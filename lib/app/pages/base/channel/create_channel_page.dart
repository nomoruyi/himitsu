import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:go_router/go_router.dart';
import 'package:himitsu_app/app/widgets/widgets.export.dart';
import 'package:himitsu_app/blocs/channel_bloc/channel_bloc.dart';
import 'package:himitsu_app/blocs/user_bloc/user_bloc.dart';
import 'package:himitsu_app/utils/dialog_util.dart';
import 'package:himitsu_app/utils/format_util.dart';
import 'package:himitsu_app/utils/settings_util.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class CreateChannelView extends StatefulWidget {
  const CreateChannelView({super.key});

  @override
  State<CreateChannelView> createState() => _CreateChannelViewState();
}

class _CreateChannelViewState extends State<CreateChannelView> {
  late final UserBloc _userBloc = BlocProvider.of<UserBloc>(context);
  late final HChannelBloc _channelBloc = BlocProvider.of<HChannelBloc>(context);

  final TextEditingController idController = TextEditingController();
  final TextEditingController channelNameController = TextEditingController();

  final List<User> addedUsers = [];
  bool nameAsked = false;

  void addUser() {
    final String input = idController.text.trim();

    if (input.isEmpty) return;

    _userBloc.add(AddUser(id: input.diacriticsInsensitive.toLowerCase().replaceAll(' ', '_')));
  }

  Future<void> createChannel() async {
    if (addedUsers.isEmpty) return;

    bool multi = (addedUsers.length > 1);

    if (multi) {
      if (await getChannelName()) {
        _channelBloc.add(CreateChannel(channelNameController.text, 'multi', users: addedUsers));
      }
    } else {
      _channelBloc.add(CreateChannel(null, 'single', users: addedUsers));
    }
  }

  Future<bool> getChannelName() async {
    bool nameSet = false;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: HimitsuPopUp(
            title: Text(
              FlutterI18n.translate(context, 'popup.title.channelName'),
              style: TextStyle(fontSize: TextSize.large, fontWeight: FontWeight.w500),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                HimitsuTextField(
                  controller: channelNameController,
                  hintText: FlutterI18n.translate(context, 'popup.content.channelName'),
                  maxCharacters: 32,
                ),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    nameSet = false;
                    Navigator.of(context).pop();
                  },
                  child: Text(FlutterI18n.translate(context, 'button.cancel'), style: TextStyle(fontSize: TextSize.medium))),
              TextButton(
                  onPressed: () {
                    if (isStringNotEmpty(channelNameController.text)) {
                      nameSet = true;
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text(FlutterI18n.translate(context, 'button.save'), style: TextStyle(fontSize: TextSize.medium)))
            ],
          ),
        );
      },
    );

    return nameSet;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HChannelBloc, HChannelState>(
      listener: (context, state) {
        if (state is ChannelCreated) context.pop();
      },
      child: BlocConsumer<UserBloc, UserState>(
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
              title: Text(channelNameController.text, style: const TextStyle(fontWeight: FontWeight.bold)),
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
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: HimitsuTextField(
                    controller: idController,
                    hintText: 'Enter User ID',
                    prefixIcon: const Icon(Icons.drive_file_rename_outline_outlined),
                    maxCharacters: 32,
                  ),
                ),
                ListView.separated(
                  itemCount: addedUsers.length,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return ListTile(
                        leading: Image.network(addedUsers[index].image ?? 'https://cdn-icons-png.flaticon.com/512/1946/1946429.png'),
                        title: Text(addedUsers[index].name),
                        trailing: Text((index + 1).toString()));
                  },
                  separatorBuilder: (BuildContext context, int index) => const Divider(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
