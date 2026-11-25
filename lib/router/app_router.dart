import 'package:go_router/go_router.dart';

import '../pages/about_page.dart';
import '../pages/home_page.dart';
import '../pages/location_page.dart';
import '../pages/note_form_page.dart';
import '../pages/notes_page.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomePage()),
    GoRoute(path: '/catatan', builder: (context, state) => const NotesPage()),
    GoRoute(
      path: '/catatan/baru',
      builder: (context, state) => const NoteFormPage(),
    ),
    GoRoute(path: '/lokasi', builder: (context, state) => const LocationPage()),
    GoRoute(path: '/tentang', builder: (context, state) => const AboutPage()),
  ],
);
