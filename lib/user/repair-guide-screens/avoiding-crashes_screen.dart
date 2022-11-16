import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:siklero/model/repair_guide/crash.dart';

class AvoidingCrashesScreen extends StatefulWidget {
  const AvoidingCrashesScreen({super.key});

  @override
  State<AvoidingCrashesScreen> createState() => _AvoidingCrashesScreenState();
}

class _AvoidingCrashesScreenState extends State<AvoidingCrashesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: const Color(0xffed8f5b),
          title: const Text('Avoiding Crash', style: TextStyle(fontFamily: 'OpenSans', fontSize: 24),),
          centerTitle: true,
          elevation: 0,
      ),
      body: ListView(
        children: crashes.map(buildCard).toList(),
      )
    );
  }
  
  Widget buildCard(Crash crash) => Padding(
    padding: const EdgeInsets.all(10),

    child: Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 150,
            width: MediaQuery.of(context).size.width,
            child: Image.asset(
              crash.imagePath,
              fit: BoxFit.fitWidth,
            )
          ),
          ExpansionTile(
            title: Text(crash.title),
            subtitle: Text("Courtesy: " + crash.courtesy),
            children: [ListTile(title: Text(crash.description),)],
          )
        ],
      ),
    ),
  ); 
}