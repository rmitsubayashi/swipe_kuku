# App a Week Challenge

This is a challenge I set for myself to create a fully functional app in 7 days.

I was inspired by a YouTube [video](https://www.youtube.com/watch?v=9O9Q8OVWrFA&t=1511s) that talked about having post-grad students develop a game a week. I googled some more and found out that this was a thing in the game dev community. However, I couldn't  find many people doing the same for mobile apps. Nevertheless, I figured if it works for games, it should work for apps as well. So, here I am.

These are some of the goals I want to achieve during the challenge(s)

- Do something new. It can be an architecture pattern, a technology on the phone like the camera or gyroscope, or a development process like TDD. Anything goes. This is a great benefit of doing small projects that I would like to take advantage of.
- Have a polished app that can be released. It doesn't have to have all the features in the world, but it should be relatively bug-free and usable by end users. I will publish all finished products on Google Play.
- Gain experience building apps from scratch.
- Time management as well as project management (cutting features, compromising quality, etc) so I can get the app finished and released.

The intended audience of this document is my current and future self, for my current self to reflect and for my future self to look back on.



## Challenge 2: Swipe Kuku

### Overview

For this challenge, I wanted to try out Flutter. Since this was only my second time making a Flutter app, I needed to keep the scope of the project small to be able to finish in a week. I came up with an idea for a math app where you answer by swiping cards left and right, like Tinder. I checked on Google Play to see whether an app like this had been made already, and luckily I didn't find any. Most of the existing apps had either multiple choice or fill in the blank, problem types you would expect on paper, not on a mobile platform.

So what is my pitch? Swiping is easier to do on a phone than punching in numbers or pressing a button. So, you can solve problems quicker and with less stress. I couldn't find any successful math apps using swipe as a reference, but there is an English word learning app which is #1 in the app store in Japan, which got popular with a swipe-based UI. The success of that app provides evidence that a swipe-based education app can become successful.

### Day 1

I plan on only having one core feature in the app. You answer questions by swiping left and right. Each question has a time limit, and if the time limit expires you get the question wrong. When you finish all questions, you can see your results.

Because of my lack of experience in Flutter, I estimated that this would take most of the week. If I had time however, I wanted to implement a practice mode where there is no time limit. Also the problems you miss would go to the bottom of the stack so you can try again and again until you get it right.

For the architecture, I decided to go with the BloC pattern. I had used this in my previous Flutter app and thought I would give it another go to have a better grasp for the architecture pattern.

I wanted to kick off development with the generating problems part, since it was isolated from the Flutter part of the app and would give me little problem. I looked into research regarding common multiplication mistakes, and I found this [paper](http://acs.ist.psu.edu/iccm2016/proceedings/buwalda2016iccm.pdf). I took the mistakes identified in the paper and put it in to code. I ended the day finishing the logic and getting started on the UI.

### Day 2 ~ 5

Days 1 through 5 were pretty much me struggling with Flutter. I finished all the screens. Some of the more difficult parts of implementation included

- implementing a BLoC for the timer
- adding a custom language for the Flutter translation API (Hiragana input, basically a kid's version of Japanese)
- using multiple BLoCs in a single screen
- width and height for Flutter widgets

### Day 6

Since I was able to finish the core part of the app, I decided to go ahead and implement practice mode. The logic will only need a small tweak from the test mode, and so too the UI. I figured it would take me a day max. It took me a while to figure out how to dynamically add problem cards to the bottom of the swipe deck, but I was able to complete the practice mode by the end of the day.

### Day 7

I added an info screen that explained the difference between practice and test mode. The rest of the day I spent preparing for release (screenshots, app icon, etc).



### Post Mortem

**Some all-over-the-place points I learned during the week**

- Some colors work better together than others. At the beginning of the project, I picked out a good looking color scheme for the app from a color scheme showcase site. When building the stats screen, I needed red, yellow, and green colors to display a heat map. I tried Google's material colors, but the heat map stood out like a sore thumb on the screen. To fix this, I went to a color scheme generator site and used the app color scheme as a base to generate the colors for the heat map. Amazingly, the colors looked like they belonged in the app.
- I was able to compare native Android to Flutter and see good and bad parts in both. For example, app bars are so much more intuitive in Flutter than Android. I want to carry some of the good parts of Flutter development into native Android in future projects.
- I take about three times longer building Flutter apps than native Android apps. I wasn't disappointed, though. This just goes to show how far I've progressed in my Android development journey.
- Flutter
- A non-designer's tip to designing: just try sh*t until it looks right. When designing the cards for the problems, the first version looked really awkward. I moved around some of the components. Still didn't look right. Then I moved around the components again. And again. And miraculously, the UI felt right.

**Some things I could not solve/need to improve on**

- I procrastinate when there's a task I don't want to do. A lot of the time, the task ends up taking a mere 30 minutes.
- I should prioritize business-critical tasks first. The app concept was spot on. It felt so good to swipe compared to pressing choices or entering digits. However, I was only able to discover this after Day 4 of development, after creating a settings screen, a result screen, and a home screen. If I would have developed and brushed up the swiping interface first, I would have discovered whether the app concept was on track then. If the concept was wrong, I could have stopped development then (I wouldn't have for the sake of the challenge) instead of having wasted several days building other parts of the app.
- Design. The problem screen looks good. But the stats and results screen leaves a lot to be desired.
- Having an established protocol for tests. I initially wrote tests for the question bloc since that was the first bloc I've written in a year, and I wanted confidence that it would work. Later in development, I had to make major revisions to the bloc. I didn't realize I even wrote tests for the bloc until way, way later. Of course they didn't pass, but since I knew the bloc worked fine I never got around to fixing the tests.

**Overall thoughts**

The app turned out better than I expected. It's simple and easy to use. I could honestly see myself twiddling with it if I'm really bored. Having a functional Flutter app under my belt feels good too.



(Some actual Readme)

### Instructions on adding translations

1. Add the string to be translated to lib/translation/translation_map.dart
2. Run generate_messages.sh in same folder
3. Go to lib/translation/generated/intl_messages.arb and find the newly generated strings
4. Copy them into intl_ja.arb and intl_ja_Hiragana.arb with the appropriate translations
5. Run compile_messages.sh

### Building the app on Android

You will need a key.properties file with the appropriate credentials (not on Github)