import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swipe_kuku/bloc/practice/practice_bloc.dart';
import 'package:swipe_kuku/bloc/practice/practice_event.dart';
import 'package:swipe_kuku/bloc/questions/questions_bloc.dart';
import 'package:swipe_kuku/bloc/questions/questions_event.dart';
import 'package:swipe_kuku/translation/translation_map.dart';
import 'package:swipe_kuku/ui/routes.dart';

class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(TranslationMap.of(context).homeTitleText),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              child: RaisedButton(
                child: Text(
                  TranslationMap.of(context).homeTestText,
                  style: TextStyle(fontSize: 48),
                ),
                onPressed: () {
                  // maybe should this be done in the question screen?
                  // but looked too complicated to do it there
                  final questionsBloc = BlocProvider.of<QuestionsBloc>(context);
                  questionsBloc.add(GetQuestions());
                  Navigator.of(context).pushNamed(Routes.questions);
                },
                color: Theme.of(context).accentColor,
                textColor: Colors.white,
                padding: EdgeInsets.fromLTRB(48, 0, 48, 0),
              ),
              margin: EdgeInsets.only(bottom: 48),
            ),
            Container(
              child: FlatButton(
                child: Text(
                  TranslationMap.of(context).practiceTitleText,
                  style: TextStyle(fontSize: 24),
                ),
                onPressed: () {
                  final practiceBloc = BlocProvider.of<PracticeBloc>(context);
                  practiceBloc.add(GetPracticeQuestions());
                  Navigator.of(context).pushNamed(Routes.practice);
                },
                textColor: Theme.of(context).accentColor,
              ),
            ),
            FlatButton(
              child: Text(
                TranslationMap.of(context).settingTitleText,
                style: TextStyle(fontSize: 24),
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(Routes.settings);
              },
              textColor: Theme.of(context).accentColor,
            ),
            FlatButton(
              child: Text(
                TranslationMap.of(context).statsTitleText,
                style: TextStyle(fontSize: 24),
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(Routes.stats);
              },
              textColor: Theme.of(context).accentColor,
            )
          ],
        )
      )
    );
  }
}