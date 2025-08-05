import 'package:dotagiftx_mobile/data/core/constants/api_constants.dart';
import 'package:dotagiftx_mobile/domain/models/market_listing_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_history_state.freezed.dart';

enum TransactionHistoryFilter { all, delivered, toReceive, completed }

@freezed
abstract class TransactionHistoryState with _$TransactionHistoryState {
  const factory TransactionHistoryState({
    @Default(false) bool isLoading,
    @Default(false) bool isLoadingMore,
    @Default([]) List<MarketListingModel> transactions,
    @Default(0) int totalTransactionsCount,
    @Default(TransactionHistoryFilter.all) TransactionHistoryFilter filter,
  }) = _TransactionHistoryState;
}
