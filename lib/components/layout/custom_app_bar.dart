import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  CustomAppBar(
      {super.key, required this.height,
      this.styleType,
      this.leadingWidth,
      this.leading,
      this.title,
      this.centerTitle,
      this.actions});

  double height;

  Style? styleType;

  double? leadingWidth;

  Widget? leading;

  Widget? title;

  bool? centerTitle;

  List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      toolbarHeight: height,
      automaticallyImplyLeading: false,
      //backgroundColor: AppTheme.primaryColor.withAlpha(200),
      backgroundColor: Theme.of(context).primaryColor,
      flexibleSpace: _getStyle(),
      leadingWidth: leadingWidth ?? 0,
      leading: leading,
      title: title,
      titleSpacing: 0,
      centerTitle: centerTitle ?? false,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size(
        double.infinity,
        height,
      );
  Container? _getStyle() {
    switch (styleType) {
      case Style.bgFillWhiteA700:
        return Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
        );
      default:
        return null;
    }
  }
}

enum Style {
  bgFillWhiteA700,
}
