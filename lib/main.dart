import 'package:flutter/material.dart';
import 'package:mobile/screens/detail_event.dart';
import 'package:mobile/screens/detail_wisata.dart';
import 'package:mobile/screens/feedback_wisata.dart';
import 'package:mobile/screens/welcome.dart';
import 'package:mobile/screens/login.dart';
import 'package:mobile/screens/register.dart';
import 'package:mobile/screens/dashboard.dart';

void main() {
  runApp(const BaliKuyy());
}

class BaliKuyy extends StatelessWidget {
  const BaliKuyy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => const Welcome(),
        '/login': (context) => const Login(),
        '/register': (context) => const Register(),
        '/dashboard': (context) => const Dashboard(),
        '/detailWisata': (context) => const DetailWisata(),
        '/detailEvent': (context) => const DetailEvent(),
        '/feedback': (context) => const FeedbackPage(),
      },
    );
  }
}
