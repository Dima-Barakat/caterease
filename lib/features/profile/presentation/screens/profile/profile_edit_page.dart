import 'dart:io';

import 'package:caterease/core/services/image_service.dart';
import 'package:caterease/core/widgets/build_label.dart';
import 'package:caterease/core/widgets/build_text_field.dart';
import 'package:caterease/features/profile/presentation/controller/bloc/profile/profile_bloc.dart';
import 'package:caterease/features/profile/presentation/screens/profile/profile_view_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileEditPage extends StatefulWidget {
  final Map<String, String> labels;

  const ProfileEditPage({super.key, required this.labels});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  String? selectedGender;
  String? photoUrl;
  final imageService = ImageService();
  final genders = [
    {"label": "Female", "value": "f"},
    {"label": "Male", "value": "m"},
  ];
  @override
  void initState() {
    super.initState();

    // Set the controllers using the passed labels
    nameController.text = widget.labels["name"] ?? "";
    emailController.text = widget.labels["email"] ?? "";
    phoneController.text = widget.labels["phone"] ?? "";
    selectedGender = _normalizeGender(widget.labels["gender"]);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }

        if (state is ProfileUpdated) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Profile updated successfully!")),
          );
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const ProfileViewPage()),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text('Profile'), centerTitle: true),
          body: _buildFormPage(context, state),
        );
      },
    );
  }

  Widget _buildFormPage(BuildContext context, ProfileState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /*   GestureDetector(
              onTap: () async {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => SizedBox(
                    height: 150,
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.camera_alt),
                          title: const Text("open camera "),
                          onTap: () async {
                            final File? image =
                                await imageService.pickImageFromCamera();
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.photo_library),
                          title: const Text("choose from gallery"),
                          onTap: () async {
                            final File? image =
                                await imageService.pickImageFromGallery();
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
              child: Center(
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey[300],
                  foregroundImage: photoUrl != null
                      ? imageService.getNetworkImage(photoUrl)
                      : null,
                  child: const Icon(Icons.person),
                ),
              ),
            ), */
            const SizedBox(height: 20),
            buildLabel("Your Full Name"),
            buildTextField(controller: nameController, hint: "Enter full name"),
            buildLabel("Email"),
            buildTextField(
                controller: emailController,
                hint: "Email address",
                keyboardType: TextInputType.emailAddress),
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
                        value: gender["value"],
                        child: Text(gender["label"]!),
                      ))
                  .toList(),
              onChanged: (value) => setState(() {
                selectedGender = value!;
              }),
              decoration: inputDecoration(),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    context.read<ProfileBloc>().add(UpdateProfileEvent(
                          name: nameController.text,
                          email: emailController.text,
                          phone: phoneController.text,
                          gender: selectedGender,
                          // photo: image, // optional if you store it
                        ));
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: state is ProfileLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Save", style: TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }

  String? _normalizeGender(String? genderCode) {
    if (genderCode == null) return null;
    if (genderCode == 'm' || genderCode == 'Male') return 'm';
    if (genderCode == 'f' || genderCode == 'Female') return 'f';
    return genderCode; // fallback
  }
}
