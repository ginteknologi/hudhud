import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:masjid_app/pages/kiblat/kiblat_compass.dart';

class KiblatPage extends StatelessWidget {
  const KiblatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        backgroundColor: Color(0xFF27B8A8),
        title: Text('Jadwal Imsakiyah'),
        // systemOverlayStyle: SystemUiOverlayStyle(
        //   statusBarColor: Colors.red,
        //   statusBarIconBrightness: Brightness.dark,
        // ),
        elevation: 0,
      ),
        backgroundColor: Theme.of(context).colorScheme.background,
        body: FutureBuilder(
          future: FlutterQiblah.androidDeviceSensorSupport(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error.toString()}'),
              );
            }
            if (snapshot.hasData) {
              return const KiblatCompass();
            } else {
              return const Text('Error');
            }
          },
        ),
    );
  }
}
