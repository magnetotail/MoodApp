import 'package:flutter/material.dart';
import 'package:mood/main.dart';
import 'package:mood/model/model.dart';

import 'skill_list.dart';

class SelectedSkillsView extends StatefulWidget {
  const SelectedSkillsView({Key? key}) : super(key: key);
  static const _edit = 'Skills bearbeiten';
  static const _add = 'Konfiguration hinzufügen';
  static const _menuItems = <String>[_edit, _add];

  @override
  State<SelectedSkillsView> createState() => _SelectedSkillsViewState();
}

class _SelectedSkillsViewState extends State<SelectedSkillsView> {
  final _selectedSkills = <SelectedSkill>[];

  @override
  void initState() {
    super.initState();
    loadSelectedSkills();
  }

  void loadSelectedSkills() async {
    var selectedSkills = await SelectedSkill().select().toList(preload: true);
    setState(() {
      _selectedSkills.addAll(selectedSkills);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton(
              onSelected: (String value) => onSelected(value, context),
              itemBuilder: (BuildContext context) {
                return SelectedSkillsView._menuItems.map((String item) {
                  return PopupMenuItem<String>(child: Text(item), value: item);
                }).toList();
              }),
        ],
        title: Text('Deine Skills'),
      ),
      drawer: const NavigationDrawer(),
      body: ListView(
        children: _selectedSkills
            .map((e) => SelectedSkillCard(selectedSkill: e, notifyDelete: removeCallback,))
            .toList(),
      ),
    );
  }

  void removeCallback(SelectedSkill skill){
    setState(() {
      _selectedSkills.remove(skill);
    });
  }


  void onSelected(String value, BuildContext context) {
    switch (value) {
      case SelectedSkillsView._edit:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const SkillList()));
        break;
      case SelectedSkillsView._add:
        addSelectedSkill(context);
        break;
    }
  }

  void addSelectedSkill(BuildContext context) async {
    SelectedSkill? newSkill = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => const InputSelectedSkill()));
    if (newSkill != null) {
      setState(() {
        _selectedSkills.add(newSkill);
      });
    }
  }
}

class SelectedSkillCard extends StatefulWidget {
  SelectedSkillCard({Key? key, required this.selectedSkill, required this.notifyDelete})
      : super(key: key);

  static const _menuItems = ['bearbeiten', 'löschen'];

  SelectedSkill selectedSkill;

  Function(SelectedSkill) notifyDelete;

  @override
  State<SelectedSkillCard> createState() => _SelectedSkillCardState();
}

class _SelectedSkillCardState extends State<SelectedSkillCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.selectedSkill.plSkill!.name!),
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
            if (widget.selectedSkill.stresslevel_min != null) Divider(),
            if (widget.selectedSkill.stresslevel_min != null)
              Text(
                  'Von Anspannung ${widget.selectedSkill.stresslevel_min} bis ${widget.selectedSkill.stresslevel_max}'),
            if (widget.selectedSkill.moodlevel_min != null) const Divider(),
            if (widget.selectedSkill.moodlevel_min != null)
              Text(
                  'Von Stimmung ${widget.selectedSkill.moodlevel_min} bis ${widget.selectedSkill.moodlevel_max}')
          ],
        ),
      ),
    );
  }

  List<PopupMenuEntry> createPopupMenuButtons(BuildContext context) {
    return SelectedSkillCard._menuItems
        .map((e) => PopupMenuItem(
              child: Text(e),
              value: e,
            ))
        .toList();
  }

  void popupMenuPressed(value, BuildContext context) {
    switch (value) {
      case 'bearbeiten':
        edit(context);
        break;
      case 'löschen':
        delete();
        break;
    }
  }

  void edit(BuildContext context) async {
    SelectedSkill? newSkill = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => InputSelectedSkill(selectedSkill: widget.selectedSkill)));
    setState(() {
      //selectedSkill properties have already been changed and saved in Input class. just need to rebuild the tree
    });
  }

  void delete() async {
    widget.notifyDelete(widget.selectedSkill);
    await widget.selectedSkill.delete();
  }
}

class InputSelectedSkill extends StatefulWidget {
  const InputSelectedSkill({Key? key, this.selectedSkill}) : super(key: key);

  final SelectedSkill? selectedSkill;

  @override
  State<InputSelectedSkill> createState() => _InputSelectedSkillState();
}

class _InputSelectedSkillState extends State<InputSelectedSkill> {
  bool _inputStress = true;
  bool _inputMood = false;
  var _stressRange = RangeValues(0, 100);
  var _moodRange = RangeValues(0, 10);
  Skill? _selectedSkill = null;

  final _skills = <Skill>[];

  @override
  void initState() {
    super.initState();
    if (widget.selectedSkill != null) {
      if (widget.selectedSkill!.stresslevel_min != null) {
        _inputStress = true;
        _stressRange = RangeValues(
            widget.selectedSkill!.stresslevel_min!.toDouble(),
            widget.selectedSkill!.stresslevel_max!.toDouble());
      }
      if (widget.selectedSkill!.moodlevel_min != null) {
        _inputMood = true;
        _moodRange = RangeValues(
            widget.selectedSkill!.moodlevel_min!.toDouble(),
            widget.selectedSkill!.moodlevel_max!.toDouble());
      }
      _selectedSkill = widget.selectedSkill!.plSkill;
    }
    loadSkills();
  }

  void loadSkills() async {
    var skills = await Skill().select().orderBy('name').toList();
    setState(() {
      _skills.addAll(skills);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Konfiguration hinzufügen')),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 16),
        child: Column(children: [
          Text('Anspannung'),
          buildStressRow(),
          Text('Stimmung'),
          buildMoodRow(),
          if (!_inputMood && !_inputStress)
            const Text('Bitte mindestens eins von beiden auswählen',
                style: TextStyle(color: Colors.red)),
          Text(
              'Aktuell ausgewählt: ${_selectedSkill != null ? _selectedSkill!.name : 'nichts'}'),
          buildSkillList(),
          ElevatedButton(
            onPressed: submit,
            child: Text('Fertig'),
          ),
        ]),
      ),
    );
  }

  Row buildMoodRow() {
    return Row(children: [
      Checkbox(
        onChanged: (value) {
          setState(() {
            _inputMood = value!;
          });
        },
        value: _inputMood,
      ),
      Expanded(
        child: RangeSlider(
          onChanged: _inputMood ? setMoodRange : null,
          values: _moodRange,
          min: 0,
          max: 10,
          divisions: 10,
        ),
      ),
      Text('${_moodRange.start.toInt()} - ${_moodRange.end.toInt()}'),
    ]);
  }

  Row buildStressRow() {
    return Row(children: [
      Checkbox(
        onChanged: (value) {
          setState(() {
            _inputStress = value!;
          });
        },
        value: _inputStress,
      ),
      Expanded(
        child: RangeSlider(
          onChanged: _inputStress ? setStressRange : null,
          values: _stressRange,
          min: 0,
          max: 100,
          divisions: 20,
        ),
      ),
      Text('${_stressRange.start.toInt()} - ${_stressRange.end.toInt()}')
    ]);
  }

  Widget buildSkillList() {
    return Expanded(
      child: ListView(
        children: _skills.map((e) => createSkillCard(e)).toList(),
      ),
    );
  }

  Widget createSkillCard(Skill skill) {
    return GestureDetector(
      onTap: () => setState(() {
        _selectedSkill = skill;
      }),
      child: Card(
        child: Padding(
            padding: EdgeInsets.all(5),
            child: Center(child: Text(skill.name!))),
      ),
    );
  }

  void submit() async {
    SelectedSkill skillConfig = widget.selectedSkill ?? SelectedSkill();
    if (!_inputStress && !_inputMood || _selectedSkill == null) {
      return; // User is shown errortext, because at least one must be selected
    }
    if (_inputStress) {
      skillConfig.stresslevel_min = _stressRange.start.toInt();
      skillConfig.stresslevel_max = _stressRange.end.toInt();
    }
    if (_inputMood) {
      skillConfig.moodlevel_min = _moodRange.start.toInt();
      skillConfig.moodlevel_max = _moodRange.end.toInt();
    }
    skillConfig.SkillId = _selectedSkill!.id;
    skillConfig.plSkill = _selectedSkill;
    await skillConfig.save();
    Navigator.pop(context, skillConfig);
  }

  void setStressRange(RangeValues values) {
    setState(() {
      _stressRange = values;
    });
  }

  void setMoodRange(RangeValues values) {
    setState(() {
      _moodRange = values;
    });
  }
}
