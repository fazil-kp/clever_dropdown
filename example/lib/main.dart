import 'package:clever_dropdown/clever_dropdown.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dropdown Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: const TextTheme(bodySmall: TextStyle(fontSize: 14)),
      ),
      home: const DropdownDemoPage(),
    );
  }
}

class DropdownDemoPage extends StatefulWidget {
  const DropdownDemoPage({super.key});

  @override
  _DropdownDemoPageState createState() => _DropdownDemoPageState();
}

class _DropdownDemoPageState extends State<DropdownDemoPage> {
  String? selectedSingleValue;
  List<String> selectedMultiValues = [];
  List<String> items = ['Apple', 'Banana', 'Orange', 'Mango', 'Grapes'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CleverDropDown Demo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Single Selection Dropdown', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            CleverDropdown<String>(
              hintText: 'Select a fruit',
              items: items,
              value: selectedSingleValue,
              onChanged: (String? value) {
                setState(() {
                  selectedSingleValue = value;
                });
                print('Selected single value: $value');
              },
              onCreateTap: (String? newValue) async {
                if (newValue != null && newValue.isNotEmpty) {
                  setState(() {
                    items.add(newValue);
                    selectedSingleValue = newValue;
                  });
                  print('Added new value: $newValue');
                }
                return;
              },
              itemAsString: (String value) => value,
            ),
            const SizedBox(height: 20),
            Text('Selected: ${selectedSingleValue ?? "None"}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 30),
            const Text('Multi Selection Dropdown', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            CleverDropdown<String>(
              hintText: 'Select fruits',
              items: items,
              values: selectedMultiValues,
              isMultiple: true,
              onListChanged: (List<String>? values) {
                setState(() {
                  selectedMultiValues = values ?? [];
                });
                print('Selected multi values: $values');
              },
              onCreateTap: (String? newValue) async {
                if (newValue != null && newValue.isNotEmpty) {
                  setState(() {
                    items.add(newValue);
                    selectedMultiValues.add(newValue);
                  });
                  print('Added new value: $newValue');
                }
                return;
              },
              itemAsString: (String value) => value,
              createOnEnter: true,
            ),
            const SizedBox(height: 20),
            Text('Selected: ${selectedMultiValues.isEmpty ? "None" : selectedMultiValues.join(", ")}', style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
