import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:student_portal_app/HomePage/Admin_Portal/Student_card/Student_search_card/studentAlldetail/studentDetail.dart';

class StudentSearchDetails extends StatefulWidget {
  StudentSearchDetails({Key? key}) : super(key: key);
  @override
  _StudentSearchDetailsState createState() => _StudentSearchDetailsState();
}

class _StudentSearchDetailsState extends State<StudentSearchDetails> {
  bool isLoading = false;
  String error = "";
  List studentData = [];
   String ?currentClass;
  List classList = [
    "Pre-NC",
    "NC",
    "UKG",
    "KG",
    "1st",
    "2nd",
    "3rd",
    "4th",
    "5th",
    "6th",
    "7th",
    "8th",
    "9th",
    "10th",
    "11th",
    "12th",
  ];

  Future<void> searchStudentDetails() async {
    if (currentClass==null) {
      setState(() {
        error = "Please Select Class";
      });
    } else {
      setState(() {
        error = "";
        isLoading = true;
      });

      // Store all data with Param Name.
      print("class:" + currentClass!);

      var data = {
        "class": currentClass,
      };
      // Starting App API Call.
      var response = await http.post(
          Uri.parse(
              "http://sniic.co.in/admin/school_app/student_detail_json.php"),
          body: json.encode(data));

      // Getting Server response into variable.
      var obj = jsonDecode(response.body);

      if (obj["result"] == "S") {
        setState(() {
          error = "";
          isLoading = false;
          studentData = obj["data"];
        });
        print(studentData);
      } else {
        setState(() {
          isLoading = false;
          error = "Student Class is not valid in the list";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFBCEBEB),
      appBar: AppBar(
        backgroundColor: Color(0xFF097272),
        title: Text("Search Student Details"),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.025,
        ),
        width: MediaQuery.of(context).size.width * 0.95,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: 30, bottom: 10),
                decoration: BoxDecoration(
                  color: Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Current Class:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(left: 50),
                          child: DropdownButton(
                            isExpanded: true,
                            underline: Text(""),
                            hint: Text("Select Current Class"),
                            value: currentClass,
                            items: classList.map<DropdownMenuItem<String>>((e) {
                              return DropdownMenuItem<String>(
                                child: Text(e),
                                value: e,
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                currentClass = value.toString();
                                print(currentClass);
                              });
                            },
                          ),
                        ),
                      ),
                    ],
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
                    searchStudentDetails();
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
              Container(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: studentData == [] ? 0 : studentData.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: (){
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context)
                            =>StudentAllinformation(studentData[index]["regno"],
                                studentData[index]["name"],studentData[index]["pic"])));
                      },
                      child: Container(
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 10),
                              margin: EdgeInsets.symmetric(vertical: 2.5),
                              decoration: BoxDecoration(
                                color: Color(0xFFFFFFFF),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width:60,
                                    height: 60,
                                    child: Image.network(studentData[index]["pic"],
                                      errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                        return Icon(Icons.error_outline,size: 50,);
                                      },),
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
                                            studentData[index]["name"],
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Text(studentData[index]["regno"]),
                                        Text(studentData[index]["class"]),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );

  }
}
