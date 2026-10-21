import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart'; // 🔥 url_launcher ADDED
import '../services/gemini_service.dart';
import '../data/user_finance_data.dart';
import '../services/user_service.dart';
import '../globals.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    if (globalChatMessages.isEmpty) {
      loadWelcomeMessage();
    }
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }


  void loadWelcomeMessage() async {
    var user = getUserFromHive();
    String name = "User";

    if (user != null && user['name'] != null) {
      name = user['name'].toString().split(" ")[0]; // first name
    }

    setState(() {
      globalChatMessages.add({
        "role": "bot",
        "text":
            "Hello $name 👋\nI'm your BudgetBee assistant.\n\n1️⃣ Analyze my spending\n2️⃣ Saving tips\n3️⃣ Investment ideas\n4️⃣ Budget advice"
      });
    });
  }

  void sendMessage(String text) async {
    setState(() {
      globalChatMessages.add({"role": "user", "text": text});
      globalChatMessages.add({"role": "bot", "text": "Typing..."}); // 🔥 loading
      controller.clear(); // CRITICAL: Clear immediately
    });
    scrollToBottom();

    final data = await getUserFinanceData();

    String reply = await GeminiService.getAIResponse(
      userMessage: text,
      userData: data,
      chatHistory: globalChatMessages, // 🔥 Passed chat history
    );

    if (mounted) {
      setState(() {
        globalChatMessages.removeLast(); // remove "Typing..."
        globalChatMessages.add({"role": "bot", "text": reply});
      });
      scrollToBottom();
    }
  }

  Widget _buildActionCard(String title, String actionText) {
    return GestureDetector(
      onTap: () => sendMessage(actionText),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
      ),
    );
  }

  Widget _buildWelcomeHeader() {
    String name = "User";
    var user = getUserFromHive();
    if (user != null && user['name'] != null) {
      name = user['name'].toString().split(" ")[0];
    }
    
    var hour = DateTime.now().hour;
    String greeting = "Good Morning";
    if (hour >= 12 && hour < 17) greeting = "Good Afternoon";
    else if (hour >= 17) greeting = "Good Evening";

    return Column(
      children: [
        const SizedBox(height: 40),
        Container(
          width: 110,
          height: 110,
          decoration: const BoxDecoration(
            color: Color(0xFF130130),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: TweenAnimationBuilder(
              tween: Tween<double>(begin: 0.9, end: 1.1),
              duration: const Duration(milliseconds: 1500),
              curve: Curves.easeInOut,
              builder: (context, scale, child) {
                return Transform.scale(
                  scale: scale,
                  child: child,
                );
              },
              onEnd: () {
                // To loop the animation, we could use an AnimationController.
                // For a simpler approach, we'll just leave it scaled slightly or use an implicit animation wrapper.
                // Actually an easy breathing effect requires a StatefulWidget, but TweenAnimationBuilder can suffice if not looped. 
              },
              child: Image.asset('assets/icons/chatbot.png', width: 60, height: 60),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          "$greeting, $name",
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(height: 30),
        _buildActionCard("📊 Show my spending", "Analyze my spending"),
        _buildActionCard("💰 Investment ideas", "Investment ideas"),
        _buildActionCard("⚠️ Am I overspending?", "Budget advice"),
        _buildActionCard("📅 Weekly report", "Weekly report"),
        const SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F2EC),
      appBar: AppBar(
        
        title: const Text("BudgetBee Assistant", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white)),
        backgroundColor: const Color(0xFF0A3622),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          )
        ],
      ),
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bd_whatsapp.jpeg'),
                fit: BoxFit.cover,
                opacity: 0.25,
              ),
            ),
          ),
          Column(
            children: [
              Expanded(
                child: ListView(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(10),
                  children: globalChatMessages.map((msg) {
                    // INTERCEPT FIRST SYSTEM MESSAGE TO SHOW CUSTOM UI
                    if (msg == globalChatMessages.first && msg["role"] == "bot" && (msg["text"]?.contains("Hello") ?? false)) {
                      return _buildWelcomeHeader();
                    }

                    return Align(
                      alignment: msg["role"] == "user"
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: msg["role"] == "user"
                              ? const Color(0xFF0A3622)
                              : Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(16),
                            topRight: const Radius.circular(16),
                            bottomLeft: Radius.circular(msg["role"] == "user" ? 16 : 0),
                            bottomRight: Radius.circular(msg["role"] == "user" ? 0 : 16),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            )
                          ]
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            msg["role"] == "user"
                                ? Text(
                                    msg["text"]!,
                                    style: const TextStyle(color: Colors.white, fontSize: 16),
                                  )
                                : MarkdownBody(
                                    data: msg["text"]!,
                                    onTapLink: (text, href, title) async {
                                      if (href != null) {
                                        try {
                                          await launchUrl(Uri.parse(href), mode: LaunchMode.externalApplication);
                                        } catch (e) {
                                          debugPrint("Could not launch $href: $e");
                                        }
                                      }
                                    },
                                    styleSheet: MarkdownStyleSheet(
                                      p: const TextStyle(fontSize: 16, height: 1.4, color: Colors.black87),
                                      a: const TextStyle(fontSize: 16, color: Colors.blue, decoration: TextDecoration.underline),
                                      strong: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0A3622)),
                                      listBullet: const TextStyle(fontSize: 18, color: Color(0xFF0A3622)),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              // BOTTOM INPUT FIELD
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            )
                          ],
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 20),
                            Expanded(
                              child: TextField(
                                controller: controller,
                                decoration: const InputDecoration(
                                  hintText: "Message..",
                                  hintStyle: TextStyle(fontSize: 16, color: Colors.black54),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Color(0xFF0A3622),
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.send, color: Colors.white, size: 20),
                                onPressed: () {
                                  if (controller.text.trim().isNotEmpty) {
                                    sendMessage(controller.text.trim());
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
