import 'package:flutter/material.dart';
import 'package:hospitalhub/service/apiservices.dart';
import 'package:hospitalhub/widgets/colors.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../model/user_model.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isLoading = false;
  User? doctorInfo;
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    fetchDoctorInfo();
  }

  Future<void> fetchDoctorInfo() async {
    setState(() => _isLoading = true);
    try {
      final Map<String, dynamic> info = await apiService.getProfile();
      setState(() {
        doctorInfo = User.fromJson(info['doctor']);
      });
    } catch (e) {
      print('Error fetching doctor information: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Doctor Profile"),
        backgroundColor: primcolor,
      ),
      body: ModalProgressHUD(
        inAsyncCall: _isLoading,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: primcolorlight,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: primcolor,
                          child: Text(
                            doctorInfo?.username.isNotEmpty == true
                                ? doctorInfo!.username[0].toUpperCase()
                                : '',
                            style: const TextStyle(
                              fontSize: 36,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          doctorInfo?.username ?? 'Unknown',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoRow("Full Name", doctorInfo?.username ?? 'Unknown'),
                          _buildInfoRow("Card Number", doctorInfo?.cardnumber ?? 'Unknown'),
                          _buildInfoRow("Email", doctorInfo?.email ?? 'Unknown'),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}