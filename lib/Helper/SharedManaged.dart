import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:product/Helper/Constant.dart';
import 'package:product/ModelClass/ModelRestaurantDetails.dart';
import 'package:product/ModelClass/ModelSocialLogin.dart';
import 'package:product/ModelClass/ModelUserLogin.dart';
import 'package:product/generated/i18n.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' show cos, sqrt, asin;
import 'package:http/http.dart' as http;
import 'dart:convert';

class SharedManager {
  static final SharedManager shared = SharedManager._internal();

  factory SharedManager() {
    return shared;
  }

  SharedManager._internal();

  var fontFamilyName = "Quicksand";
  bool isRTL = false;
  var direction = TextDirection.ltr;
  var address = "Select Address";
  var latitude = 0.0;
  var longitude = 0.0;
  var addressId = "";
  var deliveryAddressName = "";
  var deliveryAddressNumber = "";
  var restaurantID = "";
  var userID = "1";
  var oldResID = "";
  var resName = "";
  var resAddress = "";
  var resImage = "";
  bool isFromTab = false;
  bool isFromCart = false;
  int currentIndex = 2;
  var isLoggedIN = "no";
  var token = "";
  String resLatitude = "";
  String resLongitude = "";
  String orderId = "";
  //Set Distance Radius.
  //Order is only applicable between 15kms.
  double distanceFilter = 15.0;
  int deliveryCharge = 0;
  //We have set 30 second for updating driver location every time.
  //during order tracking.
  //you can set according to your requirements.
  int updateDriver = 30;

  //Couponcode Functionality
  //Make sure after order complete it should be clear

  bool isCouponApplied = false;
  var discountType = "";
  var discount = "0";
  var discountPice = "0";
  double tempTotalPrice = 0.0;
  var couponCode = '';
  final FacebookLogin facebookSignIn = new FacebookLogin();
//Driver Details
  var driverName = '';
  var driverImage = '';
  var driverReview = '';
  var driverPhone = '';

  var defaultDialCode = '+91';

  List<Subcategories> cartItems = [];

  ValueNotifier<Locale> locale = new ValueNotifier(Locale('en', ''));
  // final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  storeLocationCoordinate(LatLng coordinates) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (coordinates.latitude != 0.0 || coordinates.longitude != 0.0) {
      await prefs.setDouble("latitude", coordinates.latitude);
      await prefs.setDouble("longitude", coordinates.longitude);
    }
  }

  Future<bool> set(key, value) async {
    final shareSave = await SharedPreferences.getInstance();

    return shareSave.setString(key, value);
  }

  Future<String> get(key) async {
    final shareSave = await SharedPreferences.getInstance();
    return shareSave.getString(key);
  }

  Future<LatLng> getLocationCoordinate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    this.latitude = prefs.get("latitude");
    this.longitude = prefs.get("longitude");
    var latlong = LatLng(latitude, longitude);

    return latlong;
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }

  storeUserLoginData(UserLogin data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(DefaultKeys.userName, data.result.name);
    await prefs.setString(DefaultKeys.userEmail, data.result.email);
    await prefs.setString(DefaultKeys.userId, data.result.userId);
    await prefs.setString(DefaultKeys.userAddress, data.result.address);
    await prefs.setString(DefaultKeys.userPhone, data.result.phone);
    await prefs.setString(DefaultKeys.userImage, data.result.profileImage);
  }

  storeUserSocialLoginData(ResSocialLogin data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(DefaultKeys.userName, data.userData.name);
    await prefs.setString(DefaultKeys.userEmail, data.userData.email);
    await prefs.setString(DefaultKeys.userId, data.userData.userId);
    await prefs.setString(DefaultKeys.userAddress, data.userData.address);
    await prefs.setString(DefaultKeys.userPhone, data.userData.phone);
    await prefs.setString(DefaultKeys.userImage, data.userData.profileImage);
  }

  Future<String> getPushToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.get(DefaultKeys.pushToken);
    if (token != null) {
      return token;
    }
    return "";
  }

  Future<String> userName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var name = prefs.get(DefaultKeys.userName);
    if (name != null) {
      return name;
    }
    return "";
  }

  Future<String> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var isLoogedIn = prefs.get(DefaultKeys.isLoggedIn);
    if (isLoogedIn != null) {
      return isLoogedIn;
    }
    return "no";
  }

  Future<String> userEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var email = prefs.get(DefaultKeys.userEmail);
    if (email != null) {
      return email;
    }
    return "";
  }

  Future<String> userImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userImage = prefs.get(DefaultKeys.userImage);
    if (userImage != null) {
      return userImage;
    }
    return "";
  }

  Future<String> userPhone() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userPhone = prefs.get(DefaultKeys.userPhone);
    if (userPhone != null) {
      return userPhone;
    }
    return "";
  }

  Future<String> userId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.get(DefaultKeys.userId);
    if (userId != null) {
      return userId;
    }
    return "";
  }

  Future<String> userAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userAddress = prefs.get(DefaultKeys.userAddress);
    if (userAddress != null) {
      return userAddress;
    }
    return "";
  }

  storeString(String value, String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  Future<String> getStrng(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final value = prefs.get(key);
    if (value != null) {
      return value;
    } else {
      return "";
    }
  }

  void showAlertDialog(String message, BuildContext context) {
    //This is for the android toast
    Platform.isAndroid
        ? Fluttertoast.showToast(
            msg: "$message",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 14.0)
        :
        //THis is for IOS Alert
        new CupertinoAlertDialog(
            title: new Text("${S.current.food_zone}"),
            content: new Text("$message"),
            actions: <Widget>[
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                isDefaultAction: true,
                child: Text("OK"),
              ),
            ],
          );
  }

//Calculate Distance between two location.

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }
}

class GoogleMapsServices {
  Future<String> getRouteCoordinates(LatLng l1, LatLng l2) async {
    String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${l1.latitude},${l1.longitude}&destination=${l2.latitude},${l2.longitude}&key=${Keys.directionAPI}";
    http.Response response = await http.get(Uri.parse(url));
    print("params------>>>>>>(${l1.longitude}, ${l1.latitude})\t(${l2.longitude}, ${l2.latitude})");
    print("values------>>>>>>${response.body}");
    Map values = jsonDecode(response.body);

    return values["routes"].length==0?'':values["routes"][0]["overview_polyline"]["points"];
  }
}
