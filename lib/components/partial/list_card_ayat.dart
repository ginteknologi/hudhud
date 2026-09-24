import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_audio/just_audio.dart';

class ListCardAyatWidget extends StatefulWidget {
  const ListCardAyatWidget({
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
  State<ListCardAyatWidget> createState() => _ListCardAyatWidgetState();
}

class _ListCardAyatWidgetState extends State<ListCardAyatWidget> {
  bool _isPlaying = false;
  AudioPlayer? _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _audioPlayer!.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        if (mounted) {
          setState(() {
            _isPlaying = false;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer?.dispose();
    super.dispose();
  }

  Future<void> _toggleAudio() async {
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
        debugPrint('Audio play error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Card(
      elevation: 3,
      color: widget.activeColor ?? Colors.white,
      margin: const EdgeInsets.only(top: 20),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        width: screenWidth,
        constraints: BoxConstraints.loose(Size.infinite),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 45,
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  color: Color(0xFF92E3A9),
                  borderRadius: BorderRadius.all(Radius.circular(7)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
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
                          Column(
                            children: <Widget>[
                              Expanded(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    widget.nomor ?? '',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          fontWeight: FontWeight.normal,
                                        ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: Row(
                        children: [
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
                          const SizedBox(width: 10),
                          InkWell(
                            onTap: _toggleAudio,
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
                        ],
                      ),
                    )
                  ],
                ),
              ),
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
                    ),
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: AutoSizeText(
                      widget.descIDN ?? '',
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w300,
                          ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
