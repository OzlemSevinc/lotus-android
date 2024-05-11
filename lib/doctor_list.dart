import 'package:flutter/material.dart';
class DoctorList extends StatefulWidget {
  const DoctorList({super.key});

  @override
  State<DoctorList> createState() => _DoctorListState();
}

class _DoctorListState extends State<DoctorList> {
  var doctorList=["Doktor1","Doktor2","Doktor3","Doktor4","Doktor5","Doktor6","Doktor7"];
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
Widget _buildHorizontalListView(BuildContext context,{ required String resim, required List<String> items}) {
  return SizedBox(
    height: MediaQuery.of(context).size.height*0.93,
    child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
              child: Row(
                children: [
                  SizedBox(width:150,height:150,child: Image.asset(resim),),
                  Text(items[index]),
                ],
              )
          );
        }
    ),
  );
}