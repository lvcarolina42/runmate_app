import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:runmate_app/domain/chat/model/message_model.dart';
import 'package:runmate_app/domain/chat/use_cases/connect_chat_use_case.dart';
import 'package:runmate_app/domain/chat/use_cases/disconnect_chat_use_case.dart';
import 'package:runmate_app/domain/chat/use_cases/get_messages_use_case.dart';
import 'package:runmate_app/domain/chat/use_cases/send_message_use_case.dart';
import 'package:runmate_app/domain/user/session_manager.dart';

// NOVO: Enum para um controle de estado mais robusto.
enum ChatConnectionState { Connecting, Connected, Failed, Disconnected }

class ChatController extends GetxController {
  final ConnectChatUseCase connectChatUseCase;
  final SendMessageUseCase sendMessageUseCase;
  final GetMessagesUseCase getMessagesUseCase;
  final DisconnectChatUseCase disconnectChatUseCase;

  ChatController({
    required this.connectChatUseCase,
    required this.sendMessageUseCase,
    required this.getMessagesUseCase,
    required this.disconnectChatUseCase,
  });

  final user = SessionManager().currentUser;
  late final String challengeId;

  // Variáveis reativas
  final messages = <MessageModel>[].obs;
  final isLoadingHistory = true.obs;
  
  // ATUALIZADO: Usando o novo enum de estado.
  final connectionState = ChatConnectionState.Connecting.obs;

  StreamSubscription<MessageModel>? _subscription;

  @override
  void onInit() {
    super.onInit();
    challengeId = Get.arguments as String;
    // Inicia a sequência de conexão e carregamento.
    _initializeChat();
  }
  
  // NOVO: Método para organizar a inicialização.
  Future<void> _initializeChat() async {
    await connectChat();
    // Só carrega o histórico se a conexão foi bem-sucedida.
    if (connectionState.value == ChatConnectionState.Connected) {
      await loadPreviousMessages();
    }
  }

  // ATUALIZADO: Lógica de conexão mais robusta.
  Future<void> connectChat() async {
    if (connectionState.value == ChatConnectionState.Connected) return;

    connectionState.value = ChatConnectionState.Connecting;
    
    final result = await connectChatUseCase(challengeId: challengeId);
    
    result.processResult(
      onSuccess: (stream) {
        _subscription = stream.listen((message) {
          messages.add(message);
        });
        // A conexão foi um sucesso, agora podemos atualizar o estado.
        connectionState.value = ChatConnectionState.Connected;
      },
      onFailure: (e) {
        debugPrint("Falha ao conectar no chat: ${e.toString()}");
        connectionState.value = ChatConnectionState.Failed;
        Get.snackbar("Erro de Conexão", "Não foi possível conectar ao chat. Tente novamente mais tarde.");
      },
    );
  }

  Future<void> loadPreviousMessages() async {
    isLoadingHistory.value = true;
    final result = await getMessagesUseCase(challengeId: challengeId);
    result.processResult(
      onSuccess: (data) {
        data.sort((a, b) => a.date.compareTo(b.date));
        messages.assignAll(data);
      },
      onFailure: (e) {
        debugPrint(e.toString());
      },
    );
    isLoadingHistory.value = false;
  }

  void sendMessage(String content) {
    // Verificação de segurança adicional.
    if (content.isEmpty || user == null || connectionState.value != ChatConnectionState.Connected) {
      return;
    }
    

    final result = sendMessageUseCase(
      userId: user!.id,
      content: content,
    );

    result.processResult(
      onSuccess: (sent) { /* Sucesso, não faz nada pois já adicionamos otimisticamente */ },
      onFailure: (e) {
        debugPrint("Falha ao enviar mensagem: ${e.toString()}");
        Get.snackbar("Erro", "Não foi possível enviar a mensagem.");
      },
    );
  }

  void disconnectChat() {
    disconnectChatUseCase(challengeId: challengeId);
    _subscription?.cancel();
    _subscription = null;
    connectionState.value = ChatConnectionState.Disconnected;
  }

  @override
  void onClose() {
    disconnectChat();
    super.onClose();
  }
}