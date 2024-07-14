
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'profile_modal.dart';
import '../../utils/text_field_title.dart';
//file picker
import 'package:file_picker/file_picker.dart';
// Import UserProfile

class ProfileUpdateScreen extends StatefulWidget {
  final UserProfile userProfile; // Receive userProfile from SettingsScreen
  final Function(UserProfile) onUpdate; // Callback to update the profile

  const ProfileUpdateScreen({super.key, required this.userProfile, required this.onUpdate});

  @override
  State<ProfileUpdateScreen> createState() => _ProfileUpdateScreenState();
}

class _ProfileUpdateScreenState extends State<ProfileUpdateScreen> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _imageUrlController;
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userProfile.name);
    _phoneController = TextEditingController(text: widget.userProfile.phone);
    _emailController = TextEditingController(text: widget.userProfile.email);
    _imageUrlController = TextEditingController(text: widget.userProfile.avatar);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }
   //add image picking logic
  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
    );

    if (result != null) {
      // File file = File(result.files.single.path);
      // _imageUrlController.text = file.path;
    } else {
      // User canceled the picker
    }}
   
  @override
  Widget build(BuildContext context) {
     

    return Scaffold(
    appBar: AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      title: Text('Edit Your Profile  ',style: Theme.of(context).textTheme.displayLarge!.copyWith(
        // color: Theme.of(context).primaryColor,
     
      ),),
      // actions: [
      //   IconButton(
      //     icon: const Icon(Icons.close),
      //     onPressed: () {
      //       Navigator.pop(context);
      //     },
      //   ),],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(


            //create ui for image

             


            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 42,),

             GestureDetector(
              onTap: _pickImage,
              child: Center(
                child: CircleAvatar(
                
                  radius: 60,
                  backgroundColor: Colors.grey[500],
                  backgroundImage: _imageUrlController.text.isNotEmpty
                      ? NetworkImage(_imageUrlController.text)
                      : null,
                  child: _imageUrlController.text.isEmpty
                      ? const Icon(Icons.camera_alt, size: 25)
                      : null,
                ),
              ),
            ),
   const SizedBox(height: 59,),

              const textFieldTitle(title: 'Name'),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(hintText: 'Enter your name'),
              ),
              const SizedBox(height: 20,),
              const textFieldTitle(title: 'Mobile Number'),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(hintText: 'Enter your mobile number'),
              ),
               const SizedBox(height: 20,),
              const textFieldTitle(title: 'Email'),

              TextFormField(
                controller: _emailController,
                
                
             decoration: const InputDecoration(hintText: 'Enter You\'r Email',
             
             ),
              ),
              const SizedBox(height: 50),
              Center(
                child: GestureDetector(
                   onTap: () {
                      final updatedProfile = UserProfile(
                        name: _nameController.text,
                       phone: _phoneController.text,
                        password: _emailController.text,
                        // imageUrl: _imageUrlController.text,
                      );
                      widget.onUpdate(updatedProfile); // Call the update callback
                    },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color:  Theme.of(context).colorScheme.primary,
                      )
                    ),
                   
                   
                    child:  Center(
                      child: Text('Submit',style: TextStyle(color: Theme.of(context).colorScheme.primary,),
                                        ),
                    ),
                                ),
                ),)
            ],
          ),
        ),
      ),
    );
  }
}