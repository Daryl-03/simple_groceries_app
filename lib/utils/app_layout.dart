import 'package:flutter/material.dart';

class AppLayout{
  static displayWidth(context) {
    return MediaQuery.of(context).size.width;
  }

  static displayHeightFull(context){
    return MediaQuery.of(context).size.height;
  }

  static displayHeightWithoutStatusBar(context){
    return MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
  }

  static displayHeightWithoutAppBar(context){
    return MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - kToolbarHeight;
  }

  static displayHeightWithoutBothBars(context){
    return MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - kToolbarHeight - kBottomNavigationBarHeight;
  }
}