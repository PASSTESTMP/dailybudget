// add bloc 
import 'package:dailybudget/bloc/limit_event.dart';
import 'package:dailybudget/bloc/list_bloc.dart';
import 'package:dailybudget/bloc/list_state.dart';
import 'package:dailybudget/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommonListPage extends StatefulWidget {
  const CommonListPage({super.key});

  @override
  State<CommonListPage> createState() => _CommonListPageState();
}

class _CommonListPageState extends State<CommonListPage> {
  List<Map<String, dynamic>> _items = [];
  AppLocalizations? loc;

  @override
  void initState() {
    super.initState();
    LoadDataEvent();
    // _loadItems();
  }
  // TODO: move to service
  // Future<void> _loadItems() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? itemsJson = prefs.getString('items');
  //   if (itemsJson != null) {
  //     setState(() {
  //       _items = List<Map<String, dynamic>>.from(json.decode(itemsJson));
  //     });
  //   }
  //   _refreshItems();
  // }

  // Future<void> _refreshItems() async {
  //   WidgetsBinding.instance.addPostFrameCallback((_) async {
  //     final settings = Provider.of<SettingsModel>(context, listen: false);

  //     bool useCloud = settings.useCloud;
  //     if (useCloud && !isPC()) {
  //       await settings.cloudProvider.fetchData('shoppingLists', settings.email).then((data) {
  //         setState(() {
  //           if (data.isNotEmpty) {
  //             if (data[0]["Error"]!= null) {
  //               _items = [];
  //               settings.infoMessage = "Potwierdź email zanim się zalogujesz";
  //             } else if (data[0]['items'] != null) {
  //               _items = List<Map<String, dynamic>>.from(data[0]['items']);
  //             } else {
  //               _items = [];
  //             }
  //           } else {
  //             _items = [];
  //           }
  //         });
  //       });
  //     }
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     await prefs.setString('items', json.encode(_items));
  //   });
  // }

  // Future<void> _saveItems() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.setString('items', json.encode(_items));

  //   WidgetsBinding.instance.addPostFrameCallback((_) async {
  //     final settings = Provider.of<SettingsModel>(context, listen: false);

  //     bool useCloud = settings.useCloud;
  //     if (useCloud && !isPC()) {
  //       await settings.cloudProvider.uploadData('shoppingLists', {
  //         'id': settings.email,
  //         'items': _items,
  //       });
  //     }
  //   });
  // }

  // void _addItem() {
  //   setState(() {
  //     _items.add({'text': 'NewItem', 'checked': false});
  //   });
  //   // _saveItems();
  //   _editItem(_items.length - 1);
  // }

  // void _clearAll() {
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: Text('Clear All Items'),
  //       content: Text('Are you sure you want to clear all items?'),
  //       actions: [
  //         TextButton(
  //           onPressed: () {
  //               setState(() {
  //               _items.removeWhere((item) => item['checked'] == true);
  //             });
  //             _saveItems();
  //             Navigator.of(context).pop();
  //           },
  //           child: Text('Clear all checked'),
  //         ),
  //         TextButton(
  //           onPressed: () {
  //             setState(() {
  //               _items.clear();
  //             });
  //             _saveItems();
  //             Navigator.of(context).pop();
  //           },
  //           child: Text('Clear'),
  //         ),
  //         TextButton(
  //           onPressed: () => Navigator.of(context).pop(),
  //           child: Text('Cancel'),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // void _editItem(int index) {
  //   TextEditingController controller =
  //       TextEditingController(text: _items[index]['text']);
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     controller.selection = TextSelection(
  //       baseOffset: 0,
  //       extentOffset: controller.text.length,
  //     );
  //   });
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: Text('Edit Item'),
  //       content: TextField(
  //         controller: controller,
  //         autofocus: true,
  //         decoration: InputDecoration(hintText: 'Enter new text'),
  //         onSubmitted: (value) {
  //           setState(() {
  //             _items[index]['text'] = value;
  //           });
  //           _saveItems();
  //           Navigator.of(context).pop();
  //         },
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () {
  //             setState(() {
  //               _items[index]['text'] = controller.text;
  //             });
  //             _saveItems();
  //             Navigator.of(context).pop();
  //           },
  //           child: Text('Save'),
  //         ),
  //         TextButton(
  //           onPressed: () {
  //             setState(() {
  //               _items.removeAt(index);
  //             });
  //             _saveItems();
  //             Navigator.of(context).pop();
  //           },
  //           child: Text('Delete'),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // void _toggleCheck(int index) {
  //   setState(() {
  //     _items[index]['checked'] = !_items[index]['checked'];
  //   });
  //   _saveItems();
  // }

  @override
  Widget build(BuildContext context) {
    // final settings = Provider.of<SettingsModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<ListBloc, ListState>(
          builder: (context, state) {
            loc = AppLocalizations.of(context);
            return Text(loc!.commonListTitle);
          },
        ),
        actions: [
          // TODO: correct button to settings
          // IconButton(
          //   icon: const Icon(Icons.settings),
          //   onPressed: () => _openSettings(context),
          // ),
        ],
      ),
      body: BlocBuilder<ListBloc, ListState>(
        builder: (context, state) {
          return Column(
        children: [
          // TODO: implement info message
          // if (settings.infoMessage != "" && settings.infoMessage.isNotEmpty)
          //   Padding(
          // padding: const EdgeInsets.all(8.0),
          // child: Text(
          //   settings.infoMessage,
          //   style: TextStyle(color: Colors.red),
          // ),
          //   ),
          // Expanded(
          //   child: ListView.builder(
          // itemCount: _items.length,
          // itemBuilder: (context, index) {
          //   final item = _items[index];
          //   return GestureDetector(
          //     onLongPress: () => _editItem(index),
          //     child: ListTile(
          //   leading: Checkbox(
          //     value: item['checked'],
          //     onChanged: (value) => _toggleCheck(index),
          //   ),
          //   title: Text(
          //     item['text'],
          //     style: TextStyle(
          //       decoration: item['checked']
          //       ? TextDecoration.lineThrough
          //       : TextDecoration.none,
          //     ),
          //   ),
          //     ),
          //   );
          // },
          //   ),
          // ),
        ],
          );
        },
      ),
      // TODO: implement add and clear all
      // floatingActionButton: GestureDetector(
      //   onLongPress: () {
      //     _clearAll();
      //   },
      //   child: FloatingActionButton(
      //     onPressed: _addItem,
      //     child: Icon(Icons.add),
      //   ),
      // ),
    );
  }
}