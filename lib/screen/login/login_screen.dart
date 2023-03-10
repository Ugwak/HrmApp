import 'dart:io';
import 'dart:ui';
import 'package:attendance/screen/attendance/main_tabs.dart';
import 'package:device_information/device_information.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'dart:async';
import 'dart:convert';
import '../../models/the_day_shift_info_model.dart';
import '../../network/attendance_status_http_request.dart';
import '../../network/the_day_shift_info_http_request.dart';
import '../attendance/user_check_in_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';



TextEditingController companyNumberController = TextEditingController();
TextEditingController employeeNumberController = TextEditingController();
var empID;
var result;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
   late TheDayShift shiftData;
    // AttendanceStatus? attendanceStatus;

  var isLoaded = false;
  String _imeiNo = "";

  @override
  void initState() {
    // AttendanceServices().getAttenRecStatus(empID, Day());
    initPlatformState();
    // checkStatus();
    super.initState();
  }
   // checkStatus(){
   //   if(attenStatus == "Not clocked in"){
   //     stuts == 0;
   //     print(stuts);
   //   }else{
   //     stuts == 1;
   //     print(stuts);
   //   }
   // }
  Day() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(now);
    return formatted; // something like 2013-04-20
  }

  Future<void> initPlatformState() async {
    late String imeiNo = '';
    try {
      // PermissionStatus status = await contacts.request();
       var version = await DeviceInformation.platformVersion;
      imeiNo = await DeviceInformation.deviceIMEINumber;
      print("IMEI: ${imeiNo}");
      print(version);
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    if (!mounted) return;
    setState(() {
      _imeiNo = imeiNo;
    });
  }

  Future RegisterCheck() async {
    try {
      inProgress = true;
      var res = await http.post(
          Uri.parse("http://192.168.1.33/hrm/acc_verification.php"),
          body: {
            "CompanySerial": companyNumberController.text.toString(),
            "EmpId": employeeNumberController.text.toString(),
            "IME": _imeiNo.toString(),
          }); //sending post request with header data
      if (res.statusCode == 200) {
        setState(() {
          inProgress = false;
        });
        print(res.body);
        print("LogIN sucessful"); //print raw response on console
        var data = json.decode(res.body);
        empID = data["EmpId"];
        result = data["Result"];
        print(empID);
        print(result);
        print(data["IME"]); //decoding json to array
      } else {
        setState(() {
          inProgress = false;
        });
        debugPrint("Something went wrong! Status Code is: ${res.statusCode}");
      }
    }on SocketException catch(_){
      setState(() {
        inProgress = false;
      });
      Fluttertoast.showToast(
          msg: "Check your internet connection",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );

    }
  }

  var companyNumber;
  var employeeNumber;
  var stuts;
  var inProgress = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: size.height,
              width: size.width,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                image: AssetImage("assets/login_background.png"),
                fit: BoxFit.cover,
              )),
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
              child: Container(
                height: size.height,
                width: size.width,
                decoration:
                    BoxDecoration(color: Colors.grey.shade200.withOpacity(0.3)),
              ),
            ),
            ListView(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 35.0, top: 230),
                  child: Text(
                    "Welcome",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 50),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 35.0, top: 10, bottom: 50),
                  child: Text(
                    "Login",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 50),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40.0, vertical: 8),
                  child: TextFormField(
                      onSaved: (val) {
                        companyNumber = val;
                      },
                      keyboardType: TextInputType.text,
                      // validator: (value) => rangeValidator(value!),
                      controller: companyNumberController,
                      style: const TextStyle(color: Colors.black, fontSize: 22),

                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50)),
                        hintText: "Input Company Number",
                        fillColor: Colors.transparent,
                        filled: true,
                        prefixIcon: const Icon(
                          Icons.person,
                          color: Color(0xff666666),
                        ),
                        hintStyle: const TextStyle(
                            color: Colors.grey,
                            fontFamily: 'Cairo',
                            fontSize: 18),
                      )),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40.0, vertical: 8),
                  child: TextFormField(
                      onSaved: (val) {
                        employeeNumber = val;
                      },
                      keyboardType: TextInputType.number,
                      // validator: (value) => rangeValidator(value!),
                      controller: employeeNumberController,
                      style: const TextStyle(color: Colors.black, fontSize: 22),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
                        hintText: "Employee number",
                        fillColor: Colors.transparent,
                        filled: true,
                        // prefixIcon: const Icon(Icons.person, color: Color(0xff666666),),
                        hintStyle: const TextStyle(
                            color: Colors.grey,
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 40.0, horizontal: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () async {
                           await initPlatformState();
                           await RegisterCheck();
                           print("Result: ${result}");
                          shiftData = await Services().getDayShiftInfo(empID, Day());
                          await AttendanceServices().getAttenRecStatus(empID, Day());
                          if (shiftData != null) {
                            if(result == "1"){
                              print(employeeNumberController.text.toString());
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MainTabs(imeiNo: _imeiNo,
                                      empID: empID,
                                      totalHrs: shiftData.totalHoures == null? "--:--":shiftData.totalHoures,
                                      clockOut: shiftData.checkOut == null? "--:--":shiftData.checkOut,
                                      clockIn: shiftData.checkIn == null?"--:--":shiftData.checkIn,
                                      location: shiftData.locationName == null? "No Shift available":shiftData.locationName,
                                      dateOn: shiftData.dateOn,
                                      status: stuts,)));}
                            else if(result == "0"){
                              Fluttertoast.showToast(
                                  msg: "Check the employee number or the company number",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0
                              );
                            }
                          }
                        },
                        child:inProgress == true?  Lottie.asset('assets/lottie/loading.json', height: 60, width: 60): Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: const [
                                BoxShadow(
                                    blurRadius: 7.0, color: Color(0xffa7a9af))
                              ]),
                          child:  CircleAvatar(
                            minRadius: 30,
                            maxRadius: 30,
                            backgroundColor: Colors.red,
                            child:  Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white,
                              size: 25,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
