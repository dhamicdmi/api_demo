

import 'dart:convert';
import 'dart:io';

import 'package:api_demo/view_data.dart';
// import 'package:api_project_server/view_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
// import 'package:image_picker/image_picker.dart';

void main()
{
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: data_add(),
  ));
}
class data_add extends StatefulWidget {
  final l;
  data_add([this.l]);

  // const data_add({super.key});

  @override
  State<data_add> createState() => _data_addState();
}

class _data_addState extends State<data_add> {

  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();
  TextEditingController t3 = TextEditingController();
  final ImagePicker picker = ImagePicker();

  XFile? photo;
  String new_image = "";
  bool t = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.l!=null)
    {
      t1.text = widget.l['name'];
      t2.text = widget.l['contact'];
      t3.text = widget.l['city'];
      new_image = widget.l['image'];
      print("new_image : ${new_image}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: (widget.l!=null)?Text("UPDATE DATA"):Text("ADD DATA"),
          centerTitle: true,
        ),
        body: Column(children: [
          TextField(
            controller: t1,
            decoration: InputDecoration(
                label: Text("Name"),
                border: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                )
            ),
          ),
          TextField(
            controller: t2,
            decoration: InputDecoration(
                label: Text("Contact"),
                border: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                )
            ),
          ),
          TextField(
            controller: t3,
            decoration: InputDecoration(
                label: Text("City"),
                border: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                )
            ),
          ),
          SizedBox(height: 50,),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [
            Container(
              width: 100,height: 100,
              color: Colors.grey,
              child: (t)?(photo!=null)?Image.file(fit: BoxFit.fill,File(photo!.path)):null:(new_image!="")?Image.network("https://syflutterdata.000webhostapp.com/${new_image}"):null,
              // child: (photo!=null)?Image.file(fit: BoxFit.fill,File(photo!.path)):null,
            ),
            Text("  "),
            ElevatedButton(onPressed: () {
              showDialog(context: context, builder: (context) {
                return AlertDialog(
                  title: Text("Choose any one"),
                  actions: [
                    TextButton(onPressed: () async {
                      photo = await picker.pickImage(source: ImageSource.camera);
                      print(photo);
                      t=true;
                      Navigator.pop(context);
                      setState(() { });
                    }, child: Text("Camera")),
                    TextButton(onPressed: () async {
                      photo = await picker.pickImage(source: ImageSource.gallery);
                      print(photo);
                      t=true;
                      Navigator.pop(context);
                      setState(() { });
                    }, child: Text("Gallery"))
                  ],
                );
              },);
            },
                child: Text("Choose")),
          ],),
          SizedBox(height: 50,),
          ElevatedButton(onPressed: () async {

            String name=t1.text;
            String contact=t2.text;
            String city=t3.text;
            String image;
            // if (photo != null) {
            image = base64Encode(await photo!.readAsBytes());
            // Rest of your code...
            // image = base64Encode(await photo!.readAsBytes());
            var url;

            if (widget.l != null) {
              print("update this data");
              print(name);
              print(contact);
              print(photo!.name);
              url = Uri.parse('https://syflutterdata.000webhostapp.com/new1.php?name=$name&contact=$contact&city=$city&image=${photo!.name}&id=${widget.l['id']}');
            }
            else {
              // url = Uri.parse('https://projectofflutter.000webhostapp.com/api_data.php?name=$name&contact=$contact&city=$city');//get methode
              url = Uri.parse(
                  'https://syflutterdata.000webhostapp.com/new1.php'); //post methode
            }

            // var response = await http.get(url); //get methode
            var response = await http.post(
                url,
                body: {
                  'name': '$name',
                  'contact': '$contact',
                  'city': '$city',
                  'image': '$image',
                  'image_name': '${photo!.name}',
                }
            );
            print('Response status: ${response.statusCode}');
            // print('Response body: ${response.body}');
            Map m = jsonDecode(response.body);
            print(m);
            // }
            print("submit");
          }, child: Text("SUBMIT")),
          SizedBox(height: 50,),
          ElevatedButton(onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
              return view_data();
            },));
          }, child: Text("View Data"))
        ]),
        );
    }
}
