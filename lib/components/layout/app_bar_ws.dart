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
    bool haveSubtitle = false,
    Widget? subtitle,
    IconThemeData? iconTheme,
    VoidCallback? onTap,
    required BuildContext context, // Add the BuildContext parameter
  }) {
    return AppBar(
      iconTheme:
          iconTheme ?? IconThemeData(color: Theme.of(context).primaryColor),
      leading: noBack == true
          ? null
          : iconLeft ??
              GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop('refresh');
                  },
                  child: const Icon(Icons.arrow_back_rounded)),
      bottom: bottom,
      backgroundColor: backgroundColor ?? Colors.white,
      elevation: elevation ?? 1,
      title: Align(
        alignment: titleAlign ??
            (noBack == false && defaultPlace
                ? Alignment.centerRight
                : iconRight != null
                    ? Alignment.centerLeft
                    : Alignment.center),
        child: !haveSubtitle
            ? Text(title,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: titleSize ??
                        Theme.of(context).textTheme.titleMedium?.fontSize,
                    letterSpacing: 0.5,
                    fontWeight: FontWeight.bold,
                    color: color ?? Theme.of(context).primaryColor))
            : onTap == null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Text(title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: titleSize ??
                                    Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.fontSize,
                                letterSpacing: 0.5,
                                fontWeight: FontWeight.bold,
                                color:
                                    color ?? Theme.of(context).primaryColor)),
                        if (subtitle != null) subtitle
                      ])
                : Material(
                    color: Colors.transparent,
                    child: InkWell(
                      splashColor: Colors.white30,
                      onTap: onTap,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(title,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: titleSize ??
                                            Theme.of(context)
                                                .textTheme
                                                .titleMedium
                                                ?.fontSize,
                                        letterSpacing: 0.5,
                                        fontWeight: FontWeight.bold,
                                        color: color ??
                                            Theme.of(context).primaryColor)),
                                if (subtitle != null) subtitle
                              ]),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Icons.expand_more_rounded,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
      ),
      //centerTitle: false,
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: Center(
            child: stepForm != null
                ? Text(
                    "$stepForm/2",
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
