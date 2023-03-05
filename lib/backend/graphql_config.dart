import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQLConfig {
  static final HttpLink endpoint = HttpLink('https://himitsu.hasura.app/v1/graphql');

  final AuthLink authLink = AuthLink(getToken: () => 'x-hasura-admin-secret ${dotenv.env['HASURA_TOKEN']}');

  GraphQLClient createClient() => GraphQLClient(link: endpoint, cache: GraphQLCache());

  ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      link: endpoint,
      cache: GraphQLCache(store: HiveStore()),
    ),
  );
}
