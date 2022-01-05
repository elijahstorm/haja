import 'package:flutter/material.dart';

import 'package:haja/constants.dart';

class ErrorDisplay extends StatelessWidget {
  final String _err, title, retryPrompt;
  final VoidCallback? retry;

  const ErrorDisplay(
    this._err, {
    this.title = 'Ooops! 😓',
    this.retry,
    this.retryPrompt = 'Try Again',
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.only(
          top: Constants.defaultPadding,
        ),
        child: Center(
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: SizedBox(
                  height: 200,
                  child: Image.asset('assets/images/no-connection.gif'),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                  top: Constants.defaultPadding * 2,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: Constants.defaultPadding,
                  vertical: Constants.defaultPadding,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Column(
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    const SizedBox(height: Constants.defaultPadding),
                    Text(
                      _err,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: Constants.defaultPadding * 2),
                    if (retry != null)
                      MaterialButton(
                        onPressed: retry,
                        height: 45,
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        color: Theme.of(context).primaryColor,
                        child: Text(
                          retryPrompt,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
}
