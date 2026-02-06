enum RuleType {
  standard,
  persistent, // Snake eyes, Question master
  input, // User enters text (8, 9)
  gameEnd, // 4th King
}

class RuleDefinition {
  final String title;
  final String description;
  final RuleType type;
  final String? translationKey;

  const RuleDefinition({
    required this.title,
    required this.description,
    this.type = RuleType.standard,
    this.translationKey,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'type': type.index,
    'translationKey': translationKey,
  };

  factory RuleDefinition.fromJson(Map<String, dynamic> json) {
    return RuleDefinition(
      title: json['title'],
      description: json['description'],
      type: RuleType.values[json['type'] ?? 0],
      translationKey: json['translationKey'],
    );
  }
}

const Map<int, RuleDefinition> defaultRulesMap = {
  1: RuleDefinition(title: "Categorie", description: "Kies een categorie. Noem om de beurt iets op.", translationKey: "rule_1"),
  2: RuleDefinition(title: "Uitdelen", description: "Je mag 2 slokken uitdelen. Mag verdeeld worden.", translationKey: "rule_2"),
  3: RuleDefinition(title: "Shotje", description: "Neem zelf een shotje!", translationKey: "rule_3"),
  4: RuleDefinition(title: "Vikingen", description: "Vikingen! Roeien en brullen. Laatste moet drinken.", translationKey: "rule_4"),
  5: RuleDefinition(title: "Duimen", description: "Duimen op tafel! Laatste moet drinken.", translationKey: "rule_5"),
  6: RuleDefinition(title: "Snakeeyes", description: "Je mag niemand meer in de ogen kijken. Wie dat wel doet moet drinken.", type: RuleType.persistent, translationKey: "rule_6"),
  7: RuleDefinition(title: "Juffen", description: "Juffen! Tellen, en bij elk getal met 7 of veelvoud klappen/zeg 'Juf'.", translationKey: "rule_7"),
  8: RuleDefinition(title: "Algemene regel", description: "Verzin een algemene regel voor de hele groep.", type: RuleType.input, translationKey: "rule_8"),
  9: RuleDefinition(title: "Drinkregel", description: "Verzin een regel die te maken heeft met drinken.", type: RuleType.input, translationKey: "rule_9"),
  10: RuleDefinition(title: "Drinking Buddy", description: "Kies een buddy. Als jij drinkt, drinkt hij/zij ook (en andersom).", translationKey: "rule_10"),
  11: RuleDefinition(title: "Wijzen", description: "Aftellen 3-2-1 Wijzen! Degene naar wie de meesten wijzen moet drinken.", translationKey: "rule_11"),
  12: RuleDefinition(title: "Question Master", description: "Jij bent de Question Master. Wie antwoordt op jouw vraag moet drinken.", type: RuleType.persistent, translationKey: "rule_12"),
  13: RuleDefinition(title: "Koningsat", description: "Giet wat in de King's Cup. De 4e Koning drinkt hem leeg!", type: RuleType.gameEnd, translationKey: "rule_13"),
};
