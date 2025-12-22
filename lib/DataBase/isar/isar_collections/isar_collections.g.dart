// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'isar_collections.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetIsarUserProfileCollection on Isar {
  IsarCollection<IsarUserProfile> get isarUserProfiles => this.collection();
}

const IsarUserProfileSchema = CollectionSchema(
  name: r'IsarUserProfile',
  id: 8546962976391985935,
  properties: {
    r'createdAt': PropertySchema(
      id: 0,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'userContact': PropertySchema(
      id: 1,
      name: r'userContact',
      type: IsarType.string,
    ),
    r'userEmail': PropertySchema(
      id: 2,
      name: r'userEmail',
      type: IsarType.string,
    ),
    r'userId': PropertySchema(
      id: 3,
      name: r'userId',
      type: IsarType.string,
    ),
    r'userImagePath': PropertySchema(
      id: 4,
      name: r'userImagePath',
      type: IsarType.string,
    ),
    r'userName': PropertySchema(
      id: 5,
      name: r'userName',
      type: IsarType.string,
    )
  },
  estimateSize: _isarUserProfileEstimateSize,
  serialize: _isarUserProfileSerialize,
  deserialize: _isarUserProfileDeserialize,
  deserializeProp: _isarUserProfileDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _isarUserProfileGetId,
  getLinks: _isarUserProfileGetLinks,
  attach: _isarUserProfileAttach,
  version: '3.1.0+1',
);

int _isarUserProfileEstimateSize(
  IsarUserProfile object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.userContact;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.userEmail;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.userId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.userImagePath;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.userName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _isarUserProfileSerialize(
  IsarUserProfile object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeString(offsets[1], object.userContact);
  writer.writeString(offsets[2], object.userEmail);
  writer.writeString(offsets[3], object.userId);
  writer.writeString(offsets[4], object.userImagePath);
  writer.writeString(offsets[5], object.userName);
}

IsarUserProfile _isarUserProfileDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = IsarUserProfile();
  object.createdAt = reader.readDateTimeOrNull(offsets[0]);
  object.id = id;
  object.userContact = reader.readStringOrNull(offsets[1]);
  object.userEmail = reader.readStringOrNull(offsets[2]);
  object.userId = reader.readStringOrNull(offsets[3]);
  object.userImagePath = reader.readStringOrNull(offsets[4]);
  object.userName = reader.readStringOrNull(offsets[5]);
  return object;
}

P _isarUserProfileDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _isarUserProfileGetId(IsarUserProfile object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _isarUserProfileGetLinks(IsarUserProfile object) {
  return [];
}

void _isarUserProfileAttach(
    IsarCollection<dynamic> col, Id id, IsarUserProfile object) {
  object.id = id;
}

extension IsarUserProfileQueryWhereSort
    on QueryBuilder<IsarUserProfile, IsarUserProfile, QWhere> {
  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension IsarUserProfileQueryWhere
    on QueryBuilder<IsarUserProfile, IsarUserProfile, QWhereClause> {
  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension IsarUserProfileQueryFilter
    on QueryBuilder<IsarUserProfile, IsarUserProfile, QFilterCondition> {
  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterFilterCondition>
      createdAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'createdAt',
      ));
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterFilterCondition>
      createdAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'createdAt',
      ));
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterFilterCondition>
      createdAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterFilterCondition>
      createdAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterFilterCondition>
      createdAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterFilterCondition>
      userContactIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'userContact',
      ));
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterFilterCondition>
      userContactIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'userContact',
      ));
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterFilterCondition>
      userContactEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userContact',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterFilterCondition>
      userContactGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'userContact',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterFilterCondition>
      userContactLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'userContact',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterFilterCondition>
      userContactBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'userContact',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterFilterCondition>
      userContactStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'userContact',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterFilterCondition>
      userContactEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'userContact',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterFilterCondition>
      userContactContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'userContact',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterFilterCondition>
      userContactMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'userContact',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterFilterCondition>
      userContactIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userContact',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterFilterCondition>
      userContactIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'userContact',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterFilterCondition>
      userEmailIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'userEmail',
      ));
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterFilterCondition>
      userEmailIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'userEmail',
      ));
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterFilterCondition>
      userEmailEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userEmail',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterFilterCondition>
      userEmailGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'userEmail',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterFilterCondition>
      userEmailLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'userEmail',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterFilterCondition>
      userEmailBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'userEmail',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterFilterCondition>
      userEmailStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'userEmail',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterFilterCondition>
      userEmailEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'userEmail',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterFilterCondition>
      userEmailContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'userEmail',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterFilterCondition>
      userEmailMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'userEmail',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterFilterCondition>
      userEmailIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userEmail',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterFilterCondition>
      userEmailIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'userEmail',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterFilterCondition>
      userIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'userId',
      ));
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterFilterCondition>
      userIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'userId',
      ));
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterFilterCondition>
      userIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterFilterCondition>
      userIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterFilterCondition>
      userIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterFilterCondition>
      userIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'userId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterFilterCondition>
      userIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterFilterCondition>
      userIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterFilterCondition>
      userIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterFilterCondition>
      userIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'userId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterFilterCondition>
      userIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterFilterCondition>
      userIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'userId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterFilterCondition>
      userImagePathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'userImagePath',
      ));
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterFilterCondition>
      userImagePathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'userImagePath',
      ));
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterFilterCondition>
      userImagePathEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userImagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterFilterCondition>
      userImagePathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'userImagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterFilterCondition>
      userImagePathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'userImagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterFilterCondition>
      userImagePathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'userImagePath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterFilterCondition>
      userImagePathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'userImagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterFilterCondition>
      userImagePathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'userImagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterFilterCondition>
      userImagePathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'userImagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterFilterCondition>
      userImagePathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'userImagePath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterFilterCondition>
      userImagePathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userImagePath',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterFilterCondition>
      userImagePathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'userImagePath',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterFilterCondition>
      userNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'userName',
      ));
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterFilterCondition>
      userNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'userName',
      ));
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterFilterCondition>
      userNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterFilterCondition>
      userNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'userName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterFilterCondition>
      userNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'userName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterFilterCondition>
      userNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'userName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterFilterCondition>
      userNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'userName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterFilterCondition>
      userNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'userName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterFilterCondition>
      userNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'userName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterFilterCondition>
      userNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'userName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterFilterCondition>
      userNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userName',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterFilterCondition>
      userNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'userName',
        value: '',
      ));
    });
  }
}

extension IsarUserProfileQueryObject
    on QueryBuilder<IsarUserProfile, IsarUserProfile, QFilterCondition> {}

extension IsarUserProfileQueryLinks
    on QueryBuilder<IsarUserProfile, IsarUserProfile, QFilterCondition> {}

extension IsarUserProfileQuerySortBy
    on QueryBuilder<IsarUserProfile, IsarUserProfile, QSortBy> {
  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterSortBy>
      sortByUserContact() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userContact', Sort.asc);
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterSortBy>
      sortByUserContactDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userContact', Sort.desc);
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterSortBy>
      sortByUserEmail() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userEmail', Sort.asc);
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterSortBy>
      sortByUserEmailDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userEmail', Sort.desc);
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterSortBy> sortByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterSortBy>
      sortByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterSortBy>
      sortByUserImagePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userImagePath', Sort.asc);
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterSortBy>
      sortByUserImagePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userImagePath', Sort.desc);
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterSortBy>
      sortByUserName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userName', Sort.asc);
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterSortBy>
      sortByUserNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userName', Sort.desc);
    });
  }
}

extension IsarUserProfileQuerySortThenBy
    on QueryBuilder<IsarUserProfile, IsarUserProfile, QSortThenBy> {
  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterSortBy>
      thenByUserContact() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userContact', Sort.asc);
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterSortBy>
      thenByUserContactDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userContact', Sort.desc);
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterSortBy>
      thenByUserEmail() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userEmail', Sort.asc);
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterSortBy>
      thenByUserEmailDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userEmail', Sort.desc);
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterSortBy> thenByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterSortBy>
      thenByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterSortBy>
      thenByUserImagePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userImagePath', Sort.asc);
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterSortBy>
      thenByUserImagePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userImagePath', Sort.desc);
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterSortBy>
      thenByUserName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userName', Sort.asc);
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QAfterSortBy>
      thenByUserNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userName', Sort.desc);
    });
  }
}

extension IsarUserProfileQueryWhereDistinct
    on QueryBuilder<IsarUserProfile, IsarUserProfile, QDistinct> {
  QueryBuilder<IsarUserProfile, IsarUserProfile, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QDistinct>
      distinctByUserContact({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userContact', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QDistinct> distinctByUserEmail(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userEmail', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QDistinct> distinctByUserId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QDistinct>
      distinctByUserImagePath({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userImagePath',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarUserProfile, IsarUserProfile, QDistinct> distinctByUserName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userName', caseSensitive: caseSensitive);
    });
  }
}

extension IsarUserProfileQueryProperty
    on QueryBuilder<IsarUserProfile, IsarUserProfile, QQueryProperty> {
  QueryBuilder<IsarUserProfile, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<IsarUserProfile, DateTime?, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<IsarUserProfile, String?, QQueryOperations>
      userContactProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userContact');
    });
  }

  QueryBuilder<IsarUserProfile, String?, QQueryOperations> userEmailProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userEmail');
    });
  }

  QueryBuilder<IsarUserProfile, String?, QQueryOperations> userIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userId');
    });
  }

  QueryBuilder<IsarUserProfile, String?, QQueryOperations>
      userImagePathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userImagePath');
    });
  }

  QueryBuilder<IsarUserProfile, String?, QQueryOperations> userNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userName');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetIsarLoanCollection on Isar {
  IsarCollection<IsarLoan> get isarLoans => this.collection();
}

const IsarLoanSchema = CollectionSchema(
  name: r'IsarLoan',
  id: -5370862837766923818,
  properties: {
    r'createdAt': PropertySchema(
      id: 0,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'loanId': PropertySchema(
      id: 1,
      name: r'loanId',
      type: IsarType.string,
    ),
    r'method': PropertySchema(
      id: 2,
      name: r'method',
      type: IsarType.string,
    ),
    r'rate': PropertySchema(
      id: 3,
      name: r'rate',
      type: IsarType.double,
    ),
    r'userId': PropertySchema(
      id: 4,
      name: r'userId',
      type: IsarType.string,
    )
  },
  estimateSize: _isarLoanEstimateSize,
  serialize: _isarLoanSerialize,
  deserialize: _isarLoanDeserialize,
  deserializeProp: _isarLoanDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _isarLoanGetId,
  getLinks: _isarLoanGetLinks,
  attach: _isarLoanAttach,
  version: '3.1.0+1',
);

int _isarLoanEstimateSize(
  IsarLoan object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.loanId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.method;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.userId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _isarLoanSerialize(
  IsarLoan object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeString(offsets[1], object.loanId);
  writer.writeString(offsets[2], object.method);
  writer.writeDouble(offsets[3], object.rate);
  writer.writeString(offsets[4], object.userId);
}

IsarLoan _isarLoanDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = IsarLoan();
  object.createdAt = reader.readDateTimeOrNull(offsets[0]);
  object.id = id;
  object.loanId = reader.readStringOrNull(offsets[1]);
  object.method = reader.readStringOrNull(offsets[2]);
  object.rate = reader.readDoubleOrNull(offsets[3]);
  object.userId = reader.readStringOrNull(offsets[4]);
  return object;
}

P _isarLoanDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readDoubleOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _isarLoanGetId(IsarLoan object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _isarLoanGetLinks(IsarLoan object) {
  return [];
}

void _isarLoanAttach(IsarCollection<dynamic> col, Id id, IsarLoan object) {
  object.id = id;
}

extension IsarLoanQueryWhereSort on QueryBuilder<IsarLoan, IsarLoan, QWhere> {
  QueryBuilder<IsarLoan, IsarLoan, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension IsarLoanQueryWhere on QueryBuilder<IsarLoan, IsarLoan, QWhereClause> {
  QueryBuilder<IsarLoan, IsarLoan, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<IsarLoan, IsarLoan, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<IsarLoan, IsarLoan, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<IsarLoan, IsarLoan, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<IsarLoan, IsarLoan, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension IsarLoanQueryFilter
    on QueryBuilder<IsarLoan, IsarLoan, QFilterCondition> {
  QueryBuilder<IsarLoan, IsarLoan, QAfterFilterCondition> createdAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'createdAt',
      ));
    });
  }

  QueryBuilder<IsarLoan, IsarLoan, QAfterFilterCondition> createdAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'createdAt',
      ));
    });
  }

  QueryBuilder<IsarLoan, IsarLoan, QAfterFilterCondition> createdAtEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarLoan, IsarLoan, QAfterFilterCondition> createdAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarLoan, IsarLoan, QAfterFilterCondition> createdAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarLoan, IsarLoan, QAfterFilterCondition> createdAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarLoan, IsarLoan, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarLoan, IsarLoan, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarLoan, IsarLoan, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarLoan, IsarLoan, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarLoan, IsarLoan, QAfterFilterCondition> loanIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'loanId',
      ));
    });
  }

  QueryBuilder<IsarLoan, IsarLoan, QAfterFilterCondition> loanIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'loanId',
      ));
    });
  }

  QueryBuilder<IsarLoan, IsarLoan, QAfterFilterCondition> loanIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'loanId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarLoan, IsarLoan, QAfterFilterCondition> loanIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'loanId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarLoan, IsarLoan, QAfterFilterCondition> loanIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'loanId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarLoan, IsarLoan, QAfterFilterCondition> loanIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'loanId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarLoan, IsarLoan, QAfterFilterCondition> loanIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'loanId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarLoan, IsarLoan, QAfterFilterCondition> loanIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'loanId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarLoan, IsarLoan, QAfterFilterCondition> loanIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'loanId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarLoan, IsarLoan, QAfterFilterCondition> loanIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'loanId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarLoan, IsarLoan, QAfterFilterCondition> loanIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'loanId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarLoan, IsarLoan, QAfterFilterCondition> loanIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'loanId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarLoan, IsarLoan, QAfterFilterCondition> methodIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'method',
      ));
    });
  }

  QueryBuilder<IsarLoan, IsarLoan, QAfterFilterCondition> methodIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'method',
      ));
    });
  }

  QueryBuilder<IsarLoan, IsarLoan, QAfterFilterCondition> methodEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'method',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarLoan, IsarLoan, QAfterFilterCondition> methodGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'method',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarLoan, IsarLoan, QAfterFilterCondition> methodLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'method',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarLoan, IsarLoan, QAfterFilterCondition> methodBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'method',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarLoan, IsarLoan, QAfterFilterCondition> methodStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'method',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarLoan, IsarLoan, QAfterFilterCondition> methodEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'method',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarLoan, IsarLoan, QAfterFilterCondition> methodContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'method',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarLoan, IsarLoan, QAfterFilterCondition> methodMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'method',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarLoan, IsarLoan, QAfterFilterCondition> methodIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'method',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarLoan, IsarLoan, QAfterFilterCondition> methodIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'method',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarLoan, IsarLoan, QAfterFilterCondition> rateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'rate',
      ));
    });
  }

  QueryBuilder<IsarLoan, IsarLoan, QAfterFilterCondition> rateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'rate',
      ));
    });
  }

  QueryBuilder<IsarLoan, IsarLoan, QAfterFilterCondition> rateEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rate',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarLoan, IsarLoan, QAfterFilterCondition> rateGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'rate',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarLoan, IsarLoan, QAfterFilterCondition> rateLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'rate',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarLoan, IsarLoan, QAfterFilterCondition> rateBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'rate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarLoan, IsarLoan, QAfterFilterCondition> userIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'userId',
      ));
    });
  }

  QueryBuilder<IsarLoan, IsarLoan, QAfterFilterCondition> userIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'userId',
      ));
    });
  }

  QueryBuilder<IsarLoan, IsarLoan, QAfterFilterCondition> userIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarLoan, IsarLoan, QAfterFilterCondition> userIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarLoan, IsarLoan, QAfterFilterCondition> userIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarLoan, IsarLoan, QAfterFilterCondition> userIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'userId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarLoan, IsarLoan, QAfterFilterCondition> userIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarLoan, IsarLoan, QAfterFilterCondition> userIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarLoan, IsarLoan, QAfterFilterCondition> userIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarLoan, IsarLoan, QAfterFilterCondition> userIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'userId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarLoan, IsarLoan, QAfterFilterCondition> userIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarLoan, IsarLoan, QAfterFilterCondition> userIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'userId',
        value: '',
      ));
    });
  }
}

extension IsarLoanQueryObject
    on QueryBuilder<IsarLoan, IsarLoan, QFilterCondition> {}

extension IsarLoanQueryLinks
    on QueryBuilder<IsarLoan, IsarLoan, QFilterCondition> {}

extension IsarLoanQuerySortBy on QueryBuilder<IsarLoan, IsarLoan, QSortBy> {
  QueryBuilder<IsarLoan, IsarLoan, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<IsarLoan, IsarLoan, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<IsarLoan, IsarLoan, QAfterSortBy> sortByLoanId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'loanId', Sort.asc);
    });
  }

  QueryBuilder<IsarLoan, IsarLoan, QAfterSortBy> sortByLoanIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'loanId', Sort.desc);
    });
  }

  QueryBuilder<IsarLoan, IsarLoan, QAfterSortBy> sortByMethod() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'method', Sort.asc);
    });
  }

  QueryBuilder<IsarLoan, IsarLoan, QAfterSortBy> sortByMethodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'method', Sort.desc);
    });
  }

  QueryBuilder<IsarLoan, IsarLoan, QAfterSortBy> sortByRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rate', Sort.asc);
    });
  }

  QueryBuilder<IsarLoan, IsarLoan, QAfterSortBy> sortByRateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rate', Sort.desc);
    });
  }

  QueryBuilder<IsarLoan, IsarLoan, QAfterSortBy> sortByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<IsarLoan, IsarLoan, QAfterSortBy> sortByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension IsarLoanQuerySortThenBy
    on QueryBuilder<IsarLoan, IsarLoan, QSortThenBy> {
  QueryBuilder<IsarLoan, IsarLoan, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<IsarLoan, IsarLoan, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<IsarLoan, IsarLoan, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<IsarLoan, IsarLoan, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<IsarLoan, IsarLoan, QAfterSortBy> thenByLoanId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'loanId', Sort.asc);
    });
  }

  QueryBuilder<IsarLoan, IsarLoan, QAfterSortBy> thenByLoanIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'loanId', Sort.desc);
    });
  }

  QueryBuilder<IsarLoan, IsarLoan, QAfterSortBy> thenByMethod() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'method', Sort.asc);
    });
  }

  QueryBuilder<IsarLoan, IsarLoan, QAfterSortBy> thenByMethodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'method', Sort.desc);
    });
  }

  QueryBuilder<IsarLoan, IsarLoan, QAfterSortBy> thenByRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rate', Sort.asc);
    });
  }

  QueryBuilder<IsarLoan, IsarLoan, QAfterSortBy> thenByRateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rate', Sort.desc);
    });
  }

  QueryBuilder<IsarLoan, IsarLoan, QAfterSortBy> thenByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<IsarLoan, IsarLoan, QAfterSortBy> thenByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension IsarLoanQueryWhereDistinct
    on QueryBuilder<IsarLoan, IsarLoan, QDistinct> {
  QueryBuilder<IsarLoan, IsarLoan, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<IsarLoan, IsarLoan, QDistinct> distinctByLoanId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'loanId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarLoan, IsarLoan, QDistinct> distinctByMethod(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'method', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarLoan, IsarLoan, QDistinct> distinctByRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rate');
    });
  }

  QueryBuilder<IsarLoan, IsarLoan, QDistinct> distinctByUserId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userId', caseSensitive: caseSensitive);
    });
  }
}

extension IsarLoanQueryProperty
    on QueryBuilder<IsarLoan, IsarLoan, QQueryProperty> {
  QueryBuilder<IsarLoan, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<IsarLoan, DateTime?, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<IsarLoan, String?, QQueryOperations> loanIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'loanId');
    });
  }

  QueryBuilder<IsarLoan, String?, QQueryOperations> methodProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'method');
    });
  }

  QueryBuilder<IsarLoan, double?, QQueryOperations> rateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rate');
    });
  }

  QueryBuilder<IsarLoan, String?, QQueryOperations> userIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userId');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetIsarReceivableCollection on Isar {
  IsarCollection<IsarReceivable> get isarReceivables => this.collection();
}

const IsarReceivableSchema = CollectionSchema(
  name: r'IsarReceivable',
  id: 4165133130463009937,
  properties: {
    r'createdAt': PropertySchema(
      id: 0,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'description': PropertySchema(
      id: 1,
      name: r'description',
      type: IsarType.string,
    ),
    r'isPaid': PropertySchema(
      id: 2,
      name: r'isPaid',
      type: IsarType.boolList,
    ),
    r'isReceived': PropertySchema(
      id: 3,
      name: r'isReceived',
      type: IsarType.boolList,
    ),
    r'method': PropertySchema(
      id: 4,
      name: r'method',
      type: IsarType.string,
    ),
    r'participants': PropertySchema(
      id: 5,
      name: r'participants',
      type: IsarType.stringList,
    ),
    r'rate': PropertySchema(
      id: 6,
      name: r'rate',
      type: IsarType.doubleList,
    ),
    r'receivableId': PropertySchema(
      id: 7,
      name: r'receivableId',
      type: IsarType.string,
    )
  },
  estimateSize: _isarReceivableEstimateSize,
  serialize: _isarReceivableSerialize,
  deserialize: _isarReceivableDeserialize,
  deserializeProp: _isarReceivableDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _isarReceivableGetId,
  getLinks: _isarReceivableGetLinks,
  attach: _isarReceivableAttach,
  version: '3.1.0+1',
);

int _isarReceivableEstimateSize(
  IsarReceivable object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.description;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.isPaid.length;
  bytesCount += 3 + object.isReceived.length;
  {
    final value = object.method;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.participants.length * 3;
  {
    for (var i = 0; i < object.participants.length; i++) {
      final value = object.participants[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.rate.length * 8;
  {
    final value = object.receivableId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _isarReceivableSerialize(
  IsarReceivable object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeString(offsets[1], object.description);
  writer.writeBoolList(offsets[2], object.isPaid);
  writer.writeBoolList(offsets[3], object.isReceived);
  writer.writeString(offsets[4], object.method);
  writer.writeStringList(offsets[5], object.participants);
  writer.writeDoubleList(offsets[6], object.rate);
  writer.writeString(offsets[7], object.receivableId);
}

IsarReceivable _isarReceivableDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = IsarReceivable();
  object.createdAt = reader.readDateTimeOrNull(offsets[0]);
  object.description = reader.readStringOrNull(offsets[1]);
  object.id = id;
  object.isPaid = reader.readBoolList(offsets[2]) ?? [];
  object.isReceived = reader.readBoolList(offsets[3]) ?? [];
  object.method = reader.readStringOrNull(offsets[4]);
  object.participants = reader.readStringList(offsets[5]) ?? [];
  object.rate = reader.readDoubleList(offsets[6]) ?? [];
  object.receivableId = reader.readStringOrNull(offsets[7]);
  return object;
}

P _isarReceivableDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readBoolList(offset) ?? []) as P;
    case 3:
      return (reader.readBoolList(offset) ?? []) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readStringList(offset) ?? []) as P;
    case 6:
      return (reader.readDoubleList(offset) ?? []) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _isarReceivableGetId(IsarReceivable object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _isarReceivableGetLinks(IsarReceivable object) {
  return [];
}

void _isarReceivableAttach(
    IsarCollection<dynamic> col, Id id, IsarReceivable object) {
  object.id = id;
}

extension IsarReceivableQueryWhereSort
    on QueryBuilder<IsarReceivable, IsarReceivable, QWhere> {
  QueryBuilder<IsarReceivable, IsarReceivable, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension IsarReceivableQueryWhere
    on QueryBuilder<IsarReceivable, IsarReceivable, QWhereClause> {
  QueryBuilder<IsarReceivable, IsarReceivable, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension IsarReceivableQueryFilter
    on QueryBuilder<IsarReceivable, IsarReceivable, QFilterCondition> {
  QueryBuilder<IsarReceivable, IsarReceivable, QAfterFilterCondition>
      createdAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'createdAt',
      ));
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterFilterCondition>
      createdAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'createdAt',
      ));
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterFilterCondition>
      createdAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterFilterCondition>
      createdAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterFilterCondition>
      createdAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterFilterCondition>
      descriptionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'description',
      ));
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterFilterCondition>
      descriptionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'description',
      ));
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterFilterCondition>
      descriptionEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterFilterCondition>
      descriptionGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterFilterCondition>
      descriptionLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterFilterCondition>
      descriptionBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'description',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterFilterCondition>
      descriptionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterFilterCondition>
      descriptionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterFilterCondition>
      descriptionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterFilterCondition>
      descriptionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'description',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterFilterCondition>
      descriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterFilterCondition>
      descriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterFilterCondition>
      isPaidElementEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isPaid',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterFilterCondition>
      isPaidLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'isPaid',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterFilterCondition>
      isPaidIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'isPaid',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterFilterCondition>
      isPaidIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'isPaid',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterFilterCondition>
      isPaidLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'isPaid',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterFilterCondition>
      isPaidLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'isPaid',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterFilterCondition>
      isPaidLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'isPaid',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterFilterCondition>
      isReceivedElementEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isReceived',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterFilterCondition>
      isReceivedLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'isReceived',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterFilterCondition>
      isReceivedIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'isReceived',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterFilterCondition>
      isReceivedIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'isReceived',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterFilterCondition>
      isReceivedLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'isReceived',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterFilterCondition>
      isReceivedLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'isReceived',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterFilterCondition>
      isReceivedLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'isReceived',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterFilterCondition>
      methodIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'method',
      ));
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterFilterCondition>
      methodIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'method',
      ));
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterFilterCondition>
      methodEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'method',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterFilterCondition>
      methodGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'method',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterFilterCondition>
      methodLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'method',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterFilterCondition>
      methodBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'method',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterFilterCondition>
      methodStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'method',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterFilterCondition>
      methodEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'method',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterFilterCondition>
      methodContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'method',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterFilterCondition>
      methodMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'method',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterFilterCondition>
      methodIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'method',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterFilterCondition>
      methodIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'method',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterFilterCondition>
      participantsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'participants',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterFilterCondition>
      participantsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'participants',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterFilterCondition>
      participantsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'participants',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterFilterCondition>
      participantsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'participants',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterFilterCondition>
      participantsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'participants',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterFilterCondition>
      participantsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'participants',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterFilterCondition>
      participantsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'participants',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterFilterCondition>
      participantsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'participants',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterFilterCondition>
      participantsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'participants',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterFilterCondition>
      participantsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'participants',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterFilterCondition>
      participantsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'participants',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterFilterCondition>
      participantsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'participants',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterFilterCondition>
      participantsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'participants',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterFilterCondition>
      participantsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'participants',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterFilterCondition>
      participantsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'participants',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterFilterCondition>
      participantsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'participants',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterFilterCondition>
      rateElementEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rate',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterFilterCondition>
      rateElementGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'rate',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterFilterCondition>
      rateElementLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'rate',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterFilterCondition>
      rateElementBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'rate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterFilterCondition>
      rateLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'rate',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterFilterCondition>
      rateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'rate',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterFilterCondition>
      rateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'rate',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterFilterCondition>
      rateLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'rate',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterFilterCondition>
      rateLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'rate',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterFilterCondition>
      rateLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'rate',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterFilterCondition>
      receivableIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'receivableId',
      ));
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterFilterCondition>
      receivableIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'receivableId',
      ));
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterFilterCondition>
      receivableIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'receivableId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterFilterCondition>
      receivableIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'receivableId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterFilterCondition>
      receivableIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'receivableId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterFilterCondition>
      receivableIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'receivableId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterFilterCondition>
      receivableIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'receivableId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterFilterCondition>
      receivableIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'receivableId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterFilterCondition>
      receivableIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'receivableId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterFilterCondition>
      receivableIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'receivableId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterFilterCondition>
      receivableIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'receivableId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterFilterCondition>
      receivableIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'receivableId',
        value: '',
      ));
    });
  }
}

extension IsarReceivableQueryObject
    on QueryBuilder<IsarReceivable, IsarReceivable, QFilterCondition> {}

extension IsarReceivableQueryLinks
    on QueryBuilder<IsarReceivable, IsarReceivable, QFilterCondition> {}

extension IsarReceivableQuerySortBy
    on QueryBuilder<IsarReceivable, IsarReceivable, QSortBy> {
  QueryBuilder<IsarReceivable, IsarReceivable, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterSortBy>
      sortByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterSortBy>
      sortByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterSortBy> sortByMethod() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'method', Sort.asc);
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterSortBy>
      sortByMethodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'method', Sort.desc);
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterSortBy>
      sortByReceivableId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receivableId', Sort.asc);
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterSortBy>
      sortByReceivableIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receivableId', Sort.desc);
    });
  }
}

extension IsarReceivableQuerySortThenBy
    on QueryBuilder<IsarReceivable, IsarReceivable, QSortThenBy> {
  QueryBuilder<IsarReceivable, IsarReceivable, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterSortBy>
      thenByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterSortBy>
      thenByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterSortBy> thenByMethod() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'method', Sort.asc);
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterSortBy>
      thenByMethodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'method', Sort.desc);
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterSortBy>
      thenByReceivableId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receivableId', Sort.asc);
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QAfterSortBy>
      thenByReceivableIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receivableId', Sort.desc);
    });
  }
}

extension IsarReceivableQueryWhereDistinct
    on QueryBuilder<IsarReceivable, IsarReceivable, QDistinct> {
  QueryBuilder<IsarReceivable, IsarReceivable, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QDistinct> distinctByDescription(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'description', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QDistinct> distinctByIsPaid() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isPaid');
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QDistinct>
      distinctByIsReceived() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isReceived');
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QDistinct> distinctByMethod(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'method', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QDistinct>
      distinctByParticipants() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'participants');
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QDistinct> distinctByRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rate');
    });
  }

  QueryBuilder<IsarReceivable, IsarReceivable, QDistinct>
      distinctByReceivableId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'receivableId', caseSensitive: caseSensitive);
    });
  }
}

extension IsarReceivableQueryProperty
    on QueryBuilder<IsarReceivable, IsarReceivable, QQueryProperty> {
  QueryBuilder<IsarReceivable, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<IsarReceivable, DateTime?, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<IsarReceivable, String?, QQueryOperations>
      descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'description');
    });
  }

  QueryBuilder<IsarReceivable, List<bool>, QQueryOperations> isPaidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isPaid');
    });
  }

  QueryBuilder<IsarReceivable, List<bool>, QQueryOperations>
      isReceivedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isReceived');
    });
  }

  QueryBuilder<IsarReceivable, String?, QQueryOperations> methodProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'method');
    });
  }

  QueryBuilder<IsarReceivable, List<String>, QQueryOperations>
      participantsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'participants');
    });
  }

  QueryBuilder<IsarReceivable, List<double>, QQueryOperations> rateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rate');
    });
  }

  QueryBuilder<IsarReceivable, String?, QQueryOperations>
      receivableIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'receivableId');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetIsarStatusCollection on Isar {
  IsarCollection<IsarStatus> get isarStatus => this.collection();
}

const IsarStatusSchema = CollectionSchema(
  name: r'IsarStatus',
  id: 2802014095801570202,
  properties: {
    r'lastTimeUpdatedFirebase': PropertySchema(
      id: 0,
      name: r'lastTimeUpdatedFirebase',
      type: IsarType.dateTime,
    ),
    r'lastTimeUpdatedIsar': PropertySchema(
      id: 1,
      name: r'lastTimeUpdatedIsar',
      type: IsarType.dateTime,
    ),
    r'receivableId': PropertySchema(
      id: 2,
      name: r'receivableId',
      type: IsarType.string,
    )
  },
  estimateSize: _isarStatusEstimateSize,
  serialize: _isarStatusSerialize,
  deserialize: _isarStatusDeserialize,
  deserializeProp: _isarStatusDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _isarStatusGetId,
  getLinks: _isarStatusGetLinks,
  attach: _isarStatusAttach,
  version: '3.1.0+1',
);

int _isarStatusEstimateSize(
  IsarStatus object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.receivableId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _isarStatusSerialize(
  IsarStatus object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.lastTimeUpdatedFirebase);
  writer.writeDateTime(offsets[1], object.lastTimeUpdatedIsar);
  writer.writeString(offsets[2], object.receivableId);
}

IsarStatus _isarStatusDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = IsarStatus();
  object.id = id;
  object.lastTimeUpdatedFirebase = reader.readDateTimeOrNull(offsets[0]);
  object.lastTimeUpdatedIsar = reader.readDateTimeOrNull(offsets[1]);
  object.receivableId = reader.readStringOrNull(offsets[2]);
  return object;
}

P _isarStatusDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 1:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _isarStatusGetId(IsarStatus object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _isarStatusGetLinks(IsarStatus object) {
  return [];
}

void _isarStatusAttach(IsarCollection<dynamic> col, Id id, IsarStatus object) {
  object.id = id;
}

extension IsarStatusQueryWhereSort
    on QueryBuilder<IsarStatus, IsarStatus, QWhere> {
  QueryBuilder<IsarStatus, IsarStatus, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension IsarStatusQueryWhere
    on QueryBuilder<IsarStatus, IsarStatus, QWhereClause> {
  QueryBuilder<IsarStatus, IsarStatus, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<IsarStatus, IsarStatus, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<IsarStatus, IsarStatus, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<IsarStatus, IsarStatus, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<IsarStatus, IsarStatus, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension IsarStatusQueryFilter
    on QueryBuilder<IsarStatus, IsarStatus, QFilterCondition> {
  QueryBuilder<IsarStatus, IsarStatus, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarStatus, IsarStatus, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarStatus, IsarStatus, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarStatus, IsarStatus, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarStatus, IsarStatus, QAfterFilterCondition>
      lastTimeUpdatedFirebaseIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastTimeUpdatedFirebase',
      ));
    });
  }

  QueryBuilder<IsarStatus, IsarStatus, QAfterFilterCondition>
      lastTimeUpdatedFirebaseIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastTimeUpdatedFirebase',
      ));
    });
  }

  QueryBuilder<IsarStatus, IsarStatus, QAfterFilterCondition>
      lastTimeUpdatedFirebaseEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastTimeUpdatedFirebase',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarStatus, IsarStatus, QAfterFilterCondition>
      lastTimeUpdatedFirebaseGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastTimeUpdatedFirebase',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarStatus, IsarStatus, QAfterFilterCondition>
      lastTimeUpdatedFirebaseLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastTimeUpdatedFirebase',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarStatus, IsarStatus, QAfterFilterCondition>
      lastTimeUpdatedFirebaseBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastTimeUpdatedFirebase',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarStatus, IsarStatus, QAfterFilterCondition>
      lastTimeUpdatedIsarIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastTimeUpdatedIsar',
      ));
    });
  }

  QueryBuilder<IsarStatus, IsarStatus, QAfterFilterCondition>
      lastTimeUpdatedIsarIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastTimeUpdatedIsar',
      ));
    });
  }

  QueryBuilder<IsarStatus, IsarStatus, QAfterFilterCondition>
      lastTimeUpdatedIsarEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastTimeUpdatedIsar',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarStatus, IsarStatus, QAfterFilterCondition>
      lastTimeUpdatedIsarGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastTimeUpdatedIsar',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarStatus, IsarStatus, QAfterFilterCondition>
      lastTimeUpdatedIsarLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastTimeUpdatedIsar',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarStatus, IsarStatus, QAfterFilterCondition>
      lastTimeUpdatedIsarBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastTimeUpdatedIsar',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarStatus, IsarStatus, QAfterFilterCondition>
      receivableIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'receivableId',
      ));
    });
  }

  QueryBuilder<IsarStatus, IsarStatus, QAfterFilterCondition>
      receivableIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'receivableId',
      ));
    });
  }

  QueryBuilder<IsarStatus, IsarStatus, QAfterFilterCondition>
      receivableIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'receivableId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarStatus, IsarStatus, QAfterFilterCondition>
      receivableIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'receivableId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarStatus, IsarStatus, QAfterFilterCondition>
      receivableIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'receivableId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarStatus, IsarStatus, QAfterFilterCondition>
      receivableIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'receivableId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarStatus, IsarStatus, QAfterFilterCondition>
      receivableIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'receivableId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarStatus, IsarStatus, QAfterFilterCondition>
      receivableIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'receivableId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarStatus, IsarStatus, QAfterFilterCondition>
      receivableIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'receivableId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarStatus, IsarStatus, QAfterFilterCondition>
      receivableIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'receivableId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarStatus, IsarStatus, QAfterFilterCondition>
      receivableIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'receivableId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarStatus, IsarStatus, QAfterFilterCondition>
      receivableIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'receivableId',
        value: '',
      ));
    });
  }
}

extension IsarStatusQueryObject
    on QueryBuilder<IsarStatus, IsarStatus, QFilterCondition> {}

extension IsarStatusQueryLinks
    on QueryBuilder<IsarStatus, IsarStatus, QFilterCondition> {}

extension IsarStatusQuerySortBy
    on QueryBuilder<IsarStatus, IsarStatus, QSortBy> {
  QueryBuilder<IsarStatus, IsarStatus, QAfterSortBy>
      sortByLastTimeUpdatedFirebase() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastTimeUpdatedFirebase', Sort.asc);
    });
  }

  QueryBuilder<IsarStatus, IsarStatus, QAfterSortBy>
      sortByLastTimeUpdatedFirebaseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastTimeUpdatedFirebase', Sort.desc);
    });
  }

  QueryBuilder<IsarStatus, IsarStatus, QAfterSortBy>
      sortByLastTimeUpdatedIsar() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastTimeUpdatedIsar', Sort.asc);
    });
  }

  QueryBuilder<IsarStatus, IsarStatus, QAfterSortBy>
      sortByLastTimeUpdatedIsarDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastTimeUpdatedIsar', Sort.desc);
    });
  }

  QueryBuilder<IsarStatus, IsarStatus, QAfterSortBy> sortByReceivableId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receivableId', Sort.asc);
    });
  }

  QueryBuilder<IsarStatus, IsarStatus, QAfterSortBy> sortByReceivableIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receivableId', Sort.desc);
    });
  }
}

extension IsarStatusQuerySortThenBy
    on QueryBuilder<IsarStatus, IsarStatus, QSortThenBy> {
  QueryBuilder<IsarStatus, IsarStatus, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<IsarStatus, IsarStatus, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<IsarStatus, IsarStatus, QAfterSortBy>
      thenByLastTimeUpdatedFirebase() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastTimeUpdatedFirebase', Sort.asc);
    });
  }

  QueryBuilder<IsarStatus, IsarStatus, QAfterSortBy>
      thenByLastTimeUpdatedFirebaseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastTimeUpdatedFirebase', Sort.desc);
    });
  }

  QueryBuilder<IsarStatus, IsarStatus, QAfterSortBy>
      thenByLastTimeUpdatedIsar() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastTimeUpdatedIsar', Sort.asc);
    });
  }

  QueryBuilder<IsarStatus, IsarStatus, QAfterSortBy>
      thenByLastTimeUpdatedIsarDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastTimeUpdatedIsar', Sort.desc);
    });
  }

  QueryBuilder<IsarStatus, IsarStatus, QAfterSortBy> thenByReceivableId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receivableId', Sort.asc);
    });
  }

  QueryBuilder<IsarStatus, IsarStatus, QAfterSortBy> thenByReceivableIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receivableId', Sort.desc);
    });
  }
}

extension IsarStatusQueryWhereDistinct
    on QueryBuilder<IsarStatus, IsarStatus, QDistinct> {
  QueryBuilder<IsarStatus, IsarStatus, QDistinct>
      distinctByLastTimeUpdatedFirebase() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastTimeUpdatedFirebase');
    });
  }

  QueryBuilder<IsarStatus, IsarStatus, QDistinct>
      distinctByLastTimeUpdatedIsar() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastTimeUpdatedIsar');
    });
  }

  QueryBuilder<IsarStatus, IsarStatus, QDistinct> distinctByReceivableId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'receivableId', caseSensitive: caseSensitive);
    });
  }
}

extension IsarStatusQueryProperty
    on QueryBuilder<IsarStatus, IsarStatus, QQueryProperty> {
  QueryBuilder<IsarStatus, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<IsarStatus, DateTime?, QQueryOperations>
      lastTimeUpdatedFirebaseProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastTimeUpdatedFirebase');
    });
  }

  QueryBuilder<IsarStatus, DateTime?, QQueryOperations>
      lastTimeUpdatedIsarProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastTimeUpdatedIsar');
    });
  }

  QueryBuilder<IsarStatus, String?, QQueryOperations> receivableIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'receivableId');
    });
  }
}
