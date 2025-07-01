codegen: 
	dart run build_runner build --delete-conflicting-outputs

codeformat:
	flutter analyze .

codecov:
	flutter test --coverage
	lcov --remove coverage/lcov.info 'lib/data/*' 'lib/domain/models/*' '**/core/*' 'lib/presentation/shared/*' 'lib/presentation/**/*_view.dart' 'lib/presentation/**/subviews/*' -o coverage/lcov.info
	genhtml coverage/lcov.info -o coverage/html
	open coverage/html/index.html