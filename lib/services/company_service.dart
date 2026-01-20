// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:flutter_dotenv/flutter_dotenv.dart';

// import '../models/company.dart';
// import '../models/product_detail.dart';

// class CompanyService {
//   final String baseUrl = dotenv.env['BASE_URL']!;

//   /// تحميل قائمة الشركات
//   Future<List<Company>> fetchCompanies(String token) async {
//     final response = await http.get(
//       Uri.parse('$baseUrl/api/companies/'),
//       headers: {
//         'Authorization': 'Bearer $token',
//         'Content-Type': 'application/json',
//       },
//     );

//     if (response.statusCode == 200) {
//       final body = jsonDecode(response.body);

//       // ✅ تأكد من أن الرد يحتوي على 'results'
//       if (body is Map && body.containsKey('results')) {
//         final List<dynamic> results = body['results'];
//         return results.map((json) => Company.fromJson(json)).toList();
//       } else {
//         throw Exception('⚠ Unexpected format for company list');
//       }
//     } else {
//       throw Exception('❌ Failed to load companies (${response.statusCode})');
//     }
//   }

//   /// تحميل المنتجات التابعة لشركة معينة
//   Future<List<ProductDetail>> fetchProductsByCompany(
//       String token, int companyId) async {
//     final response = await http.get(
//       Uri.parse('$baseUrl/api/products/?company_id=$companyId'),
//       headers: {
//         'Authorization': 'Bearer $token',
//         'Content-Type': 'application/json',
//       },
//     );

//     if (response.statusCode == 200) {
//       final body = jsonDecode(response.body);
//       if (body is Map && body.containsKey('results')) {
//         final List<dynamic> results = body['results'];
//         return results.map((json) => ProductDetail.fromJson(json)).toList();
//       }
//       throw Exception('⚠ Unexpected format for product list');
//     } else {
//       throw Exception(
//           '❌ Failed to load products for company (${response.statusCode})');
//     }
//   }
// }


import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/company.dart';
import '../models/product_detail.dart';

class CompanyService {
  final String baseUrl = dotenv.env['BASE_URL']!;

  /// تحميل قائمة الشركات
  Future<List<Company>> fetchCompanies(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/companies/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

      // ✅ تأكد من أن الرد يحتوي على 'results'
      if (body is Map && body.containsKey('results')) {
        final List<dynamic> results = body['results'];
        return results.map((json) => Company.fromJson(json)).toList();
      } else {
        throw Exception('⚠ Unexpected format for company list');
      }
    } else {
      throw Exception('❌ Failed to load companies (${response.statusCode})');
    }
  }

  /// تحميل المنتجات التابعة لشركة معينة
  Future<List<ProductDetail>> fetchProductsByCompany(
      String token, int companyId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/products/?company_id=$companyId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      if (body is Map && body.containsKey('results')) {
        final List<dynamic> results = body['results'];
        return results.map((json) => ProductDetail.fromJson(json)).toList();
      }
      throw Exception('⚠ Unexpected format for product list');
    } else {
      throw Exception(
          '❌ Failed to load products for company (${response.statusCode})');
    }
  }
}
