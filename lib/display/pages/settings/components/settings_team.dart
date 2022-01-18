import 'package:flutter/material.dart';

import 'package:haja/language/constants.dart';

class DashSettingsTeam extends StatelessWidget {
  const DashSettingsTeam({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Team Settings',
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ],
        ),
        const SizedBox(height: Constants.defaultPadding),
        Container(
          padding: const EdgeInsets.all(Constants.defaultPadding),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            children: const [
              // CheckBoxSettings(),
              // SwitchModeSettings(),
            ],
          ),
        ),
      ],
    );
  }
}

class Todo {
  String name;
  bool enable;
  Todo({this.enable = true, required this.name});
}

class CheckBoxSettings extends StatefulWidget {
  const CheckBoxSettings({
    Key? key,
  }) : super(key: key);

  @override
  _StateCheckBoxSettings createState() => _StateCheckBoxSettings();
}

class _StateCheckBoxSettings extends State<CheckBoxSettings> {
  final List<Todo> _todos = [
    Todo(name: 'Purchase Paper', enable: true),
    Todo(name: 'Refill the inventory of speakers', enable: true),
    Todo(name: 'Hire someone', enable: true),
    Todo(name: 'Maketing Strategy', enable: true),
    Todo(name: 'Selling furniture', enable: true),
    Todo(name: 'Finish the disclosure', enable: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        _todos.length,
        (index) => CheckboxListTile(
          title: Text(
            _todos[index].name,
          ),
          value: _todos[index].enable,
          onChanged: (newValue) {
            setState(() {
              _todos[index].enable = newValue ?? true;
            });
          },
        ),
      ),
    );
  }
}

class Product {
  String name;
  bool enable;
  Product({this.enable = true, required this.name});
}

class SwitchModeSettings extends StatefulWidget {
  const SwitchModeSettings({
    Key? key,
  }) : super(key: key);

  @override
  _StateSwitchModeSettings createState() => _StateSwitchModeSettings();
}

class _StateSwitchModeSettings extends State<SwitchModeSettings> {
  final List<Product> _products = [
    Product(name: 'LED Submersible Lights', enable: true),
    Product(name: 'Portable Projector', enable: true),
    Product(name: 'Bluetooth Speaker', enable: true),
    Product(name: 'Smart Watch', enable: true),
    Product(name: 'Temporary Tattoos', enable: true),
    Product(name: 'Bookends', enable: true),
    Product(name: 'Vegetable Chopper', enable: true),
    Product(name: 'Neck Massager', enable: true),
    Product(name: 'Facial Cleanser', enable: true),
    Product(name: 'Back Cushion', enable: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        _products.length,
        (index) => SwitchListTile.adaptive(
          title: Text(
            _products[index].name,
          ),
          value: _products[index].enable,
          onChanged: (newValue) {
            setState(() {
              _products[index].enable = newValue;
            });
          },
        ),
      ),
    );
  }
}
