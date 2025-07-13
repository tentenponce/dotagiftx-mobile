codegen: 
	dart run build_runner build --delete-conflicting-outputs

codeformat:
	flutter analyze .

codecov:
	dart run tools/generate_include_for_coverage_test.dart
	flutter test --coverage
	lcov --extract coverage/lcov.info 'lib/presentation/**/viewmodels/*' 'lib/domain/usecases/*' -o coverage/lcov.info
	genhtml coverage/lcov.info -o coverage/html
	open coverage/html/index.html