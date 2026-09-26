import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:masjid_app/models/hadist_data.dart';

/// Bottom sheet dua tab: lompat ke nomor hadits, atau pindah kitab.
///
/// Dipakai reader hadits lewat ikon filter di header.
Future<void> showHaditsJumpSheet({
  required BuildContext context,
  required String namaTabel,
  required String longNama,
  required int totalHadits,
  required List<ImamData> listBooks,
  required void Function(int noHdt) onJump,
  required void Function(String namaTabel) onSelectKitab,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _HaditsJumpSheet(
      namaTabel: namaTabel,
      longNama: longNama,
      totalHadits: totalHadits,
      listBooks: listBooks,
      onJump: onJump,
      onSelectKitab: onSelectKitab,
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
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFD8E3E0),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.longNama,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF137065),
              ),
            ),
            const SizedBox(height: 12),
            _buildTabs(),
            const SizedBox(height: 16),
            if (_tab == 0) ..._buildJump() else ..._buildKitabList(),
          ],
        ),
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F5F3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _tabButton(0, 'Lompat Hadits', Icons.tag_rounded),
          _tabButton(1, 'Ganti Kitab', Icons.menu_book_rounded),
        ],
      ),
    );
  }

  Widget _tabButton(int index, String label, IconData icon) {
    final active = _tab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _tab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            color: active ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 15,
                color: active ? const Color(0xFF048C7C) : Colors.black45,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: active ? FontWeight.w600 : FontWeight.w500,
                  color: active ? const Color(0xFF048C7C) : Colors.black45,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildJump() {
    final total = widget.totalHadits;
    final chips = <int>{
      1,
      if (total > 2) (total / 2).round(),
      if (total > 1) total,
    }.toList()
      ..sort();

    return [
      TextField(
        controller: _controller,
        autofocus: true,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.go,
        onSubmitted: (_) => _submit(),
        decoration: InputDecoration(
          hintText: total > 0 ? 'Nomor 1–$total' : 'Nomor hadits',
          hintStyle: GoogleFonts.poppins(fontSize: 13, color: Colors.black38),
          prefixIcon: const Icon(Icons.search_rounded, size: 20),
          filled: true,
          fillColor: const Color(0xFFF8FAF9),
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE2EBE8)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE2EBE8)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF048C7C)),
          ),
        ),
        style: GoogleFonts.poppins(fontSize: 14),
      ),
      const SizedBox(height: 12),
      Wrap(
        spacing: 8,
        children: [
          for (final no in chips)
            ActionChip(
              label: Text(
                no == 1 ? 'Awal' : (no == total ? 'Akhir' : 'Tengah'),
                style: GoogleFonts.poppins(fontSize: 11),
              ),
              backgroundColor: const Color(0xFFEAF5F2),
              side: BorderSide.none,
              onPressed: () {
                _controller.text = '$no';
                _submit();
              },
            ),
        ],
      ),
      const SizedBox(height: 16),
      SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF048C7C),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 13),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            'Buka Hadits',
            style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    ];
  }

  List<Widget> _buildKitabList() {
    if (widget.listBooks.isEmpty) {
      return [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Text(
            'Daftar kitab tidak tersedia',
            style: GoogleFonts.poppins(fontSize: 13, color: Colors.black45),
          ),
        ),
      ];
    }
    return [
      Flexible(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: widget.listBooks.length,
          itemBuilder: (_, i) {
            final book = widget.listBooks[i];
            final active = book.namaTabel == widget.namaTabel;
            return ListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              leading: Icon(
                Icons.menu_book_rounded,
                size: 20,
                color: active ? const Color(0xFF048C7C) : Colors.black38,
              ),
              title: Text(
                book.longNama,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: active ? FontWeight.w600 : FontWeight.w500,
                  color: active ? const Color(0xFF048C7C) : Colors.black87,
                ),
              ),
              subtitle: Text(
                book.babCount > 0
                    ? '${book.hadits} hadits · ${book.babCount} bab'
                    : '${book.hadits} hadits',
                style: GoogleFonts.poppins(fontSize: 10, color: Colors.black45),
              ),
              trailing: active
                  ? const Icon(Icons.check_rounded,
                      size: 18, color: Color(0xFF048C7C))
                  : null,
              onTap: active
                  ? null
                  : () {
                      Navigator.of(context).pop();
                      widget.onSelectKitab(book.namaTabel);
                    },
            );
          },
        ),
      ),
    ];
  }
}
