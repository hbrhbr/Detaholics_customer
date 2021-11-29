import 'package:flutter/material.dart';
import 'package:product/Helper/CommonWidgets.dart';
import 'package:product/Helper/Constant.dart';
import 'package:product/ModelClass/DineInCategoryClass.dart';
import 'DineInOrderSuccess.dart';

class DineInCheckout extends StatefulWidget {
  final List<CATEGORY> categoryList;
  final List<ITEM> cartList;
  DineInCheckout({this.categoryList, this.cartList});
  @override
  _DineInCheckoutState createState() => _DineInCheckoutState();
}

class _DineInCheckoutState extends State<DineInCheckout> {
  String _getTotal(ITEM item) {
    var finalTotal = '0.0';

    List<EXTRA> tmpExtra =
        item.itemextra.where((i) => i.isSelected == '1').toList();
    List<SIZE> tmpSize =
        item.itemSize.where((i) => i.isSelected == '1').toList();
    if (tmpExtra.length > 0) {
      finalTotal =
          (double.parse(finalTotal) + double.parse(tmpExtra[0].extraPrice))
              .toString();
    }
    if (tmpSize.length > 0) {
      finalTotal =
          (double.parse(finalTotal) + double.parse(tmpSize[0].extraPrice))
              .toString();
    }
    finalTotal = (double.parse(finalTotal) +
            (double.parse(item.actualPrice) * int.parse(item.quantity)))
        .toStringAsFixed(2);
    return finalTotal;
  }

  _selectItemListView() {
    return Container(
      height: this.widget.cartList.length * 160.0,
      // color: AppColor.red.shade50,
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: this.widget.cartList.length,
        itemBuilder: (context, row) {
          return Container(
            // height: 100,
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 75,
                        height: 75,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage(
                                    this.widget.cartList[row].image))),
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
                                '${this.widget.cartList[row].itemName}',
                                AppColor.black87,
                                14.0,
                                FontWeight.w500,
                                1),
                            setHeight(3),
                            setCommonText(
                                '${this.widget.cartList[row].itemContent}',
                                AppColor.grey[500],
                                12.0,
                                FontWeight.w400,
                                2),
                            setHeight(8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                setCommonText(
                                    '${Currency.curr}${_getTotal(this.widget.cartList[row])}',
                                    AppColor.black,
                                    12.0,
                                    FontWeight.w500,
                                    1),
                                Container(
                                  height: 30,
                                  width: 80,
                                  color: AppColor.amber,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: InkWell(
                                          onTap: () {
                                            if (int.parse(this
                                                    .widget
                                                    .cartList[row]
                                                    .quantity) >
                                                1) {
                                              setState(() {
                                                this
                                                    .widget
                                                    .cartList[row]
                                                    .quantity = (int.parse(this
                                                            .widget
                                                            .cartList[row]
                                                            .quantity) -
                                                        1)
                                                    .toString();
                                              });
                                              _updateQuantity(row);
                                            }
                                          },
                                          child: Container(
                                            alignment: Alignment.topCenter,
                                            child: setCommonText(
                                                '-',
                                                AppColor.black,
                                                50.0,
                                                FontWeight.w400,
                                                1),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: setCommonText(
                                              '${this.widget.cartList[row].quantity}',
                                              AppColor.black,
                                              16.0,
                                              FontWeight.w500,
                                              1),
                                        ),
                                      ),
                                      Expanded(
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              this
                                                  .widget
                                                  .cartList[row]
                                                  .quantity = (int.parse(this
                                                          .widget
                                                          .cartList[row]
                                                          .quantity) +
                                                      1)
                                                  .toString();
                                            });
                                            _updateQuantity(row);
                                          },
                                          child: Container(
                                            alignment: Alignment.topCenter,
                                            child: setCommonText(
                                                '+',
                                                AppColor.black,
                                                50.0,
                                                FontWeight.w400,
                                                1),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: InkWell(
                                    onTap: () {
                                      for (var cat
                                          in this.widget.categoryList) {
                                        for (var item in cat.itemList) {
                                          if (item.id ==
                                              this.widget.cartList[row].id) {
                                            item.isAddedtoCart = '0';
                                          }
                                        }
                                      }
                                      setState(() {
                                        this.widget.cartList.removeAt(row);
                                      });
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 25,
                                      width: 60,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: AppColor.themeColor)),
                                      child: setCommonText(
                                          (this
                                                      .widget
                                                      .cartList[row]
                                                      .isAddedtoCart ==
                                                  '1')
                                              ? 'Delete'
                                              : 'Add',
                                          AppColor.themeColor,
                                          12.0,
                                          FontWeight.w500,
                                          1),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            setHeight(5),
                            Container(
                                height: 40,
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        setCommonText(
                                            'Note: ',
                                            AppColor.black87,
                                            13.0,
                                            FontWeight.w400,
                                            1),
                                        Expanded(
                                          child: setCommonText(
                                              '${this.widget.cartList[row].note}',
                                              AppColor.black,
                                              10.0,
                                              FontWeight.w400,
                                              1),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        (_getSize(this
                                                    .widget
                                                    .cartList[row]
                                                    .itemSize) ==
                                                '')
                                            ? setHeight(1)
                                            : Row(
                                                children: [
                                                  setCommonText(
                                                      'Size: ${_getSize(this.widget.cartList[row].itemSize)}',
                                                      AppColor.black,
                                                      13.0,
                                                      FontWeight.w400,
                                                      1),
                                                  setCommonText(
                                                      ', ',
                                                      AppColor.black,
                                                      13.0,
                                                      FontWeight.w400,
                                                      1),
                                                ],
                                              ),
                                        (_getExtra(this
                                                    .widget
                                                    .cartList[row]
                                                    .itemextra) ==
                                                '1')
                                            ? setHeight(1)
                                            : setCommonText(
                                                'Extra: ${_getExtra(this.widget.cartList[row].itemextra)}',
                                                AppColor.black,
                                                13.0,
                                                FontWeight.w400,
                                                1),
                                      ],
                                    ),
                                  ],
                                ))
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                Divider()
              ],
            ),
          );
        },
      ),
    );
  }

  _updateQuantity(int row) {
    for (var cat in this.widget.categoryList) {
      for (var item in cat.itemList) {
        if (item.id == this.widget.cartList[row].id) {
          item.quantity = this.widget.cartList[row].quantity;
        }
      }
    }
  }

  String _getSize(List<SIZE> sizeList) {
    List<SIZE> arrayList = sizeList.where((i) => i.isSelected == '1').toList();
    if (arrayList.length > 0) {
      return arrayList[0].title;
    } else {
      return '';
    }
  }

  String _getExtra(List<EXTRA> extraList) {
    List<EXTRA> arrayList =
        extraList.where((i) => i.isSelected == '1').toList();
    if (arrayList.length > 0) {
      return arrayList[0].title;
    } else {
      return '';
    }
  }

  _setDeliveryDetails() {
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          setCommonText(
              'Delivery Details', AppColor.black, 18.0, FontWeight.w600, 1),
          Divider(),
          _setCommonWidget('Name:', 'Hardik Dabhi'),
          _setCommonWidget('Email:', 'HD@gmail.com'),
          _setCommonWidget('Delivery Type:', 'DineIn'),
          _setCommonWidget('Table No:', '12'),
        ],
      ),
    );
  }

  _setCommonWidget(String title, String value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        setCommonText('$title', AppColor.black, 15.0, FontWeight.w500, 1),
        setHeight(3),
        setCommonText('$value', AppColor.black54, 13.0, FontWeight.w500, 1),
        setHeight(3),
        Container(height: 1, color: AppColor.grey[200]),
        setHeight(8),
      ],
    );
  }

  String _calculateGrandTotal() {
    var finalTotal = '0.0';
    for (var item in this.widget.cartList) {
      List<EXTRA> tmpExtra =
          item.itemextra.where((i) => i.isSelected == '1').toList();
      List<SIZE> tmpSize =
          item.itemSize.where((i) => i.isSelected == '1').toList();
      if (tmpExtra.length > 0) {
        finalTotal =
            (double.parse(finalTotal) + double.parse(tmpExtra[0].extraPrice))
                .toString();
      }
      if (tmpSize.length > 0) {
        finalTotal =
            (double.parse(finalTotal) + double.parse(tmpSize[0].extraPrice))
                .toString();
      }
      finalTotal = (double.parse(finalTotal) +
              (double.parse(item.actualPrice) * int.parse(item.quantity)))
          .toStringAsFixed(2);
    }
    return finalTotal;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColor.white),
        title:
            setCommonText('Checkout', AppColor.white, 22.0, FontWeight.bold, 1),
        elevation: 0.0,
      ),
      body: Container(
        color: AppColor.white,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [_selectItemListView(), _setDeliveryDetails()],
              ),
            ),
            Container(
              height: 50,
              color: AppColor.white,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 1,
                          color: AppColor.themeColor,
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 12, right: 12),
                          // color: AppColor.amber,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              setHeight(5),
                              setCommonText('GRAND TOTAL', AppColor.black, 15.0,
                                  FontWeight.w600, 1),
                              setCommonText(
                                  '${Currency.curr}${_calculateGrandTotal()}',
                                  AppColor.themeColor,
                                  14.0,
                                  FontWeight.w800,
                                  1),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => DineInOrderSuccess(
                                  cartList: this.widget.cartList,
                                )));
                        // FlutterOpenWhatsapp.sendSingleMessage("918200005207",
                        //     "Hello\nHow are you?\nAll ok\nhmmm");
                        // await launch(
                        //     "https://wa.me/${918200005207}?text=Hello");
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColor.themeColor,
                          // borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            setCommonText('MAKE PAYMENT', AppColor.white, 16.0,
                                FontWeight.w600, 1),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
