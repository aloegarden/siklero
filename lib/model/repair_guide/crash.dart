class Crash {
  final String title;
  final String courtesy;
  final String description;
  final String imagePath;

  Crash({
    required this.title,
    required this.courtesy,
    required this.description,
    required this.imagePath
  });
}

final List<Crash> crashes = [
  Crash(
    title: "Make sure you’re riding the right size bike", 
    courtesy: "reasonoverlaw.com", 
    description: "The first way that you can make sure that you’re staying safe on the road is to make sure that you are riding the right size bicycle. If you ride a bicycle that is too small or too big, it will limit your ability to handle and control the bike properly.\n\n"
    + "As a general guide, you should be able to stand with your feet flat on the ground, leaving roughly two inches of space between the bike seat and your groin. It may also be beneficial to consult with your salesperson before purchasing a bike to ensure that you have the right size frame for your height.", 
    imagePath: "asset/img/avoiding-crashes_image/check-your-bike-size.jpg"
  ),
  Crash(
    title: "Double check your brakes", 
    courtesy: "reasonoverlaw.com", 
    description: "Before you get on the road, be sure to check and then double-check that your brakes are in good working order. Make sure that the brake pads on your bicycle are rubbing against the disc rotor on the wheels. If you experience any issues, it’s worth taking the time to adjust them before you head out.\n\n"
    + "To check and be sure the brakes are working properly, simply spin the wheels with your hand and press on the brake. You should complete this simple test for both your front and back wheels before you head out on the road.", 
    imagePath: "asset/img/avoiding-crashes_image/brake-pad.jpg"
  ),
  Crash(
    title: "Always use headlights", 
    courtesy: "reasonoverlaw.com", 
    description: "Headlights are not only beneficial to motor vehicles; adding headlights to a bicycle rider will help you to both see and be seen. If you’re looking to improve your safety whenever you’re on the road, consider installing both daytime running lights and a headlight for night riding.", 
    imagePath: "asset/img/avoiding-crashes_image/bike-headlight.jpg"
  ),
  Crash(
    title: "Always wear a helmet", 
    courtesy: "reasonoverlaw.com", 
    description: "Always wearing a helmet while you’re riding your bicycle will greatly reduce your chances of developing a life-changing injury, should you ever be  involved in a bicycle accident.\n\n"
    + "In the unfortunate event that you are involved in a bicycle accident, never reuse a helmet once it has been amaged. The fact is, helmets are designed to crack upon impact with the goal of protecting your skull.", 
    imagePath: "asset/img/avoiding-crashes_image/bike-helmet.jpeg"
  ),
  Crash(
    title: "Don't ride while wearing earphones", 
    courtesy: "reasonoverlaw.com", 
    description: "People enjoy wearing headphones or earbuds while biking, as it helps them relax, get energized, or just make the ride go by quicker. However, riding with headphones or earbuds can also be dangerous.\n\n"
    + "When riding a bicycle, particularly when other traffic is present, your senses need to process an awful lot in order to alert your brain to hazards. You need to be aware of other bikes, other cars, car horns, people yelling, even sirens from first-responder vehicles.\n\n"
    + "Even if you’re on quiet roads that aren’t commonly traveled, you need to listen for any vehicles that might be behind you and could potentially threaten your safety.\n\n"
    + "Since you’re already so vulnerable when riding a bicycle on the road, you should strongly consider whether it’s worth the risk to your safety by listening to music while you ride.", 
    imagePath: "asset/img/avoiding-crashes_image/headphones.jpg"
  ),
  Crash(
    title: "Keep both hands on handlebars", 
    courtesy: "reasonoverlaw.com", 
    description: "From time to time, many people ride bicycles with only one hand or even no hands on the handlebars. For some, this is because they’re holding something in one hand, like a cup of coffee or a cell phone. For others who might have more confidence in their abilities, riding in this manner simply looks cool.\n\n"
    + "However, riding without both hands on the handlebars brings with it significant risk. There are many hazards on the road such as potholes or unevenness in the pavement, that you might not see until you’re right on it. Rough road surfaces, even with two hands on the handlebars, can make it difficult to maintain full control of your bicycle.\n\n"
    + "Regardless of your circumstances, riding with both hands on the handlebars is always recommended and can greatly reduce the risk of an accident that could cause personal injury.", 
    imagePath: "asset/img/avoiding-crashes_image/no-hands.jpg"
  ),
  Crash(
    title: "Don't ride too fast", 
    courtesy: "reasonoverlaw.com", 
    description: "When you’re riding your bike, you should always travel at speeds that you feel comfortable with and that is appropriate for the current weather conditions, traffic conditions, and the road surface on which you’re riding.\n\n"
    + "Traveling at speeds that are excessive for your current conditions will only put yourself and those around you in danger.", 
    imagePath: "asset/img/avoiding-crashes_image/ride-fast.jpg"
  ),
];