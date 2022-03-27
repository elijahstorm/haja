import 'package:flutter/material.dart';
import 'package:haja/language/constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:haja/display/components/animations/loading.dart';
import 'package:haja/content/content.dart';
import 'package:haja/controllers/keys.dart';
import 'package:haja/language/language.dart';

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
              },
            ),
            title: Text(title),
            centerTitle: false,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            foregroundColor: Theme.of(context).textTheme.bodyLarge!.color,
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
            child: Padding(
              padding: const EdgeInsets.only(
                bottom: Constants.defaultPadding,
              ),
              child: ListView(
                children: [
                  const SizedBox(
                    height: Constants.defaultPadding,
                  ),
                  child,
                ],
              ),
            ),
          ),
        ),
      );
}

class SaveableStatefulWidget<T> extends StatefulWidget {
  final void Function(T) onSave;
  final EditableValueTracker<T?> changableValue = EditableValueTracker(null);

  SaveableStatefulWidget({
    required this.onSave,
    Key? key,
  }) : super(key: key);

  void saver() {
    if (changableValue.value == null) return;

    onSave(changableValue.value!);
  }

  void signalOnce(EditableContentChangedSignal signals) {
    if (signals.contains(saver)) return;

    signals.add(saver);
  }

  @override
  createState() => _EditableContentItemState();
}

class EditableContentItem<T> extends SaveableStatefulWidget<T> {
  final T value;
  final String label, help;
  final bool inline;

  EditableContentItem({
    required onSave,
    required this.value,
    required this.label,
    required this.help,
    this.inline = false,
    Key? key,
  }) : super(
          onSave: onSave,
          key: key,
        );

  Widget generateEditing(BuildContext context) => Container();
  Widget generateView(BuildContext context) => Container();
}

class _EditableContentItemState extends State<EditableContentItem> {
  bool isEditing = false;

  @override
  Widget build(BuildContext context) => widget.inline
      ? widget.generateEditing(context)
      : Column(
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
                        builder: (context, signals, child) => IconButton(
                          onPressed: () {
                            widget.signalOnce(signals);
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
          fit: BoxFit.cover,
        ),
      );
}

class CustomEditableWidget<T> extends SaveableStatefulWidget {
  final Widget child;
  final Widget Function(T?)? editor;
  final Widget Function(Widget)? container;
  final Future<T?> Function()? onTap;

  CustomEditableWidget({
    required onSave,
    required this.child,
    this.editor,
    this.container,
    this.onTap,
    Key? key,
  }) : super(
          onSave: onSave,
          key: key,
        );

  Widget renderEditor() =>
      editor == null ? child : editor!(changableValue.value);

  Widget generateView(BuildContext context) =>
      container == null ? child : container!(child);
  Widget generateEditing(BuildContext context) =>
      container == null ? renderEditor() : container!(renderEditor());

  @override
  _CustomEditableWidgetState createState() => _CustomEditableWidgetState();
}

class _CustomEditableWidgetState extends State<CustomEditableWidget> {
  bool isEditing = false;

  @override
  Widget build(BuildContext context) => Consumer<EditableContentChangedSignal>(
        builder: (context, signals, child) => GestureDetector(
          onTap: () async {
            widget.signalOnce(signals);
            if (widget.onTap != null) {
              widget.changableValue.value = await widget.onTap!();
            }
            if (widget.changableValue.value != null) {
              setState(() => isEditing = true);
            }
          },
          child: child,
        ),
        child: isEditing
            ? widget.generateEditing(context)
            : widget.generateView(context),
      );
}

class CustomEditableText extends EditableContentItem<String> {
  final int lineHeight, maxLength;

  CustomEditableText({
    required String value,
    required void Function(String) onSave,
    required String label,
    required String help,
    this.lineHeight = 1,
    this.maxLength = 20,
    Key? key,
  }) : super(
          value: value,
          onSave: onSave,
          label: label,
          help: help,
          inline: true,
          key: key,
        );

  @override
  Widget generateEditing(BuildContext context) =>
      Consumer<EditableContentChangedSignal>(
        builder: (context, signals, child) => TextFormField(
          onChanged: (value) {
            signalOnce(signals);
            changableValue.value = value;
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '$label cannot be empty';
            }
            return null;
          },
          buildCounter: (
            context, {
            required currentLength,
            required isFocused,
            maxLength,
          }) {
            return Container(
              transform:
                  Matrix4.translationValues(0, -kToolbarHeight / 1.35, 0),
              child: Opacity(
                opacity: .5,
                child: Text(
                  '$currentLength/$maxLength',
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
            );
          },
          decoration: InputDecoration(
            hintText: Language.teamEditorPlaceholder,
            fillColor: Theme.of(context).canvasColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                Constants.defaultBorderRadiusXLarge * 2,
              ),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: Constants.defaultPadding / 2,
              horizontal: Constants.defaultPadding,
            ),
            filled: true,
          ),
          maxLines: lineHeight,
          initialValue: value,
          maxLength: maxLength,
        ),
      );

  @override
  Widget generateView(BuildContext context) => value.isEmpty
      ? Text(
          Language.teamEditorEmpty,
          maxLines: lineHeight,
          style: TextStyle(
            color: Theme.of(context).iconTheme.color!.withOpacity(.5),
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
          inline: true,
          key: key,
        );

  @override
  Widget generateEditing(BuildContext context) => Row(
        children: [
          Text(switchText),
          IconButton(
            onPressed: () {
              if (GlobalKeys.rootScaffoldMessengerKey.currentState == null) {
                return;
              }
              GlobalKeys.rootScaffoldMessengerKey.currentState!
                  .showSnackBar(SnackBar(
                content: Text(help),
              ));
            },
            icon: const Icon(
              Icons.help,
              size: 16,
            ),
          ),
          const Expanded(child: SizedBox()),
          StatefulBuilder(
            builder: (context, StateSetter setState) {
              return Consumer<EditableContentChangedSignal>(
                builder: (context, signals, child) => Switch(
                  value: changableValue.value ?? false,
                  onChanged: (value) {
                    signalOnce(signals);
                    setState(() => changableValue.value = value);
                  },
                ),
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

class CustomEditable extends StatelessWidget {
  final String label;
  final Widget content;

  const CustomEditable({
    required this.label,
    required this.content,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          content,
        ],
      );
}

class StoredPreferenceSwitcher extends StatefulWidget {
  final String keyName;
  final bool defaultValue;

  const StoredPreferenceSwitcher({
    required this.keyName,
    this.defaultValue = true,
    Key? key,
  }) : super(key: key);

  @override
  _StoredPreferenceSwitcher createState() => _StoredPreferenceSwitcher();
}

class _StoredPreferenceSwitcher extends State<StoredPreferenceSwitcher> {
  @override
  Widget build(BuildContext context) => FutureBuilder<SharedPreferences>(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Loading();
          }

          final prefs = snapshot.data!;

          return Switch(
            value: prefs.getBool(widget.keyName) ?? widget.defaultValue,
            onChanged: (updatedValue) {
              setState(() => prefs.setBool(widget.keyName, updatedValue));
            },
          );
        },
      );
}
