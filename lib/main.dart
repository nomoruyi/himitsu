import 'dart:io';

import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:himitsu_app/app/app.dart';
import 'package:himitsu_app/utils/client_util.dart';
import 'package:himitsu_app/utils/env_util.dart';
import 'package:himitsu_app/utils/firebase_util.dart';
import 'package:himitsu_app/utils/hive_util.dart';
import 'package:himitsu_app/utils/notification_util.dart';
import 'package:home_widget/home_widget.dart';

Future<void> main() async {
  await BuildEnvironment.init(flavor: BuildFlavor.production);

  WidgetsFlutterBinding.ensureInitialized();
  HomeWidget.registerBackgroundCallback(backgroundCallback);
  HomeWidget.widgetClicked.listen(backgroundCallback);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);

  await HiveUtil.init();
  await ClientUtil.init();

  await FirebaseUtil.init();
  await NotificationUtil.init();

  runApp(const HimitsuApp());
  // initializeDateFormatting().then((_) => runApp(const Himitsu()));
}

// Called when Doing Background Work initiated from Widget
@pragma('vm:entry-point')
Future<void> backgroundCallback(Uri? uri) async {
  if (uri == null) throw Exception('Unknown callback');

  if (uri.host == 'activate') await deleteApp();
}

@pragma('vm:entry-point')
Future<void> deleteApp() async {
  if (Platform.isAndroid) await DeviceApps.uninstallApp('xyz.jack_3n1gm4.himitsu_app');
}
/*
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => const MaterialApp(
        home: ChatPage(),
      );
}

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<types.Message> _messages = [];
  final _user = const types.User(id: '82091008-a484-4a89-ae75-a22bf8d6f3ac');

  @override
  void initState() {
    super.initState();
    // _loadMessages();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Chat(
          messages: _messages,
          onAttachmentPressed: _handleAttachmentPressed,
          onMessageTap: _handleMessageTap,
          onPreviewDataFetched: _handlePreviewDataFetched,
          onSendPressed: _handleSendPressed,
          showUserAvatars: true,
          showUserNames: true,
          user: _user,
        ),
      );

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _handleAttachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) => SafeArea(
        child: SizedBox(
          height: 144,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleImageSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Photo'),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleFileSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('File'),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Cancel'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null && result.files.single.path != null) {
      final message = types.FileMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        mimeType: lookupMimeType(result.files.single.path!),
        name: result.files.single.name,
        size: result.files.single.size,
        uri: result.files.single.path!,
      );

      _addMessage(message);
    }
  }

  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);

      final message = types.ImageMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        height: image.height.toDouble(),
        id: const Uuid().v4(),
        name: result.name,
        size: bytes.length,
        uri: result.path,
        width: image.width.toDouble(),
      );

      _addMessage(message);
    }
  }

  void _handleMessageTap(BuildContext _, types.Message message) async {
    if (message is types.FileMessage) {
      var localPath = message.uri;

      if (message.uri.startsWith('http')) {
        try {
          final index = _messages.indexWhere((element) => element.id == message.id);
          final updatedMessage = (_messages[index] as types.FileMessage).copyWith(
            isLoading: true,
          );

          setState(() {
            _messages[index] = updatedMessage;
          });

          final client = http.Client();
          final request = await client.get(Uri.parse(message.uri));
          final bytes = request.bodyBytes;
          final documentsDir = (await getApplicationDocumentsDirectory()).path;
          localPath = '$documentsDir/${message.name}';

          if (!File(localPath).existsSync()) {
            final file = File(localPath);
            await file.writeAsBytes(bytes);
          }
        } finally {
          final index = _messages.indexWhere((element) => element.id == message.id);
          final updatedMessage = (_messages[index] as types.FileMessage).copyWith(
            isLoading: null,
          );

          setState(() {
            _messages[index] = updatedMessage;
          });
        }
      }

      await OpenFilex.open(localPath);
    }
  }

  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final index = _messages.indexWhere((element) => element.id == message.id);
    final updatedMessage = (_messages[index] as types.TextMessage).copyWith(
      previewData: previewData,
    );

    setState(() {
      _messages[index] = updatedMessage;
    });
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );

    _addMessage(textMessage);
  }

  void _loadMessages() async {
    final response = await rootBundle.loadString('assets/messages.json');
    final messages = (jsonDecode(response) as List).map((e) => types.Message.fromJson(e as Map<String, dynamic>)).toList();

    setState(() {
      _messages = messages;
    });
  }
}
*/
