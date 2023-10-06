import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:himitsu_app/blocs/channel_bloc/channel_bloc.dart';
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
  late final ChannelBloc _channelBloc = BlocProvider.of<ChannelBloc>(context);

  final TextEditingController idController = TextEditingController();
  final List<User> addedUsers = [];

  void addUser() {
    final String input = idController.text.trim();

    if (input.isEmpty) return;

    _userBloc.add(AddUser(id: input.diacriticsInsensitive.toLowerCase().replaceAll(' ', '_')));
  }

  void createChannel() {
    if (addedUsers.isEmpty) return;

    final bool isMulti = (addedUsers.length > 1);
    final String? name = 'new Channel';

    if (isMulti) {
      // get Name from Dialog
    }

    _channelBloc.add(CreateChannel(name, multi: (addedUsers.length > 1), users: addedUsers));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(
      bloc: _userBloc,
      listener: (context, state) {
        if (state is UserSuccess || state is UserFailed) {
          idController.clear();

          if (state is UserFound) {
            addedUsers.add(state.user);
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
                onPressed: addedUsers.isEmpty ? null : createChannel,
                icon: const Icon(Icons.send_and_archive),
              )
            ],
          ),
          body: ListView.separated(
            itemCount: addedUsers.length,
            itemBuilder: (context, index) {
              return ListTile(
                  leading: Image.network(addedUsers[index].image ?? 'https://cdn-icons-png.flaticon.com/512/1946/1946429.png'),
                  title: Text(addedUsers[index].name),
                  trailing: Text((index + 1).toString()));
            },
            separatorBuilder: (BuildContext context, int index) => const Divider(),
          ),
        );
      },
    );
  }
}
