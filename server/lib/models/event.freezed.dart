// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Event {
  @JsonKey(name: '_id')
  String get id;
  String get calendarId;
  String? get baseEventId; // For recurring event instances
  String get title;
  String get description;
  String get location;
  DateTime get startDateTime;
  DateTime get endDateTime;
  bool get allDay;
  String get timezone;
  String? get recurrenceRule; // RRULE string
  bool get isException;
  DateTime? get recurrenceExceptionDate;
  List<Map<String, dynamic>> get reminders;
  DateTime get createdAt;
  DateTime get updatedAt;
  DateTime? get deletedAt;

  /// Create a copy of Event
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $EventCopyWith<Event> get copyWith =>
      _$EventCopyWithImpl<Event>(this as Event, _$identity);

  /// Serializes this Event to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Event &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.calendarId, calendarId) ||
                other.calendarId == calendarId) &&
            (identical(other.baseEventId, baseEventId) ||
                other.baseEventId == baseEventId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.startDateTime, startDateTime) ||
                other.startDateTime == startDateTime) &&
            (identical(other.endDateTime, endDateTime) ||
                other.endDateTime == endDateTime) &&
            (identical(other.allDay, allDay) || other.allDay == allDay) &&
            (identical(other.timezone, timezone) ||
                other.timezone == timezone) &&
            (identical(other.recurrenceRule, recurrenceRule) ||
                other.recurrenceRule == recurrenceRule) &&
            (identical(other.isException, isException) ||
                other.isException == isException) &&
            (identical(
                    other.recurrenceExceptionDate, recurrenceExceptionDate) ||
                other.recurrenceExceptionDate == recurrenceExceptionDate) &&
            const DeepCollectionEquality().equals(other.reminders, reminders) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      calendarId,
      baseEventId,
      title,
      description,
      location,
      startDateTime,
      endDateTime,
      allDay,
      timezone,
      recurrenceRule,
      isException,
      recurrenceExceptionDate,
      const DeepCollectionEquality().hash(reminders),
      createdAt,
      updatedAt,
      deletedAt);

  @override
  String toString() {
    return 'Event(id: $id, calendarId: $calendarId, baseEventId: $baseEventId, title: $title, description: $description, location: $location, startDateTime: $startDateTime, endDateTime: $endDateTime, allDay: $allDay, timezone: $timezone, recurrenceRule: $recurrenceRule, isException: $isException, recurrenceExceptionDate: $recurrenceExceptionDate, reminders: $reminders, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
  }
}

/// @nodoc
abstract mixin class $EventCopyWith<$Res> {
  factory $EventCopyWith(Event value, $Res Function(Event) _then) =
      _$EventCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String id,
      String calendarId,
      String? baseEventId,
      String title,
      String description,
      String location,
      DateTime startDateTime,
      DateTime endDateTime,
      bool allDay,
      String timezone,
      String? recurrenceRule,
      bool isException,
      DateTime? recurrenceExceptionDate,
      List<Map<String, dynamic>> reminders,
      DateTime createdAt,
      DateTime updatedAt,
      DateTime? deletedAt});
}

/// @nodoc
class _$EventCopyWithImpl<$Res> implements $EventCopyWith<$Res> {
  _$EventCopyWithImpl(this._self, this._then);

  final Event _self;
  final $Res Function(Event) _then;

  /// Create a copy of Event
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? calendarId = null,
    Object? baseEventId = freezed,
    Object? title = null,
    Object? description = null,
    Object? location = null,
    Object? startDateTime = null,
    Object? endDateTime = null,
    Object? allDay = null,
    Object? timezone = null,
    Object? recurrenceRule = freezed,
    Object? isException = null,
    Object? recurrenceExceptionDate = freezed,
    Object? reminders = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? deletedAt = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      calendarId: null == calendarId
          ? _self.calendarId
          : calendarId // ignore: cast_nullable_to_non_nullable
              as String,
      baseEventId: freezed == baseEventId
          ? _self.baseEventId
          : baseEventId // ignore: cast_nullable_to_non_nullable
              as String?,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      location: null == location
          ? _self.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      startDateTime: null == startDateTime
          ? _self.startDateTime
          : startDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDateTime: null == endDateTime
          ? _self.endDateTime
          : endDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      allDay: null == allDay
          ? _self.allDay
          : allDay // ignore: cast_nullable_to_non_nullable
              as bool,
      timezone: null == timezone
          ? _self.timezone
          : timezone // ignore: cast_nullable_to_non_nullable
              as String,
      recurrenceRule: freezed == recurrenceRule
          ? _self.recurrenceRule
          : recurrenceRule // ignore: cast_nullable_to_non_nullable
              as String?,
      isException: null == isException
          ? _self.isException
          : isException // ignore: cast_nullable_to_non_nullable
              as bool,
      recurrenceExceptionDate: freezed == recurrenceExceptionDate
          ? _self.recurrenceExceptionDate
          : recurrenceExceptionDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      reminders: null == reminders
          ? _self.reminders
          : reminders // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      deletedAt: freezed == deletedAt
          ? _self.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// Adds pattern-matching-related methods to [Event].
extension EventPatterns on Event {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_Event value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Event() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_Event value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Event():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_Event value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Event() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            @JsonKey(name: '_id') String id,
            String calendarId,
            String? baseEventId,
            String title,
            String description,
            String location,
            DateTime startDateTime,
            DateTime endDateTime,
            bool allDay,
            String timezone,
            String? recurrenceRule,
            bool isException,
            DateTime? recurrenceExceptionDate,
            List<Map<String, dynamic>> reminders,
            DateTime createdAt,
            DateTime updatedAt,
            DateTime? deletedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Event() when $default != null:
        return $default(
            _that.id,
            _that.calendarId,
            _that.baseEventId,
            _that.title,
            _that.description,
            _that.location,
            _that.startDateTime,
            _that.endDateTime,
            _that.allDay,
            _that.timezone,
            _that.recurrenceRule,
            _that.isException,
            _that.recurrenceExceptionDate,
            _that.reminders,
            _that.createdAt,
            _that.updatedAt,
            _that.deletedAt);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            @JsonKey(name: '_id') String id,
            String calendarId,
            String? baseEventId,
            String title,
            String description,
            String location,
            DateTime startDateTime,
            DateTime endDateTime,
            bool allDay,
            String timezone,
            String? recurrenceRule,
            bool isException,
            DateTime? recurrenceExceptionDate,
            List<Map<String, dynamic>> reminders,
            DateTime createdAt,
            DateTime updatedAt,
            DateTime? deletedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Event():
        return $default(
            _that.id,
            _that.calendarId,
            _that.baseEventId,
            _that.title,
            _that.description,
            _that.location,
            _that.startDateTime,
            _that.endDateTime,
            _that.allDay,
            _that.timezone,
            _that.recurrenceRule,
            _that.isException,
            _that.recurrenceExceptionDate,
            _that.reminders,
            _that.createdAt,
            _that.updatedAt,
            _that.deletedAt);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            @JsonKey(name: '_id') String id,
            String calendarId,
            String? baseEventId,
            String title,
            String description,
            String location,
            DateTime startDateTime,
            DateTime endDateTime,
            bool allDay,
            String timezone,
            String? recurrenceRule,
            bool isException,
            DateTime? recurrenceExceptionDate,
            List<Map<String, dynamic>> reminders,
            DateTime createdAt,
            DateTime updatedAt,
            DateTime? deletedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Event() when $default != null:
        return $default(
            _that.id,
            _that.calendarId,
            _that.baseEventId,
            _that.title,
            _that.description,
            _that.location,
            _that.startDateTime,
            _that.endDateTime,
            _that.allDay,
            _that.timezone,
            _that.recurrenceRule,
            _that.isException,
            _that.recurrenceExceptionDate,
            _that.reminders,
            _that.createdAt,
            _that.updatedAt,
            _that.deletedAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _Event implements Event {
  const _Event(
      {@JsonKey(name: '_id') required this.id,
      required this.calendarId,
      this.baseEventId,
      required this.title,
      this.description = '',
      this.location = '',
      required this.startDateTime,
      required this.endDateTime,
      this.allDay = false,
      this.timezone = 'UTC',
      this.recurrenceRule,
      this.isException = false,
      this.recurrenceExceptionDate,
      final List<Map<String, dynamic>> reminders = const [],
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt})
      : _reminders = reminders;
  factory _Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  final String calendarId;
  @override
  final String? baseEventId;
// For recurring event instances
  @override
  final String title;
  @override
  @JsonKey()
  final String description;
  @override
  @JsonKey()
  final String location;
  @override
  final DateTime startDateTime;
  @override
  final DateTime endDateTime;
  @override
  @JsonKey()
  final bool allDay;
  @override
  @JsonKey()
  final String timezone;
  @override
  final String? recurrenceRule;
// RRULE string
  @override
  @JsonKey()
  final bool isException;
  @override
  final DateTime? recurrenceExceptionDate;
  final List<Map<String, dynamic>> _reminders;
  @override
  @JsonKey()
  List<Map<String, dynamic>> get reminders {
    if (_reminders is EqualUnmodifiableListView) return _reminders;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_reminders);
  }

  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final DateTime? deletedAt;

  /// Create a copy of Event
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$EventCopyWith<_Event> get copyWith =>
      __$EventCopyWithImpl<_Event>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$EventToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Event &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.calendarId, calendarId) ||
                other.calendarId == calendarId) &&
            (identical(other.baseEventId, baseEventId) ||
                other.baseEventId == baseEventId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.startDateTime, startDateTime) ||
                other.startDateTime == startDateTime) &&
            (identical(other.endDateTime, endDateTime) ||
                other.endDateTime == endDateTime) &&
            (identical(other.allDay, allDay) || other.allDay == allDay) &&
            (identical(other.timezone, timezone) ||
                other.timezone == timezone) &&
            (identical(other.recurrenceRule, recurrenceRule) ||
                other.recurrenceRule == recurrenceRule) &&
            (identical(other.isException, isException) ||
                other.isException == isException) &&
            (identical(
                    other.recurrenceExceptionDate, recurrenceExceptionDate) ||
                other.recurrenceExceptionDate == recurrenceExceptionDate) &&
            const DeepCollectionEquality()
                .equals(other._reminders, _reminders) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      calendarId,
      baseEventId,
      title,
      description,
      location,
      startDateTime,
      endDateTime,
      allDay,
      timezone,
      recurrenceRule,
      isException,
      recurrenceExceptionDate,
      const DeepCollectionEquality().hash(_reminders),
      createdAt,
      updatedAt,
      deletedAt);

  @override
  String toString() {
    return 'Event(id: $id, calendarId: $calendarId, baseEventId: $baseEventId, title: $title, description: $description, location: $location, startDateTime: $startDateTime, endDateTime: $endDateTime, allDay: $allDay, timezone: $timezone, recurrenceRule: $recurrenceRule, isException: $isException, recurrenceExceptionDate: $recurrenceExceptionDate, reminders: $reminders, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
  }
}

/// @nodoc
abstract mixin class _$EventCopyWith<$Res> implements $EventCopyWith<$Res> {
  factory _$EventCopyWith(_Event value, $Res Function(_Event) _then) =
      __$EventCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String id,
      String calendarId,
      String? baseEventId,
      String title,
      String description,
      String location,
      DateTime startDateTime,
      DateTime endDateTime,
      bool allDay,
      String timezone,
      String? recurrenceRule,
      bool isException,
      DateTime? recurrenceExceptionDate,
      List<Map<String, dynamic>> reminders,
      DateTime createdAt,
      DateTime updatedAt,
      DateTime? deletedAt});
}

/// @nodoc
class __$EventCopyWithImpl<$Res> implements _$EventCopyWith<$Res> {
  __$EventCopyWithImpl(this._self, this._then);

  final _Event _self;
  final $Res Function(_Event) _then;

  /// Create a copy of Event
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? calendarId = null,
    Object? baseEventId = freezed,
    Object? title = null,
    Object? description = null,
    Object? location = null,
    Object? startDateTime = null,
    Object? endDateTime = null,
    Object? allDay = null,
    Object? timezone = null,
    Object? recurrenceRule = freezed,
    Object? isException = null,
    Object? recurrenceExceptionDate = freezed,
    Object? reminders = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? deletedAt = freezed,
  }) {
    return _then(_Event(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      calendarId: null == calendarId
          ? _self.calendarId
          : calendarId // ignore: cast_nullable_to_non_nullable
              as String,
      baseEventId: freezed == baseEventId
          ? _self.baseEventId
          : baseEventId // ignore: cast_nullable_to_non_nullable
              as String?,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      location: null == location
          ? _self.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      startDateTime: null == startDateTime
          ? _self.startDateTime
          : startDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDateTime: null == endDateTime
          ? _self.endDateTime
          : endDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      allDay: null == allDay
          ? _self.allDay
          : allDay // ignore: cast_nullable_to_non_nullable
              as bool,
      timezone: null == timezone
          ? _self.timezone
          : timezone // ignore: cast_nullable_to_non_nullable
              as String,
      recurrenceRule: freezed == recurrenceRule
          ? _self.recurrenceRule
          : recurrenceRule // ignore: cast_nullable_to_non_nullable
              as String?,
      isException: null == isException
          ? _self.isException
          : isException // ignore: cast_nullable_to_non_nullable
              as bool,
      recurrenceExceptionDate: freezed == recurrenceExceptionDate
          ? _self.recurrenceExceptionDate
          : recurrenceExceptionDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      reminders: null == reminders
          ? _self._reminders
          : reminders // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      deletedAt: freezed == deletedAt
          ? _self.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

// dart format on
