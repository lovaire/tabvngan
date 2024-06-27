import 'dart:convert';
//import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/savings.dart';

class SavingsService {
  final String _baseUrl =
      'https://yourbackend.com/api'; // Ganti dengan URL backend Anda

  Future<List<Savings>> getSavings() async {
    final response = await http.get(Uri.parse('$_baseUrl/savings'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Savings.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load savings');
    }
  }

  Future<void> addSavings({
    required String title,
    required double targetAmount,
    required double currentAmount,
    String? imagePath,
  }) async {
    final request =
        http.MultipartRequest('POST', Uri.parse('$_baseUrl/savings'))
          ..fields['title'] = title
          ..fields['targetAmount'] = targetAmount.toString()
          ..fields['currentAmount'] = currentAmount.toString();

    if (imagePath != null) {
      request.files.add(await http.MultipartFile.fromPath('image', imagePath));
    }

    final response = await request.send();

    if (response.statusCode != 201) {
      throw Exception('Failed to add savings');
    }
  }
}
