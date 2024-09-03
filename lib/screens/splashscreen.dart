// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hospitalhub/screens/home.dart';
import 'package:hospitalhub/widgets/colors.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:hospitalhub/screens/onboarding.dart';
import 'package:hospitalhub/service/general.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  bool showHome = false;

  @override
  void initState() {
    super.initState();
    authenticatePage();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    SharedPreferences.getInstance().then((prefs) {
      bool showHome = prefs.getBool('showHome') ?? false;

      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          showHome = showHome;
        });

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => showHome ? const HomePage() : const Onbording(),
          ),
        );
      });
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Iconsax.hospital_copy,
              size: 140,
              color: secondarytextcolor,
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              'Track and Record',
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 27,
                  color: Colors.white),
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              'Keep track & manage your patient Records ',
              style: TextStyle(
                  fontSize: 13,
                  color: Colors.white,
                  fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> authenticatePage() async {
    try {
      final userData = await getUserDataFromLocalStorage();
      final userId = userData['userId'];
      final isLoggedIn = userData['isLoggedIn'];
      if (userId != null && isLoggedIn) {
        final prefs = await SharedPreferences.getInstance();
        prefs.setBool('showHome', true);
      } else {
        final prefs = await SharedPreferences.getInstance();
        prefs.setBool('showHome', false);
      }
    } catch (e) {
      print("Error occurred: $e");
      // Handle error, show toast or snackbar
    }
  }
}
