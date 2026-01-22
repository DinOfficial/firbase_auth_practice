import 'package:flutter/material.dart';
import 'package:getx/home_page.dart';
import 'package:getx/match_provider.dart';
import 'package:provider/provider.dart';

import 'match_model.dart';

class AddMatchScreen extends StatefulWidget {
  const AddMatchScreen({super.key});

  @override
  State<AddMatchScreen> createState() => _AddMatchScreenState();
}

class _AddMatchScreenState extends State<AddMatchScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _team1NameController = TextEditingController();
  final TextEditingController _team2NameController = TextEditingController();
  final TextEditingController _team1ScoreController = TextEditingController();
  final TextEditingController _team2ScoreController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.amber, title: Text('Add Match')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Add Match', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 12),
              TextFormField(
                controller: _team1NameController,
                decoration: InputDecoration(labelText: 'Team 1 name', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _team2NameController,
                decoration: InputDecoration(labelText: 'Team 2 name', border: OutlineInputBorder()),
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _team1ScoreController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Team 1 score',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _team2ScoreController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Team 2 score',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Consumer<MatchProvider>(
                  builder: (context, provider, _) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        final match = MatchModel(
                          team1Name: _team1NameController.text,
                          team2Name: _team2NameController.text,
                          team1Score: int.parse(_team1ScoreController.text),
                          team2Score: int.parse(_team2ScoreController.text),
                          isRunning: true,
                          winnerTeam: '',
                        );
                        provider.addMatch(match);
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => HomePage()),
                          (p) => false,
                        );
                      },
                      child: Text('Submit', style: TextStyle(fontSize: 20)),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
