import 'package:flutter/material.dart';
import 'package:hospitalhub/service/apiservices.dart';
import 'package:hospitalhub/widgets/colors.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../model/user_model.dart';
import 'package:intl/intl.dart';

class PatientDetails extends StatefulWidget {
  final Patient? patient;

  const PatientDetails({super.key, this.patient});

  @override
  _PatientDetailsState createState() => _PatientDetailsState();
}

class _PatientDetailsState extends State<PatientDetails> {
  final bool _isLoading = false;
  var Recomendation = '';
  final apiService = ApiService();

  @override
  void initState() {
    super.initState();
    fetchRecomendations();
  }

  Future<void> fetchRecomendations() async {
    var recomendations =
        await apiService.getRecommendation(widget.patient!.diagnosis);
    print(recomendations);
    setState(() {
      Recomendation = recomendations as String;
    });
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
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Patient Details"),
          backgroundColor: primcolor,
        ),
        body: SafeArea(
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
                        widget.patient!.name[0].toUpperCase(),
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
                          widget.patient!.name,
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
                          DateFormat('yyyy-MM-dd')
                              .format(widget.patient!.dateOfBirth)),
                      _buildInfoRow("Phone", widget.patient!.phone),
                      _buildInfoRow("Email", widget.patient!.email),
                      _buildInfoRow("Address", widget.patient!.address),
                      _buildInfoRow("Diagnosis", widget.patient!.diagnosis),
                      _buildInfoRow(
                          "Expenses", "\$${widget.patient!.formattedExpenses}"),
                      _buildInfoRow("Status", widget.patient!.status),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        "Recommended Treatments",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text("$Recomendation"),
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
