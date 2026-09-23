import 'dart:async';
import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:masjid_app/core/network/api_endpoints.dart';
import 'package:masjid_app/models/event_count_down.dart';
import 'package:masjid_app/providers/api_providers.dart';

class CountDownWidget extends ConsumerStatefulWidget {
  const CountDownWidget({super.key});

  @override
  ConsumerState<CountDownWidget> createState() => _CountDownWidgetState();
}

class _CountDownWidgetState extends ConsumerState<CountDownWidget> {
  Timer? _timer;
  DateTime _targetDate = DateTime.parse("2025-02-28");
  EventCountDownData _eventData = EventCountDownData(
    status: false,
    title: 'Ramadhan',
    limitDate: '2025-02-28',
    description: '',
    imageUrl: 'https://nos.wjv-1.neo.id/marbot/assets/ramadhan-01.png',
  );
  List<Map<String, dynamic>> _countdownData = [];

  @override
  void initState() {
    super.initState();
    _loadEvent();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadEvent() async {
    try {
      final response = await ref.read(apiClientProvider).get<Map<String, dynamic>>(
            ApiEndpoints.event,
            fromJson: (json) =>
                json is Map ? Map<String, dynamic>.from(json) : <String, dynamic>{},
          );
      final data = response.data?['data'];
      if (data != null && data['selesai'] != null) {
        if (mounted) {
          setState(() {
            _targetDate = DateTime.tryParse(data['selesai']) ?? _targetDate;
            _eventData = EventCountDownData(
              status: true,
              description: data['keterangan'] ?? '',
              limitDate: data['selesai'] ?? '',
              title: data['judul'] ?? '',
              imageUrl: data['image'] ?? 'https://nos.wjv-1.neo.id/marbot/assets/ramadhan-01.png',
            );
          });
        }
      }
    } catch (_) {}

    _updateTimer();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateTimer());
  }

  void _updateTimer() {
    if (!mounted) return;
    final now = DateTime.now();
    final remaining = _targetDate.difference(now);

    setState(() {
      _countdownData = [
        {'value': remaining.inDays > 0 ? remaining.inDays : 0, 'label': 'Hari'},
        {'value': remaining.inHours > 0 ? (remaining.inHours % 24) : 0, 'label': 'Jam'},
        {'value': remaining.inMinutes > 0 ? (remaining.inMinutes % 60) : 0, 'label': 'Menit'},
        {'value': remaining.inSeconds > 0 ? (remaining.inSeconds % 60) : 0, 'label': 'Detik'},
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_eventData.status) return const SizedBox();

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: CachedNetworkImageProvider(_eventData.imageUrl),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(screenWidth / 50),
      ),
      width: screenWidth,
      height: screenHeight / 4,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AutoSizeText(
              _eventData.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: screenWidth / 17,
                letterSpacing: 0.5,
                fontFamily: GoogleFonts.katibeh().fontFamily,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                for (int i = 0; i < _countdownData.length; i++)
                  Row(
                    children: [
                      SizedBox(width: screenWidth / 80),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(screenWidth / 50),
                          border: Border.all(
                            width: 0.5,
                            color: const Color.fromRGBO(177, 116, 62, 1),
                          ),
                          gradient: const LinearGradient(
                            begin: Alignment(0, 1),
                            end: Alignment(-1, 0),
                            colors: [
                              Color.fromRGBO(177, 116, 62, 0.3),
                              Color.fromRGBO(215, 163, 92, 0.3),
                            ],
                          ),
                        ),
                        width: screenWidth / 5.5,
                        height: screenWidth / 5.5,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(screenWidth / 50),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                AutoSizeText(
                                  '${_countdownData[i]['value']}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: screenWidth / 9,
                                    fontFamily: GoogleFonts.katibeh().fontFamily,
                                  ),
                                ),
                                Positioned(
                                  bottom: screenWidth / 80,
                                  child: AutoSizeText(
                                    '${_countdownData[i]['label']}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: screenWidth / 25,
                                      fontFamily: GoogleFonts.katibeh().fontFamily,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: screenWidth / 80),
                    ],
                  )
              ],
            ),
            SizedBox(height: screenHeight / 80),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth / 10),
              child: AutoSizeText(
                _eventData.description,
                textAlign: TextAlign.center,
                maxLines: 2,
                presetFontSizes: const [9],
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
