import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mood/main.dart';
import 'package:mood/model/model.dart';
import 'package:mood/mood_diary/mood_diary_card.dart';

class MoodDiaryList extends StatefulWidget {
  const MoodDiaryList({Key? key}) : super(key: key);

  @override
  State<MoodDiaryList> createState() => _MoodDiaryListState();
}

class _DiaryListData {
  final DateTime? dateTime;

  final MoodDiaryEntry? entry;

  _DiaryListData(this.dateTime, this.entry);
}

class _MoodDiaryListState extends State<MoodDiaryList> {
  final listData = <_DiaryListData>[];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    final entries = await MoodDiaryEntry().select().toList();

    final list = <_DiaryListData>[];
    list.add(_DiaryListData(entries.first.dateTime, null));
    var previousDate =
        DateTime(entries.first.dateTime!.year, entries.first.dateTime!.month, entries.first.dateTime!.day);
    for (MoodDiaryEntry entry in entries) {
      final currentDate = DateTime(entry.dateTime!.year, entry.dateTime!.month, entry.dateTime!.day);
      if (currentDate.difference(previousDate).inDays >= 1) {
        previousDate = currentDate;
        list.add(_DiaryListData(entry.dateTime, null));
      }
      list.add(_DiaryListData(null, entry));
    }
    setState(() {
      listData.addAll(list);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stimmungstagebuch'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: addItem,
          )
        ],
      ),
      drawer: const NavigationDrawer(),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: listData.length,
              reverse: true,
              itemBuilder: (context, index) {
                final entry = listData[listData.length - index - 1];
                if (entry.dateTime != null) {
                  return SizedBox(
                    width: 10,
                    child: Card(
                      margin: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(DateFormat('dd.MM.yyyy').format(entry.dateTime!),
                            style: Theme.of(context).textTheme.titleMedium),
                      ),
                    ),
                  );
                }
                return MoodDiaryCard(moodDiaryEntry: entry.entry!);
              },
            ),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  void addItem() async {
    MoodDiaryEntry? entry = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const MoodDiaryInput(),
        ));
    if(entry != null){
      DateTime lastDate = DateTime(listData.last.entry!.dateTime!.year, listData.last.entry!.dateTime!.month, listData.last.entry!.dateTime!.day);
      DateTime newDate = DateTime(entry.dateTime!.year, entry.dateTime!.month, entry.dateTime!.day);

      if(!lastDate.isAtSameMomentAs(newDate)) {
        listData.add(_DiaryListData(newDate, null));
      }
      listData.add(_DiaryListData(null, entry));
    }
  }
}

class MoodDiaryInput extends StatefulWidget {
  const MoodDiaryInput({Key? key, this.moodDiaryEntry}) : super(key: key);

  final MoodDiaryEntry? moodDiaryEntry;

  @override
  State<MoodDiaryInput> createState() => _MoodDiaryInputState();
}

class _MoodDiaryInputState extends State<MoodDiaryInput> {

  String _activity = '';
  String _mood = '';
  String _thoughts = '';

  final _activityInputController = TextEditingController();
  final _moodInputController = TextEditingController();
  final _thoughtsInputController = TextEditingController();

  final _activityFocusNode = FocusNode();
  final _moodFocusNode = FocusNode();
  final _thoughtsFocusNode = FocusNode();

  bool _ratingActive = true;
  int _rating = 1;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text(widget.moodDiaryEntry == null ? 'Neuer Eintrag' : 'Bearbeiten'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                      children: [
                        TextField(
                          controller: _activityInputController,
                          focusNode: _activityFocusNode,
                          decoration: const InputDecoration.collapsed(hintText: 'Was machst du gerade?'),
                          onSubmitted: _activitySubmitted,
                          maxLines: null,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top:10),
                          child: TextField(
                            controller: _moodInputController,
                            focusNode: _moodFocusNode,
                            decoration: const InputDecoration.collapsed(hintText: 'Wie geht es dir dabei?'),
                            onSubmitted: _moodSubmitted,
                            maxLines: null,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top:10),
                          child: TextField(
                            controller: _thoughtsInputController,
                            focusNode: _thoughtsFocusNode,
                            decoration: const InputDecoration.collapsed(hintText: 'Was geht dir durch den Kopf?'),
                            onSubmitted: _thoughtsSubmitted,
                            maxLines: null,
                          ),
                        ),

                      ],
                    ),
                ),
                Row(
                  children: [
                    Checkbox(
                      onChanged: _ratingActiveChanged, value: _ratingActive,
                    ),
                    Expanded(
                      child: Slider(
                        min: 1,
                        max: 10,
                        divisions: 10,
                        value: _rating.toDouble(),
                        onChanged: _ratingActive ? _ratingChanged : null,
                      ),
                    ),
                    Text('${_ratingActive ? _rating : '-'}/10')
                  ],
                ),
                ElevatedButton(
                  onPressed: _submit,
                  child: const Text('fertig'),
                ),
              ],
            ),
            ),
      )
    );
  }

  MoodDiaryEntry createMoodDiaryEntry() {
    return MoodDiaryEntry(dateTime: DateTime.now(), activity: _activity, mood: _mood, thoughts: _thoughts, rating: _ratingActive ? _rating : null);
  }

  void _submit() async {
    _activity = _activityInputController.text;
    _mood = _moodInputController.text;
    _thoughts = _thoughtsInputController.text;
    var entry = createMoodDiaryEntry();
    await entry.save();
    Navigator.pop(context, entry);
  }

  void _ratingChanged(double value) {
    setState(() {
      _rating = value.toInt();
    });
  }

  void _ratingActiveChanged(bool? value) {
    setState(() {
      _ratingActive = value!;
    });
  }

  void _activitySubmitted(String value) {
    setState(() {
      _activity = value;
    });
  }

  void _moodSubmitted(String value) {
    setState(() {
      _mood = value;
    });
  }

  void _thoughtsSubmitted(String value) {
    setState(() {
      _thoughts = value;
    });
  }
}
