import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutterfeedbackapp/controller/form_controller.dart';
import 'package:flutterfeedbackapp/feedback_list.dart';
import 'package:flutterfeedbackapp/model/form.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Google Sheet',
      home: MyHomePage(title: 'Flutter Google Sheet'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String namePattern = r"^[A-Za-z\s]{1,}[\.]{0,1}[A-Za-z\s]{0,}$";
  String emailPattern = r"^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$";
  String mobileNoPattern = r"^[6-9]\d{9}$";

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _mobileNoController = TextEditingController();
  TextEditingController _feedbackController = TextEditingController();

  //method to submit feedback and save in google sheets
  void _submitForm(){
    FocusScope.of(context).unfocus();
    if(_formKey.currentState.validate()){
      FeedbackForm feedbackForm = FeedbackForm(
        _nameController.text,
        _emailController.text,
        _mobileNoController.text,
        _feedbackController.text
      );

      FormController formController = FormController();
      _showSnackbar("submitting feedback");

      formController.submitForm(feedbackForm, (String response) {
        print("Response $response");
        if(response == FormController.STATUS_SUCCESS){
          _showSnackbar("Feedback Submitted");
        }else{
          _showSnackbar("Error Occured");
        }
      });
    }
  }

  _showSnackbar(String message){
    final snackBar = SnackBar(content: Text(message));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  String _validateRegex(String type,String value,String pattern){
    RegExp regExp = RegExp(pattern);
    if(value.length == 0){
      return 'Please enter a $type';
    }else if(!regExp.hasMatch(value)){
      return 'Please enter a  valid $type';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      key: _scaffoldKey,
      resizeToAvoidBottomPadding: false,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(33, 212, 253, 1),
              Color.fromRGBO(183, 33, 255, 1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Feedback Form', textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Satisfy', fontSize: 50, fontWeight: FontWeight.bold, color: Colors.white),),
                SizedBox(height: 10,),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 5,
                  child: Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          TextFormField(
                            keyboardType: TextInputType.text,
                            controller: _nameController,
                            validator:(value) => _validateRegex("name",value, namePattern),
                            decoration: InputDecoration(
                              labelText: 'Name',
                            ),
                          ),
                          SizedBox(height: 10,),
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            controller: _emailController,
                            validator: (value) => _validateRegex("email",value, emailPattern),
                            decoration: InputDecoration(
                              labelText: 'Email Address',
                            ),
                          ),
                          SizedBox(height: 10,),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            controller: _mobileNoController,
                            validator: (value) => _validateRegex("Mobile Number", value, mobileNoPattern),
                            decoration: InputDecoration(
                              labelText: 'Mobile Number',
                            ),
                          ),
                          SizedBox(height: 10,),
                          TextFormField(
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            controller: _feedbackController,
                            validator: (value){
                              if(value.isEmpty){
                                return 'Enter valid feedback';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'Feedback',
                            ),
                          ),
                          SizedBox(height: 10,),
                          Center(
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(color: Color.fromRGBO(252, 0, 255, 1)),
                              ),
                              color: Color.fromRGBO(252, 0, 255, 1),
                              textColor: Colors.white,
                              onPressed: _submitForm,
                              child: Text('Submit Feedback'),
                            ),
                          ),
                          SizedBox(height: 10,),
                          Center(
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(color: Color.fromRGBO(43, 134, 197, 1)),
                              ),
                              color: Color.fromRGBO(43, 134, 197, 1),
                              textColor: Colors.white,
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FeedbackListScreen(),
                                    ));
                              },
                              child: Text('View Feedback'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

  }
}
