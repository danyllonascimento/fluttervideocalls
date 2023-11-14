import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter_videocalls/src/pages/call.dart';
import 'package:permission_handler/permission_handler.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  final _channelController = TextEditingController();
  bool _validadeError = false;
  ClientRoleType? _role = ClientRoleType.clientRoleBroadcaster;

  @override
  void dispose() {
    _channelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Agora"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              Image.network("https://tinyurl.com/2p889y4k"),
              const SizedBox(
                height: 40,
              ),
              TextField(
                controller: _channelController,
                decoration: InputDecoration(
                    errorText:
                        _validadeError ? "Channel name is mandatory" : null,
                    hintText: 'Channel Name',
                    border: const UnderlineInputBorder(
                        borderSide: BorderSide(width: 1))),
              ),
              RadioListTile(
                title: const Text("BroadCaster"),
                onChanged: (ClientRoleType? value) {
                  setState(() {
                    _role = value;
                  });
                },
                value: ClientRoleType.clientRoleBroadcaster,
                groupValue: _role,
              ),
              RadioListTile(
                title: const Text("Audience"),
                onChanged: (ClientRoleType? value) {
                  setState(() {
                    _role = value;
                  });
                },
                value: ClientRoleType.clientRoleAudience,
                groupValue: _role,
              ),
              ElevatedButton(
                onPressed: onJoin,
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 40)),
                child: const Text('Join'),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> onJoin() async {
    setState(() {
      _channelController.text.isEmpty
          ? _validadeError = true
          : _validadeError = false;
    });

    if (_channelController.text.isNotEmpty) {
      await _handlerCameraAndMic(Permission.camera);
      await _handlerCameraAndMic(Permission.microphone);
      await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CallPage(
              channelName: _channelController.text,
              role: _role,
            ),
          ));
    }
  }

  Future<void> _handlerCameraAndMic(Permission permission) async {
    final status = permission.request();
  }
}
