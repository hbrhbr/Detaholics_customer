import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:product/Helper/RequestManager.dart';
import 'package:product/Helper/SharedManaged.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CBK_KNET_Screen extends StatefulWidget {
  final String webViewForm;
  final int orderId;
  const CBK_KNET_Screen({Key key,this.webViewForm,this.orderId}) : super(key: key);

  @override
  _CBK_KNET_ScreenState createState() => _CBK_KNET_ScreenState();
}

class _CBK_KNET_ScreenState extends State<CBK_KNET_Screen> {
  WebViewController _webViewController;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: WebView(
              debuggingEnabled: false,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (controller) {
                _webViewController = controller;
                _webViewController.loadUrl( Uri.dataFromString(
                    widget.webViewForm,
                    mimeType: 'text/html',
                    encoding: Encoding.getByName('utf-8')
                ).toString());
              },
              onWebResourceError: (error) {},
              onPageFinished: (page) {
                print(page.toString());
                print("${widget.orderId} WebView Page Result ${page}");
                if(page.contains('paymentcancel.htm')){
                  SharedManager.shared.showAlertDialog("Payment Cancelled", context);
                  Navigator.pop(context,{'result':false});
                }
                else
                {
                  String encrpValue = '';
                  try{
                    Uri encrpUri = Uri.parse("$page");
                    print("encrpUri.queryParameters-->>${encrpUri.queryParameters}");
                    encrpValue = encrpUri.queryParameters['encrp'];
                  }catch(e){
                    print("Exception--->>>$e");
                  }
                  if(encrpValue.isNotEmpty) {
                    SharedManager.shared.showAlertDialog("Checking Payment Status Please wait", context);
                    getData(encrp: encrpValue);
                  }
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  void getData({String encrp}) async{
    Requestmanager manager = Requestmanager();
    Map<String, dynamic> orderStatus = await manager.getCBKOrderPaymentStatusResponse(combined_order_id: widget.orderId.toString(),encrp: encrp);
     if (orderStatus!=null&&((orderStatus['code']??0)==1)) {
       SharedManager.shared.showAlertDialog("${orderStatus['message']}", context);
       Navigator.pop(context,{'result':true});
    }else {
    SharedManager.shared.showAlertDialog("Payment Failed", context);
    Navigator.pop(context,{'result':false});
    }
  }
}
