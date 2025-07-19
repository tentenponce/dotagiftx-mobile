import 'package:dotagiftx_mobile/presentation/core/base/base_cubit.dart';
import 'package:dotagiftx_mobile/presentation/home/states/login_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class LoginCubit extends BaseCubit<LoginState> {
  LoginCubit() : super(const LoginState());

  @override
  Future<void> init() async {}
}
