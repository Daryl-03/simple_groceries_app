import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_groceries_app/data/dummy_items.dart';
import 'package:simple_groceries_app/models/grocery_item.dart';

class GroceryItemsNotifier extends StateNotifier<List<GroceryItem>> {
  GroceryItemsNotifier() : super(
    groceryItems
  );

  bool addItem(GroceryItem item, [int? index]){
    if (!state.contains(item)){
      if(index != null){
        var prevState = List.of(state);
        prevState.insert(index, item);
        state = prevState;
      } else {
        state = [
          ...state,
          item
        ];
      }
    }
    return true;
  }

  bool removeItem(GroceryItem item){
    if (state.contains(item)){
      state = [
        ...state.where((element) => element != item)
      ];
    }
    return true;
  }
}

final groceryItemsProvider = StateNotifierProvider<GroceryItemsNotifier, List<GroceryItem>>((ref) {
  return GroceryItemsNotifier();
});