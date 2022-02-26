import 'package:flutter/material.dart';

 Top_searchbar_widget(
   TextEditingController _searchcontroller,
    IconData _leadingicon,
    TextFormField _searchinputfield,
    IconData _trailingicon
){
 
  
Row( children: [
  Icon(_leadingicon),
  TextFormField(controller: _searchcontroller,
  
  
  ),Icon(_trailingicon),
],);




}