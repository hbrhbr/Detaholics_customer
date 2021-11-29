import 'package:flutter/material.dart';
import 'package:product/Helper/CommonWidgets.dart';
import 'package:product/Helper/Constant.dart';
import 'package:product/Helper/SharedManaged.dart';
import 'package:product/Provider/StoreProvider.dart';
import 'package:product/Screens/ReviewListScreen/ReviewListScreen.dart';
import 'package:product/generated/i18n.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class ResDetailsWidget extends StatelessWidget {
  final address;
  final discount;
  final openingTime;
  final closingTime;
  final review;

  ResDetailsWidget(this.address, this.discount, this.openingTime,
      this.closingTime, this.review);

  @override
  Widget build(BuildContext context) {
    StoreProvider store = StoreProvider();

    store = Provider.of<StoreProvider>(context);

    _setCommonWidgetForResDetails(
      IconData icon,
      String value,
    ) {
      return new Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Icon(icon, size: 20, color: AppColor.black54),
          setWidth(5),
          Expanded(
            flex: 3,
            child: new Container(
                // color: AppColor.white,
                // height: 50,
                child: setCommonText(
                    value, AppColor.black, 12.0, FontWeight.w400, 2)),
          ),
          setWidth(8),
        ],
      );
    }

    _launchCaller() async {
      final url = "tel:${store.restaurantDetails.phone}";
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    store = Provider.of<StoreProvider>(context);
    return Container(
      // height: 155,
      color: AppColor.white,
      padding: new EdgeInsets.only(top: 3, left: 8, right: 8),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: _setCommonWidgetForResDetails(Icons.place, '$address'),
              ),
              InkWell(
                onTap: () {
                  //Do call
                  _launchCaller();
                },
                child: Container(
                  height: 35,
                  width: 35,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: AppColor.grey,
                      borderRadius: BorderRadius.circular(20)),
                  child: Icon(Icons.call, size: 20, color: AppColor.white),
                ),
              ),
            ],
          ),
          setHeight(12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: _setCommonWidgetForResDetails(
                    Icons.watch_later_outlined, '$openingTime - $closingTime'),
              ),
              InkWell(
                onTap: () {
                  //Do Share
                  Share.share(
                      '${store.restaurantDetails.name} , ${SharedManager.shared.resAddress}');
                },
                child: Container(
                  height: 35,
                  width: 35,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: AppColor.grey,
                      borderRadius: BorderRadius.circular(20)),
                  child: Icon(Icons.share, size: 20, color: AppColor.white),
                ),
              ),
            ],
          ),
          setHeight(15),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: _setCommonWidgetForResDetails(
                    Icons.food_bank_outlined,
                    (store.restaurantDetails.isAvailable == '1')
                        ? '${S.current.open}'
                        : '${S.current.closed}'),
              ),
              InkWell(
                onTap: () {
                  if (review != '0.0') {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ReviewListScreen(
                            restaurantId: store.restaurantDetails.restaurantId,
                            restaurantName: store.restaurantDetails.name),
                        fullscreenDialog: true));
                  } else {
                    SharedManager.shared.showAlertDialog(
                        '${S.current.reviewNotAvailable}', context);
                  }
                },
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        setCommonText('$review', AppColor.black, 16.0,
                            FontWeight.bold, 1),
                        Icon(
                          Icons.star,
                          color: AppColor.orange,
                          size: 18,
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Divider(
            color: AppColor.grey,
          )
        ],
      ),
    );
  }
}
