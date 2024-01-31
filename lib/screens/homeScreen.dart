// ignore_for_file: file_names, unused_local_variable

import 'dart:ui' show Color, FontWeight, ImageFilter;

import 'package:flutter/material.dart';
// ignore: unnecessary_import
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:notesapp/screens/newNoteScreen.dart';
import 'package:notesapp/screens/noteScreen.dart';

import '../backend/getNotesInfo.dart';
import '../backend/hive.dart';
import '../backend/listNotes.dart';

class HomeScreen extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const HomeScreen({Key? key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    // String note1 =
    // "Bugün güzel bir gün geçirdim, arkadaşlarımla buluştuk ve kahve içtik. Akşam yemeğinde favori pizzamı yedim. Harika bir gün oldu!";
    // String note2 =
    //     "Dün gece ilham geldi ve yeni bir şarkı yazdım. Melodisi kafamda sürekli çalıyor. Bu proje üzerinde çalışmaya devam edeceğim.";
    // String note3 =
    //     "Notlarımı düzenledim ve planlarıma göz attım. Bu hafta sonu için alışveriş listemi oluşturdum. Evin dekorasyonu için yeni fikirler araştırıyorum.";
    // String note4 =
    //     "Yoga dersi bugün çok rahatlatıcıydı. Zihinsel ve fiziksel olarak kendimi daha iyi hissediyorum. Yoga pratiğine devam etmek benim için önemli.";
    // String note5 =
    //     "Kitap kulübü buluşmasında ilginç bir kitap keşfettik. Yazarın üslubu beni etkiledi. Şimdi diğer eserlerini de okuma listeme ekledim.";
    // String note6 =
    //     "Yürüyüş sırasında güzel bir manzara fotoğrafı çektim. Doğa fotoğrafçılığına olan ilgim her geçen gün artıyor. Yeni lensler araştırıyorum.";
    // String note7 =
    //     "Bugün sevdiğim filmi izledim ve karakterlerin derinliği beni etkiledi. Senaryo üzerine düşündüm, kendi hikayelerimi yazma fikri beni heyecanlandırıyor.";
    // String note8 =
    //     "Kendi bahçemde organik sebzeler yetiştirmeye başladım. İlk domatesim olgunlaştı ve harika görünüyor. Tarım hakkında daha fazla bilgi edinmeye kararlıyım.";
    // String note9 =
    //     "Eski arkadaşımla uzun bir telefon konuşması yaptık. Güzel anıları paylaştık ve birbirimize destek olmaya karar verdik. Dostluklar gerçekten değerlidir.";

    // late Future<int> numberOfNotes = getNumberOfNotes();

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
                  Color(0xFF20357E), // en alttaki renk
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
                Padding(
                  padding: const EdgeInsets.only(
                      left: 18.0, top: 35.0), // İstediğiniz soldan boşluk
                  child: Row(
                    children: [
                      const Text(
                        "Notlar",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0,
                        ),
                      ),
                      FutureBuilder<int>(
                        future: getNonEmptyNotesCount(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            return Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                // ignore: prefer_interpolation_to_compose_strings
                                snapshot.data.toString() + " Not",
                                style: const TextStyle(
                                  color: Color(0xFF9B9B9B),
                                  fontSize: 14.0,
                                ),
                              ),
                            );
                          }
                        },
                      )
                    ],
                  ),
                ),
                // ignore: avoid_unnecessary_containers
                Padding(
                  padding:
                      const EdgeInsets.only(left: 18.0, right: 18.0, top: 15.0),
                  child: Container(
                    padding: const EdgeInsets.only(left: 15.0),
                    width: double.infinity,
                    height: 45,
                    decoration: const BoxDecoration(
                        color: Color(0xFF50525C),
                        borderRadius: BorderRadius.all(Radius.circular(22.0))),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        FaIcon(
                          // ignore: deprecated_member_use
                          FontAwesomeIcons.search,
                          size: 18.0,
                          color: Colors.white,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 12.0),
                          child: Text(
                            'Ara',
                            style: TextStyle(
                              color: Color(0xFF9B9B9B),
                              fontSize: 17.0,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 20.0, top: 20.0),
                  child: Text(
                    "Favoriler",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                FutureBuilder<List<NoteDatabase>>(
                  future: getFavoriteNotes(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      List<NoteDatabase> favoriteNotes =
                          snapshot.data as List<NoteDatabase>;
                      return Padding(
                        padding: const EdgeInsets.only(
                          left: 20.0,
                          right: 20.0,
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics:
                                const ClampingScrollPhysics(), // Bu satır eklenmiştir
                            itemCount: favoriteNotes.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => NoteScreen(
                                        note: favoriteNotes[index],
                                        noteIndex: index,
                                      ),
                                    ),
                                  );
                                },
                                child: favoriteNotes[index].title == '' &&
                                        favoriteNotes[index].content == ''
                                    ? Container()
                                    : Column(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                              top: index <
                                                      favoriteNotes.length -
                                                          (favoriteNotes
                                                                  .length -
                                                              1)
                                                  ? 0.0
                                                  : 15.0,
                                            ),
                                            child: Container(
                                              width: double.infinity,
                                              decoration: const BoxDecoration(
                                                color: Color(0xFF50525C),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(22.0)),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 18.0,
                                                    top: 15.0,
                                                    bottom: 15.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      truncateDescription(
                                                          favoriteNotes[index]
                                                                      .title ==
                                                                  ''
                                                              ? favoriteNotes[
                                                                      index]
                                                                  .content
                                                              : favoriteNotes[
                                                                      index]
                                                                  .title,
                                                          90),
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 15.0,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 4.0),
                                                      child: Text(
                                                        favoriteNotes[index]
                                                            .date,
                                                        style: const TextStyle(
                                                          color:
                                                              Color(0xFF9B9B9B),
                                                          fontSize: 13.0,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                              );
                            },
                          ),
                        ),
                      );
                    }
                  },
                ),

                const Padding(
                  padding: EdgeInsets.only(left: 20.0, top: 20.0),
                  child: Text(
                    "Notlar",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500),
                  ),
                ),

                FutureBuilder<List<NoteDatabase>>(
                  future: getAllNotes(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      List<NoteDatabase> allTheNotes =
                          snapshot.data as List<NoteDatabase>;
                      return Padding(
                        padding: const EdgeInsets.only(
                          left: 20.0,
                          right: 20.0,
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics:
                                const ClampingScrollPhysics(), // Bu satır eklenmiştir
                            itemCount: allTheNotes.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => NoteScreen(
                                        note: allTheNotes[index],
                                        noteIndex: index,
                                      ),
                                    ),
                                  );
                                },
                                child: allTheNotes[index].title == '' &&
                                        allTheNotes[index].content == ''
                                    ? Container()
                                    : Column(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                              top: index <
                                                      allTheNotes.length -
                                                          (allTheNotes
                                                                  .length -
                                                              1)
                                                  ? 0.0
                                                  : 15.0,
                                            ),
                                            child: Container(
                                              width: double.infinity,
                                              decoration: const BoxDecoration(
                                                color: Color(0xFF50525C),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(22.0)),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 18.0,
                                                    top: 15.0,
                                                    bottom: 15.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      truncateDescription(
                                                          allTheNotes[index]
                                                                      .title ==
                                                                  ''
                                                              ? allTheNotes[
                                                                      index]
                                                                  .content
                                                              : allTheNotes[
                                                                      index]
                                                                  .title,
                                                          90),
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 15.0,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 4.0),
                                                      child: Text(
                                                        allTheNotes[index]
                                                            .date,
                                                        style: const TextStyle(
                                                          color:
                                                              Color(0xFF9B9B9B),
                                                          fontSize: 13.0,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                              );
                            },
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 16.0,
            left: 0,
            right: 0,
            child: Center(
              child: FloatingActionButton(
                backgroundColor: Colors.white,
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (builder) => const AddNoteScreen()));
                },
                child: const Icon(Icons.add),
              ),
            ),
          ),
        ],
      ),
    );
  }

  
}
