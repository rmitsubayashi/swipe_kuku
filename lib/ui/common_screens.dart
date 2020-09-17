import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:swipe_kuku/translation/translation_map.dart';

class CommonScreens {
  static Widget loading(String appBarText, BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(appBarText)),
        body: Center(
            child: Column(children: [
          Text(TranslationMap.of(context).loadingText),
          CircularProgressIndicator(),
        ])));
  }

  static Widget error(String appBarText, BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(appBarText)),
      body: Center(child: Text(TranslationMap.of(context).errorText)),
    );
  }
}
