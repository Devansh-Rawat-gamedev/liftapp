class UserModel {
  final String id;
  final String email;
  String fullName;
  String phoneNumber;
  String profilePicture;
  DateTime? createdAt;
  DateTime? updatedAt;
  String deviceToken;
  bool isEmailVerified;
  bool isProfileActive;

  UserModel({
    required this.id,
    required this.email,
    this.fullName = '',
    this.phoneNumber = '',
    this.profilePicture = '',
    this.createdAt,
    this.updatedAt,
    this.deviceToken = '',
    required this.isEmailVerified,
    required this.isProfileActive,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      id: data['id'] ?? '',
      email: data['email'] ?? '',
      fullName: data['fullName'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      profilePicture: data['profilePicture'] ?? '',
      createdAt: data['createdAt'] != null ? DateTime.parse(data['createdAt']) : null,
      updatedAt: data['updatedAt'] != null ? DateTime.parse(data['updatedAt']) : null,
      deviceToken: data['deviceToken'] ?? '',
      isEmailVerified: data['isEmailVerified'] ?? false,
      isProfileActive: data['isProfileActive'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'profilePicture': profilePicture,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'deviceToken': deviceToken,
      'isEmailVerified': isEmailVerified,
      'isProfileActive': isProfileActive,
    };
  }
}
