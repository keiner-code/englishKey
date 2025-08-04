// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sentences.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSentencesCollection on Isar {
  IsarCollection<Sentences> get sentences => this.collection();
}

const SentencesSchema = CollectionSchema(
  name: r'Sentences',
  id: 4441739973652547188,
  properties: {
    r'available': PropertySchema(
      id: 0,
      name: r'available',
      type: IsarType.bool,
    ),
    r'iconString': PropertySchema(
      id: 1,
      name: r'iconString',
      type: IsarType.string,
    ),
    r'idPadre': PropertySchema(
      id: 2,
      name: r'idPadre',
      type: IsarType.long,
    ),
    r'isItem': PropertySchema(
      id: 3,
      name: r'isItem',
      type: IsarType.bool,
    ),
    r'isSelected': PropertySchema(
      id: 4,
      name: r'isSelected',
      type: IsarType.bool,
    ),
    r'sentence': PropertySchema(
      id: 5,
      name: r'sentence',
      type: IsarType.string,
    )
  },
  estimateSize: _sentencesEstimateSize,
  serialize: _sentencesSerialize,
  deserialize: _sentencesDeserialize,
  deserializeProp: _sentencesDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _sentencesGetId,
  getLinks: _sentencesGetLinks,
  attach: _sentencesAttach,
  version: '3.1.0+1',
);

int _sentencesEstimateSize(
  Sentences object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.iconString;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.sentence.length * 3;
  return bytesCount;
}

void _sentencesSerialize(
  Sentences object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.available);
  writer.writeString(offsets[1], object.iconString);
  writer.writeLong(offsets[2], object.idPadre);
  writer.writeBool(offsets[3], object.isItem);
  writer.writeBool(offsets[4], object.isSelected);
  writer.writeString(offsets[5], object.sentence);
}

Sentences _sentencesDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Sentences(
    available: reader.readBoolOrNull(offsets[0]) ?? true,
    iconString: reader.readStringOrNull(offsets[1]),
    id: id,
    idPadre: reader.readLongOrNull(offsets[2]),
    isItem: reader.readBool(offsets[3]),
    isSelected: reader.readBoolOrNull(offsets[4]) ?? false,
    sentence: reader.readString(offsets[5]),
  );
  return object;
}

P _sentencesDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBoolOrNull(offset) ?? true) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readLongOrNull(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 5:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _sentencesGetId(Sentences object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _sentencesGetLinks(Sentences object) {
  return [];
}

void _sentencesAttach(IsarCollection<dynamic> col, Id id, Sentences object) {
  object.id = id;
}

extension SentencesQueryWhereSort
    on QueryBuilder<Sentences, Sentences, QWhere> {
  QueryBuilder<Sentences, Sentences, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension SentencesQueryWhere
    on QueryBuilder<Sentences, Sentences, QWhereClause> {
  QueryBuilder<Sentences, Sentences, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Sentences, Sentences, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Sentences, Sentences, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Sentences, Sentences, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Sentences, Sentences, QAfterWhereClause> idBetween(
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

extension SentencesQueryFilter
    on QueryBuilder<Sentences, Sentences, QFilterCondition> {
  QueryBuilder<Sentences, Sentences, QAfterFilterCondition> availableEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'available',
        value: value,
      ));
    });
  }

  QueryBuilder<Sentences, Sentences, QAfterFilterCondition> iconStringIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'iconString',
      ));
    });
  }

  QueryBuilder<Sentences, Sentences, QAfterFilterCondition>
      iconStringIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'iconString',
      ));
    });
  }

  QueryBuilder<Sentences, Sentences, QAfterFilterCondition> iconStringEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'iconString',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sentences, Sentences, QAfterFilterCondition>
      iconStringGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'iconString',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sentences, Sentences, QAfterFilterCondition> iconStringLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'iconString',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sentences, Sentences, QAfterFilterCondition> iconStringBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'iconString',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sentences, Sentences, QAfterFilterCondition>
      iconStringStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'iconString',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sentences, Sentences, QAfterFilterCondition> iconStringEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'iconString',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sentences, Sentences, QAfterFilterCondition> iconStringContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'iconString',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sentences, Sentences, QAfterFilterCondition> iconStringMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'iconString',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sentences, Sentences, QAfterFilterCondition>
      iconStringIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'iconString',
        value: '',
      ));
    });
  }

  QueryBuilder<Sentences, Sentences, QAfterFilterCondition>
      iconStringIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'iconString',
        value: '',
      ));
    });
  }

  QueryBuilder<Sentences, Sentences, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<Sentences, Sentences, QAfterFilterCondition> idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<Sentences, Sentences, QAfterFilterCondition> idEqualTo(
      Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Sentences, Sentences, QAfterFilterCondition> idGreaterThan(
    Id? value, {
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

  QueryBuilder<Sentences, Sentences, QAfterFilterCondition> idLessThan(
    Id? value, {
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

  QueryBuilder<Sentences, Sentences, QAfterFilterCondition> idBetween(
    Id? lower,
    Id? upper, {
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

  QueryBuilder<Sentences, Sentences, QAfterFilterCondition> idPadreIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'idPadre',
      ));
    });
  }

  QueryBuilder<Sentences, Sentences, QAfterFilterCondition> idPadreIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'idPadre',
      ));
    });
  }

  QueryBuilder<Sentences, Sentences, QAfterFilterCondition> idPadreEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'idPadre',
        value: value,
      ));
    });
  }

  QueryBuilder<Sentences, Sentences, QAfterFilterCondition> idPadreGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'idPadre',
        value: value,
      ));
    });
  }

  QueryBuilder<Sentences, Sentences, QAfterFilterCondition> idPadreLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'idPadre',
        value: value,
      ));
    });
  }

  QueryBuilder<Sentences, Sentences, QAfterFilterCondition> idPadreBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'idPadre',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Sentences, Sentences, QAfterFilterCondition> isItemEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isItem',
        value: value,
      ));
    });
  }

  QueryBuilder<Sentences, Sentences, QAfterFilterCondition> isSelectedEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isSelected',
        value: value,
      ));
    });
  }

  QueryBuilder<Sentences, Sentences, QAfterFilterCondition> sentenceEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sentence',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sentences, Sentences, QAfterFilterCondition> sentenceGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sentence',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sentences, Sentences, QAfterFilterCondition> sentenceLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sentence',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sentences, Sentences, QAfterFilterCondition> sentenceBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sentence',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sentences, Sentences, QAfterFilterCondition> sentenceStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'sentence',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sentences, Sentences, QAfterFilterCondition> sentenceEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'sentence',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sentences, Sentences, QAfterFilterCondition> sentenceContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'sentence',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sentences, Sentences, QAfterFilterCondition> sentenceMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'sentence',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Sentences, Sentences, QAfterFilterCondition> sentenceIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sentence',
        value: '',
      ));
    });
  }

  QueryBuilder<Sentences, Sentences, QAfterFilterCondition>
      sentenceIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'sentence',
        value: '',
      ));
    });
  }
}

extension SentencesQueryObject
    on QueryBuilder<Sentences, Sentences, QFilterCondition> {}

extension SentencesQueryLinks
    on QueryBuilder<Sentences, Sentences, QFilterCondition> {}

extension SentencesQuerySortBy on QueryBuilder<Sentences, Sentences, QSortBy> {
  QueryBuilder<Sentences, Sentences, QAfterSortBy> sortByAvailable() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'available', Sort.asc);
    });
  }

  QueryBuilder<Sentences, Sentences, QAfterSortBy> sortByAvailableDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'available', Sort.desc);
    });
  }

  QueryBuilder<Sentences, Sentences, QAfterSortBy> sortByIconString() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iconString', Sort.asc);
    });
  }

  QueryBuilder<Sentences, Sentences, QAfterSortBy> sortByIconStringDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iconString', Sort.desc);
    });
  }

  QueryBuilder<Sentences, Sentences, QAfterSortBy> sortByIdPadre() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idPadre', Sort.asc);
    });
  }

  QueryBuilder<Sentences, Sentences, QAfterSortBy> sortByIdPadreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idPadre', Sort.desc);
    });
  }

  QueryBuilder<Sentences, Sentences, QAfterSortBy> sortByIsItem() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isItem', Sort.asc);
    });
  }

  QueryBuilder<Sentences, Sentences, QAfterSortBy> sortByIsItemDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isItem', Sort.desc);
    });
  }

  QueryBuilder<Sentences, Sentences, QAfterSortBy> sortByIsSelected() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSelected', Sort.asc);
    });
  }

  QueryBuilder<Sentences, Sentences, QAfterSortBy> sortByIsSelectedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSelected', Sort.desc);
    });
  }

  QueryBuilder<Sentences, Sentences, QAfterSortBy> sortBySentence() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sentence', Sort.asc);
    });
  }

  QueryBuilder<Sentences, Sentences, QAfterSortBy> sortBySentenceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sentence', Sort.desc);
    });
  }
}

extension SentencesQuerySortThenBy
    on QueryBuilder<Sentences, Sentences, QSortThenBy> {
  QueryBuilder<Sentences, Sentences, QAfterSortBy> thenByAvailable() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'available', Sort.asc);
    });
  }

  QueryBuilder<Sentences, Sentences, QAfterSortBy> thenByAvailableDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'available', Sort.desc);
    });
  }

  QueryBuilder<Sentences, Sentences, QAfterSortBy> thenByIconString() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iconString', Sort.asc);
    });
  }

  QueryBuilder<Sentences, Sentences, QAfterSortBy> thenByIconStringDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iconString', Sort.desc);
    });
  }

  QueryBuilder<Sentences, Sentences, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Sentences, Sentences, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Sentences, Sentences, QAfterSortBy> thenByIdPadre() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idPadre', Sort.asc);
    });
  }

  QueryBuilder<Sentences, Sentences, QAfterSortBy> thenByIdPadreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'idPadre', Sort.desc);
    });
  }

  QueryBuilder<Sentences, Sentences, QAfterSortBy> thenByIsItem() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isItem', Sort.asc);
    });
  }

  QueryBuilder<Sentences, Sentences, QAfterSortBy> thenByIsItemDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isItem', Sort.desc);
    });
  }

  QueryBuilder<Sentences, Sentences, QAfterSortBy> thenByIsSelected() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSelected', Sort.asc);
    });
  }

  QueryBuilder<Sentences, Sentences, QAfterSortBy> thenByIsSelectedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSelected', Sort.desc);
    });
  }

  QueryBuilder<Sentences, Sentences, QAfterSortBy> thenBySentence() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sentence', Sort.asc);
    });
  }

  QueryBuilder<Sentences, Sentences, QAfterSortBy> thenBySentenceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sentence', Sort.desc);
    });
  }
}

extension SentencesQueryWhereDistinct
    on QueryBuilder<Sentences, Sentences, QDistinct> {
  QueryBuilder<Sentences, Sentences, QDistinct> distinctByAvailable() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'available');
    });
  }

  QueryBuilder<Sentences, Sentences, QDistinct> distinctByIconString(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'iconString', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Sentences, Sentences, QDistinct> distinctByIdPadre() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'idPadre');
    });
  }

  QueryBuilder<Sentences, Sentences, QDistinct> distinctByIsItem() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isItem');
    });
  }

  QueryBuilder<Sentences, Sentences, QDistinct> distinctByIsSelected() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isSelected');
    });
  }

  QueryBuilder<Sentences, Sentences, QDistinct> distinctBySentence(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sentence', caseSensitive: caseSensitive);
    });
  }
}

extension SentencesQueryProperty
    on QueryBuilder<Sentences, Sentences, QQueryProperty> {
  QueryBuilder<Sentences, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Sentences, bool, QQueryOperations> availableProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'available');
    });
  }

  QueryBuilder<Sentences, String?, QQueryOperations> iconStringProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'iconString');
    });
  }

  QueryBuilder<Sentences, int?, QQueryOperations> idPadreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'idPadre');
    });
  }

  QueryBuilder<Sentences, bool, QQueryOperations> isItemProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isItem');
    });
  }

  QueryBuilder<Sentences, bool, QQueryOperations> isSelectedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isSelected');
    });
  }

  QueryBuilder<Sentences, String, QQueryOperations> sentenceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sentence');
    });
  }
}
