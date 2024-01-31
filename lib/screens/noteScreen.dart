// ignore_for_file: file_names, avoid_print

import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:notesapp/backend/openai.dart';
import 'package:image_picker/image_picker.dart';

import '../backend/hive.dart';
import '../backend/listNotes.dart';
import 'homeScreen.dart';

class NoteScreen extends StatefulWidget {
  final NoteDatabase note;
  final int noteIndex;

  const NoteScreen({Key? key, required this.note, required this.noteIndex})
      : super(key: key);

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

enum SampleItem { itemOne, itemTwo, itemThree }

class _NoteScreenState extends State<NoteScreen> {
  bool favoriteStar = false;
  IconData fav = FontAwesomeIcons.star;
  IconData favTrue = FontAwesomeIcons.solidStar;
  late TextEditingController titleController =
      TextEditingController(text: widget.note.title);
  late TextEditingController contentController =
      TextEditingController(text: widget.note.content);
  bool isDeleteButtonVisible = false;
  Timer? _timer;
  String imagePath = '';
  final ImagePicker _imagePicker = ImagePicker();
  XFile? selectedImage;

  @override
  void initState() {
    super.initState();
    favoriteStar = widget.note.isFavorite;
    titleController = TextEditingController(text: widget.note.title);
    contentController = TextEditingController(text: widget.note.content);
  }

  SampleItem? selectedMenu;

  

  // String note1title =
  // "Bugün güzel bir gün geçirdim, arkadaşlarımla buluştuk ve kahve içtik.";
  //String notMetni = "Bugün gerçekten muhteşem bir gün geçirdim. Sabah güneşin sıcak ışıklarıyla uyanarak günün enerjisiyle dolup taştım. Ardından uzun zamandır görmediğim arkadaşlarımla buluştuk. Birlikte kahve içerek geçmiş günleri yâd ettik, yeni projelerimizi konuştuk ve birbirimize ilham verdik. Sohbetimiz, kahkahalarla dolu keyifli anlara dönüştü.\n\nÖğleden sonra şehirde biraz gezinme fırsatı bulduk. Caddelerde yürüyerek etrafı keşfetmek, vitrinlere göz atmak bana büyük bir mutluluk verdi. Güzel hava ve samimi dostluklar, günü daha da özel kıldı.\n\nAkşam üzeri, gün batımını izlemek için bir kafeye gittik. Renk cümbüşü içinde batan güneş, manzarayı adeta bir tabloya dönüştürdü. Bu atmosferde, içimizdeki huzur daha da derinleşti. Birbirimize duyduğumuz sevgi ve dostluğun değerini bir kez daha fark ettim.\n\nGünün sonunda eve dönerken içimde huzurla dolu, unutulmaz anlarla dolu bir günü geride bıraktım. Bugünü benim için özel kılan, sevdiklerimle bir arada olmak, güzellikleri keşfetmek ve hayatın tadını çıkarmaktı. Her anın kıymetini bilmek, yaşamı daha da anlamlı kılıyor.";
  // String notMetni =
  // "Bugün gerçekten muhteşem bir gün geçirdim. Sabah güneşin sıcak ışıklarıyla uyanarak günün enerjisiyle dolup taştım. Ardından uzun zamandır görmediğim arkadaşlarımla buluştuk. Birlikte kahve içerek geçmiş günleri yâd ettik, yeni projelerimizi konuştuk ve birbirimize ilham verdik. Sohbetimiz, kahkahalarla dolu keyifli anlara dönüştü.\n\nÖğleden sonra şehirde biraz gezinme fırsatı bulduk. Caddelerde yürüyerek etrafı keşfetmek, vitrinlere göz atmak bana büyük bir mutluluk verdi. Güzel hava ve samimi dostluklar, günü daha da özel kıldı.\n\nAkşam üzeri, gün batımını izlemek için bir kafeye gittik. Renk cümbüşü içinde batan güneş, manzarayı adeta bir tabloya dönüştürdü. Bu atmosferde, içimizdeki huzur daha da derinleşti. Birbirimize duyduğumuz sevgi ve dostluğun değerini bir kez daha fark ettim.\n\nGünün sonunda eve dönerken içimde huzurla dolu, unutulmaz anlarla dolu bir günü geride bıraktım. Bugünü benim için özel kılan, sevdiklerimle bir arada olmak, güzellikleri keşfetmek ve hayatın tadını çıkarmaktı. Her anın kıymetini bilmek, yaşamı daha da anlamlı kılıyor.\n\nGece, yıldızların altında uzun bir yürüyüş yapma fırsatı bulduk. Gökyüzü, parlayan yıldızlarla dolup taştı. Bu anlarda, evrenin büyüsüne kapıldık. Gece boyunca derin sohbetlerle zaman nasıl geçti anlamadık.\n\nGünün sonunda, evime döndüğümde kalbim huzur ve mutlulukla doluydu. Bu gün, sadece güzelliklerle dolu değil, aynı zamanda sevgi, dostluk ve keşiflerle dolu bir serüvene dönüştü. Her anın değerini bilmek, yaşamın gerçek güzelliklerini keşfetmek için bir fırsat olduğunu hatırlamak önemlidir. Bugünü unutulmaz kılan, içindeki olumlu enerjiyi paylaşmak ve sevdiklerinle özel anlar yaşamaktır.";

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
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                        // updateNote(widget.noteIndex, titleController.text, contentController.text).whenComplete(() => Navigator.pushReplacement(
                        //         context,
                        //       MaterialPageRoute(
                        //         builder: (builder) =>
                        //           const HomeScreen())));
                        setState(() {
                          widget.note.title = titleController.text;
                          widget.note.content = contentController.text;
                          widget.note.save();
                        });
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (builder) => const HomeScreen()));
                      },
                      icon: const Icon(
                        Icons.check,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.only(top: 20.0, left: 15.0, right: 15.0),
                child: _NoteInputField(
                  hintText: "",
                  controller: titleController,
                  maxLines: 1, // Başlık için maxLines 1 olmalı
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 6.0, left: 15.0),
                child: Text(
                  widget.note.date,
                  style: const TextStyle(
                    color: Color(0xFF9B9B9B),
                    fontSize: 13.0,
                  ),
                ),
              ),
              if (widget.note.photo != '')
                GestureDetector(
                  onTap: () {
                    // Tıklama olayı burada ele alınabilir
                    print('Tıklandı');
                  },
                  onLongPress: () {
                    setState(() {
                      isDeleteButtonVisible = true;
                    });

                    // Timer başlatılır ve 2 saniye sonra _hideDeleteButton metodu çağrılır
                    _timer = Timer(const Duration(seconds: 4), () {
                      _hideDeleteButton();
                    });
                  },
                  onLongPressEnd: (details) {
                    // Bu olay, parmak kaldırıldığında tetiklenir
                    _hideDeleteButton();
                  },
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Image.file(
                          File(widget.note.photo),
                          fit: BoxFit.cover,
                        ),
                      ),
                      if (isDeleteButtonVisible)
                        Positioned(
                          bottom: 16,
                          right: 16,
                          child: ElevatedButton(
                            onPressed: _deletePhoto,
                            child: const Text('Sil'),
                          ),
                        ),
                    ],
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 20.0, bottom: 20.0),
                child: _NoteInputField(
                  hintText: "",
                  controller: contentController,
                  maxLines: 10,
                ),
              ),
            ]),
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

                          // İlgili notun favori durumunu güncelle
                          widget.note.isFavorite = favoriteStar;
                          // Güncellenmiş notu kaydet (Hive üzerinde güncelleme)
                          widget.note.save();
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
                          shareNote(widget.note.title, widget.note.content,
                              widget.note.photo);
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
                                        widget.note.content = newNote;
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
                                        widget.note.content = newNote;
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
                                      print(1);
                                      addNote('deneme', newNote, '', formattedDate, false).whenComplete(() => Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) => const HomeScreen())));
                                      print(2);
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
                                 widget.note.title = '';
                                 widget.note.content = '';
                                 widget.note.save();
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

          // ignore: avoid_unnecessary_containers
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
        widget.note.photo = imagePath;
        widget.note.save();
      });
    }
  }

  void _deletePhoto() {
    // Fotoğrafı silme işlemleri burada yapılır
    setState(() {
      widget.note.photo = '';
      widget.note.save();
    });

    _hideDeleteButton();
  }

  void _hideDeleteButton() {
    setState(() {
      // isDeleteButtonVisible = false;
    });
  }

  @override
  void dispose() {
    // State objesi yok edildiğinde timer'ı iptal et
    _timer?.cancel();
    super.dispose();
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


