import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:phone_login/loginScreen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Home Screen",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body:Column(
        mainAxisAlignment : MainAxisAlignment.center,
        children: [
          Image.asset("images/welcome.jpg"),

          Container(
            margin: EdgeInsets.all(65),
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.red
              ),
              onPressed: (){
                FirebaseAuth.instance.signOut();
                Navigator.of(context).push(MaterialPageRoute(builder: (c) => LoginScreen()));
              },
              child: Text('Logout',style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),),
            ),
          )
        ],
      ),
    );
  }
}

