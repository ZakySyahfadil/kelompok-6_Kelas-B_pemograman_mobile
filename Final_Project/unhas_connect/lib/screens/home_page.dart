import 'package:flutter/material.dart';
import '../data/dummy_posts.dart';
import '../models/post.dart';
import '../theme/app_colors.dart';
import '../widgets/post_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const _categories = [
    'Untukmu',
    'Terbaru',
    'Akademik',
    'Event',
    'Organisasi',
    'Jual Beli',
    'Lost & Found',
  ];

  String _selected = 'Untukmu';

  // Nanti diganti dengan data dari Firestore
  List<Post> get _posts {
    switch (_selected) {
      case 'Untukmu':
        return dummyPosts;
      case 'Terbaru':
        return [...dummyPosts]
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      default:
        return dummyPosts.where((p) => p.category == _selected).toList();
    }
  }

  void _showSoon(String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _refresh() async {
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final posts = _posts;

    return Scaffold(
      // ===== AppBar: logo + judul + menu titik tiga =====
      appBar: AppBar(
        toolbarHeight: 68,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        titleSpacing: 16,
        title: Row(
          children: [
            // Ganti dengan Image.asset('assets/logo.png') kalau sudah ada logo
            const Icon(Icons.local_florist, color: unhasMaroon, size: 38),
            const SizedBox(width: 12),
            Container(width: 1.5, height: 38, color: unhasMaroon),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'UNHAS',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    height: 1.1,
                    color: Color(0xFF2B1B3D),
                  ),
                ),
                Text(
                  'CONNECT',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    height: 1.1,
                    color: unhasMaroon,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) => _showSoon('$value belum dibuat'),
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'Pengaturan', child: Text('Pengaturan')),
            ],
          ),
          const SizedBox(width: 4),
        ],
      ),

      // ===== Body: chip kategori + feed =====
      body: Column(
        children: [
          const SizedBox(height: 8),
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final category = _categories[i];
                final selected = category == _selected;
                return ChoiceChip(
                  label: Text(category),
                  selected: selected,
                  showCheckmark: false,
                  selectedColor: unhasMaroon,
                  backgroundColor: const Color(0xFFEFEFF2),
                  side: BorderSide.none,
                  shape: const StadiumBorder(),
                  labelStyle: TextStyle(
                    color: selected ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                  onSelected: (_) => setState(() => _selected = category),
                );
              },
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              color: unhasMaroon,
              onRefresh: _refresh,
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
                itemCount: posts.isEmpty ? 2 : posts.length + 1,
                itemBuilder: (context, i) {
                  // Item pertama: kotak "Apa yang ingin kamu bagikan?"
                  if (i == 0) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _PostComposer(
                        onTap: () => _showSoon('Buat postingan belum dibuat'),
                      ),
                    );
                  }
                  if (posts.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.only(top: 48),
                      child: Center(
                        child: Text('Belum ada postingan di kategori ini'),
                      ),
                    );
                  }
                  final post = posts[i - 1];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: PostCard(key: ValueKey(post.id), post: post),
                  );
                },
              ),
            ),
          ),
        ],
      ),

      // ===== Tombol tambah postingan =====
      floatingActionButton: FloatingActionButton(
        backgroundColor: unhasMaroon,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        onPressed: () => _showSoon('Buat postingan belum dibuat'),
        child: const Icon(Icons.add, size: 32),
      ),

      // ===== Navbar bawah: Beranda | Explore | Profil =====
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        indicatorColor: const Color(0xFFFCE4E8),
        onDestinationSelected: (index) {
          if (index == 1) _showSoon('Halaman Explore belum dibuat');
          if (index == 2) _showSoon('Halaman Profil belum dibuat');
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home, color: unhasMaroon),
            label: 'Beranda',
          ),
          NavigationDestination(
            icon: Icon(Icons.search),
            selectedIcon: Icon(Icons.search, color: unhasMaroon),
            label: 'Explore',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person, color: unhasMaroon),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

class _PostComposer extends StatelessWidget {
  const _PostComposer({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFEFEFF2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: Color(0xFFB8B8C2),
              child: Icon(Icons.person, color: Colors.white),
            ),
            SizedBox(width: 14),
            Expanded(
              child: Text(
                'Apa yang ingin kamu bagikan?',
                style: TextStyle(fontSize: 15, color: Color(0xFF6B6B76)),
              ),
            ),
            Icon(Icons.image_outlined, size: 28),
          ],
        ),
      ),
    );
  }
}