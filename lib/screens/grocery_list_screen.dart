import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_groceries_app/models/grocery_item.dart';
import 'package:simple_groceries_app/providers/grocery_items_provider.dart';
import 'package:simple_groceries_app/screens/add_item_screen.dart';
import 'package:simple_groceries_app/utils/app_layout.dart';

class GroceryListScreen extends ConsumerStatefulWidget {
  const GroceryListScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<GroceryListScreen> createState() => _GroceryListScreenState();
}

class _GroceryListScreenState extends ConsumerState<GroceryListScreen> {
  void _onAddItem() async {
    final groceryItem =
        await Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
      return const NewItemScreen();
    }));

    if (groceryItem != null) {
      ref.read(groceryItemsProvider.notifier).addItem(groceryItem);
    }
  }

  Future<bool?> _showConfirmDialog(GroceryItem item) async{
     return showDialog<bool>(
      context: context,
      builder: (ctx) {
        if (Platform.isAndroid) {
          return AlertDialog(
            title: const Text("Do you want to delete?"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text("Yes"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text("Cancel"),
              ),
            ],
          );
        } else {
          return CupertinoAlertDialog(
            title: const Text("Do you want to delete?"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text("Yes"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text("Cancel"),
              ),
            ],
          );
        }
      },
    );
  }

  void _removeItem(GroceryItem groceryItem) {
    var index = ref.read(groceryItemsProvider).indexOf(groceryItem);
    ref.read(groceryItemsProvider.notifier).removeItem(groceryItem);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Item removed"),
      action: SnackBarAction(
        label: "Undo",
        onPressed: () {
          ref.read(groceryItemsProvider.notifier).addItem(groceryItem, index);
        },
      ),
      behavior: SnackBarBehavior.floating,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final groceryItems = ref.watch(groceryItemsProvider);
    final displayHeight = AppLayout.displayHeightWithoutAppBar(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Your groceries",
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
              ),
        ),
        actions: [
          IconButton(
            onPressed: _onAddItem,
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(top: displayHeight * 0.02),
        child: ListView.builder(
          itemCount: groceryItems.length,
          itemBuilder: (ctx, index) {
            return LayoutBuilder(builder: (ctx, constraints) {
              return Dismissible(
                key: ValueKey(groceryItems[index].id),
                confirmDismiss: (direction){
                  var respo = _showConfirmDialog(groceryItems[index]);
                  return respo;
                },
                child: ListTile(
                  leading: Container(
                    decoration: BoxDecoration(
                      color: groceryItems[index].category!.color,
                    ),
                    width: constraints.maxWidth * 0.1,
                    height: constraints.maxWidth * 0.1,
                  ),
                  title: Text(
                    groceryItems[index].name,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground),
                  ),
                  trailing: Text(
                    groceryItems[index].quantity.toString(),
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                  ),
                ),
                onDismissed: (direction) {
                  _removeItem(groceryItems[index]);
                },
              );
            });
          },
        ),
      ),
    );
  }
}
