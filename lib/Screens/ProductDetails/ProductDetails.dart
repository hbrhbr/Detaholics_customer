import 'package:flutter/material.dart';
import 'package:product/Helper/CommonWidgets.dart';
import 'package:product/Helper/Constant.dart';
import 'package:badges/badges.dart';
import 'package:product/Helper/SharedManaged.dart';
import 'package:product/ModelClass/ModelRestaurantDetails.dart';
import 'package:product/Provider/StoreProvider.dart';
import 'package:product/Screens/Cart/Cart.dart';
import 'package:product/generated/i18n.dart';
import 'package:provider/provider.dart';

class ProductDetails extends StatefulWidget {
  final Subcategories productData;
  final String resId;
  ProductDetails({this.productData, this.resId});

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  StoreProvider store = StoreProvider();
  bool isAddedToCart = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkProductStatus();
  }

  _checkProductStatus() {
    if (this.widget.productData.isAdded) {
      this.isAddedToCart = true;
    } else {
      this.isAddedToCart = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    this.store = Provider.of<StoreProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.white,
        elevation: 0.0,
        title: setCommonText(
            'Product Details', AppColor.black, 20.0, FontWeight.w600, 1),
        actions: [
          Badge(
            showBadge: true,
            position: BadgePosition(top: 0, end: 2),
            animationType: BadgeAnimationType.scale,
            badgeContent: Text(
              '${this.store.getTotalCartCount()}',
              style: TextStyle(color: Colors.white),
            ),
            child: IconButton(
              icon: Icon(
                Icons.shopping_cart,
                color: Colors.black45,
              ),
              onPressed: () {},
            ),
          ),
          setWidth(5)
        ],
      ),
      body: SafeArea(
        child: Container(
          color: AppColor.white,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      color: AppColor.white,
                      child: setNetworkImage(
                          this.widget.productData.image,
                          MediaQuery.of(context).size.height / 2.5,
                          MediaQuery.of(context).size.width),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColor.white,
                      ),
                      padding: EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              (double.parse(this.widget.productData.discount) == 0)
                                  ? setWidth(0)
                                  : setCommonText(
                                (this.widget.productData.discountType == '0')
                                          ? '${Currency.curr}${this.widget.productData.discount} off'
                                          : '${this.widget.productData.discount}% off',
                                      AppColor.red,
                                      18.0,
                                      FontWeight.w600,
                                      1),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  (double.parse(this.widget.productData.discount) == 0)
                                      ? setWidth(0)
                                      : Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            setCommonText(
                                                '${Currency.curr}${this.widget.productData.price}',
                                                AppColor.grey,
                                                18.0,
                                                FontWeight.w600,
                                                1),
                                            Container(
                                              height: 3,
                                              width: 70,
                                              color: AppColor.deepOrange,
                                            )
                                          ],
                                        ),
                                  setWidth(8),
                                  setCommonText(
                                      '${Currency.curr}${calculateDiscount(this.widget.productData.price, this.widget.productData.discount, this.widget.productData.discountType)}',
                                      AppColor.themeColor,
                                      18.0,
                                      FontWeight.w600,
                                      1)
                                ],
                              ),
                            ],
                          ),
                          setHeight(5),
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Expanded(
                                    child: Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      setCommonText(
                                          '${this.store.restaurantDetails.name} ',
                                          AppColor.black87,
                                          14.0,
                                          FontWeight.w600,
                                          1),
                                      setCommonText(
                                          '${this.store.restaurantDetails.address}',
                                          AppColor.grey,
                                          12.0,
                                          FontWeight.w600,
                                          2)
                                    ],
                                  ),
                                )),
                                setCommonText(
                                    (this.widget.productData.isAvailable == '1')
                                        ? 'Available'
                                        : 'Out of Stock',
                                    (this.widget.productData.isAvailable == '1')
                                        ? AppColor.themeColor
                                        : AppColor.red,
                                    16.0,
                                    FontWeight.w400,
                                    1)
                              ]),
                          setHeight(15),
                          new Row(
                            children: <Widget>[
                              Image(
                                  height: 20,
                                  width: 20,
                                  fit: BoxFit.cover,
                                  image: AssetImage((this
                                              .widget
                                              .productData
                                              .type ==
                                          '1')
                                      ? 'Assets/RestaurantDetails/veg.png'
                                      : 'Assets/RestaurantDetails/nonVeg.png')),
                              setWidth(5),
                              new Expanded(
                                  flex: 2,
                                  child: setCommonText(
                                      this.widget.productData.name,
                                      AppColor.black,
                                      20.0,
                                      FontWeight.w500,
                                      1)),
                              // SizedBox(width: 5,),
                            ],
                          ),
                          // setCommonText('${this.widget.productData.name}',
                          //     AppColor.black, 20.0, FontWeight.w600, 1),
                          setHeight(5),
                          setCommonText(
                              '${this.widget.productData.catigoryName}',
                              AppColor.deepOrange,
                              16.0,
                              FontWeight.w600,
                              1),
                          setHeight(8),
                          setCommonText(
                              '${this.widget.productData.description}',
                              AppColor.black54,
                              14.0,
                              FontWeight.w400,
                              10),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: 50,
                color: AppColor.themeColor,
                child: Row(
                  children: [
                    Expanded(
                        child: InkWell(
                      onTap: () {
                        //check restaurant close or not
                        if (store.restaurantDetails.isAvailable == '1') {
                          //check item availability
                          //Add to cart or delete from cart
                          if (this.widget.productData.isAvailable == '1') {
                            if (this.isAddedToCart) {
                              this.store.removeItemFromCart(this.widget.productData);
                              this.isAddedToCart = false;
                            } else {
                              this.store.addItemTocart(this.widget.productData,
                                  this.widget.resId, context);
                              this.isAddedToCart = true;
                            }
                          } else {
                            SharedManager.shared.showAlertDialog(
                                'Item is out of stock', context);
                          }
                        } else {
                          SharedManager.shared
                              .showAlertDialog('Restaurant is closed', context);
                        }
                        // setState(() {});
                      },
                      child: Container(
                        alignment: Alignment.center,
                        child: setCommonText(
                            (this.isAddedToCart)
                                ? 'Delete From Cart'
                                : 'Add to Cart',
                            AppColor.white,
                            17.0,
                            FontWeight.w600,
                            1),
                      ),
                    )),
                    Expanded(
                        child: InkWell(
                      onTap: () async {
                        if (this.store.getTotalCartCount() > 0) {
                          SharedManager.shared.resAddress =
                              this.store.restaurantDetails.address;
                          SharedManager.shared.resImage =
                              this.store.restaurantDetails.bannerImage;
                          SharedManager.shared.resName =
                              this.store.restaurantDetails.name;
                          SharedManager.shared.isFromTab = false;
                          await Navigator.of(context)
                              .push(MaterialPageRoute(
                                  builder: (context) => CartApp(
                                      productData: this.widget.productData)))
                              .then((value) {
                            setState(() {
                              print(
                                  'Helllo==========>${this.widget.productData.isAdded}');

                              _checkProductStatus();
                            });
                          });
                        } else {
                          SharedManager.shared
                              .showAlertDialog('Cart is Empty', context);
                        }
                      },
                      child: Container(
                        color: AppColor.white,
                        child: Column(
                          children: [
                            Container(
                              color: AppColor.themeColor,
                              height: 1,
                            ),
                            Expanded(
                                child: Center(
                              child: setCommonText(
                                  '${S.current.checkout}',
                                  AppColor.themeColor,
                                  17.0,
                                  FontWeight.w600,
                                  1),
                            ))
                          ],
                        ),
                      ),
                    )),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
