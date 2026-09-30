import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masjid_app/core/theme/hudhud_theme.dart';
import 'package:masjid_app/providers/akun_provider.dart';
import 'package:masjid_app/providers/auth_provider.dart';

class EditAkunPage extends ConsumerStatefulWidget {
  const EditAkunPage({super.key});

  @override
  ConsumerState<EditAkunPage> createState() => _EditAkunPageState();
}

class _EditAkunPageState extends ConsumerState<EditAkunPage> {
  final txtController = TextEditingController();
  final phoneController = TextEditingController();
  final picker = ImagePicker();

  File? newFile;
  String fileName = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(authNotifierProvider).valueOrNull;
    txtController.text = user?.name ?? '';
    phoneController.text = AkunRepository.savedPhone;
  }

  @override
  void dispose() {
    txtController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
      maxWidth: 1000,
    );
    if (image == null || !mounted) return;
    setState(() {
      newFile = File(image.path);
      fileName = image.name;
    });
  }

  Future<void> _save() async {
    if (isLoading) return;
    final name = txtController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama tidak boleh kosong')),
      );
      return;
    }

    setState(() => isLoading = true);
    final ok = await ref.read(akunRepositoryProvider).simpanProfile(
          nama: name,
          phone: phoneController.text.trim(),
          newFile: newFile,
          fileName: fileName,
        );
    if (!mounted) return;
    setState(() => isLoading = false);
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil berhasil diperbarui')),
      );
      context.pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menyimpan profil')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.hudhud;
    final photo = ref.watch(authNotifierProvider).valueOrNull?.photo ?? '';
    ImageProvider? image;
    if (newFile != null) {
      image = FileImage(newFile!);
    } else if (photo.isNotEmpty) {
      image = NetworkImage(photo);
    }

    return Scaffold(
      backgroundColor: t.sand,
      appBar: AppBar(
        title: const Text('Edit Profil'),
        leading: IconButton(
          tooltip: 'Kembali',
          constraints: const BoxConstraints.tightFor(width: 48, height: 48),
          onPressed: () => context.pop(),
          icon: const Icon(LucideIcons.arrowLeft),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(t.spaceLg, t.spaceMd, t.spaceLg, t.spaceXl),
        children: [
          Center(
            child: Semantics(
              button: true,
              label: 'Ubah foto profil',
              child: InkWell(
                onTap: _pickPhoto,
                customBorder: const CircleBorder(),
                child: SizedBox(
                  width: 108,
                  height: 108,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 54,
                        backgroundColor: t.terracotta.withValues(alpha: .12),
                        backgroundImage: image,
                        child: image == null
                            ? Icon(LucideIcons.userRound,
                                size: 44, color: t.terracotta)
                            : null,
                      ),
                      Positioned(
                        right: 2,
                        bottom: 2,
                        child: Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: t.terracotta,
                            shape: BoxShape.circle,
                            border: Border.all(color: t.surface, width: 2.5),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: .15),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(LucideIcons.camera,
                              color: Colors.white, size: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: t.spaceXl),
          _field(
            context,
            label: 'Nama Lengkap',
            hint: 'Masukkan nama Anda',
            controller: txtController,
            keyboardType: TextInputType.name,
          ),
          SizedBox(height: t.spaceMd),
          _field(
            context,
            label: 'Nomor Handphone',
            hint: '08xxxxxxxxxx',
            controller: phoneController,
            keyboardType: TextInputType.phone,
          ),
          SizedBox(height: t.spaceXl),
          FilledButton.icon(
            onPressed: isLoading ? null : _save,
            style: FilledButton.styleFrom(
              minimumSize: Size(double.infinity, t.controlHeight),
              backgroundColor: t.terracotta,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(t.radiusMd)),
            ),
            icon: isLoading
                ? const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(LucideIcons.save, size: 18),
            label: Text(isLoading ? 'Menyimpan...' : 'Simpan Perubahan'),
          ),
        ],
      ),
    );
  }

  Widget _field(
    BuildContext context, {
    required String label,
    required String hint,
    required TextEditingController controller,
    required TextInputType keyboardType,
  }) {
    final t = context.hudhud;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: t.spaceXs),
          child: Text(
            label,
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(fontWeight: FontWeight.w600, color: t.charcoal),
          ),
        ),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          textInputAction: TextInputAction.next,
          style: TextStyle(color: t.charcoal, fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: t.muted, fontSize: 14),
            filled: true,
            fillColor: t.surface,
            contentPadding:
                EdgeInsets.symmetric(horizontal: t.spaceMd, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(t.radiusMd),
              borderSide: BorderSide(color: t.outline),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(t.radiusMd),
              borderSide: BorderSide(color: t.outline),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(t.radiusMd),
              borderSide: BorderSide(color: t.terracotta, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
