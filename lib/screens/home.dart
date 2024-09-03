import 'package:flutter/material.dart';
import 'package:hospitalhub/.env.dart';
import 'package:hospitalhub/model/user_model.dart';
import 'package:hospitalhub/widgets/colors.dart';
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
  final _dio = Dio();

  @override
  void initState() {
    super.initState();
    fetchPatients();
  }

  List<Patient> parsePatients(Map<String, dynamic> responseData) {
    List<dynamic> patientsJson = responseData['patients'];
    return patientsJson.map((json) => Patient.fromJson(json)).toList();
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
        final Map<String, dynamic> data = response.data;
        setState(() {
          patients = parsePatients(data);
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
          "Error fetching patients. Please check your internet connection.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('Patient Management',
                  style: TextStyle(color: secondarytextcolor)),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [primcolor, primcolorlight],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PatientCountCard(patientCount: patients.length),
                  const SizedBox(height: 24),
                  Text(
                    'Patient List',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: primcolor,
                        ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          isLoading
              ? const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return PatientListItem(patient: patients[index]);
                    },
                    childCount: patients.length,
                  ),
                ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return const PatientModal();
            },
          );
        },
        icon: const Icon(Icons.add, color: secondarytextcolor),
        label: const Text('Add Patient', style: TextStyle(color: secondarytextcolor)),
        backgroundColor: primcolorlight,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: primcolor,
        unselectedItemColor: Colors.grey,
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
          BottomNavigationBarItem(
            icon: Icon(Iconsax.user_octagon),
            label: 'Profile',
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
        child: Row(
          children: [
            const Icon(Iconsax.user_tick, size: 48, color: primcolor),
            const SizedBox(width: 16),
            Column(
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
                        color: primcolor,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PatientListItem extends StatelessWidget {
  final Patient patient;

  const PatientListItem({Key? key, required this.patient}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: primcolorlight,
          child: Text(
            patient.name[0].toUpperCase(),
            style: const TextStyle(color: secondarytextcolor),
          ),
        ),
        title: Text(patient.name),
        subtitle: Text(patient.status),
        trailing: const Icon(Iconsax.arrow_right_3, color: primcolor),
        onTap: () {
          // Navigate to patient details page
        },
      ),
    );
  }
}
