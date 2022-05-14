import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mood/model/model.dart';
import 'package:mood/mood_calendar_view.dart';
import 'package:mood/mood_entry.dart';
import 'package:mood/mood_list.dart';
import 'package:mood/skills/selected_skills.dart';
import 'mood_diary/mood_diary_list.dart';
import 'navigation/navigation_header.dart';
import 'navigation/navigation_item.dart';
import 'package:path/path.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  initDB();
  // await MyDbModel().closeDatabase();
  // await File('/data/user/0/de.foospace.mood/databases/mood.db').delete(recursive: true);
  runApp(const MyApp());
}

void initDB() async {
  await MoodEntry().select().delete();
  await Skill().select().delete();
  await SelectedSkill().select().delete();
  await SkillUse().select().delete();
  await MoodDiaryEntry().select().delete();
  await MoodEntry(stresslevel: 70, activity: 'testen', dateTime: DateTime(2021, 12, 12, 12, 13)).save();
  await MoodEntry(stresslevel: 70, activity: 'testen', dateTime: DateTime(2021, 12, 12, 12, 13)).save();
  await MoodEntry(stresslevel: 70, activity: 'testen', dateTime: DateTime(2021, 12, 12, 12, 13)).save();
  await MoodEntry(stresslevel: 70, activity: 'testen', dateTime: DateTime(2021, 12, 12, 12, 13)).save();
  await MoodEntry(stresslevel: 70, activity: 'testen', dateTime: DateTime(2021, 12, 12, 12, 13)).save();
  await MoodEntry(stresslevel: 70, activity: 'testen', dateTime: DateTime(2021, 12, 12, 12, 13)).save();
  await MoodEntry(stresslevel: 70, activity: 'testen', dateTime: DateTime(2021, 12, 12, 12, 13)).save();
  await MoodEntry(stresslevel: 70, activity: 'testen', dateTime: DateTime(2021, 12, 12, 12, 13)).save();
  await MoodEntry(stresslevel: 70, activity: 'testen', dateTime: DateTime(2021, 12, 12, 12, 13)).save();
  await MoodEntry(stresslevel: 70, activity: 'testen', dateTime: DateTime(2021, 12, 12, 12, 13)).save();
  await MoodEntry(stresslevel: 70, activity: 'testen', dateTime: DateTime(2021, 12, 12, 12, 13)).save();
  await MoodEntry(stresslevel: 70, activity: 'testen', dateTime: DateTime(2021, 12, 12, 12, 13)).save();
  await MoodEntry(stresslevel: 70, activity: 'testen', dateTime: DateTime(2021, 12, 12, 12, 13)).save();
  await MoodEntry(stresslevel: 70, activity: 'testen', dateTime: DateTime(2021, 12, 12, 12, 13)).save();
  await MoodEntry(stresslevel: 70, activity: 'testen', dateTime: DateTime(2021, 12, 12, 12, 13)).save();
  await MoodEntry(stresslevel: 70, activity: 'testen', dateTime: DateTime(2021, 12, 12, 12, 13)).save();
  await MoodEntry(stresslevel: 70, activity: 'testen', dateTime: DateTime(2021, 12, 12, 12, 13)).save();
  await MoodEntry(stresslevel: 70, activity: 'testen', dateTime: DateTime(2021, 12, 12, 12, 13)).save();
  await MoodEntry(stresslevel: 70, activity: 'testen', dateTime: DateTime(2021, 12, 12, 12, 13)).save();
  await MoodEntry(stresslevel: 70, activity: 'testen', dateTime: DateTime(2021, 12, 12, 12, 13)).save();
  await MoodEntry(stresslevel: 70, activity: 'testen', dateTime: DateTime(2021, 12, 12, 12, 13)).save();
  await MoodEntry(stresslevel: 70, activity: 'testen', dateTime: DateTime(2021, 12, 12, 12, 13)).save();
  await MoodEntry(stresslevel: 70, activity: 'testen', dateTime: DateTime(2021, 12, 12, 12, 13)).save();
  await MoodEntry(stresslevel: 70, activity: 'testen', dateTime: DateTime(2021, 12, 12, 12, 13)).save();
  await MoodEntry(stresslevel: 70, activity: 'testen', dateTime: DateTime(2021, 12, 12, 12, 13)).save();
  await MoodEntry(stresslevel: 70, activity: 'testen', dateTime: DateTime(2021, 12, 12, 12, 13)).save();
  await MoodEntry(stresslevel: 70, activity: 'testen', dateTime: DateTime(2021, 12, 12, 14, 13)).save();
  await MoodEntry(stresslevel: 70, activity: 'testen', dateTime: DateTime(2021, 12, 12, 15, 13)).save();
  await MoodEntry(stresslevel: 70, activity: 'testen', dateTime: DateTime(2021, 12, 13, 12, 13)).save();
  await MoodEntry(stresslevel: 70, activity: 'testen', dateTime: DateTime(2021, 12, 14, 12, 13)).save();
  await MoodEntry(stresslevel: 70, activity: 'testen', dateTime: DateTime(2021, 12, 15, 12, 13)).save();
  await MoodEntry(stresslevel: 70, activity: 'testen', dateTime: DateTime(2021, 12, 16, 12, 13), mood: 7).save();
  await MoodEntry(stresslevel: 70, activity: 'testen', dateTime: DateTime(2021, 12, 16, 14, 13), mood: 8).save();
  var entry = MoodEntry(stresslevel: 70, activity: 'testen', dateTime: DateTime.now());
  await entry.save();
  print(entry.saveResult);
  var id = await Skill(name: 'Atemübung', description: 'Schließe deine Augen. Konzentriere dich auf eine ruhige und tiefe Bauchatmung. Wenn du soweit bist, versuche zu lokalisieren wo deine Anspannung ist. Bei jedem weiteren einatmen stelle dir vor wie diese Teile deines Körpers immer größer und größer werden und Platz für deine Anspannung entsteht').save();
  await Skill(name: 'Akkupressurball').save();
  await Skill(name: 'Duschen').save();
  await Skill(name: 'Akkupressurring').save();
  await Skill(name: 'Musik hören').save();
  await Skill(name: 'Tee trinken').save();
  await Skill(name: 'Sport machen').save();
  await Skill(name: 'Test1').save();
  await Skill(name: 'Test2').save();
  await Skill(name: 'Test3').save();
  await Skill(name: 'Test4').save();
  await Skill(name: 'Test5').save();
  await Skill(name: 'Test6').save();
  await Skill(name: 'Test7').save();
  await Skill(name: 'Test8').save();
  await Skill(name: 'Test9').save();
  await SelectedSkill(SkillId: id, stresslevel_min: 20, stresslevel_max: 70).save();

  MoodDiaryEntry foo = MoodDiaryEntry(rating: 7, mood: 'testtesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttest', activity: 'testtesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttest', thoughts: 'test', dateTime: DateTime.now());
  await foo.save();
  print(foo.saveResult);
  await MoodDiaryEntry(mood: 'testtesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttest', activity: 'testtesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttest', thoughts: 'test', dateTime: DateTime.now()).save();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.orange, brightness: Brightness.dark),
        checkboxTheme: CheckboxThemeData(
          fillColor: MaterialStateProperty.all(Colors.orange),
        ),
      ),
      home: const MyHomePage(title: 'Mood'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return getHomePage();
  }

  Widget getHomePage(){
    //TODO: return widget configured as home in preferences
    return MoodList();
  }
}

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: const <Widget>[
          NavHeader(),
          NavItem(title: 'Anspannungsprotokoll', icon: Icons.description, widget: MoodList()),
          NavItem(title: 'Stimmungstagebuch', icon: Icons.menu_book, widget: MoodDiaryList()),
          NavItem(
              title: 'Skills', icon: Icons.add_moderator, widget: SelectedSkillsView()),
          NavItem(
              title: 'Übersicht',
              icon: Icons.calendar_today_outlined,
              widget: MoodCalendar()),
        ],
      ),
    );
  }
}

