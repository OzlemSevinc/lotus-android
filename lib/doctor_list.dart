import 'package:flutter/material.dart';
import 'package:lotus/service/doctor_service.dart';
import 'colors.dart';
import 'doctor_page.dart';
import 'entity/doctor_entity.dart';

class DoctorList extends StatefulWidget {
  const DoctorList({super.key});

  @override
  State<DoctorList> createState() => _DoctorListState();
}

class _DoctorListState extends State<DoctorList> {
 List<Doctor> doctors=[];
 List<DoctorCategory> categories = [];
 final DoctorService doctorService = DoctorService(baseUrl: 'https://lotusproject.azurewebsites.net/api/');
 bool isLoading = true;

 String? searchQuery;
 int? selectedCategoryId;
 bool? sortByAlphabetical;
 bool? sortByAlphabeticalDescending;
 int? pageNumber ;
 int? pageSize =100;

 @override
 void initState() {
   super.initState();
   fetchCategories();
   fetchDoctors();
 }

 Future<void> fetchCategories() async {
   try {
     final fetchedCategories = await doctorService.fetchDoctorCategories();
     setState(() {
       categories = fetchedCategories;
     });
   } catch (e) {
     ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(content: Text('Kategoriler yüklenemedi: $e')),
     );
   }
 }

 Future<void> fetchDoctors() async {
   setState(() {
     isLoading = true;
   });

   try {
     final fetchedDoctors = await doctorService.fetchAndFilterDoctors(
       doctorCategoryId: selectedCategoryId,
       sortByAlphabetical: sortByAlphabetical,
       sortByAlphabeticalDescending: sortByAlphabeticalDescending,
       pageNumber: pageNumber,
       pageSize: pageSize,
     );
     setState(() {
       doctors = fetchedDoctors;
       isLoading = false;
     });
   } catch (e) {
     setState(() {
       isLoading = false;
     });
     ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(content: Text('Doktorlar yüklenemedi: $e')),
     );
   }
 }

 Future<void> searchDoctors() async {
   setState(() {
     isLoading = true;
   });

   try {
     final searchedDoctors = await doctorService.searchDoctors(searchQuery ?? '');
     setState(() {
       doctors = searchedDoctors;
       isLoading = false;
     });
   } catch (e) {
     setState(() {
       isLoading = false;
     });
     print(e);
     ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(content: Text('Arama başarısız: $e')),
     );
   }
 }

 void showFilterDialog(BuildContext context) {
   showModalBottomSheet(
     context: context,
     isScrollControlled: true,
     builder: (BuildContext context) {
       return StatefulBuilder(
         builder: (BuildContext context, StateSetter setState) {
           return Container(
             padding: const EdgeInsets.all(16.0),
             height: MediaQuery.of(context).size.height * 0.4,
             child: Wrap(
               children: [
                 Column(
                   mainAxisSize: MainAxisSize.min,
                   children: [
                     DropdownButton<int>(
                       hint: Text("Kategori seçiniz"),
                       value: selectedCategoryId,
                       onChanged: (int? value) {
                         setState(() {
                           selectedCategoryId = value;
                         });
                       },
                       items: categories.map((category) {
                         return DropdownMenuItem(
                           child: Text(category.name),
                           value: category.id,
                         );
                       }).toList(),
                       isExpanded: true,
                     ),
                     SizedBox(height: 32.0),
                     SizedBox(
                       width: double.infinity,
                       child: ElevatedButton(
                         onPressed: () {
                           Navigator.pop(context);
                           fetchDoctors();
                         },
                         child: Text("Uygula"),
                       ),
                     ),
                   ],
                 ),
               ],
             ),
           );
         },
       );
     },
   );
 }

 void showSortDialog(BuildContext context) {
   showModalBottomSheet(
     context: context,
     isScrollControlled: true,
     builder: (BuildContext context) {
       return StatefulBuilder(
         builder: (BuildContext context, StateSetter setState) {
           return Container(
             padding: const EdgeInsets.all(16.0),
             child: Wrap(
               children: [
                 Column(
                   mainAxisSize: MainAxisSize.min,
                   children: [
                     ListTile(
                       title: Text("Alfabetik Sırala (A-Z)"),
                       leading: Radio<bool>(
                         value: true,
                         groupValue: sortByAlphabetical,
                         onChanged: (bool? value) {
                           setState(() {
                             sortByAlphabetical = value;
                             sortByAlphabeticalDescending = false;
                           });
                         },
                       ),
                     ),
                     ListTile(
                       title: Text("Alfabetik Sırala (Z-A)"),
                       leading: Radio<bool>(
                         value: true,
                         groupValue: sortByAlphabeticalDescending,
                         onChanged: (bool? value) {
                           setState(() {
                             sortByAlphabetical = false;
                             sortByAlphabeticalDescending = value;
                           });
                         },
                       ),
                     ),
                     SizedBox(height: 16.0),
                     SizedBox(
                       width: 400,
                       child: ElevatedButton(
                         onPressed: () {
                           Navigator.pop(context);
                           fetchDoctors();
                         },
                         child: Text("Uygula"),
                       ),
                     ),
                   ],
                 ),
               ],
             ),
           );
         },
       );
     },
   );
 }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainPink,
        scrolledUnderElevation: 0.0,
      ),
      body: Column(
        children: <Widget>[
          _searchBar(context),
          filterAndSortButtons(),
          isLoading
              ? Center(child: CircularProgressIndicator())
              :Expanded(
              child: _buildHorizontalListView(
                  context, resim: "resimler/lotus_resim.png", items: doctors)
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalListView(BuildContext context,
      { required String resim, required List<Doctor> items}) {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          final doctor = items[index];
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => DoctorPage(doctor: doctor),
                ),
              );
            },
            child: Card(
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.network(
                      doctor.image.isNotEmpty ? doctor.image : 'resimler/lotus_resim.png',
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                      errorBuilder: (context,error,stackTrace){
                        return Image.asset(resim, width: 150,height: 150, fit: BoxFit.cover);
                      },
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${doctor.name} ${doctor.surname}' ,
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Açıklama: ${doctor.information ?? 'Açıklama Yok'}",
                            style: TextStyle(fontSize: 16),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

 Widget _searchBar(BuildContext context) {
   return Container(
     color: mainPink,
     padding: const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
     child: SearchAnchor(
         builder: (BuildContext context, SearchController controller) {
           controller.text=searchQuery ?? '';
           return SearchBar(
             controller: controller,
             padding: const MaterialStatePropertyAll<EdgeInsets>(
                 EdgeInsets.symmetric(horizontal: 16.0)),
             onTap: () {
             },
             onChanged: (value) {
               setState(() {
                 searchQuery=value;
               });
             },
             onSubmitted: (value){
               searchDoctors();
             },
             leading: const Icon(Icons.search),
           );
         }, suggestionsBuilder:
         (BuildContext context, SearchController controller) {
       return [];
     }),
   );
 }

 Widget filterAndSortButtons() {
   return Padding(
     padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
     child: Row(
       mainAxisAlignment: MainAxisAlignment.spaceBetween,
       children: [
         SizedBox(
           width: MediaQuery.of(context).size.width * 0.4,
           child: ElevatedButton.icon(
             onPressed: () => showFilterDialog(context),
             icon: Icon(Icons.filter_list),
             label: Text("Filtrele"),
             style: ElevatedButton.styleFrom(
               primary: mainPink,
               onPrimary: Colors.white,
             ),
           ),
         ),
         SizedBox(
           width: MediaQuery.of(context).size.width * 0.4,
           child: ElevatedButton.icon(
             onPressed: () => showSortDialog(context),
             icon: Icon(Icons.sort),
             label: Text("Sırala"),
             style: ElevatedButton.styleFrom(
               primary: mainPink,
               onPrimary: Colors.white,
             ),
           ),
         ),
       ],
     ),
   );
 }
}