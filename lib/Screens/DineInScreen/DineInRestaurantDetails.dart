import 'package:flutter/material.dart';
import 'package:product/Helper/CommonWidgets.dart';
import 'package:product/Helper/Constant.dart';
import 'package:product/Helper/SharedManaged.dart';
import 'package:product/ModelClass/DineInCategoryClass.dart';

import 'DineInCheckout.dart';

class DineInRestaurantDetails extends StatefulWidget {
  @override
  _DineInRestaurantDetailsState createState() =>
      _DineInRestaurantDetailsState();
}

class _DineInRestaurantDetailsState extends State<DineInRestaurantDetails> {
  var message = 'Please enter your login credentials for host the meeting';
  int state = 1;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var selectedIndex = 0;
  List<CATEGORY> categoryFilter = [];
  List<ITEM> cartList = [];
  var finalTotal = '0';

  List<CATEGORY> allCategory = [
    CATEGORY('1', 'Pizza', '1', [
      ITEM(
        '1',
        'Mozzarella Pizza',
        'tomato sauce, mozzarella sabelli, cherry tomatoes, olives, pesto sauce, extra virgin olive oil',
        '1',
        '',
        '',
        '15.99',
        'Assets/DineIn/MozzarellaPizza.jpg',
        [
          SIZE('Small', '0', '0'),
          SIZE('Medium', '5', '0'),
          SIZE('Large', '8', '0'),
        ],
        [
          EXTRA('Cheese', '1', '0'),
        ],
      ),
      ITEM(
        '2',
        'Carriola Pizza',
        'tomato sauce, mozzarella sabelli, bacon, red onion, olives, extra virgin olive oil',
        '1',
        '',
        '',
        '18.99',
        'Assets/DineIn/CarronilPizza.jpg',
        [
          SIZE('Small', '0', '0'),
          SIZE('Medium', '7', '0'),
          SIZE('Large', '9', '0'),
        ],
        [
          EXTRA('Cheese', '1', '0'),
          EXTRA('olives', '3', '0'),
        ],
      ),
    ]),
    CATEGORY('2', 'Salads', '0', [
      ITEM(
        '1',
        'Caprese Salad (350gr)',
        'peeled tomatoes, mozzarella salad, Genovese pesto',
        '1',
        '',
        '',
        '15.99',
        'Assets/DineIn/Caesar_Salad.jpg',
        [],
        [
          EXTRA('Extra olives ', '1.50', '0'),
          EXTRA('Extra cheese ', '1.20', '0'),
          EXTRA('Tuna ', '1.70', '0'),
        ],
      ),
      ITEM(
        '2',
        'Caesar Salad (400g)',
        'iceberg, bacon, chicken breast, parmesan, Caesar sauce',
        '1',
        '',
        '',
        '18.99',
        'Assets/DineIn/Caprese_Salad.jpg',
        [],
        [
          EXTRA('Extra olives ', '1.50', '0'),
          EXTRA('Extra cheese ', '1.20', '0'),
          EXTRA('Tuna ', '1.70', '0'),
        ],
      ),
      ITEM(
        '3',
        'Green tuna salad (400g)',
        'lettuce, cucumbers, tuna, olive, corn, lemon, salad dressing: (Extra Virgin olive oil, Modena balsamic vinegar, honey and mustard)',
        '1',
        '',
        '',
        '18.99',
        'Assets/DineIn/Green_tuna_salad.jpg',
        [],
        [
          EXTRA('Extra cheese ', '1.20', '0'),
          EXTRA('Tuna ', '1.70', '0'),
        ],
      ),
    ]),
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.categoryFilter = allCategory;
  }

  @override
  Widget build(BuildContext context) {
    final double height = 130;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColor.white),
        title: setCommonText(
            'Grand Bhagvati', AppColor.white, 22.0, FontWeight.bold, 1),
        elevation: 0.0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.shopping_cart, color: AppColor.white),
          )
        ],
      ),
      key: _scaffoldKey,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  ClipPath(
                    clipper: BezierClipper(state),
                    child: Container(
                        padding: EdgeInsets.only(left: 15, right: 15),
                        width: MediaQuery.of(context).size.width,
                        color: AppColor.themeColor,
                        height: height,
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                setHeight(3),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.place,
                                      color: AppColor.white,
                                      size: 20,
                                    ),
                                    setWidth(5),
                                    Expanded(
                                      child: setCommonText(
                                          'B-206, Shindhu bhavan Road, S.G Highway Ahmedabad 380060',
                                          AppColor.white,
                                          16.0,
                                          FontWeight.w400,
                                          3),
                                    ),
                                  ],
                                ),
                                setHeight(5),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.watch_later,
                                      color: AppColor.white,
                                      size: 19,
                                    ),
                                    setWidth(5),
                                    Expanded(
                                      child: setCommonText(
                                          '11.00 AM : 10:30 PM',
                                          AppColor.white,
                                          15.0,
                                          FontWeight.w400,
                                          3),
                                    ),
                                  ],
                                ),
                                setHeight(8),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.phone_android,
                                      color: AppColor.white,
                                      size: 19,
                                    ),
                                    setWidth(5),
                                    Expanded(
                                      child: setCommonText(
                                          '+91909878909',
                                          AppColor.white,
                                          15.0,
                                          FontWeight.w400,
                                          3),
                                    ),
                                  ],
                                ),
                                setHeight(30),
                              ],
                            ))),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(
                        top: 10, left: 15, right: 15, bottom: 8),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          setCommonText('Restaurant Menu', AppColor.black, 18.0,
                              FontWeight.w500, 1),
                          setHeight(10),
                          _setRestaurantMenu(),
                        ]),
                  ),
                  Column(
                    children: _setItemView(),
                  )
                ],
              ),
            ),
          ),
          (this.cartList.length == 0)
              ? setHeight(1)
              : Container(
                  height: 50,
                  color: AppColor.white,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(left: 12, right: 12),
                          // color: AppColor.amber,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              setCommonText('TOTAL', AppColor.black, 15.0,
                                  FontWeight.w600, 1),
                              setCommonText(
                                  '${Currency.curr}${this.finalTotal}',
                                  AppColor.themeColor,
                                  14.0,
                                  FontWeight.w800,
                                  1),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: InkWell(
                            onTap: () async {
                              await Navigator.of(context)
                                  .push(MaterialPageRoute(
                                      builder: (context) => DineInCheckout(
                                            categoryList: this.allCategory,
                                            cartList: this.cartList,
                                          )))
                                  .then((val) {
                                setState(() {
                                  _updateView();
                                });
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: AppColor.themeColor,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              height: 40,
                              width: 120,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  setCommonText('CHECKOUT', AppColor.white,
                                      14.0, FontWeight.w600, 1),
                                  Icon(Icons.arrow_forward_outlined,
                                      color: AppColor.white)
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      setWidth(30)
                    ],
                  ),
                )
        ],
      ),
    );
  }

  String _getCartCount() {
    var count = 0;
    this.cartList = [];
    for (var category in this.allCategory) {
      var arrayList =
          category.itemList.where((i) => i.isAddedtoCart == '1').toList();
      if (arrayList.length > 0) {
        count = count + arrayList.length;
      }
      for (var item in arrayList) {
        this.cartList.add(item);
      }
    }
    print('Category Count:-->$count');
    print('Cart list Item:--->${cartList.length}');
    return count.toString();
  }

  _getTotal() {
    this.finalTotal = '0.0';
    for (var item in cartList) {
      List<EXTRA> tmpExtra =
          item.itemextra.where((i) => i.isSelected == '1').toList();
      List<SIZE> tmpSize =
          item.itemSize.where((i) => i.isSelected == '1').toList();
      if (tmpExtra.length > 0) {
        this.finalTotal = (double.parse(this.finalTotal) +
                double.parse(tmpExtra[0].extraPrice))
            .toString();
      }
      if (tmpSize.length > 0) {
        this.finalTotal = (double.parse(this.finalTotal) +
                double.parse(tmpSize[0].extraPrice))
            .toString();
      }
      this.finalTotal = (double.parse(this.finalTotal) +
              (double.parse(item.actualPrice) * int.parse(item.quantity)))
          .toStringAsFixed(2);
    }
    setState(() {});
  }

  List<String> categoryList = [
    'All',
    'Pizza',
    'Starter',
    'Panjabi',
    'South-Indian',
    'Chapati',
    'Drinks'
  ];
  _setRestaurantMenu() {
    return Container(
      height: 45,
      // color: AppColor.red,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: this.allCategory.length + 1,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(3.0),
            child: InkWell(
              onTap: () {
                this.selectedIndex = index;
                this.categoryFilter = [];
                if (selectedIndex == 0) {
                  //Add all data
                  this.categoryFilter = this.allCategory;
                  setState(() {});
                } else {
                  this
                      .categoryFilter
                      .add(this.allCategory[this.selectedIndex - 1]);
                  setState(() {});
                }
              },
              child: Container(
                alignment: Alignment.center,
                // width: 100,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(19.5),
                    border: Border.all(color: AppColor.themeColor, width: 1),
                    color: (selectedIndex == index)
                        ? AppColor.themeColor
                        : AppColor.white),
                child: setCommonText(
                    (index == 0)
                        ? '    All    '
                        : '    ${this.allCategory[index - 1].title}    ',
                    (selectedIndex == index)
                        ? AppColor.white
                        : AppColor.themeColor,
                    16.0,
                    FontWeight.w500,
                    1),
              ),
            ),
          );
        },
      ),
    );
  }

  List<Widget> _setItemView() {
    List<Widget> widgetList = [];
    for (var category in this.categoryFilter) {
      widgetList.add(_createWidget(category));
    }
    return widgetList;
  }

  _updateView() {
    setState(() {
      _getCartCount();
      _getTotal();
    });
  }

  _createWidget(CATEGORY category) {
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15),
      height: (category.itemList.length * 90.0) + 50.0,
      // color: AppColor.red,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          setCommonText(
              '${category.title}', AppColor.black, 16.0, FontWeight.w500, 1),
          setHeight(5),
          Expanded(
              child: Container(
            // color: AppColor.amber,
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: category.itemList.length,
              itemBuilder: (context, row) {
                return Container(
                  height: 90,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 75,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage(
                                      category.itemList[row].image))),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          // color: AppColor.amber,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // setHeight(5),
                              setCommonText(
                                  '${category.itemList[row].itemName}',
                                  AppColor.black87,
                                  14.0,
                                  FontWeight.w500,
                                  1),
                              setHeight(3),
                              setCommonText(
                                  '${category.itemList[row].itemContent}',
                                  AppColor.grey[500],
                                  12.0,
                                  FontWeight.w400,
                                  2),
                              setHeight(8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  setCommonText(
                                      '${Currency.curr}${category.itemList[row].actualPrice}',
                                      AppColor.black,
                                      12.0,
                                      FontWeight.w500,
                                      1),
                                  InkWell(
                                    onTap: () {
                                      if (category
                                              .itemList[row].isAddedtoCart ==
                                          '0') {
                                        presentBottomSheetss(
                                            row,
                                            category,
                                            context,
                                            category.itemList[row].itemContent,
                                            category.itemList[row].actualPrice,
                                            '',
                                            '',
                                            '',
                                            category.itemList[row].itemName,
                                            category.itemList[row].image,
                                            '',
                                            '',
                                            '',
                                            category.itemList[row].itemSize,
                                            category.itemList[row].itemextra);
                                      } else {
                                        setState(() {
                                          category.itemList[row].isAddedtoCart =
                                              '0';
                                          _updateView();
                                        });
                                      }
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 25,
                                      width: 60,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: AppColor.themeColor)),
                                      child: setCommonText(
                                          (category.itemList[row]
                                                      .isAddedtoCart ==
                                                  '1')
                                              ? 'Delete'
                                              : 'Add',
                                          AppColor.themeColor,
                                          12.0,
                                          FontWeight.w500,
                                          1),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          )),
          Divider()
        ],
      ),
    );
  }

  String _getSelectedSizePrize(List<SIZE> sizeList) {
    var arrayList = sizeList.where((i) => i.isSelected == '1').toList();
    if (arrayList.length > 0) {
      return arrayList[0].extraPrice;
    } else {
      return '0';
    }
  }

  String _getSelectedExtraPrize(List<EXTRA> sizeList) {
    var arrayList = sizeList.where((i) => i.isSelected == '1').toList();
    if (arrayList.length > 0) {
      return arrayList[0].extraPrice;
    } else {
      return '0';
    }
  }

  presentBottomSheetss(
    int index,
    CATEGORY category,
    BuildContext context,
    String itemContent,
    String price,
    String discountPrice,
    String dishId,
    String cookId,
    String title,
    String image,
    String pickup,
    String delivery,
    String startTime,
    List<SIZE> sizeList,
    List<EXTRA> extraList,
  ) {
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Container(
              // padding: EdgeInsets.only(
              //     bottom: MediaQuery.of(context).viewInsets.bottom),
              height: 470 + MediaQuery.of(context).viewInsets.bottom,
              decoration: BoxDecoration(
                  color: AppColor.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  setHeight(20),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15),
                    child: Row(
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              image: DecorationImage(image: AssetImage(image))),
                        ),
                        setWidth(5),
                        Expanded(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            setCommonText('$title', AppColor.black, 14.0,
                                FontWeight.w500, 1),
                            setCommonText(
                                '${Currency.curr} ${(double.parse(price) + double.parse(_getSelectedExtraPrize(extraList)) + double.parse(_getSelectedSizePrize(sizeList))).toStringAsFixed(2)}',
                                AppColor.black,
                                12.0,
                                FontWeight.w500,
                                2),
                          ],
                        ))
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: setCommonText('$itemContent', AppColor.grey, 12.0,
                        FontWeight.w500, 2),
                  ),
                  setHeight(5),
                  (sizeList.length == 0)
                      ? setHeight(0)
                      : Container(
                          height: (sizeList.length > 3) ? 130 : 85,
                          // color: AppColor.amber,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 12, right: 12),
                                child: setCommonText('Size', AppColor.black,
                                    14.0, FontWeight.w500, 2),
                              ),
                              setHeight(5),
                              Expanded(
                                child: new GridView.count(
                                  scrollDirection: Axis.vertical,
                                  crossAxisCount: 3,
                                  childAspectRatio: 2.5,
                                  children: new List<Widget>.generate(
                                      sizeList.length, (index) {
                                    return Container(
                                      height: 35,
                                      // color: AppColor.red,
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            value:
                                                (sizeList[index].isSelected ==
                                                        '0')
                                                    ? false
                                                    : true,
                                            onChanged: (val) {
                                              setState(() {
                                                for (var item in sizeList) {
                                                  item.isSelected = '0';
                                                }
                                                val
                                                    ? sizeList[index]
                                                        .isSelected = '1'
                                                    : sizeList[index]
                                                        .isSelected = '0';
                                              });
                                            },
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              setCommonText(
                                                  '${sizeList[index].title}',
                                                  AppColor.grey,
                                                  10.0,
                                                  FontWeight.w500,
                                                  2),
                                              setCommonText(
                                                  '${Currency.curr}${sizeList[index].extraPrice}',
                                                  AppColor.black,
                                                  10.0,
                                                  FontWeight.w500,
                                                  1)
                                            ],
                                          )
                                        ],
                                      ),
                                    );
                                  }),
                                ),
                              ),
                              Divider(),
                            ],
                          ),
                        ),
                  setHeight(5),
                  (extraList.length == 0)
                      ? setHeight(2)
                      : Container(
                          height: (extraList.length > 3) ? 130 : 85,
                          // color: AppColor.amber,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 12, right: 12),
                                child: setCommonText('Extra', AppColor.black,
                                    14.0, FontWeight.w500, 2),
                              ),
                              setHeight(5),
                              Expanded(
                                child: new GridView.count(
                                  scrollDirection: Axis.vertical,
                                  crossAxisCount: 3,
                                  childAspectRatio: 2.5,
                                  children: new List<Widget>.generate(
                                      extraList.length, (index) {
                                    return Container(
                                      // height: 55,
                                      // color: AppColor.red,
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            value:
                                                (extraList[index].isSelected ==
                                                        '0')
                                                    ? false
                                                    : true,
                                            onChanged: (val) {
                                              setState(() {
                                                for (var item in extraList) {
                                                  item.isSelected = '0';
                                                }
                                                val
                                                    ? extraList[index]
                                                        .isSelected = '1'
                                                    : extraList[index]
                                                        .isSelected = '0';
                                              });
                                            },
                                          ),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                setCommonText(
                                                    '${extraList[index].title}',
                                                    AppColor.grey,
                                                    10.0,
                                                    FontWeight.w500,
                                                    2),
                                                setCommonText(
                                                    '${Currency.curr}${extraList[index].extraPrice}',
                                                    AppColor.black,
                                                    10.0,
                                                    FontWeight.w500,
                                                    1)
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  }),
                                ),
                              ),
                              Divider(),
                            ],
                          ),
                        ),
                  setHeight(8),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        setCommonText('Add Restaurant Note', AppColor.black,
                            14.0, FontWeight.w500, 1),
                        setHeight(5),
                        Container(
                          height: 50,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  setWidth(5),
                                  Expanded(
                                    child: TextFormField(
                                      // controller: noteController,
                                      onChanged: (val) {
                                        category.itemList[index].note = val;
                                      },
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'Enter note here'),
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: SharedManager
                                              .shared.fontFamilyName),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                height: 1,
                                color: AppColor.grey,
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  setHeight(30),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15),
                    child: Row(
                      children: [
                        Expanded(
                            child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                            for (var itemExtra
                                in category.itemList[index].itemextra) {
                              itemExtra.isSelected = '0';
                            }
                            for (var itemSize
                                in category.itemList[index].itemSize) {
                              itemSize.isSelected = '0';
                            }
                          },
                          child: Container(
                            height: 45,
                            decoration: BoxDecoration(
                                color: AppColor.white,
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: AppColor.themeColor)),
                            child: Center(
                              child: setCommonText(
                                  'Cancel',
                                  AppColor.themeColor,
                                  16.0,
                                  FontWeight.w500,
                                  1),
                            ),
                          ),
                        )),
                        setWidth(15),
                        Expanded(
                            child: InkWell(
                          onTap: () async {
                            //this for update the globle array
                            for (var cat in allCategory) {
                              if (cat.id == category.id) {
                                for (var item in cat.itemList) {
                                  if (item.id == category.itemList[index].id) {
                                    item.isAddedtoCart = '1';
                                    item.note = cat.itemList[index].note;
                                  }
                                }
                              }
                            }
                            setState(() {
                              category.itemList[index].isAddedtoCart = '1';
                            });
                            Navigator.of(context).pop();
                            _updateView();
                          },
                          child: Container(
                            height: 45,
                            decoration: BoxDecoration(
                              color: AppColor.themeColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(
                              child: setCommonText('Add to Cart',
                                  AppColor.white, 16.0, FontWeight.w500, 1),
                            ),
                          ),
                        )),
                      ],
                    ),
                  )
                ],
              ),
            );
          });
        });
  }
}

class BezierClipper extends CustomClipper<Path> {
  BezierClipper(this.state);

  final int state;

  @override
  Path getClip(Size size) => _getInitialClip(size);

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;

  Path _getInitialClip(Size size) {
    Path path = new Path();
    path.lineTo(0, size.height * 0.90); //vertical line
    path.cubicTo(size.width / 3, size.height, 2 * size.width / 3,
        size.height * 0.7, size.width, size.height * 0.75); //cubic curve
    path.lineTo(size.width, 0); //vertical line
    return path;
  }
}

// class CATEGORY {
//   String id;
//   String title;
//   String isSelect;
//   List<ITEM> itemList;
//   CATEGORY(
//     this.id,
//     this.title,
//     this.isSelect,
//     this.itemList,
//   );
// }

// class ITEM {
//   String id;
//   String itemName;
//   String itemContent;
//   String quantity;
//   String note;
//   String isAddedtoCart;
//   String actualPrice;
//   String image;
//   List<SIZE> itemSize;
//   List<EXTRA> itemextra;
//   ITEM(
//     this.id,
//     this.itemName,
//     this.itemContent,
//     this.quantity,
//     this.note,
//     this.isAddedtoCart,
//     this.actualPrice,
//     this.image,
//     this.itemSize,
//     this.itemextra,
//   );
// }

// class SIZE {
//   String title;
//   String extraPrice;
//   String isSelected;
//   SIZE(
//     this.title,
//     this.extraPrice,
//     this.isSelected,
//   );
// }

// class EXTRA {
//   String title;
//   String extraPrice;
//   String isSelected;
//   EXTRA(
//     this.title,
//     this.extraPrice,
//     this.isSelected,
//   );
// }
