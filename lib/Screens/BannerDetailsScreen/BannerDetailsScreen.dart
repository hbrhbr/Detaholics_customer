import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:product/BlocClass/MainModelBlocClass/RestaurantDetails.dart';
import 'package:product/Helper/CommonWidgets.dart';
import 'package:product/Helper/Constant.dart';
import 'package:product/Helper/SharedManaged.dart';
import 'package:product/ModelClass/ModelRestaurantDetails.dart';
import 'package:product/Provider/StoreProvider.dart';
import 'package:product/Screens/Cart/Cart.dart';
import 'package:product/Screens/ProductDetails/ProductDetails.dart';
import 'package:product/Screens/ReviewListScreen/ReviewListScreen.dart';
import 'package:product/generated/i18n.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'Widgets/ResDetailsWidget/ResDetailsWidget.dart';
import 'Widgets/ReviewWidgets/ReviewWidgets.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(new BannerDetailsScreen());

class BannerDetailsScreen extends StatefulWidget {
  final restaurantID;
  BannerDetailsScreen({Key key, this.restaurantID}) : super(key: key);
  @override
  _BannerDetailsScreenState createState() => _BannerDetailsScreenState();
}

class _BannerDetailsScreenState extends State<BannerDetailsScreen> {
  var itemCount = 0;
  var totlaPrice = 0.0;
  bool isFirst = false;
  // var result = ResDetails();
  bool isGrid = false;
  List<Subcategories> subcatList = [];
  int selectedCategory = 0;
  List<MyCategory> myCategories = [];
  List<Categories> categoryList = [];

  StoreProvider store = StoreProvider();

  @override
  void initState() {
    // try {
    //   SharedManager.shared.myBanner.dispose();
    //   SharedManager.shared.myBanner = null;
    // } catch (ex) {
    //   print("banner dispose error");
    // }
    super.initState();
    resDetailsBloc.fetchRestaurantDetails(widget.restaurantID, APIS.resDetails);
    print("Restaurant id:${widget.restaurantID}");
    SharedManager.shared.restaurantID = this.widget.restaurantID;
  }

  @override
  void dispose() {
    try {} catch (ex) {
      print("banner dispose error");
    }
    super.dispose();
  }

  _launchCaller() async {
    final url = "tel:${this.store.restaurantDetails.phone}";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  List<MyCategory> _fillAllCategoryData(List<Categories> categories) {
    // sd
    this.myCategories = [];
    if (categories.length > 0) {
      this.myCategories.add(MyCategory('All', 'all', '1'));
    }
    for (var cat in categories) {
      this.myCategories.add(MyCategory(cat.categoryName, cat.categoryId, '0'));

      //this is,if cart has same restaurant data
      if (this.store.storedRestaurantID ==
          this.store.restaurantDetails.restaurantId) {
        for (var item in this.store.cartItemList) {
          for (var currentItem in cat.subcategories) {
            if (item.id == currentItem.id) {
              currentItem.isAdded = true;
            }
          }
        }
        // this.itemCount = _setItemCount(this.store.restaurantDetails.categories);
      }
    }
    return this.myCategories;
  }

  _setRestaurantDetails(List<Categories> categories) {
    return new Container(
        // color:AppColor.red,
        padding: new EdgeInsets.only(left: 8, right: 8, top: 5),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            setCommonText(S.current.res_recommenditions, AppColor.black, 16.0,
                FontWeight.w500, 1),
            setHeight(15),
            Container(
              height: 40,
              // color: AppColor.red,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: this.myCategories.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 3.0, right: 3.0),
                      child: InkWell(
                        onTap: () {
                          for (var cat in this.myCategories) {
                            cat.isSelect = '0';
                          }
                          setState(() {
                            // List
                            List<Categories> data = [];
                            if (index == 0) {
                              data = this.store.restaurantDetails.categories;
                            } else {
                              data = [
                                this
                                    .store
                                    .restaurantDetails
                                    .categories[index - 1]
                              ];
                            }
                            this.categoryList = data;
                            this.myCategories[index].isSelect = '1';
                          });
                        },
                        child: Container(
                          // width: 100,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: (this.myCategories[index].isSelect == '1')
                                  ? AppColor.themeColor
                                  : AppColor.white,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: AppColor.themeColor)),
                          child: setCommonText(
                              '   ${this.myCategories[index].title}   ',
                              (this.myCategories[index].isSelect == '1')
                                  ? AppColor.white
                                  : AppColor.themeColor,
                              14.0,
                              FontWeight.w500,
                              1),
                        ),
                      ),
                    );
                  }),
            ),
            setHeight(5),
            // new Wrap(
            //     spacing: 5,
            //     runSpacing: 0,
            //     alignment: WrapAlignment.start,
            //     children: _setChipsWidgets(categories)),
            Divider(
              color: AppColor.grey,
            ),
          ],
        ));
  }

  List<Widget> _setItemView() {
    List<Widget> widgetList = [];
    for (var category in this.categoryList) {
      widgetList.add(
          _setDynamicCategory(category.subcategories, category.categoryName));
    }
    return widgetList;
  }

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
      ],
    );
  }

  _setAddressWidgets(String address, String discount, String openingTime,
      String closingTime, String review) {
    return new Container(
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
                      '${this.store.restaurantDetails.name} , ${SharedManager.shared.resAddress}');
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
                    (this.store.restaurantDetails.isAvailable == '1')
                        ? '${S.current.open}'
                        : '${S.current.closed}'),
              ),
              InkWell(
                onTap: () {
                  if (review != '0.0') {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ReviewListScreen(
                            restaurantId: this.widget.restaurantID,
                            restaurantName: this.store.restaurantDetails.name),
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

  _setDynamicCategory(List<Subcategories> data, String title) {
    return Container(
      height: (data.length * 130.0) + 40.0,
      // color: AppColor.red,
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            setCommonText(title, AppColor.black, 16.0, FontWeight.w700, 1),
            setHeight(5),
            Expanded(
              child: new ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: data.length,
                itemBuilder: (context, row) {
                  return InkWell(
                    onTap: () {
                      data[row].catigoryName = title;
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ProductDetails(
                                productData: data[row],
                                resId: this.widget.restaurantID,
                              )));
                    },
                    child: Container(
                      padding: EdgeInsets.all(5),
                      child: Container(
                        decoration: BoxDecoration(
                            color: AppColor.white,
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 1,
                                  spreadRadius: 1,
                                  color: AppColor.grey[300],
                                  offset: Offset(0, 0))
                            ]),
                        child: new Row(
                          children: <Widget>[
                            new Stack(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: ClipRRect(
                                      child: setNetworkImage(
                                          data[row].image, 85, 85)
                                      //  ProgressiveImage(
                                      //   fit: BoxFit.cover,
                                      //   placeholder:
                                      //       AssetImage('Assets/loading.gif'),
                                      //   thumbnail: AssetImage('Assets/loading.gif'),
                                      //   image: CachedNetworkImageProvider(
                                      //     data[row].image,
                                      //   ),
                                      //   height: 85,
                                      //   width: 85,
                                      // ),
                                      ),
                                ),
                              ],
                            ),
                            new Expanded(
                              flex: 2,
                              child: new Container(
                                // color: AppColor.red,
                                child: new Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    new Row(
                                      children: <Widget>[
                                        Image(
                                            height: 20,
                                            width: 20,
                                            fit: BoxFit.cover,
                                            image: AssetImage((data[row].type ==
                                                    '1')
                                                ? 'Assets/RestaurantDetails/veg.png'
                                                : 'Assets/RestaurantDetails/nonVeg.png')),
                                        new Expanded(
                                            flex: 2,
                                            child: setCommonText(
                                                data[row].name,
                                                AppColor.black,
                                                14.0,
                                                FontWeight.w500,
                                                1)),
                                        // SizedBox(width: 5,),
                                      ],
                                    ),
                                    setCommonText(
                                        (data[row].isAvailable == '1')
                                            ? 'Available'
                                            : 'Out of Stock',
                                        (data[row].isAvailable == '1')
                                            ? AppColor.themeColor
                                            : AppColor.red,
                                        13.0,
                                        FontWeight.w500,
                                        1),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    setCommonText(
                                        data[row].description,
                                        AppColor.grey[600],
                                        12.0,
                                        FontWeight.w400,
                                        2),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    (double.parse(data[row].discount) == 0)
                                        ? setHeight(0)
                                        : setCommonText(
                                            (data[row].discountType == '0')
                                                ? '${Currency.curr}${data[row].discount} off'
                                                : '${data[row].discount}% off',
                                            AppColor.red,
                                            12.0,
                                            FontWeight.w400,
                                            1),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    new Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        new Row(
                                          children: <Widget>[
                                            (double.parse(data[row].discount) ==
                                                    0)
                                                ? setWidth(0)
                                                : new Stack(
                                                    alignment: Alignment.center,
                                                    children: <Widget>[
                                                      setCommonText(
                                                          '${Currency.curr}${data[row].price}',
                                                          AppColor.grey[600],
                                                          12.0,
                                                          FontWeight.w600,
                                                          1),
                                                      new Container(
                                                        height: 2,
                                                        width: 40,
                                                        color:
                                                            AppColor.grey[700],
                                                      ),
                                                    ],
                                                  ),
                                            SizedBox(
                                              width: 3,
                                            ),
                                            setCommonText(
                                                '${Currency.curr}${calculateDiscount(data[row].price, data[row].discount, data[row].discountType)}',
                                                AppColor.black,
                                                12.0,
                                                FontWeight.w700,
                                                1),
                                          ],
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8.0),
                                          child: new Container(
                                            height: 30,
                                            width: 60,
                                            decoration: BoxDecoration(
                                                border: Border.all(),
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            child: InkWell(
                                              onTap: () {
                                                if (data[row].isAvailable ==
                                                    '1') {
                                                  setState(() {
                                                    if (data[row].isAdded) {
                                                      this
                                                          .store
                                                          .removeItemFromCart(
                                                              data[row]);
                                                    } else {
                                                      // data[row].isAdded = true;
                                                      this.store.addItemTocart(
                                                          data[row],
                                                          this
                                                              .store
                                                              .restaurantDetails
                                                              .restaurantId,
                                                          context);
                                                    }
                                                    // //this id will store at provider class
                                                    // this
                                                    //         .store
                                                    //         .storedRestaurantID =
                                                    //     this.store.restaurantDetails.restaurantId;

                                                    // this.itemCount =
                                                    //     _setItemCount(this
                                                    //         .store
                                                    //         .restaurantDetails
                                                    //         .categories);
                                                  });
                                                } else {
                                                  commonItemOutofStockAlert(
                                                      context);
                                                }
                                              },
                                              child: new Center(
                                                child: data[row].isAdded
                                                    ? setCommonText(
                                                        S.current.delete,
                                                        AppColor.red,
                                                        12.0,
                                                        FontWeight.w600,
                                                        1)
                                                    : setCommonText(
                                                        S.current.add_plus,
                                                        AppColor.themeColor,
                                                        12.0,
                                                        FontWeight.w600,
                                                        1),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // double calculateTotalHeight(List<Subcategories> subcategory) {
  //   var height = 0.0;
  //   var count = 0.0;
  //     count = count + subcategory.length;
  //   height = count * 115;
  //   print("Final Height is:$height");
  //   return height;
  // }

  int _setItemCount(List<Categories> categoryList) {
    var count = 0;
    var price = 0.0;
    for (var cate in this.store.restaurantDetails.categories) {
      for (var item in cate.subcategories) {
        if (item.isAdded) {
          count = count + 1;
          price =
              price + (double.parse(item.price) - double.parse(item.discount));
          // SharedManager.shared.cartItems.add(item);
        }
      }
    }

    // for (int j = 0; j < subcategoryList.length; j++) {
    //   if (subcategoryList[j].isAdded) {
    //     count = count + 1;
    //     price = price +
    //         (double.parse(subcategoryList[j].price) -
    //             double.parse(subcategoryList[j].discount));
    //     SharedManager.shared.cartItems.add(subcategoryList[j]);
    //   }
    // }
    this.totlaPrice = price;
    return count;
  }

  @override
  Widget build(BuildContext context) {
    // final width = MediaQuery.of(context).size.width;
    this.store = Provider.of<StoreProvider>(context);
    _setHeroImage(String strUrl) {
      return Container(
          child: setNetworkImage(strUrl, MediaQuery.of(context).size.width,
              MediaQuery.of(context).size.width)
          //  ProgressiveImage(
          //   fit: BoxFit.cover,
          //   placeholder: AssetImage('Assets/loading.gif'),
          //   // size: 1.87KB
          //   thumbnail: AssetImage('Assets/loading.gif'),
          //   // size: 1.29MB
          //   // image: NetworkImage(
          //   //     topRestaurant[index].image),
          //   image: CachedNetworkImageProvider(
          //     strUrl,
          //   ),
          //   height: MediaQuery.of(context).size.width,
          //   width: MediaQuery.of(context).size.width,
          // ),
          );
    }

    return new Scaffold(
      body: new StreamBuilder(
        stream: resDetailsBloc.restaurantDetails,
        builder: (context, AsyncSnapshot<ResRestaurantDetails> snapshot) {
          if (snapshot.hasData) {
            if (!isFirst) {
              this.isFirst = true;
              this.store.restaurantDetails = snapshot.data.result;
              SharedManager.shared.resLatitude =
                  this.store.restaurantDetails.latitude;
              SharedManager.shared.resLongitude =
                  this.store.restaurantDetails.longitude;
              SharedManager.shared.resAddress =
                  this.store.restaurantDetails.address;
              SharedManager.shared.resImage =
                  this.store.restaurantDetails.bannerImage;
              SharedManager.shared.resName = this.store.restaurantDetails.name;
              _fillAllCategoryData(snapshot.data.result.categories);
              this.categoryList = snapshot.data.result.categories;
            } else {
//
            }
            // var result = snapshot.data.result;
            return CustomScrollView(
              scrollDirection: Axis.vertical,
              slivers: <Widget>[
                SliverAppBar(
                  centerTitle: true,
                  backgroundColor: AppColor.themeColor,
                  iconTheme: IconThemeData(color: AppColor.white),
                  expandedHeight: MediaQuery.of(context).size.width - 200,
                  elevation: 0.1,
                  pinned: true,
                  flexibleSpace: new FlexibleSpaceBar(
                    centerTitle: true,
                    title: setCommonText(this.store.restaurantDetails.name,
                        AppColor.white, 14.0, FontWeight.w500, 2),
                    background: new Stack(
                      children: <Widget>[
                        _setHeroImage(this.store.restaurantDetails.bannerImage),
                        Container(
                          color: AppColor.black.withOpacity(0.3),
                        )
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: new EdgeInsets.all(8),
                    child: new Container(
                      color: AppColor.white,
                      child: new Column(
                        children: <Widget>[
                          ResDetailsWidget(
                              this.store.restaurantDetails.address,
                              this.store.restaurantDetails.discount,
                              this.store.restaurantDetails.openingTime,
                              this.store.restaurantDetails.closingTime,
                              (this.store.restaurantDetails.avgReview != null)
                                  ? this.store.restaurantDetails.avgReview
                                  : '0.0'),
                          (this.store.restaurantDetails.categories.length > 0)
                              ? _setRestaurantDetails(
                                  this.store.restaurantDetails.categories)
                              : Container(
                                  height: 150,
                                  alignment: Alignment.center,
                                  child: setCommonText(
                                      'No Data Found',
                                      AppColor.black87,
                                      18.0,
                                      FontWeight.w600,
                                      1),
                                ),
                          Column(
                            children: _setItemView(),
                          ),
                          ReviewWidgets(
                              this.store.restaurantDetails.reviews,
                              this.widget.restaurantID,
                              this.store.restaurantDetails.name),
                          setHeight(15),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return new Center(
              child: new CircularProgressIndicator(),
            );
          }
        },
      ),
      bottomNavigationBar: Padding(
          padding: EdgeInsets.all(10.0),
          child: (this.store.getTotalCartCount() > 0)
              ? new Container(
                  color: AppColor.white,
                  height: 50,
                  child: new Material(
                      color: AppColor.themeColor,
                      borderRadius: new BorderRadius.circular(30),
                      child: new Container(
                        padding: new EdgeInsets.only(left: 20, right: 15),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new Text(
                                  "${this.store.getTotalCartCount()} ${S.current.items}",
                                  style: new TextStyle(
                                      color: AppColor.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                new Text(
                                  "${S.current.totals} ${Currency.curr}${this.store.getTotalPrice()}",
                                  style: new TextStyle(
                                      color: AppColor.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            ),
                            new Row(
                              children: <Widget>[
                                new GestureDetector(
                                  onTap: () async {
                                    if (this
                                            .store
                                            .restaurantDetails
                                            .isAvailable ==
                                        '1') {
                                      List<Subcategories> listData = [];
                                      for (int i = 0;
                                          i <
                                              this
                                                  .store
                                                  .restaurantDetails
                                                  .categories
                                                  .length;
                                          i++) {
                                        List<Subcategories> subList = this
                                            .store
                                            .restaurantDetails
                                            .categories[i]
                                            .subcategories;
                                        for (int j = 0;
                                            j < subList.length;
                                            j++) {
                                          if (subList[j].isAdded) {
                                            listData.add(subList[j]);
                                          }
                                        }
                                      }
                                      // SharedManager.shared.cartItems = listData;
                                      SharedManager.shared.resAddress =
                                          this.store.restaurantDetails.address;
                                      SharedManager.shared.resImage = this
                                          .store
                                          .restaurantDetails
                                          .bannerImage;
                                      SharedManager.shared.resName =
                                          this.store.restaurantDetails.name;
                                      SharedManager.shared.isFromTab = false;
                                      await Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (context) => CartApp()))
                                          .then((value) {
                                        print("You came from cart list");
                                        // _fillAllCategoryData(
                                        //     this.store.restaurantDetails.categories);
                                        // setState(() {
                                        //   this.isFirst = false;
                                        // });
                                      });
                                    } else {
                                      commonRestaurantCloseAlert(context);
                                    }
                                  },
                                  child: new Text(
                                    S.current.view_cart,
                                    style: new TextStyle(
                                        fontSize: 16,
                                        color: AppColor.white,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                new Icon(Icons.arrow_forward,
                                    color: AppColor.white)
                              ],
                            )
                          ],
                        ),
                      )),
                )
              : null),
    );
  }
}

class MyCategory {
  String title;
  String id;
  String isSelect;
  MyCategory(this.title, this.id, this.isSelect);
}
