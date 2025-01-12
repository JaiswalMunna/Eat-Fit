import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  String? firstName;
  String? lastName;
  String? profileImageUrl;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      String? uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        DocumentSnapshot userDoc =
            await FirebaseFirestore.instance.collection('users').doc(uid).get();

        if (userDoc.exists) {
          setState(() {
            firstName = userDoc['firstName'];
            lastName = userDoc['lastName'];
            profileImageUrl = userDoc['profileImageUrl']; // Optional field
            isLoading = false;
          });
        }
      }
    } catch (e) {
      print("Error fetching user data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> uploadProfileImage() async {
    try {
      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImage == null) return;

      File imageFile = File(pickedImage.path);
      String uid = FirebaseAuth.instance.currentUser!.uid;

      // Upload image to Firebase Storage
      UploadTask uploadTask = FirebaseStorage.instance
          .ref()
          .child('profileImages/$uid.jpg')
          .putFile(imageFile);

      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      // Update Firestore with new profile image URL
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'profileImageUrl': downloadUrl,
      });

      setState(() {
        profileImageUrl = downloadUrl;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile picture updated successfully!")),
      );
    } catch (e) {
      print("Error uploading profile image: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to upload profile picture.")),
      );
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(
        context, '/splash'); // Redirect to Splash Screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Profile",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Profile Picture
                  GestureDetector(
                    onTap: uploadProfileImage,
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: profileImageUrl != null
                          ? NetworkImage(profileImageUrl!)
                          : const AssetImage(
                                  '/Users/emilbasnyat/development/UI:UX_Mun/Eat-Fit/assets/images/profile.jpg')
                              as ImageProvider,
                      child: const Icon(Icons.camera_alt, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Name
                  Text(
                    "$firstName $lastName",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Edit Profile Button
                  GestureDetector(
                    onTap: () {
                      // Navigate to Edit Profile (if needed)
                    },
                    child: Container(
                      width: 328,
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF35CC8C),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            "Edit Profile",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Inter',
                            ),
                          ),
                          Icon(Icons.edit, color: Colors.white, size: 24),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  const Divider(color: Colors.grey, thickness: 1),
                  const SizedBox(height: 20),

                  // Options: Contact Us, About Us, Log Out
                  buildOptionRow(
                    icon:
                        '/Users/emilbasnyat/development/UI:UX_Mun/Eat-Fit/assets/icons/email.png',
                    text: "Contact Us",
                    textColor: Colors.black,
                    onTap: () {
                      // Handle contact us
                    },
                  ),
                  const SizedBox(height: 16),
                  buildOptionRow(
                    icon:
                        '/Users/emilbasnyat/development/UI:UX_Mun/Eat-Fit/assets/icons/about.png',
                    text: "About Us",
                    textColor: Colors.black,
                    onTap: () {
                      // Handle about us
                    },
                  ),
                  const SizedBox(height: 16),
                  buildOptionRow(
                    icon:
                        '/Users/emilbasnyat/development/UI:UX_Mun/Eat-Fit/assets/icons/logout.png',
                    text: "Log Out",
                    textColor: const Color(0xFFCB2030), // Red color for log out
                    onTap: logout, // Logout function
                  ),
                ],
              ),
            ),
    );
  }

  Widget buildOptionRow({
    required String icon,
    required String text,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            icon,
            width: 24,
            height: 24,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.error,
                  size: 24, color: Colors.red); // Fallback if image fails
            },
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}