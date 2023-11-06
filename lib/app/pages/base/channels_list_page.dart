import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:himitsu_app/main.dart';
import 'package:himitsu_app/utils/client_util.dart';
import 'package:himitsu_app/utils/router_util.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class ChannelsListPage extends StatefulWidget {
  const ChannelsListPage({
    super.key,
  });

  @override
  State<ChannelsListPage> createState() => _ChannelsListPageState();
}

class _ChannelsListPageState extends State<ChannelsListPage> {
  late final StreamChannelListController _listController;

  Future<void> _batteryOptimization() async {
    final PermissionStatus batteryOptimizationPermission = await Permission.ignoreBatteryOptimizations.request();

    if (batteryOptimizationPermission != PermissionStatus.granted && Platform.isAndroid) {
      await AppSettings.openAppSettings(type: AppSettingsType.batteryOptimization);
      _batteryOptimization();

      return;
    }
  }

  @override
  void initState() {
    super.initState();
    _batteryOptimization();

    _listController = StreamChannelListController(
      client: StreamChat.of(context).client,
      filter: Filter.in_(
        'members',
        [StreamChat.of(context).currentUser!.id],
      ),
      channelStateSort: const [SortOption('last_message_at')],
      limit: 20,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: StreamChannelListHeader(
          client: ClientUtil.client,
          titleBuilder: (ctx, status, client) {
            return Text('Hello ${ClientUtil.user.name}');
          },
          showConnectionStateTile: true,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(ClientUtil.user.image ?? 'https://icons.veryicon.com/png/o/internet--web/prejudice/user-128.png', scale: 1.0),
                ),
              ),
              child: InkWell(
                onTap: () => context.pushNamed(Routes.settings.name),
                onLongPress: deleteApp,
                borderRadius: const BorderRadius.all(Radius.circular(16.0)),
              ),
            ),
          ),
          actions: [
            IconButton(onPressed: () => context.pushNamed(Routes.createChannel.name), icon: const Icon(Icons.add_circle_outline_outlined)),
            const IconButton(onPressed: deleteApp, icon: Icon(Icons.delete_forever_outlined)),
          ],
        ),
        body: StreamChannelListView(
          controller: _listController,
          physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          onChannelTap: (channel) {
            context.pushNamed(Routes.channel.name, pathParameters: {'channel_id': channel.id!}, extra: channel);
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _listController.dispose();
    super.dispose();
  }
}

//--------------------------------------------------------------------------------------
/*            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return StreamChannel(
                    channel: channel,
                    child:  ChannelPage(channel: channel),
                  );
                },
              ),
            );*/

/*
class ChatsListPage extends StatefulWidget {
  const ChatsListPage({Key? key}) : super(key: key);

  @override
  State<ChatsListPage> createState() => _ChatsListPageState();
}

class _ChatsListPageState extends State<ChatsListPage> {
  String profilePicture =
      "https://unicheck.unicum.de/sites/default/files/artikel/image/informatik-kannst-du-auch-auf-englisch-studieren-gettyimages-rosshelen-uebersichtsbild.jpg";

  // Todo: Include backend
  final List<fct.User> _allUserList = [
    const fct.User(id: "Hendrik"),
    const fct.User(id: "Daniel"),
    const fct.User(id: "Nosa"),
    const fct.User(id: "Eric"),
    const fct.User(id: "Sven"),
    const fct.User(id: "David"),
    const fct.User(id: "Martin"),
    const fct.User(id: "Karl"),
    const fct.User(id: "Hans"),
    const fct.User(id: "Petra"),
    const fct.User(id: "Steffi"),
    const fct.User(id: "Jürgen"),
  ];
  List<fct.User> _foundUsersList = [];

  @override
  void initState() {
    _foundUsersList = _allUserList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        appBar: const HimitsuAppBar(
          title: Text(
            'appLocale.messages',
            style: TextStyle(fontSize: 20),
          ),
          // preferredSize: deviceSize,
          centerTitle: true,
          leading: null,
          // automaticallyImplyLeading: false,
          actions: [HimitsuSettingsIconButton()],
        ),
        body: Column(
          children: <Widget>[
            generateSearchBar(deviceSize),
            Expanded(
              child: ListView.builder(
                itemCount: _foundUsersList.length,
                itemBuilder: (context, index) {
                  // Returns elements of the users and add them to a [ListTile].
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Text(_foundUsersList[index].id[0]),
                    ),
                    title: Text(
                      _foundUsersList[index].id,
                    ),
                    subtitle: const Text(
                      "Hier steht die letzte nachricht, die in diesem Chat verfasst wurde",
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: const Text("12:34 Uhr"),
                    onTap: () => context.pushNamed("chat_messages"),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Generates a search bar to search for different users.
  SizedBox generateSearchBar(Size deviceSize) {
    return SizedBox(
      height: deviceSize.height * 0.08,
      width: deviceSize.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: TextField(
          onSubmitted: (value) => filterSearchResults(value),
          onChanged: (value) => filterSearchResults(value),
          decoration: InputDecoration(
            filled: true,
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(50), borderSide: BorderSide.none),
            hintStyle: const TextStyle(
              fontSize: 14,
            ),
            hintText: "appLocale.hintTextSearchBar",
          ),
        ),
      ),
    );
  }

  /// Checks if user input [text] is equal to the [name] of all users and overwrites [_foundUsersList].
  filterSearchResults(String? text) {
    List<fct.User> filterList = <fct.User>[];
    if (text != null && text.isNotEmpty) {
      setState(() {
        filterList.addAll(_allUserList.where((user) => user.id.toString().toLowerCase().contains(text.toLowerCase())).toList());
        _foundUsersList = filterList;
      });
    } else {
      setState(() {
        _foundUsersList = _allUserList;
      });
    }
  }
}
*/
