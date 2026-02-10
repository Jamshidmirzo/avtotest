import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:avtotest/presentation/features/home/data/model/answer_model.dart';
import 'package:avtotest/presentation/features/home/data/model/question_model.dart';
import 'package:avtotest/presentation/features/home/data/model/topic_model.dart';
import 'package:avtotest/presentation/features/home/presentation/widgets/answer_widget.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'constants.dart';

abstract class MyFunctions {
  static String getAssetsImage(String imageName) {
    return 'lib/content/media/$imageName.jpg';
  }

  static String getAssetsSvgImage(String imageName) {
    return 'lib/content/media/$imageName.svg';
  }

  static String getTitle(QuestionModel questionModel, String lang) {
    switch (lang) {
      case 'uz':
        return questionModel.questionLa;
      case 'ru':
        return questionModel.questionRu;
      default:
        return questionModel.questionUz;
    }
  }

  static String getAnswerTitle(
      {required AnswerModel answerModel, required String lang}) {
    switch (lang) {
      case 'uz':
        return answerModel.answerLa;
      case 'ru':
        return answerModel.answerRu;
      default:
        return answerModel.answerUz;
    }
  }

  static String getDescription(
      int index, List<Map<String, String>> rules, String lang) {
    return rules[index]['description_$lang'] ?? '';
  }

  static String highlightHtmlText(
    String htmlContent,
    String searchText, {
    String textColor = "black",
    String backgroundColor = "yellow",
  }) {
    if (searchText.isEmpty) return htmlContent;

    final escapedSearch = RegExp.escape(searchText);
    final regex = RegExp('($escapedSearch)', caseSensitive: false);

    return htmlContent.replaceAllMapped(regex, (match) {
      return '<span style="background-color: $backgroundColor; color: $textColor;">${match[0]}</span>';
    });
  }

  static String getLessonTitle(
      {required TopicModel lesson, required String lang}) {
    switch (lang) {
      case 'uz':
        return lesson.titleLa;
      case 'ru':
        return lesson.titleRu;
      default:
        return lesson.titleUz;
    }
  }

  static String capitalizeFirstLetter({required String text}) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  static String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = duration.inMinutes; // To'liq daqiqalar
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  static String getQuestionTitle({
    required QuestionModel questionModel,
    required String lang,
  }) {
    switch (lang) {
      case 'uz':
        return questionModel.questionLa;
      case 'ru':
        return questionModel.questionRu;
      default:
        return questionModel.questionUz;
    }
  }

  static String getQuestionDescription({
    required QuestionModel questionModel,
    required String lang,
  }) {
    switch (lang) {
      case 'uz':
        return questionModel.questionDescriptionLa;
      case 'ru':
        return questionModel.questionDescriptionRu;
      default:
        return questionModel.questionDescriptionUz;
    }
  }

  static AnswerStatus getAnswerStatus({
    required QuestionModel questionModel,
    required int index,
  }) {
    if (questionModel.isAnswered) {
      if (questionModel.answers[index].isCorrect) {
        return AnswerStatus.correct;
      } else {
        if (index == questionModel.errorAnswerIndex) {
          return AnswerStatus.incorrect;
        } else {
          return AnswerStatus.notAnswered;
        }
      }
    } else {
      if (questionModel.confirmedAnswerIndex != -1 &&
          questionModel.confirmedAnswerIndex == index) {
        return AnswerStatus.confirm;
      } else {
        return AnswerStatus.notAnswered;
      }
    }
  }

  static String removeHtmlTags(String htmlString) {
    return htmlString.replaceAll("<strong>", '').replaceAll("</strong>", "");
  }

  static String removeHtmlTagsWithSpaces(String htmlString) {
    // 1. Odatdagi HTML teglari
    final tagsToReplaceWithSpace = [
      '<p>', '</p>',
      '<br>', '<br/>', '<br />',
      '&nbsp;',
      '<div>', '</div>',
      '<li>', '</li>',
      '<ul>', '</ul>',
      '<ol>', '</ol>',
      '<h1>', '</h1>',
      '<h2>', '</h2>',
      '<h3>', '</h3>',
      '<h4>', '</h4>',
      '<h5>', '</h5>',
      '<h6>', '</h6>',
      '<p class="ql-align-justify">', // Custom case
    ];

    for (final tag in tagsToReplaceWithSpace) {
      htmlString = htmlString.replaceAll(tag, ' ');
    }

    // 2. Kuchli (bold) teglarni olib tashlash (strong, b, i, em va boshqalar)
    final tagsToRemove = [
      '<strong>',
      '</strong>',
      '<b>',
      '</b>',
      '<i>',
      '</i>',
      '<em>',
      '</em>',
      '<span>',
      '</span>',
    ];

    for (final tag in tagsToRemove) {
      htmlString = htmlString.replaceAll(tag, '');
    }

    // 3. Barcha qolgan HTML teglarini olib tashlash (regex asosida)
    htmlString = htmlString.replaceAll(RegExp(r'<[^>]*>'), '');

    // 4. Ortiqcha bo‘sh joylarni tozalash
    htmlString = htmlString.replaceAll(RegExp(r'\s+'), ' ').trim();

    return htmlString;
  }

  static String removeHtmlTagsWithNewLines(String htmlString) {
    return htmlString
        .replaceAll("<p>", "")
        .replaceAll("</p>", "")
        .replaceAll("&nbsp;", "");
  }

  static launchTelegram() async {
    debugPrint("launchTelegram called");
    const url = 'https://t.me/avtotest_support';
    await launchUrl(Uri.parse(url));
  }

  static launchTelegramForSubscriptionRequest({required String id}) async {
    debugPrint("launchTelegramForSubscriptionRequest called");

    const url = 'https://t.me/avtotest_support';
    await launchUrl(Uri.parse(url));
  }

  static Future<void> copyToClipboard(String text) async {
    try {
      await Clipboard.setData(ClipboardData(text: text));
      debugPrint('Clipboardga nusxalandi: $text');
    } catch (e) {
      debugPrint('copyToClipboard error: $e');
    }
  }

  static Future<void> copyTClipboard(String text) async {
    try {
      await Clipboard.setData(ClipboardData(text: text));
      debugPrint('Clipboardga nusxalandi: $text');
    } catch (e) {
      debugPrint('copyToClipboard error: $e');
    }
  }

  static Future<void> shareAppLink(BuildContext context) async {
    try {
      final String url = Platform.isAndroid
          ? appDetailPageInPlayMarket
          : appDetailPageInAppStore;

      // RenderObject-ni olish
      final RenderObject? renderObject = context.findRenderObject();
      Rect? shareRect;

      // Agar bu oddiy vidjet bo'lsa (RenderBox)
      if (renderObject is RenderBox) {
        shareRect = renderObject.localToGlobal(Offset.zero) & renderObject.size;
      }
      // Agar bu Sliver ichida bo'lsa, butun ekranning markazini olish (zaxira varianti)
      else {
        final size = MediaQuery.of(context).size;
        shareRect = Rect.fromLTWH(0, 0, size.width, size.height / 2);
      }

      await Share.share(
        url,
        subject: "AvtoTest ilovasini yuklab oling",
        sharePositionOrigin: shareRect,
      );
    } catch (e) {
      debugPrint("Ilovani ulashishda xatolik: $e");
    }
  }

  static Future<void> rateApp() async {
    final url = Platform.isAndroid
        ? appDetailPageInPlayMarket
        : appDetailPageInAppStore;

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      debugPrint("Store sahifasiga o'tolmadi: $url");
    }
  }

  /// Closes the app by exiting the application
  static Future<void> closeApp() async {
    try {
      if (Platform.isAndroid) {
        SystemNavigator.pop();
      } else if (Platform.isIOS) {
        exit(0);
      }
    } catch (e) {
      debugPrint('closeApp error: $e');
    }
  }

  /// Opens the app store or play store for the current app
  static Future<void> openAppStore() async {
    final url = Platform.isAndroid
        ? appDetailPageInPlayMarket
        : appDetailPageInAppStore;
    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        debugPrint('Could not launch store URL: $url');
      }
    } catch (e) {
      debugPrint('Could not launch store URL: $url, error: $e');
    }
  }

  static Future<List<dynamic>> decryptFile({
    required String inputFilePath,
    required String keyBase64,
    required String ivBase64,
  }) async {
    try {
      String jsonString = await rootBundle.loadString(inputFilePath);
      final encrypted = encrypt.Encrypted.fromBase64(jsonString);

      final key = encrypt.Key.fromBase64(keyBase64);
      final iv = encrypt.IV.fromBase64(ivBase64);

      final encrypter =
          encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
      final decrypted = encrypter.decrypt(encrypted, iv: iv);

      debugPrint("decryptFile -> Faylni deshifrlash qiymat ->$decrypted<-");

      List<dynamic> result = jsonDecode(decrypted);
      debugPrint(
          "decryptFile -> Deshifrlangan va formatlangan ma'lumotlar: $result");
      return result;
    } catch (e) {
      debugPrint(
          'decryptFile -> Faylni deshifrlashda xato ($inputFilePath): $e');
      return []; // Xato bo'lsa bo'sh Map qaytarish
    }
  }

  // Yangi metod - faqat ma'lumotlarni deshifrlash uchun
  static Future<List<dynamic>> decryptData({
    required String encryptedData,
    required String keyBase64,
    required String ivBase64,
  }) async {
    try {
      final encrypted = encrypt.Encrypted.fromBase64(encryptedData);

      final key = encrypt.Key.fromBase64(keyBase64);
      final iv = encrypt.IV.fromBase64(ivBase64);

      final encrypter =
          encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
      final decrypted = encrypter.decrypt(encrypted, iv: iv);

      List<dynamic> result = jsonDecode(decrypted);
      debugPrint(
          "decryptData -> Deshifrlangan va formatlangan ma'lumotlar uzunligi: ${result.length}");
      return result;
    } catch (e) {
      debugPrint("decryptData -> Ma'lumotni deshifrlashda xato: $e");
      return []; // Xato bo'lsa bo'sh ro'yxat qaytarish
    }
  }
}
