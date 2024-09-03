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
  String? id;
  String name;
  DateTime dateOfBirth;
  String phone;
  String email;
  String diagnosis;
  String address;
  num expenses;
  String status;

  Patient({
    this.id,
    required this.name,
    required this.dateOfBirth,
    required this.phone,
    required this.email,
    required this.diagnosis,
    required this.address,
    required this.expenses,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      'name': name,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'phone': phone,
      'email': email,
      'diagnosis': diagnosis,
      'address': address,
      'expenses': expenses,
      'status': status,
    };
  }

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['_id'],
      name: json['name'],
      dateOfBirth: DateTime.parse(json['dateOfBirth']),
      phone: json['phone'],
      email: json['email'],
      diagnosis: json['diagnosis'],
      address: json['address'],
      expenses: json['expenses'],
      status: json['status'],
    );
  }

  String get formattedDateOfBirth {
    return "${dateOfBirth.year}-${dateOfBirth.month.toString().padLeft(2, '0')}-${dateOfBirth.day.toString().padLeft(2, '0')}";
  }

  String get formattedExpenses {
    return expenses.toStringAsFixed(2);
  } 
}