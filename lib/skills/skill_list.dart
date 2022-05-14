import 'package:flutter/material.dart';

import '../model/model.dart';

class SkillList extends StatefulWidget {
  const SkillList({Key? key}) : super(key: key);

  @override
  State<SkillList> createState() => _SkillListState();
}

class _SkillListState extends State<SkillList> {
  final _skills = <Skill>[];

  @override
  void initState() {
    super.initState();
    loadSkills();
  }

  loadSkills() async {
    var skills = await Skill().select().toList(preload: true);
    setState(() {
      _skills.addAll(skills);
    });
  }

  @override
  Widget build(BuildContext context) {
    return createList();
  }

  Widget createList() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Skillübersicht'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: addSkill,
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: _skills.map((e) => SkillCard(skill: e)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  void addSkill() async {
    Skill newSkill = await Navigator.push(context, MaterialPageRoute(builder: (context) => InputSkill()));
    setState(() {
      _skills.add(newSkill);
    });
  }
}

class SkillCard extends StatefulWidget {
  SkillCard({Key? key, required this.skill}) : super(key: key);
  Skill skill;

  @override
  State<SkillCard> createState() => _SkillCardState();
}

class _SkillCardState extends State<SkillCard> {
  bool _showDescription = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() {
        _showDescription = !_showDescription;
      }),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.skill.name!),
                  SizedBox(
                    height: 20,
                    width: 30,
                    child: PopupMenuButton(
                      padding: EdgeInsets.zero,
                      itemBuilder: createPopupMenuButtons,
                      onSelected: popupMenuPressed,
                    ),
                  ),
                ],
              ),
              Divider(),
              if (_showDescription && widget.skill.description != null && widget.skill.description!.isNotEmpty)
                Text(widget.skill.description!)
              else if (!_showDescription && widget.skill.description != null && widget.skill.description!.isNotEmpty)
                const Text('Antippen um die Beschreibung anzuzeigen'),
            ],
          ),
        ),
      ),
    );
  }

    void editSkill(Skill skill) async {
    print('editing ${skill.toMap()}');
    await Navigator.push(context, MaterialPageRoute(builder: (context) => InputSkill(skill: widget.skill)));
    setState(() {
      // widget.skill = editedSkill;
    });
  }

  List<PopupMenuEntry<dynamic>> createPopupMenuButtons(BuildContext context) {
    final entries = <PopupMenuEntry<dynamic>>[];
    entries.add(const PopupMenuItem<String>(child: Text('bearbeiten'), value: 'bearbeiten'));
    return entries;
  }

  void popupMenuPressed(value) {
    print('$value pressed');
    switch (value) {
      case 'bearbeiten':
        editSkill(widget.skill);
    }
  }

}

class InputSkill extends StatefulWidget {
  const InputSkill({Key? key, this.skill}) : super(key: key);

  final Skill? skill;

  @override
  State<InputSkill> createState() => _InputSkillState();
}

class _InputSkillState extends State<InputSkill> {
  String _name = '';
  String _description = '';

  final _nameEditingController = TextEditingController();
  final _descriptionEditingController = TextEditingController();
  final _nameFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.skill != null) {
      _name = widget.skill!.name!;
      if (widget.skill!.description != null && widget.skill!.description!.isNotEmpty) {
        _description = widget.skill!.description!;
      }
    }
    _nameEditingController.text = _name;
    _descriptionEditingController.text = _description;
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
          title: Text(widget.skill != null ? 'Eintrag bearbeiten' : 'Neuer Eintrag'),
        ),
        body: Container(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameEditingController,
                  focusNode: _nameFocusNode,
                  decoration: const InputDecoration.collapsed(hintText: 'Name'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Bitte gib einen Namen ein';
                    }
                    return null;
                  },
                ),
                const Divider(),
                TextField(
                  controller: _descriptionEditingController,
                  focusNode: _descriptionFocusNode,
                  decoration: const InputDecoration.collapsed(hintText: 'Beschreibung'),
                  onSubmitted: _descriptionSubmitted,
                  maxLines: null,
                ),
                ElevatedButton(
                  onPressed: _submit,
                  child: const Text('fertig'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _nameSubmitted(String value) {
    _name = value;
  }

  void _descriptionSubmitted(String value) {
    _description = value;
  }

  void _submit() async {
    _description = _descriptionEditingController.text;
    _name = _nameEditingController.text;
    if (_formKey.currentState!.validate()) {
      var skill = widget.skill ?? Skill();
      skill.name = _name;
      skill.description = _description;
      await skill.save();
      Navigator.pop(context, skill);
    }
  }
}
