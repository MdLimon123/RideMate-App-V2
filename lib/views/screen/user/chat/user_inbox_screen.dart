import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class UserInboxScreen extends StatefulWidget {
  const UserInboxScreen({super.key});

  @override
  State<UserInboxScreen> createState() => _UserInboxScreenState();
}

class _UserInboxScreenState extends State<UserInboxScreen> {
  final TextEditingController messageController = TextEditingController();

  final List<Message> messages = [
    Message(text: "Hi 👋", isMine: false),
    Message(text: "Hello! How can I help you?", isMine: true),
    Message(text: "I need some information about my order.", isMine: false),
    Message(text: "Sure, please share your order ID.", isMine: true),
  ];

  @override
  void initState() {
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
              "Message",
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
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return _buildMessage(messages[index]);
                },
              ),
            ),

            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: messageController,
                    onFieldSubmitted: (value) {},
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
                  onTap: () {},
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
          color: message.isMine
              ? const Color(0xFFE6EAF0)
              : const Color(0xFFE6E6E6),
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
            color: message.isMine
                ? const Color(0xFF0D1A3E)
                : const Color(0xFF0D1A3E),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

class Message {
  final String text;
  final bool isMine;

  Message({required this.text, required this.isMine});
}
