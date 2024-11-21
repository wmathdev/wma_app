
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class FileDownloaderHelper {
  static Future<void> saveFileOnDevice(String fileName, File inFile) async {
    try {
      if (Platform.isAndroid) {
        // Check if the platform is Android
        final directory = Directory("/storage/emulated/0/Download");

        if (!directory.existsSync()) {
          // Create the directory if it doesn't exist
          await directory.create();
        }
        final path = '${directory.path}/$fileName';
        final bytes = await inFile.readAsBytes();
        final outFile = File(path);

        final res = await outFile.writeAsBytes(bytes, flush: true);
        print("=> saved file: ${res.path}");
      } else {
        // IOS
        final directory = await getApplicationDocumentsDirectory();
        // Get the application documents directory path
        final path = '${directory.path}/$fileName';
        final bytes = await inFile.readAsBytes();
        final res = await Share.shareXFiles([XFile(path, bytes: bytes)]);
        print("=> saved status: ${res.status}");
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}