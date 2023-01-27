import 'package:flutter/material.dart';
import 'package:siklero/model/hotline.dart';
import 'package:siklero/user/utils/utils.dart';

class HotlineScreen extends StatelessWidget {
  const HotlineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffed8f5b),
        title: const Text('Hotlines', style: TextStyle(fontFamily: 'OpenSans', fontSize: 24),),
        centerTitle: true,
      ),
      body: ListView(
        children : hotlineItems.map(buildTile).toList()
      )
    );
  }

  Widget buildTile(Hotline tile, {double leftPadding = 16}) { 

    if (tile.tiles.isEmpty) {
      return ListTile(
        contentPadding: EdgeInsets.only(left: leftPadding, right: 16),
        title: Text(
          tile.title,
          style: const TextStyle(fontSize: 15),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.local_phone_outlined),
          onPressed: () => Utils.openHotlineCall(tile.title),
        ),
      );
    } else {
      return Card(
        child: ExpansionTile(
        tilePadding: EdgeInsets.only(left: leftPadding),
        trailing: const SizedBox.shrink(),
        leading: const Icon(Icons.keyboard_arrow_right_outlined),
      
        title: Text(
          tile.title,
        ),
        children: tile.tiles.map((tile) => buildTile(tile, leftPadding: 16 + leftPadding)).toList()
        ),
      );
    }
    
  }
}