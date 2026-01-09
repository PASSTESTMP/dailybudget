// add bloc 
import 'package:dailybudget/Model/list_data_model.dart';
import 'package:dailybudget/Model/settings_data_model.dart';
import 'package:dailybudget/bloc/list_bloc.dart';
import 'package:dailybudget/bloc/list_event.dart';
import 'package:dailybudget/bloc/list_state.dart';
import 'package:dailybudget/l10n/app_localizations.dart';
import 'package:dailybudget/main.dart';
import 'package:dailybudget/pages/list_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommonListPage extends StatefulWidget {
  const CommonListPage({super.key});

  @override
  State<CommonListPage> createState() => _CommonListPageState();
}

class _CommonListPageState extends State<CommonListPage> {
  // List<Item> _items = [];
  Map<String, List<Item>> _categories = {};
  AppLocalizations? loc;

  void _openSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ListSettingsPage()),
    );
  }

  @override
  void initState() {
    super.initState();
    context.read<ListBloc>().add(LoadListDataEvent());
    _categories = context.read<ListBloc>().state.data.catItems;
  }



  // Future<void> _saveItems() async {

  //   context.read<ListBloc>().add(SaveItemEvent(_items.last));

  //   // SharedPreferences prefs = await SharedPreferences.getInstance();
  //   // await prefs.setString('items', json.encode(_items));

  //   // WidgetsBinding.instance.addPostFrameCallback((_) async {
  //   //   final settings = Provider.of<SettingsModel>(context, listen: false);

  //   //   bool useCloud = settings.useCloud;
  //   //   if (useCloud && !isPC()) {
  //   //     await settings.cloudProvider.uploadData('shoppingLists', {
  //   //       'id': settings.email,
  //   //       'items': _items,
  //   //     });
  //   //   }
  //   // });
  // }

  void _addItem() {
    _editItem("default", context.read<ListBloc>().state.data.items.length);
  }

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
  //               _items.removeWhere((item) => item.checked == true);
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

  void _editItem(String category, int index) {
    if(_categories.keys.contains(category) == false){
      _categories[category] = [Item('NewItem')];
    }else{
      _categories[category]!.add(Item('NewItem'));
    }


    TextEditingController controller =
        TextEditingController(text: _categories[category]![index].text);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.selection = TextSelection(
        baseOffset: 0,
        extentOffset: controller.text.length,
      );
    });
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Item'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(hintText: 'Enter new text'),
          onSubmitted: (value) {
            context.read<ListBloc>().add(AddItemEvent(Item(value)));
            Navigator.of(context).pop();
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              context.read<ListBloc>().add(AddItemEvent(Item(controller.text)));
              Navigator.of(context).pop();
            },
            child: Text('Save'),
          ),
          TextButton(
            onPressed: () {
              _categories[category]!.removeAt(index);
              Navigator.of(context).pop();
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _toggleCheck(String category, int index) {
    context.read<ListBloc>().add(ToggleItemCheckEvent(category, index));
  }

  @override
  Widget build(BuildContext context) {
    final settings = SettingsDataModel();
    settings.loadSettings();

    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<ListBloc, ListState>(
          builder: (context, state) {
            loc = AppLocalizations.of(context);
            return Text(loc!.commonListTitle);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _openSettings(context),
          ),
        ],
      ),
      body: BlocBuilder<ListBloc, ListState>(
        builder: (context, state) {
          _categories = state.data.catItems;
          return Column(
            children: [
              if (settings.infoMessage != "" && settings.infoMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    settings.infoMessage,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              Expanded(
                child: ListView.builder(
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final entry = _categories.entries.toList()[index];
                    final category = entry.key;
                    final items = entry.value;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if(category != 'default')
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              category,
                              style: const TextStyle(
                                fontSize: 18,
                                // fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ...items.map(
                          (item) => GestureDetector(
                            onLongPress: () => _editItem(category, items.indexOf(item)),
                            child: ListTile(
                              leading: Checkbox(
                                value: item.checked,
                                onChanged: (value) => _toggleCheck(category, items.indexOf(item)),
                              ),
                              title: Text(
                                item.text,
                                style: TextStyle(
                                  decoration: item.checked
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ]
                    );
                  },
                ),
              ),
                  //   return GestureDetector(
                  //     onLongPress: () => _editItem(index),
                  //     child: ListTile(
                  //       leading: Checkbox(
                  //         value: item.checked,
                  //         onChanged: (value) => _toggleCheck(index),
                  //         ),
                  //       title: Text(
                  //         item.text,
                  //         style: TextStyle(
                  //           decoration: item.checked
                  //           ? TextDecoration.lineThrough
                  //           : TextDecoration.none,
                  //         ),
                  //       ),
                  //     ),
                  //   );
                  // },
              //   ),
              // ),
            ],
          );
        },
      ),
      floatingActionButton: GestureDetector(
        onLongPress: () {
          // _clearAll();
        },
        child: FloatingActionButton(
          onPressed: _addItem,
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}