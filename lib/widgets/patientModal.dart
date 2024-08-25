import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hospitalhub/.env.dart';
import 'package:hospitalhub/model/user_model.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class PatientModal extends StatefulWidget {
  final Patient? patient;

  const PatientModal({
    Key? key,
    this.patient,
  }) : super(key: key);

  @override
  _PatientModalState createState() => _PatientModalState();
}

class _PatientModalState extends State<PatientModal> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _dobController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _diagnosisController;
  late TextEditingController _addressController;
  late TextEditingController _expensesController;
  late TextEditingController _statusController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.patient?.name ?? '');
    _dobController =
        TextEditingController(text: widget.patient?.dateOfBirth ?? '');
    _phoneController = TextEditingController(text: widget.patient?.phone ?? '');
    _emailController = TextEditingController(text: widget.patient?.email ?? '');
    _diagnosisController =
        TextEditingController(text: widget.patient?.diagnosis ?? '');
    _addressController =
        TextEditingController(text: widget.patient?.address ?? '');
    _expensesController =
        TextEditingController(text: widget.patient?.expenses ?? '');
    _statusController =
        TextEditingController(text: widget.patient?.status ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _diagnosisController.dispose();
    _addressController.dispose();
    _expensesController.dispose();
    _statusController.dispose();
    super.dispose();
  }

  Future<void> _savePatient() async {
    if (_formKey.currentState!.validate()) {
      final patient = Patient(
        id: widget.patient?.id,
        name: _nameController.text,
        dateOfBirth: _dobController.text,
        phone: _phoneController.text,
        email: _emailController.text,
        diagnosis: _diagnosisController.text,
        address: _addressController.text,
        expenses: _expensesController.text,
        status: _statusController.text,
      );

      final dio = Dio();
      try {
        if (widget.patient == null) {
          final prefs = await SharedPreferences.getInstance();
          final doctorId = prefs.getString('userId');

          print(patient.toJson());
          // Adding new patient
          await dio.post('$APIURL/patients/$doctorId', data: patient.toJson());
          print("Patient added: $patient");
        } else {
          // Updating existing patient
          await dio.put('$APIURL/patients/${widget.patient!.id}',
              data: patient.toJson());
          print("Patient updated: $patient");
        }
        Navigator.of(context).pop();
      } catch (e) {
        print("Error saving patient: $e");
        // Show error message to user
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text(widget.patient == null ? 'Add Patient' : 'Update Patient'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  prefixIcon: const Icon(Iconsax.user),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter patient name' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _dobController,
                decoration: InputDecoration(
                  labelText: 'Date of Birth',
                  prefixIcon: const Icon(Iconsax.calendar),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter patient DOB' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone',
                  prefixIcon: const Icon(Iconsax.call),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                validator: (value) => value?.isEmpty ?? true
                    ? 'Please enter patient phone'
                    : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: const Icon(Iconsax.sms),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                validator: (value) => value?.isEmpty ?? true
                    ? 'Please enter patient email'
                    : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _diagnosisController,
                decoration: InputDecoration(
                  labelText: 'Diagnosis',
                  prefixIcon: const Icon(Iconsax.health),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                validator: (value) => value?.isEmpty ?? true
                    ? 'Please enter patient diagnosis'
                    : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'Address',
                  prefixIcon: const Icon(Iconsax.location),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                validator: (value) => value?.isEmpty ?? true
                    ? 'Please enter patient address'
                    : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _expensesController,
                decoration: InputDecoration(
                  labelText: 'Expenses',
                  prefixIcon: const Icon(Iconsax.money),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                validator: (value) => value?.isEmpty ?? true
                    ? 'Please enter patient expenses'
                    : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _statusController,
                decoration: InputDecoration(
                  labelText: 'Status',
                  prefixIcon: const Icon(Iconsax.status),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                validator: (value) => value?.isEmpty ?? true
                    ? 'Please enter patient status'
                    : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
                    SizedBox(
          width: MediaQuery.of(context).size.width * 0.3,
          child: ElevatedButton(
            onPressed: _savePatient,
            child: Text(widget.patient == null ? 'Save' : 'Update'),
          ),
        ),
        const SizedBox(width: 14.0),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.3,
          child: TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ),
      
          ],
        )

      ],
    );
  }
}
