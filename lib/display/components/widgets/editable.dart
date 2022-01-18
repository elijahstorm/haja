import 'package:flutter/material.dart';

import 'package:haja/content/content.dart';
import 'package:haja/controllers/keys.dart';
import 'package:haja/language/language.dart';
import 'package:provider/provider.dart';

typedef EditableContentChangedSignal = List<void Function()>;

class EditableValueTracker<T> {
  T value;

  EditableValueTracker(this.value);
}

class CloseAndSaveEditor extends StatelessWidget {
  final ContentContainer content;
  final Widget child;
  final String title;

  const CloseAndSaveEditor({
    required this.content,
    required this.child,
    required this.title,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Provider<EditableContentChangedSignal>(
        create: (context) => [],
        builder: (context, _) => Scaffold(
          appBar: AppBar(
            leading: Consumer<EditableContentChangedSignal>(
                builder: (context, signals, child) {
              return IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  if (signals.isNotEmpty) {
                    for (var signal in signals) {
                      signal();
                    }
                    content.upload();
                  }
                  Navigator.of(context).pop();
                },
              );
            }),
            title: Text(title),
            actions: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          body: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: child,
          ),
        ),
      );
}

class EditableContentItem<T> extends StatefulWidget {
  final void Function(T) onSave;
  final T value;
  final String label, help;
  final EditableValueTracker<T?> changableValue = EditableValueTracker(null);

  EditableContentItem({
    required this.onSave,
    required this.value,
    required this.label,
    required this.help,
    Key? key,
  }) : super(key: key);

  Widget generateEditing(BuildContext context) => Container();
  Widget generateView(BuildContext context) => Container();

  void saver() {
    if (changableValue.value == null) return;

    onSave(changableValue.value!);
  }

  @override
  _EditableContentItemState createState() => _EditableContentItemState();
}

class _EditableContentItemState extends State<EditableContentItem> {
  bool isEditing = false;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(widget.label),
                  IconButton(
                    onPressed: () {
                      if (GlobalKeys.rootScaffoldMessengerKey.currentState ==
                          null) {
                        return;
                      }
                      GlobalKeys.rootScaffoldMessengerKey.currentState!
                          .showSnackBar(SnackBar(
                        content: Text(widget.help),
                      ));
                    },
                    icon: const Icon(
                      Icons.help,
                      size: 16,
                    ),
                  ),
                ],
              ),
              isEditing
                  ? Container()
                  : Consumer<EditableContentChangedSignal>(
                      builder: (context, signal, child) => IconButton(
                        onPressed: () {
                          signal.add(widget.saver);
                          setState(() => isEditing = true);
                        },
                        icon: child!,
                      ),
                      child: const Icon(Icons.edit),
                    ),
            ],
          ),
          isEditing
              ? widget.generateEditing(context)
              : widget.generateView(context),
        ],
      );
}

class CustomEditablePicture extends EditableContentItem<String> {
  CustomEditablePicture({
    required String value,
    required void Function(String) onSave,
    required String label,
    required String help,
    Key? key,
  }) : super(
          value: value,
          onSave: onSave,
          label: label,
          help: help,
          key: key,
        );

  @override
  Widget generateEditing(BuildContext context) => generateView(context);
  @override
  Widget generateView(BuildContext context) => SizedBox(
        height: 100,
        child: Image.network(
          value,
          fit: BoxFit.contain,
        ),
      );
}

class CustomEditableText extends EditableContentItem<String> {
  final int lineHeight;

  CustomEditableText({
    required String value,
    required void Function(String) onSave,
    required String label,
    required String help,
    this.lineHeight = 1,
    Key? key,
  }) : super(
          value: value,
          onSave: onSave,
          label: label,
          help: help,
          key: key,
        );

  @override
  Widget generateEditing(BuildContext context) => TextFormField(
        autofocus: true,
        onChanged: (value) => changableValue.value = value,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '$label cannot be empty';
          }
        },
        decoration: const InputDecoration(
          hintText: Language.teamEditorPlaceholder,
        ),
        maxLines: lineHeight,
      );

  @override
  Widget generateView(BuildContext context) => value.isEmpty
      ? Text(
          Language.teamEditorEmpty,
          maxLines: lineHeight,
          style: TextStyle(
            color: Colors.black.withOpacity(.5),
          ),
        )
      : Text(
          value,
          maxLines: lineHeight,
        );
}

class CustomSwitch extends EditableContentItem<bool> {
  final String switchText;

  CustomSwitch({
    required bool value,
    required void Function(bool) onSave,
    required String label,
    required String help,
    required this.switchText,
    Key? key,
  }) : super(
          value: value,
          onSave: onSave,
          label: label,
          help: help,
          key: key,
        );

  @override
  Widget generateEditing(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(switchText),
          StatefulBuilder(
            builder: (context, StateSetter setState) {
              return Switch(
                value: changableValue.value ?? false,
                onChanged: (value) =>
                    setState(() => changableValue.value = value),
              );
            },
          ),
        ],
      );

  @override
  Widget generateView(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(switchText),
          Opacity(
            opacity: .1,
            child: Switch(
              value: changableValue.value ?? false,
              onChanged: null,
            ),
          ),
        ],
      );
}
