import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import 'package:haja/display/pages/main/components/navbar_holder.dart';

class HajaSalomonNavbar extends StatefulWidget {
  final ValueNotifier stateIndex;
  final List<NavbarDataHolder> navbarStates;

  const HajaSalomonNavbar({
    required this.navbarStates,
    required this.stateIndex,
    Key? key,
  }) : super(key: key);

  @override
  _HajaSalomonNavbarState createState() => _HajaSalomonNavbarState();
}

class _HajaSalomonNavbarState extends State<HajaSalomonNavbar> {
  void _updateState(int index) {
    setState(() => widget.stateIndex.value = widget.navbarStates[index].name);
  }

  int get _currentIndex {
    int index = 0;

    for (int i = 0; i < widget.navbarStates.length; i++) {
      if (widget.navbarStates[i].name == widget.stateIndex.value) {
        index = i;
        break;
      }
    }

    return index;
  }

  @override
  Widget build(BuildContext context) {
    var _items = <SalomonBottomBarItem>[];

    for (int i = 0; i < widget.navbarStates.length; i++) {
      var nav = widget.navbarStates[i];

      _items.add(
        SalomonBottomBarItem(
          icon: Icon(nav.icon),
          title: Text(nav.title),
          selectedColor: nav.color(context),
        ),
      );
    }

    return SalomonBottomBar(
      currentIndex: _currentIndex,
      onTap: _updateState,
      items: _items,
    );
  }
}
