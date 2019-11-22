import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String id;
  final db = Firestore.instance;
  final _formKey = GlobalKey<FormState>();
  String name;

  void createData() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      DocumentReference ref = await db
          .collection("CRUD")
          .add({'name': '$name 👌', 'todo': randomTodo()});
      setState(() => id = ref.documentID);
      print(ref.documentID);
    }
  }

  void readData() async {
    DocumentSnapshot snapshot = await db.collection('CRUD').document(id).get();
    print(snapshot.data);
  }

  void updateData(DocumentSnapshot doc) async {
    await db
        .collection('CRUD')
        .document(doc.documentID)
        .updateData({'todo': 'You can not update dare !!! '});
  }

  void deleteData(DocumentSnapshot doc) async {
    await db.collection("CRUD").document(doc.documentID).delete();
    setState(() => id = null);
  }

  String randomTodo() {
    final randomNumber = Random().nextInt(11);
    String todo;
    switch (randomNumber) {
      case 1:
        todo = "Go and dance in fromt of class";
        break;
      case 2:
        todo = "Say I love you loudly";
        break;
      case 3:
        todo = "Call You friend to go date with you";
        break;
      case 4:
        todo = "Close your eyes and write your name";
        break;
      case 5:
        todo = "Open your instagram and show your first message";
        break;
      case 6:
        todo = "Go and wash your face";
        break;
      case 7:
        todo = "Do some code in flutter";
        break;
      case 8:
        todo = "Take a nap for 5 minutes";
        break;
      case 9:
        todo = "Ask for Holiday for tomorrow to Surya Sir";
        break;
      case 10:
        todo = "Kiss your friends hand who is near to you";
        break;
    }
    return todo;
  }

  Card buildItem(DocumentSnapshot doc) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Name : ${doc.data['name']}',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              'Dare : ${doc.data['todo']}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FlatButton(
                  onPressed: () => updateData(doc),
                  child: Text(
                    "Update",
                    style: TextStyle(fontSize: 16),
                  ),
                  color: Colors.green[400],
                ),
                SizedBox(
                  width: 8,
                ),
                FlatButton(
                  onPressed: () => deleteData(doc),
                  child: Text(
                    "Delete",
                    style: TextStyle(fontSize: 16),
                  ),
                  color: Colors.red[400],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    TextFormField buildTextFormField() {
      return TextFormField(
        decoration: InputDecoration(
          hintText: "name",
          border: InputBorder.none,
          fillColor: Colors.grey[200],
          filled: true,
        ),
        validator: (value) {
          if (value.isEmpty) {
            return "Please Enter Some Text";
          }
        },
        onSaved: (value) => name = value,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Dare App"),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(10),
        children: <Widget>[
          Form(
            key: _formKey,
            child: buildTextFormField(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RaisedButton(
                color: Colors.green,
                onPressed: createData,
                child: Text(
                  "Dare",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              // RaisedButton(
              //   color: Colors.blue,
              //   onPressed: readData,
              //   child: Text(
              //     "Read",
              //     style: TextStyle(fontSize: 15),
              //   ),
              // )
            ],
          ),
          StreamBuilder<QuerySnapshot>(
            stream: db.collection('CRUD').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                    children: snapshot.data.documents
                        .map((doc) => buildItem(doc))
                        .toList());
              } else {
                return SizedBox();
              }
            },
          )
        ],
      ),
    );
  }
}
