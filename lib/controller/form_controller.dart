import 'dart:convert' as convert;
import 'package:flutterfeedbackapp/model/form.dart';
import 'package:http/http.dart' as http;

class FormController {

  //Google App Script Web URL
  static const String URL = "https://script.google.com/macros/s/AKfycbz9F4zVfE265lbXDOdQrK8alT0sJoOZ3UJ0VDuD3Mnd7oT-5N-G/exec";

  //Success Status message
  static const STATUS_SUCCESS = "SUCCESS";

  /// Async function which saves feedback, parses [feedbackForm] parameters
  /// and sends HTTP GET request on [URL]. On successful response, [callback] is called.
  void submitForm(FeedbackForm feedbackForm,
      void Function(String) callback) async {
    try {
      await http.post(URL, body: feedbackForm.toJson()).then((response) async {
        if (response.statusCode ==
            302) { // status code 302 means that the requested resource has been temporarily moved to different URI
          var url = response.headers['location'];
          await http.get(url).then((response) {
            callback(convert.jsonDecode(response.body)['status']);
          });
        } else {
          callback(convert.jsonDecode(response.body)['status']);
        }
      });
    } catch (e) {
      print(e);
    }
  }

  Future<List<FeedbackForm>> getFeedbackList() async {
    return await http.get(URL).then((response) {
      var jsonFeedback = convert.jsonDecode(response.body) as List;
      return jsonFeedback.map((json) => FeedbackForm.fromJson(json)).toList();
    });
  }
}

