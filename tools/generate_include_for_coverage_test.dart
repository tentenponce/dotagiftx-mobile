import 'dart:io';

void main() {
  const appPackage =
      'dotagiftx_mobile'; // <- REPLACE with your app name from pubspec.yaml

  final output = File('test/include_for_coverage_test.dart');
  final buffer = StringBuffer();

  buffer.writeln(
    '// AUTO-GENERATED FILE: Ensures all files are included in test coverage.',
  );
  buffer.writeln('// Do NOT add test code here.');
  buffer.writeln('// ignore_for_file: unused_import');

  final includePatterns = ['lib/presentation', 'lib/domain/usecases'];

  for (final path in includePatterns) {
    final dir = Directory(path);
    if (!dir.existsSync()) continue;

    for (final file in dir.listSync(recursive: true)) {
      if (file is File &&
          file.path.endsWith('.dart') &&
          !file.path.endsWith('.g.dart') &&
          !file.path.endsWith('.freezed.dart') &&
          !file.path.contains('generated')) {
        final relativePath = file.path
            .replaceAll(r'\', '/')
            .replaceFirst('lib/', '');
        buffer.writeln("import 'package:$appPackage/$relativePath';");
      }
    }
  }

  buffer.writeln('\nvoid main() {}\n');

  output.createSync(recursive: true);
  output.writeAsStringSync(buffer.toString());

  print('✅ Generated test/include_for_coverage_test.dart with imports from:');
  for (final line in buffer.toString().split('\n')) {
    if (line.startsWith('import')) print('  $line');
  }
}
