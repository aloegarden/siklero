class FirstAid {
  final String title;
  final String courtesy;
  final String description;
  final String imagePath;

  FirstAid({
    required this.title,
    required this.courtesy,
    required this.description,
    required this.imagePath
  });
}

final List<FirstAid> firstaids = [
  FirstAid(
    title: "Cuts and grazing", 
    courtesy: "totalwomenscycling.com", 
    description: "If a small cut is dirty, clean it by either rinsing with cold water or using alcohol free wipes and use a gauze swab to pat the wound dry. Then cover it with sterile gauze\n\n"
    + "With soapy water, clean the area around the injury.\n\n"
    + "Try and wipe away from the wound and use a clean swab with each swipe\n\n"
    + "Remove the wound covering and apply a sterile dressing or plaster\n\n"
    + "Seek medical advice if you are worried or if you think that there might be a risk of infection\n\n"
    + "If the wound is large or bleeding heavily, apply direct pressure to the wound to stem the bleeding and raise the injured area above heart level\n\n"
    + "Apply a sterile dressing to maintain pressure on the wound and lie the injured person down with their legs raised to offset shock\n\n"
    + "Call for an ambulance", 
    imagePath: "asset/img/first-aid_image/cuts-graze.jpg"
  ),
  FirstAid(
    title: "Dislocation", 
    courtesy: "totalwomenscycling.com", 
    description: "If the injured person has a dislocated shoulder, try to keep them still, while supporting their arm in a comfortable position.\n\n"
    + "You can immobilise the injured arm with a sling if they will let you. For extra support, secure the arm to the chest by tying a broad fold bandage right around the chest and the sling.\n\n"
    + "Arrange for the injured person to be taken to hospital and treat for shock if necessary, laying them down and raising their legs.", 
    imagePath: "asset/img/first-aid_image/dislocation.jpg"
  ),
  FirstAid(
    title: "Bruising", 
    courtesy: "totalwomenscycling.com", 
    description: "Raise and support the affected area into a comfortable position\n"
    + "Using a cold compress, such as an icepack wrapped in a cloth, apply firm pressure to the bruise for up to ten minutes.", 
    imagePath: "asset/img/first-aid_image/bruises.jpg"
  ),
  FirstAid(
    title: "Strains/sprains", 
    courtesy: "totalwomenscycling.com", 
    description: "Help the injured person to sit or lie down comfortably, with some padding underneath their injury to support it.\n\n"
    + "Cool the area with a cold compress/ice pack to help reduce the swelling and pain\n"
    + "Apply comfortable support to the injury, by placing a layer of padding over the cold compress and securing it in place with a bandage\n\n"
    + "Support the injured part in a raised position if possible\n\n"
    + "If the pain is severe or they are unable to move he injured part, arrange to get them to hospital", 
    imagePath: "asset/img/first-aid_image/strain-sprain.jpg"
  ),
  FirstAid(
    title: "Fractures", 
    courtesy: "totalwomenscycling.com", 
    description: "Advise the injured person to keep still, while supporting the joints above and below the injury with your hands until it is immobilised.\n\n"
    + "For arm injuries, you can secure the injured arm with a sling. For leg injuries, secure the uninjured leg to the injured one with bandages. You can also place padding around the injury for extra support.\n\n"
    + "Arrange for the injured person to be taken to hospital – an arm injury can be transported by car, but when dealing with leg injuries call for emergency help.", 
    imagePath: "asset/img/first-aid_image/fracture.jpg"
  ),
  FirstAid(
    title: "Concussion", 
    courtesy: "totalwomenscycling.com", 
    description: "Head injuries can be potentially serious and should be treated with care.\n\n"
    + "If someone has experienced a head injury, and they are fully conscious, help them to sit down in a comfortable position.\n\n"
    + "Give them a cold compress to hold against the injured part of their head and monitor their condition.\n\n"
    + "If the injured person becomes drowsy, confused or complains of a worsening headache, vomiting or double vision, call for emergency help\n\n"
    + "Anyone who has lost consciousness, even for a short period of time should be seen by a doctor.", 
    imagePath: "asset/img/first-aid_image/concussion.jpg"
  ),
  FirstAid(
    title: "Dehydration", 
    courtesy: "totalwomenscycling.com", 
    description: "If someone you know becomes dehydrated, help them to sit down comfortably.\n\n"
    + "Give them plenty of water to drink. You can also give them oral rehydration solutions if you have them.\n\n"
    + "Advise the person to rest and, if they are suffering from cramp, stretch and massage the affected muscles\n\n"
    + "If they remain unwell, seek medical advice.",
    imagePath: "asset/img/first-aid_image/dehydration.jpg"
  ),
];