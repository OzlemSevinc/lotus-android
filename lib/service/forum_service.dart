import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lotus/entity/forum_entity.dart';


class ForumService {
  final String baseUrl;

  ForumService({required this.baseUrl});

  Future<List<Question>> fetchQuestions() async {
    final response = await http.get(Uri.parse('$baseUrl/forumQuestions/GetAllQuestions'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Question.fromJson(json)).toList();
    } else {
      throw Exception('Sorular yüklenemedi');
    }
  }
  Future<List<Question>> fetchAndFilterQuestions({
    int? categoryId,
    bool? sortByAlphabetical,
    bool? sortByAlphabeticalDescending,
    bool? sortByDate,
    bool? sortByDateAscending,
    int? pageNumber,
    int? pageSize,
  }) async {
    final queryParameters = {
      if (categoryId != null) 'ForumQuestionCategoryId': categoryId.toString(),
      if (sortByAlphabetical != null) 'SortByAlphabetical': sortByAlphabetical.toString(),
      if (sortByAlphabeticalDescending != null) 'SortByAlphabeticalDescending': sortByAlphabeticalDescending.toString(),
      if (sortByDate != null) 'SortByDate': sortByDate.toString(),
      if (sortByDateAscending != null) 'SortByDateAscending': sortByDateAscending.toString(),
      if (pageNumber != null) 'PageNumber': pageNumber.toString(),
      if (pageSize != null) 'PageSize': pageSize.toString(),
    };

    final uri = Uri.parse('$baseUrl/filter/ForumFilterAndGetAllForumQuestionsAndAnswers')
        .replace(queryParameters: queryParameters);

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Question.fromJson(json)).toList();
    } else {
      throw Exception('Sorular yüklenemedi');
    }
  }

  Future<List<Question>> searchQuestions(String questiontitle) async {
    final url = Uri.parse('$baseUrl/search/ForumSearch')
        .replace(queryParameters: {'questiontitle': questiontitle});

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Question.fromJson(json)).toList();
    } else {
      throw Exception('Sorular aranamadı');
    }
  }

  Future<List<ForumQuestionCategory>> fetchQuestionCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/forumQuestionCategories'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => ForumQuestionCategory.fromJson(json)).toList();
    } else {
      throw Exception('Kategoriler yüklenemedi');
    }
  }

  Future<Question> fetchQuestionById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/forumQuestions/GetOneQuestionByIdWithAnswers/$id'));
    if (response.statusCode == 200) {
      return Question.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Soru yüklenemedi');
    }
  }


  Future<void> addQuestion(Question question) async {
    final response = await http.post(
      Uri.parse('$baseUrl/forumQuestions'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userId': question.userId,
        'forumQuestionCategoryId': question.forumQuestionCategoryId,
        'question': question.question,
        'anonymous': question.anonymous,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Soru eklenemedi');
    }
  }

  Future<void> addAnswer(Answer answer) async {
    final response = await http.post(
      Uri.parse('$baseUrl/forumQuestionAnswers/answers'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'questionId': answer.questionId,
        'answerContent': answer.answerContent,
        'userType': answer.userType,
        'userId': answer.userId,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Cevap eklenemedi');
    }
  }
}
