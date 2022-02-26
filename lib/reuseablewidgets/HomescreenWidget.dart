import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:product/Screens/TabBarScreens/Profile/ProfileScreen.dart';

Widget searchforlocationwidget({
  IconData leadingicon,
  TextFormField formfield,
  Widget trailingicon,
  String hintext,
  Function () ontap,
}) {
  TextEditingController _searchcontroller;

  return Container(
    margin: EdgeInsets.symmetric(vertical: 10,horizontal: 5),
    child: Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Icon(
            leadingicon,
            color: Colors.black,
          ),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.only(left: 20,right: 20),
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(50)),
            child: TextFormField(readOnly: true,onTap:()=> ontap(),
              controller: _searchcontroller,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintStyle: TextStyle(),
                hintText: '$hintext',
                border: InputBorder.none,
              suffixIcon: Icon(Icons.location_pin,color: Colors.grey,size: 20,)
              ),

            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: trailingicon,
        ),
      ],
    ),
  );
}

// ignore: non_constant_identifier_names
Widget ProfileViewWidget({String username, String image, String usermessage,@required BuildContext context}) {
  print("username:->$username");
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
    width: double.infinity,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(width: 30,),
        PhysicalModel(
            elevation: 5,
            color: Colors.white.withOpacity(0.4),
            borderRadius: BorderRadius.circular(35),
            child: GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (buildContext)=>ProfileScreen()));
              },
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Colors.white,

                  backgroundImage: (image!=null&&image.isNotEmpty)?NetworkImage(image,):AssetImage("Assets/defaultProfileImage.png",),
              ),
            )),
        SizedBox(width: 10,),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(child: Text('${username.isEmpty?'Hello, User':username}',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),)),
              Flexible(child: Text('$usermessage',style: TextStyle(fontWeight: FontWeight.bold),))
            ],
          ),
        )
      ],
    ),
  );
}
