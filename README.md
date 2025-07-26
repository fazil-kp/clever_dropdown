# 📦 clever_dropdown

A highly customizable and powerful dropdown widget for Flutter with:

- 🔍 Real-time search
- ✅ Single & Multi-selection
- ➕ Support for adding new items
- ⚡ Async item loading


> `clever_dropdown` is perfect for forms, filters, settings, and searchable dropdown fields in Flutter apps — works across Android, iOS, Web, and Desktop.

---

## 🚀 Features

- 🔹 Single-selection dropdown
- 🔸 Multi-selection with checkboxes
- 🔍 Real-time filtering and search
- ➕ Dynamic "Add new" option
- 🌐 Async data fetching
- ⌨️ Keyboard navigation (Arrow ↑ ↓ + Enter)
- 🧩 Custom styling (radius, color, icons, borders)

---

## 📥 Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  clever_dropdown: latest_version
```

## 🔧 Usage


```
✅ Single Selection
CleverDropdown<String>(
  items: ['Apple', 'Banana', 'Orange'],
  value: 'Banana',
  onChanged: (value) {
    print('Selected: $value');
  },
  hintText: 'Select fruit',
  isMultiple: false,
)
```

```
✅ Multi Selection
CleverDropdown<String>(
  items: ['Red', 'Green', 'Blue'],
  isMultiple: true, // Make this true 
  initialValues: ['Red'],
  onChanged: (values) {
    print('Selected Colors: $values');
  },
  hintText: 'Select colors',
)
```
```
🧙 Create New Item

CleverDropdown<String>(
  ...
  onCreateTap: (newValue) {
    print("Create tapped with value: $newValue");
    // Add it to your backend or list
  },
)
```


## 🧾 Parameters 

| Parameter                  | Type                         | Required | Default        | Description                                        |
| -------------------------- | ---------------------------- | -------- | -------------- | -------------------------------------------------- |
| `items`                    | `List<T>`                    | No       | `[]`           | List of options for dropdown                       |
| `asyncItems`               | `Future<List<T>> Function()` | No       | `null`         | Fetch items asynchronously                         |
| `hintText`                 | `String`                     | No       | `'Select'`     | Placeholder text                                   |
| `isMultiple`               | `bool`                       | No       | `false`        | Enable multi-selection                             |
| `onChanged`                | `void Function(dynamic)`     | Yes      | `null`         | Callback for selection changes                     |
| `onCreateTap`              | `void Function(String)`      | No       | `null`         | Callback for adding new item (on Enter or tap)     |
| `itemAsString`             | `String Function(T)`         | No       | `null`         | Converts item to displayable string                |
| `enableAddItem`            | `bool`                       | No       | `false`        | Allow adding new values dynamically                |
| `maxListHeight`            | `double`                     | No       | `200.0`        | Max height of dropdown list                        |
| `smoothBorderRadius`       | `SmoothBorderRadius`         | No       | `default`      | Custom smooth border radius using `figma_squircle` |
| `dropdownColor`            | `Color`                      | No       | `Colors.white` | Dropdown background color                          |
| `borderColor`              | `Color`                      | No       | `Colors.grey`  | Outline border color                               |
| `showDropdownOnlyOnSearch` | `bool`                       | No       | `false`        | Show dropdown only when user types something       |
