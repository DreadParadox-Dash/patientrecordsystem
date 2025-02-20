import 'package:flutter/material.dart';
import 'package:patientrecordsystem/backend/functions.dart';

class pRegisterView extends StatefulWidget {
  const pRegisterView({super.key});

  @override
  State<pRegisterView> createState() => _pRegisterViewState();
}

class _pRegisterViewState extends State<pRegisterView> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _fnameController = TextEditingController();
  final TextEditingController _mnameController = TextEditingController();
  final TextEditingController _lnameController = TextEditingController();
  final TextEditingController _bdateController = TextEditingController();
  final TextEditingController _civstatController = TextEditingController();
  final TextEditingController _nlityController = TextEditingController();
  final TextEditingController _haddController = TextEditingController();
  final TextEditingController _baddController = TextEditingController();
  final TextEditingController _pnumController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _philnumController = TextEditingController();
  final TextEditingController _occupController = TextEditingController();
  final TextEditingController _rlgionController = TextEditingController();

  String? _sex;
  DateTime? _selectedDate;
  bool _dpcon = false;
  bool _sdel = false;

  @override
  void dispose() {
    _fnameController.dispose();
    _mnameController.dispose();
    _lnameController.dispose();
    _bdateController.dispose();
    _civstatController.dispose();
    _nlityController.dispose();
    _haddController.dispose();
    _baddController.dispose();
    _pnumController.dispose();
    _emailController.dispose();
    _philnumController.dispose();
    _occupController.dispose();
    _rlgionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _bdateController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // debugPrint('First Name: ${_fnameController.text}');
      // debugPrint('Middle Name: ${_mnameController.text}');
      // debugPrint('Last Name: ${_lnameController.text}');
      // debugPrint('Sex: $_sex');
      // debugPrint('Birthdate: ${_bdateController.text}');
      // debugPrint('Civil Status: ${_civstatController.text}');
      // debugPrint('Nationality: ${_nlityController.text}');
      // debugPrint('Home Address: ${_haddController.text}');
      // debugPrint('Billing Address: ${_baddController.text}');
      // debugPrint('Phone Number: ${_pnumController.text}');
      // debugPrint('Email: ${_emailController.text}');
      // debugPrint('PhilHealth Number: ${_philnumController.text}');
      // debugPrint('Occupation: ${_occupController.text}');
      // debugPrint('Religion: ${_rlgionController.text}');
      // debugPrint('Data & Privacy Consent: $_dpcon');
      // debugPrint('Soft Deletion: $_sdel');

      if (_dpcon) {
        Map<String, dynamic> patientInfo = {
          'fname' : _fnameController.text,
          'mname' : _mnameController.text,
          'lname' : _lnameController.text,
          'sex' : _sex,
          'bdate' : _bdateController.text,
          'civstat' : _civstatController.text,
          'nlity' : _nlityController.text,
          'hadd' : _haddController.text,
          'badd' : _baddController.text,
          'pnum' : _pnumController.text,
          'email' : _emailController.text,
          'philnum' : _philnumController.text,
          'occup' : _occupController.text,
          'rlgion' : _rlgionController.text,
          'dpcon' : _dpcon,
          'sdel' : _sdel,
        };
        
        Functions().addPatient(patientInfo);
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please agree to Data & Privacy Consent.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please correct the errors in the form.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Registration'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          margin: EdgeInsets.all(20),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(
              width: 2,
            ),
            borderRadius: BorderRadius.circular(10)
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Patient Name
                Row(
                  children: [
                    // First Name
                    Expanded(
                      child: TextFormField(
                        controller: _fnameController,
                        decoration: const InputDecoration(
                          labelText: 'First Name',
                          enabledBorder: OutlineInputBorder(),
                          icon: Icon(Icons.person_2_rounded),
                        ),
                        validator: (value) =>
                        value == null || value.isEmpty ? 'Please enter first name' : null,
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Middle Name
                    Expanded(
                      child: TextFormField(
                        controller: _mnameController,
                        decoration: const InputDecoration(
                          labelText: 'Middle Name',
                          enabledBorder: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Last Name
                    Expanded(
                      child: TextFormField(
                        controller: _lnameController,
                        decoration: const InputDecoration(
                          labelText: 'Last Name',
                          enabledBorder: OutlineInputBorder(),
                        ),
                        validator: (value) =>
                        value == null || value.isEmpty ? 'Please enter last name' : null,
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
                const SizedBox(height: 30,),
                //Demographic Details
                Row(
                  children: [
                    // Sex (Dropdown)
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _sex,
                        decoration: const InputDecoration(
                          labelText: 'Sex',
                          enabledBorder: OutlineInputBorder(),
                        ),
                        items: <String>['Male', 'Female', 'Other'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newValue) => setState(() => _sex = newValue),
                        validator: (value) =>
                        value == null || value.isEmpty ? 'Please select sex' : null,
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Birthdate with DatePicker
                    Expanded(
                      child: TextFormField(
                        controller: _bdateController,
                        decoration: const InputDecoration(
                          labelText: 'Birthdate',
                          hintText: 'YYYY-MM-DD',
                          suffixIcon: Icon(Icons.calendar_today),
                          enabledBorder: OutlineInputBorder(),
                        ),
                        readOnly: true,
                        onTap: () => _selectDate(context),
                        validator: (value) =>
                        value == null || value.isEmpty ? 'Please select birthdate' : null,
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
                const SizedBox(height: 10,),
                Row(
                  children: [
                    // Civil Status
                    Expanded(
                      child: TextFormField(
                        controller: _civstatController,
                        decoration: const InputDecoration(
                          labelText: 'Civil Status',
                          enabledBorder: OutlineInputBorder(),
                        ),
                        validator: (value) =>
                        value == null || value.isEmpty ? 'Please enter civil status' : null,
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Nationality
                    Expanded(
                      child: TextFormField(
                        controller: _nlityController,
                        decoration: const InputDecoration(
                          labelText: 'Nationality',
                          enabledBorder: OutlineInputBorder(),
                        ),
                        validator: (value) =>
                        value == null || value.isEmpty ? 'Please enter nationality' : null,
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
                const SizedBox(height: 30,),
                //Contact Details
                Row(
                  children: [
                    Expanded(
                      // Home Address
                      child: TextFormField(
                        controller: _haddController,
                        decoration: const InputDecoration(
                          labelText: 'Home Address',
                          enabledBorder: OutlineInputBorder(),
                          icon: Icon(Icons.home_rounded)
                        ),
                        validator: (value) =>
                        value == null || value.isEmpty ? 'Please enter home address' : null,
                      ),
                    ),
                    const SizedBox(width: 10,),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      // Billing Address
                      child: TextFormField(
                        controller: _baddController,
                        decoration: const InputDecoration(
                          labelText: 'Billing Address',
                          enabledBorder: OutlineInputBorder(),
                          icon: Icon(Icons.monetization_on_rounded)
                        ),
                        validator: (value) =>
                        value == null || value.isEmpty ? 'Please enter billing address' : null,
                      ),
                    ),
                    const SizedBox(width: 10,),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    // Phone Number
                    Expanded(
                      child: TextFormField(
                        controller: _pnumController,
                        decoration: const InputDecoration(
                          labelText: 'Phone Number',
                          enabledBorder: OutlineInputBorder(),
                          icon: Icon(Icons.numbers_rounded)
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (value) =>
                        value == null || value.isEmpty ? 'Please enter phone number' : null,
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Email
                    Expanded(
                      child: TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          enabledBorder: OutlineInputBorder(),
                          icon: Icon(Icons.email_rounded)
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Please enter email';
                          final regex = RegExp(r'\S+@\S+\.\S+');
                          if (!regex.hasMatch(value)) return 'Please enter a valid email';
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
                const SizedBox(height: 10),
                // Occupation
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _occupController,
                        decoration: const InputDecoration(
                          labelText: 'Occupation',
                          enabledBorder: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Religion
                    Expanded(
                      child: TextFormField(
                        controller: _rlgionController,
                        decoration: const InputDecoration(
                          labelText: 'Religion',
                          enabledBorder: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
                const SizedBox(height: 10,),
                // PhilHealth Number
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _philnumController,
                        decoration: const InputDecoration(
                          labelText: 'PhilHealth Number',
                          enabledBorder: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
                const SizedBox(height: 30),
                // Data & Privacy Consent (Checkbox)
                CheckboxListTile(
                  title: InkWell(
                    onTap: Functions().downloadPdf,
                    child: Text('Data & Privacy Consent'),
                  ),
                  value: _dpcon,
                  onChanged: (bool? value) {
                    setState(() {
                      _dpcon = value ?? false;
                    });
                  },
                ),
                const SizedBox(height: 20),
                // Submit Button
                ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}