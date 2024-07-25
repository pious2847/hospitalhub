// ignore_for_file: library_private_types_in_public_api

import 'package:dio/dio.dart';
import 'package:file_sharing_app/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../.env.dart';
import '../model/user_model.dart';
import '../widgets/colors.dart';
import '../widgets/messages.dart';

class ResetPass extends StatefulWidget {
  const ResetPass({super.key});

  @override
  _ResetPassState createState() => _ResetPassState();
}

class _ResetPassState extends State<ResetPass> {
  final _formKey = GlobalKey<FormState>();
  bool isRegisted = false;
  bool _obscureText = true;
  bool _isLoading = false; // Add this line

  Future<void> save() async {
    setState(() {
      _isLoading = true; // Set loading state to true
    });
    final dio = Dio();
    final prefs = await SharedPreferences.getInstance();

    final userMail = prefs.getString('email');
    try {
      final response = await dio.post(
        "$APIURL/reset-password",
        options: Options(
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
        ),
        data: {
          'email': userMail,
          'newPassword': user.password,
        },
      );
      print('Response: $response');

      if (response.statusCode == 200) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Signin()),
        );
        const resMsg = 'Password reset sucessfully !!';
        ToastMsg.showSuccessToast(" $resMsg,");

        // Dismiss the loading dialog after successful login
      } else {
        print("Invalid response ${response.statusCode}: ${response.data}");
        ToastMsg.showErrorToast("Password reset Failed Please try again");
        setState(() {
          _isLoading = false; // Set loading state to true
        });
      }
    } catch (e) {
      print("Error occurred: $e");
      ToastMsg.showErrorToast("Password reset Failed Please try again");
      // Handle error, show toast or snackbar
      setState(() {
        _isLoading = false; // Set loading state to true
      });
    }
  }

  User user = User(
    '',
    '',
    '',
    '',
    '',
  );

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      child: Scaffold(
        appBar: AppBar(title: Text("")),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 80),
                  Text(
                    "Reset Password",
                    style: GoogleFonts.poppins(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "complete to continue",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 48),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller:
                              TextEditingController(text: user.password),
                          onChanged: (value) {
                            user.password = value;
                          },
                          obscureText: _obscureText,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: const Icon(Iconsax.lock_1_copy),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureText
                                    ? Iconsax.eye_copy
                                    : Iconsax.eye_slash_copy,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: TextEditingController(text: ''),
                          obscureText: _obscureText,
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            prefixIcon: const Icon(Iconsax.lock_1_copy),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureText
                                    ? Iconsax.eye_copy
                                    : Iconsax.eye_slash_copy,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: secondarytextcolor,
                            backgroundColor: primcolorlight,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              await save();
                            }
                          },
                          child: Text(
                            'Submit',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
