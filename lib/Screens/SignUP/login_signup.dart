import 'package:flutter/material.dart';
import 'package:product/Helper/Constant.dart';
import 'package:product/Screens/ForgotPassword/forgotPassword.dart';
import 'package:product/Screens/Login/LoginPage.dart';
import 'package:product/Screens/SignUP/SignUp.dart';
import 'package:product/generated/i18n.dart';

class LoginSignUpScreen extends StatefulWidget {
  bool isLoginSelected;
  LoginSignUpScreen({Key key, this.isLoginSelected=false}) : super(key: key);

  @override
  _LoginSignUpScreenState createState() => _LoginSignUpScreenState();
}

class _LoginSignUpScreenState extends State<LoginSignUpScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bodyColor,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height*.1,),
            CircleAvatar(
              radius: 60,
              child: Image.asset(AppImages.appLogo,fit: BoxFit.contain,),
            ),
            Expanded(
              child: Stack(
                children: [
                  widget.isLoginSelected
                      ?LoginPage()
                      :SignUpPage(),
                  Positioned(
                    right: 0,
                    bottom: 110,
                    child: InkWell(
                      onTap: () async{
                        setState(() {
                          widget.isLoginSelected = true;
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration:BoxDecoration(
                            color: widget.isLoginSelected?Colors.black:Colors.grey,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(100),
                              topLeft: Radius.circular(100),
                            )
                        ),
                        height:widget.isLoginSelected?50:45,
                        width: 100,
                        child: Text(
                          'Log In',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 50,
                    child: Container(
                      width: MediaQuery.of(context).size.width-20,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          widget.isLoginSelected
                              ? InkWell(
                            onTap: () async{
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => ForgotPassword()));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '${S.current.forgotPassword}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          )
                              : InkWell(
                            onTap: () async{
                              setState(() {
                                widget.isLoginSelected = true;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '${S.current.haveUnAccount}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () async{
                              setState(() {
                                widget.isLoginSelected = false;
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              decoration:BoxDecoration(
                                  color: widget.isLoginSelected?Colors.grey:Colors.black,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(100),
                                    topLeft: Radius.circular(100),
                                  )
                              ),
                              height:widget.isLoginSelected?45:50,
                              width: 100,
                              child: Text(
                                'Sing Up',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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
