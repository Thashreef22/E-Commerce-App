import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/services/database.dart';
import 'package:shopping_app/widget/support_widget.dart';

class AllOrders extends StatefulWidget {
  const AllOrders({super.key});

  @override
  State<AllOrders> createState() => _AllOrdersState();
}

class _AllOrdersState extends State<AllOrders> {
  Stream? orderStream;

  getontheload() async {
    orderStream = await DatabaseMethods().allOrders();
    setState(() {});
  }

  @override
  void initState() {
    getontheload();
    super.initState();
  }

  Widget allOrders() {
    return StreamBuilder(
      stream: orderStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
              padding: EdgeInsets.zero,

              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot ds = snapshot.data.docs[index];

                return Container(
                  margin: EdgeInsets.only(bottom: 20.0),
                  child: Material(
                    elevation: 3.0,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: EdgeInsets.only(
                        left: 10.0,
                        top: 10.0,
                        bottom: 10.0,
                      ),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network(
                            ds["ProductImage"],
                            height: 120,
                            width: 120,
                            fit: BoxFit.cover,
                          ),
                          Spacer(),

                          Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Name: " + ds["Name"],
                                  style: AppWidget.semiboldTextFeildStyle(),
                                ),
                                SizedBox(height: 3.0,),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 2,
                                  child: Text(
                                    "Email : " + ds["Email"],
                                    style: AppWidget.lightTextFeildStyle(),
                                  ),
                                ),
                                SizedBox(height: 3.0,),
                                Text(
                                  ds["Product"],
                                  style: AppWidget.semiboldTextFeildStyle(),
                                ),
                                
                                Text(
                                  "\$" + ds["Price"],
                                  style: TextStyle(
                                    color: Color(0xFFfd6f3e),
                                    fontSize: 23.0,
                                    fontWeight: FontWeight.bold)),
                                    SizedBox(height: 10.0,),

                                    GestureDetector(
                                      onTap: ()async {
                                        await DatabaseMethods().updateStatus(ds.id);
                                        setState(() {
                                          
                                        });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(vertical: 5.0),
                                        width: 150,
                                        decoration: BoxDecoration(color: Color(0xFFfd6f3e), borderRadius: BorderRadius.circular(10)),
                                        child: Center(child: Text("Done", style: AppWidget.semiboldTextFeildStyle(),)),
                                      ),
                                    )
                              ],
                            ),
                          ),


                        ],
                      ),
                    ),
                  ),
                );
              },
            )
            : Container();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("All Orders", style: AppWidget.boldTextFeildStyle()),
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(left: 20.0, right: 20.0),
        child: Column(children: [Expanded(child: allOrders())]),
      ),
    );
  }
}
