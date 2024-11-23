import 'dart:async';
import 'package:web_socket_channel/io.dart';

const httpPrefix = 'https://';
const wsPrefix = 'wss://';

class WebSocketService {
  bool isManuallyClosed = false;
  late IOWebSocketChannel channel;
  late Completer<void> completer;

  Future<void> connect(String url, void Function(dynamic) onData,
      void Function(dynamic)? onError, void Function()? onDone) async {
    isManuallyClosed = false;
    channel = IOWebSocketChannel.connect(Uri.parse(url));
    await channel.ready;
    completer = Completer<void>();
    channel.stream.listen(
      onData,
      onError: onError,
      onDone: onDone,
    );
    await completer.future;
  }

  Future<void> close() async {
    isManuallyClosed = true;
    await channel.sink.close();
    if (!completer.isCompleted) {
      completer.complete();
    }
  }
}
