import 'package:flutter/material.dart';
import '../service/general.dart';
import 'package:dio/dio.dart';
import '../.env.dart';
import '../widgets/messages.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic> user = {};
  List<Map<String, String>> patients = [];

  @override
  void initState() {
    super.initState();
    _loadUser();
    _loadPatients();
  }

  Future<void> _loadUser() async {
    var loadedUser = await getUser();
    setState(() {
      user = loadedUser ?? {};
    });
  }

  Future<void> _loadPatients() async {
    final dio = Dio();
    final userData = await getUserDataFromLocalStorage();
    final userId = userData['userId'] ?? '';
    try {
      final response = await dio.get(
        "$APIURL/doctors/$userId/patients",
      );
        print("Patients Reponse1: ${response.data}");

      if (response.statusCode == 200) {
        setState(() {
          patients = response.data;
        });
        print("Patients Reponse: ${response.data}");
      } else {
        ToastMsg.showErrorToast("${response.data['message']}");
      }
    } catch (e) {}
    ToastMsg.showErrorToast("Please Check your internet connection");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HealthTrack'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeSection(),
              const SizedBox(height: 20),
              _buildPatientList(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Patients'),
          BottomNavigationBarItem(icon: Icon(Icons.share), label: 'Refer'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, Dr. ${user['fullName'] ?? 'Doctor'}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'You have ${patients.length} patients',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your Patients',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: patients.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                title: Text(patients[index]['name'] ?? ''),
                subtitle: Text(patients[index]['diagnosis'] ?? ''),
                leading: CircleAvatar(
                  child: Text(patients[index]['name']?[0] ?? ''),
                  backgroundColor: Colors.teal.shade200,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
