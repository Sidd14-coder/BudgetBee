import 'package:flutter/material.dart';
import '../screens/chatbot_screen.dart';

class ChatbotFab extends StatelessWidget {
  const ChatbotFab({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: "chatbot_${UniqueKey()}",
      backgroundColor: const Color(0xFF1E002B),
      shape: const CircleBorder(
        side: BorderSide(color: Colors.white, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Image.asset('assets/icons/chatbot.png'),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const ChatbotScreen(),
          ),
        );
      },
    );
  }
}
