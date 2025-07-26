Smart Dropdown
A highly customizable Flutter dropdown widget with single and multi-selection, search functionality, and the ability to create new items dynamically. The SmartDropdown widget is built on top of the moon_design package and provides a sleek, modern UI with extensive configuration options for developers.
Features

Single and Multi-Selection: Supports both single-item selection and multiple-item selection with a checkbox-based interface.
Searchable Dropdown: Filter items dynamically with a built-in search field, supporting both synchronous and asynchronous data sources.
Create New Items: Add new items to the dropdown list on-the-fly via user input, with support for Enter key or tap-based creation.
Keyboard Navigation: Navigate through dropdown options using arrow keys and select items with the Enter key.
Customizable UI: Configure colors, border radius, height, leading/trailing widgets, and more to match your app's design.
Asynchronous Data Support: Load items asynchronously with a loading indicator for seamless integration with APIs.
Error Handling: Display custom error messages or a "Create" option when no items match the search query.
Responsive Design: Adapts to different screen sizes with constrained dropdown height and smooth scrolling.

Installation
Add smart_dropdown to your pubspec.yaml:
dependencies:
  smart_dropdown: ^1.0.0
  moon_design: ^0.7.0
  figma_squircle: ^0.5.3

Run the following command to install the package:
flutter pub get

Then, import it in your Dart code:
import 'package:smart_dropdown/smart_dropdown.dart';

Usage
Basic Single-Selection Dropdown
import 'package:flutter/material.dart';
import 'package:smart_dropdown/smart_dropdown.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SmartDropdown<String>(
            hintText: 'Select a fruit',
            items: ['Apple', 'Banana', 'Orange'],
            onChanged: (String? value) {
              print('Selected: $value');
            },
            itemAsString: (String value) => value,
          ),
        ),
      ),
    );
  }
}

Multi-Selection Dropdown with Item Creation
import 'package:flutter/material.dart';
import 'package:smart_dropdown/smart_dropdown.dart';

class MultiDropdownDemo extends StatefulWidget {
  const MultiDropdownDemo({super.key});

  @override
  _MultiDropdownDemoState createState() => _MultiDropdownDemoState();
}

class _MultiDropdownDemoState extends State<MultiDropdownDemo> {
  List<String> items = ['Apple', 'Banana', 'Orange'];
  List<String> selectedValues = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SmartDropdown<String>(
          hintText: 'Select fruits',
          items: items,
          values: selectedValues,
          isMultiple: true,
          onListChanged: (List<String>? values) {
            setState(() {
              selectedValues = values ?? [];
            });
            print('Selected: $values');
          },
          onCreateTap: (String? newValue) async {
            if (newValue != null && newValue.isNotEmpty) {
              setState(() {
                items.add(newValue);
                selectedValues.add(newValue);
              });
            }
          },
          itemAsString: (String value) => value,
          createOnEnter: true,
        ),
      ),
    );
  }
}

Properties
The SmartDropdown widget is highly customizable. Below is a table of all available properties:



Property
Type
Description
Default Value



items
List<T>?
List of items to display in the dropdown.
null


value
T?
Selected value for single-selection mode.
null


values
List<T>?
Selected values for multi-selection mode.
null


onChanged
void Function(T?)?
Callback for single-selection changes.
null


onListChanged
void Function(List<T>?)?
Callback for multi-selection changes.
null


onCreateTap
Function(String?)?
Callback to handle creation of new items.
null


isMultiple
bool
Enables multi-selection mode.
false


showMultipleCount
bool
Shows the count of selected items in multi-selection mode.
true


hintText
String
Placeholder text for the input field.
Required


errorMessage
String?
Custom error message when no items are found.
'No results found.'


activeBorderColor
Color?
Border color when the input field is active.
Colors.red


inactiveBorderColor
Color?
Border color when the input field is inactive.
MoonColors.light.beerus


hoverBorderColor
Color?
Border color when the input field is hovered.
MoonColors.light.beerus


arrowColor
Color?
Color of the dropdown arrow icon.
Colors.grey


readOnly
bool?
Makes the input field read-only.
false


borderRadius
BorderRadiusGeometry?
Border radius for the input field.
null


enableArrow
bool?
Shows or hides the dropdown arrow.
true


trailing
Widget?
Custom trailing widget for the input field.
null


itemAsString
Function(T)?
Converts an item to its string representation.
null


inputFormatters
List<TextInputFormatter>?
Formatters for the input field.
null


asyncItems
Future<List<T>> Function(String)?
Async callback to fetch items based on search input.
null


createOnEnter
bool
Allows creating new items by pressing Enter.
true


leading
Widget?
Custom leading widget for the input field.
null


showDropdownOnlyOnSearch
bool?
Shows dropdown only when search input is provided.
false


height
double?
Height of the input field.
45


backgroundColor
Color?
Background color of the input field.
null


Example App
For a complete example, check the example folder in the package repository. It includes a demo app showcasing both single and multi-selection dropdowns with item creation and search functionality.
Dependencies



Contributing
Contributions are welcome! Please open an issue or submit a pull request on the GitHub repository.
License
This package is licensed under the MIT License. See the LICENSE file for details.