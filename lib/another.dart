import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'constant.dart';
import 'package:http/http.dart' as http;
import 'package:dropdown_button2/dropdown_button2.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  _asyncFileUpload(File file, String name, String email, String password,
      String _date, String gender, String status) async {
    var request = http.MultipartRequest(
        "POST", Uri.parse("https://anaajapp.com/api/user/submit_details"));

    request.fields["email"] = email;
    request.fields["password"] = password;
    request.fields["name"] = name;
    request.fields["dob"] = _date;
    request.fields["gender"] = status;
    request.fields["user_status"] = gender;
    var pic = await http.MultipartFile.fromPath("image", file.path);
    request.files.add(pic);
    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    print(responseString);
    print("Data Send seccussfull");
  }

  DateTime? pickedDate;
  String formattedDate = '';
  File? _imageFile;
  final picker = ImagePicker();
  String downloadImageUrl = '';

  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
        print(_imageFile);
        print("image selected");
      } else {
        print("No image selected");
      }
    });
  }

  int? _radioSelected;
  String gender = "";
  String? status;
  List<String> items = [
    'male',
    'female',
  ];
  final formkey = GlobalKey<FormState>();
  String email = '';
  String name = '';
  String password = '';
  String confirmPassword = '';
  bool isloading = false;
  TextEditingController dateinput = TextEditingController();
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: isloading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Form(
                key: formkey,
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.grey[200],
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 70),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(30.0),
                          child: FlatButton(
                              child: Icon(
                                Icons.add_a_photo,
                                color: Colors.blue,
                                size: 50,
                              ),
                              onPressed: pickImage),
                        ),
                        SizedBox(height: 30),
                        TextFormField(
                          keyboardType: TextInputType.name,
                          onChanged: (value) {
                            name = value.toString().trim();
                          },
                          validator: (value) =>
                              (value!.isEmpty) ? ' Please enter name' : null,
                          textAlign: TextAlign.start,
                          decoration: kTextFieldDecoration.copyWith(
                            hintText: 'Enter Your Name',
                          ),
                        ),
                        SizedBox(height: 30),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (value) {
                            email = value.toString().trim();
                          },
                          validator: (value) =>
                              (value!.isEmpty) ? ' Please enter email' : null,
                          textAlign: TextAlign.start,
                          decoration: kTextFieldDecoration.copyWith(
                            hintText: 'Enter Your Email',
                          ),
                        ),
                        SizedBox(height: 30),
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please Enter New Password";
                            } else if (value.length < 8) {
                              return "Password must be atleast 8 characters long";
                            } else {
                              return null;
                            }
                          },
                          onChanged: (value) {
                            password = value;
                          },
                          obscureText: _obscureText,
                          textAlign: TextAlign.start,
                          decoration: kTextFieldDecoration.copyWith(
                            hintText: 'Create Password',
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                              child: Icon(_obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        TextFormField(
                          obscureText: _obscureText,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please Re-Enter New Password";
                            } else if (value.length < 8) {
                              return "Password must be atleast 8 characters long";
                            } else if (value != password) {
                              return "Password must be same as above";
                            } else {
                              return null;
                            }
                          },
                          onChanged: (value) {
                            confirmPassword = value;
                          },
                          textAlign: TextAlign.start,
                          decoration: kTextFieldDecoration.copyWith(
                            hintText: 'Confirm Password',
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                              child: Icon(_obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        TextField(
                          controller:
                              dateinput, //editing controller of this TextField
                          decoration: kTextFieldDecoration.copyWith(
                              hintText: 'Date of Birth',
                              suffixIcon: const Icon(
                                Icons.calendar_today,
                                color: Colors.black,
                              )),
                          readOnly: true,
                          onTap: () async {
                            pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2101));

                            if (pickedDate != null) {
                              print(pickedDate);
                              formattedDate =
                                  DateFormat('dd/MM/yyyy').format(pickedDate!);
                              print(formattedDate);
                              setState(() {
                                dateinput.text = formattedDate;
                              });
                            } else {
                              print("Date is not selected");
                            }
                          },
                        ),
                        SizedBox(height: 30),
                        DropdownButtonHideUnderline(
                          child: DropdownButtonFormField2(
                            decoration: kTextFieldDecoration.copyWith(
                              hintText: 'Select Gender',
                            ),
                            items: items
                                .map((item) => DropdownMenuItem<String>(
                                      value: item,
                                      child: Text(
                                        item,
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ))
                                .toList(),
                            value: status,
                            onChanged: (value) {
                              setState(() {
                                status = value as String;
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Radio(
                                  value: 1,
                                  groupValue: _radioSelected,
                                  activeColor: Colors.blue,
                                  onChanged: (value) {
                                    setState(() {
                                      _radioSelected = value as int;
                                      gender = 'Active';
                                      print(gender);
                                    });
                                  },
                                ),
                                const Text("Active"),
                              ],
                            ),
                            Row(
                              children: [
                                Radio(
                                  value: 2,
                                  groupValue: _radioSelected,
                                  activeColor: Colors.red,
                                  onChanged: (value) {
                                    setState(() {
                                      _radioSelected = value as int;
                                      gender = 'Suspended';
                                      print(gender);
                                    });
                                  },
                                ),
                                const Text("Suspended"),
                              ],
                            ),
                          ],
                        ),
                        ElevatedButton(
                            onPressed: () {
                              if (formkey.currentState!.validate()) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Processing Data')),
                                );
                              }
                              _asyncFileUpload(_imageFile!, name, email,
                                  password, formattedDate, gender, status!);
                            },
                            child: Text("Sign Up"))
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
