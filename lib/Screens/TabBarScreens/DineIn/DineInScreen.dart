import 'package:flutter/material.dart';
import 'package:product/Helper/CommonWidgets.dart';
import 'package:product/Helper/Constant.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:product/Screens/DineInScreen/DineInRestaurantDetails.dart';

class DineInScreen extends StatefulWidget {
  @override
  _DineInScreenState createState() => _DineInScreenState();
}

class _DineInScreenState extends State<DineInScreen> {
  var message = 'Please enter your login credentials for host the meeting';
  int state = 1;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  bool isDineIn = true;
  bool isPickup = false;
  var pickupTime = 'Select Pickup Time';

  _setTime() {
    return DatePicker.showTime12hPicker(context,
        theme: DatePickerTheme(),
        showTitleActions: true,
        currentTime: DateTime.utc(1), onConfirm: (time) {
      print("selected Time:$time");
      setState(() {
        pickupTime = "${time.hour} hour & ${time.minute} mints";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final double height = 230;
    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ClipPath(
              clipper: BezierClipper(state),
              child: Container(
                  padding: EdgeInsets.only(left: 15, right: 15),
                  width: MediaQuery.of(context).size.width,
                  color: AppColor.themeColor,
                  height: height,
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              setCommonText('Welcom To', AppColor.white, 30.0,
                                  FontWeight.bold, 1),
                              Icon(
                                Icons.qr_code,
                                color: AppColor.white,
                                size: 45,
                              )
                            ],
                          ),
                          setCommonText('Dine In', AppColor.white, 30.0,
                              FontWeight.bold, 1),
                          SizedBox(
                            height: 3,
                          ),
                          setCommonText(
                              'We are welcome to you and your family. Please fill bellow details for the order.',
                              AppColor.white,
                              16.0,
                              FontWeight.w400,
                              3),
                          SizedBox(
                            height: 30,
                          ),
                        ],
                      ))),
            ),
            Container(
              padding: EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 8),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 50,
                      // color: AppColor.red,
                      child: Column(
                        children: [
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                border: InputBorder.none, hintText: 'Name*'),
                          ),
                          Container(
                            height: 1,
                            color: AppColor.grey[400],
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      height: 50,
                      // color: AppColor.red,
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                                border: InputBorder.none, hintText: 'Email*'),
                          ),
                          Container(
                            height: 1,
                            color: AppColor.grey[400],
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      height: 50,
                      // color: AppColor.red,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Checkbox(
                                      value: this.isDineIn,
                                      onChanged: (val) {
                                        setState(() {
                                          this.isDineIn = true;
                                          this.isPickup = false;
                                        });
                                      },
                                    ),
                                    setCommonText('Dine In', AppColor.black54,
                                        18.0, FontWeight.w600, 1)
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Checkbox(
                                      value: this.isPickup,
                                      onChanged: (val) {
                                        setState(() {
                                          this.isPickup = true;
                                          this.isDineIn = false;
                                        });
                                      },
                                    ),
                                    setCommonText('Pickup', AppColor.black54,
                                        18.0, FontWeight.w600, 1)
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    (this.isDineIn)
                        ? Container(
                            height: 50,
                            // color: AppColor.red,
                            child: Column(
                              children: [
                                TextFormField(
                                  keyboardType: TextInputType.numberWithOptions(
                                      signed: true),
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Table No*'),
                                ),
                                Container(
                                  height: 1,
                                  color: AppColor.grey[400],
                                )
                              ],
                            ),
                          )
                        : Container(
                            height: 50,
                            // color: AppColor.red,
                            child: InkWell(
                              onTap: () {
                                _setTime();
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  (pickupTime == 'Select Pickup Time')
                                      ? setCommonText(
                                          'Select Pickup Time',
                                          AppColor.red,
                                          16.0,
                                          FontWeight.w500,
                                          1)
                                      : Row(
                                          children: [
                                            setCommonText(
                                                'Pickup Time: ',
                                                AppColor.black54,
                                                16.0,
                                                FontWeight.w500,
                                                1),
                                            setCommonText(
                                                '$pickupTime',
                                                AppColor.red,
                                                16.0,
                                                FontWeight.w500,
                                                1),
                                          ],
                                        ),
                                  SizedBox(height: 8),
                                  Container(
                                    height: 1,
                                    color: AppColor.grey[400],
                                  )
                                ],
                              ),
                            ),
                          ),
                    setHeight(25),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => DineInRestaurantDetails()));
                      },
                      child: Container(
                        height: 45,
                        decoration: BoxDecoration(
                            color: AppColor.themeColor,
                            borderRadius: BorderRadius.circular(5)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            setCommonText('SCANE NOW', AppColor.white, 16.0,
                                FontWeight.w500, 1),
                            Icon(Icons.qr_code, color: AppColor.white, size: 25)
                          ],
                        ),
                      ),
                    )
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}

class BezierClipper extends CustomClipper<Path> {
  BezierClipper(this.state);

  final int state;

  @override
  Path getClip(Size size) => _getInitialClip(size);

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;

  Path _getInitialClip(Size size) {
    Path path = new Path();
    path.lineTo(0, size.height * 0.90); //vertical line
    path.cubicTo(size.width / 3, size.height, 2 * size.width / 3,
        size.height * 0.7, size.width, size.height * 0.75); //cubic curve
    path.lineTo(size.width, 0); //vertical line
    return path;
  }
}
