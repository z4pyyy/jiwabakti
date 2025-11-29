import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:jiwa_bakti/models/user.dart';
import 'package:jiwa_bakti/services/api_service.dart';
import 'package:jiwa_bakti/stores/ads_store.dart';
import 'package:jiwa_bakti/stores/article_store.dart';
import 'package:jiwa_bakti/utils/search_cache.dart';

import 'package:jiwa_bakti/services/flowlink_service.dart';

void initializeGetIt() {
  GetIt.I.registerLazySingleton<SearchCache>(() => SearchCache());

  GetIt.I.registerSingleton<Dio>(
    Dio(
      BaseOptions(baseUrl: "https://utusansarawak.com.my/wp-json/wp/v2"),
    ),
  );

  GetIt.I.registerSingleton<ApiService>(
    ApiService(
      client: GetIt.I<Dio>(),
    ),
  );

  GetIt.I.registerSingleton<User>(User(
    textSizeScale: 1.0,
  ));

  GetIt.I.registerSingleton<ArticleStore>(
      ArticleStore(
        client: GetIt.I<Dio>(),
      )
  );

  GetIt.I.registerSingleton<AdsStore>(AdsStore());

  GetIt.I.registerLazySingleton<FlowLinkService>(() => FlowLinkService());

}
