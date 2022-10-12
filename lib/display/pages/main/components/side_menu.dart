import 'package:flutter/material.dart';

import 'package:haja/controllers/responsive.dart';
import 'package:haja/language/constants.dart';
import 'package:haja/display/pages/main/components/navbar_holder.dart';

class SideMenu extends StatelessWidget {
  final ValueNotifier stateIndex;
  final List<NavbarDataHolder> navbarStates;

  const SideMenu({
    required this.stateIndex,
    required this.navbarStates,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> drawerChildren = List<Widget>.generate(
      navbarStates.length,
      (index) => DrawerListTile(
        data: navbarStates[index],
        press: () => stateIndex.value = navbarStates[index].name,
      ),
    );

    return Drawer(
      child: ListView(
        children: <Widget>[
              DrawerHeader(
                child: Image.asset(Constants.logoAsset),
              ),
            ] +
            drawerChildren,
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    required this.data,
    required this.press,
  }) : super(key: key);

  final NavbarDataHolder data;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        if (!Responsive.isDesktop(context)) Navigator.pop(context);
        press();
      },
      horizontalTitleGap: 0.0,
      leading: Icon(
        data.icon,
        color: data.color(context),
      ),
      title: Opacity(
        opacity: 0.8,
        child: Text(
          data.title,
        ),
      ),
    );
  }
}
