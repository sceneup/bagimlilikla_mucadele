class BeklemeDegerlendirme {
  final String? id;
  final String waitlistId;
  final String userId;
  final String evaluationType; // 'initial' veya '24h'
  final int urgeScore; // 1 - 5
  final String? purchaseReason;
  final String? thought;
  final DateTime? createdAt;

  BeklemeDegerlendirme({
    this.id,
    required this.waitlistId,
    required this.userId,
    required this.evaluationType,
    required this.urgeScore,
    this.purchaseReason,
    this.thought,
    this.createdAt,
  });

  Map<String, dynamic> toSupabaseMap() {
    final map = <String, dynamic>{
      'waitlist_id': waitlistId,
      'user_id': userId,
      'evaluation_type': evaluationType,
      'urge_score': urgeScore,
      'purchase_reason': purchaseReason,
      'thought': thought,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  factory BeklemeDegerlendirme.fromSupabase(Map<String, dynamic> json) {
    return BeklemeDegerlendirme(
      id: json['id']?.toString(),
      waitlistId: json['waitlist_id'].toString(),
      userId: json['user_id'].toString(),
      evaluationType: json['evaluation_type']?.toString() ?? '24h',
      urgeScore: (json['urge_score'] as num?)?.toInt() ?? 5,
      purchaseReason: json['purchase_reason']?.toString(),
      thought: json['thought']?.toString(),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'].toString()).toLocal()
          : null,
    );
  }
}
