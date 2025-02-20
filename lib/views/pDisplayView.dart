import 'package:flutter/material.dart';
import 'package:patientrecordsystem/backend/functions.dart';

class pDisplayView extends StatefulWidget {
  final int hospitalid;
  const pDisplayView({super.key, required this.hospitalid});

  @override
  State<pDisplayView> createState() => _pDisplayViewState();
}

class _pDisplayViewState extends State<pDisplayView> {
  late Map<String, dynamic> patient;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPatientData();
  }

  Future<void> _fetchPatientData() async {
    try {
      Map<String, dynamic> data = await Functions().findPatient(widget.hospitalid) as Map<String, dynamic>;
      setState(() {
        patient = data;
        _isLoading = false;
      });
    } catch (e) {
      print("Error fetching patient data: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Info'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : patient.isEmpty
          ? const Center(child: Text("No patient found"))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Patient Name
            Text(
              "Name: ${patient['fname'] ?? ''} ${patient['mname'] ?? ''} ${patient['lname'] ?? ''}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            //Hospital ID
            Text.rich(TextSpan(children: [TextSpan(text: "Hospital ID: ", style: TextStyle(fontWeight: FontWeight.bold)), TextSpan(text: "${patient['id'].toString().padLeft(15, '0') ?? ''}") ])),
            const SizedBox(height: 30),
            // Demographic Details
            Row(
              children: [
                // Sex (Dropdown)
                Text.rich(TextSpan(children: [TextSpan(text: "Sex: ", style: TextStyle(fontWeight: FontWeight.bold)), TextSpan(text: "${patient['sex'] ?? ''}") ])),
                const SizedBox(width: 10),
                // Birthdate
                Text.rich(TextSpan(children: [TextSpan(text: "Birthdate: ", style: TextStyle(fontWeight: FontWeight.bold)), TextSpan(text: "${patient['bdate'] ?? ''}") ])),
                const SizedBox(width: 10),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                // Civil Status
                Text.rich(TextSpan(children: [TextSpan(text: "Civil Status: ", style: TextStyle(fontWeight: FontWeight.bold)), TextSpan(text: "${patient['civstat'] ?? ''}") ])),
                const SizedBox(width: 10),
                // Nationality
                Text.rich(TextSpan(children: [TextSpan(text: "Nationality: ", style: TextStyle(fontWeight: FontWeight.bold)), TextSpan(text: "${patient['nlity'] ?? ''}") ])),
                const SizedBox(width: 10),
              ],
            ),
            const SizedBox(height: 30),
            // Contact Details
            Row(
              children: [
                Text.rich(TextSpan(children: [TextSpan(text: "Home Address: ", style: TextStyle(fontWeight: FontWeight.bold)), TextSpan(text: "${patient['hadd'] ?? ''}") ])),
                const SizedBox(width: 10),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text.rich(TextSpan(children: [TextSpan(text: "Billing Address: ", style: TextStyle(fontWeight: FontWeight.bold)), TextSpan(text: "${patient['badd'] ?? ''}") ])),
                const SizedBox(width: 10),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                // Phone Number
                Text.rich(TextSpan(children: [TextSpan(text: "Phone Number: ", style: TextStyle(fontWeight: FontWeight.bold)), TextSpan(text: "${patient['pnum'] ?? ''}") ])),
                const SizedBox(width: 10),
                // Email
                Text.rich(TextSpan(children: [TextSpan(text: "Email: ", style: TextStyle(fontWeight: FontWeight.bold)), TextSpan(text: "${patient['email'] ?? ''}") ])),
                const SizedBox(width: 10),
              ],
            ),
            const SizedBox(height: 10),
            // Occupation & Religion
            Row(
              children: [
                Text.rich(TextSpan(children: [TextSpan(text: "Occupation: ", style: TextStyle(fontWeight: FontWeight.bold)), TextSpan(text: "${patient['occup'] ?? ''}") ])),
                const SizedBox(width: 10),
                Text.rich(TextSpan(children: [TextSpan(text: "Religion: ", style: TextStyle(fontWeight: FontWeight.bold)), TextSpan(text: "${patient['rlgion'] ?? ''}") ])),
                const SizedBox(width: 10),
              ],
            ),
            const SizedBox(height: 10),
            // PhilHealth Number
            Row(
              children: [
                Text.rich(TextSpan(children: [TextSpan(text: "PhilHealth Number: ", style: TextStyle(fontWeight: FontWeight.bold)), TextSpan(text: "${patient['philnum'] ?? ''}") ])),
                const SizedBox(width: 10),
              ],
            ),
            const SizedBox(height: 30),
            OverflowBar(
              alignment: MainAxisAlignment.start,
              spacing: 20,
              children: [
                TextButton.icon(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/edit', arguments: patient['id']);
                  },
                  icon: const Icon(Icons.edit_rounded),
                  label: const Text('Edit'),
                ),
                TextButton.icon(
                  onPressed: () {
                    // Functions().softDeletePatient(patient['id']);
                    // setState(() {});
                    _showDelConfirm(context, patient['id']);
                    // Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.delete_rounded),
                  label: const Text('Delete'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Future _showDelConfirm(BuildContext context, int id) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Are you sure?'),
        content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Would you like to move this entry to the trash bin?'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Confirm'),
            onPressed: () async {
              Navigator.of(context).pop();
              await Functions().softDeletePatient(id);
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
