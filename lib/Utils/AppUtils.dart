import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'dart:math';


class AppUtils {

  static final int SECOND_MILLIS = 1000;
  static final int MINUTE_MILLIS = 60 * SECOND_MILLIS;
  static final int HOUR_MILLIS = 60 * MINUTE_MILLIS;
  static final int DAY_MILLIS = 24 * HOUR_MILLIS;
  static final int MONTH = 2592000000;

  static String getDateTimeAgo(String str_date) {
    String formatedCutTime = str_date.substring(17, 22);
    int time = convertStringDatetoTimeStammp(str_date);
    if (time < 1000000000000) {
      time *= 1000;
    }

    int now = new DateTime.now().millisecondsSinceEpoch;

    final int diff = now - time;
    if (diff < MINUTE_MILLIS) {
      return "Vừa xong";
    } else if (diff < HOUR_MILLIS) {
      return (diff / MINUTE_MILLIS).toString() + " phút trước";
    } else if (diff < 12 * HOUR_MILLIS) {
      return (diff / HOUR_MILLIS).toString() + " giờ trước";
    } else if (diff < DAY_MILLIS) {
//      Calendar day = Calendar.getInstance();
//      day.setTimeInMillis(time);
//
//      Calendar today = Calendar.getInstance();
//      if (today.get(Calendar.DATE) == day.get(Calendar.DATE)) {
//        return "Hôm nay lúc " + formatedCutTime;
//      } else {
//        return "Hôm qua lúc " + formatedCutTime;
//      }

      return "Hôm nay lúc " + formatedCutTime;
    } else if (diff < 48 * HOUR_MILLIS) {
//      Calendar day = Calendar.getInstance();
//      day.setTimeInMillis(time);
//
//      Calendar today = Calendar.getInstance();
//      if (today.get(Calendar.DATE) - day.get(Calendar.DATE) == 1) {
//        return "Hôm qua lúc " + formatedCutTime;
//      } else {
//        return "Hôm kia lúc " + formatedCutTime;
//      }
      return "Hôm qua lúc " + formatedCutTime;
    } else if (diff < MONTH) {
      return formatStringDateTiengViet5(str_date);
    } else {
      return formatStringDateTiengViet6(str_date);
    }
  }

  static String formatStringDateTiengViet5(String str_date) {
    String formatedCut0 = str_date.substring(0, 3);
    String formatedCut1 = str_date.substring(5, 11);
    String formatedCut2 = str_date.substring(17, 22);

    String cutTotal = formatedCut0 + " " + formatedCut1 + " lúc " +
        formatedCut2;
    String formated = cutTotal
        .replaceAll("Mon", "T2")
        .replaceAll("Tue", "T3")
        .replaceAll("Wed", "T4")
        .replaceAll("Thu", "T5")
        .replaceAll("Fri", "T6")
        .replaceAll("Sat", "T7")
        .replaceAll("Sun", "CN")
        .replaceAll("Jan", "Th1")
        .replaceAll("Feb", "Th2")
        .replaceAll("Mar", "Th3")
        .replaceAll("Apr", "Th4")
        .replaceAll("May", "Th5")
        .replaceAll("Jun", "Th6")
        .replaceAll("Jul", "Th7")
        .replaceAll("Aug", "Th8")
        .replaceAll("Sep", "Th9")
        .replaceAll("Oct", "Th10")
        .replaceAll("Nov", "Th11")
        .replaceAll("Dec", "Th12");
    return formated;
  }

  static String formatStringDateTiengViet6(String str_date) {
    String formatedCut1 = str_date.substring(5, 11);
    String formatedCut2 = str_date.substring(17, 22);
    String formatedCutYear = str_date.substring(12, 16);


    String cutTotal = formatedCut1 + "," + formatedCutYear + " lúc " +
        formatedCut2;
    String formated = cutTotal
        .replaceAll("Jan", "Th1")
        .replaceAll("Feb", "Th2")
        .replaceAll("Mar", "Th3")
        .replaceAll("Apr", "Th4")
        .replaceAll("May", "Th5")
        .replaceAll("Jun", "Th6")
        .replaceAll("Jul", "Th7")
        .replaceAll("Aug", "Th8")
        .replaceAll("Sep", "Th9")
        .replaceAll("Oct", "Th10")
        .replaceAll("Nov", "Th11")
        .replaceAll("Dec", "Th12");
    return formated;
  }


  static int convertStringDatetoTimeStammp(String str_date) {
    int timeStamp = 0;
    String dateFormatZ = str_date + "00";

    final df = new DateFormat('E, dd MMM yyyy HH:mm:ss Z');
    DateTime date = df.parse(dateFormatZ);
    timeStamp = date.millisecondsSinceEpoch;
    return timeStamp;
  }

  static Image getSharingOptionIcon(int sharing_option,double width,double height) {
    switch (sharing_option) {
      case 1:
        return Image.asset("assets/images/ic_friends.png",width: width,height: height,);
      case 2:
        return Image.asset("assets/images/ic_option_user.png",width: width,height: height);
      default:
        return Image.asset("assets/images/ic_public.png",width: width,height: height);
    }
  }

  static String formatNumber (int number)
  {
    String _formattedNumber = number.toString();
    if (number>100000)
      {
         _formattedNumber = NumberFormat.compactCurrency(
          decimalDigits: 2,
          symbol: '', // if you want to add currency symbol then pass that in this else leave it empty.
        ).format(number);
      }
    return _formattedNumber;
  }
}