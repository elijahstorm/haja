import 'package:flutter/material.dart';
import 'package:haja/language/language.dart';

class User {
  String name, username, image;
  bool isFollowedByMe;

  User(this.name, this.username, this.image, this.isFollowedByMe);
}

class SearchPage extends StatefulWidget {
  static const routeName = '/search';

  final String? initialSearchInput;

  const SearchPage({
    this.initialSearchInput,
    Key? key,
  }) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final List<User> _users = [
    User(
        'Elliana Palacios',
        '@elliana',
        'https://images.unsplash.com/photo-1504735217152-b768bcab5ebc?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=200&w=200&s=0ec8291c3fd2f774a365c8651210a18b',
        false),
    User(
        'Kayley Dwyer',
        '@kayley',
        'https://images.unsplash.com/photo-1503467913725-8484b65b0715?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=200&w=200&s=cf7f82093012c4789841f570933f88e3',
        false),
    User(
        'Kathleen Mcdonough',
        '@kathleen',
        'https://images.unsplash.com/photo-1507081323647-4d250478b919?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=200&w=200&s=b717a6d0469694bbe6400e6bfe45a1da',
        false),
    User(
        'Kathleen Dyer',
        '@kathleen',
        'https://images.unsplash.com/photo-1502980426475-b83966705988?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=200&w=200&s=ddcb7ec744fc63472f2d9e19362aa387',
        false),
    User(
        'Mikayla Marquez',
        '@mikayla',
        'https://images.unsplash.com/photo-1541710430735-5fca14c95b00?ixlib=rb-1.2.1&q=80&fm=jpg&crop=faces&fit=crop&h=200&w=200&ixid=eyJhcHBfaWQiOjE3Nzg0fQ',
        false),
    User(
        'Kiersten Lange',
        '@kiersten',
        'https://images.unsplash.com/photo-1542534759-05f6c34a9e63?ixlib=rb-1.2.1&q=80&fm=jpg&crop=faces&fit=crop&h=200&w=200&ixid=eyJhcHBfaWQiOjE3Nzg0fQ',
        false),
    User(
        'Carys Metz',
        '@metz',
        'https://images.unsplash.com/photo-1516239482977-b550ba7253f2?ixlib=rb-1.2.1&q=80&fm=jpg&crop=faces&fit=crop&h=200&w=200&ixid=eyJhcHBfaWQiOjE3Nzg0fQ',
        false),
    User(
        'Ignacio Schmidt',
        '@schmidt',
        'https://images.unsplash.com/photo-1542973748-658653fb3d12?ixlib=rb-1.2.1&q=80&fm=jpg&crop=faces&fit=crop&h=200&w=200&ixid=eyJhcHBfaWQiOjE3Nzg0fQ',
        false),
    User(
        'Clyde Lucas',
        '@clyde',
        'https://images.unsplash.com/photo-1569443693539-175ea9f007e8?ixlib=rb-1.2.1&q=80&fm=jpg&crop=faces&fit=crop&h=200&w=200&ixid=eyJhcHBfaWQiOjE3Nzg0fQ',
        false),
    User(
        'Mikayla Marquez',
        '@mikayla',
        'https://images.unsplash.com/photo-1541710430735-5fca14c95b00?ixlib=rb-1.2.1&q=80&fm=jpg&crop=faces&fit=crop&h=200&w=200&ixid=eyJhcHBfaWQiOjE3Nzg0fQ',
        false)
  ];

  List<User> _searchResults = [];

  @override
  void initState() {
    super.initState();

    setState(() {
      _searchResults = _users;
    });

    if (widget.initialSearchInput == null) return;

    _onSearch(widget.initialSearchInput!);
  }

  void _onSearch(String search) {
    setState(() {
      _searchResults = _users
          .where((user) => user.name.toLowerCase().contains(search))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        iconTheme: Theme.of(context).iconTheme,
        title: SizedBox(
          height: 38,
          child: Hero(
            tag: 'searchBar',
            child: TextFormField(
              onChanged: (value) => _onSearch(value),
              initialValue: widget.initialSearchInput,
              autofocus: widget.initialSearchInput != null,
              decoration: InputDecoration(
                filled: true,
                fillColor: Theme.of(context).cardColor,
                contentPadding: const EdgeInsets.all(0),
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide.none),
                hintStyle: const TextStyle(
                  fontSize: 14,
                ),
                hintText: 'Search users',
              ),
            ),
          ),
        ),
      ),
      body: Container(
        child: _searchResults.isNotEmpty
            ? ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  return userComponent(user: _searchResults[index]);
                },
              )
            : const Center(
                child: Text(Language.noDataFoundError),
              ),
      ),
    );
  }

  Widget userComponent({required User user}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            SizedBox(
                width: 60,
                height: 60,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.network(user.image),
                )),
            const SizedBox(width: 10),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                user.name,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                user.username,
                style: TextStyle(
                  color: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .color!
                      .withOpacity(.8),
                ),
              ),
            ])
          ]),
          GestureDetector(
            onTap: () {
              setState(() {
                user.isFollowedByMe = !user.isFollowedByMe;
              });
            },
            child: AnimatedContainer(
              height: 35,
              width: 110,
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                color: user.isFollowedByMe
                    ? Theme.of(context).primaryColor
                    : Colors.grey.withOpacity(0.05),
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                    color: user.isFollowedByMe
                        ? Colors.transparent
                        : Colors.grey.shade700),
              ),
              child: Center(
                child: Text(
                  user.isFollowedByMe
                      ? Language.unfollowButton
                      : Language.followButton,
                  style: TextStyle(
                    color: user.isFollowedByMe ? Colors.white : null,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
