import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masjid_app/core/theme/hudhud_theme.dart';
import 'package:masjid_app/models/hadist_data.dart';

/// Bottom sheet dua tab: lompat ke nomor hadits, atau pindah kitab.
Future<void> showHaditsJumpSheet({
  required BuildContext context,
  required String namaTabel,
  required String longNama,
  required int totalHadits,
  required List<ImamData> listBooks,
  required void Function(int noHdt) onJump,
  required void Function(String namaTabel) onSelectKitab,
}) {
  final t = context.hudhud;
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => Container(
      decoration: BoxDecoration(
        color: t.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(t.radiusMd)),
      ),
      child: _HaditsJumpSheet(
        namaTabel: namaTabel,
        longNama: longNama,
        totalHadits: totalHadits,
        listBooks: listBooks,
        onJump: onJump,
        onSelectKitab: onSelectKitab,
      ),
    ),
  );
}

class _HaditsJumpSheet extends StatefulWidget {
  final String namaTabel;
  final String longNama;
  final int totalHadits;
  final List<ImamData> listBooks;
  final void Function(int noHdt) onJump;
  final void Function(String namaTabel) onSelectKitab;

  const _HaditsJumpSheet({
    required this.namaTabel,
    required this.longNama,
    required this.totalHadits,
    required this.listBooks,
    required this.onJump,
    required this.onSelectKitab,
  });

  @override
  State<_HaditsJumpSheet> createState() => _HaditsJumpSheetState();
}

class _HaditsJumpSheetState extends State<_HaditsJumpSheet> {
  int _tab = 0;
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final no = int.tryParse(_controller.text.trim());
    if (no == null || no < 1) return;
    final clamped = no > widget.totalHadits && widget.totalHadits > 0
        ? widget.totalHadits
        : no;
    Navigator.of(context).pop();
    widget.onJump(clamped);
  }

  @override
  Widget build(BuildContext context) {
    final t = context.hudhud;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Padding(
        padding: EdgeInsets.fromLTRB(t.spaceLg, t.spaceMd, t.spaceLg, t.spaceLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: t.outline,
                  borderRadius: BorderRadius.circular(t.radiusSm),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.longNama,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: t.charcoal,
                    ),
                  ),
                ),
                IconButton(
                  constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                  icon: Icon(LucideIcons.x, size: 18, color: t.muted),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildTabs(t),
            const SizedBox(height: 16),
            if (_tab == 0) ..._buildJump(t) else ..._buildKitabList(t),
          ],
        ),
      ),
    );
  }

  Widget _buildTabs(HudhudTheme t) {
    return Container(
      height: t.controlHeight,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: t.sand,
        borderRadius: BorderRadius.circular(t.radiusMd),
        border: Border.all(color: t.outline),
      ),
      child: Row(
        children: [
          _tabButton(t, 0, 'Lompat Hadits', LucideIcons.hash),
          _tabButton(t, 1, 'Ganti Kitab', LucideIcons.bookOpen),
        ],
      ),
    );
  }

  Widget _tabButton(HudhudTheme t, int index, String label, IconData icon) {
    final active = _tab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _tab = index),
        child: Container(
          decoration: BoxDecoration(
            color: active ? t.surface : Colors.transparent,
            borderRadius: BorderRadius.circular(t.radiusSm),
            boxShadow: active
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    )
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 15,
                color: active ? t.terracotta : t.muted,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 13,
                  fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                  color: active ? t.terracotta : t.muted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildJump(HudhudTheme t) {
    final total = widget.totalHadits;
    final chips = <int>{
      1,
      if (total > 2) (total / 2).round(),
      if (total > 1) total,
    }.toList()
      ..sort();

    return [
      Container(
        height: t.controlHeight,
        decoration: BoxDecoration(
          color: t.surface,
          borderRadius: BorderRadius.circular(t.radiusMd),
          border: Border.all(color: t.outline),
        ),
        child: TextField(
          controller: _controller,
          autofocus: true,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.go,
          onSubmitted: (_) => _submit(),
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 14,
            color: t.charcoal,
          ),
          decoration: InputDecoration(
            hintText: total > 0 ? 'Nomor 1–$total' : 'Nomor hadits',
            hintStyle: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 13,
              color: t.muted,
            ),
            prefixIcon: Icon(LucideIcons.search, size: 18, color: t.muted),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          ),
        ),
      ),
      const SizedBox(height: 12),
      Wrap(
        spacing: 8,
        children: [
          for (final no in chips)
            ActionChip(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(t.radiusMd),
                side: BorderSide(color: t.outline),
              ),
              backgroundColor: t.sand,
              label: Text(
                no == 1 ? 'Awal' : (no == total ? 'Akhir' : 'Tengah'),
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: t.charcoal,
                ),
              ),
              onPressed: () {
                _controller.text = '$no';
                _submit();
              },
            ),
        ],
      ),
      const SizedBox(height: 16),
      FilledButton(
        onPressed: _submit,
        style: FilledButton.styleFrom(
          minimumSize: Size(double.infinity, t.controlHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(t.radiusMd),
          ),
        ),
        child: const Text('Buka Hadits'),
      ),
    ];
  }

  List<Widget> _buildKitabList(HudhudTheme t) {
    if (widget.listBooks.isEmpty) {
      return [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Text(
            'Daftar kitab tidak tersedia',
            style: TextStyle(fontFamily: 'Roboto', fontSize: 13, color: t.muted),
          ),
        ),
      ];
    }
    return [
      ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.4,
        ),
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: widget.listBooks.length,
          separatorBuilder: (_, __) => const SizedBox(height: 6),
          itemBuilder: (_, i) {
            final book = widget.listBooks[i];
            final active = book.namaTabel == widget.namaTabel;
            return Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(t.radiusMd),
                onTap: active
                    ? null
                    : () {
                        Navigator.of(context).pop();
                        widget.onSelectKitab(book.namaTabel);
                      },
                child: Container(
                  constraints: BoxConstraints(minHeight: t.controlHeight),
                  padding: EdgeInsets.symmetric(horizontal: t.spaceMd, vertical: t.spaceSm),
                  decoration: BoxDecoration(
                    color: active ? t.sand : t.surface,
                    borderRadius: BorderRadius.circular(t.radiusMd),
                    border: Border.all(color: active ? t.terracotta : t.outline),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        LucideIcons.bookOpen,
                        size: 18,
                        color: active ? t.terracotta : t.muted,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              book.longNama,
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 13,
                                fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                                color: active ? t.terracotta : t.charcoal,
                              ),
                            ),
                            Text(
                              book.babCount > 0
                                  ? '${book.hadits} hadits · ${book.babCount} bab'
                                  : '${book.hadits} hadits',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 11,
                                color: t.muted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (active)
                        Icon(LucideIcons.check, size: 18, color: t.terracotta),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ];
  }
}
