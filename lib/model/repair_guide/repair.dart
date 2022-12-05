class Repair {
  final String title;
  final String courtesy;
  final String description;
  final String imagePath;
  final String videoLink;

  Repair({
    required this.title,
    required this.courtesy,
    required this.description,
    required this.imagePath,
    required this.videoLink
  });
}

final List<Repair> repairs = [
  Repair(
    title: "Inner Tube Replacement", 
    courtesy: "ridefar.info", 
    description: "When you have a puncture, simply removing the tire and inserting a new inner tube is not enough, you also need to diagnose the cause of the puncture to help avoid re-occurrences. Possible causes include a sharp object in the tire, a pinch flat, a valve problem, a rim tape problem, and poorly-adjusted brake pads rubbing away the tire’s sidewall. After removing one side of the tire, remove the tube but leave the valve in the rim and pump up the old tube to locate the hole and determine the cause.\n\n"
    + "If you find the hole and it appears to have been made by a sharp object then investigate the corresponding part of the tire to see if the object (glass, metal, thorn, etc.) is still there and use a pointy tool to prise it out, or push it out from the back. If the hole in the tire is large enough for a new tube to protrude through then you’ll need to install a tire boot between the tire and the tube (which could be a proper tire boot or could be some paper money or a food wrapper).\n\n"
    + "If the hole is a pair of parallel lines, also called a snake bike or pinch flat, then it was almost certainly caused by the tube getting pinched between the ground and the rim, probably due to the tire being under-inflated, so just install a new tube and make sure you pump it up to a sufficient pressure. \n\n"
    + "If the hole is on the rim side of the tube then check the rim tape in that area, which may need re-aligning to completely cover all spoke holes.\n\n"
    + "If the rim tape needs repairing/reinforcing then you can use any tape available as a temporary fix, but it may not hold up to high pressure for a long time.", 
    imagePath: "asset/img/repair_image/inner-tube.jpg",
    videoLink: "https://youtu.be/eqR6nlZNeU8"
  ),
  Repair(
    title: "Inner Tube Repair", 
    courtesy: "ridefar.info", 
    description: "After finding the hole in the tube, use sandpaper to clean off the area to make the glue work better. After applying a small amount of glue and spreading it around an area larger than the patch, wait a few minutes for the glue to mostly dry before pressing the patch down firmly. Glue that was opened more than about a month ago won’t work properly anymore, so bring a new, unopened tube.", 
    imagePath: "asset/img/repair_image/patch-bike-tube.jpg",
    videoLink: "https://youtu.be/T0F_hibWHlU"
  ),
  Repair(
    title: "Tubeless Tire Repair", 
    courtesy: "ridefar.info", 
    description: "If you are running tubeless tires and a small hole isn’t automatically sealed by the sealant then stop and move the hole to the bottom of the tire and put weight on it to slow the air flow and let the sealant work, or press on the hole with your thumb.\n\n"
    + "Slow leaks that develop in tubeless setups can be caused by leaky valves, so check that the valve core is well tightened. Hopefully you can then simply pump the tire back up to your preferred pressure, but if the tire has disconnected from the rim and you cannot get it to re-seal using only your pump, then you may be able to use an air compressor at a petrol/gas station if you bring a Presta-Schrader valve adapter or you could find a bike shop with a compressor.\n\n"
    + "When a hole in a tubeless tire cannot be fixed, an inner tube can be installed, using the same procedure as with a regular tire, but the tire may be more difficult to unmount and mount than with a standard tire and rim.", 
    imagePath: "asset/img/repair_image/tubeless-tire.jpg",
    videoLink: "https://youtu.be/0UB3b9dIRzY"
  ),
  Repair(
    title: "Chain Repair", 
    courtesy: "singletracks.com", 
    description: "The first step is to remove the broken link. This is where the chain tool is needed. The tool will have a recess shaped for laying the chain link in, holding the chain firmly while the screw plunger presses the pin out. This step can be performed with the chain still on the bike, or it can be pulled off and laid flat.\n\n"
    + "Remove the broken link such that you are left with the ‘inner’ link of the chain on both ends.\n\n"
    + "The chain is now ready for the Powerlink. Insert each half into one end of the chain, from opposite sides, so that the pins and plates will interlock.\n\n"
    + "All that’s left is to snap the power link together. Look closely at the two link plates and you will see a slightly oversized opening on each one. Push the pins through those slots and then yank the chain. Done!", 
    imagePath: "asset/img/repair_image/chain-repair.jpg",
    videoLink: "https://youtu.be/HpUCCrgugQE"
  ),
  Repair(
    title: "Rear Derailleur Hanger Replacement", 
    courtesy: "ridefar.info", 
    description: "Derailleur hangers are designed to bend relatively easily to protect the frame and the rear derailleur during a crash or if the bike simply falls over. Minor damage and slight misalignment might not be immediately apparent, but when you shift into the larger cogs on the cassette after a crash then the rear derailleur may move into the wheel’s spokes and cause serious damage to the derailleur, wheel, hanger, and possibly the frame.\n\n"
    + "You should therefore check the hanger and derailleur alignment after any bike fall and replace the hanger if it might be bent. Because each hanger is specific to a certain bike model (or small set of models), the correct one is normally difficult to obtain at short notice, so order one ahead of time and take it with you.", 
    imagePath: "asset/img/repair_image/rd-hanger.jpg",
    videoLink: "https://www.youtube.com/watch?v=TGQgcv3d0Ec"
  ),
  Repair(
    title: "Brake Pad Adjustment & Replacement", 
    courtesy: "ridefar.info", 
    description: "Rim brakes normally have an adjustment knob where the cable housing enters the brake which can be unscrewed to compensate for wear, but make sure that the pads still contact the rim at the correct height and replace the pads when the wear line is reached.\n\n"
    + "Cable-actuated disc brakes should have a pad adjustment screw on each side of the caliper; hydraulic disc brakes should automatically move the pistons in to adjust for pad wear.\n\n"
    + "It’s more difficult to see brake pad wear with disc brakes, but they should generally be changed when there is less than 1 mm of material left on the backing plate or if there is too much lever travel that cannot be corrected by bleeding a hydraulic brake. When changing disc brake pads, the pistons need to be moved back to their initial position, which is easy to do with cable-actuated discs, but can be tricky with hydraulic discs – try using a tire lever to separate the pistons fully before putting the new pads in.", 
    imagePath: "asset/img/repair_image/brake-pad.jpg",
    videoLink: "https://youtu.be/Xqw0SaZl-jo"
  ),
  Repair(
    title: "Nut & Bolt Tightening & Replacement", 
    courtesy: "ridefar.info", 
    description: "Carrying a few spares of common bolt sizes is a good idea, as well as a few bike-specific bolts that are difficult to obtain in regular stores. If a bolt is broken or lost and you don’t have a spare, then see if there is somewhere else on the bike that is less essential from which you can borrow a bolt temporarily. For instance, water bottle cage bolts are M5 and may work as a replacement seatpost-clamp bolt, stem bolt, etc. As a last resort, some bolts can be temporarily replaced with zip ties.", 
    imagePath: "asset/img/repair_image/nuts-bolts.jpg",
    videoLink: "https://youtu.be/iDhxJVn1wz4"
  ),
  Repair(
    title: "Headset Adjustment", 
    courtesy: "ridefar.info", 
    description: "If you choose to change the height of your handlebars at some point then you’ll need to re-adjust your headset, and you may also need to do so if you turn your stem to transport your bike.", 
    imagePath: "asset/img/repair_image/headset.jpg",
    videoLink: "https://youtu.be/lM4iddLaL8I"
  ),
];