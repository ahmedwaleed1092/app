class ServiceModel {
  final String name;
  final double rating;
  final String experience;
  final String roole; // هذا المتغير هو المسؤول عن الفلترة (سباكة، نجار، إلخ)
  final String? imageUrl;

  ServiceModel({
    required this.name,
    required this.rating,
    required this.experience,
    required this.roole,
    this.imageUrl,
  });
}
