import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lotus/colors.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  List<File> images = [];
  final nameController = TextEditingController();
  final definitionController = TextEditingController();
  final priceController = TextEditingController();
  final locationController = TextEditingController();
  String? selectedCategory;
  final List<String> categories = ["Giyim ve Tekstil","Banyo ve Bakım","Bebek Odası","Oyuncak ve Kitap","Araç ve Gereç","Diğer"];

  Future<void> pickImages(ImageSource source)async{
    if(source == ImageSource.gallery){
    final pickedImages=await ImagePicker().pickMultiImage();

    if(pickedImages != null){
      setState(() {
        images.addAll(pickedImages.map((pickedImage) => File(pickedImage.path)).toList());
      });
    }
    }else{
      final imageTaken = await ImagePicker().pickImage(source: source);

      if(imageTaken != null){
        setState(() {
          images.add(File(imageTaken.path));
        });
      }
    }
  }

  void imageSourceBottomSheet(BuildContext context){
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context){
          return SafeArea(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text("Galeri"),
                    onTap: (){
                      Navigator.of(context).pop();
                      pickImages(ImageSource.gallery);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.camera_alt),
                    title: const Text("Kamera"),
                    onTap: (){
                      Navigator.of(context).pop();
                      pickImages(ImageSource.camera);
                    },
                  )
                ],
              ),
          );
        },
        );
  }

  void saveProduct(){

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainPink,
        scrolledUnderElevation: 0.0,
        title: const Text("Yeni Ürün Ekleme"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              "Ürün resmi ekleyiniz",
              style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: ()=>imageSourceBottomSheet(context),
              child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  color: Colors.grey[200],
                ),
                child: Center(
                  child: Icon(
                    Icons.add_a_photo,
                    size: 50,
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            images.isNotEmpty
                ? Wrap(
              spacing: 8,
              runSpacing: 8,
              children: images.map((image) {
                return Stack(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Image.file(
                        image,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            images.remove(image);
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
              }).toList(),
            )
                : const Text('Henüz fotoğraf eklenmedi',style: TextStyle(fontSize: 18),),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration:  InputDecoration(
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
                decoration:  InputDecoration(
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
              decoration:  InputDecoration(
                labelText: 'Ürün Fiyatı',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: locationController,
              decoration:  InputDecoration(
                labelText: 'Adres',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedCategory,
              hint: const Text('Ürün Kategorisi'),
              items: categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
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
              child: const Text('Ürünü Kaydet',style: TextStyle(fontSize: 16),),
            ),
          ],
        ),
      ),
    );
  }
}
