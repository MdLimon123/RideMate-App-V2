import 'package:flutter/material.dart';
import 'package:flutter_extension/util/app_colors.dart';

class CustomLoading extends StatelessWidget {
  const CustomLoading({super.key, this.color, this.size});
  final double? size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(color: color ?? AppColors.primaryColor),
    );
  }
}
