import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supa_electronics/const/color.dart';
import 'package:supa_electronics/services/api_service.dart';

class ProfileScreen extends StatefulWidget {
  final VoidCallback onLogout;

  const ProfileScreen({
    Key? key,
    required this.onLogout,
    required String token,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController usernameController;
  bool isEditing = false;
  bool isLoading = false;
  File? _selectedImage;

  String username = '';
  String email = '';
  String token = '';

  String id = '';

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? '';
      email = prefs.getString('email') ?? '';
      token = prefs.getString('token') ?? '';
            id = prefs.getString('userid') ?? '';

      usernameController.text = username;
    });
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveChanges() async {
    setState(() => isLoading = true);

    final newUsername = usernameController.text.trim();
    if (newUsername.isEmpty) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('اسم المستخدم لا يمكن أن يكون فارغًا'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final success = await ApiService(token: token).updateUserProfile({
      'username': newUsername,
      'email': email,
    });

    if (success) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', newUsername);
    }

    setState(() {
      isLoading = false;
      if (success) {
        isEditing = false;
        username = newUsername;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success ? 'تم تحديث المعلومات بنجاح' : 'فشل في التحديث'),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  void dispose() {
    usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body:
      
      
      
       Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildHeader(),
                SizedBox(height: 60), // مسافة للصورة
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      isEditing
                          ? _buildEditableField(
                              "اسم المستخدم", usernameController)
                          : Row(
                              children: [
                                _buildStaticField("اسم المستخدم", username),
                                Spacer(),
                                IconButton(
                                  icon: Icon(
                                    Icons.edit,
                                    color: AppColors.primary,
                                  ),
                                  onPressed: () {
                                    setState(() => isEditing = true);
                                  },
                                ),
                              ],
                            ),
                      SizedBox(height: 30),
                      _buildStaticField("البريد الإلكتروني", email),
                      SizedBox(height: 30),
                      _buildStaticField("نوع الحساب", "مستخدم"),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                if (isEditing)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: isLoading
                        ? CircularProgressIndicator()
                        : ElevatedButton.icon(
                            onPressed: _saveChanges,
                            icon: Icon(Icons.save),
                            label: Text("حفظ التعديلات"),
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, 50),
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                  ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: ElevatedButton.icon(
                    onPressed: widget.onLogout,
                    icon: Icon(Icons.logout),
                    label: Text("تسجيل الخروج"),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 220,
            left: MediaQuery.of(context).size.width / 2 - 70,
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 70,
                  backgroundColor: const Color.fromARGB(242, 255, 255, 255),
                  backgroundImage: _selectedImage != null
                      ? FileImage(_selectedImage!)
                      : null,
                  child: _selectedImage == null
                      ? Icon(Icons.person, size: 90, color: AppColors.secondary)
                      : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      height: 300,
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Stack(
        children: [
         Container(
  width: double.infinity,
  child: ClipRRect(
    borderRadius: BorderRadius.only(
      bottomLeft: Radius.circular(34),
      bottomRight: Radius.circular(34),
    ),
    child: Image.asset(
      "assets/image2.jpg",
      fit: BoxFit.fitWidth,
    ),
  ),
),
Container(
      width: double.infinity,
      height: 300,
      decoration: BoxDecoration(
        color: const Color.fromARGB(137, 18, 62, 68),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),),
          Padding(
            padding: const EdgeInsets.only(top:60.0,right: 30,left: 30),
            child: Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
              color: const Color.fromARGB(136, 255, 255, 255),
        borderRadius: BorderRadius.all(
          Radius.circular(32),
        ),
      ),
                child: Center(
                  child: Text(
                    username,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ),
          
        ],
      ),
    );
  }

  Widget _buildEditableField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16)),
        SizedBox(height: 4),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildStaticField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text("${label}:",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        Text(value, textAlign: TextAlign.start, style: TextStyle(fontSize: 16)),
      ],
    );
  }
}
