class RecurrenceType {
  final int id;
  final String type;

  RecurrenceType({required this.id, required this.type});

  factory RecurrenceType.fromJson(Map<String, dynamic> json) {
    return RecurrenceType(
      id: json['id'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
    };
  }
}
