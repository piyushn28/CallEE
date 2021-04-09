import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home1 extends StatefulWidget {
  @override
  _HomeState1 createState() => _HomeState1();
}

class _HomeState1 extends State<Home1> {
  final databaseReference = Firestore.instance;

  void createRecord() async {
    await databaseReference.collection("series")
        .document("1")
        .setData({
      'title': 'big bang theory',
      'rating': 8.5
    });

    /*DocumentReference ref = await databaseReference.collection("books")
        .add({
      'title': 'Flutter in Action',
      'description': 'Complete Programming Guide to learn Flutter'
    });
    print(ref.documentID);*/
    getData();
  }

  void getData() {
    databaseReference
        .collection("series")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        print('${f.data}}');
      });
    });
  }

  void updateData() {
    databaseReference
        .collection('series')
        .document('1')
        .updateData({'rating': 9.5})
        .then((val){})
        .catchError((e){
      print(e.toString());
      showDialog(
          context: context,
          builder: (context){
            return AlertDialog(
              title: Text("No data found"),
              actions: <Widget>[
                FlatButton(
                  child: Text("Ok"),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            );
          }
      );
    });
  }

  void deleteData() {
    try {
      databaseReference
          .collection('series')
          .document('1')
          .delete();
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter CS"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text("Create",),
              onPressed: createRecord,
            ),
            RaisedButton(
              child: Text("Update",),
              onPressed: updateData,
            ),
            RaisedButton(
              child: Text("Delete",),
              onPressed: deleteData,
            ),
            SizedBox(height: 10.0,),
            Text("The data will be displayed below once you create it"),
            SizedBox(height: 10.0,),
            StreamBuilder(
              stream: databaseReference.collection("series").snapshots(),
              builder: (context, snapshot){
                if(!snapshot.hasData)
                  return Text("No data");
                List<dynamic> myData = [];
                snapshot.data.documents.forEach((f){
                  myData.add(f.data);
                });
                return Text(myData.length == 0 ? "No data found" : myData.toString());
              },
            ),
          ],
        ),
      ),
    );
  }
}