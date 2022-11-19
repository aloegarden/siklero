import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:siklero/model/repair_guide.dart';

class RepairGuideScreen extends StatelessWidget {
  const RepairGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffed8f5b),
      appBar: AppBar(
        backgroundColor: const Color(0xffed8f5b),
          title: const Text('Repair Guide', style: TextStyle(fontFamily: 'OpenSans', fontSize: 24),),
          centerTitle: true,
          elevation: 0,
      ),
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: true,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(top: 20),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),

                      child: SizedBox(
                        height: 10000,

                        child: GridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          physics: const ScrollPhysics(),

                          children: List.generate(repairguideItems.length, (index) {
                            return Center(
                              child: homeCard(context, repairguideItem: repairguideItems[index],),
                            );
                          }
                          )
                        ),
                      ),
                    ),
                  )
                ),
              ],
            )
          )
        ],
      ),
    );
  }

  Widget homeCard(BuildContext context, {required RepairGuide repairguideItem}){
    Color primaryColor = const Color(0xffE45F1E);
    const TextStyle textStyle = TextStyle(
      fontFamily: 'OpenSans',
      fontWeight: FontWeight.w700,
      fontSize: 20,
      color: Colors.white
    );

    return InkWell(
      onTap: () async {
        Navigator.push(context, MaterialPageRoute(builder: (context) => repairguideItem.screen));
      },
      child: Card(
        color: primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(child: repairguideItem.icon),
                const SizedBox(height: 20,),
                Flexible(child: Text(repairguideItem.text, overflow: TextOverflow.fade, style: textStyle, textAlign: TextAlign.center,))
              ],
            ),
          ),
        ),
      ),
    );
  }
}