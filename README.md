# JUANOTES

![CI/CD](https://github.com/dominicarrojado/hashtag-interactive-valentines-day-card-app/workflows/CI/CD/badge.svg) [![codecov](https://codecov.io/github/dominicarrojado/hashtag-interactive-valentines-day-card-app/branch/develop/graph/badge.svg?token=V5QRH2QTM4)](https://codecov.io/github/dominicarrojado/hashtag-interactive-valentines-day-card-app)

Note Create application with [Flutter](https://flutter.dev/) + [Dart](https://www.dart.dev/).

## KULLANILAN TEKNOLOJİLER - USED ​​TECHNOLOGIES
![Dart](https://img.shields.io/badge/-Dart-333333?style=flat&logo=DART)
![Flutter](https://img.shields.io/badge/-Flutter-333333?style=flat&logo=Flutter)
<br>
![Hive](https://img.shields.io/badge/-hive-333333?style=flat&logo=hive)
<br>
![GitHub](https://img.shields.io/badge/-GitHub-333333?style=flat&logo=github)
![OpenAI](https://img.shields.io/badge/-openai-333333?style=flat&logo=OpenAI)
<br>
![Android](https://img.shields.io/badge/-android-333333?style=flat&logo=Android)
![iOS](https://img.shields.io/badge/-ios-333333?style=flat&logo=iOS)


## DEMO VİDEOSU

[![Video](https://raw.githubusercontent.com/Enderjua/juanotes/main/juanotes-3.mp4)](https://raw.githubusercontent.com/Enderjua/juanotes/main/juanotes-3.mp4)

## JUANOTE PROJESİNDE VAR OLAN ÖZELLİKLER

Ana Proje | [Eklendi](https://github.com/gethugothemes/bookworm-light)  
:------------ |    :----:    | 
Not Uygulamasına Özel Karşılama Ekranı                   | ![](https://demo.gethugothemes.com/icons/tick.png) | ![](https://demo.gethugothemes.com/icons/tick.png)                |
Yeni Bir Not Ekleme           | ![](https://demo.gethugothemes.com/icons/tick.png) | ![](https://demo.gethugothemes.com/icons/tick.png)                |
Yeni Notlar Ekeleme Esnasında Düzenlemeler Yapma, Seçenekleri Kullanma                 | ![](https://demo.gethugothemes.com/icons/tick.png) | ![](https://demo.gethugothemes.com/icons/tick.png)                |
Favori Notların Sıralanması           | ![](https://demo.gethugothemes.com/icons/tick.png) | ![](https://demo.gethugothemes.com/icons/tick.png)                |
Notların Sıralanması              | ![](https://demo.gethugothemes.com/icons/tick.png) | ![](https://demo.gethugothemes.com/icons/tick.png)                |
Notları Okuma Esnasında Güncellemeler Yapabilme                        | ![](https://demo.gethugothemes.com/icons/tick.png) | ![](https://demo.gethugothemes.com/icons/tick.png)                |
Kullanıcının Önceki Notlarını Kullanarak Yapay Zeka Eğitimi    | ![](https://demo.gethugothemes.com/icons/tick.png) | ![](https://demo.gethugothemes.com/icons/tick.png)                |
AI Tarafından Kullanıcıya Özel Not Yaratma                        | ![](https://demo.gethugothemes.com/icons/tick.png) | ![](https://demo.gethugothemes.com/icons/tick.png)                |
AI Tarafından Yazılan Bir Notu Kullanıcıya Uygun Devam Ettirme                   | ![](https://demo.gethugothemes.com/icons/tick.png) | ![](https://demo.gethugothemes.com/icons/tick.png)                |
AI Tarafından Yazılan Notu Türkçe Dilbilgisi Kurallarına Uygun Düzeltme                | ![](https://demo.gethugothemes.com/icons/tick.png) | ![](https://demo.gethugothemes.com/icons/tick.png)                |
Karşılama Ekranını İlk Görüşten Sonra Yok Etme                      | ![](https://demo.gethugothemes.com/icons/x.png)    | ![](https://demo.gethugothemes.com/icons/tick.png)    |
Tema, Düzeltme, Seçenekler Bölümünü Ayarlar ile Yönetme    | ![](https://demo.gethugothemes.com/icons/x.png)    | ![](https://demo.gethugothemes.com/icons/tick.png)    |
Tüm Dillere Uygunluk                    | ![](https://demo.gethugothemes.com/icons/x.png)    | ![](https://demo.gethugothemes.com/icons/tick.png)    |
İngilizceye Uygunluk                    | ![](https://demo.gethugothemes.com/icons/x.png)    | ![](https://demo.gethugothemes.com/icons/tick.png)    |


## CİHAZA KURULUM - LOCAL DEVELOPMENT

```bash
# clone the repository
git clone https://github.com/Enderjua/juanotes.git

# cd in the project directory
$ cd juanotes

$ flutter run
# or
$ flutter build apk
```


## YAPAY ZEKA KURULUMU - AI DEVELOPMENT

```dart
// backend/openai.dart
...

import 'listNotes.dart';

class startGpt {
  String apiKey = 'YOUR_API_KEY'; // Write Your OPENAI API KEY
  String apiUrl = 'https://api.openai.com/v1/chat/completions';
...
}
```

## VERİ TABANI KURULUMU - DATABASE DEVELOPMENT
```dart
import 'package:hive_flutter/hive_flutter.dart';

@HiveType(typeId: 0)
class NoteDatabase extends HiveObject {
  @HiveField(0)
  late String title;

  @HiveField(1)
  late String content;

  @HiveField(2)
  late String date;

  @HiveField(3)
  late String photo;

  @HiveField(4)
  late bool isFavorite;
}
...
```



## TECHNOLOGİES USED İN THE PROJECT

These tools have been helpful to us:

 * FLUTTER
 * DART
 * HİVE
 * OPENAI
 * IMAGE PICKER
 * FONTAWESOME
 * SHARE PLUS

# SUPPORT OUR PROJECT

My email adress: enderjua@gmail.com
