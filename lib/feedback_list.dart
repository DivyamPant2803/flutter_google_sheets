import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutterfeedbackapp/controller/form_controller.dart';
import 'package:flutterfeedbackapp/model/form.dart';

class FeedbackListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Feedback Responses',
      home: FeedbackListPage(title: 'Responses'),
    );
  }
}

class FeedbackListPage extends StatefulWidget {
  FeedbackListPage({Key key, this.title}) : super(key:key);
  final String title;
  @override
  _FeedbackListPageState createState() => _FeedbackListPageState();
}

class _FeedbackListPageState extends State<FeedbackListPage> {
  List<FeedbackForm> feedbackItems = List<FeedbackForm>();
  bool _items = false;

  //Method to submit feedback and save to google sheets
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _items = false;
    });
    FormController().getFeedbackList().then((feedbackItems){
      setState(() {
        _items = true;
        this.feedbackItems = feedbackItems;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,

      body: _items ? Container(
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 8, top: 30, right: 8, bottom: 8),
              child: Text('Responses', style: TextStyle(fontFamily: 'Satisfy', fontSize: 40, color: Colors.white),),
            ),
            Expanded(
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: feedbackItems.length,
                  itemBuilder: (context, index){
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Row(
                              children: <Widget>[
                                Icon(Icons.person, color: Colors.blue,),
                                SizedBox(width: 5,),
                                Expanded(
                                  child: Text("${feedbackItems[index].name} (${feedbackItems[index].email})"),
                                ),
                              ],
                            ),
                            subtitle: Row(
                              children: <Widget>[
                                Icon(Icons.message, color: Colors.orange,),
                                SizedBox(width: 5,),
                                Expanded(
                                  child: Text(feedbackItems[index].feedback),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ) : Container(
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
            child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),),)),
    );
  }
}

