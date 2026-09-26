import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';

class MuazinDoaModal extends StatefulWidget {
  const MuazinDoaModal({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const MuazinDoaModal(),
    );
  }

  @override
  State<MuazinDoaModal> createState() => _MuazinDoaModalState();
}

class _MuazinDoaModalState extends State<MuazinDoaModal>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  static const String _doaArab =
      'اللَّهُمَّ رَبَّ هَذِهِ الدَّعْوَةِ التَّامَّةِ، وَالصَّلَاةِ الْقَائِمَةِ، آتِ مُحَمَّدًا الْوَسِيلَةَ وَالْفَضِيلَةَ، وَابْعَثْهُ مَقَامًا مَحْمُودًا الَّذِي وَعَدْتَهُ';

  static const String _doaLatin =
      'Allāhumma rabba hāżihid-da‘watit-tāmmati, waṣ-ṣalātil-qā’imah, āti Muḥammadanil-wasīlata wal-faḍīlah, wab‘aṡhu maqāmam maḥmūdanil-lażī wa‘adtah.';

  static const String _doaArti =
      'Ya Allah, Tuhan pemilik seruan yang sempurna ini dan shalat yang akan didirikan, berikanlah kepada Nabi Muhammad wasilah dan keutamaan, serta tempatkanlah beliau pada kedudukan terpuji yang telah Engkau janjikan.';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _copyDoa() {
    final text = '$_doaArab\n\n$_doaLatin\n\nArtinya:\n"$_doaArti"\n(HR. Bukhari)';
    Clipboard.setData(ClipboardData(text: text));
    Fluttertoast.showToast(
      msg: 'Doa berhasil disalin ke papan klip',
      backgroundColor: const Color(0xFF137065),
      textColor: Colors.white,
    );
  }

  void _shareDoa() {
    final text =
        'Doa Setelah Adzan:\n\n$_doaArab\n\n$_doaLatin\n\nArtinya:\n"$_doaArti"\n\n(HR. Bukhari no. 614)\nDibagikan via Aplikasi Marbot';
    SharePlus.instance.share(ShareParams(text: text));
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.82;

    return Container(
      height: height,
      decoration: const BoxDecoration(
        color: Color(0xFFF8FAF9),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Drag handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFD1DBD7),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 12, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Panduan & Doa Muadzin',
                      style: GoogleFonts.poppins(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF137065),
                      ),
                    ),
                    Text(
                      'Doa setelah adzan, adab muadzin & lafal',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded, color: Colors.black54),
                  tooltip: 'Tutup',
                ),
              ],
            ),
          ),

          // TabBar
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F0EC),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                color: const Color(0xFF048C7C),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF048C7C).withValues(alpha: 0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              labelColor: Colors.white,
              unselectedLabelColor: const Color(0xFF5A726B),
              labelStyle: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              tabs: const [
                Tab(text: 'Doa Adzan'),
                Tab(text: 'Adab Muadzin'),
                Tab(text: 'Lafal Adzan'),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildDoaTab(),
                _buildAdabTab(),
                _buildLafalTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoaTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Keutamaan Banner
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFEBF7F5),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFBCE3DC)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.stars_rounded,
                  color: Color(0xFF048C7C),
                  size: 22,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Keutamaan Membaca Doa Setelah Adzan',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF137065),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Barangsiapa membaca doa ini setelah adzan, maka halal baginya syafaat Nabi Muhammad SAW pada hari kiamat. (HR. Bukhari)',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: const Color(0xFF2C554E),
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Doa Card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFE2EBE8)),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF048C7C).withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5F3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Lafadz Doa',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF048C7C),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: _copyDoa,
                          icon: const Icon(Icons.copy_rounded, size: 18),
                          color: const Color(0xFF048C7C),
                          tooltip: 'Salin Doa',
                          visualDensity: VisualDensity.compact,
                        ),
                        IconButton(
                          onPressed: _shareDoa,
                          icon: const Icon(Icons.share_rounded, size: 18),
                          color: const Color(0xFF048C7C),
                          tooltip: 'Bagikan Doa',
                          visualDensity: VisualDensity.compact,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Teks Arab
                Text(
                  _doaArab,
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  style: GoogleFonts.amiri(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    height: 2.0,
                    color: const Color(0xFF137065),
                  ),
                ),
                const SizedBox(height: 16),

                const Divider(color: Color(0xFFEAEFEA)),
                const SizedBox(height: 10),

                // Latin
                Text(
                  'Transliterasi Latin:',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _doaLatin,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: const Color(0xFF374151),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 14),

                // Terjemahan
                Text(
                  'Artinya:',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _doaArti,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: const Color(0xFF4B5563),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdabTab() {
    final adabs = [
      {
        'title': 'Ikhlas Semata Karena Allah',
        'desc':
            'Mengumandangkan adzan murni mengharap ridha dan pahala dari Allah SWT tanpa pamrih keduniaan.',
        'icon': Icons.favorite_rounded,
      },
      {
        'title': 'Suci dari Hadats (Berwudhu)',
        'desc':
            'Disunnahkan dalam keadaan berwudhu dan suci dari hadats kecil maupun besar sebelum adzan.',
        'icon': Icons.water_drop_rounded,
      },
      {
        'title': 'Menghadap ke Arah Kiblat',
        'desc':
            'Berdiri menghadap kiblat dengan tegak saat mengumandangkan adzan, serta menolehkan kepala ke kanan saat Hayya \'alas-Shalah dan ke kiri saat Hayya \'alal-Falah.',
        'icon': Icons.explore_rounded,
      },
      {
        'title': 'Melantunkan Tartil & Suara Jelas',
        'desc':
            'Menyuarakan adzan dengan tenang, jelas, lantang, dan lagu yang khusyuk agar panggilan shalat terdengar indah dan menggugah hati umat.',
        'icon': Icons.volume_up_rounded,
      },
      {
        'title': 'Berdoa Antara Adzan & Iqamah',
        'desc':
            'Waktu antara adzan dan iqamah adalah salah satu waktu paling mustajab untuk berdoa kepada Allah SWT. (HR. Abu Dawud & Tirmidzi)',
        'icon': Icons.access_time_filled_rounded,
      },
    ];

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 24),
      itemCount: adabs.length,
      itemBuilder: (context, index) {
        final item = adabs[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2EBE8)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF048C7C).withValues(alpha: 0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5F3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  item['icon'] as IconData,
                  color: const Color(0xFF048C7C),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${index + 1}. ${item['title']}',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF137065),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      item['desc'] as String,
                      style: GoogleFonts.poppins(
                        fontSize: 11.5,
                        color: Colors.black87,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLafalTab() {
    final lafadzList = [
      {'arab': 'اللهُ أَكْبَرُ اللهُ أَكْبَرُ', 'arti': 'Allah Maha Besar, Allah Maha Besar (2x)', 'times': '2x'},
      {'arab': 'أَشْهَدُ أَنْ لاَ إِلَهَ إِلاَّ اللهُ', 'arti': 'Aku bersaksi tiada tuhan selain Allah (2x)', 'times': '2x'},
      {'arab': 'أَشْهَدُ أَنَّ مُحَمَّدًا رَسُولُ اللهِ', 'arti': 'Aku bersaksi bahwa Muhammad adalah utusan Allah (2x)', 'times': '2x'},
      {'arab': 'حَيَّ عَلَى الصَّلاَةِ', 'arti': 'Marilah mendirikan shalat (2x)', 'times': '2x'},
      {'arab': 'حَيَّ عَلَى الْفَلاَحِ', 'arti': 'Marilah menuju kemenangan (2x)', 'times': '2x'},
      {
        'arab': 'الصَّلاَةُ خَيْرٌ مِنَ النَّوْمِ',
        'arti': 'Shalat itu lebih baik daripada tidur (Khusus Adzan Subuh, 2x)',
        'times': 'Subuh'
      },
      {'arab': 'اللهُ أَكْبَرُ اللهُ أَكْبَرُ', 'arti': 'Allah Maha Besar, Allah Maha Besar (1x)', 'times': '1x'},
      {'arab': 'لاَ إِلَهَ إِلاَّ اللهُ', 'arti': 'Tiada tuhan selain Allah (1x)', 'times': '1x'},
    ];

    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 24),
      itemCount: lafadzList.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final item = lafadzList[index];
        final isSubuh = item['times'] == 'Subuh';

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: isSubuh ? const Color(0xFFFBF7EE) : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSubuh ? const Color(0xFFE9C579) : const Color(0xFFE2EBE8),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2.5,
                    ),
                    decoration: BoxDecoration(
                      color: isSubuh
                          ? const Color(0xFFF7E6B8)
                          : const Color(0xFFE8F5F3),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      item['times']!,
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: isSubuh
                            ? const Color(0xFF8B6406)
                            : const Color(0xFF048C7C),
                      ),
                    ),
                  ),
                  Text(
                    item['arab']!,
                    textDirection: TextDirection.rtl,
                    style: GoogleFonts.amiri(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF137065),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                item['arti']!,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
