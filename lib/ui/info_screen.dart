import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:swipe_kuku/translation/translation_map.dart';

class InfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("インフォメーション"),
        ),
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                TranslationMap.of(context).homeTestText,
                style: TextStyle(
                    color: Theme.of(context).primaryColorDark, fontSize: 24),
              ),
              Text(TranslationMap.of(context).infoTest),
              Container(
                child: Text(
                  TranslationMap.of(context).practiceTitleText,
                  style: TextStyle(
                      color: Theme.of(context).primaryColorDark, fontSize: 24),
                ),
                margin: EdgeInsets.only(top: 16),
              ),
              Text(TranslationMap.of(context).infoPractice)
            ],
          ),
          margin: EdgeInsets.all(16),
        ));
  }
}
