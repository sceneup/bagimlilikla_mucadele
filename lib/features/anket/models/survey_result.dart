class SurveyResult {
  final String? id;
  final String userId;
  final int attemptNo;

  final int question1;
  final int question2;
  final int question3;
  final int question4;
  final int question5;
  final int question6;
  final int question7;
  final int question8;
  final int question9;
  final int question10;
  final int question11;
  final int question12;
  final int question13;
  final int question14;
  final int question15;
  final int question16;
  final int question17;

  final int totalScore;
  final DateTime takenAt;
  final DateTime nextSurveyAt;

  const SurveyResult({
    this.id,
    required this.userId,
    required this.attemptNo,
    required this.question1,
    required this.question2,
    required this.question3,
    required this.question4,
    required this.question5,
    required this.question6,
    required this.question7,
    required this.question8,
    required this.question9,
    required this.question10,
    required this.question11,
    required this.question12,
    required this.question13,
    required this.question14,
    required this.question15,
    required this.question16,
    required this.question17,
    required this.totalScore,
    required this.takenAt,
    required this.nextSurveyAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'attempt_no': attemptNo,

      'question_1': question1,
      'question_2': question2,
      'question_3': question3,
      'question_4': question4,
      'question_5': question5,
      'question_6': question6,
      'question_7': question7,
      'question_8': question8,
      'question_9': question9,
      'question_10': question10,
      'question_11': question11,
      'question_12': question12,
      'question_13': question13,
      'question_14': question14,
      'question_15': question15,
      'question_16': question16,
      'question_17': question17,

      'total_score': totalScore,
      'taken_at': takenAt.toIso8601String(),
      'next_survey_at': nextSurveyAt.toIso8601String(),
    };
  }

  factory SurveyResult.fromMap(
      Map<String, dynamic> map,
      ) {
    return SurveyResult(
      id: map['id'] as String?,
      userId: map['user_id'] as String,
      attemptNo: map['attempt_no'] as int,

      question1: map['question_1'] as int,
      question2: map['question_2'] as int,
      question3: map['question_3'] as int,
      question4: map['question_4'] as int,
      question5: map['question_5'] as int,
      question6: map['question_6'] as int,
      question7: map['question_7'] as int,
      question8: map['question_8'] as int,
      question9: map['question_9'] as int,
      question10: map['question_10'] as int,
      question11: map['question_11'] as int,
      question12: map['question_12'] as int,
      question13: map['question_13'] as int,
      question14: map['question_14'] as int,
      question15: map['question_15'] as int,
      question16: map['question_16'] as int,
      question17: map['question_17'] as int,

      totalScore: map['total_score'] as int,

      takenAt: DateTime.parse(
        map['taken_at'] as String,
      ),

      nextSurveyAt: DateTime.parse(
        map['next_survey_at'] as String,
      ),
    );
  }
}