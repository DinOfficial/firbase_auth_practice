import 'package:flutter/material.dart';

class AddMatchScreen extends StatefulWidget {
  const AddMatchScreen({super.key});

  @override
  State<AddMatchScreen> createState() => _AddMatchScreenState();
}

class _AddMatchScreenState extends State<AddMatchScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text('Add Match'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key:_formKey ,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Add Match', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 12),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Team 1',
                  border: OutlineInputBorder(),
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
