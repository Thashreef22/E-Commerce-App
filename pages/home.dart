import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopping_app/pages/category_products.dart';
import 'package:shopping_app/pages/product_detail.dart';
import 'package:shopping_app/services/database.dart';
import 'package:shopping_app/services/shared_pref.dart';
import 'package:shopping_app/widget/support_widget.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool search = false;

  List categories = [
    "images/headphone_icon.png",
    "images/laptop.png",
    "images/watch.png",
    "images/TV.png",
  ];

  List Categoryname = ["Headphones", "Laptop", "Watch", "TV"];

  var queryResultSet = [];
  var tempSearchStore = [];
  TextEditingController searchcontroller = TextEditingController();

  initiateSearch(value) {
    if (value.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }

    setState(() {
      search = true;
    });

    if (value.isEmpty) {
  setState(() {
    queryResultSet = [];
    tempSearchStore = [];
  });
  return;
}

var CapitalizedValue = value[0].toUpperCase() + value.substring(1);

if (queryResultSet.isEmpty && value.length == 1) {
  DatabaseMethods().search(value).then((QuerySnapshot docs) {
    setState(() {
      for (int i = 0; i < docs.docs.length; ++i) {
        queryResultSet.add(docs.docs[i].data());
      }
    });
  });
}
 else {
      tempSearchStore=[];
      for (var element in queryResultSet) {
        if ((element['UpdatedName'] as String).startsWith(CapitalizedValue)) {

          setState(() {
            tempSearchStore.add(element);
          });
        }
      }
      
    }
  }

  String? name, image;

  getthesharedpref() async {
    name = await SharedPreferenceHelper().getUserName();
    setState(() {});
  }

  ontheload() async {
    await getthesharedpref();
    setState(() {});
  }

  @override
  void initState() {
    ontheload();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF2F2F2),
      body: name == null? Center(child: CircularProgressIndicator())
              : Container(
                margin: EdgeInsets.only(top: 38.0, left: 20.0, right: 20.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Hey, ${name!}",
                                  style: AppWidget.boldTextFeildStyle(),
                                ),
                    
                                Text(
                                  "Good Morning",
                                  style: AppWidget.lightTextFeildStyle())
                              ],
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                "images/user.png",
                                height: 70,
                                width: 70,
                                fit: BoxFit.cover,
                              ),
                            )
                          ],
                        ),
                    
                        SizedBox(height: 30.0),
                        Container(
                          
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: MediaQuery.of(context).size.width,
                          child: TextField(
                            controller: searchcontroller,
                            onChanged: (value) {
                              initiateSearch(value.toUpperCase());
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Search Products",
                              hintStyle: AppWidget.lightTextFeildStyle(),
                              prefixIcon: search? GestureDetector(
                                onTap: () {
                                  search=false;
                                  tempSearchStore=[];
                                  queryResultSet=[];
                                  searchcontroller.text="";
                                  setState(() {
                                    
                                  });
                                },
                                child: Icon(Icons.close)): Icon(
                                Icons.search, 
                                color: Colors.black)),
                              

                          ),
                        ),
                        SizedBox(height: 20.0),
                        search? ListView(
                              padding: EdgeInsets.only(left: 10.0, right: 10.0),
                              primary: false,
                              shrinkWrap: true,
                              children: tempSearchStore.map((element) {
                                return buildResultCard(element);
                              }).toList(),
                            ): Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 20.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Categories",
                                        style: AppWidget.semiboldTextFeildStyle(),
                                      ),
                                                    
                                      Text(
                                        "See all",
                                        style: TextStyle(
                                          color: Color(0xFF6347A5),
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                           
                    
                        SizedBox(height: 20.0),
                    
                        Row(
                          children: [
                            Container(
                              height: 130,
                              padding: EdgeInsets.all(20),
                              margin: EdgeInsets.only(right: 20.0),
                              decoration: BoxDecoration(
                                color: Color(0xFF6347A5),
                                borderRadius: BorderRadius.circular(10),
                              ),
                    
                              child: Center(
                                child: Text(
                                  "All",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: SizedBox(
                                height: 130,
                                child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  itemCount: categories.length,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return CategoryTitle(
                                      image: categories[index],
                                      name: Categoryname[index],
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "All Products",
                              style: AppWidget.semiboldTextFeildStyle(),
                            ),
                            Text(
                              "See all",
                              style: TextStyle(
                                color: Color(0xFF6347A5),
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.0),
                        SizedBox(
                          height: 240,
                          child: ListView(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: 20.0),
                                padding: EdgeInsets.symmetric(horizontal: 20.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  children: [
                                    Image.asset(
                                      "images/headphone2.png",
                                      height: 150,
                                      width: 150,
                                      fit: BoxFit.cover,
                                    ),
                                    Text(
                                      "HeadPhone",
                                      style: AppWidget.semiboldTextFeildStyle(),
                                    ),
                                    SizedBox(height: 10.0),
                                    Row(
                                      children: [
                                        Text(
                                          "\$100",
                                          style: TextStyle(
                                            color: Color(0xFF6347A5),
                                            fontSize: 22.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(width: 50.0),
                                        Container(
                                          padding: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            color: Color(0xFF6347A5),
                                            borderRadius: BorderRadius.circular(50)),
                                          child: Icon(
                                            Icons.add,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                    
                              Container(
                                margin: EdgeInsets.only(right: 20.0),
                                padding: EdgeInsets.symmetric(horizontal: 20.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  children: [
                                    Image.asset(
                                      "images/watch2.png",
                                      height: 150,
                                      width: 150,
                                      fit: BoxFit.cover,
                                    ),
                                    Text(
                                      "AppleWatch",
                                      style: AppWidget.semiboldTextFeildStyle(),
                                    ),
                                    SizedBox(height: 10.0),
                                    Row(
                                      children: [
                                        Text(
                                          "\$300",
                                          style: TextStyle(
                                            color: Color(0xFF6347A5),
                                            fontSize: 22.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(width: 50.0),
                                        Container(
                                          padding: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            color: Color(0xFF6347A5),
                                            borderRadius: BorderRadius.circular(
                                              50,
                                            ),
                                          ),
                                          child: Icon(
                                            Icons.add,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                    
                              Container(
                                margin: EdgeInsets.only(right: 20.0),
                                padding: EdgeInsets.symmetric(horizontal: 20.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  children: [
                                    Image.asset(
                                      "images/laptop2.png",
                                      height: 150,
                                      width: 150,
                                      fit: BoxFit.cover,
                                    ),
                                    Text(
                                      "HeadPhone",
                                      style: AppWidget.semiboldTextFeildStyle(),
                                    ),
                                    SizedBox(height: 10.0),
                                    Row(
                                      children: [
                                        Text(
                                          "\$400",
                                          style: TextStyle(
                                            color: Color(0xFF6347A5),
                                            fontSize: 22.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(width: 50.0),
                                        Container(
                                          padding: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            color: Color(0xFF6347A5),
                                            borderRadius: BorderRadius.circular(
                                              50,
                                            ),
                                          ),
                                          child: Icon(
                                            Icons.add,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                      ]
                    )
                  ),
    
                ),
              );
    
  }
    Widget buildResultCard(data){
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context)=> ProductDetail(detail: data["Detail"], image: data["Image"], name: data["Name"], price: data["Price"])));
      },
      child: Container(
        padding: EdgeInsets.only(left: 20.0),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        height: 100,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(data["Image"], height: 70, width: 70, fit: BoxFit.cover,)),
              SizedBox(width: 20.0,),
            Text(data["Name"], style: AppWidget.semiboldTextFeildStyle(),)
          ],
        ),
      ),
    );
  }
}

class CategoryTitle extends StatelessWidget {
  String image, name;
  CategoryTitle({super.key, required this.image, required this.name});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryProduct(category: name),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.only(right: 20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(image, height: 50, width: 50, fit: BoxFit.cover),

            Icon(Icons.arrow_forward),
          ],
        ),
      ),
    );
  }

}

