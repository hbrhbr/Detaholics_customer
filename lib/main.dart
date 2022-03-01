import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:product/Helper/Constant.dart';
import 'package:product/Helper/SharedManaged.dart';
import 'package:product/Provider/StoreProvider.dart';
import 'package:product/Screens/SignUP/SignUp.dart';
import 'package:product/Screens/SignUP/login_signup.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'Helper/CommonWidgets.dart';
import 'Screens/Login/LoginPage.dart';
import 'Screens/OnBoardingScreen/Onboarding.dart';
import 'Screens/OrderStatusPage/OrderStatusPage.dart';
import 'Screens/TabBarScreens/Orders/OrderScreen.dart';
import 'Screens/TabBarScreens/TabScreen/TabBar.dart';
import 'generated/i18n.dart';
import 'package:firebase_core/firebase_core.dart';

//Local Push Notification setup

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Streams are created so that app can respond to notification-related events since the plugin is initialised in the `main` function
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String> selectNotificationSubject =
    BehaviorSubject<String>();

NotificationAppLaunchDetails notificationAppLaunchDetails;
AndroidNotificationChannel channel;

class ReceivedNotification {
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceivedNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload,
  });
}

Future<void> main() async {
  // needed if you intend to initialize in the `main` function
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return ValueListenableBuilder(
        valueListenable: SharedManager.shared.locale,
        builder: (context, Locale value, _) {
          print(value);
          return ChangeNotifierProvider(
            create: (context) => StoreProvider(),
            child: MaterialApp(
              // initialRoute:'/LoginPage',
              // onGenerateRoute: RouteGenerator.generateRoute,
              debugShowCheckedModeBanner: false,
              locale: value,
              builder: (BuildContext context, Widget child){
                final MediaQueryData data = MediaQuery.of(context);
                return MediaQuery(
                  data: data.copyWith(textScaleFactor: 1),
                  child: child,
                );
              },
              localizationsDelegates: [
                S.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              supportedLocales: S.delegate.supportedLocales,
              localeListResolutionCallback:
                  S.delegate.listResolution(fallback: const Locale('en', '')),
              theme: ThemeData(primaryColor: AppColor.themeColor),
              home:
           new Splash(),
            ),
          );
        });
  }
}

class Splash extends StatefulWidget {
  @override
  SplashState createState() => new SplashState();
}

class SplashState extends State<Splash> {
  void _requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  Future<void> _showNotification(String title, String message) async {
    // var androidPlatformChannelSpecifics = AndroidNotificationDetails(
    //     'your channel id', 'your channel name', 'your channel description',
    //     importance: Importance.max, priority: Priority.high, ticker: 'ticker');
    // var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails();
    await flutterLocalNotificationsPlugin.show(
        0, '$title', '$message', platformChannelSpecifics,
        payload: 'item x');
  }

  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);
    if (_seen) {
      if(prefs.getString("isLoogedIn")!=null&&prefs.getString("isLoogedIn")=='yes') {
        SharedManager.shared.isLoggedIN = "yes";
        SharedManager.shared.currentIndex = 0;
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => new TabBarScreen()));
      } else
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => new Login_SignUP_Option_Screen()));

    } else {
      await prefs.setBool('seen', true);
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => new Onboarding()));
    }
  }

  @override
  void initState() {
    super.initState();
    // FirebaseApp.initializeApp(this);
    _requestIOSPermissions();
    new Timer(new Duration(milliseconds: (Platform.isAndroid ? 2000 : 100)),
        () {
      checkFirstSeen();
    });
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      if (message != null) {}
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                // TODO add a proper drawable resource to android, for now using
                //      one that already exists in example app.
                icon: 'launch_background',
              ),
            ));
        OrderScreen().updateOrder();
        OrderStatusPage().getOrderStatus();
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
    });
    Platform.isAndroid
        ? FirebaseMessaging.instance.getToken().then((fcmToken) async {
            SharedManager.shared.token = fcmToken;
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString(DefaultKeys.pushToken, fcmToken);
          })
        : FirebaseMessaging.instance.getAPNSToken().then((fcmToken) async {
            SharedManager.shared.token = fcmToken;
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString(DefaultKeys.pushToken, fcmToken);
          });

    // _firebaseMessaging.configure(
    //   onMessage: (Map<String, dynamic> message) {
    //     // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    //     // _notifier.notify('message', 'true');
    //     final message1 = message['notification']['body'];
    //     final title = message['notification']['title'];
    //     print("Notification Message:$message1");
    //     print("Notification Message:$message");
    // OrderScreen().updateOrder();
    // OrderStatusPage().getOrderStatus();
    //     // if (Platform.isAndroid) {
    //     // displayTostForNotification(message1);
    //     _showNotification(title, message1);
    //     // }
    //     return;
    //   },
    // );
    // _firebaseMessaging.requestPermission(sound: true, badge: true, alert: true);
    // _firebaseMessaging.getToken().then((String token) async {
    //   assert(token != null);
    //   print(token);
    //   SharedManager.shared.token = token;
    //   // SharedPreferences prefs = await SharedPreferences.getInstance();
    //   // await prefs.setString(token,DefaultKeys.pushToken);
    // });
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }

    /*Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => new SecondScreen(payload)),
    );*/
  }

  displayTostForNotification(String message) async {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  Future onDidRecieveLocalNotification(
      int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
          child: Platform.isAndroid
              ? new Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                      borderRadius: new BorderRadius.circular(75),
                      image: DecorationImage(
                          image: AssetImage(AppImages.appLogo))),
                )
              : new Text('')),
    );
  }
}

class Login_SignUP_Option_Screen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bodyColor,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                color: AppColor.bodyColor,
                image: DecorationImage(fit:BoxFit.cover, image: AssetImage("Assets/Onboarding/ob5.png"))),
          ),
          Positioned(
            top: 40,
            left: 10,
            child: new Chip(
              backgroundColor: AppColor.grey[200],
              label: GestureDetector(
                onTap: () async {
                  await SharedManager.shared
                      .storeString("no", "isLoogedIn");
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => new TabBarScreen()));

                },
                child: new Text('  Skip  ',
                    style: new TextStyle(
                      fontFamily: SharedManager.shared.fontFamilyName,
                    )),
              ),
            ),
          ),
          Positioned(
            bottom: 70,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: ()async{
                      await SharedManager.shared.storeString("no", "isLoogedIn");
                      SharedManager.shared.currentIndex = 0;
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginSignUpScreen(isLoginSelected: true)));
                    },
                    child: Container(
                      height: 40,
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      decoration: BoxDecoration(
                          color: AppColor.black,
                          borderRadius: BorderRadius.circular(30)),
                      child: Center(
                        child: setCommonText('${S.current.login}', AppColor.white, 16.0, FontWeight.bold, 1),
                      ),
                    ),
                  ),
                  SizedBox(width: 10,),
                  InkWell(
                    onTap: ()async{
                      await SharedManager.shared.storeString("no", "isLoogedIn");
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginSignUpScreen(isLoginSelected: false)));
                      },
                    child: Container(
                      height: 40,
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      decoration: BoxDecoration(
                          color: AppColor.orangeDeep,
                          borderRadius: BorderRadius.circular(30)),
                      child: Center(
                        child: setCommonText('${S.current.register}', AppColor.white, 16.0, FontWeight.bold, 1),
                      ),
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
}
