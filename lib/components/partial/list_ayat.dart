import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_audio/just_audio.dart';

class ListAyatWidget extends StatefulWidget {
  const ListAyatWidget({
    super.key,
    required this.id,
    this.nomor,
    this.ayat,
    this.descEN,
    this.descIDN,
    this.audioFile,
    this.onTap,
    this.activeColor,
    required this.bookmarked,
  });

  final int id;
  final String? nomor;
  final String? ayat;
  final String? descEN;
  final String? descIDN;
  final String? audioFile;
  final bool bookmarked;
  final VoidCallback? onTap;
  final Color? activeColor;

  @override
  State<ListAyatWidget> createState() => _ListAyatWidgetState();
}

class _ListAyatWidgetState extends State<ListAyatWidget> {
  bool _isPlaying = false;
  AudioPlayer? _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _audioPlayer!.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        if (mounted) setState(() => _isPlaying = false);
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer?.dispose();
    super.dispose();
  }

  Future<void> _togglePlay() async {
    if (_audioPlayer == null || widget.audioFile == null || widget.audioFile!.isEmpty) return;

    if (_isPlaying) {
      await _audioPlayer!.pause();
      if (mounted) setState(() => _isPlaying = false);
    } else {
      try {
        await _audioPlayer!.setUrl(widget.audioFile!);
        await _audioPlayer!.play();
        if (mounted) setState(() => _isPlaying = true);
      } catch (e) {
        debugPrint('Audio error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(children: [
      Container(
          width: screenWidth,
          color: const Color.fromARGB(255, 233, 233, 233),
          constraints: BoxConstraints.loose(Size.infinite),
          child: Row(
            children: [
              Container(
                width: 50,
                padding: const EdgeInsets.only(left: 15, right: 15),
                constraints: BoxConstraints.loose(Size.infinite),
                color: const Color.fromARGB(255, 233, 233, 233),
                child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 42,
                        width: 42,
                        child: Stack(
                          children: <Widget>[
                            InkWell(
                              onTap: widget.onTap,
                              child: SvgPicture.asset(
                                widget.bookmarked
                                    ? 'assets/icons/active_bookmark.svg'
                                    : 'assets/icons/bookmark.svg',
                                alignment: Alignment.center,
                                width: 28,
                                height: 28,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 42,
                        width: 42,
                        child: Stack(
                          children: <Widget>[
                            SvgPicture.asset(
                              'assets/icons/list_star.svg',
                              alignment: Alignment.center,
                              width: 42,
                              height: 42,
                            ),
                            Positioned.fill(
                              child: Center(
                                child: Text(
                                  widget.nomor ?? '',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        fontWeight: FontWeight.normal,
                                      ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 42,
                        width: 42,
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Center(
                                child: InkWell(
                                  onTap: _togglePlay,
                                  child: _isPlaying
                                      ? Icon(
                                          Icons.pause_rounded,
                                          color: Theme.of(context).primaryColor,
                                        )
                                      : Icon(
                                          Icons.play_arrow_rounded,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                  child: Container(
                padding: const EdgeInsets.all(15),
                color: Colors.white,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: AutoSizeText(
                            widget.ayat ?? '',
                            textAlign: TextAlign.end,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                            maxLines: 15,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: AutoSizeText(
                              widget.descEN ?? '',
                              textAlign: TextAlign.start,
                              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                    fontWeight: FontWeight.w300,
                                    fontStyle: FontStyle.italic,
                                  ),
                            )),
                        const SizedBox(height: 20),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: AutoSizeText(
                              widget.descIDN ?? '',
                              textAlign: TextAlign.start,
                              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                    fontWeight: FontWeight.w300,
                                  ),
                            ))
                      ],
                    )
                  ],
                ),
              ))
            ],
          )),
      const Divider(
        color: Color.fromARGB(255, 226, 226, 226),
        thickness: 3,
        height: 2,
      ),
    ]);
  }
}
