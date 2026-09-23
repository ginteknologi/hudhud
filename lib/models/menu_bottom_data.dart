enum BottomBarEnum { beranda, alquran, ruangan, dkm, muazin }

class BottomMenuModel {
  BottomMenuModel(
      {required this.icon,
      this.title,
      required this.activeIcon,
      required this.navType});

  String icon;
  String activeIcon;
  BottomBarEnum navType;
  String? title;
}
