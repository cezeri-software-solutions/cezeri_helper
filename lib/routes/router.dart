import 'package:auto_route/auto_route.dart';

import 'router.gr.dart';

@AutoRouterConfig()
class CezeriHelperRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: CezeriImageViewRoute.page, path: '/image-view'),
    // ggf. weitere Modul-Routen …
  ];
}
