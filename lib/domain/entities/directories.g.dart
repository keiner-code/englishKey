// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'directories.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDirectoriesCollection on Isar {
  IsarCollection<Directories> get directories => this.collection();
}

const DirectoriesSchema = CollectionSchema(
  name: r'Directories',
  id: -1946906712518721040,
  properties: {
    r'directoryPath': PropertySchema(
      id: 0,
      name: r'directoryPath',
      type: IsarType.string,
    )
  },
  estimateSize: _directoriesEstimateSize,
  serialize: _directoriesSerialize,
  deserialize: _directoriesDeserialize,
  deserializeProp: _directoriesDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _directoriesGetId,
  getLinks: _directoriesGetLinks,
  attach: _directoriesAttach,
  version: '3.1.0+1',
);

int _directoriesEstimateSize(
  Directories object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.directoryPath;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _directoriesSerialize(
  Directories object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.directoryPath);
}

Directories _directoriesDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Directories(
    directoryPath: reader.readStringOrNull(offsets[0]),
    id: id,
  );
  return object;
}

P _directoriesDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _directoriesGetId(Directories object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _directoriesGetLinks(Directories object) {
  return [];
}

void _directoriesAttach(
    IsarCollection<dynamic> col, Id id, Directories object) {
  object.id = id;
}

extension DirectoriesQueryWhereSort
    on QueryBuilder<Directories, Directories, QWhere> {
  QueryBuilder<Directories, Directories, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension DirectoriesQueryWhere
    on QueryBuilder<Directories, Directories, QWhereClause> {
  QueryBuilder<Directories, Directories, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Directories, Directories, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<Directories, Directories, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Directories, Directories, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Directories, Directories, QAfterWhereClause> idBetween(
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

extension DirectoriesQueryFilter
    on QueryBuilder<Directories, Directories, QFilterCondition> {
  QueryBuilder<Directories, Directories, QAfterFilterCondition>
      directoryPathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'directoryPath',
      ));
    });
  }

  QueryBuilder<Directories, Directories, QAfterFilterCondition>
      directoryPathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'directoryPath',
      ));
    });
  }

  QueryBuilder<Directories, Directories, QAfterFilterCondition>
      directoryPathEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'directoryPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Directories, Directories, QAfterFilterCondition>
      directoryPathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'directoryPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Directories, Directories, QAfterFilterCondition>
      directoryPathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'directoryPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Directories, Directories, QAfterFilterCondition>
      directoryPathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'directoryPath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Directories, Directories, QAfterFilterCondition>
      directoryPathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'directoryPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Directories, Directories, QAfterFilterCondition>
      directoryPathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'directoryPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Directories, Directories, QAfterFilterCondition>
      directoryPathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'directoryPath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Directories, Directories, QAfterFilterCondition>
      directoryPathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'directoryPath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Directories, Directories, QAfterFilterCondition>
      directoryPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'directoryPath',
        value: '',
      ));
    });
  }

  QueryBuilder<Directories, Directories, QAfterFilterCondition>
      directoryPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'directoryPath',
        value: '',
      ));
    });
  }

  QueryBuilder<Directories, Directories, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<Directories, Directories, QAfterFilterCondition> idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<Directories, Directories, QAfterFilterCondition> idEqualTo(
      Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Directories, Directories, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Directories, Directories, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Directories, Directories, QAfterFilterCondition> idBetween(
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
}

extension DirectoriesQueryObject
    on QueryBuilder<Directories, Directories, QFilterCondition> {}

extension DirectoriesQueryLinks
    on QueryBuilder<Directories, Directories, QFilterCondition> {}

extension DirectoriesQuerySortBy
    on QueryBuilder<Directories, Directories, QSortBy> {
  QueryBuilder<Directories, Directories, QAfterSortBy> sortByDirectoryPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'directoryPath', Sort.asc);
    });
  }

  QueryBuilder<Directories, Directories, QAfterSortBy>
      sortByDirectoryPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'directoryPath', Sort.desc);
    });
  }
}

extension DirectoriesQuerySortThenBy
    on QueryBuilder<Directories, Directories, QSortThenBy> {
  QueryBuilder<Directories, Directories, QAfterSortBy> thenByDirectoryPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'directoryPath', Sort.asc);
    });
  }

  QueryBuilder<Directories, Directories, QAfterSortBy>
      thenByDirectoryPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'directoryPath', Sort.desc);
    });
  }

  QueryBuilder<Directories, Directories, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Directories, Directories, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }
}

extension DirectoriesQueryWhereDistinct
    on QueryBuilder<Directories, Directories, QDistinct> {
  QueryBuilder<Directories, Directories, QDistinct> distinctByDirectoryPath(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'directoryPath',
          caseSensitive: caseSensitive);
    });
  }
}

extension DirectoriesQueryProperty
    on QueryBuilder<Directories, Directories, QQueryProperty> {
  QueryBuilder<Directories, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Directories, String?, QQueryOperations> directoryPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'directoryPath');
    });
  }
}
