import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class IsLoginMiddleware extends GetMiddleware {
  final authStore = GetStorage();
  @override
  RouteSettings? redirect(String? route) {
    final dataLogin = authStore.read('isLogin');
    if (dataLogin != true) {
      Fluttertoast.showToast(
          msg: "Untuk bisa mengakses fitur ini silahkan login dahulu.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black87,
          timeInSecForIosWeb: 1,
          fontSize: Get.width / 30);
      return const RouteSettings(name: '/auth');
    } else {
      return null;
    }
  }
}
