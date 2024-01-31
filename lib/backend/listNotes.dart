// ignore_for_file: file_names

import 'package:share_plus/share_plus.dart';

String truncateDescription(String description, int maxLength) {
    return (description.length > maxLength)
        ? '${description.substring(0, maxLength)}...'
        : description;
  }

String cleanUserInput(String userInput) {
  // Özel karakterleri temizleme
  String cleanedInput = userInput.replaceAll(RegExp(r'[^\w\s]'), '');

  // Boşlukları değiştirme
  cleanedInput = cleanedInput.replaceAll(' ', '\\\\n');

  return cleanedInput;
}

void shareNote(String title, String content, String imagePath) {
    String text = "Başlık: $title\nNot: $content";

    if (imagePath.isNotEmpty && imagePath != '') {
      Share.shareXFiles([XFile(imagePath)], text: text);
    }

    Share.share(text);
  }

