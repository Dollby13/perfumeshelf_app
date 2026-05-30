import 'package:flutter/material.dart';

import '../data/sample_perfumes.dart';
import '../models/perfume.dart';
import '../theme/app_colors.dart';
import '../widgets/perfume_photo.dart';
import 'perfume_detail_page.dart';
import 'perfume_form_page.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Perfume> perfumes = samplePerfumes();

  Future<void> addPerfume() async {
    final result = await Navigator.push<Perfume>(
      context,
      MaterialPageRoute(builder: (_) => const PerfumeFormPage()),
    );

    if (result == null || !mounted) return;

    setState(() {
      perfumes.add(result);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Data parfum berhasil ditambahkan')),
    );
  }

  Future<void> openDetail(int index) async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (_) => PerfumeDetailPage(perfume: perfumes[index]),
      ),
    );

    if (result == null || !mounted) return;

    if (result['action'] == 'delete') {
      setState(() {
        perfumes.removeAt(index);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data parfum berhasil dihapus')),
      );
    }

    if (result['action'] == 'update') {
      setState(() {
        perfumes[index] = result['perfume'];
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data parfum berhasil diperbarui')),
      );
    }
  }

  void openProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ProfilePage()),
    );
  }

  Widget buildHomeContent() {
    if (perfumes.isEmpty) {
      return const Center(
        child: Text(
          'Belum ada koleksi parfum',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Koleksi Parfum Kamu',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Kelola daftar parfum pribadi secara sederhana.',
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 18),
        ...List.generate(perfumes.length, (index) {
          final perfume = perfumes[index];

          return Card(
            color: AppColors.card,
            elevation: 3,
            margin: const EdgeInsets.only(bottom: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () => openDetail(index),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    PerfumePhoto(imageUrl: perfume.imageUrl),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            perfume.namaParfum,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${perfume.merek} - ${perfume.aroma}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text('Status: ${perfume.status}'),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Icon(Icons.arrow_forward_ios, size: 16),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin PerfumeShelf'),
        actions: [
          IconButton(icon: const Icon(Icons.person), onPressed: openProfile),
        ],
      ),
      body: buildHomeContent(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        onPressed: addPerfume,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: Colors.grey,
          currentIndex: 0,
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            if (index == 1) {
              addPerfume();
            } else if (index == 2) {
              openProfile();
            }
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline),
              label: 'Tambah',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
          ],
        ),
      ),
    );
  }
}
