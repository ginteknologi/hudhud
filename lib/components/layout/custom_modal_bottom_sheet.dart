import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class CustomModalBottomSheet extends StatelessWidget {
  const CustomModalBottomSheet(
      {super.key,
      this.typeSheet = TypeBottomSheet.typeAlertSheet,
      this.titleAlert,
      this.textAlert,
      this.closeButton = true,
      this.confirmText,
      this.dataGrid,
      this.height,
      this.onTap,
      this.content = const []});

  final TypeBottomSheet typeSheet;
  // alert
  final String? titleAlert;
  final String? textAlert;
  final bool? closeButton;
  final String? confirmText;

  // grid sheet
  final List? dataGrid;
  final VoidCallback? onTap;

  // custom sheet
  final double? height;
  final List<Widget> content;

  Wrap alertSheet(BuildContext context) {
    return Wrap(
      spacing: 60, // Add spacing between the child widgets.
      children: <Widget>[
        // Add a container with height to create some space.
        Container(height: 10),
        // Add a text widget with a title for the sheet.
        Text(
          titleAlert!,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
        ),
        Container(height: 10), // Add some more space.
        // Add a text widget with a long description for the sheet.
        Text(
          textAlert!,
          style: TextStyle(
              color: Colors.grey[600], // Set the text color.
              fontSize: 18 // Set the text size.
              ),
        ),
        Container(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Visibility(
                visible: closeButton!,
                child: TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.transparent,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Tutup",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary)),
                )),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(confirmText!,
                  style: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .inversePrimary)), // Add the button text.
            )
          ],
        )
      ],
    );
  }

  Padding gridSheet(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 0, right: 0, bottom: 0),
      child: SizedBox(
          height: MediaQuery.of(context).size.height / 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 4,
                height: 5,
                margin: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: dataGrid?.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4, mainAxisSpacing: 10),
                itemBuilder: (context, index) {
                  return SizedBox(
                      child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                  onTap: onTap ??
                                      () {
                                        Navigator.pop(context);
                                        if (dataGrid?[index]['urlNav'] !=
                                            null) {
                                          Get.toNamed(
                                              dataGrid?[index]['urlNav']);
                                        }
                                      },
                                  borderRadius: BorderRadius.circular(20),
                                  splashColor:
                                      Colors.green.withValues(alpha: 0.5),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(dataGrid?[index]['icon'],
                                          height: 35, width: 35),
                                      const SizedBox(height: 5),
                                      Text(
                                        '${dataGrid?[index]["label"]}',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            height: 1,
                                            fontSize: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.fontSize,
                                            color: Colors.black87,
                                            fontWeight: FontWeight.w500),
                                        maxLines: 2,
                                      ),
                                      // Text(
                                      //   '${dataGrid?[index]["label"]}',
                                      //   textAlign: TextAlign.center,
                                      //   style: TextStyle(
                                      //       fontSize: Theme.of(context)
                                      //           .textTheme
                                      //           .bodySmall
                                      //           ?.fontSize,
                                      //       color: Colors.black87,
                                      //       fontWeight: FontWeight.w500),
                                      // ),
                                    ],
                                  )))));
                },
              )
            ],
          )),
    );
  }

  Padding customSheet(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 0, right: 0, bottom: 0),
      child: SizedBox(
          height: height ?? 350,
          // constraints: BoxConstraints.loose(Size.infinite),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 4,
                height: 5,
                margin: EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
              ),
              Flexible(
                  flex: 1,
                  child: Column(
                    children: content,
                  )),
            ],
          )),
    );
  }

  Padding fullScreenSheet(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 0, right: 0, bottom: 0),
      child: Container(
          constraints: BoxConstraints.loose(Size.infinite),
          // height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: content,
                  )),
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // Define padding for the container.
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      // Create a Wrap widget to display the sheet contents.
      child: typeSheet == TypeBottomSheet.typeAlertSheet
          ? alertSheet(context)
          : typeSheet == TypeBottomSheet.typeGridSheet
              ? gridSheet(context)
              : typeSheet == TypeBottomSheet.typeFullscreenSheet
                  ? fullScreenSheet(context)
                  : customSheet(context),
    );
  }
}

enum TypeBottomSheet {
  typeGridSheet,
  typeAlertSheet,
  typeCustomSheet,
  typeFullscreenSheet
}
