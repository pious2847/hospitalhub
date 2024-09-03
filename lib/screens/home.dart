import 'package:flutter/material.dart';
import 'package:hospitalhub/.env.dart';
import 'package:hospitalhub/model/user_model.dart';
import 'package:hospitalhub/widgets/messages.dart';
import 'package:hospitalhub/widgets/patientModal.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Patient> patients = [];
  bool isLoading = true;
  final Dio _dio = Dio();

  @override
  void initState() {
    super.initState();
    fetchPatients();
  }

  Future<void> fetchPatients() async {
    setState(() {
      isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final doctorId = prefs.getString('userId');

      if (doctorId == null) {
        throw Exception('Doctor ID not found');
      }

      final response = await _dio.get('$APIURL/doctors/$doctorId/patients');
      print(response);
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        setState(() {
          patients = data.map((json) => Patient.fromJson(json)).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load patients');
      }
    } catch (e) {
      print('Error fetching patients: $e');
      setState(() {
        isLoading = false;
      });
      ToastMsg.showErrorToast(
          "Error fetching patients check internet connection");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Management'),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: fetchPatients,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PatientCountCard(patientCount: patients.length),
                    const SizedBox(height: 24),
                    Text(
                      'Patient List',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    PatientTable(patients: patients),
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return const PatientModal();
            },
          );
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Iconsax.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.user),
            label: 'Patients',
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.share),
            label: 'Refers',
          ),
        ],
      ),
    );
  }
}

class PatientCountCard extends StatelessWidget {
  final int patientCount;

  const PatientCountCard({Key? key, required this.patientCount})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Patients',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              '$patientCount',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class PatientTable extends StatelessWidget {
  final List<Patient> patients;

  const PatientTable({Key? key, required this.patients}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: const [
              DataColumn(label: Text('Name')),
              DataColumn(label: Text('Status')),
            ],
            rows: patients
                .map((patient) => DataRow(cells: [
                      DataCell(Text(patient.name)),
                      DataCell(Text(patient.status)),
                    ]))
                .toList(),
          ),
        ),
      ),
    );
  }
}
