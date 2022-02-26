import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:product/Helper/Constant.dart';
import 'package:product/Helper/SharedManaged.dart';
import 'package:product/Screens/Cart/Cart.dart';
import 'package:product/Screens/CategoryListScreen/CategoryListScreen.dart';
import 'package:product/Screens/TabBarScreens/Dashboard/Dashboard.dart';
import 'package:product/Screens/TabBarScreens/DineIn/DineInScreen.dart';
import 'package:product/Screens/TabBarScreens/Orders/OrderScreen.dart';
import 'package:product/Screens/TabBarScreens/Profile/ProfileScreen.dart';
import 'package:product/Screens/TabBarScreens/SearchScreen/SearchScreen.dart';
import 'package:product/generated/i18n.dart';

void main() => runApp(new TabBarScreen());

class TabBarScreen extends StatefulWidget {
  @override
  _TabBarScreenState createState() => _TabBarScreenState(); 
}

class _TabBarScreenState extends State<TabBarScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  final List<Widget> _children = [
    DashboardApp(),
   // SearchScreen(),
    // DineInScreen(),
    // ProfileScreen(),
    CategoryListScreen(),
    CartApp(),
    OrderScreen(),
  ];

  _onTapped(int index) {
    setState(() {
      print("index $index");
      SharedManager.shared.isFromTab = true;
      SharedManager.shared.currentIndex = index;
    });
  }

  _setBottomBarIcons({int type=0,int navIndex}) {
    return new Container(
        height: 30,
        width: 30,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: AppColor.navgigabariconColor,
              //blurRadius: 5.0, // has the effect of softening the shadow
              spreadRadius: (type == 0)?0.0:1.0, // has the effect of extending the shadow
              offset: Offset(
                0.0, // horizontal, move right 10
                0.0, // vertical, move down 10
              ),
            )
          ],
          color: (type == 0) ? AppColor.white : AppColor.navgigabariconColor,
          borderRadius: new BorderRadius.circular(15),
        ),
        child: new Center(
          child: new Icon(
            navIndex==0?Icons.home:navIndex==1?Icons.flash_on:navIndex==2?Icons.shopping_cart:Icons.local_shipping,
            color: AppColor.grey,
            size: 23,
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return new Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: <Widget>[
          _children[SharedManager.shared.currentIndex],
        ],
      ),
      backgroundColor: AppColor.bodyColor,
      bottomNavigationBar: PhysicalModel(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(50),topRight:Radius.circular(50),),
        color: Colors.white,
        elevation: 12,
        child: new BottomNavigationBar(

          backgroundColor: AppColor.white,
          // elevation: 1,
          type: BottomNavigationBarType.fixed, //if you remove this tab bar will white.
          currentIndex: SharedManager.shared.currentIndex,
          selectedLabelStyle: TextStyle(
            color: AppColor.themeColor,
          ),
          selectedItemColor: AppColor.themeColor,
          onTap: _onTapped,
          items: [
            BottomNavigationBarItem(
                icon: _setBottomBarIcons(type: 0,navIndex: 0),
                activeIcon: _setBottomBarIcons(type: 1,navIndex: 0),
                label: '${S.current.home}'
            ),
            // BottomNavigationBarItem(
            //     icon: new Icon(Icons.qr_code, size: 25),
            //     activeIcon:
            //         new Icon(Icons.qr_code, color: AppColor.themeColor, size: 25),
            //     label: 'DineIn'),
            // BottomNavigationBarItem(
            //     icon: new Icon(Icons.search, size: 25),
            //     activeIcon:
            //         new Icon(Icons.search, color: AppColor.navgigabariconColor, size: 25),
            //     label: 'Search'),
            BottomNavigationBarItem(
                icon: _setBottomBarIcons(type: 0,navIndex: 1),
                activeIcon: _setBottomBarIcons(type: 1,navIndex: 1),
                label: '${S.current.categories}'),
            BottomNavigationBarItem(
                icon: _setBottomBarIcons(type: 0,navIndex: 2),
                activeIcon: _setBottomBarIcons(type: 1,navIndex: 2),
                label: '${S.current.cart}'),
            BottomNavigationBarItem(
                icon: _setBottomBarIcons(type: 0,navIndex: 3),
                activeIcon: _setBottomBarIcons(type: 1,navIndex: 3),
                label: '${S.current.orders}'),
          ],
        ),
      ),
    );
  }
}
