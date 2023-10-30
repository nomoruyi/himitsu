import 'package:flutter/material.dart';
import 'package:himitsu_app/app/widgets/loading_widget.dart';
import 'package:himitsu_app/utils/client_util.dart';
import 'package:himitsu_app/utils/crypt_util.dart';
import 'package:himitsu_app/utils/env_util.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class ChannelPage extends StatefulWidget {
  const ChannelPage({
    super.key,
    required this.channel,
  });

  final Channel channel;

  @override
  State<ChannelPage> createState() => _ChannelPageState();
}

class _ChannelPageState extends State<ChannelPage> {
  String? receiverJwk;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.channel.queryMembers(filter: Filter.notEqual('id', ClientUtil.user.id)),
      builder: (ctx, snapshot) {
        if (snapshot.hasData) {
          // JSONCryptKeyPair keyPair = authData.keyPair!;

          if (receiverJwk == null) {
            final receiver = snapshot.data!.members[0];
            receiverJwk = receiver.user!.extraData['publicKey'] as String?;
            log.e('$receiverJwk MOIN');
            log.e('${ClientUtil.keyPair!.publicKey} USER PK');
          }

          return StreamChannel(
            channel: widget.channel,
            child: Scaffold(
              appBar: const StreamChannelHeader(showTypingIndicator: true),
              body: FutureBuilder(
                  // Generating derivedKey using user's privateKey and receiver's publicKey
                  future: CryptUtil.deriveKey(ClientUtil.keyPair!.privateKey, receiverJwk!),
                  builder: (ctx, derivedKey) {
                    if (derivedKey.hasError) return Text('Error: ${derivedKey.error}');
                    if (!derivedKey.hasData) return const Placeholder(color: Colors.red);

                    return Column(
                      children: <Widget>[
                        Expanded(
                          child: StreamMessageListView(
                            messageBuilder: (_, __, ___, ____) => _messageBuilder(_, __, ___, ____, derivedKey.data!),
                          ),
                        ),
                        StreamMessageInput(
                          preMessageSending: (message) async {
                            if (widget.channel.type == 'multi') return message;

                            // Encrypting the message text using derivedKey
                            final encryptedMessage = await CryptUtil.encryptMessage(message.text ?? '', derivedKey.data!);
                            log.f('EM!: $encryptedMessage');
                            // Creating a new message with the encrypted message text
                            final newMessage = message.copyWith(text: encryptedMessage);
                            return newMessage;
                          },
                        ),
                      ],
                    );
                  }),
            ),
          );
        } else if (snapshot.hasError) {
          return const Placeholder();
        }
        return const LoadingWidget();
      },
    );
  }

  //region WIDGETS
  Widget _messageBuilder(
      BuildContext context, MessageDetails messageDetails, List<Message> currentMessages, StreamMessageWidget defaultWidget, List<int> derivedKey) {
    if (widget.channel.type == 'multi') return defaultWidget;
    // Retrieving the message from details
    final message = messageDetails.message;

    // Decrypting the message text using the derivedKey
    final decryptedMessageFuture = CryptUtil.decryptMessage(message.text!, derivedKey);
    return FutureBuilder<String>(
      future: decryptedMessageFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
        if (!snapshot.hasData) return Container();

        // Updating the original message with the decrypted text
        final decryptedMessage = message.copyWith(text: snapshot.data);

        log.f('DM!: ${snapshot.data}');

        // Returning defaultWidget with updated message
        return defaultWidget.copyWith(
          message: decryptedMessage,
        );
      },
    );
  }
//endregion
}
