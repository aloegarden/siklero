import 'package:flutter/cupertino.dart';

class Hotline {
  Hotline({
    //required this.icon,
    required this.headerText,
    required this.hotlineText,
    required this.isExpanded
  });

  //final Icon icon;
  final String headerText;
  final Map<String, List<String>> hotlineText;
  final bool isExpanded;
}

final List <Hotline> hotlineItems = [
  Hotline(
    //icon: ,
    headerText: "Local Emergency Numbers", 
    hotlineText: {
      "National Emergency Line" : ["117"],
      "Philippine National Police" : ["117", "02 722 0650"],
      "Metropolitan Manila Development Authority (MMDA)" : ["136"],
      "Bureau of Fire Protection (BFP)" : ["02 729 5166", "02 410 6254", "02 431 8859", "02 407 1230"],
      "Philippine Coast Guard" : ["02 527 8481"],
      "Manila Water Hotline" : ["1627"]
    }, 
    isExpanded: false
  ),
  Hotline(
    headerText: "Manila Private Hospitals", 
    hotlineText: {
      "St. Luke’s Medical Center – Global City" : ["02 789 7700", "02 723 0101"],
      "Makati Medical Center" : ["02 888 8999"],
      "Asian Hospital and Medical Center" : ["02 771 9000"],
      "The Medical City" : ["02 635 6789"],
      "Cardinal Santos Medical Center" : ["02 727 0001"],
      "Manila Doctors Hospital" : ["02 524 3011"],
      "World City Medical Center" : ["02 913 8320"],
      "UST Hospital" : ["02 731 3001"]
    }, 
    isExpanded: false
  ),
  Hotline(
    headerText: "Manila Government Hospitals", 
    hotlineText: {
      "Philippine General Hospital" : ["02 521 8450", "02 524 2221"],
      "Ospital ng Maynila Medical Center" : ["02 524 6061"],
      "Dr. Jose Fabella Memorial Hospital" : ["02 735 7144"],
      "San Lazaro Hospital" : ["02 732 9177", "02 711 6966"],
      "Tondo Medical Center" : ["02 251 8421"]
    }, 
    isExpanded: false
  ),
  
];