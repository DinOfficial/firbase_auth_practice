import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getx/log_in_screen.dart';
import 'package:getx/match_model.dart';
import 'package:getx/match_provider.dart';
import 'package:getx/sign_up_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import 'add_match_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final MatchProvider matchProvider = MatchProvider();

  @override
  void initState() {
    super.initState();
    Provider.of<MatchProvider>(context, listen: false).list.clear();
    Provider.of<MatchProvider>(context, listen: false).getMatches();
    Provider.of<MatchProvider>(context, listen: false).list;
  }
  @override
  Widget build(BuildContext context) {
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
                  MaterialPageRoute(builder: (_) => const SignInScreen()),
                  (route) => false,
                );
              },
              icon: Icon(Icons.logout, color: Colors.white, size: 28),
            ),
          ),
        ],
      ),
      body: Consumer<MatchProvider>(
        builder: (context, matchProvider, _) {
          return ListView.separated(
            itemCount: matchProvider.list.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(radius: 8),
                title: Text('${matchProvider.list[index].team1Name} VS ${matchProvider.list[index].team2Name}'),
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
          );
        }
      ),
      floatingActionButton: FloatingActionButton(onPressed: _onTapAddIcon, child: Icon(Icons.add)),
    );
  }

  void _onTapAddIcon() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const AddMatchScreen()));
  }

}
