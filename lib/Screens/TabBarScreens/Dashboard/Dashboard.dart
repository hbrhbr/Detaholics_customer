import 'dart:async';
import 'package:product/BlocClass/MainModelBlocClass/RestaurantDetails.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoder/model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:product/BlocClass/MainModelBlocClass/DashboadBloc.dart';
import 'package:product/Helper/CommonWidgets.dart';
import 'package:product/Helper/Constant.dart';
import 'package:product/Helper/LocationManager.dart';
import 'package:product/Helper/SharedManaged.dart';
import 'package:product/ModelClass/Dashboard.dart';
import 'package:product/Provider/StoreProvider.dart';
import 'package:product/Screens/AllRestaurantList/Widgets/MealDealListviewWidget.dart';
import 'package:product/Screens/Cart/Cart.dart';
import 'package:product/Screens/SubcategoryListScreen/SubcategoryListScreen.dart';
import 'package:product/Screens/TabBarScreens/Orders/OrderScreen.dart';
import 'package:product/Screens/TabBarScreens/Profile/ProfileScreen.dart';
import 'package:product/Screens/TabBarScreens/Profile/Widgets/Top_search_widdget.dart';
import 'package:product/Screens/TabBarScreens/SearchScreen/SearchScreen.dart';
import 'package:product/generated/i18n.dart';
import 'package:product/main.dart';
import 'package:product/reuseablewidgets/HomescreenWidget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Widgets/BannerBottom.dart';
import 'Widgets/BannerFirst.dart';
import 'Widgets/BannerRestaurants.dart';
import 'Widgets/BannerSecond.dart';
import 'Widgets/CategoryList.dart';
import 'Widgets/MealDealItems.dart';
import 'Widgets/MostPopularResWidgets.dart';
import 'Widgets/TopRestaurantWidget.dart';
import 'package:place_picker/place_picker.dart';

void main() => runApp(new DashboardApp());

class DashboardApp extends StatefulWidget {
  DashboardApp({Key key, isOrderDone}) : super(key: key);

  @override
  _DashboardAppState createState() => _DashboardAppState();
}

class _DashboardAppState extends State<DashboardApp>
    with SingleTickerProviderStateMixin {
  var localAddress = "";
  var isOrderStates = "no";
  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: Keys.kGoogleApiKey);
  LatLng currentLocation;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  StoreProvider store = StoreProvider();
  TextEditingController _serchcontroller;
  // final List discountList = [
  //   {
  //     'discount': '14',
  //     'discountName': 'Foodis Friday',
  //     'velidity': '20th july 2020',
  //     'code': 'FooDy2020',
  //     'bannerImage': 'Assets/RestaurantDetails/RestaurantApp.jpg'
  //   },
  //   {
  //     'discount': '18',
  //     'discountName': 'July Special',
  //     'velidity': '18th july 2020',
  //     'code': 'July2020',
  //     'bannerImage': 'Assets/food.jpeg'
  //   },
  //   {
  //     'discount': '20',
  //     'discountName': 'Birthday Offer',
  //     'velidity': '22th july 2020',
  //     'code': 'HDOffer',
  //     'bannerImage': 'Assets/res.jpeg'
  //   },
  //   {
  //     'discount': '25',
  //     'discountName': 'Junmasti Special',
  //     'velidity': '25th july 2020',
  //     'code': 'KANHA2020',
  //     'bannerImage': 'Assets/RestaurantDetails/RestaurantApp.jpg'
  //   },
  // ];

  // final List categoryList = [
  //   {
  //     'title': 'Pizza',
  //     'bannerImage': 'Assets/RestaurantDetails/RestaurantApp.jpg'
  //   },
  //   {'title': 'Italiyan', 'bannerImage': 'Assets/food.jpeg'},
  //   {'title': 'Maxican', 'bannerImage': 'Assets/res.jpeg'},
  //   {
  //     'title': 'South Indian',
  //     'bannerImage': 'Assets/RestaurantDetails/RestaurantApp.jpg'
  //   },
  // ];

  String name ='User';
  String image;
  @override
  void initState() {
    // super.initState();
    LocationManager.shared.getCurrentLocation();
    SharedManager.shared.userName().then((value) {
      setState((){
        name = value;
      });
    });
    SharedManager.shared.userImage().then((value) {
      setState((){
        image = value;
      });
    });
    dashboardBloc.fetchDashboardData(APIS.dashBoard, []);
    _setStatus();
    // SharedManager.shared.setBannerAdds();

    super.initState();
  }

  @override
  void dispose() {
    // try {
    //   SharedManager.shared.myBanner.dispose();
    //   SharedManager.shared.myBanner = null;
    // } catch (ex) {
    //   print("banner dispose error");
    // }
    super.dispose();
  }

  _setStatus() async {
    final status = await SharedManager.shared.isLoggedIn();
    final userId = await SharedManager.shared.userId();
    // final token = await SharedManager.shared.getPushToken();

    print("Login Status:$status");
    print("User ID is:$userId");
    SharedManager.shared.isLoggedIN = status;
    SharedManager.shared.userID = userId;
    // SharedManager.shared.token = token;

    if (!this.store.isSearchAddress) {
      _getAddressFromCurrentLocation(
          await SharedManager.shared.getLocationCoordinate());
    } else {
      _getAddressFromCurrentLocation(currentLocation);
    }
  }

  _getAddressFromCurrentLocation(LatLng coordinate) async {
    // var coordinate = await SharedManager.shared.getLocationCoordinate();
    print("Stored Location:$coordinate");
    if (this.store.isSearchAddress) {
      ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
          content: setCommonText(
              '${S.current.pleaseWaitCollectiingNewRestaurants}',
              AppColor.white,
              15.0,
              FontWeight.w500,
              2)));
    }

    SharedManager.shared.latitude = coordinate.latitude;
    SharedManager.shared.longitude = coordinate.longitude;

    final coordinates =
        new Coordinates(coordinate.latitude, coordinate.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    print('${first.addressLine}, ${first.featureName}');
    setState(() {
      if (first.addressLine != null) {
        this.localAddress = first.addressLine;
      }
      if (first.featureName != null) {
        this.localAddress = this.localAddress + " " + first.featureName;
      }
      SharedManager.shared.address = localAddress;
      print("Final Address:---->$localAddress");
      dashboardBloc.fetchDashboardData(APIS.dashBoard, []);
    });
  }

  Future<Null> displayPrediction(var p) async {
    if (p != null) {
      var detail = await _places.getDetailsByPlaceId(p.placeId);

      double lat = detail.result.geometry.location.lat;
      double lng = detail.result.geometry.location.lng;

      setState(() {
        this.store.isSearchAddress = true;
        this.currentLocation = LatLng(lat, lng);
        _getAddressFromCurrentLocation(currentLocation);
      });
    }
  }

  void showPlacePicker() async {
    LocationResult result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PlacePicker(
              "${Keys.kGoogleApiKey}",
              displayLocation: LatLng(SharedManager.shared.latitude,
                  SharedManager.shared.longitude),
            )));

    // Handle the result in your way
    print(result.latLng);

    double lat = result.latLng.latitude;
    double lng = result.latLng.longitude;

    setState(() {
      this.currentLocation = LatLng(lat, lng);
      _getAddressFromCurrentLocation(currentLocation);
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    this.store = Provider.of<StoreProvider>(context);
    return SafeArea(
      top: true,
      child: new Scaffold(
          key: _scaffoldKey,
          backgroundColor: AppColor.bodyColor,
          body: Container(
            color: AppColor.bodyColor,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                searchforlocationwidget(ontap:(){showPlacePicker();},
                    leadingicon: Icons.notification_important_sharp,
                    hintext: SharedManager.shared.address.isEmpty?'search address':SharedManager.shared.address,
                    trailingicon:
                    SharedManager.shared.isLoggedIN=="yes"?
                    PopupMenuButton(
                      color: Colors.black,
                        key: Key("meNUKey"),
                        itemBuilder: (_) => <PopupMenuItem<String>>[
                          PopupMenuItem<String>(child: Text('Home',style: TextStyle(color: Colors.white),), value: '1'),
                          PopupMenuItem<String>(child: Text('Order',style: TextStyle(color: Colors.white),), value: '2'),
                          PopupMenuItem<String>(child: Text('Cart',style: TextStyle(color: Colors.white),), value: '3'),
                          PopupMenuItem<String>(child: Text('Profile',style: TextStyle(color: Colors.white),), value: '4'),
                          PopupMenuItem<String>(child: Text('Logout',style: TextStyle(color: Colors.white),), value: '5'),
                        ],
                        onSelected: (value) {
                        print("value:-> $value");

                        switch(value){
                          case '1':
                            break;
                          case '2':
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => OrderScreen()),
                            );
                            break;
                          case '3':
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => CartApp()),
                            );
                            break;
                          case '4':
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => ProfileScreen()),
                            );
                            break;
                          case '5':
                            SharedPreferences.getInstance().then((value) => value.clear());
                            Navigator.of(context).popUntil((predicate){
                              return predicate.isFirst;
                            });
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) => Login_SignUP_Option_Screen()),
                            );
                            break;
                        }
                        },
                      icon: Icon(Icons.menu),

                        ):Icon(Icons.menu),
                ),
                Expanded(
                  child: Center(
                    child: StreamBuilder(
                      stream: dashboardBloc.dashboardData,
                      builder: (context, AsyncSnapshot<Dashboard> snapshot) {
                        if (snapshot.hasData) {
                          // dashboardBloc.dispose();
                          var result = snapshot.data.result;
                          return new Container(
                            color: AppColor.bodyColor,
                            child: new ListView(
                              // shrinkWrap: true,
                              children: <Widget>[
                                // (result.bannerRestaurents.length > 0)
                                //     ? BannerRestaurants(width, result.bannerRestaurents)
                                //     : Text(''),
                                // SizedBox(height: 10),
                                 SizedBox(
                                   child: ProfileViewWidget(
                                       image: image,
                                       context: context,
                                       username: '$name',
                                       usermessage: 'good morning, happy to join us '),
                                      width: MediaQuery.of(context).size.width,
                                 ),
                                CategoryList(result.categories),
                                _setCommonDivider(),
                                (result.popularRestaurents.length > 0)
                                    ? PopularRestaurants(
                                        width, result.bannerRestaurents)
                                    : _setItemNotAvailableWidget(
                                        'Most Popular Item is not available'),
                                _setCommonDivider(),
                                // SizedBox(height: 5),
                                // (result.couponCodes.length > 0)
                                //     ? _setTodaysOfferWidgets(
                                //         context, result.couponCodes)
                                //     : SizedBox(
                                //         height: 0,
                                //       ),
                                // (discountList.length > 0)
                                //     ? SizedBox(
                                //         height: 15,
                                //       )
                                //     : SizedBox(
                                //         height: 0,
                                //       ),
                                // // SizedBox(height: 5),
                                // // _setCommonDivider(),
                                // // SizedBox(height: 5),
                                // // BannerFirst(),
                                // SizedBox(height: 5),
                                (result.mealDeal.length > 0)
                                    ? ListviewMealDashboardWidget(result. mealDeal)
                                    : _setItemNotAvailableWidget(
                                        'Meal Deals Item is not available'),
                                // // _setCommonDivider(),
                                // // SizedBox(height: 5),
                                // // BannerSecond(),
                                // SizedBox(height: 5),
                                // (result.topRestaurents.length > 0)
                                //     ? TopRestaurants(width, result.topRestaurents)
                                //     : _setItemNotAvailableWidget(
                                //         'Top Restaurant is not available'),
                                // BannerBottom()
                              ],
                            ),
                          );
                        } else {
                          return Container(
                            color: AppColor.bodyColor,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}

_setItemNotAvailableWidget(String title) {
  return Container(
      height: 100,
      margin: EdgeInsets.only(top: 5,left: 20),
      child: setCommonText('$title', AppColor.black87, 14.0, FontWeight.w500, 2));
}

_setCommonDivider() {
  return Container(color: AppColor.grey[100], height: 8);
}

_setTodaysOfferWidgets(BuildContext context, List<CouponCodes> discountList) {
  return new Container(
    height: 90,
    // color: AppColor.red,
    child: Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              setCommonText('${S.current.todaysOffers}', AppColor.black, 15.0,
                  FontWeight.w500, 1),
              // InkWell(
              //   onTap: () {},
              //   child: setCommonText(S.current.see_all, AppColor.themeColor, 16.0,
              //       FontWeight.w600, 1),
              // )
            ],
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Expanded(
            child: Container(
          color: AppColor.red[100],
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              // itemCount: discountList.length,
              itemCount: 20,
              itemBuilder: (context, index) {
                return new Container(
                    width: MediaQuery.of(context).size.width / 2.5,
                    padding: new EdgeInsets.only(
                        left: 4, right: 4, bottom: 0, top: 0),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: AppColor.grey[300]),
                          borderRadius: BorderRadius.circular(5)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(width: 8),
                          Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage('Assets/offer.png'))),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                              child: Container(
                                  child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                (discountList[index].discountType == '1')
                                    ? 'Flat ${discountList[index].discount}% off'
                                    : 'Upto ${discountList[index].discount}% off',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: AppColor.black87,
                                    fontFamily:
                                        SharedManager.shared.fontFamilyName),
                                textAlign: TextAlign.start,
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 5),
                              Container(
                                height: 26,
                                child: setCommonText(
                                    ' ${discountList[index].couponCode} ',
                                    AppColor.red,
                                    12.0,
                                    FontWeight.bold,
                                    1),
                              )
                            ],
                          ))),
                        ],
                      ),
                    ));
              }),
        ))
      ],
    ),
  );
}
