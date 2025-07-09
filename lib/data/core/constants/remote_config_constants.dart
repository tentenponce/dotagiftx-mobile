import 'package:dotagiftx_mobile/domain/models/treasure_model.dart';

abstract final class RemoteConfigConstants {
  static const String keyDotagiftxImageBaseUrl = 'dotagiftx_image_base_url';
  static const String keyTreasures = 'treasures';

  static const String defaultDotagiftxImageBaseUrl =
      'https://api.dotagiftx.com/images/';

  static const String defaultMiddlemanUrl = 'https://dotagiftx.com/middleman';
  static const Iterable<TreasureModel> defaultTreasures = [
    TreasureModel(
      name: "Spring 2025 Heroes' Hoard",
      image: 'spring_2024_heroes_hoard.png',
      rarity: 'mythical',
    ),
    TreasureModel(
      name: 'The Charms of the Snake',
      image: 'the_charms_of_the_snake.png',
      rarity: 'mythical',
    ),
    TreasureModel(
      name: "Winter 2024 Heroes' Hoard",
      image: 'winter_2024_heroes_hoard.png',
      rarity: 'mythical',
    ),
    TreasureModel(
      name: "Crownfall 2024 Collector's Cache II",
      image: 'crownfall_2024_collect_s_cache_ii.png',
      rarity: 'mythical',
    ),
    TreasureModel(
      name: "Crownfall 2024 Collector's Cache",
      image: 'crownfall_2024_collect_s_cache.png',
      rarity: 'mythical',
    ),
    TreasureModel(
      name: 'Crownfall Treasure I',
      image: 'crownfall_treasure_i.png',
      rarity: 'mythical',
    ),
    TreasureModel(
      name: 'Crownfall Treasure II',
      image: 'crownfall_treasure_ii.png',
      rarity: 'mythical',
    ),
    TreasureModel(
      name: 'Crownfall Treasure III',
      image: 'crownfall_treasure_iii.png',
      rarity: 'mythical',
    ),
    TreasureModel(
      name: 'Dead Reckoning Chest',
      image: 'dead_reckoning_chest.png',
      rarity: 'mythical',
    ),
    TreasureModel(
      name: "August 2023 Collector's Cache",
      image: 'august_2023_collector_s_cache.png',
      rarity: 'mythical',
    ),
    TreasureModel(
      name: "Diretide 2022 Collector's Cache II",
      image: 'diretide_2022_collector_s_cache_ii.png',
      rarity: 'immortal',
    ),
    TreasureModel(
      name: "Diretide 2022 Collector's Cache",
      image: 'diretide_2022_collector_s_cache.png',
      rarity: 'immortal',
    ),
    TreasureModel(
      name: 'Immortal Treasure I 2022',
      image: 'immortal_treasure_i_2022.png',
      rarity: 'immortal',
    ),
    TreasureModel(
      name: 'Immortal Treasure II 2022',
      image: 'immortal_treasure_ii_2022.png',
      rarity: 'immortal',
    ),
    TreasureModel(
      name: 'The Battle Pass Collection 2022',
      image: 'the_battle_pass_collection_2022.png',
      rarity: 'immortal',
    ),
    TreasureModel(
      name: 'Ageless Heirlooms 2022',
      image: 'ageless_heirlooms_2022.png',
      rarity: 'immortal',
    ),
    TreasureModel(
      name: "Aghanim's 2021 Collector's Cache",
      image: 'aghanim_s_2021_collector_s_cache.webp',
      rarity: 'mythical',
    ),
    TreasureModel(
      name: "Aghanim's 2021 Ageless Heirlooms",
      image: 'aghanim_s_2021_ageless_heirlooms.webp',
      rarity: 'mythical',
    ),
    TreasureModel(
      name: "Aghanim's 2021 Continuum Collection",
      image: 'aghanim_s_2021_continuum_collection.webp',
      rarity: 'mythical',
    ),
    TreasureModel(
      name: "Aghanim's 2021 Immortal Treasure",
      image: 'aghanim_s_2021_immortal_treasure.webp',
      rarity: 'immortal',
    ),
    TreasureModel(
      name: "Nemestice 2021 Collector's Cache",
      image: 'nemestice_2021_collector_s_cache.webp',
      rarity: 'mythical',
    ),
    TreasureModel(
      name: 'Nemestice 2021 Immortal Treasure',
      image: 'nemestice_2021_immortal_treasure.webp',
      rarity: 'mythical',
    ),
    TreasureModel(
      name: 'Nemestice 2021 Themed Treasure',
      image: 'nemestice_2021_themed_treasure.webp',
      rarity: 'mythical',
    ),
    TreasureModel(
      name: 'Immortal Treasure I 2020',
      image: 'immortal_treasure_i_2020.webp',
      rarity: 'immortal',
    ),
    TreasureModel(
      name: 'Immortal Treasure II 2020',
      image: 'immortal_treasure_ii_2020.webp',
      rarity: 'immortal',
    ),
    TreasureModel(
      name: 'Immortal Treasure III 2020',
      image: 'immortal_treasure_iii_2020.webp',
      rarity: 'immortal',
    ),
    TreasureModel(
      name: "The International 2020 Collector's Cache",
      image: 'the_international_2020_collector_s_cache.webp',
      rarity: 'mythical',
    ),
    TreasureModel(
      name: "The International 2020 Collector's Cache II",
      image: 'the_international_2020_collector_s_cache_ii.webp',
      rarity: 'mythical',
    ),
    TreasureModel(
      name: "The International 2019 Collector's Cache",
      image: 'the_international_2019_collector_s_cache.webp',
      rarity: 'mythical',
    ),
    TreasureModel(
      name: "The International 2019 Collector's Cache II",
      image: 'the_international_2019_collector_s_cache_ii.webp',
      rarity: 'mythical',
    ),
    TreasureModel(
      name: "The International 2018 Collector's Cache",
      image: 'the_international_2018_collector_s_cache.webp',
      rarity: 'mythical',
    ),
    TreasureModel(
      name: "The International 2018 Collector's Cache II",
      image: 'the_international_2018_collector_s_cache_ii.webp',
      rarity: 'mythical',
    ),
    TreasureModel(
      name: "The International 2017 Collector's Cache",
      image: 'the_international_2017_collector_s_cache.webp',
      rarity: 'mythical',
    ),
    TreasureModel(
      name: "The International 2016 Collector's Cache",
      image: 'the_international_2016_collector_s_cache.webp',
      rarity: 'mythical',
    ),
    TreasureModel(
      name: "The International 2015 Collector's Cache",
      image: 'the_international_2015_collector_s_cache.webp',
      rarity: 'mythical',
    ),
    TreasureModel(
      name: 'Treasure of the Cryptic Beacon',
      image: 'treasure_of_the_cryptic_beacon.webp',
      rarity: 'mythical',
    ),
  ];

  static String defaultDotabuffUrl(String steamId) =>
      'https://www.dotabuff.com/players/$steamId';

  static String defaultSteamInventoryUrl(String steamId) =>
      'https://steamcommunity.com/profiles/$steamId/inventory/';
  static String defaultSteamRepUrl(String steamId) =>
      'https://steamrep.com/search?q=$steamId';

  static String defaultTransactionHistoryUrl(String steamId) =>
      'https://dotagiftx.com/profiles/$steamId/delivered';
}
