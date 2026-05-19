import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/user/chat_controller.dart';
import 'package:flutter_extension/data/model/message_model.dart';
import 'package:flutter_extension/views/base/custom_loading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class UserInboxScreen extends StatefulWidget {
  final String chatId;
  const UserInboxScreen({super.key, required this.chatId});

  @override
  State<UserInboxScreen> createState() => _UserInboxScreenState();
}

class _UserInboxScreenState extends State<UserInboxScreen> {
  final TextEditingController messageController = TextEditingController();
  
  final _chatController = Get.put(ChatController());



  @override
  void initState() {
    _chatController.fetchMessages(chatId: widget.chatId);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            InkWell(
              onTap: () {
                Get.back();
              },
              child: const Icon(Icons.arrow_back_ios, color: Color(0xFF676769)),
            ),
            const SizedBox(width: 12),
            const Text(
              "Need Help",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Color(0xFF333333),
              ),
            ),
            // Spacer(),
            // Container(
            //   height: 40,
            //   width: 40,
            //   padding: EdgeInsets.all(8),
            //   decoration: BoxDecoration(
            //     shape: BoxShape.circle,
            //     color: Color(0xFFE6EAF0),
            //   ),
            //   child: SvgPicture.asset("assets/icons/phone.svg"),
            // ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Expanded(
              child: Obx(() {
                if (_chatController.isLoading.value) {
                  return const Center(child: CustomLoading());
                }

                if (_chatController.messages.isEmpty) {
                  return const Center(
                    child: Text(
                      "Start Chatting now",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: _chatController.messages.length,
                  itemBuilder: (context, index) {
                    final message = _chatController.messages[index];
                    return _buildMessage(message);
                  },
                );
              }),
            ),

            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: messageController,
                    onFieldSubmitted: (value) {
                      _chatController.sendMessage(
                        chatId: widget.chatId,
                        text: messageController.text,
                      );
                      messageController.clear();
                    },
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      hintStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF545454),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Color(0xFF545454),
                          width: 1,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Color(0xFF545454),
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Color(0xFF545454),
                          width: 1,
                        ),
                      ),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.asset('assets/icons/emoji.svg'),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                InkWell(
                  onTap: () {
                    _chatController.sendMessage(
                      chatId: widget.chatId,
                      text: messageController.text,
                    );
                    messageController.clear();
                  },
                  child: SvgPicture.asset('assets/icons/send.svg'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessage(Message message) {
    return Align(
      alignment: message.isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: message.isMine ? const Color(0xFFE6EAF0) : const Color(0xFFE6E6E6),
          borderRadius: message.isMine
              ? const BorderRadius.only(
                  bottomRight: Radius.circular(16),
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                )
              : const BorderRadius.only(
                  topRight: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: message.isMine ? const Color(0xFF0D1A3E) : const Color(0xFF0D1A3E),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}


