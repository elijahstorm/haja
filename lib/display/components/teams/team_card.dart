import 'package:flutter/material.dart';

import 'package:haja/content/teams/content.dart';
import 'package:haja/content/todo/content.dart';
import 'package:haja/language/constants.dart';
import 'package:haja/language/language.dart';

// TODO: this
class TeamCard extends StatelessWidget {
  final TeamContent content;

  const TeamCard(
    this.content, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      child: GestureDetector(
        onTap: () => content.navigateTo(context),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 150,
                child: Image.network(
                  content.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, err, stacktrace) => Image.asset(
                    Constants.defaultTeamPicture,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: Constants.defaultPadding,
                  horizontal: Constants.defaultPadding / 2,
                ),
                child: Text(content.title),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: Constants.defaultPadding,
                  horizontal: Constants.defaultPadding / 2,
                ),
                // child: Row(
                //   children: [
                //     Opacity(
                //       opacity: .7,
                //       child: FutureBuilder<List<TodoContent>>(
                //         future: content.activeTodos,
                //         builder: (context, snapshot) => Text(
                //           snapshot.hasData
                //               ? Language.countableWithTrailingS(
                //                   snapshot.data!.length,
                //                   'active Todo',
                //                 )
                //               : Language.loadingActiveTeamTodos,
                //           style: const TextStyle(
                //             fontSize: 16,
                //           ),
                //         ),
                //       ),
                //     ),
                //     const SizedBox(width: Constants.defaultPadding * 5),
                //     Opacity(
                //       opacity: .7,
                //       child: Text(
                //         Language.countableWithTrailingS(
                //           content.users.length,
                //           'member',
                //         ),
                //         style: const TextStyle(
                //           fontSize: 16,
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
