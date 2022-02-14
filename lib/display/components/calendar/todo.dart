import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import 'package:haja/language/constants.dart';
import 'package:haja/language/language.dart';
import 'package:haja/content/todo/cache.dart';
import 'package:haja/content/todo/content.dart';
import 'package:haja/display/components/calendar/focused_date.dart';
import 'package:haja/display/components/widgets/alerts.dart';
import 'package:haja/display/components/widgets/skeleton.dart';

class Todo extends StatelessWidget {
  const Todo({
    Key? key,
  }) : super(key: key);

  void _createNew(
    TodoCache cache, {
    required DateTime date,
    String status = TodoContent.unfinishedStatus,
    String type = '',
    String color = '',
    String title = '',
    String caption = '',
    bool upload = false,
    bool editing = false,
  }) {
    var todo = TodoContent(
      date: date,
      status: status,
      type: type,
      color: color,
      title: title,
      caption: caption,
      editing: editing,
      id: Constants.createUniqueId(),
    );

    cache.add(todo);

    if (upload) {
      todo.upload();
    }
  }

  void _openNewInput(TodoCache cache, DateTime time) {
    if (_isEditing(cache)) return;

    _createNew(
      cache,
      editing: true,
      date: time,
    );
  }

  bool _isEditing(TodoCache cache) {
    return cache.items.indexWhere((todo) => todo.editing) != -1;
  }

  void _closeAndSave({
    required String title,
    required DateTime time,
    required TodoCache cache,
    required TodoContent todo,
  }) {
    if (!todo.editing) return;

    todo.editing = false;

    if (!todo.synchedWithDatabase) {
      cache.remove(todo);

      if (title == '') {
        return;
      }

      _createNew(
        cache,
        title: title,
        date: time,
        caption: todo.caption,
        color: todo.color,
        type: todo.type,
        upload: true,
      );
    } else {
      if (title == '') {
        return;
      }

      Map<String, dynamic> json = todo.toJson();
      json['title'] = title;
      json['id'] = todo.id;

      var updatedContent = TodoContent.fromJson(json);

      cache.remove(todo);
      cache.add(updatedContent);
      updatedContent.synchedWithDatabase = true;
      updatedContent.upload();
    }
  }

  void _toggleFinished(TodoCache cache, TodoContent todo) {
    todo.toggleFinished();
    todo.upload();
    cache.notify();
  }

  void _editTodo(TodoCache cache, TodoContent todo) {
    todo.editing = true;
    cache.notify();
  }

  void _share(TodoContent todo) {
    Share.share('check out my website ${todo.shareLink}');
  }

  void _changeDate(BuildContext context, TodoCache cache, TodoContent todo) {
    showDatePicker(
      context: context,
      initialDate: todo.date,
      firstDate: DateTime(2017, 1),
      lastDate: DateTime(2023, 7),
      helpText: Language.alertDateChangePrompt,
    ).then((DateTime? newDate) {
      if (newDate != null) {
        todo.date = newDate;
        todo.upload();
        cache.notify();
      }
    });
  }

  void _deleteTodo(TodoCache cache, TodoContent todo) {
    todo.delete();
    cache.remove(todo);
  }

  void _openMenuOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => const AlertTextDialog(
        alert: 'main',
        subtext: 'sub',
      ),
    );
  }

  Widget _buildEditingTodo(
    BuildContext context, {
    required TodoCache cache,
    required TodoContent todo,
    required DateTime time,
  }) =>
      TodoListCasing(
        mainChild: EditableFocusLosingField(
          value: todo.title,
          onSubmit: (input) {
            _closeAndSave(
              title: input,
              time: time,
              cache: cache,
              todo: todo,
            );

            _openNewInput(cache, time);
          },
          onExit: (value) {
            _closeAndSave(
              title: value,
              time: time,
              cache: cache,
              todo: todo,
            );
          },
        ),
      );

  Widget _buildNonEditingTodo(
    BuildContext context, {
    required TodoCache cache,
    required TodoContent todo,
  }) =>
      TodoListCasing(
        mainChild: Text(
          todo.title,
        ),
        leadingIcon: Icon(
          todo.status == TodoContent.finishedStatus
              ? Icons.check_circle
              : Icons.circle_outlined,
          color:
              Constants.fromHex(todo.color) ?? Theme.of(context).primaryColor,
        ),
        trailingIcon: GestureDetector(
          onTap: () {
            // TODO like
          },
          child: const Icon(
            Icons.favorite,
            color: Colors.red, // TODO liked
            size: Constants.textSizeRegular,
          ),
        ),
        options: [
          Option(
            icon: Icons.edit,
            open: () => _editTodo(cache, todo),
          ),
          Option(
            icon: Icons.calendar_today,
            open: () => _changeDate(context, cache, todo),
          ),
          Option(
            icon: Icons.delete,
            open: () => _deleteTodo(cache, todo),
          ),
          Option(
            icon: Icons.share,
            open: () => _share(todo),
          ),
        ],
        onColorChanged: (color) {
          todo.color = Constants.toHex(color);
          todo.upload();
          cache.notify();
        },
        onLeadingIconTap: () => _toggleFinished(cache, todo),
      );

  Widget _buildMoreOptionsButton(BuildContext context) => GestureDetector(
        onTap: () => _openMenuOptions(context),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(30),
          ),
          child: const Icon(
            Icons.more_horiz,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Consumer<FocusedDate>(
      builder: (context, focusedDate, child) {
        return Consumer<TodoCache>(
          builder: (context, cache, child) {
            var filter = cache.filterByDates(
              focusedDate.start,
              focusedDate.end,
            );

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextButton.icon(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                  ),
                  onPressed: () {
                    _openNewInput(cache, focusedDate.time);
                  },
                  icon: const Icon(Icons.add),
                  label: const Text(Language.addButton),
                ),
                if (cache.items.isEmpty) const SkeletonLoader(),
                Column(
                  children: List.generate(
                    filter.length,
                    (index) => filter[index].editing
                        ? _buildEditingTodo(
                            context,
                            cache: cache,
                            todo: filter[index],
                            time: focusedDate.time,
                          )
                        : _buildNonEditingTodo(
                            context,
                            cache: cache,
                            todo: filter[index],
                          ),
                  ),
                ),
                const SizedBox(height: Constants.defaultPadding),
                const Divider(
                  height: 2,
                  thickness: 1,
                  indent: Constants.defaultPadding * 3,
                  endIndent: Constants.defaultPadding * 3,
                ),
                const SizedBox(height: Constants.defaultPadding),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Container(),
                    ),
                    _buildMoreOptionsButton(context),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class Option {
  final IconData icon;
  final VoidCallback open;

  const Option({
    required this.icon,
    required this.open,
  });
}

class TodoListCasing extends StatefulWidget {
  final Widget mainChild, leadingIcon, trailingIcon;
  final VoidCallback? onLeadingIconTap;
  final void Function(Color)? onColorChanged;
  final List<Option> options;

  const TodoListCasing({
    required this.mainChild,
    this.onColorChanged,
    this.options = const [],
    this.leadingIcon = const Icon(Icons.circle),
    this.trailingIcon = const SizedBox(
      width: 0,
      height: 0,
    ),
    this.onLeadingIconTap,
    Key? key,
  }) : super(key: key);

  @override
  _TodoListCasingState createState() => _TodoListCasingState();
}

class _TodoListCasingState extends State<TodoListCasing> {
  bool showOptions = false;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(
          vertical: Constants.defaultPadding / 4,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: widget.onLeadingIconTap,
              child: Container(
                child: widget.leadingIcon,
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: Constants.defaultPadding / 3,
                ),
                width: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      child: widget.mainChild,
                      onTap: () => setState(() => showOptions = !showOptions),
                    ),
                    const SizedBox(
                      height: Constants.defaultPadding / 2,
                    ),
                    if (showOptions)
                      Row(
                        children: List.generate(
                          widget.options.length,
                          (index) => GestureDetector(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                right: Constants.defaultPadding / 4 + 2.5,
                                left: 3,
                              ),
                              child: Icon(
                                widget.options[index].icon,
                                size: 18,
                              ),
                            ),
                            onTap: widget.options[index].open,
                          ),
                        ),
                      ),
                    if (showOptions)
                      const SizedBox(
                        height: Constants.defaultPadding / 2,
                      ),
                    if (showOptions && widget.onColorChanged != null)
                      Row(
                        children: List.generate(
                          Constants.todoColorOptions.length,
                          (index) => GestureDetector(
                            onTap: () {
                              widget.onColorChanged!(
                                Constants.todoColorOptions[index],
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                right: Constants.defaultPadding / 4,
                              ),
                              child: Icon(
                                Icons.circle,
                                color: Constants.todoColorOptions[index],
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            widget.trailingIcon,
          ],
        ),
      );
}

class EditableFocusLosingField extends StatefulWidget {
  final String value;
  final void Function(String) onSubmit;
  final void Function(String) onExit;

  const EditableFocusLosingField({
    required this.value,
    required this.onSubmit,
    required this.onExit,
    Key? key,
  }) : super(key: key);

  @override
  _EditableFocusLosingField createState() => _EditableFocusLosingField();
}

class _EditableFocusLosingField extends State<EditableFocusLosingField> {
  TextEditingController inputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    inputController.text = widget.value;
  }

  @override
  void dispose() {
    inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Focus(
        child: TextFormField(
          autofocus: true,
          inputFormatters: [
            LengthLimitingTextInputFormatter(500),
          ],
          controller: inputController,
          onFieldSubmitted: widget.onSubmit,
          decoration: const InputDecoration(
            border: UnderlineInputBorder(),
            hintText: Language.createNewTodoHint,
          ),
          style: const TextStyle(
            fontSize: 14.0,
            height: 1,
          ),
        ),
        onFocusChange: (hasFocus) {
          if (hasFocus) return;

          widget.onExit(inputController.text);
        },
      );
}
