import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import 'package:haja/constants.dart';

class AlertTextDialog extends StatelessWidget {
  const AlertTextDialog({
    required this.alert,
    this.subtext = '',
    this.heightDevider = 5,
    Key? key,
  }) : super(key: key);

  final String alert;
  final String subtext;
  final int heightDevider;

  final primaryColor = const Color(0xff4338CA);
  final secondaryColor = const Color(0xff6D28D9);
  final accentColor = const Color(0xffffffff);
  final backgroundColor = const Color(0xffffffff);
  final errorColor = const Color(0xffEF4444);

  Widget generate(BuildContext context) => const SizedBox(
        width: 0,
        height: 0,
      );

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        width: MediaQuery.of(context).size.width / 1.5,
        height: MediaQuery.of(context).size.height / heightDevider,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).colorScheme.secondary,
            ],
          ),
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              offset: const Offset(12, 26),
              blurRadius: 50,
              spreadRadius: 0,
              color: Colors.grey.withOpacity(.1),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: accentColor.withOpacity(.05),
              radius: 25,
              child: Image.asset(Constants.logoAsset),
            ),
            const SizedBox(height: 15),
            Text(
              alert,
              style: TextStyle(
                color: accentColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 3.5),
            Text(
              subtext,
              style: TextStyle(
                color: accentColor,
                fontSize: 12,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 15),
            generate(context),
          ],
        ),
      ),
    );
  }
}

enum AlertIcon {
  date,
  edit,
  color,
  delete,
}

extension AlertIconExtension on AlertIcon {
  String fileName() {
    switch (this) {
      case AlertIcon.date:
        return '${Constants.imageAssetPath}logo.png';
      case AlertIcon.edit:
        return '${Constants.imageAssetPath}logo.png';
      case AlertIcon.color:
        return '${Constants.imageAssetPath}logo.png';
      case AlertIcon.delete:
        return '${Constants.imageAssetPath}logo.png';
      default:
        return '${Constants.imageAssetPath}logo.png';
    }
  }

  IconData getIcon() {
    switch (this) {
      case AlertIcon.date:
        return Icons.calendar_today;
      case AlertIcon.edit:
        return Icons.edit;
      case AlertIcon.color:
        return Icons.palette;
      case AlertIcon.delete:
        return Icons.delete;
      default:
        return Icons.calendar_today;
    }
  }
}

class AlertButton {
  final String label;
  final VoidCallback action;
  final AlertIcon icon;
  final bool stopPop;

  AlertButton({
    required this.label,
    required this.action,
    this.stopPop = false,
    this.icon = AlertIcon.date,
  });

  String get asset {
    return icon.fileName();
  }

  IconData get icondata {
    return icon.getIcon();
  }
}

class AlertButtonsDialog extends StatelessWidget {
  final String alert;
  final String subtext;
  final List<AlertButton> buttons;

  const AlertButtonsDialog({
    required this.alert,
    required this.buttons,
    this.subtext = '',
    Key? key,
  }) : super(key: key);

  final primaryColor = const Color(0xff4338CA);
  final secondaryColor = const Color(0xff6D28D9);
  final accentColor = const Color(0xffffffff);
  final backgroundColor = const Color(0xffffffff);
  final errorColor = const Color(0xffEF4444);
  final buttonSize = 60.0;

  Widget generate(BuildContext context) {
    var buttonsList = <Widget>[];

    for (int i = 0; i < buttons.length; i++) {
      buttonsList.add(
        GestureDetector(
          onTap: () {
            buttons[i].action();
            if (buttons[i].stopPop) return;
            Navigator.of(context).pop();
          },
          child: Container(
            height: buttonSize,
            width: buttonSize,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: Constants.defaultPadding / 4),
                SizedBox(
                  height: buttonSize / 2,
                  child: Icon(
                    buttons[i].icondata,
                  ),
                ),
                const SizedBox(height: Constants.defaultPadding / 4),
                Text(
                  buttons[i].label,
                  maxLines: 1,
                  style: const TextStyle(
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: Constants.defaultPadding / 4),
              ],
            ),
          ),
        ),
      );

      if (i < buttons.length - 1) {
        buttonsList.add(const SizedBox(width: Constants.defaultPadding / 2));
      }
    }

    return GridView.extent(
      // crossAxisCount: 2, // TODO: bad grid layout flow -> idk why
      maxCrossAxisExtent: buttonSize,
      mainAxisSpacing: 0,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: buttonsList,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        padding: const EdgeInsets.all(Constants.defaultPadding),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).colorScheme.secondary,
            ],
          ),
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              offset: const Offset(12, 26),
              blurRadius: 50,
              spreadRadius: 0,
              color: Colors.grey.withOpacity(.1),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: accentColor.withOpacity(.05),
              radius: buttonSize / 2,
              child: Image.asset(Constants.logoAsset),
            ),
            const SizedBox(height: Constants.defaultPadding / 2),
            Text(
              alert,
              style: TextStyle(
                color: accentColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: Constants.defaultPadding / 4),
            Text(
              subtext,
              style: TextStyle(
                color: accentColor,
                fontSize: 12,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: Constants.defaultPadding),
            generate(context),
          ],
        ),
      ),
    );
  }
}

class AlertColorDialog extends AlertTextDialog {
  final void Function(Color) onColorChanged;
  final Color pickerColor;

  final int _portraitCrossAxisCount = 4;
  final int _landscapeCrossAxisCount = 5;
  final double _borderRadius = 30;
  final double _iconSize = 12;

  const AlertColorDialog({
    required alert,
    required this.onColorChanged,
    this.pickerColor = Colors.grey,
    subtext = '',
    Key? key,
  }) : super(
          alert: alert,
          subtext: subtext,
          heightDevider: 1,
          key: key,
        );

  final List<Color> colors = const [
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
    Colors.brown,
    Colors.grey,
    Colors.blueGrey,
    Colors.black,
  ];

  Widget generateMaterial() {
    return SingleChildScrollView(
      child: MaterialPicker(
        pickerColor: pickerColor,
        onColorChanged: onColorChanged,
        enableLabel: false,
        portraitOnly: false,
      ),
    );
  }

  Widget pickerLayoutBuilder(
      BuildContext context, List<Color> colors, PickerItem child) {
    Orientation orientation = MediaQuery.of(context).orientation;

    return SizedBox(
      width: 300,
      height: orientation == Orientation.portrait ? 360 : 240,
      child: GridView.count(
        crossAxisCount: orientation == Orientation.portrait
            ? _portraitCrossAxisCount
            : _landscapeCrossAxisCount,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        children: [for (Color color in colors) child(color)],
      ),
    );
  }

  Widget pickerItemBuilder(
      Color color, bool isCurrentColor, void Function() changeColor) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_borderRadius),
        color: color,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: changeColor,
          borderRadius: BorderRadius.circular(_borderRadius),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 250),
            opacity: isCurrentColor ? 1 : 0,
            child: Icon(
              Icons.done,
              size: _iconSize,
              color: useWhiteForeground(color) ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget generateBlocky() {
    return SingleChildScrollView(
      child: BlockPicker(
        pickerColor: pickerColor,
        onColorChanged: onColorChanged,
        availableColors: colors,
        layoutBuilder: pickerLayoutBuilder,
        itemBuilder: pickerItemBuilder,
      ),
    );
  }

  final bool isBlocky = true;

  @override
  Widget generate(BuildContext context) {
    return isBlocky ? generateBlocky() : generateMaterial();
  }
}
