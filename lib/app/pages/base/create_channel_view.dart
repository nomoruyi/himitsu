import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:himitsu_app/blocs/user_bloc/user_bloc.dart';
import 'package:himitsu_app/utils/dialog_util.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class CreateChannelView extends StatefulWidget {
  const CreateChannelView({super.key});

  @override
  State<CreateChannelView> createState() => _CreateChannelViewState();
}

class _CreateChannelViewState extends State<CreateChannelView> {
  late final UserBloc _userBloc = BlocProvider.of<UserBloc>(context);
  final TextEditingController idController = TextEditingController();

  final List<User> addedUsersNotifier = [];

  void addUser() {
    final String input = idController.text.trim();

    if (input.isEmpty) return;

    _userBloc.add(AddUser(id: input.diacriticsInsensitive.toLowerCase().replaceAll(' ', '_')));
  }

  void createChannel() {
    if (addedUsersNotifier.isEmpty) return;

/*    if(addedUsersNotifier.length == 1){
      _channelBloc.add(CreateDirektChannel());
    } else{
      _channelBloc.add(CreateMultiChannel());
    }*/
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(
      bloc: _userBloc,
      listener: (context, state) {
        if (state is UserSuccess || state is UserFailed) {
          idController.clear();

          if (state is UserFound) {
            addedUsersNotifier.add(state.user);
          } else if (state is UserNotFound) {
            FlushbarUtil.error(
              context,
              title: FlutterI18n.translate(context, 'error.'),
              message: FlutterI18n.translate(context, 'error.userNotFound'),
            ).show(context);
          }
        }
      },
      buildWhen: (previous, current) => current is UserSuccess,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: TextField(
              controller: idController,
            ),
            actions: [
              IconButton(
                onPressed: addUser,
                icon: const Icon(Icons.add),
              ),
              IconButton(
                onPressed: addedUsersNotifier.isEmpty ? null : createChannel,
                icon: const Icon(Icons.send_and_archive),
              )
            ],
          ),
          body: ListView.separated(
            itemCount: addedUsersNotifier.length,
            itemBuilder: (context, index) {
              return ListTile(
                  leading: Image.network(addedUsersNotifier[index].image ?? 'https://cdn-icons-png.flaticon.com/512/1946/1946429.png'),
                  title: Text(addedUsersNotifier[index].name),
                  trailing: Text((index + 1).toString()));
            },
            separatorBuilder: (BuildContext context, int index) => const Divider(),
          ),
        );
      },
    );
  }
}
