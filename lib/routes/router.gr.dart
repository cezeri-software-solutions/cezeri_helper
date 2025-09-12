// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i2;
import 'package:cezeri_helper/src/cezeri_helper/widgets/cezeri_image_view_page.dart'
    as _i1;
import 'package:flutter/material.dart' as _i3;

/// generated route for
/// [_i1.CezeriImageViewPage]
class CezeriImageViewRoute extends _i2.PageRouteInfo<CezeriImageViewRouteArgs> {
  CezeriImageViewRoute({
    required List<String> urls,
    int initialIndex = 0,
    _i3.Key? key,
    List<_i2.PageRouteInfo>? children,
  }) : super(
         CezeriImageViewRoute.name,
         args: CezeriImageViewRouteArgs(
           urls: urls,
           initialIndex: initialIndex,
           key: key,
         ),
         initialChildren: children,
       );

  static const String name = 'CezeriImageViewRoute';

  static _i2.PageInfo page = _i2.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CezeriImageViewRouteArgs>();
      return _i1.CezeriImageViewPage(
        urls: args.urls,
        initialIndex: args.initialIndex,
        key: args.key,
      );
    },
  );
}

class CezeriImageViewRouteArgs {
  const CezeriImageViewRouteArgs({
    required this.urls,
    this.initialIndex = 0,
    this.key,
  });

  final List<String> urls;

  final int initialIndex;

  final _i3.Key? key;

  @override
  String toString() {
    return 'CezeriImageViewRouteArgs{urls: $urls, initialIndex: $initialIndex, key: $key}';
  }
}
