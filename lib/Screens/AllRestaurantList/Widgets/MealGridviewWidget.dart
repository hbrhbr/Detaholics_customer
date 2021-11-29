import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:product/Helper/Constant.dart';
import 'package:product/Helper/SharedManaged.dart';
import 'package:product/ModelClass/ModelMealDeals.dart';
import 'package:product/Screens/BannerDetailsScreen/BannerDetailsScreen.dart';

class GridViewMealWidget extends StatelessWidget {
  final List<Result> data;
  GridViewMealWidget(this.data);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return new Container(
      padding: new EdgeInsets.all(5),
      child: GridView.count(
        crossAxisCount: 3,
        children: new List<Widget>.generate(data.length, (index) {
          return new GestureDetector(
            onTap: () {
              Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
                  builder: (context) => BannerDetailsScreen(
                        restaurantID: data[index].id,
                      )));
            },
            child: Container(
              width: width / 3,
              // height: 170,
              padding: new EdgeInsets.all(8),
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    child: Column(
                      children: [
                        Expanded(flex: 1, child: Container()),
                        Expanded(
                            flex: 5,
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColor.white,
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 1,
                                      spreadRadius: 1,
                                      color: AppColor.grey[300],
                                      offset: Offset(0, 0))
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(height: 45),
                                    Text(
                                      data[index].name,
                                      style: TextStyle(
                                          color: AppColor.black,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12.0,
                                          fontFamily: SharedManager
                                              .shared.fontFamilyName),
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                    ),
                                    SizedBox(height: 3),
                                    Text(
                                      data[index].restaurantName,
                                      style: TextStyle(
                                          color: AppColor.grey,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 10.0,
                                          fontFamily: SharedManager
                                              .shared.fontFamilyName),
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                    ),
                                    SizedBox(height: 3),
                                  ],
                                ),
                              ),
                            ))
                      ],
                    ),
                  ),
                  Positioned(
                      top: 0,
                      child: Container(
                        height: 70,
                        // width: 70,
                        width: width / 4.2,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 1,
                                spreadRadius: 1,
                                color: AppColor.grey[300],
                                offset: Offset(0, 0))
                          ],
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: CachedNetworkImageProvider(
                                  data[index].image)),
                        ),
                      )),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
