import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:projecy/App/core/models/personel_list_model.dart';

class PersonellistRepository {


  final String baseUrl =
      "https://beechem.ishtech.live/api/personnel-details"; // change this

  Future<List<PersonnelData>> getPersonnelList(String token) async {
    final url = Uri.parse(baseUrl);

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": token, // your bearer token
      },
      body: jsonEncode({}), // add body if your API needs
    );

    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);
      final data = PersonnelResponse.fromJson(jsonBody);
      return data.data;
    } else {
      throw Exception("Failed to fetch personnel list");
    }
  }
}

