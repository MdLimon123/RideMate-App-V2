// import 'package:flutter/material.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;

// class SocketService {
//   static final SocketService _instance = SocketService._internal();
//   factory SocketService() => _instance;

//   SocketService._internal();

//   IO.Socket? socket;
//   bool isConnected = false;

//   // Pending listeners until socket connects
//   final List<Map<String, Function(dynamic)>> _pendingListeners = [];

//   // Connect to socket
//   void connect(String token) {
//     if (isConnected || socket != null) {
//       debugPrint('⚠️ Socket already connected');
//       return;
//     }

//     debugPrint('🟡 Trying to connect socket... , \n token :${token} ');
//     socket = IO.io(
//       'https://v2.radeefz.com',
//       IO.OptionBuilder()
//           .setTransports(['websocket'])
//           .disableAutoConnect()
//           .enableReconnection()
//           .setReconnectionAttempts(20)
//           .setReconnectionDelay(2000)
//           .setReconnectionDelayMax(8000)
//           .setAuth({"token": token})
//           .build(),
//     );

//     socket!.connect();

//     // Socket connected
//     socket!.on('connect', (_) {
//       isConnected = true;
//       debugPrint('✅ SOCKET CONNECTED');
//       debugPrint('🆔 Socket ID: ${socket!.id}');

//       // Attach any pending listeners
//       for (var listener in _pendingListeners) {
//         listener.forEach((event, handler) {
//           socket?.on(event, handler);
//         });
//       }
//       _pendingListeners.clear();
//     });

//     socket!.on('disconnect', (_) {
//       isConnected = false;
//       debugPrint('❌ Socket Disconnected');
//     });

//     socket!.on('connect_error', (err) {
//       isConnected = false;
//       debugPrint('🔥 SOCKET CONNECT ERROR: $err');
//     });
//   }

//   // Emit event
//   void emit(String event, {dynamic data, Function(dynamic response)? ack}) {
//     if (socket == null) return;

//     if (ack != null) {
//       socket!.emitWithAck(event, data, ack: ack);
//       debugPrint(
//         "============================ Emit event : $event ask : $ack ============================",
//       );
//     } else {
//       socket!.emit(event, data);
//     }
//   }

//   // Attach listener (will attach immediately if connected, or pending)
//   void on(String event, Function(dynamic) handler) {
//     if (isConnected) {
//       socket?.on(event, handler);
//     } else {
//       _pendingListeners.add({event: handler});
//     }
//   }

//   // Remove listener
//   void off(String event) {
//     socket?.off(event);
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  IO.Socket? socket;
  bool isConnected = false;

  final List<Map<String, Function(dynamic)>> _pendingListeners = [];

  /// ✅ CONNECT (ASYNC SAFE)
  Future<void> connect(String token) async {
    // Prevent duplicate connection
    //final cleanToken = token.trim();
    if (socket != null && socket!.connected) {
      debugPrint('⚠️ Socket already connected');
      return;
    }

    debugPrint('🟡 Trying to connect socket...\nToken: $token');

    final completer = Completer<void>();

    socket = IO.io(
      'https://v2.radeefz.com',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .enableForceNewConnection()
          .enableReconnection()
          .setReconnectionAttempts(20)
          .setReconnectionDelay(2000)
          .setReconnectionDelayMax(8000)

          .setAuth({"token": "$token"})

          .build(),
    );

    socket!.connect();

    socket!.onAny((event, data) {
      print("📡 EVENT RECEIVED: $event | DATA: $data");
    });

    /// ON CONNECT
    socket!.onConnect((_) {
      isConnected = true;
      debugPrint('✅ SOCKET CONNECTED');
      debugPrint('🆔 Socket ID: ${socket!.id}');

      // Attach pending listeners safely
      for (var listener in _pendingListeners) {
        listener.forEach((event, handler) {
          socket?.off(event); // prevent duplicate
          socket?.on(event, handler);
        });
      }
      _pendingListeners.clear();

      if (!completer.isCompleted) {
        completer.complete();
      }
    });

    /// ON DISCONNECT
    socket!.onDisconnect((_) {
      isConnected = false;
      debugPrint('❌ Socket Disconnected');
    });

    /// CONNECT ERROR
    socket!.onConnectError((err) {
      isConnected = false;
      debugPrint('🔥 SOCKET CONNECT ERROR: $err');

      if (!completer.isCompleted) {
        completer.completeError(err);
      }
    });

    return completer.future;
  }

  /// ✅ SAFE EMIT
  void emit(String event, {dynamic data, Function(dynamic response)? ack}) {
    if (socket == null || !socket!.connected) {
      debugPrint("⚠️ Cannot emit. Socket not connected.");
      return;
    }

    if (ack != null) {
      socket!.emitWithAck(event, data, ack: ack);
    } else {
      socket!.emit(event, data);
    }
  }

  /// ✅ SAFE LISTENER (NO DUPLICATE)
  void on(String event, Function(dynamic) handler) {
    if (socket == null) return;

    if (socket!.connected) {
      socket!.off(event); // prevent duplicate
      socket!.on(event, handler);
    } else {
      _pendingListeners.add({event: handler});
    }
  }

  /// ✅ REMOVE LISTENER
  void off(String event) {
    socket?.off(event);
  }

  /// ✅ CLEAN DISCONNECT
  void disconnect() {
    socket?.clearListeners();
    socket?.disconnect();
    socket = null;
    isConnected = false;
    debugPrint("🛑 Socket fully disconnected");
  }
}
