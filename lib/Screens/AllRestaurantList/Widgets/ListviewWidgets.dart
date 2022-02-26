import 'package:flutter/material.dart';
import 'package:product/Helper/CommonWidgets.dart';
import 'package:product/Helper/Constant.dart';
import 'package:product/Helper/SharedManaged.dart';
import 'package:product/ModelClass/ModelAllRestaurantList.dart';
import 'package:product/Screens/BannerDetailsScreen/BannerDetailsScreen.dart';
import 'package:product/generated/i18n.dart';

class ListViewWidget extends StatelessWidget {
  final List<Restaurant> restaurants;
  ListViewWidget(this.restaurants);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: restaurants.length,
        itemBuilder: (context, index) {
          return new InkWell(
            onTap: () {
              if (restaurants[index].isAvailable == '1') {
                Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
                    builder: (context) => BannerDetailsScreen(
                          restaurantID: restaurants[index].id,
                        )));
              } else {
                commonRestaurantCloseAlert(context);
              }
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 30,vertical: 3),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 170,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        restaurants[index].image,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    color: Colors.black26,
                    padding: new EdgeInsets.all(8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          restaurants[index].name,
                          style: TextStyle(
                              color: AppColor.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 18.0,
                              fontFamily: SharedManager.shared.fontFamilyName),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                        ),
                        SizedBox(height: 3),
                        Text(
                          restaurants[index].address,
                          style: TextStyle(
                              color: AppColor.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 16.0,
                              fontFamily: SharedManager
                                  .shared.fontFamilyName),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

_setCommonWidgets(double titlFont, double descriptionFont, double ratingFont,
    double priceFont, double rationIconSize, Restaurant restaurant) {
  return new Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
      setCommonText(
          restaurant.name, Colors.black, titlFont, FontWeight.w500, 1),
      SizedBox(height: 3),
      setCommonText(restaurant.address, Colors.grey[700], descriptionFont,
          FontWeight.w400, 2),
      SizedBox(
        height: 3,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          setCommonText(
              (restaurant.review != null) ? '${restaurant.review}' : '0.0',
              AppColor.orange,
              13.0,
              FontWeight.w500,
              1),
          Icon(
            Icons.star,
            color: AppColor.orange,
            size: 12,
          ),
        ],
      ),
    ],
  );
}
