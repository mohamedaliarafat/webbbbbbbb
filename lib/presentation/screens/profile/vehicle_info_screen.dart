import 'package:customer/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VehicleInfoScreen extends StatefulWidget {
  @override
  _VehicleInfoScreenState createState() => _VehicleInfoScreenState();
}

class _VehicleInfoScreenState extends State<VehicleInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _vehicleTypeController = TextEditingController();
  final _vehicleModelController = TextEditingController();
  final _licensePlateController = TextEditingController();
  final _vehicleColorController = TextEditingController();
  final _vehicleYearController = TextEditingController();

  String? _selectedVehicleType;

  final List<String> _vehicleTypes = [
    'سيارة صغيرة',
    'سيارة كبيرة',
    'شاحنة صغيرة',
    'شاحنة كبيرة',
    'دراجة نارية',
  ];

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('معلومات المركبة'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () => _saveVehicleInfo(authProvider),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Vehicle Type
              DropdownButtonFormField<String>(
                value: _selectedVehicleType,
                decoration: InputDecoration(
                  labelText: 'نوع المركبة',
                  border: OutlineInputBorder(),
                ),
                items: _vehicleTypes.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedVehicleType = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى اختيار نوع المركبة';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Vehicle Model
              TextFormField(
                controller: _vehicleModelController,
                decoration: InputDecoration(
                  labelText: 'موديل المركبة',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال موديل المركبة';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // License Plate
              TextFormField(
                controller: _licensePlateController,
                decoration: InputDecoration(
                  labelText: 'رقم اللوحة',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال رقم اللوحة';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Vehicle Color
              TextFormField(
                controller: _vehicleColorController,
                decoration: InputDecoration(
                  labelText: 'لون المركبة',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),

              // Vehicle Year
              TextFormField(
                controller: _vehicleYearController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'سنة الصنع',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 30),

              // Insurance Section
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'معلومات التأمين',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 15),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'رقم وثيقة التأمين',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 15),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'تاريخ انتهاء التأمين',
                          border: OutlineInputBorder(),
                        ),
                        onTap: () {
                          // TODO: Show date picker
                        },
                      ),
                      SizedBox(height: 15),
                      ElevatedButton.icon(
                        onPressed: () {
                          // TODO: Upload insurance document
                        },
                        icon: Icon(Icons.upload),
                        label: Text('رفع وثيقة التأمين'),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),

              // Error Message
              if (authProvider.error.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red),
                  ),
                  child: Text(
                    authProvider.error,
                    style: TextStyle(color: Colors.red),
                  ),
                ),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: authProvider.isLoading
                      ? null
                      : () => _saveVehicleInfo(authProvider),
                  child: authProvider.isLoading
                      ? CircularProgressIndicator()
                      : Text(
                          'حفظ معلومات المركبة',
                          style: TextStyle(fontSize: 16),
                        ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveVehicleInfo(AuthProvider authProvider) async {
    if (_formKey.currentState!.validate()) {
      final vehicleInfo = {
        'type': _selectedVehicleType,
        'model': _vehicleModelController.text,
        'licensePlate': _licensePlateController.text,
        'color': _vehicleColorController.text,
        'year': _vehicleYearController.text.isNotEmpty 
            ? int.tryParse(_vehicleYearController.text) 
            : null,
      };

      final success = await authProvider.completeProfile({
        'vehicleInfo': vehicleInfo,
      });

      if (success && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تم حفظ معلومات المركبة بنجاح')),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  void dispose() {
    _vehicleTypeController.dispose();
    _vehicleModelController.dispose();
    _licensePlateController.dispose();
    _vehicleColorController.dispose();
    _vehicleYearController.dispose();
    super.dispose();
  }
}