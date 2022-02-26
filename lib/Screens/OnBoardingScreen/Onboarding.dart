import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:product/Helper/Constant.dart';
import 'package:product/Helper/LocationManager.dart';
import 'package:product/Helper/SharedManaged.dart';
import 'package:product/Screens/TabBarScreens/TabScreen/TabBar.dart';
import 'package:transformer_page_view/transformer_page_view.dart';

import '../../main.dart';

void main() => runApp(new Onboarding());

class Onboarding extends StatefulWidget {
  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final List<String> images = [
    "Assets/Onboarding/ob1.png",
    "Assets/Onboarding/ob2.png",
    "Assets/Onboarding/ob3.png",
    "Assets/Onboarding/ob4.png",
  ];
  int slideIndex = 0;
  final IndexController controller = IndexController();

  _getAddressFromCurrentLocation(LatLng coordinate) async {
    // var coordinate = await SharedManager.shared.getLocationCoordinate();
    print("Stored Location:$coordinate");

    final coordinates =
        new Coordinates(coordinate.latitude, coordinate.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    print('${first.addressLine}, ${first.featureName}');
    setState(() {
      if (first.addressLine != null) {
        SharedManager.shared.address = first.addressLine;
      }
    });
  }

  _setAddressState() async {
    _getAddressFromCurrentLocation(
        await SharedManager.shared.getLocationCoordinate());
  }

  @override
  void initState() {
    LocationManager.shared.getCurrentLocation();
    _setAddressState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TransformerPageView transformerPageView = TransformerPageView(
        onPageChanged: (value) {
          print("Value:$value");
          setState(() {
            slideIndex = value;
          });
        },
        loop: false,
        controller: controller,
        transformer: new PageTransformerBuilder(
            builder: (Widget child, TransformInfo info) {
          return new Material(
            color: AppColor.white,
            textStyle: new TextStyle(color: AppColor.white),
            borderRadius: new BorderRadius.circular(12.0),
            child: new Container(
              decoration: BoxDecoration(
                  image:
                      DecorationImage(image: AssetImage(images[info.index]))),
            ),
          );
        }),
        itemCount: images.length);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: AppColor.white,
          body: new Stack(
            children: <Widget>[
              transformerPageView,
              new Positioned(
                top: 40,
                left: 10,
                child: new Chip(
                  backgroundColor: AppColor.grey[200],
                  label: (this.slideIndex == 3)
                      ? new GestureDetector(
                          onTap: () async {
                            await SharedManager.shared
                                .storeString("no", "isLoogedIn");
                            Navigator.of(context, rootNavigator: true)
                                .pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) => TabBarScreen()),
                                    ModalRoute.withName(AppRoute.tabbar));
                          },
                          child: new Text(
                            '  Home  ',
                            style: new TextStyle(
                              fontFamily: SharedManager.shared.fontFamilyName,
                            ),
                          ),
                        )
                      : new GestureDetector(
                          onTap: () async {
                            await SharedManager.shared.storeString("no", "isLoogedIn");
                            Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => TabBarScreen()), ModalRoute.withName(AppRoute.tabbar));
                          },
                          child: new Text('  Skip  ',
                              style: new TextStyle(
                                fontFamily: SharedManager.shared.fontFamilyName,
                              )),
                        ),
                ),
              ),
              Positioned(
                right:0,
                child: SafeArea(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: 15,
                    color: Colors.black,
                  ),
                ),
              ),
               Positioned(
                right:10,
                bottom: 70,
                child: Container(child: IconButton(
                    onPressed: () async{
                // code for next page
                      if(slideIndex!=images.length-1)
                      setState(() {
                        slideIndex++;
                        controller.move(slideIndex);
                      });
                      else{
                        await SharedManager.shared.storeString("no", "isLoogedIn");
                        Navigator.of(context, rootNavigator: true)
                            .pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => Login_SignUP_Option_Screen()),
                            ModalRoute.withName(AppRoute.tabbar));
                      }
                  
                },icon: Icon(Icons.arrow_forward,color: AppColor.white,)),
                  decoration:BoxDecoration(color: Colors.black,
                  borderRadius: BorderRadius.only(topLeft:Radius.circular(20),
                  bottomLeft: Radius.circular(20))),
                  height:40,
                  width: 100,
                  
                ),
              ),
            ],
          ),
        ));
  }
}
