// ignore_for_file: file_names

import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notesapp/backend/hive.dart';
import 'package:notesapp/backend/openai.dart';
import 'package:notesapp/screens/homeScreen.dart';
import 'package:notesapp/screens/noteScreen.dart';
import 'package:share_plus/share_plus.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({Key? key}) : super(key: key); 

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  XFile? selectedImage;
  bool favoriteStar = false;
  IconData fav = FontAwesomeIcons.star;
  IconData favTrue = FontAwesomeIcons.solidStar;
  String imagePath = '';

  SampleItem? selectedMenu;


  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String getMonthName(int month) {
      switch (month) {
        case 1:
          return "Ocak";
        case 2:
          return "Şubat";
        case 3:
          return "Mart";
        case 4:
          return "Nisan";
        case 5:
          return "Mayıs";
        case 6:
          return "Haziran";
        case 7:
          return "Temmuz";
        case 8:
          return "Ağustos";
        case 9:
          return "Eylül";
        case 10:
          return "Ekim";
        case 11:
          return "Kasım";
        case 12:
          return "Aralık";
        default:
          return "";
      }
    }

    String formattedDate =
        "${getMonthName(now.month)} ${now.day}, ${now.year}";

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF242730), // en üstteki renk
                  Color(0xFF242730), // en üstteki renk
                  Color(0xFF487552), // en alttaki rengi
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0, top: 40.0),
                      child: IconButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (builder) => const HomeScreen()));
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 5.0, top: 40.0),
                      child: IconButton(
                        onPressed: () {
                          addNote(titleController.text, contentController.text,
                                  imagePath, formattedDate, favoriteStar)
                              .whenComplete(() => Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (builder) =>
                                          const HomeScreen())));
                        },
                        icon: const Icon(
                          Icons.check,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20.0, left: 15.0, right: 15.0),
                  child: Text(
                    "Yeni Not",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 19.0,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 20.0, left: 15.0, right: 15.0),
                  child: _NoteInputField(
                    hintText: "Başlık",
                    controller: titleController,
                    maxLines: 1, // Başlık için maxLines 1 olmalı
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 6.0, left: 15.0),
                  child: Text(
                    formattedDate,
                    style: const TextStyle(
                      color: Color(0xFF9B9B9B),
                      fontSize: 13.0,
                    ),
                  ),
                ),
                if (selectedImage != null)
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Image.file(
                      File(selectedImage!.path),
                      fit: BoxFit.cover,
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 20.0, bottom: 20.0),
                  child: _NoteInputField(
                    hintText: "Notunuz...",
                    controller: contentController,
                    maxLines: 10,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0.0,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                height: 70,
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                decoration: BoxDecoration(
                  color: const Color(0xFF487552)
                      .withOpacity(1), // Blurlu alanın rengini belirle
                  borderRadius: BorderRadius.circular(
                      0.0), // İstediğiniz şekilde kenar yuvarlaklığını ayarla
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            favoriteStar = !favoriteStar;
                          });
                          if (favoriteStar) {
                            setState(() {
                              fav = FontAwesomeIcons.solidStar;
                            });
                          } else {
                            setState(() {
                              fav = FontAwesomeIcons.star;
                            });
                          }
                        },
                        child: FaIcon(
                          favoriteStar ? favTrue : fav,
                          color: Colors.white,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          _pickImage();
                        },
                        child: const FaIcon(
                          FontAwesomeIcons.image,
                          color: Colors.white,
                        ),
                      ), // Resim / Fotoğraf ikonu
                      InkWell(
                        onTap: () {
                          shareNote(titleController.text, contentController.text,
                              imagePath);
                        },
                        child: const FaIcon(
                          FontAwesomeIcons.share,
                          color: Colors.white,
                        ),
                      ), // Paylaşma / Dışa Aktarma ikonu
                      MenuAnchor(
                        builder: (BuildContext context,
                            MenuController controller, Widget? child) {
                          return InkWell(
                            onTap: () {
                              if (controller.isOpen) {
                                controller.close();
                              } else {
                                controller.open();
                              }
                            },
                            child: const FaIcon(
                              FontAwesomeIcons.microchip,
                              color: Colors.white,
                            ),
                            // tooltip: 'Show menu',
                          );
                        },
                        menuChildren: List<MenuItemButton>.generate(
                          3,
                          (int index) => MenuItemButton(
                            onPressed: () => setState(
                                () => selectedMenu = SampleItem.values[index]),
                            child: InkWell(
                                onTap: () async {
                                  if (index == 0) {
                                    String newNote = await startGpt()
                                        .formatNote(
                                            contentController.text);

                                    // Kontrol et: Widget hala ağaçta mı?
                                    if (mounted) {
                                      setState(() {
                                        // widget.note.save();
                                        contentController.text = newNote;
                                      });
                                    }
                                  } else if (index == 1) {
                                    String newNote = await startGpt()
                                        .learningAllNotesAndWriteNote(
                                            contentController.text);

                                    // Kontrol et: Widget hala ağaçta mı?
                                    if (mounted) {
                                      setState(() {
                                        
                                        // widget.note.save();
                                        contentController.text = newNote;
                                      });
                                    }
                                  } else {
                                    String newNote = await startGpt()
                                        .learningAllNotesAndCreateNewNote(
                                            );

                                    // Kontrol et: Widget hala ağaçta mı?
                                    if (mounted) {
                                      // print(1);
                                      addNote('deneme', newNote, '', formattedDate, false).whenComplete(() => Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) => const HomeScreen())));
                                      // print(2);
                                    }
                                  }
                                },
                                child: Text(
                                  index == 0
                                      ? 'Dil Kurallarını Uygula'
                                      : index == 1
                                          ? 'Notu Devam Ettir'
                                          : 'Yeni Not Üret',
                                )),
                          ),
                        ),
                      ),

                      // Sihirli Değnek ikonu
                      MenuAnchor(
                        builder: (BuildContext context,
                            MenuController controller, Widget? child) {
                          return InkWell(
                            onTap: () {
                              if (controller.isOpen) {
                                controller.close();
                              } else {
                                controller.open();
                              }
                            },
                            child: const FaIcon(
                              FontAwesomeIcons.ellipsis,
                              color: Colors.white,
                            ),
                            // tooltip: 'Show menu',
                          );
                        },
                        menuChildren: List<MenuItemButton>.generate(
                          1,
                          (int index) => MenuItemButton(
                            onPressed: () => setState(
                                () => selectedMenu = SampleItem.values[index]),
                            child: InkWell(
                              onTap: () {
                               setState(() {
                                 titleController.text = '';
                                 contentController.text = '';
                               });
                               Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) => const HomeScreen()));
                              },
                              child: const Text('Notu Sil')
                              ),
                          ),
                        ),
                      ),
                      // Üç Nokta (yatay) ikonu
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage() async {
    XFile? pickedImage =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        selectedImage = pickedImage;
        imagePath = pickedImage.path;
      });
    }
  }

  void shareNote(String title, String content, String imagePath) {
  String text = "Başlık: $title\nNot: $content";

  if(imagePath.isNotEmpty && imagePath != '') {
    Share.shareXFiles([XFile(imagePath)], text: text);
  }

  Share.share(text);
}


}

class _NoteInputField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final int? maxLines;

  const _NoteInputField({
    Key? key,
    required this.hintText,
    required this.controller,
    this.maxLines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: TextStyle(
        color: Colors.white,
        fontSize: maxLines != 1 ? 15.0 : 19.0,
        fontWeight: maxLines != 1 ? FontWeight.w400 : FontWeight.bold,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: const Color(0xFF9B9B9B),
          fontSize: maxLines != 1 ? 15.0 : 19.0,
          fontWeight: maxLines != 1 ? FontWeight.w400 : FontWeight.bold,
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide.none,
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide.none,
        ),
      ),
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
    );
  }
}
