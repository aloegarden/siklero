import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:siklero/model/repair_guide/preparation.dart';

class PreparationScreen extends StatefulWidget {
  const PreparationScreen({super.key});

  @override
  State<PreparationScreen> createState() => _PreparationScreenState();
}

class _PreparationScreenState extends State<PreparationScreen> {
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
        children: preparations.map(buildCard).toList(),
      )
    );
  }
  
  Widget buildCard(Preparation preparation) => Padding(
    padding: const EdgeInsets.all(10),

    child: Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: <Widget>[
          Stack(
            children: [
              SizedBox(
                height: 150,
                width: MediaQuery.of(context).size.width,
                child: Image.asset(
                  preparation.imagePath,
                  fit: BoxFit.fitWidth,
                )
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    "Image: ${preparation.imagecredit}",
                    style: TextStyle(fontFamily: "OpenSans", color: Colors.black.withOpacity(0.5), fontSize: 12),
                  ),
                )
              )
            ],
          ),
          ExpansionTile(
            title: Text(preparation.title),
            subtitle: Text("Courtesy: ${preparation.courtesy}"),
            children: [ListTile(title: Text(preparation.description),)],
          )
        ],
      ),
    ),
  ); 
}