import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/data_controller.dart';
import 'package:flutter_extension/data/api/api_client.dart';
import 'package:flutter_extension/data/api/socket_manager.dart';
import 'package:flutter_extension/data/model/message_model.dart';
import 'package:flutter_extension/data/model/terms_model.dart';
import 'package:flutter_extension/views/screen/driver/chat/driver_inbox_screen.dart'
    hide Message;
import 'package:get/get.dart';

class DriverChatController extends GetxController {
  var chatId = "".obs;

  var isLoading = false.obs;


  RxList<Message> messages = <Message>[].obs;


  final SocketService _socketService = SocketService();

  final _dataController = Get.put(DataController());

  @override
  void onInit() {
    super.onInit();
    listenForMessages();
  }

  Future<void> createAdminChatRoom() async {
    final response = await ApiClient.postData("/inbox/new-chat-to-admin", {});
    if (response.statusCode == 200 || response.statusCode == 201) {
      chatId.value = response.body['id'];
      debugPrint("Chat ID=========>: ${chatId.value}");
      Get.to(() => DriverInboxScreen(chatId: chatId.value));
    } else {
      debugPrint("Something went wrong");
    }
  }

  Future<void> createChatRoom({required String userId}) async {
    final body = {"user_id": userId};

    final response = await ApiClient.postData("/inbox/new-chat", body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      chatId.value = response.body['id'];
      debugPrint("Chat ID=========>: ${chatId.value}");
      Get.to(() => DriverInboxScreen(chatId: chatId.value));
    } else {
      debugPrint("Something went wrong");
    }
  }

  Future<void> fetchMessages({required String chatId}) async {
    isLoading.value = true;

    final response = await ApiClient.getData("/messages?chat_id=$chatId");

    if (response.statusCode == 200) {
      final json = response.body;
      final model = MessageModel.fromJson(json);
      messages.value = model.data;
    } else {
      debugPrint("Failed to load messages");
    }

    isLoading.value = false;
  }

  void sendMessage({
    required String chatId,
    required String text,
    List<String>? mediaUrls,
  }) {
    if (text.trim().isEmpty) return;

    final body = {
      "chat_id": chatId,
      "text": text,
      "media_urls": mediaUrls ?? [],
    };

    ///  correct event
    _socketService.emit("message:send", data: body);

    /// Optimistic UI
    messages.add(
      Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        chatId: chatId,
        userId: _dataController.id.value,
        text: text,
        mediaUrls: mediaUrls ?? [],
        isDeleted: false,
        seenBy: [],
        isMine: true,
      ),
    );
  }

  void listenForMessages() {
    _socketService.on("message:new", (data) {
      final message = Message.fromJson(data);

      final exists = messages.any((m) => m.id == message.id);
      if (!exists) {
        messages.add(message);
      }
    });
  }

 
}
