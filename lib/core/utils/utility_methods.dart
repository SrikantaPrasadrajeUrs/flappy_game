import 'package:flutter/material.dart';

void navigateTo({required Widget child, required BuildContext context, bool shouldClearStack = false}){
  if(shouldClearStack){
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>child));
  }else{
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>child));
  }

}