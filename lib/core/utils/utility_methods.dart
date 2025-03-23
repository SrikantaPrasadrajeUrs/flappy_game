import 'package:flutter/material.dart';

void navigateTo({required Widget child, required BuildContext context, bool shouldClearStack = false}){
  if(shouldClearStack){
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>child),(route) => false,);
  }else{
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>child));
  }
}

void goBack(BuildContext context){
  Navigator.of(context).pop();
}