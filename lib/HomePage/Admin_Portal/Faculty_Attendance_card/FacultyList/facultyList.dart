import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:student_portal_app/HomePage/Admin_Portal/Faculty_Attendance_card/FacultyList/facultyDetail.dart';

import 'faculty_id_card_generator.dart';
class FacultyList extends StatefulWidget {
  const FacultyList({Key? key}) : super(key: key);

  @override
  _FacultyListState createState() => _FacultyListState();
}

class _FacultyListState extends State<FacultyList> {
  bool isLoading = false;
  String error = "";
  List facultyData = [];
  TextEditingController searchFaculty = new TextEditingController();
  void initState(){
    isLoading=true;
    searchFacultyDetails();
  }
  Future<void> searchFacultyDetails() async {
    {
      setState(() {
        error = "";
        isLoading = true;
      });

      // Store all data with Param Name.
      print("class:" + searchFaculty.text);
      // Starting App API Call.
      var response = await http.post(
          Uri.parse(
              "http://sniic.co.in/admin/school_app/staff_list_json.php"));

      // Getting Server response into variable.
      var obj = jsonDecode(response.body);

      if (obj["result"] == "S") {
        setState(() {
          error = "";
          isLoading = false;
          facultyData = obj["data"];
        });
        print(facultyData);
      } else {
        print(obj["message"]);
        setState(() {
          isLoading = false;
          error = "Something Went Wrong";
        });
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Faculty List"),
      ),
      body:Container(
        margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.025,
        ),
        width: MediaQuery.of(context).size.width * 0.95,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: 20),
                //color: Color(0xFFFFFFFF),
                decoration: BoxDecoration(
                  color: Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: TextFormField(
                    controller: searchFaculty,
                    decoration: InputDecoration(
                      icon: Icon(
                        Icons.search_rounded,
                        color: Colors.black,
                        size: 24,
                      ),
                      border: InputBorder.none,
                      hintText: "Enter Faculty  Name",
                      hintStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                child: error != ""
                    ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    error,
                    style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                        fontSize: 14),
                    textAlign: TextAlign.left,
                  ),
                )
                    : Text(""),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.95,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF097272),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: () {
                    searchFacultyDetails();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: isLoading != false
                        ? Text(
                      "Searching.....",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                        : Text(
                      "Search",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: facultyData == [] ? 0 : facultyData.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    margin: EdgeInsets.symmetric(vertical: 2.5),
                    decoration: BoxDecoration(
                      color: Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: GestureDetector(
                      onTap: (){
                        Map data=facultyData[index];
                        print(data);
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>FacultyDetail(data: data,)));
                      },
                      child: Wrap(
                       // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(facultyData[index]["pic"]),
                              backgroundColor: Colors.grey,
                              radius: 40,
                              // child: Icon(
                              //   Icons.person_outlined,
                              //   color: Color(0xFFFFFFFF),
                              // ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            child: Column(
                              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5),
                                  child: Text(
                                    facultyData[index]["name"],
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Text(facultyData[index]["empid"]),
                                Text("Phone:"+facultyData[index]["phone"]),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>
                                  FacultyIdCard(facultyData[index],))
                              );
                            },
                            child: Container(
                              // alignment: Alignment.centerRight,
                              height: 100,
                              child: Icon(Icons.qr_code_2,size: 50,),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
