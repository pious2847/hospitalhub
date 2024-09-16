import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hospitalhub/.env.dart';
import 'package:hospitalhub/model/user_model.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:hospitalhub/widgets/colors.dart';

class ReferPatients extends StatefulWidget {
  final Patient? patient;

  const ReferPatients({Key? key, this.patient}) : super(key: key);

  @override
  _ReferPatientsState createState() => _ReferPatientsState();
}

class _ReferPatientsState extends State<ReferPatients> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _cardController;

  @override
  void initState() {
    super.initState();
    _cardController = TextEditingController(text: '');
  }

  @override
  void dispose() {
    _cardController.dispose();
    super.dispose();
  }

  Future<void> _savePatient() async {
    if (_formKey.currentState!.validate()) {
      final dio = Dio();
      try {
        final prefs = await SharedPreferences.getInstance();
        final doctorId = prefs.getString('userId');

        // Get the card number from the text controller
        final cardNumber = _cardController.text;

        await dio.post('$APIURL/patients/$doctorId', data: {
          "patientId": widget.patient!.id,
          "referto": cardNumber, 
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Patient referred successfully')),
        );
        Navigator.of(context).pop(true); // Return true to indicate success
      } catch (e) {
        print("Error saving patient: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Error saving patient. Please try again.')),
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
            borderSide: const BorderSide(color: primcolor, width: 2),
          ),
        ),
        validator: validator ??
            (value) => value?.isEmpty ?? true ? 'This field is required' : null,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        onTap: onTap,
        readOnly: readOnly,
      ),
    );
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
                const Text(
                  'Transfer Patient',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: primcolor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                _buildTextField(
                  controller: _cardController,
                  label: 'Doctor ID',
                  icon: Iconsax.card_copy,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _savePatient,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primcolor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Transfer',
                          style: TextStyle(color: secondarytextcolor),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancel'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: const BorderSide(color: primcolor),
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
