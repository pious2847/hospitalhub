import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hospitalhub/.env.dart';
import 'package:hospitalhub/model/user_model.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:hospitalhub/widgets/colors.dart';
import 'package:intl/intl.dart';

class PatientModal extends StatefulWidget {
  final Patient? patient;

  const PatientModal({Key? key, this.patient}) : super(key: key);

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
    _dobController = TextEditingController(
      text: widget.patient?.formattedDateOfBirth ?? '',
    );
    _phoneController = TextEditingController(text: widget.patient?.phone ?? '');
    _emailController = TextEditingController(text: widget.patient?.email ?? '');
    _diagnosisController = TextEditingController(text: widget.patient?.diagnosis ?? '');
    _addressController = TextEditingController(text: widget.patient?.address ?? '');
    _expensesController = TextEditingController(
      text: widget.patient?.formattedExpenses ?? '',
    );
    _statusController = TextEditingController(text: widget.patient?.status ?? '');
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
        dateOfBirth: DateFormat('yyyy-MM-dd').parse(_dobController.text),
        phone: _phoneController.text,
        email: _emailController.text,
        diagnosis: _diagnosisController.text,
        address: _addressController.text,
        expenses: num.parse(_expensesController.text),
        status: _statusController.text,
      );

      final dio = Dio();
      try {
        if (widget.patient == null) {
          final prefs = await SharedPreferences.getInstance();
          final doctorId = prefs.getString('userId');
          await dio.post('$APIURL/patients/$doctorId', data: patient.toJson());
        } else {
          await dio.put('$APIURL/patients/${widget.patient!.id}', data: patient.toJson());
        }
        Navigator.of(context).pop(true); // Return true to indicate success
      } catch (e) {
        print("Error saving patient: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving patient. Please try again.')),
        );
      }
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    VoidCallback? onTap,
    bool readOnly = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: primcolor),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: primcolor, width: 2),
          ),
        ),
        validator: validator ?? (value) => value?.isEmpty ?? true ? 'This field is required' : null,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        onTap: onTap,
        readOnly: readOnly,
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.patient?.dateOfBirth ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dobController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  widget.patient == null ? 'Add Patient' : 'Update Patient',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: primcolor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                _buildTextField(
                  controller: _nameController,
                  label: 'Name',
                  icon: Iconsax.user,
                ),
                _buildTextField(
                  controller: _dobController,
                  label: 'Date of Birth',
                  icon: Iconsax.calendar,
                  readOnly: true,
                  onTap: () => _selectDate(context),
                ),
                _buildTextField(
                  controller: _phoneController,
                  label: 'Phone',
                  icon: Iconsax.call,
                  keyboardType: TextInputType.phone,
                ),
                _buildTextField(
                  controller: _emailController,
                  label: 'Email',
                  icon: Iconsax.sms,
                  keyboardType: TextInputType.emailAddress,
                ),
                _buildTextField(
                  controller: _diagnosisController,
                  label: 'Diagnosis',
                  icon: Iconsax.health,
                ),
                _buildTextField(
                  controller: _addressController,
                  label: 'Address',
                  icon: Iconsax.location,
                ),
                _buildTextField(
                  controller: _expensesController,
                  label: 'Expenses',
                  icon: Iconsax.money,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                  ],
                ),
                _buildTextField(
                  controller: _statusController,
                  label: 'Status',
                  icon: Iconsax.status,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _savePatient,
                        child: Text(widget.patient == null ? 'Save' : 'Update'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primcolor,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancel'),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: BorderSide(color: primcolor),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}