import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      selectedItemColor: Theme.of(context).primaryColor,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Iconsax.home),
          label: 'Home',
          tooltip: "Home",
        ),
        BottomNavigationBarItem(
          icon: Icon(Iconsax.user),
          label: 'Patients',
          tooltip: "Patients"
        ),
        BottomNavigationBarItem(
          icon: Icon(Iconsax.user_octagon),
          label: 'Profile',
          tooltip: "Profile"
        ),
      ],
    );
  }
}