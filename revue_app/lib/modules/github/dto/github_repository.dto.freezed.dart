// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'github_repository.dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$GithubRepositoryDto {
  Repository get repository => throw _privateConstructorUsedError;
  List<GitHubFile> get files => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $GithubRepositoryDtoCopyWith<GithubRepositoryDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GithubRepositoryDtoCopyWith<$Res> {
  factory $GithubRepositoryDtoCopyWith(
          GithubRepositoryDto value, $Res Function(GithubRepositoryDto) then) =
      _$GithubRepositoryDtoCopyWithImpl<$Res, GithubRepositoryDto>;
  @useResult
  $Res call({Repository repository, List<GitHubFile> files});
}

/// @nodoc
class _$GithubRepositoryDtoCopyWithImpl<$Res, $Val extends GithubRepositoryDto>
    implements $GithubRepositoryDtoCopyWith<$Res> {
  _$GithubRepositoryDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? repository = null,
    Object? files = null,
  }) {
    return _then(_value.copyWith(
      repository: null == repository
          ? _value.repository
          : repository // ignore: cast_nullable_to_non_nullable
              as Repository,
      files: null == files
          ? _value.files
          : files // ignore: cast_nullable_to_non_nullable
              as List<GitHubFile>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_GithubRepositoryDtoCopyWith<$Res>
    implements $GithubRepositoryDtoCopyWith<$Res> {
  factory _$$_GithubRepositoryDtoCopyWith(_$_GithubRepositoryDto value,
          $Res Function(_$_GithubRepositoryDto) then) =
      __$$_GithubRepositoryDtoCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Repository repository, List<GitHubFile> files});
}

/// @nodoc
class __$$_GithubRepositoryDtoCopyWithImpl<$Res>
    extends _$GithubRepositoryDtoCopyWithImpl<$Res, _$_GithubRepositoryDto>
    implements _$$_GithubRepositoryDtoCopyWith<$Res> {
  __$$_GithubRepositoryDtoCopyWithImpl(_$_GithubRepositoryDto _value,
      $Res Function(_$_GithubRepositoryDto) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? repository = null,
    Object? files = null,
  }) {
    return _then(_$_GithubRepositoryDto(
      repository: null == repository
          ? _value.repository
          : repository // ignore: cast_nullable_to_non_nullable
              as Repository,
      files: null == files
          ? _value._files
          : files // ignore: cast_nullable_to_non_nullable
              as List<GitHubFile>,
    ));
  }
}

/// @nodoc

class _$_GithubRepositoryDto implements _GithubRepositoryDto {
  const _$_GithubRepositoryDto(
      {required this.repository, required final List<GitHubFile> files})
      : _files = files;

  @override
  final Repository repository;
  final List<GitHubFile> _files;
  @override
  List<GitHubFile> get files {
    if (_files is EqualUnmodifiableListView) return _files;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_files);
  }

  @override
  String toString() {
    return 'GithubRepositoryDto(repository: $repository, files: $files)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_GithubRepositoryDto &&
            (identical(other.repository, repository) ||
                other.repository == repository) &&
            const DeepCollectionEquality().equals(other._files, _files));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, repository, const DeepCollectionEquality().hash(_files));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_GithubRepositoryDtoCopyWith<_$_GithubRepositoryDto> get copyWith =>
      __$$_GithubRepositoryDtoCopyWithImpl<_$_GithubRepositoryDto>(
          this, _$identity);
}

abstract class _GithubRepositoryDto implements GithubRepositoryDto {
  const factory _GithubRepositoryDto(
      {required final Repository repository,
      required final List<GitHubFile> files}) = _$_GithubRepositoryDto;

  @override
  Repository get repository;
  @override
  List<GitHubFile> get files;
  @override
  @JsonKey(ignore: true)
  _$$_GithubRepositoryDtoCopyWith<_$_GithubRepositoryDto> get copyWith =>
      throw _privateConstructorUsedError;
}
