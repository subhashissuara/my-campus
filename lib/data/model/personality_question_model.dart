import 'package:cloud_firestore/cloud_firestore.dart';

class PersonalityQuestionModel {
  final String id;
  final String questionLeft;
  final String questionRight;
  int? scaleAnswers;

  PersonalityQuestionModel({
    required this.id,
    required this.questionLeft,
    required this.questionRight,
    this.scaleAnswers,
  });

  factory PersonalityQuestionModel.fromDocument(DocumentSnapshot doc) {
    return PersonalityQuestionModel(
      id: doc.id,
      questionLeft: doc['questionLeft'],
      questionRight: doc['questionRight'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'questionLeft': questionLeft,
      'questionRight': questionRight,
      'scaleAnswers': scaleAnswers,
    };
  }
}
