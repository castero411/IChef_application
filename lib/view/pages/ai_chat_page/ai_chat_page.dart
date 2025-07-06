// pages/ai_chat_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i_chef_application/provider/api_provider.dart';

// ────────── A simple message model ──────────
class ChatMessage {
  final String text;
  final bool isUser;
  const ChatMessage(this.text, this.isUser);
}

// Loading‑state flag
final _chatSendingProvider = StateProvider<bool>((_) => false);

// ────────── Screen widget ──────────
class AiChatPage extends ConsumerStatefulWidget {
  const AiChatPage({super.key});
  @override
  ConsumerState<AiChatPage> createState() => _AiChatPageState();
}

class _AiChatPageState extends ConsumerState<AiChatPage> {
  final _controller = TextEditingController();
  final _messages = <ChatMessage>[];

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty || ref.read(_chatSendingProvider)) return;

    // Add user bubble immediately
    setState(() => _messages.insert(0, ChatMessage(text, true)));
    _controller.clear();
    ref.read(_chatSendingProvider.notifier).state = true;

    try {
      // 🔗 Call the backend via ChefApiService
      final api = ref.read(chefApiServiceProvider);
      final reply = await api.sendMessageToBot(text);

      setState(() => _messages.insert(0, ChatMessage(reply, false)));
    } catch (_) {
      setState(
        () => _messages.insert(
          0,
          const ChatMessage('⚠️  Error talking to iChef. Try again.', false),
        ),
      );
    } finally {
      ref.read(_chatSendingProvider.notifier).state = false;
    }
  }

  Widget _bubble(ChatMessage m) => Align(
    alignment: m.isUser ? Alignment.centerRight : Alignment.centerLeft,
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      padding: const EdgeInsets.all(12),
      constraints: const BoxConstraints(maxWidth: 280),
      decoration: BoxDecoration(
        color: m.isUser ? Colors.blueAccent : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        m.text,
        style: TextStyle(color: m.isUser ? Colors.white : Colors.grey.shade900),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final isSending = ref.watch(_chatSendingProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('iChef Chat')),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          children: [
            /// ── Messages (or empty placeholder) ──
            Expanded(
              child:
                  _messages.isEmpty
                      ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.chat_bubble_outline,
                              size: 64,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Ask iChef anything!',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      )
                      : ListView.builder(
                        reverse: true,
                        itemCount: _messages.length,
                        itemBuilder: (_, i) => _bubble(_messages[i]),
                      ),
            ),

            if (isSending)
              const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            const Divider(height: 1),

            /// ── Composer ──
            SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                color: Colors.white,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: const InputDecoration.collapsed(
                          hintText: 'Send a message…',
                        ),
                        onSubmitted: (_) => _send(),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send, color: Colors.blueAccent),
                      onPressed: isSending ? null : _send,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
