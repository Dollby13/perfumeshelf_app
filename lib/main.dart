import 'package:flutter/material.dart';

void main() {
  runApp(const PerfumeShelfApp());
}

class AppColors {
  static const primary = Color(0xFF6D4C41);
  static const secondary = Color(0xFFD7B56D);
  static const background = Color(0xFFF8F3EC);
  static const card = Colors.white;
  static const textDark = Color(0xFF2B2B2B);
  static const danger = Color(0xFFD32F2F);
}

class Perfume {
  String namaParfum;
  String merek;
  String aroma;
  String ukuran;
  String konsentrasi;
  String status;
  String catatan;

  Perfume({
    required this.namaParfum,
    required this.merek,
    required this.aroma,
    required this.ukuran,
    required this.konsentrasi,
    required this.status,
    required this.catatan,
  });
}

class PerfumeShelfApp extends StatelessWidget {
  const PerfumeShelfApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PerfumeShelf',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ),
      home: const SplashPage(),
    );
  }
}

// ================= SPLASH PAGE =================

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.spa, size: 90, color: Colors.white),
            SizedBox(height: 20),
            Text(
              'PerfumeShelf',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Koleksi Parfum Pribadi',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            SizedBox(height: 35),
            CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}

// ================= LOGIN PAGE =================

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Icon(Icons.spa, size: 90, color: AppColors.primary),
                  const SizedBox(height: 20),
                  const Text(
                    'PerfumeShelf',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Masuk ke akun kamu',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 32),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      hintText: 'Email',
                      prefixIcon: Icon(Icons.email),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const HomePage()),
                        );
                      },
                      child: const Text('Login'),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const RegisterPage()),
                      );
                    },
                    child: const Text(
                      'Belum punya akun? Register',
                      style: TextStyle(color: AppColors.primary),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ================= REGISTER PAGE =================

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: ListView(
            children: [
              const Text(
                'Buat Akun Baru',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Daftar untuk mulai mencatat koleksi parfum kamu.',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 28),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  hintText: 'Nama lengkap',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  hintText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Register berhasil. Silakan login.'),
                      ),
                    );
                    Navigator.pop(context);
                  },
                  child: const Text('Register'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ================= HOME PAGE =================

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Perfume> perfumes = [
    Perfume(
      namaParfum: 'Dior Sauvage',
      merek: 'Dior',
      aroma: 'Fresh Spicy',
      ukuran: '100ml',
      konsentrasi: 'EDT',
      status: 'Favorit',
      catatan: 'Cocok digunakan untuk acara malam dan kegiatan outdoor.',
    ),
    Perfume(
      namaParfum: 'Bleu de Chanel',
      merek: 'Chanel',
      aroma: 'Woody Aromatic',
      ukuran: '100ml',
      konsentrasi: 'EDP',
      status: 'Sering Dipakai',
      catatan: 'Aromanya elegan, clean, dan tahan lama.',
    ),
    Perfume(
      namaParfum: 'YSL Y',
      merek: 'Yves Saint Laurent',
      aroma: 'Fresh Aromatic',
      ukuran: '60ml',
      konsentrasi: 'EDP',
      status: 'Casual',
      catatan: 'Cocok untuk pemakaian harian.',
    ),
  ];

  Future<void> addPerfume() async {
    final result = await Navigator.push<Perfume>(
      context,
      MaterialPageRoute(builder: (_) => const PerfumeFormPage()),
    );

    if (result != null) {
      setState(() {
        perfumes.add(result);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data parfum berhasil ditambahkan')),
      );
    }
  }

  Future<void> openDetail(int index) async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (_) => PerfumeDetailPage(
          perfume: perfumes[index],
        ),
      ),
    );

    if (result == null) return;

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
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: const CircleAvatar(
                backgroundColor: AppColors.secondary,
                child: Icon(Icons.spa, color: Colors.white),
              ),
              title: Text(
                perfume.namaParfum,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  '${perfume.merek} • ${perfume.aroma}\nStatus: ${perfume.status}',
                ),
              ),
              isThreeLine: true,
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => openDetail(index),
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
        title: const Text('PerfumeShelf'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: openProfile,
          ),
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
            if (index == 0) {
              // Tetap di Home
            } else if (index == 1) {
              addPerfume();
            } else if (index == 2) {
              openProfile();
            }
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline),
              label: 'Tambah',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}

// ================= DETAIL PAGE =================

class PerfumeDetailPage extends StatelessWidget {
  final Perfume perfume;

  const PerfumeDetailPage({
    super.key,
    required this.perfume,
  });

  Future<void> editPerfume(BuildContext context) async {
    final updatedPerfume = await Navigator.push<Perfume>(
      context,
      MaterialPageRoute(
        builder: (_) => PerfumeFormPage(perfume: perfume),
      ),
    );

    if (updatedPerfume != null) {
      Navigator.pop(context, {
        'action': 'update',
        'perfume': updatedPerfume,
      });
    }
  }

  void confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hapus Parfum'),
        content: const Text(
          'Apakah kamu yakin ingin menghapus data parfum ini?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context, {'action': 'delete'});
            },
            child: const Text(
              'Hapus',
              style: TextStyle(color: AppColors.danger),
            ),
          ),
        ],
      ),
    );
  }

  Widget detailItem(String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Parfum'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Card(
          color: Colors.white,
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: ListView(
              children: [
                const Center(
                  child: Icon(
                    Icons.spa,
                    size: 85,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 20),
                detailItem('Nama Parfum', perfume.namaParfum),
                detailItem('Merek', perfume.merek),
                detailItem('Aroma', perfume.aroma),
                detailItem('Ukuran', perfume.ukuran),
                detailItem('Konsentrasi', perfume.konsentrasi),
                detailItem('Status', perfume.status),
                detailItem('Catatan', perfume.catatan),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => editPerfume(context),
                        icon: const Icon(Icons.edit),
                        label: const Text('Edit'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.danger,
                        ),
                        onPressed: () => confirmDelete(context),
                        icon: const Icon(Icons.delete),
                        label: const Text('Hapus'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ================= FORM TAMBAH / EDIT PARFUM =================

class PerfumeFormPage extends StatefulWidget {
  final Perfume? perfume;

  const PerfumeFormPage({
    super.key,
    this.perfume,
  });

  @override
  State<PerfumeFormPage> createState() => _PerfumeFormPageState();
}

class _PerfumeFormPageState extends State<PerfumeFormPage> {
  final namaController = TextEditingController();
  final merekController = TextEditingController();
  final aromaController = TextEditingController();
  final ukuranController = TextEditingController();
  final konsentrasiController = TextEditingController();
  final statusController = TextEditingController();
  final catatanController = TextEditingController();

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
      namaParfum: namaController.text,
      merek: merekController.text,
      aroma: aromaController.text,
      ukuran: ukuranController.text,
      konsentrasi: konsentrasiController.text,
      status: statusController.text,
      catatan: catatanController.text,
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
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.perfume != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Parfum' : 'Tambah Parfum'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const Text(
              'Data Parfum',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Isi informasi parfum dengan lengkap.',
              style: TextStyle(color: Colors.grey),
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
            inputField(
              label: 'Ukuran',
              controller: ukuranController,
              icon: Icons.local_drink,
            ),
            inputField(
              label: 'Konsentrasi',
              controller: konsentrasiController,
              icon: Icons.science,
            ),
            inputField(
              label: 'Status',
              controller: statusController,
              icon: Icons.favorite,
            ),
            inputField(
              label: 'Catatan',
              controller: catatanController,
              icon: Icons.note,
              maxLines: 3,
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
    );
  }
}

// ================= PROFILE PAGE =================

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController(text: 'User PerfumeShelf');
    final phoneController = TextEditingController(text: '081234567890');
    final bioController = TextEditingController(
      text: 'Pecinta parfum dengan aroma fresh, woody, dan clean.',
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const Center(
              child: CircleAvatar(
                radius: 48,
                backgroundColor: AppColors.primary,
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 58,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Nama'),
            const SizedBox(height: 8),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Email'),
            const SizedBox(height: 8),
            const TextField(
              enabled: false,
              decoration: InputDecoration(
                hintText: 'user@email.com',
                prefixIcon: Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Nomor Telepon'),
            const SizedBox(height: 8),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.phone),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Bio'),
            const SizedBox(height: 8),
            TextField(
              controller: bioController,
              maxLines: 3,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.info),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Profil berhasil diperbarui')),
                  );
                },
                child: const Text('Simpan Perubahan'),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.danger,
                  side: const BorderSide(color: AppColors.danger),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                    (route) => false,
                  );
                },
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}