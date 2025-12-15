class SocialSignupData {
  final String uid;
  final String email;
  final String provider;
  final String? name;
  final String? photo;

  const SocialSignupData({
    required this.uid,
    required this.email,
    required this.provider,
    this.name,
    this.photo,
  });
}
