class Tool {
  final String title;
  final String courtesy;
  final String description;
  final String imagePath;

  Tool({
    required this.title,
    required this.courtesy,
    required this.description,
    required this.imagePath
  });
}

final List<Tool> tools = [
  Tool(
    title: 'Allen Key', 
    courtesy: "ridefar.info",
    description: 'Sizes from 1.5 mm to 10 mm may be needed, depending on what bolts are on your bike. Adapter heads for the larger sizes (6, 8, 10 mm) that fit over smaller size keys can often be used instead of separate large keys if you don’t need very much leverage.', 
    imagePath: 'asset/img/tools_image/allen-key.jpg'
  ),
  Tool(
    title: 'Screwdriver', 
    courtesy: "ridefar.info",
    description: 'A flat-blade screwdriver can be useful for all sorts of tasks; a cross-head screwdriver is generally less useful.', 
    imagePath: 'asset/img/tools_image/screwdriver.jpg'
  ),
  Tool(
    title: 'Chain tool', 
    courtesy: "ridefar.info",
    description: 'Make sure that your chain tool is strong enough to remove a pin from the chain you are using so that you can replace a damaged link with a quick link. You normally won’t need to use the tool to re-join a chain unless you run out of quick links.', 
    imagePath: 'asset/img/tools_image/chain-tool.jpg'
  ),
  Tool(
    title: 'Multi-tools vs. individual tools', 
    courtesy: "ridefar.info",
    description: 'Multi-tools are great at keeping your tools compact and organized, but they can sometimes be awkward to use in tight places. Keep a multi-tool for minimalist, fast bike for rides closer to home, but for the bikepacking races I bring a set of small, individual tools because they are far easier to work with and barely weigh any extra or take up much more space, but this is a very individual preference.', 
    imagePath: 'asset/img/tools_image/multitool-vs-tools.jpg'
  ),
  Tool(
    title: 'Smart Phone', 
    courtesy: "ridefar.info",
    description: 'If you have a bike problem that you don’t know how to fix in a bikepacking race, you shouldn’t call your buddy who is a bike mechanic (that would be a form of personal assistance, so would be against the ethos of being self-supported), but you can use it to search the internet for possible solutions to the problem. There are also app’s available that show you how to do basic repairs.', 
    imagePath: 'asset/img/tools_image/smart-phone.jpg'
  ),
  Tool(
    title: 'Tire Levers', 
    courtesy: "ridefar.info",
    description: 'Strong levers that won’t break are important. One lever is enough for some tires but two levers make the job far easier, so I always carry three so that I have an extra in case one breaks, and occasionally all three are needed for really tight tires. ', 
    imagePath: 'asset/img/tools_image/tire-lever.jpg'
  ),
  Tool(
    title: 'Tire Pump', 
    courtesy: "ridefar.info",
    description: 'A minimal, lightweight pump is ideal on a stripped-down race bike where you hope to never use it. If you do get a puncture then it’s important to be able to easily achieve a sufficient pressure to ensure that you are not susceptible to future pinch flats.', 
    imagePath: 'asset/img/tools_image/pump.jpeg'
  ),
  Tool(
    title: 'Chain Lube', 
    courtesy: "ridefar.info",
    description: 'Oil is not really a tool or a spare part, but is something that you should bring with you. Put a few drops on the chain pins every couple of days or after a big rain shower. If you leave it until your drivetrain is getting noisy then you will have been wasting energy for a while.', 
    imagePath: 'asset/img/tools_image/chain-lube.jpg'
  ),
  Tool(
    title: 'Inner Tube', 
    courtesy: "cyclesuk.com",
    description: 'If you get a puncture when you are out cycling the quickest way to fix it is to pull the old tube out and put a new one in. Trying to find the hole in the tube and patch it properly is not something you want to do at the side of the road on a cold and rainy day. You can always patch the old tube when you get home.', 
    imagePath: 'asset/img/tools_image/inner-tube.jpg'
  ),
  Tool(
    title: 'Patch Kit', 
    courtesy: "rei.com",
    description: 'The most common problem cyclists face is a flat tire. Always carry a spare tube and/or a patch kit with you. If your flat tire is caused by a small puncture, you’ll likely be able to use a patch kit to fix it. For large punctures and blowouts, replacing the tube is your best option.', 
    imagePath: 'asset/img/tools_image/patch-kit.jpg'
  ),
  Tool(
    title: 'First Aid Kit', 
    courtesy: "stereosports.co.uk", 
    description: "No matter where you are when you get into an accident on your bike, the earlier you can treat injuries, the better chance you have of recovering quickly and getting back to what you enjoy. Take care of yourself with a bike first aid kit. A cycling first aid kit can be tiny, compact, and lightweight.", 
    imagePath: 'asset/img/tools_image/first-aid-kit.jpg')
];