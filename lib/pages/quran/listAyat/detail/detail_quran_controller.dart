import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:mesjid_app/pages/quran/quran_service.dart';

class DetailAyatQuranController extends GetxController {
  var isLoadingList = true.obs;
  var list = {}.obs;
  List listSurah = [].obs;
  List listAyat = [].obs;
  late List<RxBool> listAyatBookmarked;

  var txtController = TextEditingController();

  var surah = Get.arguments['selectedSurah'];

  var isChecked = false.obs;

  getData() async {
    final result = await QuranService().getList(page: 0, limit: 10);
    list.value = result['data'];
    isLoadingList.value = false;
  }

  getAyats() async {
    return listSurah = [
      {
        "id": 2,
        "title": "Al-Fatihah",
        "subTitle": "Pembukaan",
        "category": "Donatur",
        "type": "Makiah",
        "total": "75"
      },
      {
        "id": 3,
        "title": "Al-Fatihah",
        "subTitle": "Pembukaan",
        "category": "Donatur",
        "type": "Makiah",
        "total": "75"
      },
      {
        "id": 4,
        "title": "Al-Fatihah",
        "subTitle": "Pembukaan",
        "category": "Donatur",
        "type": "Makiah",
        "total": "75"
      },
      {
        "id": 5,
        "title": "Al-Fatihah",
        "subTitle": "Pembukaan",
        "category": "Donatur",
        "type": "Makiah",
        "total": "75"
      },
      {
        "id": 6,
        "title": "Al-Fatihah",
        "subTitle": "Pembukaan",
        "category": "Donatur",
        "type": "Makiah",
        "total": "75"
      },
      {
        "id": 7,
        "title": "Al-Ikhlas",
        "subTitle":
            "Pembukaan terus menerus yaaa Pembukaan terus menerus yaaa ",
        "category": "Donatur",
        "type": "Madaniah",
        "total": "75"
      },
      {
        "id": 8,
        "title": "Al-Ikhlas",
        "subTitle": "Pembukaan",
        "category": "Donatur",
        "type": "Madaniah",
        "total": "75"
      },
      {
        "id": 9,
        "title": "Al-Ikhlas",
        "subTitle": "Pembukaan",
        "category": "Donatur",
        "type": "Madaniah",
        "total": "105"
      },
      {
        "id": 10,
        "title": "Al-Anfal",
        "subTitle": "Pembukaan",
        "category": "Donatur",
        "type": "Madaniah",
        "total": "105"
      },
      {
        "id": 11,
        "title": "Al-Anfal",
        "subTitle": "Pembukaan",
        "category": "Donatur",
        "type": "Makiah",
        "total": "105"
      },
    ];
  }

  getAyat() async {
    listAyat = [
      {
        "id": 1,
        "ayat": "بسم الله الرحمن الرحيم",
        "descEN":
            "In the name of Allah, the Entirely Merciful, the Especially Merciful.",
        "descIDN":
            "Dengan menyebut nama Allah Yang Maha Penyayang lagi Maha Penyayang.",
        "nomor": "1",
        "bookmarked": true
      },
      {
        "id": 2,
        "ayat": "بسم الله الرحمن الرحيم",
        "descEN":
            "In the name of Allah, the Entirely Merciful, the Especially Merciful.",
        "descIDN":
            "Dengan menyebut nama Allah Yang Maha Penyayang lagi Maha Penyayang.",
        "nomor": "2",
        "bookmarked": false
      },
      {
        "id": 3,
        "ayat":
            "يٰۤـاَيُّهَا الَّذِيۡنَ اٰمَنُوۡۤا اِذَا تَدَايَنۡتُمۡ بِدَيۡنٍ اِلٰٓى اَجَلٍ مُّسَمًّى فَاكۡتُبُوۡهُ ​ؕ وَلۡيَكۡتُب بَّيۡنَكُمۡ كَاتِبٌۢ بِالۡعَدۡلِ​ وَلَا يَاۡبَ كَاتِبٌ اَنۡ يَّكۡتُبَ كَمَا عَلَّمَهُ اللّٰهُ​ فَلۡيَكۡتُبۡ ​ۚ وَلۡيُمۡلِلِ الَّذِىۡ عَلَيۡهِ الۡحَـقُّ وَلۡيَتَّقِ اللّٰهَ رَبَّهٗ وَلَا يَبۡخَسۡ مِنۡهُ شَيۡـــًٔا ​ؕ فَاِنۡ كَانَ الَّذِىۡ عَلَيۡهِ الۡحَـقُّ سَفِيۡهًا اَوۡ ضَعِيۡفًا اَوۡ لَا يَسۡتَطِيۡعُ اَنۡ يُّمِلَّ هُوَ فَلۡيُمۡلِلۡ وَلِيُّهٗ بِالۡعَدۡلِ​ؕ وَاسۡتَشۡهِدُوۡا شَهِيۡدَيۡنِ مِنۡ رِّجَالِكُمۡ​ۚ فَاِنۡ لَّمۡ يَكُوۡنَا رَجُلَيۡنِ فَرَجُلٌ وَّامۡرَاَتٰنِ مِمَّنۡ تَرۡضَوۡنَ مِنَ الشُّهَدَآءِ اَنۡ تَضِلَّ اِحۡدٰٮهُمَا فَتُذَكِّرَ اِحۡدٰٮهُمَا الۡاُخۡرٰى​ؕ وَ لَا يَاۡبَ الشُّهَدَآءُ اِذَا مَا دُعُوۡا ​ؕ وَلَا تَسۡـــَٔمُوۡۤا اَنۡ تَكۡتُبُوۡهُ صَغِيۡرًا اَوۡ كَبِيۡرًا اِلٰٓى اَجَلِهٖ​ؕ ذٰ لِكُمۡ اَقۡسَطُ عِنۡدَ اللّٰهِ وَاَقۡوَمُ لِلشَّهَادَةِ وَاَدۡنٰۤى اَلَّا تَرۡتَابُوۡٓا اِلَّاۤ اَنۡ تَكُوۡنَ تِجَارَةً حَاضِرَةً تُدِيۡرُوۡنَهَا بَيۡنَكُمۡ فَلَيۡسَ عَلَيۡكُمۡ جُنَاحٌ اَلَّا تَكۡتُبُوۡهَا ​ؕ وَاَشۡهِدُوۡۤا اِذَا تَبَايَعۡتُمۡ وَلَا يُضَآرَّ كَاتِبٌ وَّلَا شَهِيۡدٌ  ؕ وَاِنۡ تَفۡعَلُوۡا فَاِنَّهٗ فُسُوۡقٌ ۢ بِكُمۡ ؕ وَ اتَّقُوا اللّٰهَ​ ؕ وَيُعَلِّمُكُمُ اللّٰهُ​ ؕ وَاللّٰهُ بِكُلِّ شَىۡءٍ عَلِيۡمٌ",
        "descEN":
            "O you who believe! If you have debts and receivables for a specified period of time, you should write them down. And let a writer among you write it correctly. Let the writer not refuse to write it as Allah has taught him, so let him write it. And let the person who owes it dictate, and let him fear Allah, his Lord, and let him not deduct anything from it. If the debtor is someone who lacks intelligence or is weak (in his condition), or is unable to dictate himself, then let his guardian dictate it correctly. And testify with two male witnesses among you. If there are not two male (witnesses), then (may be) a man and two women among the people you like from the (existing) witnesses, so that if one forgets, the other will remind him. And don't let the witnesses refuse when called. And don't get bored of writing it down, for the deadline, whether (the debt) is small or large. That is more just in the sight of Allah, more able to strengthen testimony, and closer to you being beyond doubt, except if it is a cash trade that you carry out between yourselves, then there is no sin for you if you do not write it down. And take witnesses when you buy and sell, and do not make writing difficult and neither are witnesses. If you do (that), then indeed, it is an act of wickedness on your part. And fear Allah, Allah teaches you, and Allah is All-Knowing of everything.",
        "descIDN":
            "Wahai orang-orang yang beriman! Apabila kamu melakukan utang piutang untuk waktu yang ditentukan, hendaklah kamu menuliskannya. Dan hendaklah seorang penulis di antara kamu menuliskannya dengan benar. Janganlah penulis menolak untuk menuliskannya sebagaimana Allah telah mengajarkan kepadanya, maka hendaklah dia menuliskan. Dan hendaklah orang yang berutang itu mendiktekan, dan hendaklah dia bertakwa kepada Allah, Tuhannya, dan janganlah dia mengurangi sedikitpun daripadanya. Jika yang berutang itu orang yang kurang akalnya atau lemah (keadaannya), atau tidak mampu mendiktekan sendiri, maka hendaklah walinya mendiktekannya dengan benar. Dan persaksikanlah dengan dua orang saksi laki-laki diantara kamu. Jika tidak ada (saksi) dua orang laki-laki, maka (boleh) seorang laki-laki dan dua orang perempuan diantara orang-orang yang kamu sukai dari para saksi (yang ada), agar jika yang seorang lupa maka yang lain mengingatkannya. Dan janganlah saksi-saksi itu menolak apabila dipanggil. Dan janganlah kamu bosan menuliskannya, untuk batas waktunya baik (utang itu) kecil maupun besar. Yang demikian itu, lebih adil di sisi Allah, lebih dapat menguatkan kesaksian, dan lebih mendekatkan kamu kepada ketidakraguan, kecuali jika hal itu merupakan perdagangan tunai yang kamu jalankan diantara kamu, maka tidak ada dosa bagi kamu jika kamu tidak menuliskannya. Dan ambillah saksi apabila kamu berjual beli, dan janganlah menulis dipersulit dan begitu juga saksi. Jika kamu lakukan (yang demikian), maka sungguh, hal itu suatu kefasikan pada kamu. Dan bertakwalah kepada Allah, Allah memberikan pengajaran kepadamu, dan Allah Maha Mengetahui segala sesuatu.",
        "nomor": "2",
        "bookmarked": false
      },
    ];
    listAyatBookmarked = List.generate(listAyat.length, (index) => false.obs);
    return listAyat;
  }

  bookmark() async {
    Fluttertoast.showToast(
        msg: "Ayat Berhasil Ditandai",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black87,
        timeInSecForIosWeb: 1,
        fontSize: Get.width / 30);
  }

  @override
  void onInit() {
    print(surah);
    getAyats();
    getAyat();
    super.onInit();
  }
}
