import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:simple_groceries_app/data/categories.dart';
import 'package:simple_groceries_app/utils/app_layout.dart';

class NewItemScreen extends StatefulWidget {
  const NewItemScreen({Key? key}) : super(key: key);

  @override
  State<NewItemScreen> createState() => _NewItemScreenState();
}

class _NewItemScreenState extends State<NewItemScreen> {
  final _formKey = GlobalKey<FormState>();
  var _title;
  var _quantity;
  var _category = categories.entries.first.value;

  void _saveItem() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      var url = Uri.https(
          "flutter-prep-6adb1-default-rtdb.firebaseio.com",
          "shopping-list.json");
      http.post(
        url,
        headers: {
          'Content-type': ContentType.json.value
        },
        body: jsonEncode({
          'title': _title,
          'quantity': _quantity,
          'category': _category.title
        })
      ).then((response) {
        Navigator.of(context).pop();
      });
      // Navigator.of(context).pop(
      //   GroceryItem(
      //     id: DateTime.now().toString(),
      //     name: _title,
      //     quantity: _quantity,
      //     category: _category,
      //   ),
      // );
    }
  }

  void _resetForm() {
    _formKey.currentState!.reset();
  }

  @override
  Widget build(BuildContext context) {
    final displayWidth = AppLayout.displayWidth(context);
    final displayHeight = AppLayout.displayHeightWithoutAppBar(context);

    return Scaffold(
        appBar: AppBar(
          title: const Text("New Item"),
        ),
        body: Padding(
          padding: EdgeInsets.all(displayWidth * 0.05),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  maxLines: 1,
                  decoration: const InputDecoration(
                    label: Text('Title'),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.trim().isEmpty ||
                        value.trim().length == 1 ||
                        value.trim().length >= 50) {
                      return "Title must be between 1 and 50";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _title = value;
                  },
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: '1',
                        decoration: const InputDecoration(
                          label: Text('Quantity'),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              int.tryParse(value) == null ||
                              int.tryParse(value)! <= 0) {
                            return "Must be a valid, positive number";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _quantity = int.tryParse(value!);
                        },
                      ),
                    ),
                    SizedBox(
                      width: displayWidth * 0.01,
                    ),
                    Expanded(
                      child: DropdownButtonFormField(
                        value: _category,
                        items: [
                          for (final category in categories.entries)
                            DropdownMenuItem(
                              value: category.value,
                              child: Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: category.value.color,
                                    ),
                                    width: displayWidth * 0.05,
                                    height: displayWidth * 0.05,
                                  ),
                                  SizedBox(
                                    width: displayWidth * 0.03,
                                  ),
                                  Text(
                                    category.value.title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onBackground),
                                  )
                                ],
                              ),
                            )
                        ],
                        onChanged: (value) {
                          setState(() {
                            _category = value!;
                          });
                        },
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: displayHeight * 0.03,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _resetForm,
                      child: const Text("Reset"),
                    ),
                    ElevatedButton(
                      onPressed: _saveItem,
                      child: const Text("Add item"),
                    )
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
