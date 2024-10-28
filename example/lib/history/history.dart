// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:convert';
import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as pp;

void main(List<String> args) async => runApp(const App());

class App extends StatelessWidget {
  static const title = 'Example: History';

  const App({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: title,
        home: ChatPage(),
        debugShowCheckedModeBanner: false,
      );
}

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // final _provider = GeminiProvider(
  //   generativeModel: GenerativeModel(
  //     model: 'gemini-1.5-flash',
  //     apiKey: geminiApiKey,
  //   ),
  // );
  final _controller = LlmChatViewController(provider: EchoProvider());

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onHistoryChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onHistoryChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text(App.title),
          actions: [
            IconButton(
              onPressed: _clearHistory,
              icon: const Icon(Icons.history),
            ),
          ],
        ),
        body: LlmChatView(controller: _controller),
      );

  void _clearHistory() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear history?'),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Clear'),
          ),
          OutlinedButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );

    if (ok == true) _controller.clearHistory();
  }

  void _onHistoryChanged() async {
    io.File messageFile(io.Directory dir, int messageNo) {
      final fileName = path.join(
        dir.path,
        'message-${messageNo.toString().padLeft(3, '0')}.json',
      );
      debugPrint('Message: $fileName');
      return io.File(fileName);
    }

    // get the latest history
    final history = _controller.history.toList();

    // get a spot to store the history on disk
    final temp = await pp.getTemporaryDirectory();
    final dir = io.Directory(path.join(temp.path, 'chat-history'));
    await dir.create();

    // write the new messages
    for (var i = 0; i != history.length; ++i) {
      // skip if the file already exists
      final file = messageFile(dir, i);
      if (file.existsSync()) continue;

      // write the new message to disk
      final map = LlmChatViewController.mapFrom(history[i]);
      final json = JsonEncoder.withIndent('  ').convert(map);
      await file.writeAsString(json);
    }

    // delete any old messages
    var i = history.length;
    while (true) {
      final file = messageFile(dir, i);
      if (!file.existsSync()) break;
      await file.delete();
      ++i;
    }
  }
}
