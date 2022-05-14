import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mood/model/model.dart';
import 'package:mood/mood_entry.dart';
import 'package:intl/intl.dart';
import 'main.dart';

class ListData {
  final DateTime? dateTime;

  final MoodEntry? entry;

  ListData(this.dateTime, this.entry);
}

class MoodList extends StatefulWidget {
  const MoodList({Key? key}) : super(key: key);

  @override
  State<MoodList> createState() => _MoodListState();
}

class _MoodListState extends State<MoodList> {
  final _entries = <ListData>[];

  @override
  void initState() {
    super.initState();
    loadEntries();
  }

  loadEntries() async {
    var entries = await MoodEntry().select().toList();
    final list = <ListData>[];
    list.add(ListData(entries.first.dateTime, null));
    var previousDate =
        DateTime(entries.first.dateTime!.year, entries.first.dateTime!.month, entries.first.dateTime!.day);
    for (MoodEntry entry in entries) {
      final currentDate = DateTime(entry.dateTime!.year, entry.dateTime!.month, entry.dateTime!.day);
      if (currentDate.difference(previousDate).inDays >= 1) {
        previousDate = currentDate;
        list.add(ListData(entry.dateTime, null));
      }
      list.add(ListData(null, entry));
    }
    setState(() {
      _entries.addAll(list);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Anspannungsprotokoll'),
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
              reverse: true,
              itemCount: _entries.length,
              itemBuilder: (context, index) {
                final entry = _entries[_entries.length - index - 1];
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
                return MoodEntryCard(moodEntry: entry.entry!);
              },
            ),
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }

  void addItem() async {
    MoodEntry? result = await Navigator.push(context, MaterialPageRoute(builder: (context) => const MoodInput()));
    if (result != null) {
      setState(() {
        if (result.dateTime!.difference(_entries.last.entry!.dateTime!).inDays >= 1) {
          _entries.add(ListData(result.dateTime, null));
        }
        _entries.add(ListData(null, result));
      });
    }
  }
}

class MoodInput extends StatefulWidget {
  const MoodInput({Key? key, this.moodEntry}) : super(key: key);

  final MoodEntry? moodEntry;

  @override
  State<MoodInput> createState() => _MoodInputState();
}

class _MoodInputState extends State<MoodInput> {
  double _stressLevel = 0;
  String _activity = '';
  double _mood = 1;

  bool _inputMood = false;

  final _activityTextController = TextEditingController();
  final _activityFocusNode = FocusNode();
  Color _stressLevelIconColor = const Color.fromRGBO(0, 255, 0, 1);

  @override
  void initState() {
    if (widget.moodEntry != null) {
      _activityTextController.text = widget.moodEntry!.activity!;
      _stressLevel = widget.moodEntry!.stresslevel!.toDouble();
      _stressLevelIconColor = MoodEntryCard.calculateStressColor(widget.moodEntry!.stresslevel!);
      if (widget.moodEntry!.mood != null) {
        _inputMood = true;
        _mood = widget.moodEntry!.mood!.toDouble();
      }
    }
    super.initState();
  }

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
          title: Text(widget.moodEntry == null ? 'Neuer Eintrag' : 'Bearbeiten'),
        ),
        body: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text('Anspannung'),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: Slider(
                      value: _stressLevel,
                      max: 100,
                      divisions: 20,
                      label: _stressLevel.round().toString(),
                      onChanged: _stressLevelChanged,
                      onChangeStart: (v) => _unfocusTextfields(),
                    ),
                  ),
                  Icon(Icons.circle, color: _stressLevelIconColor),
                ],
              ),
              const Text('Stimmung'),
              createMoodRow(),
              const SizedBox(height: 10),
              const Text('Was machst du gerade?'),
              const SizedBox(height: 10),
              TextField(
                controller: _activityTextController,
                decoration: const InputDecoration.collapsed(
                  hintText: 'Schreib es hier rein',
                  border: UnderlineInputBorder(),
                ),
                onSubmitted: _handleActivityTextSubmitted,
                focusNode: _activityFocusNode,
              ),
              const Expanded(
                child: Center(child: Text('Danke!', textScaleFactor: 2)),
              ),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('fertig'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row createMoodRow() {
    return Row(
      children: [
        Checkbox(
          onChanged: (bool? value) {
            setState(() {
              _inputMood = value!;
            });
          },
          value: _inputMood,
        ),
        Expanded(
          child: Slider(
            value: _mood,
            max: 10,
            min: 1,
            label: _mood.round().toString(),
            onChanged: _inputMood ? _moodChanged : null,
            onChangeStart: (v) => _unfocusTextfields(),
          ),
        ),
        Text('${_mood.toInt()}/10'),
      ],
    );
  }

  MoodEntry _createMoodEntry() {
    return MoodEntry(
        id: widget.moodEntry != null ? widget.moodEntry!.id : null,
        stresslevel: _stressLevel.toInt(),
        activity: _activity,
        dateTime: DateTime.now(),
        mood: _inputMood ? _mood.toInt() : null);
  }

  void _submit() async {
    _unfocusTextfields();
    MoodEntry entry = _createMoodEntry();
    await entry.save();
    Navigator.pop(context, entry);
  }

  void _unfocusTextfields() {
    _activityFocusNode.unfocus();
    _handleActivityTextSubmitted(_activityTextController.text);
  }

  void _stressLevelChanged(double value) {
    setState(() {
      _stressLevel = value;
      _stressLevelIconColor = MoodEntryCard.calculateStressColor(_stressLevel.toInt());
    });
  }

  void _moodChanged(double value) {
    setState(() {
      _mood = value;
    });
  }

  void _handleActivityTextSubmitted(String text) {
    setState(() {
      _activity = text;
    });
  }
}
