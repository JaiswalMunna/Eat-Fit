// import 'package:flutter/material.dart';

// class ChangePasswordScreen extends StatefulWidget {
//   const ChangePasswordScreen({super.key});

//   @override
//   State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
// }

// class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
//   final TextEditingController _oldPasswordController = TextEditingController();
//   final TextEditingController _newPasswordController = TextEditingController();
//   final TextEditingController _confirmPasswordController =
//       TextEditingController();
//   bool _isOldPasswordVisible = false;
//   bool _isNewPasswordVisible = false;
//   bool _isConfirmPasswordVisible = false;

//   @override
//   void dispose() {
//     _oldPasswordController.dispose();
//     _newPasswordController.dispose();
//     _confirmPasswordController.dispose();
//     super.dispose();
//   }

//   void _changePassword() {
//     // Handle password change logic here
//     final oldPassword = _oldPasswordController.text.trim();
//     final newPassword = _newPasswordController.text.trim();
//     final confirmPassword = _confirmPasswordController.text.trim();

//     if (newPassword != confirmPassword) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("New passwords do not match!")),
//       );
//       return;
//     }

//     // Add your password update logic here
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("Password changed successfully!")),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.white,
//         centerTitle: true,
//         title: const Text(
//           "Change password",
//           style: TextStyle(
//               color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
//         ),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             const SizedBox(height: 20),
//             const Text(
//               "Please enter your old and new passwords to continue",
//               style: TextStyle(color: Colors.grey, fontSize: 14),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 30),
//             _buildPasswordField(
//               controller: _oldPasswordController,
//               label: "Old password",
//               isVisible: _isOldPasswordVisible,
//               onVisibilityToggle: () {
//                 setState(() {
//                   _isOldPasswordVisible = !_isOldPasswordVisible;
//                 });
//               },
//             ),
//             const SizedBox(height: 20),
//             _buildPasswordField(
//               controller: _newPasswordController,
//               label: "New password",
//               isVisible: _isNewPasswordVisible,
//               onVisibilityToggle: () {
//                 setState(() {
//                   _isNewPasswordVisible = !_isNewPasswordVisible;
//                 });
//               },
//             ),
//             const SizedBox(height: 20),
//             _buildPasswordField(
//               controller: _confirmPasswordController,
//               label: "Repeat new password",
//               isVisible: _isConfirmPasswordVisible,
//               onVisibilityToggle: () {
//                 setState(() {
//                   _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
//                 });
//               },
//             ),
//             const SizedBox(height: 30),
//             ElevatedButton(
//               onPressed: _changePassword,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFF35CC8C),
//                 minimumSize: const Size(double.infinity, 50),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//               child: const Text(
//                 "Change",
//                 style: TextStyle(color: Colors.white, fontSize: 16),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildPasswordField({
//     required TextEditingController controller,
//     required String label,
//     required bool isVisible,
//     required VoidCallback onVisibilityToggle,
//   }) {
//     return TextField(
//       controller: controller,
//       obscureText: !isVisible,
//       decoration: InputDecoration(
//         labelText: label,
//         labelStyle: const TextStyle(color: Colors.grey, fontSize: 14),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//         ),
//         prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
//         suffixIcon: IconButton(
//           icon: Icon(
//             isVisible ? Icons.visibility : Icons.visibility_off,
//             color: Colors.grey,
//           ),
//           onPressed: onVisibilityToggle,
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isLoading = false;
  bool _isOldPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  Future<void> _changePassword() async {
    final oldPassword = _oldPasswordController.text.trim();
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (newPassword != confirmPassword) {
      _showSnackbar("New passwords do not match.");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;

      // Reauthenticate the user with the old password
      final credential = EmailAuthProvider.credential(
        email: user!.email!,
        password: oldPassword,
      );
      await user.reauthenticateWithCredential(credential);

      // Update the password
      await user.updatePassword(newPassword);

      _showSnackbar("Password changed successfully!");
      Navigator.pop(context); // Return to the previous screen
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        _showSnackbar("Incorrect old password.");
      } else {
        _showSnackbar("Error: ${e.message}");
      }
    } catch (e) {
      _showSnackbar("An unexpected error occurred.");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Change Password",
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
                  const Text(
                    "Please enter your old and new passwords to continue",
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(height: 20),
                  _buildPasswordField(
                    "Old password",
                    _oldPasswordController,
                    _isOldPasswordVisible,
                    () {
                      setState(() {
                        _isOldPasswordVisible = !_isOldPasswordVisible;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildPasswordField(
                    "New password",
                    _newPasswordController,
                    _isNewPasswordVisible,
                    () {
                      setState(() {
                        _isNewPasswordVisible = !_isNewPasswordVisible;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildPasswordField(
                    "Repeat new password",
                    _confirmPasswordController,
                    _isConfirmPasswordVisible,
                    () {
                      setState(() {
                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                      });
                    },
                  ),
                  const SizedBox(height: 30),
                  GestureDetector(
                    onTap: _changePassword,
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xFF35CC8C),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          "Change",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildPasswordField(String label, TextEditingController controller,
      bool isVisible, VoidCallback toggleVisibility) {
    return TextField(
      controller: controller,
      obscureText: !isVisible,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(
            isVisible ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: toggleVisibility,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
