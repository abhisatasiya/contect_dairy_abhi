import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:contact_dairy/Controllers/providers/themeprovider.dart';
import 'package:contact_dairy/modals/Globals.dart';
import 'package:contact_dairy/utils/Global.dart';

class AddContact extends StatefulWidget {
  const AddContact({Key? key}) : super(key: key);

  @override
  State<AddContact> createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {
  GlobalKey<FormState> Image = GlobalKey<FormState>();
  GlobalKey<FormState> Name = GlobalKey<FormState>();
  GlobalKey<FormState> Phone = GlobalKey<FormState>();
  GlobalKey<FormState> Email = GlobalKey<FormState>();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  int currentStepperValue = 0;

  String? firstName;
  String? lastName;
  String? phone;
  String? email;
  File? image;

  Future<void> getImageFromCamera() async {
    ImagePicker picker = ImagePicker();
    XFile? img = await picker.pickImage(source: ImageSource.camera);
    if (img != null) {
      setState(() {
        image = File(img.path);
      });
    }
  }

  Future<void> getImageFromGallery() async {
    ImagePicker picker = ImagePicker();
    XFile? img = await picker.pickImage(source: ImageSource.gallery);
    if (img != null) {
      setState(() {
        image = File(img.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Add"),
        actions: [
          IconButton(
            onPressed: () {
              Provider.of<themeProvider>(context, listen: false).changeTheme();
            },
            icon: Icon(
              Icons.circle,
            ),
          ),
          IconButton(
            onPressed: () async {
              setState(() {
                if (Email.currentState!.validate() && Phone.currentState!.validate() && Name.currentState!.validate()) {
                  Email.currentState!.save();
                  Phone.currentState!.save();
                  Name.currentState!.save();
                }
              });

              Globals.allContacts.add(
                Contact(
                  firstName: firstName!,
                  lastName: lastName!,
                  phoneNumber: phone!,
                  email: email!,
                  image: image,
                ),
              );

              await Navigator.of(context)
                  .pushNamedAndRemoveUntil('/', (route) => false);

              setState(() {});
            },
            icon: Icon(
              Icons.check,
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            Stepper(
              currentStep: currentStepperValue,
              onStepContinue: () {
                setState(() {
                  if (currentStepperValue < 3) {
                    setState(() {
                      if (currentStepperValue == 0 && image == null) {
                      } else if (currentStepperValue == 0) {
                        if (Image.currentState!.validate()) {
                          Image.currentState!.save();
                          setState(() {
                            currentStepperValue++;
                          });
                        }
                      } else if (currentStepperValue == 1) {
                        if (Name.currentState!.validate()) {
                          Name.currentState!.save();
                          setState(() {
                            currentStepperValue++;
                          });
                        }
                      } else if (currentStepperValue == 2) {
                        if (Phone.currentState!.validate()) {
                          Phone.currentState!.save();
                          setState(() {
                            currentStepperValue++;
                          });
                        }
                      } else if (currentStepperValue == 3) {
                        if (Email.currentState!.validate()) {
                          Email.currentState!.save();
                        }
                      } else {
                        setState(() {
                          currentStepperValue++;
                        });
                      }
                    });
                  }
                });
              },
              onStepCancel: () {
                setState(() {
                  if (currentStepperValue > 0) {
                    currentStepperValue--;
                  }
                });
              },
              steps: [
                Step(
                  title: Text("Pick Image"),
                  isActive: (currentStepperValue >= 0) ? true : false,
                  content: Form(
                    key: Image,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.grey,
                              foregroundImage: (image != null)
                                  ? FileImage(
                                      File(image!.path),
                                    )
                                  : null,
                              child: Text("Add"),
                            ),
                            FloatingActionButton(
                              onPressed: () {
                                setState(() {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text(
                                        "Your Image Source",
                                      ),
                                      content: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              setState(() {
                                                getImageFromCamera();
                                                Navigator.of(context).pop();
                                              });
                                            },
                                            child: Text("Camera"),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              setState(() {
                                                getImageFromGallery();
                                                Navigator.of(context).pop();
                                              });
                                            },
                                            child: Text("Gallery"),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                });
                              },
                              child: Icon(Icons.add),
                              mini: true,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  state: (currentStepperValue == 0)
                      ? StepState.editing
                      : StepState.indexed,
                ),
                Step(
                  title: Text("Full Name"),
                  isActive: (currentStepperValue >= 1) ? true : false,
                  state: (currentStepperValue == 1)
                      ? StepState.editing
                      : StepState.indexed,
                  content: Form(
                    key: Name,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          height: 60,
                          child: TextFormField(
                            cursorColor: Colors.black,
                            controller: Controllers.firstName,
                            keyboardType: TextInputType.name,
                            onSaved: (name) {
                              firstName = name;
                            },
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Please enter your Name";
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                                borderSide: BorderSide(
                                  color: Colors.red,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                                borderSide: BorderSide(
                                  color: Colors.red,
                                ),
                              ),
                              hintText: "First Name",
                              labelText: "First Name",
                              hintStyle: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        SizedBox(
                          height: 60,
                          child: TextFormField(
                            cursorColor: Colors.black,
                            controller: Controllers.lastName,
                            keyboardType: TextInputType.name,
                            onSaved: (name) {
                              lastName = name;
                            },
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Please enter your Name";
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                                borderSide: BorderSide(
                                  color: Colors.red,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                                borderSide: BorderSide(
                                  color: Colors.red,
                                ),
                              ),
                              hintText: "Last Name",
                              labelText: "Last Name",
                              hintStyle: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Step(
                  title: Text("Phone Number"),
                  isActive: (currentStepperValue >= 2) ? true : false,
                  state: (currentStepperValue == 2)
                      ? StepState.editing
                      : StepState.indexed,
                  content: Form(
                    key: Phone,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          height: 60,
                          child: TextFormField(
                            cursorColor: Colors.black,
                            controller: Controllers.phoneNumber,
                            keyboardType: TextInputType.number,
                            onSaved: (name) {
                              phone = name;
                            },
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Please enter your Phone Number";
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                                borderSide: BorderSide(
                                  color: Colors.red,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                                borderSide: BorderSide(
                                  color: Colors.red,
                                ),
                              ),
                              hintText: "Phone Number",
                              labelText: "Phone Number",
                              hintStyle: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Step(
                  title: Text("Email"),
                  isActive: (currentStepperValue >= 3) ? true : false,
                  state: (currentStepperValue == 3)
                      ? StepState.editing
                      : StepState.indexed,
                  content: Form(
                    key: Email,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          height: 60,
                          child: TextFormField(
                            cursorColor: Colors.black,
                            controller: Controllers.email,
                            keyboardType: TextInputType.emailAddress,
                            onSaved: (name) {
                              email = name;
                            },
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Please enter your Email";
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                                borderSide: BorderSide(
                                  color: Colors.red,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                                borderSide: BorderSide(
                                  color: Colors.red,
                                ),
                              ),
                              hintText: "Email",
                              labelText: "Email",
                              hintStyle: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
