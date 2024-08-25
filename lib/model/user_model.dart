// ignore_for_file: file_names

class User {
  String username;
  String cardnumber;
  String email;
  String otp;
  String password;
  User(this.username, this.cardnumber,this.email, this.password, this.otp);
}

class Patient {
  String? id;  // Add this line
  String name;
  String dateOfBirth;
  String phone;
  String email;
  String diagnosis;
  String address;
  String expenses;
  String status;

  Patient({
    this.id,  // Add this line
    required this.name,
    required this.dateOfBirth,
    required this.phone,
    required this.email,
    required this.diagnosis,
    required this.address,
    required this.expenses,
    required this.status,
  });

  // Add this method
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'dateOfBirth': dateOfBirth,
      'phone': phone,
      'email': email,
      'diagnosis': diagnosis,
      'address': address,
      'expenses': expenses,
      'status': status,
    };
  }

  // Optionally, add this factory constructor
  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['_id'],
      name: json['name'],
      dateOfBirth: json['dateOfBirth'],
      phone: json['phone'],
      email: json['email'],
      diagnosis: json['diagnosis'],
      address: json['address'],
      expenses: json['expenses'],
      status: json['status'],
    );
  }
}
