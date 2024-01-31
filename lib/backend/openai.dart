// import 'package:dart_openai/dart_openai.dart';
// import 'package:flutter/material.dart';

// ignore_for_file: equal_keys_in_map, avoid_print, camel_case_types

import 'dart:io';
import 'dart:convert';

import 'package:notesapp/backend/hive.dart';

import 'listNotes.dart';

class startGpt {
  String apiKey = 'YOUR_API_KEY';
  String apiUrl = 'https://api.openai.com/v1/chat/completions';

  Future<String> formatNote(String userInput) async {

    String cleanedUserInput = cleanUserInput(userInput);

    // API request body
    final requestBody = {
      "model": "gpt-3.5-turbo",
      "messages": [
        {
          "role": "user",
          "content":
              "Correct the note I will send you here according to Turkish grammar rules, Please include only corrected notes in your answer to me. NEVER WRITE ANYTHING ELSE. note: $cleanedUserInput"
        }
      ],
      "temperature": 0.7
    };

    // Encode the request body to JSON
    final encodedBody = jsonEncode(requestBody);

    // HTTP POST request
    final response = await HttpClient().postUrl(Uri.parse(apiUrl))
      ..headers.set('Content-Type', 'application/json')
      ..headers.set('Authorization', 'Bearer $apiKey')
      ..write(encodedBody);

    // Get the response
    final httpResponse = await response.close();
    String responseBody = await utf8.decodeStream(httpResponse);

    // Parse the JSON response
    final jsonResponse = jsonDecode(responseBody);

    // Access the content inside message
    final content = jsonResponse['choices'][0]['message']['content'];
    // print('Content: $content');

    return content;
  }

  Future<String> learningAllNotesAndCreateNewNote() async {
    String allNotes = await getAllNotesContent();

    // API endpoint

    String metin =
        "Sana bir kullanıcıya ait tüm not bilgilerini atacağım bu attığım nottaki tüm bilgileri öğren ve hafızana kaydet Daha sonrasında bu kullanıcıya uygun rastgele bir not üret. Bana vereceğin cevapta yalnızca ürettiğin not olsun. Bu not, önceki notlarla aynı kesinlikle olmasın. Bana vereceğin yanıtta yalnızca üretiğin not olsun. Ekstra bir açıklama yapmanı istemiyorum. Yalnızca ürettiğin not ile cevap ver. İşte notlar:";
    metin = cleanUserInput(metin);
    String cleanedUserInput = cleanUserInput(allNotes);

    final requestBody = {
      "model": "gpt-3.5-turbo",
      "messages": [
        {"role": "user", "content": "$metin : $cleanedUserInput"}
      ],
      "temperature": 0.7
    };

    // Encode the request body to JSON
    final encodedBody = jsonEncode(requestBody);

    // HTTP POST request
    final response = await HttpClient().postUrl(Uri.parse(apiUrl))
      ..headers.set('Content-Type', 'application/json')
      ..headers.set('Authorization', 'Bearer $apiKey')
      ..write(encodedBody);

    // Get the response
    final httpResponse = await response.close();
    String responseBody = await utf8.decodeStream(httpResponse);

    // Parse the JSON response
    final jsonResponse = jsonDecode(responseBody);

    // Access the content inside message
    final content = jsonResponse['choices'][0]['message']['content'];
    print('Content: $content');

    return content;
  }

  Future<String> learningAllNotesAndWriteNote(String userInput) async {
    String allNotes = await getAllNotesContent();

    String cleanedUserInput = cleanUserInput(allNotes);
    String user = cleanUserInput(userInput);

    final requestBody = {
      "model": "gpt-3.5-turbo",
      "messages": [
        {
          "role": "user",
          "content":
              "Learn from the following notes and wait me.: $cleanedUserInput",
          "role": "user",
          "content":
              "Continue the information you learned from this note. Please say Turkish. Do not generate a new note, continue from the existing content in this note: $user"
        }
      ],
      "temperature": 0.7
    };

    // Encode the request body to JSON
    final encodedBody = jsonEncode(requestBody);

    // HTTP POST request
    final response = await HttpClient().postUrl(Uri.parse(apiUrl))
      ..headers.set('Content-Type', 'application/json')
      ..headers.set('Authorization', 'Bearer $apiKey')
      ..write(encodedBody);

    // Get the response
    final httpResponse = await response.close();
    String responseBody = await utf8.decodeStream(httpResponse);

    // Parse the JSON response
    final jsonResponse = jsonDecode(responseBody);

    // Access the content inside message
    final content = jsonResponse['choices'][0]['message']['content'];
    print('Content: $content');

    return content;
  }
}
