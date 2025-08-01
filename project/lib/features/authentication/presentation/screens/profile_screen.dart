import 'package:caterease/core/widgets/build_label.dart';
import 'package:caterease/core/widgets/build_text_field.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  String? selectedGender;
  String? selectedCity;
  String? photoUrl;
  final ImagePicker picker = ImagePicker();
  final List<String> genders = ['Male', 'Female'];
  final List<String> cities = ['Damascus', 'Aleppo', 'Homs', 'Latakia'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        //   centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () async {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => Container(
                      height: 150,
                      child: Column(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.camera_alt),
                            title: const Text("open camera "),
                            onTap: () async {
                              final XFile? image = await picker.pickImage(
                                  source: ImageSource.camera);
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.photo_library),
                            title: const Text("choose from gallery"),
                            onTap: () async {
                              final XFile? image = await picker.pickImage(
                                  source: ImageSource.gallery);
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey[300],
                  child: const Icon(Icons.camera_alt, size: 30),
                ),
                /* child: CircleAvatar(
                  radius: 50,
                  backgroundImage: photoUrl != null
                      ? NetworkImage(photoUrl!)
                      : AssetImage('assets/default_avatar.png')
                          as ImageProvider,
                  child: photoUrl == null
                      ? Icon(Icons.camera_alt, size: 30)
                      : null,
                ), */
              ),
              const SizedBox(height: 20),
              buildLabel("Your Full Name"),
              buildTextField(
                  controller: nameController, hint: "Enter full name"),
              buildLabel("Email"),
              buildTextField(
                  controller: emailController,
                  hint: "Email address",
                  keyboardType: TextInputType.emailAddress),
              buildLabel("Date of birth"),
              buildTextField(
                controller: dobController,
                hint: "Date of birth",
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime(2000),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    dobController.text =
                        "${pickedDate.toLocal()}".split(' ')[0];
                  }
                },
              ),
              buildLabel("Mobile number"),
              buildTextField(
                controller: phoneController,
                hint: "Phone number",
                keyboardType: TextInputType.phone,
              ),
              buildLabel("Gender"),
              DropdownButtonFormField<String>(
                value: selectedGender,
                items: genders
                    .map((gender) => DropdownMenuItem(
                          child: Text(gender),
                          value: gender,
                        ))
                    .toList(),
                onChanged: (value) => setState(() => selectedGender = value),
                decoration: inputDecoration(),
              ),
              /*              buildLabel("City"),
              DropdownButtonFormField<String>(
                value: selectedCity,
                items: cities
                    .map((city) => DropdownMenuItem(
                          child: Text(city),
                          value: city,
                        ))
                    .toList(),
                onChanged: (value) => setState(() => selectedCity = value),
                decoration: inputDecoration(),
              ),
              SizedBox(height: 20),
              buildLabel("Location"),
              buildTextField(
                controller: locationController,
                hint: "Current location",
                readOnly: true,
                /* onTap: () async {
                  bool serviceEnabled;
                  LocationPermission permission;

                  serviceEnabled = await Geolocator.isLocationServiceEnabled();
                  if (!serviceEnabled) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('يرجى تفعيل خدمة الموقع GPS')),
                    );
                    return;
                  }

                  permission = await Geolocator.checkPermission();
                  if (permission == LocationPermission.denied) {
                    permission = await Geolocator.requestPermission();
                    if (permission == LocationPermission.denied) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('تم رفض صلاحية الموقع')),
                      );
                      return;
                    }
                  }

                  if (permission == LocationPermission.deniedForever) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('تم رفض صلاحية الموقع بشكل دائم')),
                    );
                    return;
                  }

                  Position position = await Geolocator.getCurrentPosition(
                      desiredAccuracy: LocationAccuracy.high);
                  setState(() {
                    locationController.text =
                        "${position.latitude}, ${position.longitude}";
                  });
                }, */
              ),
              SizedBox(height: 20), */
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // عملية الحفظ
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: const Text("Save", style: TextStyle(fontSize: 16)),
                ),
              ),
              const SizedBox(height: 25),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text("Log out"),
                onTap: () {
                  // تنفيذ تسجيل الخروج
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text("Delete Account",
                    style: TextStyle(color: Colors.red)),
                onTap: () {
                  // تنفيذ حذف الحساب
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
