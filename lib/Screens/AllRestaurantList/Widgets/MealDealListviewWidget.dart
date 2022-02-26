import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:product/Helper/CommonWidgets.dart';
import 'package:product/Helper/Constant.dart';
import 'package:product/Helper/SharedManaged.dart';
import 'package:product/ModelClass/Dashboard.dart';
import 'package:product/ModelClass/ModelRestaurantDetails.dart';
import 'package:product/Screens/CheckOut/Checkout.dart';
import 'package:product/Screens/RestaurantDetails/RestaurantDetails.dart';
import 'package:product/ModelClass/ModelMealDeals.dart';
import 'package:product/generated/i18n.dart';
import 'package:progressive_image/progressive_image.dart';

import '../AllRestaurantList.dart';

class ListviewMealWidget extends StatelessWidget {
  final List<Result> data;
  ListviewMealWidget(this.data);
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: data.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return new InkWell(
          onTap: () {
            Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
                builder: (context) => RestaurantDetails(
                      restaurantID: data[index].id,
                    )));
          },
          child: new Container(
            height: 100,
            width: MediaQuery.of(context).size.width,
            padding: new EdgeInsets.only(left: 8, right: 8, top: 3, bottom: 3),
            margin: new EdgeInsets.only(left: 15, right: 15, top: 3, bottom: 3),
            child: new Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: new Container(
                    width: 80,
                    decoration: BoxDecoration(
                        // image: DecorationImage(
                        //     image: NetworkImage(data[index].image),
                        //     fit: BoxFit.cover),
                        ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: ProgressiveImage(
                        fit: BoxFit.cover,
                        placeholder: AssetImage('Assets/loading.gif'),
                        // size: 1.87KB
                        thumbnail: AssetImage('Assets/loading.gif'),
                        // size: 1.29MB
                        image: CachedNetworkImageProvider(data[index].image),
                        height: 80,
                        width: 80,
                      ),
                    ),
                  ),
                ),
                new Expanded(
                    child: new Container(
                  padding: new EdgeInsets.only(left: 0, top: 10, right: 5),
                  child: Stack(
                    children: <Widget>[
                      _setCommonWidgetsForMealList(
                          14.0, 12.0, 12.0, 12.0, 13, data[index],context)
                    ],
                  ),
                ))
              ],
            ),
          ),
        );
      },
    );
  }
}
_setCommonWidgetsForMealList(double titlFont, double descriptionFont, double ratingFont, double priceFont, double rationIconSize, Result item,BuildContext context) {
  return new Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      SizedBox(height: 2),
      setCommonText(item.name, Colors.black, titlFont, FontWeight.w500, 1),
      SizedBox(height: 3),
      setCommonText(item.restaurantName, Colors.grey[700], descriptionFont,
          FontWeight.w400, 2),
      SizedBox(
        height: 3,
      ),
      new Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          setCommonText(
              '${Currency.curr}${(double.parse(item.price) - (double.parse(item.discount)))}',
              Colors.black,
              priceFont,
              FontWeight.w600,
              1),
          InkWell(
            onTap: ()async{
              _showBottomSheet(item: item,context: context);
            },
            child: Container(
              height: 25,
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  color: AppColor.black,
                  borderRadius: BorderRadius.circular(30)),
              child: Center(
                child: setCommonText('add cart', AppColor.white, 16.0, FontWeight.bold, 1),
              ),
            ),
          ),
        ],
      )
    ],
  );
}

class ListviewMealDashboardWidget extends StatelessWidget {
  final List<MealDeal> data;
  ListviewMealDashboardWidget(this.data);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: new EdgeInsets.only(left: 30, right: 20,bottom: 10,top: 5),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              setCommonText(S.current.mealDeals, AppColor.black, 15.0,
                  FontWeight.w500, 1),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => AllRestaurantList(
                        title: S.current.mealDeals,
                        apiKey: APIS.mealDeals,
                        isMealDeal: true,
                      )));
                },
                child: Row(
                  children: [
                    setCommonText(S.current.seeAll, AppColor.black, 12.0,
                        FontWeight.w400, 1),
                    Icon(Icons.arrow_forward,
                        color: AppColor.black54, size: 16)
                  ],
                ),
              )
            ],
          ),
        ),
        ListView.builder(
          itemCount: data.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return new InkWell(
              onTap: () {
                Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
                    builder: (context) => RestaurantDetails(
                          restaurantID: data[index].id,
                        )));
              },
              child: new Container(
                height: 100,
                width: MediaQuery.of(context).size.width,
                padding: new EdgeInsets.only(left: 8, right: 8, top: 3, bottom: 3),
                margin: new EdgeInsets.only(left: 15, right: 15, top: 3, bottom: 3),
                child: new Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: new Container(
                        width: 80,
                        decoration: BoxDecoration(
                            // image: DecorationImage(
                            //     image: NetworkImage(data[index].image),
                            //     fit: BoxFit.cover),
                            ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: ProgressiveImage(
                            fit: BoxFit.cover,
                            placeholder: AssetImage('Assets/loading.gif'),
                            // size: 1.87KB
                            thumbnail: AssetImage('Assets/loading.gif'),
                            // size: 1.29MB
                            image: CachedNetworkImageProvider(data[index].image),
                            height: 80,
                            width: 80,
                          ),
                        ),
                      ),
                    ),
                    new Expanded(
                        child: new Container(
                      padding: new EdgeInsets.only(left: 0, top: 10, right: 5),
                      child: Stack(
                        children: <Widget>[
                          _setDashboardCommonWidgetsForMealList(
                              14.0, 12.0, 12.0, 12.0, 13, data[index],context)
                        ],
                      ),
                    ))
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
_setDashboardCommonWidgetsForMealList(double titlFont, double descriptionFont, double ratingFont, double priceFont, double rationIconSize, MealDeal item,BuildContext context) {
  return new Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      SizedBox(height: 2),
      setCommonText(item.name, Colors.black, titlFont, FontWeight.w500, 1),
      SizedBox(height: 3),
      setCommonText(item.restaurantName, Colors.grey[700], descriptionFont,
          FontWeight.w400, 2),
      SizedBox(
        height: 3,
      ),
      new Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          setCommonText(
              '${Currency.curr}${(double.parse(item.price) - (double.parse(item.discount)))}',
              Colors.black,
              priceFont,
              FontWeight.w600,
              1),
          InkWell(
            onTap: ()async{
              _showDashboardBottomSheet(item: item,context: context);
            },
            child: Container(
              height: 25,
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  color: AppColor.black,
                  borderRadius: BorderRadius.circular(30)),
              child: Center(
                child: setCommonText('add cart', AppColor.white, 16.0, FontWeight.bold, 1),
              ),
            ),
          ),
        ],
      )
    ],
  );
}

_showBottomSheet({Result item, BuildContext context}){
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (ctc){
      return Container(
        padding: EdgeInsets.only(
          top: 30,
          left: 20
        ),
        height: MediaQuery.of(context).size.height*.3,
        decoration: BoxDecoration(
          color: AppColor.bodyColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: new Container(
                    width: 80,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: ProgressiveImage(
                        fit: BoxFit.cover,
                        placeholder: AssetImage('Assets/loading.gif'),
                        // size: 1.87KB
                        thumbnail: AssetImage('Assets/loading.gif'),
                        // size: 1.29MB
                        image: CachedNetworkImageProvider(item.image),
                        height: 80,
                        width: 80,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 2),
                    setCommonText(item.name, Colors.black, 18.0, FontWeight.w800, 1),
                    SizedBox(height: 3),
                    setCommonText(item.restaurantName, Colors.grey[700], 16.0,
                        FontWeight.w600, 2),
                    SizedBox(
                      height: 3,
                    ),
                  ],
                ),
              ],
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                InkWell(
                  onTap: ()async{

                  },
                  child: Container(
                    height: 35,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        color: AppColor.black,
                        borderRadius: BorderRadius.circular(30)),
                    child: Center(
                      child: setCommonText('Add To Cart', AppColor.white, 16.0, FontWeight.bold, 1),
                    ),
                  ),
                ),
                SizedBox(width: 10,),
                InkWell(
                  onTap: ()async{

                  },
                  child: Container(
                    height: 35,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        color: AppColor.grey,
                        borderRadius: BorderRadius.circular(30)),
                    child: Center(
                      child: setCommonText(S.current.checkout, AppColor.white, 16.0, FontWeight.bold, 1),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20,),
          ],
        ),
      );
    }
  );
}
_showDashboardBottomSheet({MealDeal item, BuildContext context}){
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (ctc){
      return Container(
        padding: EdgeInsets.only(
          top: 30,
          left: 20
        ),
        height: MediaQuery.of(context).size.height*.3,
        decoration: BoxDecoration(
          color: AppColor.bodyColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: new Container(
                    width: 80,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: ProgressiveImage(
                        fit: BoxFit.cover,
                        placeholder: AssetImage('Assets/loading.gif'),
                        // size: 1.87KB
                        thumbnail: AssetImage('Assets/loading.gif'),
                        // size: 1.29MB
                        image: CachedNetworkImageProvider(item.image),
                        height: 80,
                        width: 80,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 2),
                    setCommonText(item.name, Colors.black, 18.0, FontWeight.w800, 1),
                    SizedBox(height: 3),
                    setCommonText(item.restaurantName, Colors.grey[700], 16.0,
                        FontWeight.w600, 2),
                    SizedBox(
                      height: 3,
                    ),
                  ],
                ),
              ],
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                InkWell(
                  onTap: ()async{

                  },
                  child: Container(
                    height: 35,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        color: AppColor.black,
                        borderRadius: BorderRadius.circular(30)),
                    child: Center(
                      child: setCommonText('Add To Cart', AppColor.white, 16.0, FontWeight.bold, 1),
                    ),
                  ),
                ),
                SizedBox(width: 10,),
                InkWell(
                  onTap: ()async{

                  },
                  child: Container(
                    height: 35,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        color: AppColor.grey,
                        borderRadius: BorderRadius.circular(30)),
                    child: Center(
                      child: setCommonText(S.current.checkout, AppColor.white, 16.0, FontWeight.bold, 1),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20,),
          ],
        ),
      );
    }
  );
}
