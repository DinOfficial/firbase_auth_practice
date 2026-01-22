import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getx/sign_up_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'add_match_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text('Live Score App'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 24),
            child: IconButton(
              onPressed: () async {
                await GoogleSignIn().signOut();
                await FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const SignUpScreen()),
                  (route) => false,
                );
              },
              icon: Icon(Icons.logout, color: Colors.white, size: 28),
            ),
          ),
        ],
      ),
      body: ListView.separated(
        itemCount: 10,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(radius: 8),
            title: Text('Bangladesh VS Argentina'),
            subtitle: Text('Winner Team: Pending'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('2:3', style: TextStyle(fontSize: 24)),
                IconButton(onPressed: () {}, icon: Icon(Icons.edit_location_alt_outlined)),
                IconButton(onPressed: () {}, icon: Icon(Icons.delete_rounded)),
              ],
            ),
          );
        },
        separatorBuilder: (context, index) {
          return const SizedBox(height: 12);
        },
      ),
      floatingActionButton: FloatingActionButton(onPressed: _onTapAddIcon, child: Icon(Icons.add)),
    );
  }

  void _onTapAddIcon() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const AddMatchScreen()));
  }
}
