import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share_plus/share_plus.dart';

class WorshipShareHelper {
  static String formatWorshipText({
    required String title,
    String? subtitle,
    String? arabic,
    String? latin,
    String? translation,
    String? source,
    String appSignature = 'Dibagikan melalui Hudhud',
  }) {
    final buffer = StringBuffer();
    buffer.writeln(title);
    if (subtitle != null && subtitle.trim().isNotEmpty) {
      buffer.writeln(subtitle.trim());
    }
    buffer.writeln();

    if (arabic != null && arabic.trim().isNotEmpty) {
      buffer.writeln(arabic.trim());
      buffer.writeln();
    }

    if (latin != null && latin.trim().isNotEmpty) {
      buffer.writeln(latin.trim());
      buffer.writeln();
    }

    if (translation != null && translation.trim().isNotEmpty) {
      buffer.writeln('Artinya:');
      buffer.writeln('"${translation.trim()}"');
      buffer.writeln();
    }

    if (source != null && source.trim().isNotEmpty) {
      buffer.writeln('Sumber: ${source.trim()}');
      buffer.writeln();
    }

    buffer.writeln('($appSignature)');
    return buffer.toString().trim();
  }

  static void copy({
    required String text,
    String successMessage = 'Teks berhasil disalin',
  }) {
    Clipboard.setData(ClipboardData(text: text));
    Fluttertoast.showToast(
      msg: successMessage,
      backgroundColor: const Color(0xFFD06A4C),
      textColor: Colors.white,
    );
  }

  static void share({
    required String text,
    String? subject,
  }) {
    SharePlus.instance.share(
      ShareParams(
        text: text,
        subject: subject,
      ),
    );
  }

  static void copyItem({
    required String title,
    String? subtitle,
    String? arabic,
    String? latin,
    String? translation,
    String? source,
    String successMessage = 'Teks berhasil disalin',
  }) {
    final text = formatWorshipText(
      title: title,
      subtitle: subtitle,
      arabic: arabic,
      latin: latin,
      translation: translation,
      source: source,
    );
    copy(text: text, successMessage: successMessage);
  }

  static void shareItem({
    required String title,
    String? subtitle,
    String? arabic,
    String? latin,
    String? translation,
    String? source,
  }) {
    final text = formatWorshipText(
      title: title,
      subtitle: subtitle,
      arabic: arabic,
      latin: latin,
      translation: translation,
      source: source,
    );
    share(text: text, subject: title);
  }
}
