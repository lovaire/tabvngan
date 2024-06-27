import 'dart:io'; // Import ini digunakan untuk menangani file gambar yang dipilih
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/savings_service.dart';

class AddSavingsScreen extends StatefulWidget {
  @override
  _AddSavingsScreenState createState() => _AddSavingsScreenState();
}

class _AddSavingsScreenState extends State<AddSavingsScreen> {
  final _titleController = TextEditingController();
  final _targetAmountController = TextEditingController();
  final _currentAmountController = TextEditingController();
  final _savingsService = SavingsService();
  File? _image;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<void> _saveSavings() async {
    final title = _titleController.text;
    final targetAmount = double.parse(_targetAmountController.text);
    final currentAmount = double.parse(_currentAmountController.text);

    await _savingsService.addSavings(
      title: title,
      targetAmount: targetAmount,
      currentAmount: currentAmount,
      imagePath: _image?.path,
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Savings'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: _targetAmountController,
                decoration: InputDecoration(labelText: 'Target Amount'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _currentAmountController,
                decoration: InputDecoration(labelText: 'Current Amount'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              _image == null
                  ? Text('No image selected.')
                  : Image.file(_image!),
              TextButton(
                onPressed: _pickImage,
                child: Text('Pick Image'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveSavings,
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
