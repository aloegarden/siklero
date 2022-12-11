class Hotline {

  const Hotline({
    //required this.icon,
    required this.title,
    this.tiles = const [],
  });

  //final Icon icon;
  final String title;
  final List<Hotline> tiles;
  //final Map<String, List<String>> hotlineText;
}

final List <Hotline> hotlineItems = <Hotline>[
  const Hotline(
    title: "Local Emergency Numbers",
    tiles: [
      Hotline(
        title: "Philippine National Police",
        tiles: [
          Hotline(title: "117"),
          Hotline(title: "02 722 0650")
          ]
      ),
      Hotline(
        title: "Metropolitan Manila Development Authority (MMDA)",
        tiles: [
          Hotline(title: "136")
        ]
      ),
      Hotline(
        title: "Bureau of Fire Protection (BFP)",
        tiles: [
          Hotline(title: "02 729 5166"),
          Hotline(title: "02 410 6254"),
          Hotline(title: "02 431 8859"),
          Hotline(title: "02 407 1230"),
        ]
      ),
      Hotline(
        title: "Philippine Coast Guard",
        tiles: [
          Hotline(title: "02 527 8481")
        ]
      ),
      Hotline(
        title: "Manila Water Hotline",
        tiles: [
          Hotline(title: "1627")
        ]
      ),
    ]
  ),
  const Hotline(
    title: "Manila Private Hospitals",
    tiles: [
      Hotline(
        title: "St. Luke’s Medical Center – Global City",
        tiles: [
          Hotline(title: "02 789 7700"),
          Hotline(title: "02 723 0101")
        ]
      ),
      Hotline(
        title: "Makati Medical Center",
        tiles: [
          Hotline(title: "02 888 8999")
        ]
      ),
      Hotline(
        title: "Asian Hospital and Medical Center",
        tiles: [
          Hotline(title: "02 771 9000")
        ]
      ),
      Hotline(
        title: "The Medical City",
        tiles: [
          Hotline(title: "02 635 6789")
        ]
      ),
      Hotline(
        title: "Cardinal Santos Medical Center",
        tiles: [
          Hotline(title: "02 727 0001")
        ]
      ),
      Hotline(
        title: "Manila Doctors Hospital",
        tiles: [
          Hotline(title: "02 524 3011")
        ]
      ),
      Hotline(
        title: "World City Medical Center",
        tiles: [
          Hotline(title: "02 913 8320")
        ]
      ),
      Hotline(
        title: "UST Hospital",
        tiles: [
          Hotline(title: "02 731 3001")
        ]
      ),
    ]
  ),
  const Hotline(
    title: "Manila Government Hospitals",
    tiles: [
      Hotline(
        title: "Philippine General Hospital",
        tiles: [
          Hotline(title: "02 521 8450"),
          Hotline(title: "02 524 2221"),
        ]
      ),
      Hotline(
        title: "Ospital ng Maynila Medical Center",
        tiles: [
          Hotline(title: "02 524 6061"),
        ]
      ),
      Hotline(
        title: "Dr. Jose Fabella Memorial Hospital",
        tiles: [
          Hotline(title: "02 735 7144"),
        ]
      ),
      Hotline(
        title: "San Lazaro Hospital" ,
        tiles: [
          Hotline(title: "02 732 9177"),
          Hotline(title: "02 711 6966"),
        ]
      ),
      Hotline(
        title: "Tondo Medical Center",
        tiles: [
          Hotline(title: "02 251 8421"),
        ]
      ),
    ]
  ),
];