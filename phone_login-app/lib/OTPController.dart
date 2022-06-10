import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:phone_login/homeScreen.dart';
import 'package:pinput/pinput.dart';



class OTPControllerScreen extends StatefulWidget {
  final String phone;
  final String codeDigits;
  
  OTPControllerScreen({required this.phone, required this.codeDigits});
  

  @override
  State<OTPControllerScreen> createState() => _OTPControllerScreenState();
}

class _OTPControllerScreenState extends State<OTPControllerScreen> {
  final GlobalKey<ScaffoldState> _scaffolkey = GlobalKey<ScaffoldState>();
  final TextEditingController _pinOTPCodeControllar = TextEditingController();
  final FocusNode _pinOTPcodeFocus = FocusNode();
  String? verificationCode;

  final BoxDecoration _pinOTPCodeDecoration = BoxDecoration(
      color: Colors.blueAccent,
      borderRadius: BorderRadius.circular(10.0),
      border: Border.all(
        color: Colors.grey,
      ));

    @override
      void initState() {
        super.initState();

        verifyPhoneNumber();
      
      }

      verifyPhoneNumber() async{
         await FirebaseAuth.instance.verifyPhoneNumber(
           phoneNumber: "${widget.codeDigits + widget.phone}",
           verificationCompleted: (PhoneAuthCredential credential) async
           {
             await FirebaseAuth.instance.signInWithCredential(credential).then((value){
                if(value.user != null){
                       Navigator.of(context).push(MaterialPageRoute(builder: (c)=> HomeScreen() ));
                     }
             });
           },
           verificationFailed: (FirebaseException e)
           {
             ScaffoldMessenger.of(context).showSnackBar(
                     SnackBar(
                       content: Text(e.message.toString()),
                       duration: Duration(seconds: 3),
                       ),
                     );
           },
           codeSent: (String vID, int? resentToken)
           {
             setState(() {
               verificationCode = vID;
             });
           },
           codeAutoRetrievalTimeout: (String  vID)
           {
             setState(() {
               verificationCode = vID;
             });
           },
           timeout: Duration(seconds: 60),
         );
      }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffolkey,
      appBar: AppBar(
        title: Text("OTP verification"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset("images/otp.png"),
          ),

          Container(
            margin: EdgeInsets.only(top: 20),
            child: Center(
              child: GestureDetector(
                onTap: () {
                  verifyPhoneNumber();
                },
                child: Text(
                  "Verifying : ${widget.codeDigits}-${widget.phone}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ),
          
          Padding(
            padding: EdgeInsets.all(40.0),
            child: Pinput(
               focusNode: _pinOTPcodeFocus,
               controller: _pinOTPCodeControllar,
               onSubmitted: (pin) async
               {
                 try{
                   await FirebaseAuth.instance
                   .signInWithCredential(PhoneAuthProvider
                   .credential(verificationId: verificationCode!, smsCode: pin))
                   .then((value) {
                     if(value.user != null){
                       Navigator.of(context).push(MaterialPageRoute(builder: (c)=> HomeScreen() ));
                     }
                   });
                   
                 }
                 catch(e){
                   FocusScope.of(context).unfocus();
                   ScaffoldMessenger.of(context).showSnackBar(
                     SnackBar(
                       content: Text("Invalid OTP"),
                       duration: Duration(seconds: 3),
                       ),
                     );
                 }
               },
              
            ),
            )
          // /
        ],
      ),
    );
  }
}
