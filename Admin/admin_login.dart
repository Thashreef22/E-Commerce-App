import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/Admin/home_admin.dart';
import 'package:shopping_app/widget/support_widget.dart';


class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {

  TextEditingController usernamecontroller= TextEditingController();
  TextEditingController userpasswordcontroller= TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 10.0,left: 20.0 , right: 20.0, bottom: 40.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                    
              Image.asset("images/login.png"),
              Center(
                child: 
                Text("Admin Panel",
                 style: AppWidget.semiboldTextFeildStyle(),
                ),
              ),
              SizedBox(height: 20.0,),
              
              Text("Username" ,
               style:  AppWidget.semiboldTextFeildStyle(),
              ),
              SizedBox(height: 20.0,),
              Container(
                padding: EdgeInsets.only(left: 20.0),
                decoration: BoxDecoration(color: Color(0xFFE3E8EC), borderRadius: BorderRadius.circular(10)),
                child: TextFormField(
                 
                  controller: usernamecontroller,
                  decoration: InputDecoration(border: InputBorder.none, hintText: "Username"),
                ),
              ),
              SizedBox(
                height: 20.0,
                
                ),
              
              Text("Password" ,
               style:  AppWidget.semiboldTextFeildStyle(),
              ),
              SizedBox(height: 20.0,),
              Container(
                padding: EdgeInsets.only(left: 20.0),
                decoration: BoxDecoration(color: Color(0xFFE3E8EC), borderRadius: BorderRadius.circular(10)),
                child: TextFormField(
                  obscureText: true,
                  
                  controller: userpasswordcontroller,
                  decoration: InputDecoration(border: InputBorder.none, hintText: "Password"),
                ),
              ),
             
              SizedBox(height: 30.0,),
              GestureDetector(
                onTap: () {
                  loginAdmin();
                },
                child: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width/2,
                    padding: EdgeInsets.all(18),
                    decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(10)),
                    child: Center(child: Text("LOGIN" , style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold),)),
                  ),
                ),
              ),
              SizedBox(height: 20.0,),
              
            ],
            ),
          ),
        ),
      );
    
  
  }

  loginAdmin(){
    FirebaseFirestore.instance.collection("Admin").get().then((snapshot){
      for (var result in snapshot.docs) {
        if(result.data()['username']!=usernamecontroller.text.trim()){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text("Your id is not Correct", style: TextStyle(fontSize: 20.0),)));
        }
        else if(result.data()['password']!=userpasswordcontroller.text.trim()){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text("Password is not Correct", style: TextStyle(fontSize: 20.0),)));
        }
        else
        {
          Navigator.push(context, MaterialPageRoute(builder: (context)=> HomeAdmin()));
        }

      } 
    });
  }

}