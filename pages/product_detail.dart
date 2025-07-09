
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:shopping_app/services/constant.dart';
import 'package:shopping_app/services/database.dart';
import 'package:shopping_app/services/shared_pref.dart';
import 'package:shopping_app/widget/support_widget.dart';
import 'package:http/http.dart'as http;


class ProductDetail extends StatefulWidget {
  String image, name, detail, price;
  ProductDetail(
    {super.key,  required this.detail,
    required this.image,
    required this.name,
    required this.price});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
String? name, mail;

getthesharedpref()async{
  name= await SharedPreferenceHelper().getUserName();
  mail= await SharedPreferenceHelper().getUserEmail();
  
  setState(() {
    
  });
}

ontheload()async{
  await getthesharedpref();
  setState(() {
    
  });
}

@override
  void initState(){
    super.initState();
    ontheload();
  }


  Map<String, dynamic>? paymentIntent;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFfef5f1),
      body: Container(
        padding: EdgeInsets.only(top: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        Stack(
          children: [ GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              margin: EdgeInsets.only(left: 20.0),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(border: Border.all(),borderRadius: BorderRadius.circular(30)),
              child: Icon(Icons.arrow_back_ios_new_outlined)),
          ),

          Center(
            child: Image.network(
            widget.image, 
            height: 400,
            width: 250,
           
        ))

        ]  ),
        Expanded(
          child: Container(
            padding: EdgeInsets.only(top: 20.0, left: 20.0,right: 20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
            ),
            width: MediaQuery.of(context).size.width, child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(widget.name, style: AppWidget.boldTextFeildStyle()),
                    Text("\$${widget.price}",
                     style: TextStyle(
                      color: Color(0xFF6347A5),
                       fontSize: 23.0,
                       fontWeight: FontWeight.bold))
                  ],
                ),
                SizedBox(height: 20.0,),
                Text("Details", style: AppWidget.semiboldTextFeildStyle(),),
                SizedBox(height: 10.0,),
                Text(widget.detail),
                SizedBox(height: 90.0,),
                GestureDetector(
                  onTap: () {
                    makePayment(widget.price);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical:  10.0),
                    decoration: BoxDecoration(
                     color:  Color(0xFF6347A5), borderRadius: BorderRadius.circular(10)
                    ),
                    width: MediaQuery.of(context).size.width,
                    child: Center(child: Text("Buy Now", style: TextStyle(color: Colors.white, fontSize: 20.0 , fontWeight: FontWeight.bold), )),
                    ),
                )
              ],
            ),),
        ),

      ],),),
    );
  }


  Future<void> makePayment(String amount)async{
    try{
      paymentIntent= await createPaymentIntent(amount, 'USD');
      await Stripe.instance.initPaymentSheet(paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: paymentIntent?['client_secret'],
        style:ThemeMode.dark,merchantDisplayName: 'Thashreef'
      )).then((value) {});
      displayPaymentSheet();
    }
    catch(e,s){
      print('exception:$e$s');
    }
  }
  
  displayPaymentSheet()async{
    try{
      await Stripe.instance.presentPaymentSheet().then((value) async{
        Map<String, dynamic> orderInfoMap={
          "Product": widget.name,
          "Price": widget.price,
          "Name": name,
          "Email": mail,

          "ProductImage":widget.image,
          "Status": "On the Way!"

        };
        await DatabaseMethods().orderDetails(orderInfoMap);
        // ignore: use_build_context_synchronously
        showDialog(context: context, builder: (_)=> AlertDialog(
          content: Column(mainAxisSize: MainAxisSize.min,
          children: [Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green,),
              Text("Payment Successfully")
            ],
          )],
          ),
        ));
        paymentIntent=null;
      }).onError((error, stackTrace){
        print("Error is :---> $error $stackTrace");
      });
    } on StripeException catch(e){
      print("Error is :---> $e");
      showDialog(context: context, builder: (_)=> AlertDialog(
        content: Text("Cancelled")
      ));
    } catch(e){
      print('$e');
    }
  }

  createPaymentIntent(String amount, String currency)async{
    try{
      Map<String, dynamic> body={
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]':'card'
      };

      var response = await http.post(
       Uri.parse('https://api.stripe.com/v1/payment_intents'),
       headers: {
        'Authorization': 'Bearer $secretkey',
        'Content-Type': 'application/x-www-form-urlencoded',
          },body: body,
          );
          return jsonDecode(response.body);
    } catch(err){
      print('err charging user: ${err.toString()}');
    }
  }

  calculateAmount(String amount){
    final calculatedAmount=(int.parse(amount) * 100);
    return calculatedAmount.toString();
  }
}