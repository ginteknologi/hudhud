import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mesjid_app/components/button/elevatedbutton.dart';
import 'package:mesjid_app/components/layout/app_bar_ws.dart';
import 'package:mesjid_app/components/partial/list_card_ui.dart';
import 'package:mesjid_app/pages/artikel/detail/detail_artikel_controller.dart';
import 'package:flutter_html/flutter_html.dart';

class DetailArtikelPage extends StatelessWidget {
  const DetailArtikelPage({super.key});

  layout(DetailArtikelController ctrl, BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Padding(
                padding: const EdgeInsets.only(left: 21, right: 21),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                          elevation: 0,
                          color: const Color(0xFFF5F5F5),
                          margin: const EdgeInsets.only(top: 20),
                          clipBehavior: Clip.antiAlias,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            //set border radius more than 50% of height and width to make circle
                          ),
                          child: Container(
                            width: Get.width,
                            height: 170,
                            constraints: BoxConstraints.loose(Size.infinite),
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(
                                        ctrl.selectedArtikel['image']),
                                    fit: BoxFit.fill)),
                          )),
                     const SizedBox(
                        height: 20,
                      ),
                      Container(
                        // width: Get.width,
                        // height: 170,
                        padding:
                            const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        constraints: BoxConstraints.loose(Size.infinite),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Text(
                          ctrl.selectedArtikel['category'],
                          style: context.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      AutoSizeText(
                        "Sedekah yang Paling Utama adalah yang Paling Sesuai dengan Kondisi Penerima Sedekah",
                        style: context.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold, color: Colors.black),
                        maxLines: 4,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                          ctrl.selectedArtikel['time'] +
                              "  |  " +
                              ctrl.selectedArtikel['date'],
                          style: context.textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0,
                              color: Colors.black)),
                      const SizedBox(
                        height: 20,
                      ),
Html(
              data: '''
<h2><b>Teks hadist</b></h2>
<span style="font-weight: 400;">Dari </span><a href="https://muslim.or.id/84260-abu-said-al-khudri.html"><span style="font-weight: 400;">Abu Sa’id Al-Khudhri</span></a> <i><span style="font-weight: 400;">radhiyallahu ‘anhu, </span></i><span style="font-weight: 400;">Rasulullah </span><i><span style="font-weight: 400;">shallallahu ‘alaihi wasallam </span></i><span style="font-weight: 400;">bersabda,</span>

<span style="font-weight: 400;">أَيُّمَا مُسْلِمٍ كَسَا مُسْلِمًا ثَوْبًا عَلَى عُرْيٍ، كَسَاهُ اللَّهُ مِنْ خُضْرِ الْجَنَّةِ، وَأَيُّمَا مُسْلِمٍ أَطْعَمَ مُسْلِمًا عَلَى جُوعٍ، أَطْعَمَهُ اللَّهُ مِنْ ثِمَارِ الْجَنَّةِ، وَأَيُّمَا مُسْلِمٍ سَقَى مُسْلِمًا عَلَى ظَمَإٍ، سَقَاهُ اللَّهُ مِنَ الرَّحِيقِ الْمَخْتُومِ</span>

<span style="font-weight: 400;">“</span><i><span style="font-weight: 400;">Siapa pun seorang muslim yang memakaikan pakaian kepada muslim yang lainnya karena ia tidak berpakaian, maka Allah akan memakaikan kepadanya pakaian dari pakaian yang hijau di surga. Siapa pun seorang muslim yang memberikan makan kepada muslim lainnya yang dalam keadaan lapar, maka Allah akan memberinya makanan dari buah-buahan di surga. Dan siapa pun seorang muslim yang memberi minum muslim lainnya yang dalam keadaan haus, maka Allah akan memberinya minum dari ar-rahiq al-makhtum (arak surga).</span></i><span style="font-weight: 400;">” (HR. Abu Dawud no. 1682. Dinilai </span><i><span style="font-weight: 400;">dha’if </span></i><span style="font-weight: 400;"> oleh </span><a href="https://muslim.or.id/27562-biografi-asy-syaikh-al-muhaddits-muhammad-nashiruddin-al-albani-1.html"><span style="font-weight: 400;">Al-Albani</span></a><span style="font-weight: 400;">. Di dalam sanadnya terdapat perawi bernama Abu Khalid Ad-Dalani, dia ini jujur, namun sering salah dalam meriwayatkan hadis. Lihat pula </span><i><span style="font-weight: 400;">Tahdzib At-Tahdzib, </span></i><span style="font-weight: 400;">12: 89)</span>
<h2><b>Kandungan hadis</b></h2>
<b><i>Kandungan pertama, </i></b><span style="font-weight: 400;">hadis ini mengandung motivasi untuk berhias dengan akhlak yang mulia ini, yaitu senang memberi bantuan kepada orang lain yang membutuhkan dalam rangka mencari ganjaran dan pahala. Hadis ini juga menunjukkan bahwa siapa saja yang beramal dengan suatu amal, maka akan mendapatkan balasan yang semisal pada hari kiamat. Allah </span><i><span style="font-weight: 400;">Ta’ala </span></i><span style="font-weight: 400;">berfirman,</span>

<span style="font-weight: 400;">جَزَاء مِّن رَّبِّكَ عَطَاء حِسَاباً</span>

<span style="font-weight: 400;">“</span><i><span style="font-weight: 400;">Sebagai pembalasan dari Tuhanmu dan pemberian yang cukup banyak.</span></i><span style="font-weight: 400;">” (</span><a href="https://tafsirweb.com/11926-surat-an-naba-ayat-36.html"><span style="font-weight: 400;">QS. An-Naba’: 36</span></a><span style="font-weight: 400;">)</span>

<span style="font-weight: 400;">Allah </span><i><span style="font-weight: 400;">Ta’ala </span></i><span style="font-weight: 400;">juga berfirman,</span>

<span style="font-weight: 400;">هَلْ جَزَاء الْإِحْسَانِ إِلَّا الْإِحْسَانُ</span>

<span style="font-weight: 400;">“</span><i><span style="font-weight: 400;">Bukankah tidak ada balasan kebaikan, kecuali kebaikan (pula).</span></i><span style="font-weight: 400;">” (QS. Ar-Rahman: 60)</span>

<span style="font-weight: 400;">Siapa saja yang memberi pakaian kepada orang yang tidak memiliki pakaian, maka dia akan diberi pakaian dari pakaian surga yang berwarna hijau. Ini adalah pakaian yang paling bernilai dan berharga. Siapa saja yang memberi makan orang yang kelaparan, maka akan diberi makan dari buah-buahan surga. Dan siapa saja yang memberi minum orang yang kehausan, maka dia akan diberi minum dari </span><i><span style="font-weight: 400;">ar-rakhiq al-makhtum, </span></i><span style="font-weight: 400;">yaitu sari </span><i><span style="font-weight: 400;">khamr </span></i><span style="font-weight: 400;">di surga.</span>

<span style="font-weight: 400;">Hadis ini, dan hadis-hadis lain yang semakna dengannya, meskipun sanadnya lemah </span><i><span style="font-weight: 400;">(dha’if), </span></i><span style="font-weight: 400;">akan tetapi maknanya benar (sahih). Hal ini karena didukung dengan dalil-dalil yang menunjukkan keutamaan sedekah. Di antara bentuk sedekah adalah memberi pakaian kepada orang yang tidak memiliki pakaian dan memberi makan kepada orang-orang yang kelaparan tidak memiliki makanan. Demikian pula, hadis ini didukung oleh dalil-dalil yang menunjukkan bahwa balasan </span><i><span style="font-weight: 400;">(al-jazaa’) </span></i><span style="font-weight: 400;">itu sejenis (setimpal) dengan amal perbuatan. Surga adalah negeri yang penuh dengan kemuliaan dan nikmat. Surga adalah negeri tempat adanya balasan dan kebaikan. Dan Allah </span><i><span style="font-weight: 400;">Ta’ala </span></i><span style="font-weight: 400;">memberikan balasan kepada seorang hamba sesuai dengan amalnya, bahkan lebih banyak dari amalnya sebagai anugerah dan keutamaan untuk hamba-Nya.</span>
<h4><b><i>Kandungan kedua,  </i></b><span style="font-weight: 400;">hadis ini merupakan dalil tentang keutamaan sedekah yang sesuai dengan kebutuhan orang yang menerima sedekah. Misalnya, jika ada orang yang tidak memiliki pakaian, maka kita bersedekah dengan memberi pakaian. Karena dalam kondisi tersebut, dia sangat membutuhkan pakaian untuk menutup auratnya, atau untuk melindungi diri dari cuaca panas dan dingin. Jika ada orang yang kelaparan, maka dia memberi bantuan dalam bentuk makanan. Atau jika ada orang yang membutuhkan air, maka dia memberi bantuan dalam bentuk air minum atau sarana-sarana untuk mendapatkan air, misalnya dengan membangun sumur bor, atau sejenisnya.</span></h4>
<span style="font-weight: 400;">Oleh karena itu, hendaknya seorang muslim memperhatikan hal ini. Hendaknya seorang muslim melihat pada setiap masa, manakah yang lebih bermanfaat untuk orang yang akan diberikan sedekah. Jika datang musim dingin, dia pun bersedekah dengan pakaian musim dingin sehingga orang-orang yang membutuhkan tidak kedinginan. Jika sedang musim panas (musim kemarau), dia bersedekah dengan bentuk yang sesuai, misalnya memberi bantuan air bersih ke daerah-daerah yang dilanda kekeringan.</span>

<span style="font-weight: 400;">Demikian pembahasan singkat ini, semoga bermanfaat.</span>

<i><span style="font-weight: 400;">Wallahu Ta’ala a’lam.</span></i>

<i><span style="font-weight: 400;">Sumber: muslim.or.id</span></i>
              ''',
              style: {
                'h2': Style(
                  fontSize: FontSize(24.0),
                  fontWeight: FontWeight.bold,
                ),
                'b': Style(
                  fontWeight: FontWeight.bold,
                ),
                'i': Style(
                  fontStyle: FontStyle.italic,
                ),
                'a': Style(
                  color: Colors.blue,
                ),
              },
            ),
                      // Text(
                      //     "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer fringilla libero a turpis viverra vehicula. Sed ac pellentesque ligula, ac pharetra justo. Donec ut erat vitae tortor accumsan convallis. Aenean ornare commodo purus sed semper. Sed fermentum et mi ac condimentum. Etiam sed sagittis ex, in imperdiet urna. Cras iaculis ante et purus molestie lacinia. Mauris id dolor et velit tempus imperdiet sit amet vel arcu. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Vivamus interdum venenatis quam. Fusce ullamcorper at arcu ut placerat. Nulla",
                      //     style: context.textTheme.bodySmall?.copyWith(
                      //         fontWeight: FontWeight.normal,
                      //         letterSpacing: 0,
                      //         color: Colors.black)),
                      const SizedBox(
                        height: 20,
                      ),
                      const Divider(
                        color: Colors.black38,
                      ),
                      Container(
                        // height: 53,
                        width: Get.width,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Container(
                                padding: const EdgeInsets.only(right: 13.0),
                                child: AutoSizeText("Yuk ingetin yang lain!",
                                    maxLines: 1,
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: Theme.of(context)
                                            .textTheme
                                            .labelLarge
                                            ?.fontSize,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                            Flexible(
                              child: SizedBox(
                                width: double.infinity,
                                child: ButtonElevated(
                                  title: 'Bagikan Sekarang!',
                                  width: Get.width,
                                  bgcolor: const Color(0xFF92E3A9),
                                  height: 35,
                                  color: Colors.black,
                                  radius: 5,
                                  size: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.fontSize,
                                  showIcon: "right",
                                  iconRight: Icon(
                                    Icons.share,
                                    size: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.fontSize,
                                  ),
                                  onPressed: () {
                                    // ctrl.goToDetail('1');
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      const Divider(
                        color: Colors.black38,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Artikel Lainnya",
                        style: context.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      getListArtikel(ctrl, context)
                    ]))));
  }

  getListArtikel(DetailArtikelController ctrl, BuildContext context) {
    return ListView.builder(
      physics: const ClampingScrollPhysics(),
      itemCount: ctrl.listArtikels.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        // Datum model = filteredEvents[index];
        return FadeInUp(
          child: ListCardUiWidget(
            id: ctrl.listArtikels[index]['id'],
            title: ctrl.listArtikels[index]['title'],
            position: MainAxisAlignment.end,
            usingDivider: false,
            height: 170,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(ctrl.listArtikels[index]['image']),
                    fit: BoxFit.cover)),
            titleStyle: context.textTheme.titleSmall
                ?.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
            marginSeparator: 0,
            subtitleStyle: context.textTheme.labelMedium
                ?.copyWith(fontWeight: FontWeight.bold, color: Colors.black45),
            onTap: () {
              // ctrl.goToDetail(ctrl.listDoa[index]);
            },
            hasFooter: true,
            footerContent: [
              Text(
                  ctrl.listArtikels[index]['time'] +
                      '  |  ' +
                      ctrl.listArtikels[index]['date'],
                  textAlign: TextAlign.start,
                  style: context.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w300,
                      letterSpacing: 0,
                      color: Colors.white)),
              Row(
                children: [
                  Icon(
                    Icons.remove_red_eye_rounded,
                    color: Colors.white,
                    size: context.textTheme.labelLarge?.fontSize,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(ctrl.listArtikels[index]['viewer'],
                      textAlign: TextAlign.end,
                      style: context.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w300, color: Colors.white)),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(DetailArtikelController());

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBarWSWidget.getAppbarWidget(
          title: "Artiketl > Amalan", context: context, elevation: 0),
      body: layout(ctrl, context),
    );
  }
}
