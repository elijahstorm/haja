import 'package:flutter/material.dart';

class VideoPrebuffer extends StatelessWidget {
  final VoidCallback onTap;
  final String imageLink;
  final bool localImage;

  const VideoPrebuffer({
    required this.onTap,
    required this.imageLink,
    this.localImage = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: AspectRatio(
          aspectRatio: 1.5 / 1,
          child: Container(
            margin: const EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: localImage
                  ? DecorationImage(
                      image: AssetImage(imageLink),
                      fit: BoxFit.cover,
                    )
                  : DecorationImage(
                      image: NetworkImage(imageLink),
                      fit: BoxFit.cover,
                    ),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).scaffoldBackgroundColor.withOpacity(.9),
                    Theme.of(context).scaffoldBackgroundColor.withOpacity(.3),
                  ],
                ),
              ),
              child: const Align(
                child: Icon(
                  Icons.play_arrow,
                  size: 70,
                ),
              ),
            ),
          ),
        ),
      );
}
