import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/model.dart';

class MoodDiaryCard extends StatefulWidget {
  MoodDiaryCard({Key? key, required MoodDiaryEntry moodDiaryEntry})
      : _moodDiaryEntry = moodDiaryEntry,
        super(key: key);

  MoodDiaryEntry _moodDiaryEntry;

  @override
  State<MoodDiaryCard> createState() => _MoodDiaryCardState();
}

class _MoodDiaryCardState extends State<MoodDiaryCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(DateFormat('hh:mm').format(widget._moodDiaryEntry.dateTime!),
                  style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.left),
              if (widget._moodDiaryEntry.rating != null)
                Text('Deine Bewertung: ${widget._moodDiaryEntry.rating}/10',
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
            ]),
            Divider(),
            Row(crossAxisAlignment: CrossAxisAlignment.start,children: [
              const SizedBox(width: 90, child: Text('Was hast du gemacht:')),
              const SizedBox(width: 10),
              Expanded(child: Text(widget._moodDiaryEntry.activity!)),
            ]),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start,children: [
                const SizedBox(width: 90, child: Text('Deine Gefühle dabei:')),
                const SizedBox(width: 10),
                Expanded(child: Text(widget._moodDiaryEntry.mood!)),
              ]),
            ),
            Row(crossAxisAlignment: CrossAxisAlignment.start,children: [
              const SizedBox(width: 90, child: Text('Was dir durch den Kopf ging:')),
              const SizedBox(width: 10),
              Expanded(child: Text(widget._moodDiaryEntry.thoughts!)),
            ])
          ],
        ),
      ),
    );
  }

  List<PopupMenuEntry> createPopupMenuButtons(BuildContext context) {
    return <PopupMenuEntry>[];
  }

  popupMenuPressed(Object? value, BuildContext context) {}
}
