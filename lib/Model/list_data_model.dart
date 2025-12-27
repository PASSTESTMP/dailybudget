class  ListDataModel {
  String infoMessage = "";

  // 

  String id;
  String name;
  List<String> items;
  String ownerId;
  List<String> sharedWith;

  ListDataModel({
    required this.id,
    required this.name,
    required this.items,
    required this.ownerId,
    required this.sharedWith,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'items': items,
    'ownerId': ownerId,
    'sharedWith': sharedWith,
  };

  factory ListDataModel.fromJson(Map<String, dynamic> json) => ListDataModel(
    id: json['id'],
    name: json['name'],
    items: List<String>.from(json['items']),
    ownerId: json['ownerId'],
    sharedWith: List<String>.from(json['sharedWith']),
  );
}