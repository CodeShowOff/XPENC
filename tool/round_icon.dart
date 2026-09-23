import 'dart:io';
import 'package:image/image.dart' as img;

void main() {
  final file = File('assets/images/appicon.png');
  final image = img.decodeImage(file.readAsBytesSync())!;
  
  // Create a transparent image of the same size
  final roundedImage = img.Image(width: image.width, height: image.height, numChannels: 4);
  
  // Calculate corner radius (e.g., 20% of the width)
  final radius = image.width * 0.2;
  
  for (int y = 0; y < image.height; y++) {
    for (int x = 0; x < image.width; x++) {
      bool isInside = true;
      
      // Check the 4 corners
      if (x < radius && y < radius) {
        // Top-left
        final dx = radius - x;
        final dy = radius - y;
        if (dx * dx + dy * dy > radius * radius) isInside = false;
      } else if (x > image.width - radius && y < radius) {
        // Top-right
        final dx = x - (image.width - radius);
        final dy = radius - y;
        if (dx * dx + dy * dy > radius * radius) isInside = false;
      } else if (x < radius && y > image.height - radius) {
        // Bottom-left
        final dx = radius - x;
        final dy = y - (image.height - radius);
        if (dx * dx + dy * dy > radius * radius) isInside = false;
      } else if (x > image.width - radius && y > image.height - radius) {
        // Bottom-right
        final dx = x - (image.width - radius);
        final dy = y - (image.height - radius);
        if (dx * dx + dy * dy > radius * radius) isInside = false;
      }
      
      if (isInside) {
        roundedImage.setPixel(x, y, image.getPixel(x, y));
      } else {
        // Transparent
        roundedImage.setPixelRgba(x, y, 0, 0, 0, 0);
      }
    }
  }
  
  File('assets/images/appicon_rounded.png').writeAsBytesSync(img.encodePng(roundedImage));
  print('Saved appicon_rounded.png');
}
