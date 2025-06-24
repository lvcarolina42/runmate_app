import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:runmate_app/domain/chat/model/message_model.dart';
import 'package:runmate_app/presentation/chat/controller/chat_controller.dart';
import 'package:runmate_app/shared/themes/app_colors.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ChatController controller = Get.find<ChatController>();
  final textController = TextEditingController();
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Intl.defaultLocale = 'pt_BR';

    controller.messages.listen((_) {
        Future.delayed(const Duration(milliseconds: 100), () {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOut,
          );
        });
    });
  }

  @override
  void dispose() {
    textController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  bool _isSameDay(DateTime dateA, DateTime dateB) {
    return dateA.year == dateB.year &&
           dateA.month == dateB.month &&
           dateA.day == dateB.day;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1. Cor de fundo principal alterada
      backgroundColor: AppColors.blue950,
      appBar: AppBar(
        title: const Text('Chat'),
        // AppBar com fundo transparente para se mesclar ao Scaffold
        backgroundColor: AppColors.blue950,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.connectionState.value == ChatConnectionState.Connecting) {
                return const Center(child: CircularProgressIndicator(color: Colors.white));
              }
              if (controller.connectionState.value == ChatConnectionState.Failed) {
                return const Center(child: Text("Falha na conexão com o chat.", style: TextStyle(color: Colors.white70)));
              }
              if (controller.isLoadingHistory.value) {
                return const Center(child: CircularProgressIndicator(color: Colors.white));
              }

              return ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final message = controller.messages[index];
                  final isMine = message.user.id == controller.user?.id;
                  
                  final bool showDateSeparator = index == 0 ||
                      !_isSameDay(
                        controller.messages[index - 1].date,
                        message.date,
                      );

                  return Column(
                    children: [
                      if (showDateSeparator) 
                        _DateSeparator(date: message.date),
                      _MessageBubble(message: message, isMine: isMine),
                    ],
                  );
                },
              );
            }),
          ),
          Obx(() => _ChatInputField(
              textController: textController,
              isEnabled: controller.connectionState.value == ChatConnectionState.Connected,
              onSend: () {
                final text = textController.text.trim();
                if (text.isNotEmpty) {
                  controller.sendMessage(text);
                  textController.clear();
                  FocusScope.of(context).unfocus();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _DateSeparator extends StatelessWidget {
  final DateTime date;
  const _DateSeparator({required this.date});

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final dateToCompare = DateTime(date.year, date.month, date.day);

    if (dateToCompare == today) {
      return 'HOJE';
    } else if (dateToCompare == yesterday) {
      return 'ONTEM';
    } else {
      return DateFormat('d MMMM', 'pt_BR').format(date).toUpperCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        // Cor do separador de data ajustada para o tema escuro
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        _formatDate(date),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final MessageModel message;
  final bool isMine;

  const _MessageBubble({required this.message, required this.isMine});

  @override
  Widget build(BuildContext context) {
    const radius = Radius.circular(20);
    const zeroRadius = Radius.zero;
    // Cor de destaque para o nome do remetente
    final highlightColor = Colors.cyan.shade300;

    return Container(
      // Alinhamento do horário junto ao balão
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 12),
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // 2. Mostra o horário à esquerda para as mensagens dos outros
          if (!isMine)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Text(
                DateFormat('HH:mm', 'pt_BR').format(message.date),
                style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12),
              ),
            ),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              decoration: BoxDecoration(
                // 3. Cores dos balões ajustadas para o tema escuro
                color: isMine ? const Color(0xFF005c97) : const Color(0xFF263238),
                borderRadius: BorderRadius.only(
                  topLeft: radius,
                  topRight: radius,
                  bottomLeft: isMine ? radius : zeroRadius,
                  bottomRight: isMine ? zeroRadius : radius,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isMine)
                    Text(
                      message.user.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: highlightColor,
                        fontSize: 13,
                      ),
                    ),
                  if (!isMine) const SizedBox(height: 4),
                  Text(
                    message.content,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Mostra o horário à direita para as suas mensagens
          if (isMine)
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                DateFormat('HH:mm').format(message.date),
                style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }
}


class _ChatInputField extends StatelessWidget {
  final TextEditingController textController;
  final VoidCallback onSend;
  final bool isEnabled;

  const _ChatInputField({
    required this.textController, 
    required this.onSend,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // 4. Design do campo de input ajustado
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.blue950,
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.1)))
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: textController,
                textCapitalization: TextCapitalization.sentences,
                enabled: isEnabled,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: isEnabled ? 'Digite sua mensagem...' : 'Conectando...',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
                onSubmitted: isEnabled ? (text) => onSend() : null,
              ),
            ),
            const SizedBox(width: 8),
            Material(
              color: isEnabled ? Colors.cyan.shade400 : Colors.grey.shade600,
              borderRadius: BorderRadius.circular(30),
              child: InkWell(
                borderRadius: BorderRadius.circular(30),
                onTap: isEnabled ? onSend : null,
                child: const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Icon(
                    Icons.send,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
