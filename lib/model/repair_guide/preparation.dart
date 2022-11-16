class Preparation {
  final String title;
  final String courtesy;
  final String description;
  final String imagePath;

  Preparation({
    required this.title,
    required this.courtesy,
    required this.description,
    required this.imagePath
  });
}

List<Preparation> preparations = [
  Preparation(
    title: "Bike ABC’s: Air, Brakes, Chain", 
    courtesy: "rei.com", 
    description: "A is for Air: Having properly inflated tires helps prevent flats. Check the sidewall of your tire for the recommended tire pressure. While you’re checking the air, take a moment to look for cracks or excessive wear on your tires. Also take the opportunity to ensure your quick-release levers and thru axles (if you have them) that attach your wheels to the bike frame are properly tightened. Then, before you ride, make sure you have your patch kit and pump with you.\n\n"
    + "B is for Brakes: Squeeze your front and rear brake levers to make sure that the brakes engage properly and smoothly.\n\n"
    + "C is for Chain: Look at your chain and all the gears. Keeping your chain lubricated and everything clean will ensure your bike shifts easier and the drivetrain (made up of the front chain rings, rear cassette, rear derailleur and chain) last longer.", 
    imagePath: "asset/img/preparation_image/bike-abc.jpg"
  ),
  Preparation(
    title: "Check Your Bike Size", 
    courtesy: "rei.com", 
    description: "If it has been a while since you’ve been on your bike, or you’re borrowing one from a friend, make sure it fits you. As a general rule, when you’re standing over the bike with your feet flat on the ground there should be at least 1– 2 inches of clearance between your crotch and the top tube (bar) on a road bike and at least 2–3 inches on a mountain bike.", 
    imagePath: "asset/img/preparation_image/check-your-bike-size.jpg"
  ),
  Preparation(
    title: "Bike Seat Height and Positioning", 
    courtesy: "rei.com", 
    description: "Check that the saddle (seat) is adjusted at the right height and position for you.\n"
    + "Having the saddle at the right height for pedaling is important for your knees: When your leg extended in the 6 o’clock position, your knee should be slightly bent.\n"
    + "The correct fore/aft position is when your knee is directly over the center of your front pedal when your feet are parallel to the ground.\n"
    + "Personal preference determines whether the saddle should be tipped forward, level or backward.", 
    imagePath: "asset/img/preparation_image/bike-seat-and-height.jpg"
  ),
  Preparation(
    title: "Bike Rims", 
    courtesy: "rei.com", 
    description: "Lift up the bike and spin the wheels. The rims should be straight and not wobble noticeably from side-to-side or up-and-down. If they do, that means your wheel isn’t true (straight) and you need to bring your bike in for service.", 
    imagePath: "asset/img/preparation_image/bike-rims.jpg"
  ),
  Preparation(
    title: "Bike Gears", 
    courtesy: "rei.com", 
    description: "Spin the crank and shift through the gears. The chain should transfer smoothly from gear to gear. If the chain wants to jump up or down a gear on your rear cassette, then the shifting needs to be adjusted.", 
    imagePath: "asset/img/preparation_image/bike-gear.jpg"
  ),
  Preparation(
    title: "Bike Cranks", 
    courtesy: "rei.com", 
    description: "Cranks are the arms that attach the pedals to the bike. Give each one a pull to make sure it is tight. Do not ride a bike with a loose crank.", 
    imagePath: "asset/img/preparation_image/bike-crank.jpg"
  ),
  Preparation(
    title: "Bike Frame and Headset", 
    courtesy: "rei.com", 
    description: "First, check the frame for cracks. Then, hold the front brake and rock the bike back and forth. Excessive play means the headset needs adjusting. Do not ride a bike with a cracked frame or loose headset.", 
    imagePath: "asset/img/preparation_image/frame-headset.jpg"
  ),
];