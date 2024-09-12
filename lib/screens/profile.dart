import 'package:flutter/material.dart';
import 'package:hospitalhub/service/apiservices.dart';
import 'package:hospitalhub/widgets/colors.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../model/user_model.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatefulWidget {

  const ProfilePage({super.key, });

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isLoading = false;
  List<User> doctorInfo = [];
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    fetchdoctorInfo();
  }
    List<User> parseDoctor(Map<String, dynamic> responseData) {
    List<dynamic> doctorJson = responseData['doctor'];
    return doctorJson.map((json) => User.fromJson(json)).toList();
  }

  Future<void> fetchdoctorInfo() async {
    setState(() => _isLoading = true);
    try {
      final Map<String, dynamic> info = await apiService.getProfile();
      print("HEALTH INFO : $info");


      setState(() {
        doctorInfo = parseDoctor(info);
      });
    } catch (e) {
      print('Error fetching health information: $e');
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
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 24, 17, 17),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: primarytextcolor),
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
        title: const Text("Profile"),
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
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.3,
                  decoration: const BoxDecoration(
                    color: primcolorlight,
                  ),
                  child: Center(
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: primcolor,
                      child: Text(
                        doctorInfo.username[0].toUpperCase() ?? '',
                        style: const TextStyle(
                          fontSize: 48,
                          color: secondarytextcolor,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          doctorInfo?.name ?? 'Unknown',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: primarytextcolor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildInfoRow(
                        "Date of Birth",
                        doctorInfo?.dateOfBirth != null
                            ? DateFormat('yyyy-MM-dd').format(doctorInfo!.dateOfBirth)
                            : 'Unknown',
                      ),
                      _buildInfoRow("Phone", doctorInfo?.phone ?? 'Unknown'),
                      _buildInfoRow("Email", doctorInfo?.email ?? 'Unknown'),
                      _buildInfoRow("Address", doctorInfo?.address ?? 'Unknown'),
                      _buildInfoRow("Diagnosis", doctorInfo?.diagnosis ?? 'Unknown'),
                      _buildInfoRow("Status", doctorInfo?.status ?? 'Unknown'),
                    
                    ],
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