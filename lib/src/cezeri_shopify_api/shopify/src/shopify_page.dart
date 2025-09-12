import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../../cezeri_shopify_api.dart';
import '../../graphql_operations/storefront/queries/get_all_pages.dart';
import '../../graphql_operations/storefront/queries/get_page_by_handle.dart';
import '../../mixins/src/shopify_error.dart';

/// ShopifyPage class handles all Page related things.
class ShopifyPage with ShopifyError {
  ShopifyPage._();

  GraphQLClient? get _graphQLClient => ShopifyConfig.graphQLClient;

  /// Singleton instance of [ShopifyPage]
  static final ShopifyPage instance = ShopifyPage._();

  /// Returns a List of [Page].
  ///
  /// Returns All [Page] of the Shop.
  Future<List<Page>?> getAllPages({SortKeyPage sortKeyPage = SortKeyPage.ID, bool reversePages = false, String? pagesQuery}) async {
    final WatchQueryOptions options = WatchQueryOptions(
      document: gql(getAllPagesQuery),
      variables: {'reversePages': reversePages, 'sortKey': sortKeyPage.parseToString(), 'pagesQuery': pagesQuery},
      fetchPolicy: ShopifyConfig.fetchPolicy,
    );
    final QueryResult result = await _graphQLClient!.query(options);
    checkForError(result);
    return (Pages.fromGraphJson((result.data ?? const {})["pages"] ?? const {})).pageList;
  }

  /// Returns a [Page].
  ///
  /// Returns the [Page] that is associated to the [handle].
  Future<Page> getPageByHandle(String handle) async {
    final QueryOptions options = WatchQueryOptions(
      document: gql(getPageByHandleQuery),
      variables: {'handle': handle},
      fetchPolicy: ShopifyConfig.fetchPolicy,
    );
    final QueryResult result = await _graphQLClient!.query(options);
    checkForError(result);
    var response = result.data!['pageByHandle'];
    return Page.fromJson(response);
  }
}
