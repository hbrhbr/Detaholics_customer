import 'package:flutter/material.dart';
import 'package:product/Helper/CommonWidgets.dart';
import 'package:product/Helper/Constant.dart';
import 'package:product/Helper/RequestManager.dart';
import 'package:product/Helper/SharedManaged.dart';
import 'package:product/ModelClass/ModelRestaurantDetails.dart';
import 'package:product/Provider/StoreProvider.dart';
import 'package:product/Screens/ChangeAddress/ChangeAddress.dart';
import 'package:product/Screens/CheckOut/Checkout.dart';
import 'package:product/generated/i18n.dart';
import 'package:provider/provider.dart';

class CartApp extends StatefulWidget {
  final Subcategories productData;
  CartApp({this.productData});
  @override
  _CartAppState createState() => _CartAppState();
}

class _CartAppState extends State<CartApp> {
//Define the variable on the top

  List riderTipList = [
    {"price": 5, "isSelect": false},
    {"price": 10, "isSelect": false},
    {"price": 15, "isSelect": false},
  ];

  var totalPrice = 0.0;
  var paidPrice = 0.0;
  var riderTip = 0;
  // var charge = shared;
  var discountedPrice = 0.0;
  var grandTotalAmount = 0.0;

  TextEditingController couponController = TextEditingController();
  TextEditingController coockingInstructions = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  StoreProvider store = StoreProvider();

//This is the place where you have to create the all widgets

  _setAddedCartListWidgets() {
    return new Container(
      height: (100.0 * this.store.cartItemList.length) + 170,
      color: Colors.white,
      padding: new EdgeInsets.all(5),
      child: new Column(
        children: <Widget>[
          new Container(
            height: 80,
            // color: Colors.blue,
            child: new Row(
              children: <Widget>[
                setNetworkImage(SharedManager.shared.resImage, 60, 100),
                // new Container(
                //   width: 100,
                //   padding: new EdgeInsets.all(10),
                //   // color: Colors.yellow,
                //   child: new Image(
                //     image: NetworkImage(SharedManager.shared.resImage),
                //     fit: BoxFit.cover,
                //   ),
                // ),
                SizedBox(
                  width: 5,
                ),
                new Expanded(
                  flex: 2,
                  child: new Container(
                    padding: new EdgeInsets.all(5),
                    // color: Colors.pink,
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        setCommonText('${SharedManager.shared.resName}',
                            Colors.black, 13.0, FontWeight.w500, 2),
                        SizedBox(
                          height: 5,
                        ),
                        setCommonText('${SharedManager.shared.resAddress}',
                            Colors.grey, 12.0, FontWeight.w400, 3),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          new Divider(
            color: Colors.grey,
          ),
          _setAddedProductList((this.store.cartItemList.length * 100.0)),
          _setCartTotalAndDescriptionWidgets(60),
        ],
      ),
    );
  }

  _setCartTotalAndDescriptionWidgets(double height) {
    return new Container(
      height: height,
      // color: Colors.yellow,
      child: new Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: new Container(
                // color:Colors.red,
                child: new Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Icon(
                  Icons.note_add,
                  color: Colors.black38,
                  size: 18,
                ),
                SizedBox(
                  width: 5,
                ),
                new Expanded(
                  child: new TextFormField(
                    controller: coockingInstructions,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: S.current.coocking_instructions,
                        hintStyle: new TextStyle(color: Colors.amber)),
                    style: new TextStyle(
                        fontSize: 13,
                        color: Colors.black87,
                        fontFamily: SharedManager.shared.fontFamilyName),
                  ),
                )
              ],
            )),
          ),
          // Expanded(
          //   flex: 1,
          //   child: new Container(
          //     padding: new EdgeInsets.only(left: 10, right: 10),
          //     // color:Colors.blue,
          //     child: new Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       children: <Widget>[
          //         new Row(
          //           children: <Widget>[
          //             setCommonText(S.current.item_total, Colors.grey, 14.0,
          //                 FontWeight.w500, 2),
          //           ],
          //         ),
          //         new Row(
          //           children: <Widget>[
          //             new Stack(
          //               alignment: Alignment.center,
          //               children: <Widget>[
          //                 setCommonText('${Currency.curr}${this.paidPrice}',
          //                     Colors.grey, 14.0, FontWeight.w500, 1),
          //                 new Container(
          //                     width: 50, height: 2, color: Colors.grey),
          //               ],
          //             ),
          //             SizedBox(
          //               width: 6,
          //             ),
          //             setCommonText('${Currency.curr}${this.totalPrice}',
          //                 Colors.grey, 14.0, FontWeight.w500, 1),
          //           ],
          //         )
          //       ],
          //     ),
          //   ),
          // ),
          new Divider(color: Colors.grey)
        ],
      ),
    );
  }

  _setTotalPriceCount() {
    var total = 0.0;
    var totalWithDis = 0.0;
    for (var i = 0; i < this.store.cartItemList.length; i++) {
      var price = double.parse(this.store.cartItemList[i].price);
      var discount = double.parse(this.store.cartItemList[i].discount);
      var count = this.store.cartItemList[i].count;

      total = total + (count * price);
      totalWithDis = totalWithDis + (count * (price - discount));
    }
    this.paidPrice = total;
    this.totalPrice = totalWithDis;
    if (this.store.getTotalCartCount() == 0) {
      this.store.storedRestaurantID = '';
    }
  }

  _setAddedProductList(double height) {
    return new Container(
      height: height,
      // color: Colors.red,
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          itemCount: this.store.cartItemList.length,
          itemBuilder: (context, index) {
            return new Container(
              height: 100,
              child: new Column(
                children: <Widget>[
                  Expanded(
                    child: Stack(
                      children: <Widget>[
                        new Container(
                          color: Colors.white,
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Container(
                                color: Colors.white,
                                padding: new EdgeInsets.all(10),
                                child: setNetworkImage(
                                    this.store.cartItemList[index].image,
                                    80,
                                    80),
                              ),
                              new Expanded(
                                flex: 4,
                                child: new Container(
                                  padding: new EdgeInsets.all(3),
                                  color: Colors.white,
                                  child: new Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Row(
                                        children: [
                                          Container(
                                            height: 15,
                                            width: 15,
                                            child: new Image(
                                              image: (this
                                                          .store
                                                          .cartItemList[index]
                                                          .type ==
                                                      "1")
                                                  ? AssetImage(
                                                      'Assets/RestaurantDetails/veg.png')
                                                  : AssetImage(
                                                      'Assets/RestaurantDetails/nonVeg.png'),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          SizedBox(width: 3),
                                          Expanded(
                                            child: setCommonText(
                                                this
                                                    .store
                                                    .cartItemList[index]
                                                    .name,
                                                Colors.black,
                                                13.0,
                                                FontWeight.w500,
                                                1),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 2,
                                      ),
                                      setCommonText(
                                          this
                                              .store
                                              .cartItemList[index]
                                              .description,
                                          Colors.grey[600],
                                          12.0,
                                          FontWeight.w400,
                                          2),
                                      new SizedBox(
                                        height: 10,
                                      ),
                                      new Row(
                                        children: <Widget>[
                                          new Stack(
                                            alignment: Alignment.center,
                                            children: <Widget>[
                                              setCommonText(
                                                  '${Currency.curr}${this.store.cartItemList[index].price}',
                                                  Colors.deepOrangeAccent,
                                                  12.0,
                                                  FontWeight.w500,
                                                  1),
                                              new Container(
                                                height: 1,
                                                width: 45,
                                                color: Colors.black87,
                                              )
                                            ],
                                          ),
                                          new SizedBox(width: 5),
                                          setCommonText(
                                              '${Currency.curr}${(double.parse(this.store.cartItemList[index].price)) - (double.parse(this.store.cartItemList[index].discount))}',
                                              Colors.black54,
                                              12.0,
                                              FontWeight.w500,
                                              1),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                height: 60,
                                width: 80,
                                padding: new EdgeInsets.all(3),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    new Container(
                                        height: 28,
                                        // color: Colors.green,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            border: Border.all(
                                              color: AppColor.themeColor,
                                            )),
                                        child: new Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Expanded(
                                              flex: 1,
                                              child: new Container(
                                                  color: Colors.white,
                                                  child: new Align(
                                                    alignment:
                                                        Alignment.topCenter,
                                                    child: new GestureDetector(
                                                      onTap: () {
                                                        if (this
                                                                .store
                                                                .cartItemList[
                                                                    index]
                                                                .count >
                                                            1) {
                                                          this
                                                              .store
                                                              .removeItemFromCart(
                                                                this
                                                                        .store
                                                                        .cartItemList[
                                                                    index],
                                                              );
                                                          // setState(() {
                                                          //   this
                                                          //       .store
                                                          //       .cartItemList[
                                                          //           index]
                                                          //       .count = this
                                                          //           .store
                                                          //           .cartItemList[
                                                          //               index]
                                                          //           .count -
                                                          //       1;
                                                          //   _setTotalPriceCount();
                                                          // });
                                                        }
                                                      },
                                                      child: new Text(
                                                        "-",
                                                        style: new TextStyle(
                                                            fontSize: 25,
                                                            color: AppColor
                                                                .themeColor),
                                                      ),
                                                    ),
                                                  )),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: new Container(
                                                color: AppColor.themeColor,
                                                child: new Center(
                                                  child: setCommonText(
                                                      '${this.store.cartItemList[index].count}',
                                                      Colors.white,
                                                      14.0,
                                                      FontWeight.w500,
                                                      1),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: new Container(
                                                color: Colors.white,
                                                child: new Center(
                                                  child: new GestureDetector(
                                                    onTap: () {
                                                      this.store.addItemTocart(
                                                          this
                                                                  .store
                                                                  .cartItemList[
                                                              index],
                                                          SharedManager.shared
                                                              .restaurantID,
                                                          context);
                                                      // setState(() {
                                                      //   this
                                                      //       .store
                                                      //       .cartItemList[index]
                                                      //       .count = this
                                                      //           .store
                                                      //           .cartItemList[
                                                      //               index]
                                                      //           .count +
                                                      //       1;
                                                      //   _setTotalPriceCount();
                                                      // });
                                                    },
                                                    child: new Text(
                                                      "+",
                                                      style: new TextStyle(
                                                          fontSize: 20,
                                                          color: AppColor
                                                              .themeColor),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                    new SizedBox(
                                      height: 5,
                                    ),
                                    setCommonText(
                                        '${Currency.curr}${(((double.parse(this.store.cartItemList[index].price)) - (double.parse(this.store.cartItemList[index].discount))) * this.store.cartItemList[index].count)}',
                                        Colors.black87,
                                        15.0,
                                        FontWeight.w500,
                                        1),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        new Positioned(
                            bottom: -15,
                            right: -10,
                            child: IconButton(
                                icon: Icon(Icons.delete),
                                color: Colors.red,
                                iconSize: 20,
                                onPressed: () {
                                  // setState(() {
                                  if (this.widget.productData.id ==
                                      this.store.cartItemList[index].id) {
                                    this.widget.productData.isAdded = false;
                                  }
                                  this.store.removeItemFromCart(
                                      this.store.cartItemList[index]);
                                  _setTotalPriceCount();
                                  // });
                                }))
                      ],
                    ),
                  ),
                  new Divider(
                    color: Colors.grey[300],
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  _setBottomPlaceOrderWidgets() {
    return new Container(
      color: AppColor.themeColor,
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new Expanded(
            child: new Container(
              width: MediaQuery.of(context).size.width,
              padding: new EdgeInsets.only(left: 30, right: 30),
              // color: Colors.pink,
              child: new GestureDetector(
                onTap: () {
                  (SharedManager.shared.addressId != "")
                      ? Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Checkout(
                                charge:
                                    "${SharedManager.shared.deliveryCharge}",
                                discountedPrice: "${this.totalPrice}",
                                grandTotalAmount:
                                    "${this.totalPrice + SharedManager.shared.deliveryCharge + this.riderTip}",
                                tipAmount: "${this.riderTip}",
                                totalPrice: "${this.paidPrice}",
                                coockingInstructions:
                                    this.coockingInstructions.text,
                                totalSaving:
                                    "${this.totalPrice + SharedManager.shared.deliveryCharge}",
                                cartItems: this.store.cartItemList,
                              )))
                      : SharedManager.shared.showAlertDialog(
                          S.current.select_address_first, context);
                },
                child: new Material(
                  color: AppColor.themeColor,
                  borderRadius: new BorderRadius.circular(5),
                  child: new Center(
                      child: new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      setCommonText(S.current.place_order, Colors.white, 18.0,
                          FontWeight.w500, 1),
                      SizedBox(width: 5),
                      Icon(Icons.arrow_forward, color: Colors.white, size: 20)
                    ],
                  )),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // _setRiderTipWidgets() {
  //   return new Container(
  //       padding: new EdgeInsets.all(8),
  //       height: 120,
  //       color: Colors.grey[100],
  //       child: new Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: <Widget>[
  //           // setCommonText(S.current.addTip_for_rider, Colors.black87, 14.0,
  //           //     FontWeight.w500, 1),
  //           // setCommonText(S.current.valid_for_driver, Colors.black38, 12.0,
  //           //     FontWeight.w400, 1),
  //           SizedBox(
  //             height: 5,
  //           ),
  //           new Container(
  //             height: 50,
  //             // color: Colors.amber,
  //             child: new ListView.builder(
  //               itemCount: this.riderTipList.length,
  //               scrollDirection: Axis.horizontal,
  //               itemBuilder: (context, index) {
  //                 return new Container(
  //                   padding: new EdgeInsets.only(top: 8, bottom: 8, right: 8),
  //                   width: 70,
  //                   child: new GestureDetector(
  //                     onTap: () {
  //                       setState(() {
  //                         _setTipData();
  //                         this.riderTipList[index]['isSelect'] = true;
  //                         this.riderTip = this.riderTipList[index]["price"];
  //                       });
  //                     },
  //                     child: new Container(
  //                       decoration: BoxDecoration(
  //                           borderRadius: BorderRadius.circular(5),
  //                           border: Border.all(
  //                             color: (this.riderTipList[index]['isSelect'])
  //                                 ? Colors.black
  //                                 : AppColor.themeColor,
  //                           )),
  //                       child: new Center(
  //                           child: setCommonText(
  //                               '${Currency.curr}${this.riderTipList[index]["price"]}',
  //                               (this.riderTipList[index]['isSelect'])
  //                                   ? Colors.black87
  //                                   : AppColor.themeColor,
  //                               14.0,
  //                               FontWeight.w500,
  //                               1)),
  //                     ),
  //                   ),
  //                 );
  //               },
  //             ),
  //           )
  //         ],
  //       ));
  // }

  _setTipData() {
    for (var i = 0; i < this.riderTipList.length; i++) {
      this.riderTipList[i]["isSelect"] = false;
    }
  }

  _applyCouponCodeFunctionality() {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.0))),
        backgroundColor: Colors.white,
        context: context,
        isScrollControlled: true,
        builder: (context) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: _setCouponWidget()));
  }

  _setCouponWidget() {
    return new Container(
      height: 380.0,
      color: Colors.transparent,
      //so you don't have to change MaterialApp canvasColor
      child: new Container(
        padding: EdgeInsets.only(left: 15, right: 15),
        decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(20.0),
                topRight: const Radius.circular(20.0))),
        child: Column(
          children: [
            setHeight(10),
            Row(
              children: [
                Expanded(
                    child: setCommonText('Apply Coupon', AppColor.black87, 18.0,
                        FontWeight.w500, 1)),
                IconButton(
                    icon: Icon(Icons.close, color: AppColor.black87),
                    onPressed: () {
                      Navigator.of(context).pop();
                    })
              ],
            ),
            setHeight(10),
            _addCouponCodeWidget(),
            setHeight(10),
            _setAvailableCouponList(),
          ],
        ),
      ),
    );
  }

  _setAvailableCouponList() {
    return Container(
      height: 220,
      width: MediaQuery.of(context).size.width,
      // color: AppColor.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          setCommonText(
              'Available Coupons', AppColor.black87, 18.0, FontWeight.w500, 1),
          setHeight(10),
          Expanded(
              child: Container(
            // color: AppColor.amber,
            child: ListView.builder(
                itemCount: 2,
                itemBuilder: (context, index) {
                  return Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        setHeight(8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              height: 35,
                              // width: 120,
                              decoration: BoxDecoration(
                                color: AppColor.orange.shade300,
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                    width: 1, color: AppColor.deepOrange),
                              ),
                              child: setCommonText('  HOLISPECIAL  ',
                                  AppColor.white, 15.0, FontWeight.w500, 1),
                            ),
                            Container(
                              height: 30,
                              width: 70,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: AppColor.deepOrange,
                                  borderRadius: BorderRadius.circular(5)),
                              child: setCommonText('SELECT', AppColor.white,
                                  12.0, FontWeight.w500, 1),
                            )
                          ],
                        ),
                        setHeight(5),
                        setCommonText(
                            '${Currency.curr}16 off on all orders above ${Currency.curr} 250',
                            AppColor.black87,
                            14.0,
                            FontWeight.w400,
                            1),
                        setHeight(3),
                        setCommonText('Applicable only once per user',
                            AppColor.grey, 14.0, FontWeight.w400, 1),
                        setHeight(8),
                        Container(
                          height: 1,
                          color: AppColor.grey[300],
                        )
                      ],
                    ),
                  );
                }),
          ))
        ],
      ),
    );
  }

  _addCouponCodeWidget() {
    return Container(
      height: 50,
      // color: AppColor.white,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: Container(
                child: TextFormField(
                  decoration: InputDecoration(
                      hintText: "Add Code Here", border: InputBorder.none),
                ),
              )),
              Padding(
                padding: EdgeInsets.only(left: 8, right: 5, top: 4, bottom: 4),
                child: setCommonText(
                    'ADD', AppColor.deepOrange, 15.0, FontWeight.w500, 1),
              )
            ],
          ),
          Container(height: 1, color: AppColor.grey)
        ],
      ),
    );
  }

  _setPromoCodeGrandTotalWidgets() {
    return new Container(
      height: 230,
      color: Colors.grey[100],
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 60,
            color: AppColor.white,
            padding: EdgeInsets.only(left: 12, right: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    _applyCouponCodeFunctionality();
                  },
                  child: Row(
                    children: [
                      Image(
                        height: 35,
                        width: 40,
                        image: AssetImage('Assets/Cart/coupon.png'),
                      ),
                      setWidth(8),
                      setCommonText('APPLY COUPON', AppColor.deepOrange, 18.0,
                          FontWeight.w500, 1),
                    ],
                  ),
                ),
                Container(
                  height: 30,
                  width: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: AppColor.deepOrange,
                      borderRadius: BorderRadius.circular(5)),
                  child: setCommonText(
                      'APPLY', AppColor.white, 12.0, FontWeight.w500, 1),
                )
              ],
            ),
          ),
          // new Expanded(
          //   flex: 1,
          //   child: new Container(
          //     padding:
          //         new EdgeInsets.only(left: 15, right: 10, top: 5, bottom: 5),
          //     color: Colors.white,
          //     child: new Row(
          //       crossAxisAlignment: CrossAxisAlignment.center,
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: <Widget>[
          //         new Icon(
          //           Icons.ac_unit,
          //           color: AppColor.amber.shade400,
          //           size: 18,
          //         ),
          //         SizedBox(width: 5),
          //         new Expanded(
          //           flex: 5,
          //           child: new TextFormField(
          //               enabled:
          //                   SharedManager.shared.isCouponApplied ? false : true,
          //               controller: couponController,
          //               decoration: InputDecoration(
          //                   hintText: S.current.apply_CouponCode,
          //                   hintStyle: new TextStyle(
          //                       color: AppColor.themeColor, fontSize: 14),
          //                   border: InputBorder.none),
          //               style: new TextStyle(
          //                   fontFamily: SharedManager.shared.fontFamilyName,
          //                   color: AppColor.black87,
          //                   fontWeight: FontWeight.w500,
          //                   fontSize: 17)),
          //         ),
          //         Padding(
          //           padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          //           child: Container(
          //             width: 1,
          //             color: AppColor.grey,
          //           ),
          //         ),
          //         Expanded(
          //             flex: 2,
          //             child: InkWell(
          //               onTap: () {
          //                 SharedManager.shared.isCouponApplied
          //                     ? _removeCouponCode()
          //                     : _applyPromocode();
          //               },
          //               child: Container(
          //                 child: Center(
          //                     child: setCommonText(
          //                         SharedManager.shared.isCouponApplied
          //                             ? '${S.current.delete}'
          //                             : '${S.current.apply}',
          //                         SharedManager.shared.isCouponApplied
          //                             ? AppColor.red
          //                             : AppColor.black87,
          //                         14.0,
          //                         FontWeight.w500,
          //                         1)),
          //               ),
          //             ))
          //       ],
          //     ),
          //   ),
          // ),
          SizedBox(
            height: 8,
          ),
          new Expanded(
            flex: 3,
            child: new Container(
                padding: new EdgeInsets.only(left: 15, right: 15),
                color: Colors.white,
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new Row(
                          children: <Widget>[
                            setCommonText(S.current.item_total, Colors.grey,
                                14.0, FontWeight.w500, 1),
                          ],
                        ),
                        new Row(
                          children: <Widget>[
                            new Stack(
                              alignment: Alignment.center,
                              children: <Widget>[
                                setCommonText(
                                    '${Currency.curr}${this.paidPrice}',
                                    Colors.grey,
                                    13.0,
                                    FontWeight.w500,
                                    1),
                                new Container(
                                    width: 40, height: 2, color: Colors.grey),
                              ],
                            ),
                            SizedBox(
                              width: 6,
                            ),
                            setCommonText('${Currency.curr}${this.totalPrice}',
                                Colors.grey, 13.0, FontWeight.w500, 1),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        setCommonText(S.current.charges, Colors.grey, 13.0,
                            FontWeight.w500, 1),
                        SizedBox(
                          width: 6,
                        ),
                        setCommonText(
                            '${Currency.curr}${SharedManager.shared.deliveryCharge}.0',
                            Colors.red,
                            13.0,
                            FontWeight.w500,
                            1),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        setCommonText(S.current.total_amount,
                            AppColor.themeColor, 13.0, FontWeight.w500, 1),
                        SizedBox(
                          width: 6,
                        ),
                        setCommonText(
                            '${Currency.curr}${(this.totalPrice + SharedManager.shared.deliveryCharge)}',
                            AppColor.themeColor,
                            13.0,
                            FontWeight.w500,
                            1),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Divider(
                      color: Colors.grey,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        setCommonText(S.current.grand_total, Colors.black, 14.0,
                            FontWeight.w500, 1),
                        SizedBox(
                          width: 6,
                        ),
                        setCommonText(
                            '${Currency.curr}${this.totalPrice + SharedManager.shared.deliveryCharge + this.riderTip}',
                            Colors.black,
                            14.0,
                            FontWeight.w500,
                            1),
                      ],
                    ),
                  ],
                )),
          ),
          SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }

  _applyPromocode() async {
    if (couponController.text == "") {
      SharedManager.shared
          .showAlertDialog('${S.current.applyPromocoFirst}', context);
      return;
    }

    showSnackbar(S.current.loading, _scaffoldKey, context);

    Requestmanager manager = Requestmanager();

    final param = {
      "user_id": SharedManager.shared.userID,
      "promocode": couponController.text
    };

    await manager.applyCouponCode(context, param).then((value) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      print('Success code ${value.code}');
      //0=>flat amount, 1=>percentage
      //discount will be based on Item Total
      if (value.code == 1) {
        //Percentage
        SharedManager.shared.isCouponApplied = true;
        SharedManager.shared.discountType = value.data.discountType;
        SharedManager.shared.discount = value.data.discount;
        SharedManager.shared.tempTotalPrice = this.totalPrice;
        SharedManager.shared.couponCode = couponController.text;

        if (value.data.discountType == "1") {
          // this.paidPrice
          // 595 - (595*15)/100 = 505.75
          setState(() {
            this.totalPrice = (this.totalPrice -
                (this.totalPrice * double.parse(value.data.discount)) / 100);
            SharedManager.shared.discountPice =
                ((SharedManager.shared.tempTotalPrice *
                            double.parse(value.data.discount)) /
                        100)
                    .toString();
          });
        }
        //Flat Amount
        else {
          this.totalPrice =
              (this.totalPrice - double.parse(value.data.discount));
          SharedManager.shared.discountPice = value.data.discount;
        }
      }
    });
  }

  _removeCouponCode() {
    if (SharedManager.shared.isCouponApplied) {
      setState(() {
        this.totalPrice = SharedManager.shared.tempTotalPrice;
        couponController.text = "";
        SharedManager.shared.isCouponApplied = false;
        SharedManager.shared.discountType = "";
        SharedManager.shared.discount = "";
        SharedManager.shared.discountPice = "0.0";
        SharedManager.shared.tempTotalPrice = 0.0;
      });
    }
  }

  _setPersonalDetailsWidgets() {
    return new Container(
        padding: new EdgeInsets.only(left: 15, right: 15),
        // height:100,
        // color: Colors.red,
        child: new Row(
          children: <Widget>[
            new Expanded(
              flex: 4,
              child: new Container(
                color: Colors.white,
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 5,
                    ),
                    setCommonText(S.current.personal_details, Colors.black,
                        14.0, FontWeight.w600, 1),
                    SizedBox(
                      height: 3,
                    ),
                    new Row(
                      children: <Widget>[
                        setCommonText(SharedManager.shared.deliveryAddressName,
                            Colors.grey, 14.0, FontWeight.w500, 1),
                        SizedBox(
                          width: 5,
                        ),
                        setCommonText(
                            SharedManager.shared.deliveryAddressNumber,
                            Colors.grey,
                            12.0,
                            FontWeight.w200,
                            1),
                      ],
                    ),
                    new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        setCommonText(S.current.delivery_food_to, Colors.black,
                            14.0, FontWeight.w600, 1),
                        SizedBox(
                          height: 2,
                        ),
                        (SharedManager.shared.addressId != "")
                            ? setCommonText(SharedManager.shared.address,
                                Colors.orange, 12.0, FontWeight.w500, 3)
                            : setCommonText(S.current.select_address,
                                Colors.orange, 12.0, FontWeight.w500, 3),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            new Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: () async {
                  final status = await Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ChangeAddress()));
                  if (status) {
                    setState(() {
                      print(
                          'Delivery Charges is:${SharedManager.shared.deliveryCharge}');
                    });
                  }
                },
                child: new Container(
                  child: new Center(
                    child: setCommonText(S.current.change, AppColor.themeColor,
                        14.0, FontWeight.w500, 1),
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('Cart list count:${this.store.cartItemList.length}');
    // if (this.store.cartItemList.length > 0) {
    //   _setTotalPriceCount();
    // }
  }

  @override
  Widget build(BuildContext context) {
    this.store = Provider.of<StoreProvider>(context);
    _setTotalPriceCount();
    return new Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      body: (SharedManager.shared.isLoggedIN == 'yes')
          ? ((this.store.cartItemList.length > 0)
              ? new Container(
                  child: Column(
                  children: <Widget>[
                    new Expanded(
                        flex: 10,
                        child: new Container(
                          color: Colors.white,
                          child: new ListView(
                            children: <Widget>[
                              _setAddedCartListWidgets(),
                              // _setRiderTipWidgets(),
                              _setPromoCodeGrandTotalWidgets(),
                              _setPersonalDetailsWidgets(),
                              // _setCouponWidget(),
                              SizedBox(
                                height: 15,
                              )
                            ],
                          ),
                        )),
                    new Expanded(
                      flex: 1,
                      child: _setBottomPlaceOrderWidgets(),
                    )
                  ],
                ))
              : dataFound(context, S.current.dont_have_single_item_to_cart,
                  AssetImage(AppImages.cartDefaultImage), "0"))
          : setLockedAccessWidgets(context, true),
      appBar: new AppBar(
        centerTitle: true,
        leading: (!SharedManager.shared.isFromTab)
            ? ((this.store.cartItemList.length > 0)
                ? new IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: AppColor.white,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    color: Colors.white,
                  )
                : new Text(''))
            : new Text(''),
        backgroundColor: AppColor.themeColor,
        elevation: 0.0,
        brightness: Brightness.light,
        title: setCommonText(
            S.current.cart, AppColor.white, 20.0, FontWeight.w600, 1),
      ),
    );
  }
}
