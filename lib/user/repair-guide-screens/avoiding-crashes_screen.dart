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

  final TextStyle titleStyle = const TextStyle(
    fontFamily: 'OpenSans',
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: Color(0xff581D00)
  );

  final TextStyle courtesyStyle = const TextStyle(
    fontFamily: 'OpenSans',
    color: Colors.deepOrange
  );

  final TextStyle contentStyle = const TextStyle(
    fontFamily: 'OpenSans',
    color: Color(0xff581D00)
  );


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
            backgroundColor: Color(0xFfFFD4BC),
            title: Text(crash.title, style: titleStyle,),
            subtitle: Text("Courtesy: " + crash.courtesy, style: courtesyStyle,),
            children: [ListTile(title: Text(crash.description, style: contentStyle,),), Divider()],
          )
        ],
      ),
    ),
  ); 
}