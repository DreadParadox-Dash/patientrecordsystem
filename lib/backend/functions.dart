import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';


class Functions extends ChangeNotifier {
  // List<Card> pListTile = [];
  //
  // Future addToPList(patients) async {
  //   pListTile = patients.map<Card>((patient) {
  //     // print('Pasyente:: $patient');
  //     return Card.outlined(
  //       margin: const EdgeInsets.all(8.0),
  //       child: Padding(
  //         padding: const EdgeInsets.all(16.0),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             ListTile(
  //               leading: Icon(Icons.person_2_rounded),
  //               title: Text(
  //                 "Name: ${patient['fname'] ?? ''} ${patient['mname'] ?? ''} ${patient['lname'] ?? ''}",
  //                 style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  //               ),
  //               subtitle: Text.rich(TextSpan(children: [TextSpan(text: "Hospital ID: ", style: TextStyle(fontWeight: FontWeight.bold)), TextSpan(text: "${patient['id'].toString().padLeft(15, '0') ?? ''}") ])),
  //             ),
  //             const SizedBox(height: 8),
  //             Text.rich(TextSpan(children: [TextSpan(text: "Sex: ", style: TextStyle(fontWeight: FontWeight.bold)), TextSpan(text: "${patient['sex'] ?? ''}") ])),
  //             Text.rich(TextSpan(children: [TextSpan(text: "Birthdate: ", style: TextStyle(fontWeight: FontWeight.bold)), TextSpan(text: "${patient['bdate'] ?? ''}") ])),
  //             Text.rich(TextSpan(children: [TextSpan(text: "Civil Status: ", style: TextStyle(fontWeight: FontWeight.bold)), TextSpan(text: "${patient['civstat'] ?? ''}") ])),
  //             Text.rich(TextSpan(children: [TextSpan(text: "Nationality: ", style: TextStyle(fontWeight: FontWeight.bold)), TextSpan(text: "${patient['nlity'] ?? ''}") ])),
  //             Text.rich(TextSpan(children: [TextSpan(text: "Home Address: ", style: TextStyle(fontWeight: FontWeight.bold)), TextSpan(text: "${patient['hadd'] ?? ''}") ])),
  //             Text.rich(TextSpan(children: [TextSpan(text: "Billing Address: ", style: TextStyle(fontWeight: FontWeight.bold)), TextSpan(text: "${patient['badd'] ?? ''}") ])),
  //             Text.rich(TextSpan(children: [TextSpan(text: "Phone Number: ", style: TextStyle(fontWeight: FontWeight.bold)), TextSpan(text: "${patient['pnum'] ?? ''}") ])),
  //             Text.rich(TextSpan(children: [TextSpan(text: "Email: ", style: TextStyle(fontWeight: FontWeight.bold)), TextSpan(text: "${patient['email'] ?? ''}") ])),
  //             Text.rich(TextSpan(children: [TextSpan(text: "PhilHealth Number: ", style: TextStyle(fontWeight: FontWeight.bold)), TextSpan(text: "${patient['philnum'] ?? ''}") ])),
  //             Text.rich(TextSpan(children: [TextSpan(text: "Occupation: ", style: TextStyle(fontWeight: FontWeight.bold)), TextSpan(text: "${patient['occup'] ?? ''}") ])),
  //             Text.rich(TextSpan(children: [TextSpan(text: "Religion: ", style: TextStyle(fontWeight: FontWeight.bold)), TextSpan(text: "${patient['rlgion'] ?? ''}") ])),
  //             SizedBox(height: 20,),
  //             OverflowBar(
  //               alignment: MainAxisAlignment.start,
  //               spacing: 20,
  //               children: [
  //                 TextButton.icon(
  //                   onPressed: () {},
  //                   icon: const Icon(Icons.edit_rounded),
  //                   label: const Text('Edit'),
  //                 ),
  //                 TextButton.icon(
  //                   onPressed: () {},
  //                   icon: const Icon(Icons.delete_rounded),
  //                   label: const Text('Delete'),
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  //       ),
  //     );
  //   }).toList();
  //   print(pListTile.length);
  //   notifyListeners();
  // }

  Future<List<dynamic>?> fetchPatients({String sortBy = 'id', String order = 'asc'}) async {
    final Uri apiUrl = Uri.parse('http://127.0.0.1:8000/allpatient?sortBy=$sortBy&order=$order');

    try {
      final response = await http.get(
        apiUrl,
        headers: {
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          return data['data']; // Return list of patients
        } else {
          print('Error: ${data['message']}');
          return null;
        }
      } else {
        print('Failed to fetch patients: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching patients: $e');
      return null;
    }
  }

  Future addPatient(Map<String, dynamic> patientInfo) async {
    final String apiUrl = "http://127.0.0.1:8000/addpatient";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type' : 'application/json; charset=UTF-8',
        },
        body: jsonEncode(patientInfo),
      );

      if (response.statusCode == 201) {
        print("Patient added: ${response.body}");
      } else {
        print("Failed to add patient. Status code: ${response.statusCode}");
        print("Response: ${response.body}");
      }
    } catch (e) {
      print("Exception: $e");
    }
  }

  Future findPatient(int hospitalid) async {
    final String apiUrl = "http://127.0.0.1:8000/selectpatient/$hospitalid";

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final patientData = jsonDecode(response.body);
        Map<String, dynamic> patient = patientData['data'];
        print(patientData);
        return patient;
      } else {
        print("Patient not found. and Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching patient: $e");
    }
  }

  Future<List?> searchPatients(String query) async {
    final String apiUrl = "http://127.0.0.1:8000/searchpatient?query=$query";

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> patientsdatas = jsonDecode(response.body);
        List patients = patientsdatas['data'];
        if (patients.isEmpty) {
          return null;
        } else {
          return patients;
        }
      } else {
        print("Search failed with status: ${response.statusCode}");
        print("Response: ${response.body}");
      }
    } catch (e) {
      print("Error searching for patients: $e");
    }
  }

  Future<bool> softDeletePatient(int id) async {
    final String apiUrl = 'http://127.0.0.1:8000/patient/$id/delete';

    try {
      final response = await http.put(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to delete patient. Status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Exception occurred: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>?> updatePatient(int id, Map<String, dynamic> updatedData) async {
    final String apiUrl = 'http://127.0.0.1:8000/editpatient/$id';

    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(updatedData),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("Failed to update patient: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Error updating patient: $e");
      return null;
    }
  }

  Future downloadPdf() async {
    final Uri fileUri = Uri.parse('https://drive.google.com/uc?export=download&id=1MU-hlUMU-5KlTulNSXvQb0wGPV8pULjX');

    await launchUrl(fileUri, mode: LaunchMode.externalApplication);
  }

}