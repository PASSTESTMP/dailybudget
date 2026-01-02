class ListDataModel {
  String id = '';
  List<Item> items = [];
  String ownerId = '';
  List<String> sharedWith = [];
}

class Item {
  String text;
  String category;
  bool checked = false;

  Item(this.text, {this.category = ''});
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
    category: json['category'] as String? ?? '',
  )..checked = json['checked'] as bool? ?? false;
}

Map<String, dynamic> listDataModelToJson(ListDataModel model) {
  return {
    'id': model.id,
    'items': model.items.map(itemToJson).toList(),
    'ownerId': model.ownerId,
    'sharedWith': model.sharedWith,
  };
}

ListDataModel listDataModelFromJson(Map<String, dynamic> json) {
  return ListDataModel()
    ..id = json['id'] as String? ?? ''
    ..items = (json['items'] as List<dynamic>? ?? [])
        .map((itemJson) => itemFromJson(itemJson as Map<String, dynamic>))
        .toList()
    ..ownerId = json['ownerId'] as String? ?? ''
    ..sharedWith = (json['sharedWith'] as List<dynamic>? ?? [])
        .map((e) => e as String)
        .toList();
}
