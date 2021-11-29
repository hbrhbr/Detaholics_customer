import 'dart:convert';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:product/Helper/CommonWidgets.dart';
import 'package:product/Helper/Constant.dart';
import 'package:product/Helper/LocationManager.dart';
import 'package:product/Helper/RequestManager.dart';
import 'package:product/Helper/SharedManaged.dart';
import 'package:product/Screens/Login/SocialLogin/sign_in.dart';
import 'package:product/Screens/TabBarScreens/TabScreen/TabBar.dart';
import 'package:product/generated/i18n.dart';
import 'package:http/http.dart' as http;

// void main() => runApp(new SignUpPage());
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(SignUpPage());
}

class SignUpPage extends StatefulWidget {
  final bool isFromLoginPage;
  SignUpPage({Key key, this.isFromLoginPage}) : super(key: key);
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  static TextEditingController userNameController = new TextEditingController();
  static TextEditingController emailController = new TextEditingController();
  static TextEditingController passwordController = new TextEditingController();
  static TextEditingController phoneController = new TextEditingController();

  static double latitude = 0.0;
  static double longitude = 0.0;
  bool isSecure = true;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

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
            '0', profile['name'], profile['email'], profile['id'], data['url']);
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

  _loginWithSocialMedia(
      String type, String name, String email, String id, String image) async {
    final param = {
      "email": email,
      "name": name,
      "phone": "123456",
      "latitude": "${SharedManager.shared.latitude}",
      "longitude": "${SharedManager.shared.longitude}",
      "social_id": id,
      "is_social_login": '1',
      "device_token": '${SharedManager.shared.token}',
      "profile_image": '$image'
    };
    print('User Parameters:======>$param');

    showSnackbar("${S.current.loading}", _scaffoldKey, context);
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
        // Navigator.pop(context);
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
    //Select default language
    LocationManager.shared.getCurrentLocation();
    _getUserCurrentLocation();
    emailController.text = "";
  }

  _getUserCurrentLocation() async {
    LatLng coordinate = await SharedManager.shared.getLocationCoordinate();
    latitude = coordinate.latitude;
    longitude = coordinate.longitude;
  }

  _actionMethodRegistration(BuildContext context) async {
    print(emailController.text);
    print(passwordController.text);
    print(phoneController.text);
    print(userNameController.text);

    var url = APIS.registration;
    var param = {
      "name": userNameController.text,
      "email": emailController.text,
      "password": passwordController.text,
      "device_token": SharedManager.shared.token,
      "phone": phoneController.text,
      "latitude": latitude.toString(),
      "longitude": longitude.toString()
    };

//Uncomment If you want to do normal registration
    _doRegistration(param, url, context);

//UnCommnet If you want to use OTP Authentication

    // await loginUser(
    //     '${SharedManager.shared.defaultDialCode}${phoneController.text}',
    //     context,
    //     param,
    //     url);
  }

//First you have to make OTP Verifcation
//After Verf the OTP Registration Process will be done
  // Future<void> loginUser(
  //     String phone, BuildContext context, dynamic param, String apiUrl) async {
  //   await Firebase.initializeApp();
  //   FirebaseAuth _auth = FirebaseAuth.instance;
  //   final _codeController = TextEditingController();

  //   print('Phone no is:$phone');
  //   showSnackbar('${S.current.loading}', _scaffoldKey, context);;

  //   _auth.verifyPhoneNumber(
  //       phoneNumber: phone,
  //       timeout: Duration(seconds: 60),
  //       verificationCompleted: (AuthCredential credential) async {
  //         ScaffoldMessenger.of(context).hideCurrentSnackBar();
  //         Navigator.of(context).pop();
  //         UserCredential result = await _auth.signInWithCredential(credential);
  //         User user = result.user;

  //         if (user != null) {
  //           // SharedManager.shared
  //           //     .showAlertDialog('OTP Verification Done', context);
  //           _doRegistration(param, apiUrl, context);
  //         } else {
  //           print("Error");
  //         }

  //         //This callback would gets called when verification is done auto maticlly
  //       },
  //       verificationFailed: (FirebaseAuthException exception) {
  //         ScaffoldMessenger.of(context).hideCurrentSnackBar();
  //         print(exception.message);
  //         SharedManager.shared.showAlertDialog('${exception.message}', context);
  //       },
  //       codeSent: (String verificationId, [int forceResendingToken]) {
  //         ScaffoldMessenger.of(context).hideCurrentSnackBar();
  //         showDialog(
  //             context: context,
  //             barrierDismissible: false,
  //             builder: (context) {
  //               return AlertDialog(
  //                 title: Text("Please Enter the Verification Code"),
  //                 content: Column(
  //                   mainAxisSize: MainAxisSize.min,
  //                   children: <Widget>[
  //                     TextField(
  //                       keyboardType: TextInputType.numberWithOptions(
  //                           decimal: true, signed: true),
  //                       controller: _codeController,
  //                     ),
  //                   ],
  //                 ),
  //                 actions: <Widget>[
  //                   FlatButton(
  //                     child: Text("Confirm"),
  //                     textColor: Colors.white,
  //                     color: Colors.blue,
  //                     onPressed: () async {
  //                       final code = _codeController.text.trim();
  //                       AuthCredential credential =
  //                           PhoneAuthProvider.credential(
  //                               verificationId: verificationId, smsCode: code);

  //                       UserCredential result =
  //                           await _auth.signInWithCredential(credential);

  //                       User user = result.user;

  //                       if (user != null) {
  //                         // Navigator.push(
  //                         //     context,
  //                         //     MaterialPageRoute(
  //                         //         builder: (context) => HomeScreen(
  //                         //               user: user,
  //                         //             )));
  //                         // Navigator.of(context).pop();
  //                         // SharedManager.shared.showAlertDialog(
  //                         //     'OTP Verification Done', context);
  //                         _doRegistration(param, apiUrl, context);
  //                       } else {
  //                         print("Error");
  //                       }
  //                     },
  //                   )
  //                 ],
  //               );
  //             });
  //       },
  //       codeAutoRetrievalTimeout: (String verificationId) {});
  // }

  _doRegistration(dynamic param, String url, BuildContext context) async {
    showSnackbar('${S.current.loading}', _scaffoldKey, context);
    var manager = Requestmanager();
    await manager
        .requestForUserRegistration(url, true, param)
        .then((data) async {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      if (data.code == 1) {
        emailController.text = '';
        passwordController.text = '';
        phoneController.text = '';
        userNameController.text = '';
        await SharedManager.shared.storeString("yes", "isLoogedIn");
        await SharedManager.shared.storeString("no", "isSocialLogin");
        await SharedManager.shared.storeUserLoginData(data);
        SharedManager.shared.currentIndex = 2;
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => TabBarScreen()),
            ModalRoute.withName(AppRoute.tabbar));
      } else {
        // Navigator.pop(context);
        SharedManager.shared.showAlertDialog(data.message, context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        color: AppColor.white,
        child: Column(
          children: <Widget>[
            Expanded(
                flex: 1,
                child: Stack(
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
                          setCommonText(S.current.food_zone, AppColor.black54,
                              20.0, FontWeight.w500, 1)
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
                          child: setCommonText(S.current.skip, AppColor.black,
                              16.0, FontWeight.w500, 1),
                        ))
                  ],
                )),
            Expanded(
                flex: 3,
                child: Container(
                  padding: EdgeInsets.only(right: 20, left: 20),
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              controller: userNameController,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: '${S.current.full_name}'),
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: AppColor.black,
                                  fontFamily:
                                      SharedManager.shared.fontFamilyName),
                            ),
                            Container(
                              height: 1,
                              color: AppColor.black38,
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Container(
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
                                  color: AppColor.black,
                                  fontFamily:
                                      SharedManager.shared.fontFamilyName),
                            ),
                            Container(
                              height: 1,
                              color: AppColor.black38,
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Container(
                        child: Row(
                          children: [
                            Container(
                              width: 50,
                              // color: AppColor.red,
                              child: Column(
                                children: [
                                  Container(
                                    width: 70,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Center(
                                      child: SizedBox(
                                        height: 45,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: CountryCodePicker(
                                            showFlagMain: false,
                                            onChanged: (e) {
                                              print(e.dialCode);
                                              SharedManager.shared
                                                  .defaultDialCode = e.dialCode;
                                            },
                                            initialSelection: 'IN',
                                            favorite: ['+91', 'IN'],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  setHeight(3),
                                  Container(
                                    width: 45,
                                    height: 1,
                                    color: AppColor.grey,
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                                child: Column(
                              children: <Widget>[
                                TextFormField(
                                  controller: phoneController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: '${S.current.phone}'),
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: AppColor.black,
                                      fontFamily:
                                          SharedManager.shared.fontFamilyName),
                                ),
                                Container(
                                  height: 1,
                                  color: AppColor.black38,
                                )
                              ],
                            ))
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 25,
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
                                        color: AppColor.black,
                                        fontFamily: SharedManager
                                            .shared.fontFamilyName),
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
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      InkWell(
                        onTap: () {
                          var validator = SharedManager.shared
                              .validateEmail(emailController.text);

                          if (userNameController.text == "") {
                            SharedManager.shared.showAlertDialog(
                                S.current.not_a_valid_full_name, context);
                            return;
                          } else if (emailController.text == "" &&
                              validator == S.current.email) {
                            SharedManager.shared.showAlertDialog(
                                S.current.pleaseEnterEmail, context);
                            return;
                          } else if (phoneController.text == "") {
                            SharedManager.shared.showAlertDialog(
                                S.current.not_a_valid_phone, context);
                            return;
                          } else if (passwordController.text == "" &&
                              (passwordController.text.length < 5)) {
                            SharedManager.shared.showAlertDialog(
                                S.current.wrong_email_or_password, context);
                            return;
                          }
                          _actionMethodRegistration(context);
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                              color: AppColor.themeColor,
                              borderRadius: BorderRadius.circular(5)),
                          child: Center(
                            child: setCommonText('${S.current.register}',
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
                          setCommonText('${S.current.haveUnAccount}',
                              AppColor.grey, 14.0, FontWeight.w500, 1),
                          SizedBox(
                            width: 4,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: setCommonText('${S.current.login}',
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
                                    _loginWithSocialMedia('0', nameGoogle,
                                        emailGoogle, idGoogle, '');
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
                )),
          ],
        ),
      ),
    );
  }
}

/*
return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new Scaffold(
        body: new Stack(
              children: <Widget>[
                new Container(
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(AppImages.background,
                    ),
                    fit: BoxFit.cover
                  )
                ),
              ),
              new Container(
                height: MediaQuery.of(context).size.height,
                color: AppColor.black.withOpacity(0.4),
              ),
                 new ListView(
              children: <Widget>[
                _setHeaderView(),
                _setFormView()
              ],
                ),
              ],
            ),
        ),
        routes: <String,WidgetBuilder>{
        AppRoute.signUp:(BuildContext context) => new SignUpPage()
        }
    );
 */

//AppID:ca-app-pub-8299041309330339~1673534621
