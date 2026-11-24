class Quiz {
  final String uc;
  final int level;
  final List<Question> questions;
  int grade;

  Quiz({required this.uc, required this.questions, required this.level, required this.grade});

  toJson() {
    return {
      "Uc": uc,
      "Level" : level,
      "Questions": questions.map((question) => question.toJson()).toList(),
      "Grade": grade,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      "Uc": uc,
      "Level" : level,
      "Questions": questions.map((question) => question.toMap()).toList(),
      "Grade": grade,
    };
  }

  factory Quiz.fromMap(Map<String, dynamic> map) {
    List<dynamic> questionsData = map['Questions'] ?? [];
    List<Question> questions = questionsData.map((q) => Question.fromMap(q)).toList();

    return Quiz(
      uc: map['Uc'] ?? '',
      level: map['Level'] ?? 0,
      questions: questions,
      grade: map['Grade'] ?? 0,
    );
  }
}

class Question {
  final String uc;
  final int level;
  final String questionText;
  final List<dynamic> choices;
  final int correctAnswerIndex;

  Question({
    required this.questionText,
    required this.choices,
    required this.correctAnswerIndex,
    required this.uc,
    required this.level,
  });

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      uc: map['uc'] ?? '',
      level: map['level'] ?? 0,
      questionText: map['questionText'] ?? '',
      choices: map['choices'] ?? [],
      correctAnswerIndex: map['correctAnswerIndex'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uc' : uc,
      'level' : level,
      'questionText': questionText,
      'choices': choices,
      'correctAnswerIndex': correctAnswerIndex,
    };
  }

  toJson() {
    return {
      'uc' : uc,
      'level' : level,
      'questionText': questionText,
      'choices': choices,
      'correctAnswerIndex': correctAnswerIndex,
    };
  }
}