import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:controller_mobile/bloc/notification_bloc.dart';
import 'package:controller_mobile/services/services.dart';
import 'package:controller_mobile/shared/shared.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:controller_mobile/ui/pages/pages.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'bloc/page_bloc.dart';

Future<void> firebaseMessagingForegroundHandler(
    RemoteMessage message, BuildContext context) async {
  await Firebase.initializeApp();
  if (message.data.isNotEmpty) {
    BlocProvider.of<NotificationBloc>(context).add(NewNotification());
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  if (message.data.isNotEmpty) {
    AwesomeNotifications().createNotification(
        content: NotificationContent(
            largeIcon: message.data['icon'],
            roundedLargeIcon: true,
            id: 10,
            channelKey: 'test334',
            backgroundColor: accent1Color,
            displayOnForeground: false,
            color: accent1Color,
            notificationLayout: NotificationLayout.BigPicture,
            title: message.data['title'],
            body: message.data['body']));
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AwesomeNotifications().initialize(
      'resource://drawable/logo',
      [
        NotificationChannel(
            channelKey: "test334",
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            ledColor: accent1Color)
      ],
      debug: true);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await Firebase.initializeApp();

  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AwesomeNotifications()
        .actionStream
        .listen((ReceivedNotification receivedNotification) {});
    return ScreenUtilInit(
      designSize: const Size(414, 736),
      builder: () {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => PageBloc(),
              child: Container(),
            ),
            BlocProvider(
              create: (context) => NotificationBloc(),
              child: Container(),
            )
          ],
          child: StreamBuilder<User?>(
              initialData: null,
              stream: AuthService.checkUserExist,
              builder: (context, snapshot) {
                return (snapshot.connectionState == ConnectionState.active ||
                        snapshot.connectionState == ConnectionState.done)
                    ? MaterialApp(
                        debugShowCheckedModeBanner: false,
                        home: Wrapper(user: snapshot.data),
                      )
                    : MaterialApp(
                        home: Scaffold(
                          body: Center(
                            child: SpinKitRing(color: accentColor),
                          ),
                        ),
                      );
              }),
        );
      },
    );
  }
}
