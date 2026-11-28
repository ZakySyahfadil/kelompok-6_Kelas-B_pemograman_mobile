import '../models/post.dart';

final List<Post> dummyPosts = [
  Post(
    id: '1',
    authorName: 'RizkyAulia',
    faculty: 'Fakultas Teknik',
    major: 'Informatika',
    content: 'Ada yang tahu jadwal KRS semester depan kapan ya?',
    category: 'Akademik',
    imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTUCjT8_YUByq_ili5f-6XAnhuQrfFpgee7AlqgWNjmew&s=10',
    createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    likeCount: 124,
    commentCount: 3,
  ),
  Post(
    id: '2',
    authorName: 'NaufalDwi',
    faculty: 'Fakultas Ilmu Budaya',
    major: 'Sastra Jepang',
    content: 'Info kegiatan kampus minggu ini!\n\n'
        'Ada seminar "Inovasi untuk Masa Depan" di Auditorium FMIPA, '
        'besok jam 08.00. Buruan daftar ya, kuotanya terbatas! 📢',
    category: 'Event',
    createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    likeCount: 87,
    commentCount: 1,
  ),
  Post(
    id: '3',
    authorName: 'AndiPratama',
    faculty: 'Fakultas Teknik',
    major: 'Teknik Elektro',
    content: 'Open recruitment HMJ Elektro sudah dibuka! '
        'Yuk gabung dan berkembang bareng.',
    category: 'Organisasi',
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
    likeCount: 45,
    commentCount: 0,
  ),
  Post(
    id: '4',
    authorName: 'SitiNurhaliza',
    faculty: 'Fakultas Kedokteran',
    major: 'Pendidikan Dokter',
    content: 'Kehilangan kunci motor Honda di sekitar gedung perpustakaan. '
        'Kalau ada yang menemukan tolong hubungi aku ya 🙏',
    category: 'Lost & Found',
    createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
    likeCount: 9,
    commentCount: 0,
  ),
];