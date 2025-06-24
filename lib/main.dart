import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:runmate_app/shared/app_routes/paths.dart';
import 'package:runmate_app/di/dependency_injection.dart';
import 'package:runmate_app/shared/app_routes/routes.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:runmate_app/domain/user/session_manager.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:runmate_app/shared/services/firebase_notifications_service.dart'; // Importe o novo serviço

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (GetPlatform.isAndroid) await Firebase.initializeApp();

  if (GetPlatform.isAndroid) FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  DependencyInjector().setup();

  await SessionManager().loadUser();

  // MapboxOptions.setAccessToken("pk.eyJ1IjoibHZjYXJvbGluYTQyIiwiYSI6ImNtYW4wcWp1bjBwODgyeG9zcTQzYjg1bmQifQ.S8YMmFdqNqUSKnefdhUXNA");

  final isLoggedIn = SessionManager().isLoggedIn;

  if (GetPlatform.isAndroid) await GetIt.I<FirebaseNotificationsService>().initialize(); 

  runApp(
    MaterialApp.router(
      theme: ThemeData(
        fontFamily: 'Roboto',
      ),
      debugShowCheckedModeBanner: false,
      routeInformationParser: GetInformationParser(),
      routerDelegate: GetDelegate(
        preventDuplicateHandlingMode: PreventDuplicateHandlingMode.DoNothing,
      ),
      builder: (context, child) {
        return GetMaterialApp(
          getPages: Routes.pages,
          debugShowCheckedModeBanner: false,
          builder: (context, child) => child!,
          localizationsDelegates: const [
            GlobalWidgetsLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('pt')],
          initialRoute: isLoggedIn ? Paths.menuPage : Paths.loginPage,
        );
      },
    ),
  );
}