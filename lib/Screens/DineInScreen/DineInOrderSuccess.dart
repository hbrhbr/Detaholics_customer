import 'package:flutter/material.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:product/Helper/CommonWidgets.dart';
import 'package:product/Helper/Constant.dart';
import 'package:product/Helper/SharedManaged.dart';
import 'package:product/generated/i18n.dart';
import 'package:product/ModelClass/DineInCategoryClass.dart';

import '../../Helper/SharedManaged.dart';
import '../TabBarScreens/TabScreen/TabBar.dart';

class DineInOrderSuccess extends StatefulWidget {
  final List<ITEM> cartList;
  DineInOrderSuccess({this.cartList});
  @override
  _DineInOrderSuccessState createState() => _DineInOrderSuccessState();
}

class _DineInOrderSuccessState extends State<DineInOrderSuccess> {
  var message = '';

  String _getSize(List<SIZE> sizeList) {
    List<SIZE> arrayList = sizeList.where((i) => i.isSelected == '1').toList();
    if (arrayList.length > 0) {
      return arrayList[0].title;
    } else {
      return '';
    }
  }

  String _getExtra(List<EXTRA> extraList) {
    List<EXTRA> arrayList =
        extraList.where((i) => i.isSelected == '1').toList();
    if (arrayList.length > 0) {
      return arrayList[0].title;
    } else {
      return '';
    }
  }

  Future<void> _setWhatappMessage() async {
    // message = 'Order No:' + '#12345\n';
    // message = message + '\n ================================ \n';
    for (var item in this.widget.cartList) {
      message = message +
          'Item Name: ${item.itemName}\nItem Note: ${item.note}\nItem Quantity: ${item.quantity}\nExtra: ${_getExtra(item.itemextra)}\nSIZE: ${_getSize(item.itemSize)}\n-------------------------------------\n';
    }
    message =
        message + 'Order No:12345\nDelivery Type: Dine in\nTable No: 12\n';
    print('Final Message is:--->$message');
    FlutterOpenWhatsapp.sendSingleMessage("918200005207", """$message""");
    // return message;
  }

  setSuccessView(BuildContext context) {
    return new Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: AppColor.themeColor,
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Container(
            height: 120,
            width: 120,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("Assets/Checkout/success.png"),
                    fit: BoxFit.cover)),
          ),
          SizedBox(
            height: 30,
          ),
          setCommonText(
              S.current.thank_you, Colors.white, 20.0, FontWeight.w400, 1),
          SizedBox(
            height: 8,
          ),
          setCommonText(S.current.your_order_placed, Colors.white, 16.0,
              FontWeight.w400, 1),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'To Start making order you must have to send this order to Restaurant via What\'s App.',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
                fontFamily: SharedManager.shared.fontFamilyName,
                color: AppColor.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          new Container(
            height: 50,
            width: MediaQuery.of(context).size.width - 200,
            child: new InkWell(
              onTap: () async {
                await _setWhatappMessage().then((value) {
                  // SharedManager.shared.showAlertDialog('back to home', context);
                  SharedManager.shared.currentIndex = 2;
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => TabBarScreen()),
                      ModalRoute.withName(AppRoute.tabbar));
                });
              },
              child: new Material(
                color: Colors.white,
                borderRadius: new BorderRadius.circular(25),
                child: new Center(
                  child: setCommonText('Send Order Now', Colors.black87, 16.0,
                      FontWeight.w500, 1),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: setSuccessView(context),
    );
  }
}
