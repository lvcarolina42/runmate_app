// lib/shared/services/firebase_notifications_service.dart

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:runmate_app/domain/notifications/notification_handler.dart';
import 'dart:convert'; // Necessário para jsonEncode/Decode

// Instância global para o plugin de notificações locais.
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// --- Funções de Nível Superior para Callbacks do flutter_local_notifications ---

/// Callback para quando uma notificação local é tocada no foreground.
/// Passa o payload e o actionId para o NotificationHandler.
@pragma('vm:entry-point')
void onDidReceiveNotificationResponseCallback(NotificationResponse response) async {
  print('onDidReceiveNotificationResponse (foreground/local): ${response.payload} | Action: ${response.actionId}');
  if (response.payload != null) {
    // Adiciona a ação ao payload antes de passar para o handler.
    final Map<String, dynamic> data = jsonDecode(response.payload!);
    data['action'] = response.actionId; // Ação do botão tocado.
    GetIt.I.get<NotificationHandler>().handleMessageOpenedAppFromLocalNotification(jsonEncode(data));
  }
}

/// Callback para quando uma notificação local é tocada no background/terminada.
/// Passa o payload e o actionId para o NotificationHandler.
@pragma('vm:entry-point')
void onDidReceiveBackgroundNotificationResponseCallback(NotificationResponse response) async {
  print('onDidReceiveBackgroundNotificationResponse: ${response.payload} | Action: ${response.actionId}');
  if (response.payload != null) {
    // Garante que o Firebase está inicializado no contexto isolado do background handler.
    await Firebase.initializeApp();
    // Adiciona a ação ao payload antes de passar para o handler.
    final Map<String, dynamic> data = jsonDecode(response.payload!);
    data['action'] = response.actionId; // Ação do botão tocado.
    GetIt.I.get<NotificationHandler>().handleMessageOpenedAppFromLocalNotification(jsonEncode(data));
  }
}

/// Manipulador de mensagens Firebase em segundo plano (top-level function).
/// Inicializa o flutter_local_notifications e delega para o NotificationHandler.
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");

  // Configuração para inicializar o flutter_local_notifications no isolado de background.
  // Usa '@mipmap/ic_launcher' para o ícone padrão.
  const AndroidInitializationSettings initializationSettingsAndroidBackground =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettingsBackground =
      InitializationSettings(android: initializationSettingsAndroidBackground);

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettingsBackground,
    // Passa as funções de nível superior para os callbacks.
    onDidReceiveBackgroundNotificationResponse: onDidReceiveBackgroundNotificationResponseCallback,
    onDidReceiveNotificationResponse: onDidReceiveNotificationResponseCallback,
  );

  // Delega o processamento da mensagem de background para o NotificationHandler.
  GetIt.I.get<NotificationHandler>().handleBackgroundMessage(message);
}

class FirebaseNotificationsService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final NotificationHandler _notificationHandler;

  // Construtor que obtém o NotificationHandler via GetIt para injeção de dependência.
  FirebaseNotificationsService() : _notificationHandler = GetIt.I<NotificationHandler>();

  /// Inicializa o Firebase Messaging e o flutter_local_notifications.
  Future<void> initialize() async {
    // Configurações para a inicialização do flutter_local_notifications no foreground.
    // Usa '@mipmap/ic_launcher' para o ícone padrão do aplicativo.
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      // Passa as funções de nível superior para os callbacks.
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponseCallback,
      onDidReceiveBackgroundNotificationResponse: onDidReceiveBackgroundNotificationResponseCallback,
    );

    // Configura o manipulador de mensagens em segundo plano.
    // Esta linha é crucial para o Flutter registrar o ponto de entrada da função de background.
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    await _requestPermissions();
    await _getToken();
    _listenToMessages();
    await _handleInitialMessage();
  }

  /// Solicita permissões de notificação ao usuário.
  Future<void> _requestPermissions() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true, announcement: false, badge: true, carPlay: false,
      criticalAlert: false, provisional: false, sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('Permissão de notificação concedida pelo usuário');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('Permissão provisória de notificação concedida');
    } else {
      print('Permissão de notificação recusada ou não aceita');
    }
  }

  /// Obtém o token FCM único do dispositivo.
  Future<void> _getToken() async {
    String? fcmToken = await _messaging.getToken();
    print("FCM Token: $fcmToken");
    // TODO: Envie este token para o seu backend para possibilitar o envio de notificações direcionadas.
  }

  /// Escuta por mensagens FCM enquanto o aplicativo está em execução.
  void _listenToMessages() {
    // Lida com mensagens recebidas enquanto o app está em primeiro plano (foreground).
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Mensagem recebida em primeiro plano!');
      print('Dados da mensagem: ${message.data}');
      // Delega para o NotificationHandler exibir uma notificação local com o novo design.
      _notificationHandler.handleForegroundMessage(message);
    });

    // Lida com o evento de o usuário abrir o app ao tocar em uma notificação FCM.
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Aplicativo aberto por uma notificação (Firebase): ${message.data}');
      // O handler processa a ação de toque na notificação.
      _notificationHandler.handleMessageOpenedApp(message);
    });
  }

  /// Lida com a mensagem inicial que abriu o aplicativo a partir de um estado encerrado.
  Future<void> _handleInitialMessage() async {
    RemoteMessage? initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      print('Aplicativo iniciado do estado encerrado por uma notificação (Firebase): ${initialMessage.data}');
      _notificationHandler.handleInitialMessage(initialMessage);
    }
  }
}