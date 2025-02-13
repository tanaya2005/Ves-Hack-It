// lib/models/volunteer.dart

class Volunteer {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String address;

  Volunteer({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
  });

  // Convert Volunteer object to JSON for API requests
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
    };
  }

  // Convert JSON response from API to Volunteer object
  factory Volunteer.fromJson(Map<String, dynamic> json) {
    return Volunteer(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
    );
  }
}
