import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:himitsu_app/app/widgets/app_bar_widget.dart';

class ChatsView extends StatefulWidget {
  const ChatsView({Key? key}) : super(key: key);

  @override
  State<ChatsView> createState() => _ChatsViewState();
}

class _ChatsViewState extends State<ChatsView> {
  String profilePicture =
      "https://unicheck.unicum.de/sites/default/files/artikel/image/informatik-kannst-du-auch-auf-englisch-studieren-gettyimages-rosshelen-uebersichtsbild.jpg";

  // Todo: Include backend
  final List<User> _allUserList = [
    const User(id: "Hendrik"),
    const User(id: "Daniel"),
    const User(id: "Nosa"),
    const User(id: "Eric"),
    const User(id: "Sven"),
    const User(id: "David"),
    const User(id: "Martin"),
    const User(id: "Karl"),
    const User(id: "Hans"),
    const User(id: "Petra"),
    const User(id: "Steffi"),
    const User(id: "Jürgen"),
  ];
  List<User> _foundUsersList = [];

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
          actions: [OekoSettingsIconButton()],
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
                    onTap: () => Navigator.of(context).pushNamed("chat_messages"),
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
    List<User> filterList = <User>[];
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
