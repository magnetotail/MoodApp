import 'dart:convert';
import 'package:sqfentity/sqfentity.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

part 'model.g.dart';

const tableSkill = SqfEntityTable(

    tableName: 'Skill',
    primaryKeyName: 'id',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    useSoftDeleting: false,
    modelName: null,
    fields: [
      SqfEntityField('name', DbType.text, isNotNull: true),
      SqfEntityField('description', DbType.text)
    ]);

const tableSelectedSkill = SqfEntityTable(
    tableName: 'SelectedSkill',
    primaryKeyName: 'id',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    useSoftDeleting: false,
    modelName: null,
    fields: [
      SqfEntityFieldRelationship(
          parentTable: tableSkill, deleteRule: DeleteRule.CASCADE),
      SqfEntityField('active', DbType.bool,
          defaultValue: true, isNotNull: true),
      SqfEntityField('stresslevel_min', DbType.integer),
      SqfEntityField('stresslevel_max', DbType.integer),
      SqfEntityField('moodlevel_min', DbType.integer),
      SqfEntityField('moodlevel_max', DbType.integer)
    ]);

const tableSkillUse = SqfEntityTable(
    tableName: 'SkillUse',
    primaryKeyName: 'id',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    useSoftDeleting: false,
    modelName: null,
    fields: [
      SqfEntityFieldRelationship(
          parentTable: tableSkill,
          relationType: RelationType.ONE_TO_MANY,
          deleteRule: DeleteRule.CASCADE,
          isNotNull: true),
      SqfEntityField('useDateTime', DbType.datetime),
      SqfEntityFieldRelationship(
          isNotNull: false,
          parentTable: tableMoodEntry,
          relationType: RelationType.ONE_TO_MANY
      ),
      SqfEntityFieldRelationship(
        isNotNull: false,
        parentTable: tableEffectiveness,
        relationType: RelationType.ONE_TO_MANY,
      ),

    ]);

const tableEffectiveness = SqfEntityTable(
    tableName: 'Effectiveness',
    primaryKeyName: 'id',
    primaryKeyType: PrimaryKeyType.integer_unique,
    useSoftDeleting: false,
    fields: [
      SqfEntityField('description', DbType.text),
    ]);

const tableMoodEntry = SqfEntityTable(
    tableName: 'MoodEntry',
    primaryKeyName: 'id',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    useSoftDeleting: false,
    fields: [
      SqfEntityField('stresslevel', DbType.integer, isNotNull: true),
      SqfEntityField('mood', DbType.integer),
      SqfEntityField('dateTime', DbType.datetime),
      SqfEntityField('activity', DbType.text)
    ]);

const tableMoodDiaryEntry = SqfEntityTable(
    tableName: 'MoodDiaryEntry',
    primaryKeyName: 'id',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    useSoftDeleting: false,
    fields: [
      SqfEntityField('activity', DbType.text),
      SqfEntityField('mood', DbType.text),
      SqfEntityField('thoughts', DbType.text),
      SqfEntityField('rating', DbType.integer),
      SqfEntityField('dateTime', DbType.datetime)
    ]);

const tableMoodWithDiaryEntry = SqfEntityTable(
    tableName: 'MoodWithDiaryEntry',
    primaryKeyName: 'id',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    useSoftDeleting: false,
    fields: [
      // SqfEntityField('test', DbType.integer),
      SqfEntityField('moodId', DbType.integer),
      SqfEntityField('diaryId', DbType.integer),
    ]

);

@SqfEntityBuilder(myDbModel)
const myDbModel = SqfEntityModel(
  // databasePath: ,

    databaseName: 'mood.db',

    databaseTables: [
      tableSkill,
      tableSelectedSkill,
      tableSkillUse,
      tableEffectiveness,
      tableMoodDiaryEntry,
      tableMoodEntry,
      tableMoodWithDiaryEntry
    ]);
