import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:corona_tracker/views/signup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:password/password.dart';
import 'package:corona_tracker/views/Home.dart';

final backgroundColor=const Color(0xFFf4f4f6);

class Login extends StatefulWidget {
  @override
  _State createState() => _State();
}


class _State extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _email = TextEditingController();
  Future<void> validate(BuildContext context) async {
   int count = 0;
   if (_formKey.currentState.validate()) {
    var data = Firestore.instance
        .collection('users')
        .getDocuments().then((querySnapshot) {
     querySnapshot.documents.forEach((result) {
      if (result.data['email'] == _email.text &&
          result.data['password'] == Password.hash(_pass.text, new PBKDF2())
              .toString()) {
       count++;
      }
     });
     if (count == 0) {
      return showDialog<void>(
       context: context,
       builder: (BuildContext context) {
        return AlertDialog(
         title: Text('Warning'),
         content: const Text('Verifie your email or password'),
         actions: <Widget>[
          FlatButton(
           child: Text('Ok'),
           onPressed: () {
            Navigator.of(context).pop();
           },
          ),
         ],
        );
       },
      );
     }
     else {
      Navigator.push(
       context,
       MaterialPageRoute(builder: (context) => Home()),
      );
     }
    });
   }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

     body: Container(
       color: backgroundColor,
       height: MediaQuery.of(context).size.height,
       width: MediaQuery.of(context).size.width,
       child:SafeArea(




    child:Padding(
    padding: const EdgeInsets.only(top:20),
    child: SafeArea(
    child:ListView(

    children: <Widget>[
    Align(
    alignment: Alignment.center,
   child:Row(

    children: <Widget>[

     GestureDetector(
      onTap: () {
       Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Signup()),
       );
      },

      child:  Icon(
       Icons.arrow_back,
       color: Colors.blue,
       size: 24.0,
      ),
     ),
    Text(
    "      Sign in to your account",

    style:TextStyle(
    color:const Color(0xFF272343),
    fontSize:20,
    decoration : null,
    fontWeight: FontWeight.bold,

    )
    ),
    ]
       ),
     ),
    Form(
     key: _formKey,
    child:Padding(
    padding: const EdgeInsets.only(top:70),

    child: Column(

    children: <Widget>[

    TextFormField(
    style: TextStyle(color: const Color(0xFF272343)),
    controller: _email,
     validator: (value)=>value.isEmpty?"Email can\'t be empty":null,

     decoration: new InputDecoration(
    labelText: 'Enter your Email',
    enabledBorder: UnderlineInputBorder(
    borderSide:
    BorderSide(color: Colors.grey),
    ),
    focusedBorder: UnderlineInputBorder(
    borderSide:
    BorderSide(color: Colors.amber),
    ),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    keyboardType: TextInputType.emailAddress,
    ),
    TextFormField(
    style: TextStyle(color: const Color(0xFF272343)),
    controller: _pass,
     validator: (value)=>value.isEmpty?"Password can\'t be empty":null,
     obscureText: true,
    decoration: new InputDecoration(
    labelText: 'Enter your Password',
    enabledBorder: UnderlineInputBorder(
    borderSide:
    BorderSide(color: Colors.grey),
    ),
    focusedBorder: UnderlineInputBorder(
    borderSide:
    BorderSide(color: Colors.amber),
    ),
    border: UnderlineInputBorder()),
    ),

    Padding(
    padding: const EdgeInsets.only(top: 20.0),
    child: RaisedButton(
    onPressed: () {
    // Validate returns true if the form is valid, otherwise false.
    validate(context);
    },
    textColor: Colors.white,
    padding: const EdgeInsets.all(0.0),
    child: Container(
    decoration: const BoxDecoration(
    gradient: LinearGradient(
    colors: <Color>[
    Colors.blue,
    Colors.green,
    Colors.amber,
    ],
    ),
    borderRadius: BorderRadius.all(
    const Radius.circular(10.0),
    ),
    ),

    padding: const EdgeInsets.all(10.0),
    child:
    Align(
    alignment: Alignment.center,
    child: const Text('Login', style: TextStyle(fontSize: 15)),
    ),
    )


    ),


    ),
    ]
    ),
    ),
    )


    ]
    )

    )

    ),
    ),
    ),
    );
  }
}
