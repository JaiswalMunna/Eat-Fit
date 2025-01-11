import 'package:flutter/material.dart';

class TopAppBar extends StatelessWidget {
  final VoidCallback onProfileTap;
  final VoidCallback onCalendarTap;

  const TopAppBar({
    super.key,
    required this.onProfileTap,
    required this.onCalendarTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      leading: GestureDetector(
        onTap: onProfileTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundImage: AssetImage('assets/images/profile.jpg'),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.calendar_today, color: Colors.black),
          onPressed: onCalendarTap,
        ),
      ],
    );
  }
}
