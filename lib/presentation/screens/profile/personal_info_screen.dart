import 'package:customer/presentation/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PersonalInfoScreen extends StatefulWidget {
  @override
  _PersonalInfoScreenState createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (userProvider.currentUser != null) {
      _nameController.text = userProvider.currentUser!.name;
      _phoneController.text = userProvider.currentUser!.phone;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        
        title: Text('المعلومات الشخصية'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () => _saveProfile(userProvider),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Profile Image
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(userProvider.currentUser?.profileImage ?? ''),
                child: userProvider.currentUser?.profileImage == null
                    ? Icon(Icons.person, size: 50)
                    : null,
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  // TODO: Implement image picker
                },
                child: Text('تغيير الصورة'),
              ),
              SizedBox(height: 30),

              // Name Field
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'الاسم',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال الاسم';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Phone Field
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'رقم الهاتف',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال رقم الهاتف';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Email Field
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'البريد الإلكتروني',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 30),

              // Error Message
              if (userProvider.error.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red),
                  ),
                  child: Text(
                    userProvider.error,
                    style: TextStyle(color: Colors.red),
                  ),
                ),

              Spacer(),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: userProvider.isLoading
                      ? null
                      : () => _saveProfile(userProvider),
                  child: userProvider.isLoading
                      ? CircularProgressIndicator()
                      : Text(
                          'حفظ التغييرات',
                          style: TextStyle(fontSize: 16),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveProfile(UserProvider userProvider) async {
    if (_formKey.currentState!.validate()) {
      final updateData = {
        'name': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
        if (_emailController.text.isNotEmpty) 'email': _emailController.text.trim(),
      };

      await userProvider.updateUser(
        userProvider.currentUser!.id,
        updateData,
      );

      if (userProvider.error.isEmpty && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تم حفظ التغييرات بنجاح')),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}