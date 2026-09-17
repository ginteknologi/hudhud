import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

Future downloadAndSaveFile(
    {required String url, required String pathsave}) async {
  final directory = await getApplicationDocumentsDirectory();
  final String fileName = url.substring(url.lastIndexOf('/') + 1);
  final subfolderDirectory = Directory('${directory.path}$pathsave');
  if (!(await subfolderDirectory.exists())) {
    await subfolderDirectory.create(recursive: true);
  }
  final String lokasiSave = '${directory.path}$pathsave/$fileName';
  var kondisi = checkIfFileExists(fileName: fileName, pathsave: pathsave);
  if (await kondisi) {
    print('File sudah ada.');
    return lokasiSave;
  } else {
    final response = await http.get(Uri.parse(url));
    final File file = File(lokasiSave);
    await file.writeAsBytes(response.bodyBytes);
    print('File berhasil diunduh dan disimpan di: ${file.path}');
    return lokasiSave;
  }
}

Future<bool> checkIfFileExists(
    {required String fileName, required String pathsave}) async {
  final directory = await getApplicationDocumentsDirectory();
  final String lokasiSave = '${directory.path}$pathsave/$fileName';
  final File file = File(lokasiSave);
  return file.exists();
}

Future<String> checkIfFile(
    {required String fileName, required String pathsave}) async {
  final directory = await getApplicationDocumentsDirectory();
  final String lokasiSave = '${directory.path}$pathsave/$fileName';
  final File file = File(lokasiSave);
  bool exists = await file.exists();

  if (exists) {
    return lokasiSave;
  } else {
    return '';
  }
}
