import 'package:flutter/material.dart';
import 'package:patientrecordsystem/backend/functions.dart';

class pListView extends StatefulWidget {
  const pListView({super.key});

  @override
  State<pListView> createState() => _pListViewState();
}

class _pListViewState extends State<pListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Patient'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.app_registration),
            tooltip: 'Register Patient',
            onPressed: () {
              Navigator.of(context).pushNamed('/registration');
            },
          ),
          // IconButton(
          //   icon: const Icon(Icons.all_inbox),
          //   tooltip: 'Debug Button',
          //   onPressed: () {
          //     // Functions().fetchPatients();
          //     // setState(() {});
          //     Navigator.of(context).pushNamed('/edit', arguments: 1);
          //   },
          // ),
          // IconButton(
          //   icon: const Icon(Icons.details_rounded),
          //   tooltip: 'Debug Print',
          //   onPressed: () {
          //     Navigator.of(context).pushNamed('/display', arguments: 1);
          //     // Functions().findPatient(1);
          //   },
          // ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 20,),
          Center(child: SearchComponent()),
          SizedBox(height: 20,),
          Divider(),
          SizedBox(height: 20,),
          Expanded(child: PListComponent()),
        ],
      ),
    );
  }
}

class SearchComponent extends StatefulWidget {
  const SearchComponent({super.key});

  @override
  State<SearchComponent> createState() => _SearchComponentState();
}

class _SearchComponentState extends State<SearchComponent> {
  List? patients;
  String? query;

  void _onSearch(String query) async {
    final result = await Functions().searchPatients(query);
    setState(() {
      this.query = query;
      patients = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
    builder: (BuildContext context, SearchController controller) {
      return SearchBar(
        controller: controller,
        onChanged: (value) {
          if (value.isNotEmpty){
            print('CALLING...');
            _onSearch(value);
          }

        },
        onSubmitted: (_) {
          controller.openView();
          // controller.clear();
        },
        leading: Icon(
          Icons.search_rounded,
          color: Colors.black,
        ),
        hintText: 'Search Patient Name...',
      );
    },
    suggestionsBuilder: (BuildContext context, TextEditingController controller) {
      final query = controller.text.trim().toLowerCase();

      if (query.isEmpty) {
        return [
          const ListTile(
            title: Text('Type to search for patients...'),
          )
        ];
      }

      if (patients == null) {
        return [
          const ListTile(
            title: Text('No patients found.'),
          )
        ];
      }

      if (patients!.isEmpty) {
        return [
          const ListTile(
            title: Text('No patients found.'),
          )
        ];
      }

      return patients!.map<ListTile>((patient) {
        final String fullName = "${patient['fname']} ${patient['mname'] ?? ''} ${patient['lname']}";
        return ListTile(
          title: Text(fullName),
          onTap: () {
            // Functions().addToPList(patients);
            // Functions().findPatient(patient['id']);
            Navigator.of(context).pushNamed('/display', arguments: patient['id']);
          }
        );
      }).toList();
    });
  }
}

// class PListComponent extends StatefulWidget {
//   const PListComponent({super.key});
//
//   @override
//   State<PListComponent> createState() => _PListComponentState();
// }
//
// class _PListComponentState extends State<PListComponent> {
//   bool _isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     // Fetch patients when the page initializes
//     // Provider.of<Functions>(context, listen: false).fetchPatients().then((_) {
//     //   setState(() {
//     //     _isLoading = false;
//     //   });
//     // });
//     setState(() {
//       _isLoading = false;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final functions = Provider.of<Functions>(context);
//     return _isLoading
//       ? const Center(child: CircularProgressIndicator(),)
//       : functions.pListTile.isNotEmpty
//         ? RefreshIndicator(
//           onRefresh: () async {
//             setState(() {
//               _isLoading = true;
//             });
//             await functions.fetchPatients();
//             setState(() {
//               _isLoading = false;
//             });
//           },
//           child: ListView.builder(
//             itemCount: functions.pListTile.length,
//             itemBuilder: (context, index) {
//               return functions.pListTile[index];
//             }
//           ),
//         )
//         : const Center(child: Text('No Patients Found'),);
//   }
// }

class PListComponent extends StatefulWidget {
  const PListComponent({super.key});

  @override
  State<PListComponent> createState() => _PListComponentState();
}

class _PListComponentState extends State<PListComponent> {
  String _col = 'id';
  String _order = 'asc';
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(width: 30,),
            Expanded(
              child: DropdownButtonFormField<String>(
                value: _col,
                decoration: const InputDecoration(
                  labelText: 'Column',
                  enabledBorder: OutlineInputBorder(),
                ),
                items: <String>['id', 'mname', 'fname', 'lname', 'bdate'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) => setState(() => _col = newValue!),
                validator: (value) =>
                value == null || value.isEmpty ? 'Please select a Column' : null,
              ),
            ),
            SizedBox(width: 30,),
            Expanded(
              child: DropdownButtonFormField<String>(
                value: _order,
                decoration: const InputDecoration(
                  labelText: 'Order by',
                  enabledBorder: OutlineInputBorder(),
                ),
                items: <String>['asc', 'desc'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) => setState(() => _order = newValue!),
                validator: (value) =>
                value == null || value.isEmpty ? 'Please select an order' : null,
              ),
            ),
            SizedBox(width: 30,),
          ],
        ),
        FutureBuilder(
          future: Functions().fetchPatients(sortBy: _col, order: _order),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator(),);
            } else if (snapshot.hasError) {
              return Center(child: Text('Error fetching patients.'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty || snapshot.data == null) {
              return Center(child: Text('No patients found.'));
            } else {
              return Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final patient = snapshot.data![index];
                    return ListTile(
                      leading: Icon(Icons.person_2_rounded),
                      title: Text(
                        "Name: ${patient['fname'] ?? ''} ${patient['mname'] ?? ''} ${patient['lname'] ?? ''}",
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text.rich(TextSpan(children: [TextSpan(text: "Hospital ID: ", style: TextStyle(fontWeight: FontWeight.bold)), TextSpan(text: patient['id'].toString().padLeft(15, '0') ?? '') ])),
                      onTap: () {
                        Navigator.of(context).pushNamed('/display', arguments: patient['id']);
                      },
                    );
                  },
                ),
              );
            }
          }
        )
      ],
    );
  }
}
