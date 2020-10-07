import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:swipe_kuku/translation/translation_map.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(TranslationMap.of(context).infoTitle),
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
              Text(TranslationMap.of(context).infoPractice),
              Container(
                child: Text(
                  TranslationMap.of(context).infoPrivacyPolicy,
                  style: TextStyle(
                      color: Theme.of(context).primaryColorDark, fontSize: 24),
                ),
                margin: EdgeInsets.only(top: 16),
              ),
              RichText(
                  text: TextSpan(
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    decoration: TextDecoration.underline),
                text: TranslationMap.of(context).infoPrivacyPolicy,
                recognizer: TapGestureRecognizer()
                  ..onTap = () async {
                    final url =
                        'https://docs.google.com/document/d/1-niY6xsld0l29YJ_dF8_dcD-RoDES171XTlJ-45PPVU/edit?usp=sharing';
                    if (await canLaunch(url)) {
                      await launch(
                        url,
                        forceSafariVC: false,
                      );
                    }
                  },
              )),
            ],
          ),
          margin: EdgeInsets.all(16),
        ));
  }
}
