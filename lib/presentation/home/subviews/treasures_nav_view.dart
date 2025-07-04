import 'package:dotagiftx_mobile/domain/models/treasure_model.dart';
import 'package:dotagiftx_mobile/presentation/core/resources/app_colors.dart';
import 'package:dotagiftx_mobile/presentation/home/states/home_state.dart';
import 'package:dotagiftx_mobile/presentation/home/subviews/treasure_card_view.dart';
import 'package:dotagiftx_mobile/presentation/home/viewmodels/home_cubit.dart';
import 'package:dotagiftx_mobile/presentation/shared/localization/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TreasuresNavView extends StatefulWidget {
  const TreasuresNavView({super.key});

  @override
  State<TreasuresNavView> createState() => _TreasuresNavViewState();
}

class _TreasuresNavViewState extends State<TreasuresNavView> {
  static final List<TreasureItem> _treasures = [
    const TreasureItem(
      name: "Spring 2025 Heroes' Hoard",
      image: 'spring_2024_heroes_hoard.png',
      rarity: 'mythical',
    ),
    const TreasureItem(
      name: 'The Charms of the Snake',
      image: 'the_charms_of_the_snake.png',
      rarity: 'mythical',
    ),
    const TreasureItem(
      name: "Winter 2024 Heroes' Hoard",
      image: 'winter_2024_heroes_hoard.png',
      rarity: 'mythical',
    ),
    const TreasureItem(
      name: "Crownfall 2024 Collector's Cache II",
      image: 'crownfall_2024_collect_s_cache_ii.png',
      rarity: 'mythical',
    ),
    const TreasureItem(
      name: "Crownfall 2024 Collector's Cache",
      image: 'crownfall_2024_collect_s_cache.png',
      rarity: 'mythical',
    ),
    const TreasureItem(
      name: 'Crownfall Treasure I',
      image: 'crownfall_treasure_i.png',
      rarity: 'mythical',
    ),
    const TreasureItem(
      name: 'Crownfall Treasure II',
      image: 'crownfall_treasure_ii.png',
      rarity: 'mythical',
    ),
    const TreasureItem(
      name: 'Crownfall Treasure III',
      image: 'crownfall_treasure_iii.png',
      rarity: 'mythical',
    ),
    const TreasureItem(
      name: 'Dead Reckoning Chest',
      image: 'dead_reckoning_chest.png',
      rarity: 'mythical',
    ),
    const TreasureItem(
      name: "August 2023 Collector's Cache",
      image: 'august_2023_collector_s_cache.png',
      rarity: 'mythical',
    ),
    const TreasureItem(
      name: "Diretide 2022 Collector's Cache II",
      image: 'diretide_2022_collector_s_cache_ii.png',
      rarity: 'immortal',
    ),
    const TreasureItem(
      name: "Diretide 2022 Collector's Cache",
      image: 'diretide_2022_collector_s_cache.png',
      rarity: 'immortal',
    ),
    const TreasureItem(
      name: 'Immortal Treasure I 2022',
      image: 'immortal_treasure_i_2022.png',
      rarity: 'immortal',
    ),
    const TreasureItem(
      name: 'Immortal Treasure II 2022',
      image: 'immortal_treasure_ii_2022.png',
      rarity: 'immortal',
    ),
    const TreasureItem(
      name: 'The Battle Pass Collection 2022',
      image: 'the_battle_pass_collection_2022.png',
      rarity: 'immortal',
    ),
    const TreasureItem(
      name: 'Ageless Heirlooms 2022',
      image: 'ageless_heirlooms_2022.png',
      rarity: 'immortal',
    ),
    const TreasureItem(
      name: "Aghanim's 2021 Collector's Cache",
      image: 'aghanim_s_2021_collector_s_cache.webp',
      rarity: 'mythical',
    ),
    const TreasureItem(
      name: "Aghanim's 2021 Ageless Heirlooms",
      image: 'aghanim_s_2021_ageless_heirlooms.webp',
      rarity: 'mythical',
    ),
    const TreasureItem(
      name: "Aghanim's 2021 Continuum Collection",
      image: 'aghanim_s_2021_continuum_collection.webp',
      rarity: 'mythical',
    ),
    const TreasureItem(
      name: "Aghanim's 2021 Immortal Treasure",
      image: 'aghanim_s_2021_immortal_treasure.webp',
      rarity: 'immortal',
    ),
    const TreasureItem(
      name: "Nemestice 2021 Collector's Cache",
      image: 'nemestice_2021_collector_s_cache.webp',
      rarity: 'mythical',
    ),
    const TreasureItem(
      name: 'Nemestice 2021 Immortal Treasure',
      image: 'nemestice_2021_immortal_treasure.webp',
      rarity: 'mythical',
    ),
    const TreasureItem(
      name: 'Nemestice 2021 Themed Treasure',
      image: 'nemestice_2021_themed_treasure.webp',
      rarity: 'mythical',
    ),
    const TreasureItem(
      name: 'Immortal Treasure I 2020',
      image: 'immortal_treasure_i_2020.webp',
      rarity: 'immortal',
    ),
    const TreasureItem(
      name: 'Immortal Treasure II 2020',
      image: 'immortal_treasure_ii_2020.webp',
      rarity: 'immortal',
    ),
    const TreasureItem(
      name: 'Immortal Treasure III 2020',
      image: 'immortal_treasure_iii_2020.webp',
      rarity: 'immortal',
    ),
    const TreasureItem(
      name: "The International 2020 Collector's Cache",
      image: 'the_international_2020_collector_s_cache.webp',
      rarity: 'mythical',
    ),
    const TreasureItem(
      name: "The International 2020 Collector's Cache II",
      image: 'the_international_2020_collector_s_cache_ii.webp',
      rarity: 'mythical',
    ),
    const TreasureItem(
      name: "The International 2019 Collector's Cache",
      image: 'the_international_2019_collector_s_cache.webp',
      rarity: 'mythical',
    ),
    const TreasureItem(
      name: "The International 2019 Collector's Cache II",
      image: 'the_international_2019_collector_s_cache_ii.webp',
      rarity: 'mythical',
    ),
    const TreasureItem(
      name: "The International 2018 Collector's Cache",
      image: 'the_international_2018_collector_s_cache.webp',
      rarity: 'mythical',
    ),
    const TreasureItem(
      name: "The International 2018 Collector's Cache II",
      image: 'the_international_2018_collector_s_cache_ii.webp',
      rarity: 'mythical',
    ),
    const TreasureItem(
      name: "The International 2017 Collector's Cache",
      image: 'the_international_2017_collector_s_cache.webp',
      rarity: 'mythical',
    ),
    const TreasureItem(
      name: "The International 2016 Collector's Cache",
      image: 'the_international_2016_collector_s_cache.webp',
      rarity: 'mythical',
    ),
    const TreasureItem(
      name: "The International 2015 Collector's Cache",
      image: 'the_international_2015_collector_s_cache.webp',
      rarity: 'mythical',
    ),
    const TreasureItem(
      name: 'Treasure of the Cryptic Beacon',
      image: 'treasure_of_the_cryptic_beacon.webp',
      rarity: 'mythical',
    ),
  ];

  late final ScrollController _scrollController;
  bool _isScrolled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        title: Text(I18n.of(context).homeTreasures),
        backgroundColor: AppColors.black,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          return Stack(
            children: [
              GridView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.8,
                ),
                itemCount: _treasures.length,
                itemBuilder: (context, index) {
                  final treasure = _treasures[index];
                  return TreasureCard(treasure: treasure);
                },
              ),
              // Top shadow when scrolled
              if (_isScrolled)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 20,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.black.withValues(alpha: 0.8),
                          AppColors.black.withValues(alpha: 0.4),
                          AppColors.black.withValues(alpha: 0.0),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    FocusScope.of(context).unfocus();

    final isScrolled =
        _scrollController.hasClients && _scrollController.offset > 0;
    if (isScrolled != _isScrolled) {
      setState(() {
        _isScrolled = isScrolled;
      });
    }
  }
}
