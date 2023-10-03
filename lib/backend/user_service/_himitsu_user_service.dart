import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:himitsu_app/backend/graphql_config.dart';
import 'package:himitsu_app/backend/user_service/user_service.dart';

class HimitsuUserService implements UserService {
  @override
  Future<List<User>> getUsers() async {
    QueryResult result = await GraphQLConfig.instance.client.value.query(QueryOptions(
      fetchPolicy: FetchPolicy.noCache,
      document: gql('''
      
      '''),
    ));

    return <User>[];
  }

  @override
  Future<void> logout() async {}
}
