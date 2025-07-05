import 'package:dotagiftx_mobile/domain/models/offer_model.dart';
import 'package:dotagiftx_mobile/presentation/core/base/base_cubit.dart';
import 'package:injectable/injectable.dart';

@injectable
class DotaItemDetailCubit extends BaseCubit<OffersState> {
  static const int pageSize = 2;

  static const int maxPages = 1; // Simulate finite data
  DotaItemDetailCubit() : super(const OffersState());

  @override
  Future<void> init() async {}

  Future<void> loadMoreOffers() async {
    if (state.isLoadingMore || !state.hasMoreData || state.isLoading) return;

    emit(state.copyWith(isLoadingMore: true));

    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 300));

      final startIndex = state.currentPage * pageSize;
      final newOffers = _generateMockOffers(startIndex, pageSize);

      final allOffers = [...state.offers, ...newOffers];
      final hasMore = state.currentPage < maxPages - 1;

      emit(
        state.copyWith(
          offers: allOffers,
          isLoadingMore: false,
          currentPage: state.currentPage + 1,
          hasMoreData: hasMore,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoadingMore: false));
    }
  }

  Future<void> loadOffers() async {
    if (state.isLoading) return;

    emit(state.copyWith(isLoading: true, error: null));

    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));

      final newOffers = _generateMockOffers(0, pageSize);

      emit(
        state.copyWith(
          offers: newOffers,
          isLoading: false,
          currentPage: 1,
          hasMoreData: true,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: 'Failed to load offers'));
    }
  }

  Future<void> refresh() async {
    emit(const OffersState());
    await loadOffers();
  }

  List<OfferModel> _generateMockOffers(int startIndex, int count) {
    final users = [
      {'name': 'Mora', 'avatar': '👑', 'badge': 'PARTNER', 'verified': true},
      {
        'name': 'xiaoqianbi000',
        'avatar': '🛡️',
        'badge': 'SUPPORTER',
        'verified': true,
      },
      {'name': '2099', 'avatar': '⚔️', 'badge': '', 'verified': false},
      {'name': 'SteamUser123', 'avatar': '🎮', 'badge': '', 'verified': false},
      {
        'name': 'DotaTrader',
        'avatar': '💎',
        'badge': 'PARTNER',
        'verified': true,
      },
      {'name': 'MarketKing', 'avatar': '👑', 'badge': '', 'verified': false},
      {
        'name': 'ItemHunter',
        'avatar': '🏹',
        'badge': 'SUPPORTER',
        'verified': true,
      },
      {
        'name': 'TreasureFinder',
        'avatar': '💰',
        'badge': '',
        'verified': false,
      },
    ];

    return List.generate(count, (index) {
      final globalIndex = startIndex + index;
      final user = users[globalIndex % users.length];
      const basePrice = 60.0;
      final priceVariation =
          (globalIndex * 3.7) % 20 - 10; // -10 to +10 variation

      return OfferModel(
        id: 'offer_${globalIndex + 1}',
        userName: user['name']! as String,
        userAvatar: user['avatar']! as String,
        price: basePrice + priceVariation,
        postedDate: DateTime.now().subtract(
          Duration(
            minutes: (globalIndex * 17) % 1440, // Random times within last day
          ),
        ),
        quantity: 1,
        userBadge: user['badge']! as String,
        isVerified: user['verified']! as bool,
      );
    });
  }
}

class OffersState {
  final List<OfferModel> offers;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMoreData;
  final int currentPage;
  final String? error;

  const OffersState({
    this.offers = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMoreData = true,
    this.currentPage = 0,
    this.error,
  });

  OffersState copyWith({
    List<OfferModel>? offers,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMoreData,
    int? currentPage,
    String? error,
  }) {
    return OffersState(
      offers: offers ?? this.offers,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMoreData: hasMoreData ?? this.hasMoreData,
      currentPage: currentPage ?? this.currentPage,
      error: error,
    );
  }
}
