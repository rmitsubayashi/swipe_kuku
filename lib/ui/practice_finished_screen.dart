import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:swipe_kuku/translation/translation_map.dart';
import 'package:swipe_kuku/ui/routes.dart';

class PracticeFinishedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(TranslationMap.of(context).practiceFinishedTitleText),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(child: Text(
                TranslationMap.of(context).practiceFinishedCongratulations,
                style: TextStyle(
                    fontSize: 36, color: Theme
                    .of(context)
                    .primaryColorDark),
              ), margin: EdgeInsets.only(bottom: 24),),
              RaisedButton(
                child: Text(
                  TranslationMap
                      .of(context)
                      .resultsToHome,
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
                color: Theme
                    .of(context)
                    .accentColor,
                onPressed: () {
                  // pop all screens before this
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(Routes.home, (route) => false);
                },
                padding: EdgeInsets.fromLTRB(48, 8, 48, 8),
              ),
            ],
          ),
        ));
  }
}
