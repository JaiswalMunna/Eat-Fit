import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TopAppBar extends StatefulWidget {
  final VoidCallback onProfileTap;
  final VoidCallback onCalendarTap;

  const TopAppBar({
    super.key,
    required this.onProfileTap,
    required this.onCalendarTap,
  });

  @override
  _TopAppBarState createState() => _TopAppBarState();
}

class _TopAppBarState extends State<TopAppBar> {
  String? _profileImageUrl;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProfileImage();
  }

  /// Fetches the profile image URL from Firestore
  Future<void> _fetchProfileImage() async {
    try {
      String? uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        DocumentSnapshot userDoc =
            await FirebaseFirestore.instance.collection('users').doc(uid).get();

        if (userDoc.exists) {
          setState(() {
            _profileImageUrl =
                userDoc['profileImageUrl']; // Fetch the image URL
          });
        }
      }
    } catch (e) {
      print("Error fetching profile image: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      leading: GestureDetector(
        onTap: widget.onProfileTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: _isLoading
              ? const CircleAvatar(
                  radius: 24,
                  child: CircularProgressIndicator(),
                )
              : CircleAvatar(
                  radius: 24,
                  backgroundImage: _profileImageUrl != null
                      ? NetworkImage(_profileImageUrl!)
                      : const AssetImage('assets/images/profile.jpg')
                          as ImageProvider,
                ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.calendar_today, color: Colors.black),
          onPressed: widget.onCalendarTap,
        ),
      ],
    );
  }
}
