import 'package:flutter/material.dart';
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
  //region METHODS
/*
  FutureOr<Message> _encryptMessage(message) async {
    if (widget.channel.type == 'multi') return message;

    // Encrypting the message text using derivedKey
    final encryptedMessage = await CryptUtil.encryptMessage(message.text ?? '', derivedKey.data!);
    log.f('EM!: $encryptedMessage');
    // Creating a new message with the encrypted message text
    final newMessage = message.copyWith(text: encryptedMessage);
    return newMessage;
  }
*/

  //endregion
  @override
  Widget build(BuildContext context) {
    return StreamChannel(
      channel: widget.channel,
      child: const Scaffold(
        appBar: StreamChannelHeader(showTypingIndicator: true),
        body: Column(
          children: <Widget>[
            Expanded(
              child: StreamMessageListView(),
            ),
            StreamMessageInput(),
          ],
        ),
      ),
    );
  }

//region WIDGETS
/*
  Widget _messageBuilder(      BuildContext context, MessageDetails messageDetails, List<Message> currentMessages, StreamMessageWidget defaultWidget) {
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
*/
//endregion
}
