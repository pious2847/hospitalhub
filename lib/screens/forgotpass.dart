import 'package:dio/dio.dart';
import 'package:hospitalhub/screens/otp.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../.env.dart';
import '../model/user_model.dart';
import '../widgets/colors.dart';
import '../widgets/messages.dart';

class ForgotPass extends StatefulWidget {
  const ForgotPass({super.key});

  @override
  _ForgotPassState createState() => _ForgotPassState();
}

class _ForgotPassState extends State<ForgotPass> {
  final _formKey = GlobalKey<FormState>();
  bool isRegisted = false;
  bool _isLoading = false; // Add this line

  Future<void> save() async {
    setState(() {
      _isLoading = true; // Set loading state to true
    });
    final dio = Dio();
    try {
      final response = await dio.post(
        "$APIURL/forgot-password",
        options: Options(
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
        ),
        data: {
          'email': user.email,
        },
      );
      print('Response: $response');

      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();

        prefs.setString('email', user.email);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const OptVerification()),
        );
        const resMsg = 'Verification Code Sent to Email';
        ToastMsg.showSuccessToast("$resMsg");

        // Dismiss the loading dialog after successful login
      } else {
        print("Invalid response ${response.statusCode}: ${response.data}");
        ToastMsg.showErrorToast("verification Failed Please try again");
        setState(() {
          _isLoading = false; // Set loading state to true
        });
      }
    } catch (e) {
      print("Error occurred: $e");
      ToastMsg.showErrorToast("verification Failed Please try again");
      // Handle error, show toast or snackbar
      setState(() {
        _isLoading = false; // Set loading state to true
      });
    }
  }

  User user = User(
     username: '', cardnumber: '', email: '', password: '', otp: '',
  );

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      child: Scaffold(
        appBar: AppBar(
          title: Text("")
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 80),
                  Text(
                    "Forgot Password",
                    style: GoogleFonts.poppins(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Verify to continue",
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
                          controller: TextEditingController(text: user.email),
                          onChanged: (value) {
                            user.email = value;
                          },
                          decoration: InputDecoration(
                            labelText: 'Email',
                            prefixIcon: const Icon(Iconsax.message_2_copy),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your email';
                            } else if (!RegExp(
                                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                .hasMatch(value)) {
                              return 'Enter a valid email address';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
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
                            'Verify',
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
