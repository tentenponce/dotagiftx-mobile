import 'package:dotagiftx_mobile/domain/models/user_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_state.freezed.dart';

@freezed
abstract class ProfileState with _$ProfileState {
  const factory ProfileState({
    @Default(false) bool loadingLogin,
    @Default(false) bool loadingLogout,
    @Default(null) UserModel? user,
  }) = _ProfileState;
}
