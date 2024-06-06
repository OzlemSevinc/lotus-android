class Article{
  int id;
  String title;
  String content;
  String date;
  String writer;
  String image;
  int categoryId;

  Article({required this.id,required this.title,required this.content,required this.date,required this.writer,required this.image,required this.categoryId});

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      content: json['contentText'] ?? '',
      date: json['releaseDate'] ?? '',
      writer: json['writers'] ?? '',
      image: json['image'] ?? '',
      categoryId: json['articleCategoryId'] ?? 0,
    );
  }

}