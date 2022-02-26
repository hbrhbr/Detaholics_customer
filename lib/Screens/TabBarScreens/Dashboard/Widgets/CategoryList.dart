import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:product/Helper/CommonWidgets.dart';
import 'package:product/Helper/Constant.dart';
import 'package:product/ModelClass/Dashboard.dart';
import 'package:product/Screens/CategoryListScreen/CategoryListScreen.dart';
import 'package:product/Screens/SubcategoryListScreen/SubcategoryListScreen.dart';
import 'package:product/generated/i18n.dart';
import 'package:progressive_image/progressive_image.dart';
import '../../../../Helper/Constant.dart';

class CategoryList extends StatelessWidget {
  final List<Categories> categoryList;
  CategoryList(this.categoryList);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      width: MediaQuery.of(context).size.width,
      color: AppColor.bodyColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 30,vertical: 5),
            child: setCommonText('Cuisines around you', AppColor.black, 18.0,
                FontWeight.w500, 1),
          ),
          Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 30,vertical: 5),
                color: AppColor.bodyColor,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categoryList.length,
                itemBuilder: (builder, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SubcategoryListScreen(
                                categoryID: categoryList[index].categoryId,
                                categoryName: categoryList[index].categoryName,
                              )));
                    },
                    child: Container(
                      width: 90,
                      height: 120,
                      alignment: Alignment.center,
                      margin: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: PhysicalModel(
                              color: Colors.white30,
                              elevation: 10,
                              child: setNetworkImage(
                                  categoryList[index].image, 50, 50),
                            ),
                          ),
                          SizedBox(height: 5),
                          setCommonText(
                              '${categoryList[index].categoryName}',
                              AppColor.black,
                              12.0,
                              FontWeight.w400,
                              1)
                        ],
                      ),
                    ),
                  );
                }),
          ))
        ],
      ),
    );
  }
}
