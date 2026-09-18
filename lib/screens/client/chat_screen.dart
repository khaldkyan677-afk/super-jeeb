import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String name;
  final IconData icon;
  final Color color;

  const ChatScreen({
    super.key,
    this.name = 'الكابتن أحمد',
    this.icon = Icons.person,
    this.color = const Color(0xFF25D366),
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _msgController = TextEditingController();
  final _scrollController = ScrollController();

  final List<Map<String, dynamic>> _messages = [
    {
      'text': 'السلام عليكم، أنا في طريقي إليك',
      'me': false,
      'time': '10:50 ص',
    },
    {
      'text': 'وعليكم السلام، أنا في انتظارك',
      'me': true,
      'time': '10:51 ص',
    },
    {
      'text': 'سأصل خلال 5 دقائق بإذن الله',
      'me': false,
      'time': '10:52 ص',
    },
    {
      'text': 'تمام، في انتظارك',
      'me': true,
      'time': '10:52 ص',
    },
  ];

  void _sendMessage() {
    if (_msgController.text.trim().isEmpty) return;
    setState(() {
      _messages.add({
        'text': _msgController.text,
        'me': true,
        'time': _now(),
      });
    });
    _msgController.clear();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _now() {
    final h = DateTime.now().hour;
    final m = DateTime.now().minute.toString().padLeft(2, '0');
    final period = h < 12 ? 'ص' : 'م';
    final hour = h > 12 ? h - 12 : (h == 0 ? 12 : h);
    return '$hour:$m $period';
  }

  @override
  void dispose() {
    _msgController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B2D42),
        leading: const BackButton(color: Colors.white),
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: widget.color.withValues(alpha: 0.2),
              child: Icon(widget.icon, color: widget.color, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.name,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold)),
                  const Text('متصل الآن',
                      style: TextStyle(
                          color: Color(0xFF25D366), fontSize: 10)),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.phone, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('📞 اتصال محمي'),
                    backgroundColor: Color(0xFF25D366)),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(15),
              itemCount: _messages.length,
              itemBuilder: (context, i) => _bubble(_messages[i]),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            color: Colors.white,
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.attach_file,
                        color: Color(0xFFEF233C)),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('📎 إرفاق ملف')),
                      );
                    },
                  ),
                  Expanded(
                    child: TextField(
                      controller: _msgController,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                      decoration: InputDecoration(
                        hintText: 'اكتب رسالة...',
                        hintStyle: const TextStyle(fontSize: 13),
                        filled: true,
                        fillColor: const Color(0xFFF8F9FA),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: const Color(0xFFEF233C),
                    child: IconButton(
                      icon: const Icon(Icons.send,
                          color: Colors.white, size: 20),
                      onPressed: _sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bubble(Map<String, dynamic> msg) {
    final isMe = msg['me'] as bool;
    return Align(
      alignment: isMe ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(
            horizontal: 14, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isMe ? const Color(0xFFEF233C) : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(isMe ? 4 : 18),
            bottomRight: Radius.circular(isMe ? 18 : 4),
          ),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.05), blurRadius: 5),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(msg['text'],
                style: TextStyle(
                    color: isMe ? Colors.white : const Color(0xFF2B2D42),
                    fontSize: 13,
                    height: 1.4)),
            const SizedBox(height: 4),
            Text(msg['time'],
                style: TextStyle(
                    color: isMe ? Colors.white70 : Colors.grey,
                    fontSize: 9)),
          ],
        ),
      ),
    );
  }
}
