class Product {
  int id;
  String name;
  String definition;
  String? status;
  String ownerId;
  double price;
  int category;
  List<ProductImage> images;
  String location;
  DateTime productTime;

  Product({
    required this.id,
    required this.name,
    required this.definition,
    this.status,
    required this.ownerId,
    required this.price,
    required this.category,
    required this.images,
    required this.location,
    required this.productTime,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      name: json['productName'] ?? '',
      definition: json['productDefinition'] ?? '',
      status: json['productStatus'] ,
      ownerId: json['ownerId'] ?? '',
      price: json['price']?.toDouble() ?? 0.0,
      category: json['categoryId'] ?? '',
      images: json['productImages'] !=null
      ? (json['productImages'] as List)
          .map((i) => ProductImage.fromJson(i))
          .toList() : [],
      location: json['productLocation'] ?? '',
      productTime: DateTime.parse(json['productTime'] ?? DateTime.now().toIso8601String() )
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productName': name,
      'productDefinition': definition,
      'ownerId': ownerId,
      'price': price,
      'categoryId': category,
      'productLocation': location,
      'id': id,
    };
  }
}

class ProductImage {
  int id;
  int productId;
  String imageUrl;

  ProductImage({
    required this.id,
    required this.productId,
    required this.imageUrl,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      id: json['id'] ?? 0,
      productId: json['productId'] ?? 0,
      imageUrl: json['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'imageUrl': imageUrl,
    };
  }
}

class ProductCategory {
  int id;
  String name;

  ProductCategory({
    required this.id,
    required this.name,
  });

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    return ProductCategory(
      id: json['productCategoryId'],
      name: json['productCategoryName'],
    );
  }
}