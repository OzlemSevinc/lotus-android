class Question {
  final int id;
  final String userId;
  final int userType;
  final int forumQuestionCategoryId;
  final String question;
  final String creationDate;
  final int anonymous;
  final List<Answer> answers;

  Question({
    required this.id,
    required this.userId,
    required this.userType,
    required this.forumQuestionCategoryId,
    required this.question,
    required this.creationDate,
    required this.anonymous,
    required this.answers,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['questionId'] ?? 0,
      userId: json['userId'] ?? '',
      userType: json['userType'] ?? 0,
      forumQuestionCategoryId: json['forumQuestionCategoryId'] ?? 0,
      question: json['question'] ?? '',
      creationDate: json['creationDate'] ?? '',
      anonymous: json['anonymous'] ?? 0 ,
      answers: json['answers'] != null
          ? List<Answer>.from(json['answers'].map((x) => Answer.fromJson(x)))
          : [],
    );
  }
}

class Answer {
  final int id;
  final int questionId;
  final String userId;
  final String answerContent;
  final int userType;

  Answer({
    required this.id,
    required this.questionId,
    required this.userId,
    required this.answerContent,
    required this.userType,
  });

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      id: json['answerId'],
      questionId: json['questionId'],
      userId: json['userId'],
      answerContent: json['answerContent'],
      userType: json['userType'],
    );
  }
}

class ForumQuestionCategory {
  final int id;
  final String name;

  ForumQuestionCategory({required this.id, required this.name});

  factory ForumQuestionCategory.fromJson(Map<String, dynamic> json) {
    return ForumQuestionCategory(
      id: json['forumQuestionCategoryId'],
      name: json['forumQuestionCategoryName'],
    );
  }
}