import 'package:dotagiftx_mobile/data/api/dotagiftx_api.dart';
import 'package:dotagiftx_mobile/presentation/core/base/base_cubit.dart';
import 'package:dotagiftx_mobile/presentation/home/states/home_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class HomeCubit extends BaseCubit<HomeState> {
  final DotagiftxApi _dotagiftxApi;

  HomeCubit(this._dotagiftxApi) : super(const HomeState());

  @override
  Future<void> init() async {
    final catalogResponse = await _dotagiftxApi.getRecentBids();
    emit(state.copyWith(newBuyOrderItems: catalogResponse.data));
  }
}
