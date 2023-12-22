import 'package:flutter/material.dart';

class AppBarWSWidget {
  static AppBar getAppbarWidget({
    required String title,
    String? stepForm,
    Widget? iconRight,
    Widget? iconLeft,
    Function? logout,
    Function? back,
    PreferredSizeWidget? bottom,
    Color? backgroundColor,
    Color? color,
    double? titleSize,
    double? elevation,
    Alignment? titleAlign,
    bool? noBack = false,
    bool defaultPlace = true,
    required BuildContext context, // Add the BuildContext parameter
  }) {
    return AppBar(
      iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
      leading: noBack == true
          ? null
          : iconLeft ??
              GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .pop(); // Navigate back to the previous page
                  },
                  child: const Icon(Icons.arrow_back_rounded)),
      bottom: bottom,
      backgroundColor: backgroundColor ?? Colors.white,
      elevation: elevation ?? 1,
      title: Align(
        alignment: noBack == false && defaultPlace
            ? Alignment.centerRight
            : iconRight != null
                ? Alignment.centerLeft
                : Alignment.center,
        child: Text(title,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: titleSize ??
                    Theme.of(context).textTheme.titleMedium?.fontSize,
                letterSpacing: 0.5,
                fontWeight: FontWeight.bold,
                color: color ?? Theme.of(context).primaryColor)),
      ),
      //centerTitle: false,
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: Center(
            child: stepForm != null
                ? Text(
                    stepForm != null ? "$stepForm/2" : "",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  )
                : logout != null
                    ? IconButton(
                        onPressed: () async {
                          logout();
                        },
                        icon: const Icon(
                          Icons.logout,
                        ),
                      )
                    : back != null
                        ? IconButton(
                            onPressed: () async {
                              back();
                            },
                            icon: const Icon(
                              Icons.close,
                            ),
                          )
                        : const Text(""),
          ),
        ),
        iconRight ?? const Text("")
      ],
    );
  }
}
