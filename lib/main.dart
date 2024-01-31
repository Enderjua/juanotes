import 'dart:ui';import 'package:flutter/widgets.dart';

import 'package:flutter/material.dart'
    show Alignment, BackdropFilter, BoxDecoration, BuildContext, Center, Color, ColorScheme, Colors, Column, Container, EdgeInsets, Expanded, FontWeight, InkWell, Key, LinearGradient, MainAxisAlignment, MaterialApp, MaterialPageRoute, Padding, Positioned, Scaffold, Stack, State, StatefulWidget, StatelessWidget, Text, TextStyle, ThemeData, Widget, runApp;
import 'package:notesapp/backend/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:notesapp/screens/homeScreen.dart';

void main() async {
    await Hive.initFlutter();
  Hive.registerAdapter(NoteDatabaseAdapter());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JuaNote',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF242730), // en üstteki renk
              Color(0xFF20357E), // sağ üst köşe rengi
              // ignore: unnecessary_const
              const Color(0xFF82345A), // sol orta köşe rengi
              Color(0xFF272626), // en alttaki renk
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Stack(
                alignment: Alignment.center,
                children: [
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
                  const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "JuaNote",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Expanded(
              flex: 8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                      image: AssetImage('assets/img/welcomenote.png'),
                      height: 60),
                  SizedBox(
                    height: 12.0,
                  ),
                  Text(
                    "Not Almayı Kolaylaştır",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Center(
                      child: Text(
                        "Not almak hiç bu kadar kolay olmamıştı. Şimdi sıra sende!",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              // ignore: avoid_unnecessary_containers
              child: Padding(
                padding: const EdgeInsets.only(left: 19.0, right: 19.0, bottom: 20.0, top: 10.0),
                child: InkWell(
                  onTap: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (build) => const HomeScreen()));
                  },
                  child: Container(
                    width: double.infinity,
                  
                    decoration: const BoxDecoration(
                      color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(23.0))
                    ),
                    child: const  Center(
                      child: Text("Hadi Başlayalım", style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF161616),
                      ),),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
