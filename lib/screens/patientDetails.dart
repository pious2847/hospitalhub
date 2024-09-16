import 'package:flutter/material.dart';
import 'package:hospitalhub/service/apiservices.dart';
import 'package:hospitalhub/widgets/colors.dart';
import 'package:hospitalhub/widgets/patientModal.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../model/user_model.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class PatientDetails extends StatefulWidget {
  final Patient? patient;

  const PatientDetails({Key? key, this.patient}) : super(key: key);

  @override
  _PatientDetailsState createState() => _PatientDetailsState();
}

class _PatientDetailsState extends State<PatientDetails> {
  bool _isLoading = false;
  Map<String, dynamic> healthInfo = {};
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
  }

  Future<void> deletepatients(patient) async {
    try {
      await apiService.deletePatient(patient.id);
    } catch (e) {
      print(e);
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
        title: const Text("Patient Details"),
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
                        widget.patient?.name[0].toUpperCase() ?? '',
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
                          widget.patient?.name ?? 'Unknown',
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
                        widget.patient?.dateOfBirth != null
                            ? DateFormat('yyyy-MM-dd')
                                .format(widget.patient!.dateOfBirth)
                            : 'Unknown',
                      ),
                      _buildInfoRow(
                          "Phone", widget.patient?.phone ?? 'Unknown'),
                      _buildInfoRow(
                          "Email", widget.patient?.email ?? 'Unknown'),
                      _buildInfoRow(
                          "Address", widget.patient?.address ?? 'Unknown'),
                      _buildInfoRow(
                          "Diagnosis", widget.patient?.diagnosis ?? 'Unknown'),
                      _buildInfoRow(
                        "Expenses",
                        widget.patient?.formattedExpenses != null
                            ? "\$${widget.patient!.formattedExpenses}"
                            : 'Unknown',
                      ),
                      _buildInfoRow(
                          "Status", widget.patient?.status ?? 'Unknown'),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment
                            .spaceEvenly, // To space out the buttons
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width *
                                0.4, // 40% of the screen width
                            child: ElevatedButton(
                              onPressed: () => {
                                deletepatients(widget.patient),
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                padding: EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Delete',
                                style: TextStyle(color: secondarytextcolor),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width *
                                0.4, // 40% of the screen width
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                side: BorderSide(color: primcolor),
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return PatientModal(
                                      patient: widget.patient,
                                    );
                                  },
                                );
                              },
                              child: const Text('edit'),
                            ),
                          ),
                        ],
                      )
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
