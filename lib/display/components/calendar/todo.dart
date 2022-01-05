import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:haja/constants.dart';
import 'package:haja/content/todo/cache.dart';
import 'package:haja/content/todo/content.dart';
import 'package:haja/display/components/calendar/focused_date.dart';
import 'package:haja/display/components/widgets/alerts.dart';
import 'package:haja/display/components/widgets/skeleton.dart';

class Todo extends StatelessWidget {
  final TextEditingController _inputController = TextEditingController();

  Todo({
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

    _inputController.text = '';

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

    // TODO: Problem: Saving data is inconsistant
    if (!todo.synchedWithDatabase) {
      // TODO: potentitally incorrect upload flow
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
    _inputController.text = todo.title;
    cache.notify();
  }

  void _changeTodoColor(
      BuildContext context, TodoCache cache, TodoContent todo) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertColorDialog(
        alert: todo.title,
        subtext: 'Choose a new COLOR',
        onColorChanged: (color) {
          todo.color = Constants.toHex(color);
          todo.upload();
          cache.notify();
          Navigator.of(context).pop();
        },
      ),
    ).then((_) => Navigator.of(context).pop());
  }

  void _changeDate(BuildContext context, TodoCache cache, TodoContent todo) {
    showDatePicker(
      context: context,
      initialDate: todo.date,
      firstDate: DateTime(2017, 1),
      lastDate: DateTime(2023, 7),
      helpText: 'Change the task date',
    ).then((DateTime? newDate) {
      if (newDate != null) {
        todo.date = newDate;
        todo.upload();
        cache.notify();
      }

      Navigator.of(context).pop();
    });
  }

  void _deleteTodo(TodoCache cache, TodoContent todo) {
    todo.delete();
    cache.remove(todo);
  }

  void _openOptions(BuildContext context, TodoCache cache, TodoContent todo) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertButtonsDialog(
        alert: todo.title,
        subtext: '${todo.status}: ${DateFormat('MM / dd').format(todo.date)}',
        buttons: [
          AlertButton(
            label: 'Edit',
            action: () => _editTodo(cache, todo),
            icon: AlertIcon.edit,
          ),
          AlertButton(
            label: 'Colors',
            action: () => _changeTodoColor(context, cache, todo),
            stopPop: true,
            icon: AlertIcon.color,
          ),
          AlertButton(
            label: 'Date',
            action: () => _changeDate(context, cache, todo),
            stopPop: true,
          ),
          AlertButton(
            label: 'Delete',
            action: () => _deleteTodo(cache, todo),
            icon: AlertIcon.delete,
          ),
        ],
      ),
    );
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
        mainChild: Focus(
          child: TextFormField(
            autofocus: true,
            inputFormatters: [
              LengthLimitingTextInputFormatter(500),
            ],
            controller: _inputController,
            onFieldSubmitted: (input) {
              _closeAndSave(
                title: input,
                time: time,
                cache: cache,
                todo: todo,
              );
              _openNewInput(cache, time);
            },
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              hintText: 'start a new Todo',
            ),
            style: const TextStyle(
              fontSize: 14.0,
              height: 1,
            ),
          ),
          onFocusChange: (hasFocus) {
            print('chainging focus to $hasFocus');
            if (hasFocus) return;

            _closeAndSave(
              title: _inputController.text,
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
        mainChild: GestureDetector(
          onTap: () => _openOptions(context, cache, todo),
          child: Text(
            todo.title,
          ),
        ),
        leadingIcon: Icon(
          todo.status == TodoContent.finishedStatus
              ? Icons.check_circle_outlined
              : Icons.circle,
          color:
              Constants.fromHex(todo.color) ?? Theme.of(context).primaryColor,
        ),
        onLeadingIconTap: () => _toggleFinished(cache, todo),
        onTrailingIconTap: () => _openOptions(context, cache, todo),
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
                    padding: const EdgeInsets.symmetric(
                      vertical: Constants.defaultPadding / 2,
                    ),
                  ),
                  onPressed: () {
                    _openNewInput(cache, focusedDate.time);
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add'),
                ),
                if (cache.items.isEmpty) const SkeletonLoader(),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  reverse: true,
                  itemCount: filter.length,
                  itemBuilder: (context, index) => filter[index].editing
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

class TodoListCasing extends StatelessWidget {
  final Widget mainChild, leadingIcon;
  final VoidCallback? onLeadingIconTap, onTrailingIconTap;

  const TodoListCasing({
    required this.mainChild,
    this.leadingIcon = const Icon(Icons.circle),
    this.onLeadingIconTap,
    this.onTrailingIconTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(
          vertical: Constants.defaultPadding / 2,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: onLeadingIconTap,
              child: Container(
                child: leadingIcon,
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Constants.defaultPadding / 3,
                    ),
                    width: MediaQuery.of(context).size.width -
                        Constants.defaultPadding * 7,
                    child: mainChild,
                  ),
                  GestureDetector(
                    onTap: onTrailingIconTap,
                    child: const Icon(
                      Icons.more_horiz,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
