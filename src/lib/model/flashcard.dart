class FlashCard{
  final Map<String, dynamic> themes;
  final List<dynamic> text1;
  final List<dynamic> text2;
  final List<dynamic> text3;
  final List<dynamic> text4;
  final List<dynamic> text5;
  final List<dynamic> text6;
  final String uc;
  bool read;

  FlashCard({required this.themes,required this.text1,required this.text2,required this.text3,required this.text4,required this.text5,required this.text6,required this.uc, required this.read});

  toJson() {
    return {
      "Uc": uc,
      "Text1": text1,
      "Text2": text2,
      "Text3": text3,
      "Text4": text4,
      "Text5": text5,
      "Text6": text6,
      "Theme": themes,
      "Read" : read,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      "Uc": uc,
      "Text1": text1,
      "Text2": text2,
      "Text3": text3,
      "Text4": text4,
      "Text5": text5,
      "Text6": text6,
      "Theme": themes,
      "Read" : read,
    };
  }

  factory FlashCard.fromMap(Map<String, dynamic> map) {
    return FlashCard(
      themes: Map<String, dynamic>.from(map['Theme'] ?? {}),
      text1: List<dynamic>.from(map['Text1'] ?? []),
      text2: List<dynamic>.from(map['Text2'] ?? []),
      text3: List<dynamic>.from(map['Text3'] ?? []),
      text4: List<dynamic>.from(map['Text4'] ?? []),
      text5: List<dynamic>.from(map['Text5'] ?? []),
      text6: List<dynamic>.from(map['Text6'] ?? []),
      uc: map['Uc'] ?? '',
      read: map['Read'] ?? false,
    );
  }
}