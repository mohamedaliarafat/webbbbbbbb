import 'package:customer/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class DocumentsUploadScreen extends StatefulWidget {
  @override
  _DocumentsUploadScreenState createState() => _DocumentsUploadScreenState();
}

class _DocumentsUploadScreenState extends State<DocumentsUploadScreen> {
  final Map<String, String> _uploadedDocuments = {};

  final List<Map<String, String>> _requiredDocuments = [
    {
      'name': 'commercialLicense',
      'title': 'رخصة تجارية',
      'description': 'رفع صورة الرخصة التجارية سارية المفعول'
    },
    {
      'name': 'energyLicense', 
      'title': 'رخصة الطاقة',
      'description': 'رفع صورة رخصة الطاقة'
    },
    {
      'name': 'commercialRecord',
      'title': 'السجل التجاري', 
      'description': 'رفع صورة السجل التجاري'
    },
    {
      'name': 'taxNumber',
      'title': 'الرقم الضريبي',
      'description': 'رفع صورة الشهادة الضريبية'
    },
    {
      'name': 'nationalAddressDocument',
      'title': 'وثيقة العنوان الوطني',
      'description': 'رفع وثيقة العنوان الوطني'
    },
    {
      'name': 'civilDefenseLicense',
      'title': 'رخصة الدفاع المدني',
      'description': 'رفع رخصة الدفاع المدني سارية المفعول'
    },
  ];

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('رفع المستندات'),
        actions: [
          if (_uploadedDocuments.length == _requiredDocuments.length)
            IconButton(
              icon: Icon(Icons.check),
              onPressed: () => _submitDocuments(authProvider),
            ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'المستندات المطلوبة',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'يرجى رفع جميع المستندات المطلوبة لإكمال عملية التسجيل',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemCount: _requiredDocuments.length,
                itemBuilder: (context, index) {
                  final doc = _requiredDocuments[index];
                  final isUploaded = _uploadedDocuments.containsKey(doc['name']);

                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: Icon(
                        isUploaded ? Icons.check_circle : Icons.description,
                        color: isUploaded ? Colors.green : Colors.grey,
                      ),
                      title: Text(doc['title']!),
                      subtitle: Text(doc['description']!),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isUploaded)
                            IconButton(
                              icon: Icon(Icons.visibility, color: Colors.blue),
                              onPressed: () {
                                // TODO: View document
                              },
                            ),
                          IconButton(
                            icon: Icon(isUploaded ? Icons.edit : Icons.upload),
                            onPressed: () => _uploadDocument(doc['name']!),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

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
            SizedBox(height: 10),

            // Submit Button
            if (_uploadedDocuments.length == _requiredDocuments.length)
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: authProvider.isLoading
                      ? null
                      : () => _submitDocuments(authProvider),
                  child: authProvider.isLoading
                      ? CircularProgressIndicator()
                      : Text(
                          'إرسال المستندات',
                          style: TextStyle(fontSize: 16),
                        ),
                ),
              ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _uploadDocument(String documentName) {
    // TODO: Implement document picker and upload
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('رفع المستند'),
        content: Text('اختر طريقة رفع المستند'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _pickDocumentFromGallery(documentName);
            },
            child: Text('المعرض'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _pickDocumentFromCamera(documentName);
            },
            child: Text('الكاميرا'),
          ),
        ],
      ),
    );
  }

  void _pickDocumentFromGallery(String documentName) {
    // TODO: Implement gallery picker
    setState(() {
      _uploadedDocuments[documentName] = 'document_path_here';
    });
  }

  void _pickDocumentFromCamera(String documentName) {
    // TODO: Implement camera picker
    setState(() {
      _uploadedDocuments[documentName] = 'document_path_here';
    });
  }

  Future<void> _submitDocuments(AuthProvider authProvider) async {
    final success = await authProvider.uploadDocuments(_uploadedDocuments);
    
    if (success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم رفع المستندات بنجاح')),
      );
      Navigator.pushReplacementNamed(context, '/home');
    }
  }
}