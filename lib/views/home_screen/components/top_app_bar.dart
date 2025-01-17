// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class TopAppBar extends StatefulWidget {
//   final VoidCallback onProfileTap;
//   final VoidCallback onCalendarTap;

//   const TopAppBar({
//     super.key,
//     required this.onProfileTap,
//     required this.onCalendarTap,
//   });

//   @override
//   _TopAppBarState createState() => _TopAppBarState();
// }

// class _TopAppBarState extends State<TopAppBar> {
//   String? _profileImageUrl;
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _fetchProfileImage();
//   }

//   /// Fetches the profile image URL from Firestore
//   Future<void> _fetchProfileImage() async {
//     try {
//       String? uid = FirebaseAuth.instance.currentUser?.uid;
//       if (uid != null) {
//         DocumentSnapshot userDoc =
//             await FirebaseFirestore.instance.collection('users').doc(uid).get();

//         if (userDoc.exists && userDoc.data() != null) {
//           setState(() {
//             _profileImageUrl = userDoc['profileImageUrl'];
//           });
//         }
//       }
//     } catch (e) {
//       print("Error fetching profile image: $e");
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       backgroundColor: Colors.white,
//       elevation: 0,
//       centerTitle: false,
//       leading: GestureDetector(
//         onTap: widget.onProfileTap,
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: _isLoading
//               ? const CircleAvatar(
//                   radius: 24,
//                   child: CircularProgressIndicator(),
//                 )
//               : CircleAvatar(
//                   radius: 24,
//                   backgroundImage:
//                       _profileImageUrl != null && _profileImageUrl!.isNotEmpty
//                           ? NetworkImage(_profileImageUrl!)
//                           : const AssetImage('assets/images/profile.jpg')
//                               as ImageProvider,
//                 ),
//         ),
//       ),
//       actions: [
//         IconButton(
//           icon: const Icon(Icons.calendar_today, color: Colors.black),
//           onPressed: widget.onCalendarTap,
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TopAppBar extends StatelessWidget {
  final VoidCallback onProfileTap;
  final VoidCallback onCalendarTap;
  final bool showCalendarIcon; // New parameter to toggle calendar icon

  const TopAppBar({
    super.key,
    required this.onProfileTap,
    required this.onCalendarTap,
    this.showCalendarIcon = true, // Default is true to show the calendar icon
  });

  @override
  Widget build(BuildContext context) {
    final String? uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      return AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        leading: GestureDetector(
          onTap: onProfileTap,
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
              radius: 24,
              backgroundImage: AssetImage('assets/images/profile.jpg'),
            ),
          ),
        ),
        actions: showCalendarIcon
            ? [
                IconButton(
                  icon: const Icon(Icons.calendar_today, color: Colors.black),
                  onPressed: onCalendarTap,
                ),
              ]
            : null, // Hide calendar icon if showCalendarIcon is false
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.calendar_today, color: Colors.black),
        //     onPressed: onCalendarTap,
        //   ),
        // ],
      );
    }

    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      leading: StreamBuilder<DocumentSnapshot>(
        stream:
            FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircleAvatar(
                radius: 24,
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (snapshot.hasError) {
            print("Error fetching profile image: ${snapshot.error}");
          }

          final userDoc = snapshot.data;
          final profileImageUrl = userDoc?.get('profileImageUrl') as String?;

          return GestureDetector(
            onTap: onProfileTap,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                radius: 24,
                backgroundImage:
                    profileImageUrl != null && profileImageUrl.isNotEmpty
                        ? NetworkImage(profileImageUrl)
                        : const AssetImage('assets/images/profile.jpg')
                            as ImageProvider,
              ),
            ),
          );
        },
      ),
      actions: showCalendarIcon
          ? [
              IconButton(
                icon: const Icon(Icons.calendar_today, color: Colors.black),
                onPressed: onCalendarTap,
              ),
            ]
          : [], // Ensure no calendar icon when showCalendarIcon is false
    );
  }
}
