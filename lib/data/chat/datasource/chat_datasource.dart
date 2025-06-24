import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:runmate_app/data/api/go_api_handler_impl.dart'; // Mantenha seus imports

class ChatDatasource {
  final GoApiHandlerImpl apiHandler;
  WebSocket? _socket;
  StreamController<dynamic>? _controller;

  ChatDatasource({required this.apiHandler});

  Future<dynamic> getPreviousMessages(String challengeId) async {
    return await apiHandler.get("/chat/$challengeId/messages");
  }

  // --- MÉTODO ATUALIZADO: Lógica de conexão e limpeza robusta ---
  Future<Stream<dynamic>> connectWebSocket(String challengeId) async {
    // 1. Garante que qualquer conexão ou controller anterior seja totalmente limpo.
    // Isso é a chave para evitar o erro "Stream has already been listened to".
    disconnect();

    // 2. Cria um novo controller para esta nova tentativa de conexão.
    _controller = StreamController.broadcast();
    final uri = Uri.parse('wss://runmate-go-api.wonderfulflower-0ee6f11a.brazilsouth.azurecontainerapps.io/chat/$challengeId');

    try {
      _socket = await WebSocket.connect(uri.toString());

      _socket!.listen(
        (data) {
          // Adiciona um check de segurança para não adicionar eventos a um controller fechado.
          if (_controller?.isClosed == false) {
            _controller?.add(jsonDecode(data));
          }
        },
        // 3. Garante a limpeza quando a conexão é encerrada por qualquer motivo.
        onDone: () {
          disconnect();
        },
        onError: (error) {
          if (_controller?.isClosed == false) {
            _controller?.addError(error);
          }
          disconnect();
        },
        // Deixar cancelOnError como nulo ou false nos dá controle sobre a limpeza.
      );

      return _controller!.stream;
    } catch (e) {
      // 4. Se a conexão inicial falhar, garante que o controller recém-criado seja limpo.
      disconnect();
      throw Exception("Falha ao conectar ao WebSocket: $e");
    }
  }

  void sendMessage(String payload) {
    if (_socket != null && _socket?.closeCode == null) {
      _socket!.add(payload);
    } else {
      throw Exception("Socket não está conectado. Não é possível enviar a mensagem.");
    }
  }

  // --- MÉTODO ATUALIZADO: Lógica de limpeza centralizada ---
  void disconnect() {
    _socket?.close();
    _socket = null;
    // Verifica se o controller existe e não está fechado antes de tentar fechar.
    if (_controller?.isClosed == false) {
      _controller?.close();
    }
    _controller = null;
  }
}