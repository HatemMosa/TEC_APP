import 'package:flutter/material.dart';

import '../../core/helper/color_helper.dart';

class ShareComponents{
  getBackgroundGradient(){
    return  const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        ColorHelper.backgroundColor1,
        ColorHelper.backgroundColor2,
      ],
    );
  }
}