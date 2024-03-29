import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:siklero/model/repair_guide/tool.dart';

class ToolsScreen extends StatefulWidget {
  const ToolsScreen({super.key});

  @override
  State<ToolsScreen> createState() => _ToolsScreenState();
}
class _ToolsScreenState extends State<ToolsScreen> {

  late ExpandableController controller;

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
  void initState() {
    super.initState();
    controller = ExpandableController();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: const Color(0xffed8f5b),
          title: const Text('Tools', style: TextStyle(fontFamily: 'OpenSans', fontSize: 24),),
          centerTitle: true,
          elevation: 0,
      ),
      body: ListView(
        children: tools.map(buildCard).toList(),
      )
    );
  }
  
  Widget buildCard(Tool tool) => Padding(
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
                  tool.imagePath,
                  fit: BoxFit.fitWidth,
                )
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    "Image: ${tool.imagecredit}",
                    style: TextStyle(fontFamily: "OpenSans", color: Colors.black.withOpacity(0.5), fontSize: 12),
                  ),
                )
              )
            ],
          ),
          ExpansionTile(
            backgroundColor: const Color(0xFfFFD4BC),
            title: Text(
              tool.title,
              style: titleStyle
            ),
            subtitle: Text(
              "Courtesy: ${tool.courtesy}",
              style: courtesyStyle,
            ),
            children: [
              ListTile(title: Text(tool.description, style: contentStyle,)),
              const Divider()
            ],
          )
        ],
      ),
    ),
  );
}