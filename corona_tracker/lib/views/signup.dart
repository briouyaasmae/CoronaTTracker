import 'dart:core';
import 'dart:async';
import 'dart:io';
import 'package:country_codes/country_codes.dart';
import 'package:flutter/material.dart';
import 'package:corona_tracker/views/login.dart';
import 'package:country_provider/country_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:password/password.dart';
import 'package:geolocator/geolocator.dart';

final backgroundColor=const Color(0xFFf4f4f6);
class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup>  {

  var countries;
  final firestoreInstance = Firestore.instance;
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _username= TextEditingController();
  String _value;
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Position _currentPosition;
  String _currentAddress;
  Future<List<Country>> getCountries() async {
    return countries= await  CountryProvider.getAllCountries();

  }
  Future<void> validate(BuildContext context) async {
    if (formKey.currentState.validate()) {
      int count=0;
     /* geolocator
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
          .then((Position position) async {
        _currentPosition = position;

          List<Placemark> p = await geolocator.placemarkFromCoordinates(
              _currentPosition.latitude, _currentPosition.longitude);

          Placemark place = p[0];

          setState(() {
            _currentAddress = place.country;
          });
      });*/
      var data = Firestore.instance
          .collection('users')
          .getDocuments().then((querySnapshot) {
        querySnapshot.documents.forEach((result) {
          if (result.data['email'] == _email.text) {
            count++;
          }
        });
            if(count==0) {
              firestoreInstance.collection("users").add(
                  {
                    "username": _username.text,
                    "email": _email.text,
                    "password": Password.hash(_pass.text, new PBKDF2())
                        .toString(),
                    "country": _value,
                  }
              ).then((_) {
                return showDialog<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Done'),
                      content: const Text('Welcome to corona tracker'),
                      actions: <Widget>[
                        FlatButton(
                          child: Text('Ok'),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Login()),
                            );
                          },
                        ),
                      ],
                    );
                  },
                );
                    });

            }
          else {
              return showDialog<void>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Account exists'),
                    content: const Text('There is an account with this email ,try to login'),
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
        });

    }
      else{
            return Text("form is invalid");
            }
       return null;
        }


  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
      color: backgroundColor,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,

          child:Padding(
              padding: const EdgeInsets.only(top:20),
         child: SafeArea(
        child:Center(
        child:ListView(

          children: <Widget>[
            Align(
              alignment: Alignment.center,
            child:Text(
                "Sign up to track corona virus",
                style:TextStyle(
                  color:const Color(0xFF272343),
                  fontSize:20,
                  decoration : null,
                  fontWeight: FontWeight.bold,

                )
            ),
          ),
             Form(
               key: formKey,
               child:Padding(
                   padding: const EdgeInsets.only(top:40),

                   child: Column(

                       children: <Widget>[
         TextFormField(

                   style: TextStyle(color: const Color(0xFF272343)),

           validator: (value)=>value.isEmpty?"Username can\'t be empty":null,
           controller: _username,

    decoration: new InputDecoration(
                     labelText: 'Enter your Username',

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

                         TextFormField(
                           style: TextStyle(color: const Color(0xFF272343)),
                           validator: (value)=>value.isEmpty?"Email can\'t be empty":null,
                           controller: _email,
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
                               border: UnderlineInputBorder()),
                           keyboardType: TextInputType.emailAddress,
                         ),
                         TextFormField(
                           style: TextStyle(color: const Color(0xFF272343)),
                           controller: _pass,
                           validator:(value){
                             Pattern pattern =
                                 r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])';
                             RegExp regex = new RegExp(pattern);
                             if(value.length<=7){
                               return "Password can\'t be less than 8 caractere";
                             }
                             else {
                               if (!regex.hasMatch(value))
                                 return 'Uppercase and lowercase ,numbers are required';
                               else
                                 return null;
                             }
                           },
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
                         TextFormField(
                           style: TextStyle(color: const Color(0xFF272343)),
                           controller: _confirmPass,
                           obscureText: true,
                           validator:(value){
                             if(value.isEmpty){
                               return "Password can\'t be empty";
                             }
                             if(value!=_pass.text){
                               return "Verifie your password";
                             }
                             return null;
                           },
                         decoration: new InputDecoration(
                               labelText: 'Confirm your password',
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

             FutureBuilder<List<Country>>(
                 future: getCountries(),
                 builder: (context, snapshot) {
                   if (snapshot.connectionState != ConnectionState.done) {
                     // return: show loading widget
                   }
                   if (snapshot.hasError) {
                     // return: show error widget
                   }
                   List<Country> users = snapshot.data ?? [];

                   return  DropdownButtonFormField<dynamic>(
                     isDense: false,
                     isExpanded: true,
                     hint: new Text("Select Country"),
                     value: _value ,
                     items: users.map((var value) {
                       return new DropdownMenuItem<dynamic>(
                         value: value.name,
                         child: new Text(value.name),

                       );
                     }).toList(),
                     onChanged: (value) {
                       setState(() {
                        _value=value;
                       });
                     },
                     validator: (value) {
                       if (value?.isEmpty ?? true) {
                         return 'Please enter a valid Country';
                       }
                       return null;
                     },
                   );
                 }),

              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: RaisedButton(
                    onPressed: () {
                      validate(context);
                    },
                  // Validate returns true if the form is valid, otherwise false.
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
                        child: const Text('Submit', style: TextStyle(fontSize: 15)),
                      ),
                    )





                ),

              ),

                         Padding(
                           padding: const EdgeInsets.only(left:48,top:20.0),

                        child: Row(

                             children: <Widget>[

                             Text(
                                "if you already have an account"
                              ),
                             GestureDetector(
                           onTap: () {
                             Navigator.push(
                               context,
                               MaterialPageRoute(builder: (context) => Login()),
                             );
                           },

                           child: Text(
                             "Sign in",
                             style: TextStyle(
                               decoration: TextDecoration.underline,
                               color: Colors.blue,
                             ),
                           ),
                         ),
                         ]
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
