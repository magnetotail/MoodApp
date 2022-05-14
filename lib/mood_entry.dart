import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mood/model/model.dart';

import 'mood_list.dart';

//Could not find a way yet to update the card in the list when edited without bloating things up so making it stateful for now

class MoodEntryCard extends StatefulWidget {
  MoodEntry _moodEntry;

  MoodEntryCard({Key? key, required MoodEntry moodEntry})
      : _moodEntry = moodEntry,
        super(key: key);

  @override
  State<MoodEntryCard> createState() => _MoodEntryCardState();

  static Color calculateStressColor(int value) {
    return HSVColor.fromAHSV(1, 100 - value.toDouble(), 1, 1).toColor();
  }
}

class _MoodEntryCardState extends State<MoodEntryCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: MoodEntryCard.calculateStressColor(widget._moodEntry.stresslevel!)),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
            // leading: Icon(Icons.circle,
            //     color: MoodEntryDto.calculateStressColor(_moodEntry.stresslevel)),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(DateFormat('HH:mm').format(widget._moodEntry.dateTime!),
                      style: Theme.of(context).textTheme.titleMedium),
                  SizedBox(
                    height: 20,
                    width: 30,
                    child: PopupMenuButton(
                      padding: EdgeInsets.zero,
                      itemBuilder: createPopupMenuButtons,
                      onSelected: (value) => popupMenuPressed(value, context),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (widget._moodEntry.mood != null)
                    Text('Stimmung: ${widget._moodEntry.mood}/10', style: Theme.of(context).textTheme.titleMedium),
                  Expanded(
                      child: Text(
                    'Anspannung: ${widget._moodEntry.stresslevel} %',
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.right,
                  )),
                ],
              ),
              if (widget._moodEntry.activity != null && widget._moodEntry.activity!.isNotEmpty) createActivityRow(),
            ]),
      ),
    );
  }

  List<PopupMenuEntry<dynamic>> createPopupMenuButtons(BuildContext context) {
    final entries = <PopupMenuEntry<dynamic>>[];
    entries.add(const PopupMenuItem<String>(child: Text('bearbeiten'), value: 'bearbeiten'));
    return entries;
  }

  void popupMenuPressed(value, BuildContext context) {
    print('$value pressed');
    switch (value) {
      case 'bearbeiten':
        edit(context);
        break;
    }
  }

  void edit(BuildContext context) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => MoodInput(moodEntry: widget._moodEntry)))
        .then((value) {

      setState(() {
        //need to update this way, otherwise the listBuilder would not apply the changes when rebuilding the widget when scrolling far away
        widget._moodEntry.mood = value.mood;
        widget._moodEntry.stresslevel = value.stresslevel;
        widget._moodEntry.activity = value.activity;
        widget._moodEntry.dateTime = value.dateTime;
      });
    });
  }

  Widget createActivityRow() {
    Widget widget;
    if (this.widget._moodEntry.activity != null && this.widget._moodEntry.activity!.isNotEmpty) {
      widget = Column(
        children: [
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Was hast du gemacht?"),
              const SizedBox(width: 30),
              Expanded(
                child: Text(this.widget._moodEntry.activity!, textAlign: TextAlign.right),
              ),
            ],
          ),
        ],
      );
    } else {
      widget = Container(
        height: 0,
      );
    }
    return widget;
  }
}
