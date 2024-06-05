class Podcast{
  int id;
  String title;
  String description;
  String url;
  String writers;
  String image;
  int categoryId;

  Podcast({required this.id,required this.title,required this.description,required this.url,required this.writers,required this.image,required this.categoryId});

  factory Podcast.fromJson(Map<String, dynamic> json) {
    return Podcast(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      url: json['url'] ?? '',
      writers: json['writers'] ?? '',
      image: json['image'] ?? '',
      categoryId: json['podcastCategoryId'] ?? '',
    );
  }
}