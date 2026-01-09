class ListDataModel {
  String id = '';
  List<Item> items = [];
  String ownerId = '';
  List<String> sharedWith = [];

  Map<String, List<Item>> get catItems {
    final Map<String, List<Item>> result = {};
    for (final item in items) {
      result.putIfAbsent(item.category, () => []).add(item);
    }
    return result;
  }
}

class Item {
  String text;
  bool checked = false;
  String category;

  Item(this.text, {this.category = 'default'});
}

Map<String, dynamic> itemToJson(Item item) {
  return {
    'text': item.text,
    'category': item.category,
    'checked': item.checked,
  };
}

Item itemFromJson(Map<String, dynamic> json) {
  return Item(
    json['text'] as String,
  )..checked = json['checked'] as bool? ?? false;
}

Map<String, dynamic> listDataModelToJson(ListDataModel model) {
  return {
    'id': model.id,
    'items': model.items.map((item) => itemToJson(item)).toList(),
    'ownerId': model.ownerId,
    'sharedWith': model.sharedWith,
  };
}

ListDataModel listDataModelFromJson(Map<String, dynamic> json) {
  return ListDataModel()
    ..id = json['id'] as String? ?? ''
    ..items = (json['items'] as List<dynamic>? ?? [])
        .map((e) => itemFromJson(e as Map<String, dynamic>))
        .toList()
    ..ownerId = json['ownerId'] as String? ?? ''
    ..sharedWith = (json['sharedWith'] as List<dynamic>? ?? [])
        .map((e) => e as String)
        .toList();
}
