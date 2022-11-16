import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:siklero/model/repair_guide/repair.dart';

class RoadsideRepairScreen extends StatefulWidget {
  const RoadsideRepairScreen({super.key});

  @override
  State<RoadsideRepairScreen> createState() => _RoadsideRepairScreenState();
}

class _RoadsideRepairScreenState extends State<RoadsideRepairScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: const Color(0xffed8f5b),
          title: const Text('Preparation', style: TextStyle(fontFamily: 'OpenSans', fontSize: 24),),
          centerTitle: true,
          elevation: 0,
      ),
      body: ListView(
        children: repairs.map(buildCard).toList(),
      )
    );
  }
  
  Widget buildCard(Repair repair) => Padding(
    padding: const EdgeInsets.all(10),

    child: Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 150,
            width: MediaQuery.of(context).size.width,
            child: Image.asset(
              repair.imagePath,
              fit: BoxFit.fitWidth,
            )
          ),
          ExpansionTile(
            title: Text(repair.title),
            subtitle: Text("Courtesy: " + repair.courtesy),
            children: [ListTile(title: Text(repair.description),)],
          )
        ],
      ),
    ),
  ); 
}