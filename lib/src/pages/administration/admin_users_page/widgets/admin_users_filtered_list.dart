import 'package:appli_wei_custom/models/user.dart';
import 'package:appli_wei_custom/src/pages/administration/admin_users_page/widgets/admin_user_card.dart';
import 'package:appli_wei_custom/src/providers/user_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminUsersFilteredList extends StatefulWidget {
  const AdminUsersFilteredList({Key key, @required this.users}) : super(key: key);

  final List<User> users;

  @override 
  _AdminUsersFilteredListState createState() => _AdminUsersFilteredListState();
}

class _AdminUsersFilteredListState extends State<AdminUsersFilteredList> {
  final TextEditingController _controller = TextEditingController();
  String _filter;

  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
      setState(() {
        _filter = _controller.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: TextField(
            decoration: const InputDecoration(
              labelText: "Chercher un utilisateur",
            ),
            controller: _controller,
          ),
        ),
        const SizedBox(height: 8.0,),
        Expanded(
          child: ListView.builder(
            itemCount: widget.users.length,
            itemBuilder: (context, index) {
              return Consumer<UserStore>(
                builder: (context, userStore, child) {
                  return Visibility(
                    visible: 
                    _filter == null ||
                    _filter == "" ||
                    widget.users[index].firstName.toLowerCase().contains(_filter.toLowerCase()) ||
                    widget.users[index].lastName.toLowerCase().contains(_filter.toLowerCase()) ||
                    widget.users[index].username.toLowerCase().contains(_filter.toLowerCase()) ||
                    widget.users[index].email.toLowerCase().contains(_filter.toLowerCase()),
                    child: AdminUserCard(user: widget.users[index],),
                  );
                },
              );
            },
          ),
        )
      ],
    );
  }
}