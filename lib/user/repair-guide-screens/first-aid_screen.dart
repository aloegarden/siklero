import 'package:flutter/material.dart';
import 'package:siklero/model/repair_guide/first_aid.dart';

class FirstAidScreen extends StatefulWidget {
  const FirstAidScreen({super.key});

  @override
  State<FirstAidScreen> createState() => _FirstAidScreenState();
}

class _FirstAidScreenState extends State<FirstAidScreen> {

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
          Stack(
            children: [
              SizedBox(
                height: 150,
                width: MediaQuery.of(context).size.width,
                child: Image.asset(
                  firstAid.imagePath,
                  fit: BoxFit.fitWidth,
                )
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    "Image: ${firstAid.imagecredit}",
                    style: TextStyle(fontFamily: "OpenSans", color: Colors.black.withOpacity(0.5), fontSize: 12),
                  ),
                )
              )
            ],
          ),
          ExpansionTile(
            backgroundColor: const Color(0xFfFFD4BC),
            title: Text(firstAid.title, style: titleStyle,),
            subtitle: Text("Courtesy: ${firstAid.courtesy}", style: courtesyStyle,),
            children: [ListTile(title: Text(firstAid.description, style: contentStyle,),), const Divider()],
          )
        ],
      ),
    ),
  ); 
}