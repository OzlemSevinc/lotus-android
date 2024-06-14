import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lotus/colors.dart';
import 'package:lotus/service/product_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'entity/product_entity.dart';

class AddProduct extends StatefulWidget {
  final Product? product;
  final String? title;

  const AddProduct({super.key, this.product, this.title});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  List<File?> images = [];
  List<ProductImage> existingImages = [];
  final nameController = TextEditingController();
  final definitionController = TextEditingController();
  final priceController = TextEditingController();
  final locationController = TextEditingController();
  int? selectedCategory;
  List<ProductCategory> categories = [];
  String? selectedCity;
  List<String> cities = ["Adana", "Adıyaman", "Afyonkarahisar", "Ağrı", "Amasya", "Ankara", "Antalya", "Artvin", "Aydın", "Balıkesir",
    "Bilecik", "Bingöl", "Bitlis", "Bolu", "Burdur", "Bursa", "Çanakkale", "Çankırı", "Çorum", "Denizli", "Diyarbakır",
    "Edirne", "Elazığ", "Erzincan", "Erzurum", "Eskişehir", "Gaziantep", "Giresun", "Gümüşhane", "Hakkari", "Hatay", "Isparta", "Mersin",
    "İstanbul", "İzmir", "Kars", "Kastamonu", "Kayseri", "Kırklareli", "Kırşehir", "Kocaeli", "Konya", "Kütahya", "Malatya", "Manisa",
    "Kahramanmaraş", "Mardin", "Muğla", "Muş", "Nevşehir", "Niğde", "Ordu", "Rize", "Sakarya", "Samsun", "Siirt",
    "Sinop", "Sivas", "Tekirdağ", "Tokat", "Trabzon", "Tunceli", "Şanlıurfa", "Uşak", "Van", "Yozgat", "Zonguldak",
    "Aksaray", "Bayburt", "Karaman", "Kırıkkale", "Batman", "Şırnak", "Bartın", "Ardahan", "Iğdır", "Yalova", "Karabük", "Kilis", "Osmaniye", "Düzce"
  ];
  final ProductService productService = ProductService(baseUrl: 'https://lotusproject.azurewebsites.net/api/');
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      nameController.text = widget.product!.name;
      definitionController.text = widget.product!.definition;
      priceController.text = widget.product!.price.toString();
      locationController.text = widget.product!.location;
      selectedCategory = widget.product!.category;
      existingImages = widget.product!.images;
      images = List<File?>.filled(existingImages.length, null);
    }
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      final fetchedCategories = await productService.fetchProductCategories();
      setState(() {
        categories = fetchedCategories;
      });
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kategoriler yüklenemedi: $e')),
      );
    }
  }

  Future<void> pickImage(ImageSource source, int index) async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        if (index < existingImages.length) {
          existingImages[index] = ProductImage(id: existingImages[index].id, productId: existingImages[index].productId, imageUrl: pickedImage.path);
          images[index] = File(pickedImage.path);
        } else {
          images.add(File(pickedImage.path));
        }
      });
    }
  }

  void imageSourceBottomSheet(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Galeri"),
                onTap: () {
                  Navigator.of(context).pop();
                  pickImage(ImageSource.gallery, index);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Kamera"),
                onTap: () {
                  Navigator.of(context).pop();
                  pickImage(ImageSource.camera, index);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> saveProduct() async {
    setState(() {
      isLoading = true;
    });

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kullanıcı bilgileri alınamadı')),
      );
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      final newProduct = Product(
        id: widget.product?.id ?? 0,
        name: nameController.text,
        definition: definitionController.text,
        ownerId: userId,
        price: double.parse(priceController.text),
        category: selectedCategory!,
        images: existingImages,
        location: selectedCity!,
        productTime: DateTime.now(),
      );

      int productId;

      if (widget.product == null) {
        productId = await productService.addProduct(newProduct);
      } else {
        productId = widget.product!.id;
        await productService.updateProduct(newProduct);
      }

      for (int i = 0; i < images.length; i++) {
        if (images[i] != null) {
          if (i < existingImages.length) {
            await productService.updateProductImage(existingImages[i].id, images[i]!);
          } else {
            await productService.uploadProductImage(productId, images[i]!);
          }
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ürün başarıyla ${widget.product == null ? 'eklendi' : 'güncellendi'}')),
      );

      Navigator.of(context).pop(true);
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ürün eklenemedi: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> deleteProductAndProductImage() async {
    setState(() {
      isLoading = true;
    });

    try {
      if (widget.product != null) {
        await productService.deleteProduct(widget.product!.id);
        for (var image in existingImages) {
          await productService.deleteProductImage(image.id);
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ürün başarıyla silindi')),
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ürün silinemedi: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainPink,
        scrolledUnderElevation: 0.0,
        title: Text("${widget.title}"),
        actions: widget.product != null
            ? [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: deleteProductAndProductImage,
          ),
        ]
            : null,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              "Ürün resimleri ekleyiniz",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(4, (index) {
                return Stack(
                  children: [
                    GestureDetector(
                      onTap: () => imageSourceBottomSheet(context, index),
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          color: Colors.grey[200],
                        ),
                        child: existingImages.length > index && images[index] == null
                            ? Image.network(
                          existingImages[index].imageUrl,
                          fit: BoxFit.cover,
                        )
                            : images.length > index && images[index] != null
                            ? Image.file(
                          images[index]!,
                          fit: BoxFit.cover,
                        )
                            : Center(
                          child: Icon(
                            Icons.add_a_photo,
                            size: 50,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ),
                    if(images.length > index && images[index] != null)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              if (index < existingImages.length) {
                                existingImages.removeAt(index);
                              }
                              if (index < images.length) {
                                images.removeAt(index);
                              }
                            });
                          },
                          child: const CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.red,
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              }),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Ürün Adı',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 150,
              child: TextField(
                controller: definitionController,
                maxLines: null,
                expands: true,
                decoration: InputDecoration(
                  labelText: 'Ürün Açıklaması',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Ürün Fiyatı',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedCity,
              hint: const Text('İl'),
              items: cities.map((city) {
                return DropdownMenuItem(
                  value: city,
                  child: Text(city),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCity = value;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              value: selectedCategory,
              hint: const Text('Ürün Kategorisi'),
              items: categories.map((category) {
                return DropdownMenuItem(
                  value: category.id,
                  child: Text(category.name),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: saveProduct,
              style: ElevatedButton.styleFrom(
                backgroundColor: mainPink,
                foregroundColor: coal,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Ürünü Kaydet', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
