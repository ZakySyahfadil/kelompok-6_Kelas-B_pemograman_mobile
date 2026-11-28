import '../models/comment.dart';

// Pengguna "yang sedang login" untuk dummy.
// Nanti diganti dengan FirebaseAuth.instance.currentUser!.uid
const String dummyCurrentUserId = 'me';
const String dummyCurrentUserName = 'Kamu';

// Kunci = id postingan (sama dengan id di dummy_posts.dart)
Map<String, List<Comment>> buildDummyComments() => {
      '1': [
        Comment(
          id: 'c1',
          authorId: 'u2',
          authorName: 'AndiPratama',
          content: 'Biasanya KRS dibuka minggu kedua setelah libur, coba cek di SIM-A.',
          createdAt: DateTime.now().subtract(const Duration(hours: 1, minutes: 40)),
        ),
        Comment(
          id: 'c2',
          authorId: 'u3',
          authorName: 'SitiNurhaliza',
          content: 'Kemarin di grup angkatan katanya tanggal 10. Tapi belum pasti.',
          createdAt: DateTime.now().subtract(const Duration(hours: 1)),
        ),
        Comment(
          id: 'c3',
          authorId: dummyCurrentUserId,
          authorName: dummyCurrentUserName,
          content: 'Makasih infonya! 🙏',
          createdAt: DateTime.now().subtract(const Duration(minutes: 20)),
        ),
      ],
      '2': [
        Comment(
          id: 'c4',
          authorId: 'u4',
          authorName: 'RizkyAulia',
          content: 'Pendaftarannya lewat mana kak?',
          createdAt: DateTime.now().subtract(const Duration(hours: 3)),
        ),
      ],
    };