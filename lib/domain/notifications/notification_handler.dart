import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:convert';
import 'package:get/get.dart'; // Para Get.toNamed, se você descomentar
import 'package:runmate_app/shared/services/firebase_notifications_service.dart'; // Importe a instância global do plugin

class NotificationHandler {
  NotificationHandler();

  /// Exibe uma notificação local enriquecida no sistema.
  /// Recebe uma RemoteMessage e usa seus dados para criar a notificação.
  Future<void> _showLocalNotification(RemoteMessage message) async {
    // Extrai dados relevantes da mensagem Firebase.
    // Prioriza o `notification` payload se existir, senão usa os `data` personalizados.
    final String? eventTitle = message.notification?.title ?? message.data['eventTitle'];
    final String? eventBody = message.notification?.body ?? message.data['eventBody'];
    final String? eventId = message.data['eventId']; // ID do evento para navegação.

    // Define os botões de ação que aparecerão na notificação expandida.
    // Configuração detalhada da notificação para Android.
    // Usamos BigTextStyleInformation para permitir um texto mais longo e detalhado.
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'RunMate_Event_Channel', // ID único do canal de notificação.
      'Eventos RunMate', // Nome do canal visível ao usuário nas configurações.
      channelDescription: 'Notificações de novos eventos de corrida disponíveis para participação.',
      importance: Importance.max, // Nível de importância: alto (faz barulho e aparece no topo).
      priority: Priority.high, // Prioridade alta.
      showWhen: true, // Mostra o timestamp da notificação.
      icon: '@mipmap/ic_launcher', // Usa o ícone padrão do aplicativo.
      // Opcional: `color` para personalizar a cor de fundo do ícone (requer definição em `colors.xml`).
      // color: const Color.fromARGB(255, 255, 87, 34), // Exemplo: Laranja vibrante.
      styleInformation: BigTextStyleInformation(
        // Texto principal expandido da notificação.
        // Inclui um CTA e o corpo do evento, se disponível.
        eventBody ?? '',
        htmlFormatBigText: true, // Desabilita formatação HTML no texto principal.
        contentTitle: eventTitle, // Título da notificação expandida.
        htmlFormatContentTitle: true, // Desabilita formatação HTML no título.
        htmlFormatSummaryText: true, // Desabilita formatação HTML no resumo.
        htmlFormatContent: true,
        htmlFormatTitle: true,
      ),
    );

    // Configurações para outras plataformas (iOS, macOS) podem ser adicionadas aqui se necessário.
    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    // Constrói o payload que será associado à notificação local.
    // Este payload será retornado quando o usuário interagir com a notificação.
    final Map<String, dynamic> payloadData = {
      ...message.data, // Inclui todos os dados originais da mensagem Firebase.
      'notificationType': 'event_notification', // Tipo para identificar a notificação.
      'eventId': eventId, // ID do evento para navegação específica.
      'action': '', // Placeholder para a ação do botão (preenchido no callback).
    };
    final String payload = jsonEncode(payloadData); // Converte o payload para JSON string.

    // Exibe a notificação no sistema.
    await flutterLocalNotificationsPlugin.show(
      message.hashCode, // ID da notificação (usar hashcode para garantir unicidade para cada mensagem).
      eventTitle ?? 'Novo Evento RunMate!', // Título da notificação.
      eventBody ?? 'Um evento de corrida foi adicionado!', // Corpo da notificação.
      platformChannelSpecifics, // Detalhes específicos da plataforma.
      payload: payload, // Payload associado.
    );
  }

  /// Lida com mensagens FCM quando o aplicativo está em primeiro plano (ativo).
  void handleForegroundMessage(RemoteMessage message) {
    if (message.notification != null || message.data.isNotEmpty) {
      print('Notificação em primeiro plano (FCM): ${message.notification?.title} / ${message.notification?.body}');
      _showLocalNotification(message); // Exibe a notificação local enriquecida.
    }
  }

  /// Lida com mensagens FCM quando o aplicativo está em segundo plano.
  void handleBackgroundMessage(RemoteMessage message) {
    print('Mensagem em segundo plano processada: ${message.data}');
    // Se a mensagem não contiver um `notification` payload (ou seja, é uma "silent notification"),
    // o Android não a exibirá automaticamente. Neste caso, criamos uma notificação local.
    // Se a mensagem contiver um `notification` payload, o sistema Android já cuida da exibição padrão.
    if (message.notification == null && message.data.isNotEmpty) {
      _showLocalNotification(message); // Cria uma notificação local rica para mensagens apenas com dados.
    }
    // A interação com os botões (actions) ainda será capturada pelos callbacks de nível superior
    // `onDidReceiveBackgroundNotificationResponseCallback` definidos em `firebase_notifications_service.dart`.
  }

  /// Lida com o evento de o usuário abrir o aplicativo tocando em uma notificação FCM padrão.
  void handleMessageOpenedApp(RemoteMessage message) {
    print('App aberto via notificação (FCM): ${message.data}');
    // Processa o toque na notificação, delegando para um método unificado.
    _processNotificationTap(message.data);
  }

  /// Lida com o evento de o usuário abrir o aplicativo tocando em uma notificação LOCAL.
  void handleMessageOpenedAppFromLocalNotification(String payload) {
    print('App aberto via notificação LOCAL: $payload');
    // Decodifica o payload JSON e processa o toque na notificação.
    final Map<String, dynamic> data = jsonDecode(payload);
    _processNotificationTap(data);
  }

  /// Lida com o evento de o aplicativo ser iniciado a partir de um estado encerrado
  /// por uma notificação FCM.
  void handleInitialMessage(RemoteMessage message) {
    print('App lançado via notificação (FCM): ${message.data}');
    // Adiciona um pequeno atraso para garantir que as rotas do GetX estejam prontas.
    Future.delayed(const Duration(milliseconds: 500), () {
      _processNotificationTap(message.data);
    });
  }

  /// Método unificado para processar o toque ou ação de uma notificação.
  /// Direciona a navegação ou lógica com base no tipo de notificação e ação.
  void _processNotificationTap(Map<String, dynamic> data) {
    final String? notificationType = data['notificationType'];
    final String? action = data['action'];
    final String? eventId = data['eventId'];

    // Lógica específica para notificações de eventos de corrida.
    if (notificationType == 'event_notification') {
      if (action == 'participate_action') {
        print('Ação: Participar do evento ID: $eventId');
        // TODO: Lógica para inscrever o usuário no evento.
        if (eventId != null) {
          // Exemplo de navegação para a tela de inscrição do evento.
          // Get.toNamed('${Paths.eventRegistrationPage}/$eventId');
          Get.snackbar("Ação de Notificação", "Participar do evento $eventId");
        }
      } else if (action == 'view_details_action' || action == null || action.isEmpty) {
        print('Ação: Ver Detalhes do evento ID: $eventId');
        // Se a ação for "Ver Detalhes" ou um toque geral na notificação (sem ação específica).
        if (eventId != null) {
          // Exemplo de navegação para a tela de detalhes do evento.
          // Get.toNamed('${Paths.eventDetailsPage}/$eventId');
          Get.snackbar("Ação de Notificação", "Ver detalhes do evento $eventId");
        }
      }
    } else {
      // Lógica para outros tipos de notificações que não sejam de eventos de corrida.
      final screen = data['screen'];
      if (screen == 'profile') {
        // Get.toNamed(Paths.profilePage);
        Get.snackbar("Ação de Notificação", "Ir para Perfil");
      } else if (screen == 'dashboard') {
        // Get.toNamed(Paths.dashboardPage);
        Get.snackbar("Ação de Notificação", "Ir para Dashboard");
      }
    }
  }
}