import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:product/Helper/CommonWidgets.dart';
import 'package:product/Helper/Constant.dart';
import 'package:product/Helper/LocationManager.dart';
import 'package:product/Helper/RequestManager.dart';
import 'package:product/Helper/SharedManaged.dart';
import 'package:product/Screens/ForgotPassword/forgotPassword.dart';
import 'package:product/Screens/SignUP/SignUp.dart';
import 'package:product/Screens/TabBarScreens/TabScreen/TabBar.dart';
import 'package:http/http.dart' as http;
import 'package:product/generated/i18n.dart';
import 'SocialLogin/sign_in.dart';

void main() => runApp(LoginPage());

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var width = 40.0;
  var height = 40.0;
  var status = true;

  var widthgp = 40.0;
  var heightgp = 40.0;
  var statusgp = true;

  static TextEditingController emailController = new TextEditingController();
  static TextEditingController passwordController = new TextEditingController();
  bool isSecure = true;
  static double latitude = 0.00;
  static double longitude = 0.00;
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
//Social Media Integrations for login.

//Facebook Login Stuff

  Future<Null> _loginWithFacebook() async {
    final FacebookLoginResult result =
        await SharedManager.shared.facebookSignIn.logIn(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final FacebookAccessToken accessToken = result.accessToken;
        var graphResponse = await http.get(Uri.parse(
            'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture&access_token=${accessToken.token}'));
        var profile = json.decode(graphResponse.body);
        var data = profile['picture']['data'];
        print("User Facebook Response:$profile");
        _loginWithSocialMedia(
            '1', profile['name'], profile['email'], profile['id'], data['url']);
        break;
      case FacebookLoginStatus.cancelledByUser:
        // _showMessage('Login cancelled by the user.');
        print('Login cancelled by the user');
        break;
      case FacebookLoginStatus.error:
        print('Something went wrong with the login process.\n'
            'Here\'s the error Facebook gave us: ${result.errorMessage}');
        break;
    }
  }

//TODO: Social Media Login

  _loginWithSocialMedia(String loginTypeCode, String name, String email, String id, String image) async {
    final param = {
      "email": email,
      "name": name,
      "phone": "123456",
      "latitude": "${SharedManager.shared.latitude}",
      "longitude": "${SharedManager.shared.longitude}",
      "social_id": id,
      "is_social_login": '$loginTypeCode',
      "device_token": '${SharedManager.shared.token}',
      "profile_image": '$image'
    };
    print('User Parameters:======>$param');

    showSnackbar("${S.current.loading}", _scaffoldkey, context);
    Requestmanager manager = Requestmanager();
    await manager
        .getUserLoginWithSocialMedia(APIS.socialLogin, true, param)
        .then((value) async {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      if (value.code == 1) {
        await SharedManager.shared.storeUserSocialLoginData(value);
        emailController.text = '';
        passwordController.text = '';
        await SharedManager.shared.storeString("yes", "isLoogedIn");
        await SharedManager.shared.storeString("yes", "isSocialLogin");
        SharedManager.shared.isLoggedIN = "yes";
        Navigator.pop(context);
        SharedManager.shared.currentIndex = 2;
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => TabBarScreen()),
            ModalRoute.withName(AppRoute.tabbar));
      } else {
        SharedManager.shared.showAlertDialog(value.message, context);
      }
    });
  }

  @override
  void initState() {
    super.initState();

    LocationManager.shared.getCurrentLocation();
    _getUserCurrentLocation();
    emailController.text = "";
  }
  // var facebookLogin = FacebookLogin();

  _getUserCurrentLocation() async {
    LatLng coordinate = await SharedManager.shared.getLocationCoordinate();
    latitude = coordinate.latitude;
    longitude = coordinate.longitude;
  }

  _setLoginMethod() async {
    var validator = SharedManager.shared.validateEmail(emailController.text);

    if (emailController.text == "" || validator == "Enter Valid Email") {
      Navigator.pop(context);
      SharedManager.shared
          .showAlertDialog("${S.current.enterEmailFirst}", context);
      return;
    } else if (passwordController.text == "") {
      Navigator.pop(context);
      SharedManager.shared
          .showAlertDialog("${S.current.enterOldpass}}", context);
      return;
    }

    var param = {
      "email": emailController.text,
      "password": passwordController.text,
      "device_token": SharedManager.shared.token,
      "latitude": latitude.toString(),
      "longitude": longitude.toString(),
    };

    print("Request Parameter:$param");

    var manager = Requestmanager();
    var data = await manager.getUserLogin(APIS.login, true, param);
    print("User data: ===== >>>>>>${data.code}");
    if (data.code == 1) {
      emailController.text = '';
      passwordController.text = '';
      await SharedManager.shared.storeString("yes", "isLoogedIn");
      await SharedManager.shared.storeString("no", "isSocialLogin");
      await SharedManager.shared.storeUserLoginData(data);
      SharedManager.shared.isLoggedIN = "yes";
      Navigator.pop(context);
      SharedManager.shared.currentIndex = 2;
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => TabBarScreen()),
          ModalRoute.withName(AppRoute.tabbar));
    } else {
      Navigator.pop(context);
      SharedManager.shared.showAlertDialog(data.message, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return Scaffold(
      key: _scaffoldkey,
      body: Container(
        color: AppColor.white,
        child: Column(
          children: <Widget>[
            setHeight(60),
            Stack(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  // color: AppColor.red,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: AssetImage(AppImages.appLogo),
                      ),
                      setCommonText(S.current.food_zone, AppColor.black54, 20.0,
                          FontWeight.w500, 1)
                    ],
                  ),
                ),
                Positioned(
                    top: 40,
                    right: 12,
                    child: InkWell(
                      onTap: () {
                        SharedManager.shared.currentIndex = 2;
                        Navigator.of(context, rootNavigator: true)
                            .pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => TabBarScreen()),
                                ModalRoute.withName(AppRoute.tabbar));
                      },
                      child: setCommonText(S.current.skip, AppColor.black, 16.0,
                          FontWeight.w500, 1),
                    ))
              ],
            ),
            Container(
              padding: EdgeInsets.only(right: 20, left: 20),
              // color: AppColor.amber,
              child: Column(
                children: <Widget>[
                  Container(
                    // height: 60,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: '${S.current.email}'),
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: AppColor.grey,
                              fontFamily: SharedManager.shared.fontFamilyName),
                        ),
                        Container(
                          height: 1,
                          color: AppColor.black38,
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    // height: 60,
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: TextFormField(
                                controller: passwordController,
                                obscureText: this.isSecure ? true : false,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: '${S.current.password}'),
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: AppColor.grey,
                                    fontFamily:
                                        SharedManager.shared.fontFamilyName),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  this.isSecure = !this.isSecure;
                                });
                              },
                              child: Icon(
                                this.isSecure
                                    ? Icons.visibility_off
                                    : Icons.remove_red_eye,
                                color: this.isSecure
                                    ? AppColor.grey
                                    : AppColor.black54,
                                size: 20.0,
                              ),
                            )
                          ],
                        ),
                        Container(
                          height: 1,
                          color: AppColor.black38,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ForgotPassword()));
                              },
                              child: setCommonText(
                                  '${S.current.forgotPassword}',
                                  AppColor.grey,
                                  14.0,
                                  FontWeight.w500,
                                  1),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          });
                      _setLoginMethod();
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          color: AppColor.themeColor,
                          borderRadius: BorderRadius.circular(5)),
                      child: Center(
                        child: setCommonText('${S.current.login}',
                            AppColor.white, 16.0, FontWeight.bold, 1),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      setCommonText('${S.current.dont_have_account}',
                          AppColor.grey, 14.0, FontWeight.w500, 1),
                      SizedBox(
                        width: 4,
                      ),
                      InkWell(
                        onTap: () {
                          //SignUpPage
                          //OTPVerificationPage
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SignUpPage(
                                    isFromLoginPage: true,
                                  )));
                        },
                        child: setCommonText('${S.current.register}',
                            AppColor.themeColor, 15.0, FontWeight.bold, 1),
                      )
                    ],
                  ),
                  SizedBox(height: 25),
                  Container(
                    height: 45,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: InkWell(
                          onTap: () {
                            _loginWithFacebook();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: AppColor.facebookBG,
                                borderRadius: BorderRadius.circular(5)),
                            child: Center(
                              child: setCommonText('${S.current.facebook}',
                                  AppColor.white, 16.0, FontWeight.bold, 1),
                            ),
                          ),
                        )),
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                            child: InkWell(
                          onTap: () {
                            // _logOut();
                            signInWithGoogle().then((result) {
                              if (result != null) {
                                print(result);
                                _loginWithSocialMedia(
                                    '2', nameGoogle, emailGoogle, idGoogle, '');
                              }
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: AppColor.googleBG,
                                borderRadius: BorderRadius.circular(5)),
                            child: Center(
                              child: setCommonText('${S.current.google}',
                                  AppColor.white, 16.0, FontWeight.bold, 1),
                            ),
                          ),
                        )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
