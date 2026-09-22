import 'dart:io';
import 'package:image/image.dart' as img;

void main() {
  final dir = Directory('branding');
  for (final file in dir.listSync()) {
    if (file is File) {
      if (file.path.endsWith('.png') || file.path.endsWith('.ico')) {
        final image = img.decodeImage(file.readAsBytesSync());
        if (image != null) {
          print('${file.path}: ${image.width}x${image.height}');
        }
      }
    }
  }
}
