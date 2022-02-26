import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:product/BlocClass/MainModelBlocClass/CategoryListBLoC.dart';
import 'package:product/Helper/CommonWidgets.dart';
import 'package:product/Helper/Constant.dart';
import 'package:product/ModelClass/ModelCategoryList.dart';
import 'package:product/Screens/SubcategoryListScreen/SubcategoryListScreen.dart';
import 'package:product/generated/i18n.dart';
import 'package:progressive_image/progressive_image.dart';

class CategoryListScreen extends StatefulWidget {
  @override
  _CategoryListScreenState createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    try {} catch (ex) {
      print("banner dispose error");
    }
    super.dispose();
  }

  TextEditingController _searchcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    categoryListBloc.fetchAllCategoryList();
    return SafeArea(
      top: true,
      child: Scaffold(
        backgroundColor: AppColor.bodyColor,
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 10,),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Icon(
                        Icons.notifications,
                        color: Colors.black,
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                            "Cuisine Around You",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w700
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Icon(Icons.menu, color: Colors.black),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 20,right: 20),
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(50)),
                child: TextFormField(
                  controller: _searchcontroller,
                  decoration: InputDecoration(
                    hintStyle: TextStyle(),
                    hintText: 'Search here',
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Expanded(
                child: StreamBuilder(
                    stream: categoryListBloc.categoryList,
                    builder: (context, AsyncSnapshot<ResCategoryList> snapshot) {
                      if (snapshot.hasData) {
                        final categoryList = snapshot.data.categoryList;
                        return ListView.builder(
                          itemCount: categoryList.length,
                            itemBuilder: (context,index){
                            return InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => SubcategoryListScreen(
                                    categoryID: categoryList[index].categoryId,
                                    categoryName:
                                    categoryList[index].categoryName,
                                  )));
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              padding: EdgeInsets.symmetric(horizontal: 5,vertical: 15),
                                decoration: BoxDecoration(
                                  color: AppColor.white,
                                  borderRadius: BorderRadius.circular(10)
                                ),
                                alignment: Alignment.center,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(width: 10,),
                                    Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(35),
                                        boxShadow: [
                                          BoxShadow(
                                              blurRadius: 2,
                                              spreadRadius: 1,
                                              offset: Offset(0, 1),
                                              color: AppColor.grey[400])
                                        ],
                                        // image: DecorationImage(
                                        //   fit: BoxFit.cover,
                                        //   image: NetworkImage(
                                        //       categoryList[index].image),
                                        // )
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(35),
                                        child: ProgressiveImage(
                                          placeholder:
                                          AssetImage('Assets/loading.gif'),
                                          // size: 1.87KB
                                          thumbnail:
                                          AssetImage('Assets/loading.gif'),
                                          // size: 1.29MB
                                          image: CachedNetworkImageProvider(
                                              categoryList[index].image),
                                          height: 70,
                                          width: 70,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10,),
                                    setCommonText(
                                        categoryList[index].categoryName,
                                        AppColor.black54, 20.0, FontWeight.w800, 1),
                                  ],
                                )),
                          );
                        });
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
