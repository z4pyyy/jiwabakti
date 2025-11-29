class GoogleSignupData {
  final String uid;
  final String email;
  final String? name;
  final String? photo;

  GoogleSignupData({
    required this.uid,
    required this.email,
    this.name,
    this.photo,
  });
}