import 'package:flutter/material.dart';
import 'package:product/Helper/CommonWidgets.dart';
import 'package:product/Helper/Constant.dart';
import 'package:product/generated/i18n.dart';

void main() => runApp(new SupportScreen());

class SupportScreen extends StatefulWidget {
  @override
  _SupportScreenState createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColor.white),
        elevation: 0.0,
        backgroundColor: AppColor.themeColor,
        centerTitle: true,
        title: setCommonText(
            S.current.support, AppColor.white, 20.0, FontWeight.w500, 1),
      ),
      body: new Container(
        child: new Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              color: AppColor.bodyColor,
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('Assets/images/mail.png'))),
                  ),
                  SizedBox(height: 5),
                  // setCommonText(S.current.contactUs, AppColor.white, 20.0,
                  //     FontWeight.bold, 1),
                  setHeight(20),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              color: AppColor.bodyColor,
              padding: new EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  // mainAxisAlignment: MainAxisAlignment.start,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Icon(Icons.place, color: AppColor.red, size: 30),
                      SizedBox(width: 5),
                      Flexible(
                        child: Text(
                          '220, Satyam Corporate, Near Plaza Complex, United State +123423456',
                          style: TextStyle(
                            color: AppColor.black87,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              color: AppColor.bodyColor,
              padding: new EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  // mainAxisAlignment: MainAxisAlignment.start,
                  Row(
                    children: <Widget>[
                      SizedBox(height: 5),
                      Icon(Icons.mobile_screen_share,
                          color: AppColor.red, size: 30),
                      SizedBox(width: 10),
                      Text(
                        '+123423456',
                        style: TextStyle(
                          color: AppColor.black87,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              color: AppColor.bodyColor,
              padding: new EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  // mainAxisAlignment: MainAxisAlignment.start,
                  Row(
                    children: <Widget>[
                      SizedBox(height: 5),
                      Icon(Icons.computer, color: AppColor.red, size: 30),
                      SizedBox(width: 10),
                      Text(
                        '${S.current.email}:test@hotmail.com',
                        style: TextStyle(
                          color: AppColor.black87,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              color: AppColor.bodyColor,
              padding: new EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  // mainAxisAlignment: MainAxisAlignment.start,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 5),
                      Icon(Icons.watch_later, color: AppColor.red, size: 30),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Monday to Friday: \t9am to 10pm',
                            style: TextStyle(
                              color: AppColor.black87,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            'Saturday to Sunday\t10pm to 5pm',
                            style: TextStyle(
                              color: AppColor.black87,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ],
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
