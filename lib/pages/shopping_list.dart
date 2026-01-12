// add bloc 
import 'package:dailybudget/Model/list_data_model.dart';
import 'package:dailybudget/Model/settings_data_model.dart';
import 'package:dailybudget/bloc/list_bloc.dart';
import 'package:dailybudget/bloc/list_event.dart';
import 'package:dailybudget/bloc/list_state.dart';
import 'package:dailybudget/l10n/app_localizations.dart';
import 'package:dailybudget/pages/list_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommonListPage extends StatefulWidget {
  const CommonListPage({super.key});

  @override
  State<CommonListPage> createState() => _CommonListPageState();
}

class _CommonListPageState extends State<CommonListPage> {
  Map<String, List<Item>> _categories = {};
  late AppLocalizations loc;
  late SettingsDataModel settings;

  void _openSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ListSettingsPage()),
    );
  }

  @override
  void initState() {
    super.initState();
    settings = SettingsDataModel();
    settings.loadSettings();
    context.read<ListBloc>().add(LoadListDataEvent());
  }

  void _addItem() {
    _editItem("default", context.read<ListBloc>().state.data.items.length);
  }

  void _clearAll() {
    loc = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(loc.clearAllLabel),
        content: Text(loc.allItemsLabel),
        actions: [
          TextButton(
            onPressed: () {
              context.read<ListBloc>().add(RemoveCheckedItemEvent());
              Navigator.of(context).pop();
            },
            child: Text(loc.clearChackedLabel),
          ),
          TextButton(
            onPressed: () {
              context.read<ListBloc>().add(RemoveAllItemEvent());
              Navigator.of(context).pop();
            },
            child: Text(loc.clearLabel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(loc.cancelLabel),
          ),
        ],
      ),
    );
  }

  void _editItem(String category, int index) {
    TextEditingController controller = TextEditingController();
    String categoryOld = category;
    int indexOld = index;
    bool isEdit = false;
    loc = AppLocalizations.of(context)!;
    
    if (_categories[category] != null && index < _categories[category]!.length) {
      controller.text = _categories[category]![index].text;
      isEdit = true;
    }


    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.selection = TextSelection(
        baseOffset: 0,
        extentOffset: controller.text.length,
      );
    });
    
    showDialog(
      context: context,
      builder: (context) => BlocListener<ListBloc, ListState>(
        listener: (context, state) {
          if (state is ListUpdatedState) {
            Navigator.of(context).pop();
          }
        },
        child: AlertDialog(
          title: Text(loc.editLabel),
          content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: controller,
            autofocus: true,
            decoration: InputDecoration(hintText: loc.enterNewLabel),
            onSubmitted: (value) {
              if (isEdit){
                context.read<ListBloc>().add(EditItemEvent(categoryOld, Item(value, category: category), indexOld));
              }else{
                context.read<ListBloc>().add(AddItemEvent(Item(value, category: category)));
              }
            },
          ),
          Autocomplete<String>(
            optionsBuilder: (TextEditingValue textEditingValue) {
          return _categories.keys
            .where((cat) => cat.toLowerCase().contains(textEditingValue.text.toLowerCase()))
            .toList();
            },
            onSelected: (String selection) {
          category = selection;
            },
            fieldViewBuilder: (context, catController, focusNode, onFieldSubmitted) {
          catController.text = category;
          return TextField(
            controller: catController,
            focusNode: focusNode,
            decoration: InputDecoration(hintText: loc.enterNewLabel),
            onSubmitted: (value) {
              category = value;
            },
          );
            },
          ),
        ],
          ),
          actions: [
        TextButton(
          onPressed: () {
            if (isEdit){
              context.read<ListBloc>().add(EditItemEvent(categoryOld, Item(controller.text, category: category), indexOld));
            }else{
              context.read<ListBloc>().add(AddItemEvent(Item(controller.text, category: category)));
            }
          },
          child: Text(loc.saveLabel),
        ),
        TextButton(
          onPressed: () {
            context.read<ListBloc>().add(DeleteItemEvent(category, index));
          },
          child: Text(loc.deleteLabel),
        ),
          ],
        ),
      ),
    );
  }

  void _toggleCheck(String category, int index) {
    context.read<ListBloc>().add(ToggleItemCheckEvent(category, index));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<ListBloc, ListState>(
          builder: (context, state) {
            loc = AppLocalizations.of(context)!;
            return Text(loc.commonListTitle);
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
              if (settings.infoMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    settings.infoMessage,
                    style: const TextStyle(color: Colors.red),
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
                        
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            children: [
                              if (category != 'default')
                                Text(
                                  category,
                                  style: const TextStyle(fontSize: 18),
                                ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Container(
                                height: 1,
                                color: Colors.grey,
                                ),
                              ),
                            ],
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
                      ],
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: GestureDetector(
        onLongPress: _clearAll,
        child: FloatingActionButton(
          onPressed: _addItem,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}