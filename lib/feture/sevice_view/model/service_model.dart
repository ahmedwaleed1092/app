class ServiceModel {
  final String name;
  final double rating;
  final String experience;
  String? imageUrl = "assets/images/profile.png";

  ServiceModel({
    required this.name,
    required this.rating,
    required this.experience,
    this.imageUrl,
  });
}
