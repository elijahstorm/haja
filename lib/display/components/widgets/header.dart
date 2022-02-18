import 'package:flutter/foundation.dart';
import 'package:haja/controllers/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:haja/language/language.dart';
import 'package:provider/provider.dart';

import 'package:haja/display/pages/search/page.dart';
import 'package:haja/display/pages/debug/page.dart';
import 'package:haja/login/user_state.dart';
import 'package:haja/language/constants.dart';

class Header extends StatefulWidget {
  final String title;

  const Header(
    this.title, {
    Key? key,
  }) : super(key: key);

  @override
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends State<Header> with TickerProviderStateMixin {
  bool _showMenuOptions = false;
  void _toggleMenuOptions() {
    setState(() => _showMenuOptions = !_showMenuOptions);
  }

  Widget _drawHeaderDropdownButton({
    required String label,
    required IconData icon,
    required VoidCallback? onTap,
  }) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: Constants.defaultPadding * 1.5,
            vertical: Constants.defaultPadding /
                (Responsive.isMobile(context) ? 2 : 1),
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(label),
              const SizedBox(width: Constants.defaultPadding),
              Icon(icon),
            ],
          ),
        ),
      );

  Widget _drawMenuOptions() => AnimatedOpacity(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        opacity: _showMenuOptions ? 1 : 0,
        child: AnimatedSize(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          child: Container(
            padding: const EdgeInsets.only(top: Constants.defaultPadding),
            constraints: _showMenuOptions
                ? const BoxConstraints(maxHeight: double.infinity)
                : const BoxConstraints(maxHeight: 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IntrinsicWidth(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (!kReleaseMode)
                        _drawHeaderDropdownButton(
                          label: Language.debugTestingOption,
                          icon: Icons.bug_report,
                          onTap: () => Navigator.pushNamed(
                            context,
                            DebugTestingPage.routeName,
                          ),
                        ),
                      const SizedBox(height: Constants.defaultPadding),
                      Consumer<UserState>(
                        builder: (context, userstate, child) {
                          return GestureDetector(
                            child: child,
                            onTap: () => userstate.logout(),
                          );
                        },
                        child: _drawHeaderDropdownButton(
                          label: Language.logoutButton,
                          icon: Icons.exit_to_app,
                          onTap: null,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            // if (!Responsive.isDesktop(context))
            //   IconButton(
            //     icon: Icon(Icons.menu),
            //     onPressed: context.read<MenuController>().controlMenu,
            //   ),
            if (!Responsive.isMobile(context))
              Text(
                widget.title,
                style: Theme.of(context).textTheme.headline6,
              ),
            if (!Responsive.isMobile(context))
              Spacer(flex: Responsive.isDesktop(context) ? 2 : 1),
            const Expanded(child: SearchField()),
            // DashboardCard(_toggleMenuOptions),
          ],
        ),
        _drawMenuOptions(),
      ],
    );
  }
}

class DashboardCard extends StatelessWidget {
  final VoidCallback _openMenuOptionsAction;

  const DashboardCard(
    this._openMenuOptionsAction, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _openMenuOptionsAction,
      child: Container(
        margin: const EdgeInsets.only(left: Constants.defaultPadding),
        padding: const EdgeInsets.only(
          left: Constants.defaultPadding,
        ),
        child: Consumer<UserState>(
          builder: (context, userstate, child) {
            return Row(
              children: [
                kIsWeb
                    ? Image.asset(
                        Constants.placeholderUserIcon,
                        height: 24,
                      )
                    : SvgPicture.network(
                        userstate.data.icon,
                        height: 24,
                      ),
                if (!Responsive.isMobile(context))
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Constants.defaultPadding / 2,
                    ),
                    child: Text(userstate.data.name),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class SearchField extends StatefulWidget {
  const SearchField({
    Key? key,
  }) : super(key: key);

  @override
  _StateSearchField createState() => _StateSearchField();
}

class _StateSearchField extends State<SearchField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _lastInteraction = DateTime.now().subtract(Duration(seconds: _timeout));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final int _timeout = 5;
  DateTime _lastInteraction = DateTime.now();
  bool get _rejectChangeState {
    Duration timeSince = DateTime.now().difference(_lastInteraction);

    return timeSince.inSeconds < _timeout;
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'searchBar',
      child: SizedBox(
        height: 20,
        child: TextField(
          onChanged: (value) {
            if (_rejectChangeState) return;

            _lastInteraction = DateTime.now();

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SearchPage(
                  initialSearchInput: value,
                ),
              ),
            );
          },
          controller: _controller,
          decoration: InputDecoration(
            hintText: Language.searchPrompt,
            border: const OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 6,
            ),
            suffixIcon: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  SearchPage.routeName,
                );
              },
              child: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: Constants.defaultPadding / 2,
                ),
                child: const Icon(
                  Icons.search,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
