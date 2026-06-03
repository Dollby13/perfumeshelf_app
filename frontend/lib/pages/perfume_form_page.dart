import 'package:flutter/material.dart';

import '../models/perfume.dart';
import '../theme/app_colors.dart';

class PerfumeFormPage extends StatefulWidget {
  final Perfume? perfume;

  const PerfumeFormPage({super.key, this.perfume});

  @override
  State<PerfumeFormPage> createState() => _PerfumeFormPageState();
}

class _PerfumeFormPageState extends State<PerfumeFormPage> {
  static const ukuranOptions = [
    'Travel Size - 10ml',
    'Daily Carry - 30ml',
    'Compact Bottle - 50ml',
    'Standard Shelf - 75ml',
    'Full Bottle - 100ml',
    'Collector Size - 125ml',
  ];

  static const konsentrasiOptions = [
    'Body Mist - ringan',
    'EDC - segar',
    'EDT - harian',
    'EDP - tahan lama',
    'Extrait - intens',
  ];

  static const statusOptions = [
    'Guest Preview',
    'Tersedia',
    'Favorit Admin',
    'Rekomendasi',
    'Stok Terbatas',
    'Disembunyikan',
  ];

  final namaController = TextEditingController();
  final merekController = TextEditingController();
  final aromaController = TextEditingController();
  final ukuranController = TextEditingController();
  final konsentrasiController = TextEditingController();
  final statusController = TextEditingController();
  final catatanController = TextEditingController();
  final imageUrlController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.perfume != null) {
      namaController.text = widget.perfume!.namaParfum;
      merekController.text = widget.perfume!.merek;
      aromaController.text = widget.perfume!.aroma;
      ukuranController.text = widget.perfume!.ukuran;
      konsentrasiController.text = widget.perfume!.konsentrasi;
      statusController.text = widget.perfume!.status;
      catatanController.text = widget.perfume!.catatan;
      imageUrlController.text = widget.perfume!.imageUrl;
    } else {
      statusController.text = statusOptions.first;
    }
  }

  @override
  void dispose() {
    namaController.dispose();
    merekController.dispose();
    aromaController.dispose();
    ukuranController.dispose();
    konsentrasiController.dispose();
    statusController.dispose();
    catatanController.dispose();
    imageUrlController.dispose();
    super.dispose();
  }

  void saveData() {
    if (namaController.text.isEmpty ||
        merekController.text.isEmpty ||
        aromaController.text.isEmpty ||
        ukuranController.text.isEmpty ||
        konsentrasiController.text.isEmpty ||
        statusController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap isi semua data wajib')),
      );
      return;
    }

    final perfume = Perfume(
      id: widget.perfume?.id,
      namaParfum: namaController.text,
      merek: merekController.text,
      aroma: aromaController.text,
      ukuran: ukuranController.text,
      konsentrasi: konsentrasiController.text,
      status: statusController.text,
      catatan: catatanController.text,
      imageUrl: imageUrlController.text,
    );

    Navigator.pop(context, perfume);
  }

  Widget inputField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
      ),
    );
  }

  Widget optionSection({
    required String title,
    required IconData icon,
    required TextEditingController controller,
    required List<String> options,
  }) {
    final selectedText = controller.text.isEmpty
        ? 'Pilih $title'
        : controller.text;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => showOptionPicker(
          title: title,
          icon: icon,
          controller: controller,
          options: options,
        ),
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: title,
            prefixIcon: Icon(icon),
            suffixIcon: const Icon(Icons.keyboard_arrow_down),
          ),
          child: Text(
            selectedText,
            style: TextStyle(
              fontSize: 16,
              color: controller.text.isEmpty
                  ? AppColors.textMuted
                  : AppColors.textDark,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  void showOptionPicker({
    required String title,
    required IconData icon,
    required TextEditingController controller,
    required List<String> options,
  }) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(icon, color: AppColors.primary),
                    const SizedBox(width: 10),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        color: AppColors.textDark,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: options.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1, color: AppColors.border),
                    itemBuilder: (context, index) {
                      final option = options[index];
                      final selected = controller.text == option;

                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          option,
                          style: TextStyle(
                            fontWeight: selected
                                ? FontWeight.w800
                                : FontWeight.w500,
                            color: selected
                                ? AppColors.primary
                                : AppColors.textDark,
                          ),
                        ),
                        trailing: selected
                            ? const Icon(
                                Icons.check_circle,
                                color: AppColors.accent,
                              )
                            : null,
                        onTap: () {
                          setState(() => controller.text = option);
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.perfume != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Parfum' : 'Tambah Parfum')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 620),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Text(
                'Data Parfum',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Isi informasi parfum dengan lengkap.',
                style: TextStyle(color: AppColors.textMuted),
              ),
              const SizedBox(height: 20),
              inputField(
                label: 'Nama Parfum',
                controller: namaController,
                icon: Icons.spa,
              ),
              inputField(
                label: 'Merek',
                controller: merekController,
                icon: Icons.label,
              ),
              inputField(
                label: 'Aroma',
                controller: aromaController,
                icon: Icons.air,
              ),
              optionSection(
                title: 'Ukuran untuk katalog',
                icon: Icons.local_drink,
                controller: ukuranController,
                options: ukuranOptions,
              ),
              optionSection(
                title: 'Konsentrasi parfum',
                icon: Icons.science,
                controller: konsentrasiController,
                options: konsentrasiOptions,
              ),
              optionSection(
                title: 'Status tampilan admin',
                icon: Icons.verified,
                controller: statusController,
                options: statusOptions,
              ),
              inputField(
                label: 'Catatan',
                controller: catatanController,
                icon: Icons.note,
                maxLines: 3,
              ),
              inputField(
                label: 'URL Gambar',
                controller: imageUrlController,
                icon: Icons.image,
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: saveData,
                  child: Text(isEdit ? 'Update' : 'Simpan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
