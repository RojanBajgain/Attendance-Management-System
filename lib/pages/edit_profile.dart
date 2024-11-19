import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:image_picker/image_picker.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  /* CircleAvatar(
                    radius: 70,
                    backgroundColor: Colors.grey[300],
                    backgroundImage:
                        const AssetImage("assets/images/profile_image.png"),
                   */
                  // Center(
                  //   child: _image == null
                  //       ? Text('No image selected.')
                  //       : Image.file(File(_image!.path)),
                  // ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: CircleAvatar(
                      radius: MediaQuery.of(context).size.height * 0.075,
                      backgroundColor: Colors.grey[300],
                      backgroundImage:
                          _image != null ? FileImage(File(_image!.path)) : null,
                      child: _image == null
                          ? Icon(
                              Icons.person,
                              size: 50,
                              color: Colors.white,
                            )
                          : null,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Center(
                    child: Column(
                      children: [
                        ElevatedButton(
                          style: ButtonStyle(
                            elevation: MaterialStateProperty.all(5),
                            backgroundColor:
                                MaterialStateProperty.all(Colors.black),
                            foregroundColor:
                                MaterialStateProperty.all(Colors.white),
                          ),
                          child: Text(
                            "Pick Image",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: getImage,
                          onLongPress: getImageFromCamera,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  const EditProfileForm(),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future getImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  Future getImageFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });
  }
}

// const authOutlineInputBorder = OutlineInputBorder(
//   borderSide: BorderSide(color: Color(0xFF757575)),
//   borderRadius: BorderRadius.all(Radius.circular(10)),
// );

class EditProfileForm extends StatefulWidget {
  const EditProfileForm({super.key});

  @override
  State<EditProfileForm> createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> {
  String? _selectedValue;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: 'Enter Name ',
                          style: TextStyle(
                            fontFamily: 'Mukta',
                            fontSize: 15.0,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: '*',
                          style: TextStyle(
                            fontFamily: 'Mukta',
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Container(
                    height: 50.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.grey.shade50,
                      border: Border.all(
                        color: Colors.black,
                        width: 1.0,
                      ),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Enter Your Name",
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 12.0,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12.0),
              Column(
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(
                          text: 'Date of Birth ',
                          style: TextStyle(
                            fontFamily: 'Mukta',
                            fontSize: 15.0,
                          ),
                        ),
                        const TextSpan(
                          text: '*',
                          style: TextStyle(
                            fontFamily: 'Mukta',
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Container(
                height: 50.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.grey.shade50,
                  border: Border.all(
                    color: Colors.black,
                    width: 1.0,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 10.0,
                  ),
                  child: FormBuilderDateTimePicker(
                    name: 'date_of_birth',
                    decoration: const InputDecoration(
                        icon: Icon(
                          Icons.calendar_month_outlined,
                          color: Colors.grey,
                        ),
                        hintText: 'Start Date',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        )),
                    inputType: InputType.date,
                    onChanged: (value) {
                      setState(() {});
                    },
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1980, 1, 1),
                    lastDate: DateTime.now(),
                  ),
                ),
              ),
              const SizedBox(height: 12.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: 'Contact Number ',
                          style: TextStyle(
                            fontFamily: 'Mukta',
                            fontSize: 15.0,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: '*',
                          style: TextStyle(
                            fontFamily: 'Mukta',
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Container(
                    height: 50.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.grey.shade50,
                      border: Border.all(
                        color: Colors.black,
                        width: 1.0,
                      ),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Enter Contact Number",
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 12.0,
                        ),
                        border: InputBorder.none,
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: 'Designation ',
                          style: TextStyle(
                            fontFamily: 'Mukta',
                            fontSize: 15.0,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: '*',
                          style: TextStyle(
                            fontFamily: 'Mukta',
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Container(
                    height: 50.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.grey.shade50,
                      border: Border.all(
                        color: Colors.black,
                        width: 1.0,
                      ),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Enter Designation",
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 12.0,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12.0),
              Column(
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(
                          text: 'Shift ',
                          style: TextStyle(
                            fontFamily: 'Mukta',
                            fontSize: 15.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Container(
                height: 50.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.grey.shade50,
                  border: Border.all(
                    color: Colors.black,
                    width: 1.0,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 10.0,
                  ),
                  child: FormBuilderDropdown<String>(
                    onChanged: (value) {
                      setState(() {
                        _selectedValue = value;
                      });
                    },
                    name: 'shift',
                    hint: const Text(
                      'Select',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                    items: [
                      'Morning Shift',
                      'Day Shift',
                      'Night Shift',
                    ]
                        .map((shift) => DropdownMenuItem(
                              value: shift,
                              child: Text(shift),
                            ))
                        .toList(),
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              Column(
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(
                          text: 'Gender ',
                          style: TextStyle(
                            fontFamily: 'Mukta',
                            fontSize: 15.0,
                          ),
                        ),
                        const TextSpan(
                          text: '*',
                          style: TextStyle(
                            fontFamily: 'Mukta',
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Container(
                height: 50.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.grey.shade50,
                  border: Border.all(
                    color: Colors.black,
                    width: 1.0,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 10.0,
                  ),
                  child: FormBuilderDropdown<String>(
                    onChanged: (value) {
                      setState(() {
                        _selectedValue = value;
                      });
                    },
                    name: 'gender',
                    hint: const Text(
                      'Select',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                    items: [
                      'Male',
                      'Female',
                      'Others',
                    ]
                        .map((gender) => DropdownMenuItem(
                              value: gender,
                              child: Text(gender),
                            ))
                        .toList(),
                  ),
                ),
              ),
              const SizedBox(height: 12.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: 'Address ',
                          style: TextStyle(
                            fontFamily: 'Mukta',
                            fontSize: 15.0,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: '*',
                          style: TextStyle(
                            fontFamily: 'Mukta',
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Container(
                    height: 50.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.grey.shade50,
                      border: Border.all(
                        color: Colors.black,
                        width: 1.0,
                      ),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Enter Address",
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 12.0,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: 'Email ',
                          style: TextStyle(
                            fontFamily: 'Mukta',
                            fontSize: 15.0,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: '*',
                          style: TextStyle(
                            fontFamily: 'Mukta',
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Container(
                    height: 50.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.grey.shade50,
                      border: Border.all(
                        color: Colors.black,
                        width: 1.0,
                      ),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Enter Email Address",
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 12.0,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12.0),
              Column(
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(
                          text: 'Joined Date ',
                          style: TextStyle(
                            fontFamily: 'Mukta',
                            fontSize: 15.0,
                          ),
                        ),
                        const TextSpan(
                          text: '*',
                          style: TextStyle(
                            fontFamily: 'Mukta',
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Container(
                height: 50.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.grey.shade50,
                  border: Border.all(
                    color: Colors.black,
                    width: 1.0,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 10.0,
                  ),
                  child: FormBuilderDateTimePicker(
                    name: 'joined_date',
                    decoration: const InputDecoration(
                        icon: Icon(
                          Icons.calendar_month_outlined,
                          color: Colors.grey,
                        ),
                        hintText: 'Joined Date',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        )),
                    inputType: InputType.date,
                    onChanged: (value) {
                      setState(() {});
                    },
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1980, 1, 1),
                    lastDate: DateTime.now(),
                  ),
                ),
              ),
              SizedBox(height: 30.0),
              Center(
                child: Container(
                  height: 45.0,
                  width: 120.0,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.black,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.save_outlined,
                        color: Colors.white,
                      ),
                      Text(
                        "Save",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Mukta',
                          fontSize: 16.0,
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
