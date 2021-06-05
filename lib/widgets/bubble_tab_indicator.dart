import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';

class BubbleTabIndicatorUtils {
  static bubbleTabIndicator(
      EdgeInsets insets,
      EdgeInsets padding,
      double height, double radius, Color tabColor, TabBarIndicatorSize tabBarIndicatorSize) {
    return BubbleTabIndicator(
      indicatorHeight: height,
      indicatorRadius: radius,
      indicatorColor: tabColor,
      tabBarIndicatorSize: tabBarIndicatorSize,
      insets: insets,
      padding: padding
    );
  }
}
