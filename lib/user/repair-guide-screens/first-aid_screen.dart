import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:siklero/model/repair_guide/first_aid.dart';

class FirstAidScreen extends StatefulWidget {
  const FirstAidScreen({super.key});

  @override
  State<FirstAidScreen> createState() => _FirstAidScreenState();
}

class _FirstAidScreenState extends State<FirstAidScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: const Color(0xffed8f5b),
          title: const Text('First Aid', style: TextStyle(fontFamily: 'OpenSans', fontSize: 24),),
          centerTitle: true,
          elevation: 0,
      ),
      body: ListView(
        children: firstaids.map(buildCard).toList(),
      )
    );
  }
  
  Widget buildCard(FirstAid firstAid) => Padding(
    padding: const EdgeInsets.all(10),

    child: Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 150,
            width: MediaQuery.of(context).size.width,
            child: Image.asset(
              firstAid.imagePath,
              fit: BoxFit.fitWidth,
            )
          ),
          ExpansionTile(
            title: Text(firstAid.title),
            subtitle: Text("Courtesy: " + firstAid.courtesy),
            children: [ListTile(title: Text(firstAid.description),)],
          )
        ],
      ),
    ),
  ); 
}