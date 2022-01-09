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
        width:
            MediaQuery.of(context).size.width - (Constants.defaultPadding * 2),
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
        padding: const EdgeInsets.all(Constants.defaultPadding),
        child: SingleChildScrollView(
          child: ClipRRect(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
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

class AlertButtonsDialog extends AlertTextDialog {
  final List<AlertButton> buttons;

  const AlertButtonsDialog({
    required alert,
    required this.buttons,
    subtext = '',
    Key? key,
  }) : super(
          key: key,
          alert: alert,
          subtext: subtext,
          heightDevider: 3,
        );

  final buttonSize = 70.0;

  @override
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
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(
                Constants.defaultBorderRadiusSmall,
              )),
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
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
    }

    return GridView.extent(
      maxCrossAxisExtent: buttonSize,
      mainAxisSpacing: Constants.defaultPadding / 4,
      crossAxisSpacing: Constants.defaultPadding / 4,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: buttonsList,
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
    this.pickerColor = Constants.primaryColorLight,
    subtext = '',
    Key? key,
  }) : super(
          alert: alert,
          subtext: subtext,
          heightDevider: 2,
          key: key,
        );

  final List<Color> colors = const [
    Constants.primaryColorLight,
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
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

  Widget pickerLayoutBuilder(
    BuildContext context,
    List<Color> colors,
    PickerItem child,
  ) {
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
        physics: const NeverScrollableScrollPhysics(),
        children: [for (Color color in colors) child(color)],
      ),
    );
  }

  Widget pickerItemBuilder(
    Color color,
    bool isCurrentColor,
    void Function() changeColor,
  ) {
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

  @override
  Widget generate(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
            Radius.circular(Constants.defaultBorderRadiusSmall)),
        color: Theme.of(context).scaffoldBackgroundColor.withOpacity(.7),
      ),
      child: BlockPicker(
        pickerColor: pickerColor,
        onColorChanged: onColorChanged,
        availableColors: colors,
        layoutBuilder: pickerLayoutBuilder,
        itemBuilder: pickerItemBuilder,
      ),
    );
  }
}
