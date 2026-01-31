// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recurrence_rule.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RecurrenceRule {
  Frequency get frequency;
  int get interval;
  int? get count;
  DateTime? get until;
  List<int> get byWeekDay; // 0 = Sunday, 6 = Saturday
  List<int> get byMonthDay;
  List<int> get byMonth;

  /// Create a copy of RecurrenceRule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RecurrenceRuleCopyWith<RecurrenceRule> get copyWith =>
      _$RecurrenceRuleCopyWithImpl<RecurrenceRule>(
          this as RecurrenceRule, _$identity);

  /// Serializes this RecurrenceRule to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RecurrenceRule &&
            (identical(other.frequency, frequency) ||
                other.frequency == frequency) &&
            (identical(other.interval, interval) ||
                other.interval == interval) &&
            (identical(other.count, count) || other.count == count) &&
            (identical(other.until, until) || other.until == until) &&
            const DeepCollectionEquality().equals(other.byWeekDay, byWeekDay) &&
            const DeepCollectionEquality()
                .equals(other.byMonthDay, byMonthDay) &&
            const DeepCollectionEquality().equals(other.byMonth, byMonth));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      frequency,
      interval,
      count,
      until,
      const DeepCollectionEquality().hash(byWeekDay),
      const DeepCollectionEquality().hash(byMonthDay),
      const DeepCollectionEquality().hash(byMonth));

  @override
  String toString() {
    return 'RecurrenceRule(frequency: $frequency, interval: $interval, count: $count, until: $until, byWeekDay: $byWeekDay, byMonthDay: $byMonthDay, byMonth: $byMonth)';
  }
}

/// @nodoc
abstract mixin class $RecurrenceRuleCopyWith<$Res> {
  factory $RecurrenceRuleCopyWith(
          RecurrenceRule value, $Res Function(RecurrenceRule) _then) =
      _$RecurrenceRuleCopyWithImpl;
  @useResult
  $Res call(
      {Frequency frequency,
      int interval,
      int? count,
      DateTime? until,
      List<int> byWeekDay,
      List<int> byMonthDay,
      List<int> byMonth});
}

/// @nodoc
class _$RecurrenceRuleCopyWithImpl<$Res>
    implements $RecurrenceRuleCopyWith<$Res> {
  _$RecurrenceRuleCopyWithImpl(this._self, this._then);

  final RecurrenceRule _self;
  final $Res Function(RecurrenceRule) _then;

  /// Create a copy of RecurrenceRule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? frequency = null,
    Object? interval = null,
    Object? count = freezed,
    Object? until = freezed,
    Object? byWeekDay = null,
    Object? byMonthDay = null,
    Object? byMonth = null,
  }) {
    return _then(_self.copyWith(
      frequency: null == frequency
          ? _self.frequency
          : frequency // ignore: cast_nullable_to_non_nullable
              as Frequency,
      interval: null == interval
          ? _self.interval
          : interval // ignore: cast_nullable_to_non_nullable
              as int,
      count: freezed == count
          ? _self.count
          : count // ignore: cast_nullable_to_non_nullable
              as int?,
      until: freezed == until
          ? _self.until
          : until // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      byWeekDay: null == byWeekDay
          ? _self.byWeekDay
          : byWeekDay // ignore: cast_nullable_to_non_nullable
              as List<int>,
      byMonthDay: null == byMonthDay
          ? _self.byMonthDay
          : byMonthDay // ignore: cast_nullable_to_non_nullable
              as List<int>,
      byMonth: null == byMonth
          ? _self.byMonth
          : byMonth // ignore: cast_nullable_to_non_nullable
              as List<int>,
    ));
  }
}

/// Adds pattern-matching-related methods to [RecurrenceRule].
extension RecurrenceRulePatterns on RecurrenceRule {
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
    TResult Function(_RecurrenceRule value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RecurrenceRule() when $default != null:
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
    TResult Function(_RecurrenceRule value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RecurrenceRule():
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
    TResult? Function(_RecurrenceRule value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RecurrenceRule() when $default != null:
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
            Frequency frequency,
            int interval,
            int? count,
            DateTime? until,
            List<int> byWeekDay,
            List<int> byMonthDay,
            List<int> byMonth)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RecurrenceRule() when $default != null:
        return $default(_that.frequency, _that.interval, _that.count,
            _that.until, _that.byWeekDay, _that.byMonthDay, _that.byMonth);
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
            Frequency frequency,
            int interval,
            int? count,
            DateTime? until,
            List<int> byWeekDay,
            List<int> byMonthDay,
            List<int> byMonth)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RecurrenceRule():
        return $default(_that.frequency, _that.interval, _that.count,
            _that.until, _that.byWeekDay, _that.byMonthDay, _that.byMonth);
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
            Frequency frequency,
            int interval,
            int? count,
            DateTime? until,
            List<int> byWeekDay,
            List<int> byMonthDay,
            List<int> byMonth)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RecurrenceRule() when $default != null:
        return $default(_that.frequency, _that.interval, _that.count,
            _that.until, _that.byWeekDay, _that.byMonthDay, _that.byMonth);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _RecurrenceRule implements RecurrenceRule {
  const _RecurrenceRule(
      {required this.frequency,
      this.interval = 1,
      this.count,
      this.until,
      final List<int> byWeekDay = const [],
      final List<int> byMonthDay = const [],
      final List<int> byMonth = const []})
      : _byWeekDay = byWeekDay,
        _byMonthDay = byMonthDay,
        _byMonth = byMonth;
  factory _RecurrenceRule.fromJson(Map<String, dynamic> json) =>
      _$RecurrenceRuleFromJson(json);

  @override
  final Frequency frequency;
  @override
  @JsonKey()
  final int interval;
  @override
  final int? count;
  @override
  final DateTime? until;
  final List<int> _byWeekDay;
  @override
  @JsonKey()
  List<int> get byWeekDay {
    if (_byWeekDay is EqualUnmodifiableListView) return _byWeekDay;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_byWeekDay);
  }

// 0 = Sunday, 6 = Saturday
  final List<int> _byMonthDay;
// 0 = Sunday, 6 = Saturday
  @override
  @JsonKey()
  List<int> get byMonthDay {
    if (_byMonthDay is EqualUnmodifiableListView) return _byMonthDay;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_byMonthDay);
  }

  final List<int> _byMonth;
  @override
  @JsonKey()
  List<int> get byMonth {
    if (_byMonth is EqualUnmodifiableListView) return _byMonth;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_byMonth);
  }

  /// Create a copy of RecurrenceRule
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$RecurrenceRuleCopyWith<_RecurrenceRule> get copyWith =>
      __$RecurrenceRuleCopyWithImpl<_RecurrenceRule>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$RecurrenceRuleToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _RecurrenceRule &&
            (identical(other.frequency, frequency) ||
                other.frequency == frequency) &&
            (identical(other.interval, interval) ||
                other.interval == interval) &&
            (identical(other.count, count) || other.count == count) &&
            (identical(other.until, until) || other.until == until) &&
            const DeepCollectionEquality()
                .equals(other._byWeekDay, _byWeekDay) &&
            const DeepCollectionEquality()
                .equals(other._byMonthDay, _byMonthDay) &&
            const DeepCollectionEquality().equals(other._byMonth, _byMonth));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      frequency,
      interval,
      count,
      until,
      const DeepCollectionEquality().hash(_byWeekDay),
      const DeepCollectionEquality().hash(_byMonthDay),
      const DeepCollectionEquality().hash(_byMonth));

  @override
  String toString() {
    return 'RecurrenceRule(frequency: $frequency, interval: $interval, count: $count, until: $until, byWeekDay: $byWeekDay, byMonthDay: $byMonthDay, byMonth: $byMonth)';
  }
}

/// @nodoc
abstract mixin class _$RecurrenceRuleCopyWith<$Res>
    implements $RecurrenceRuleCopyWith<$Res> {
  factory _$RecurrenceRuleCopyWith(
          _RecurrenceRule value, $Res Function(_RecurrenceRule) _then) =
      __$RecurrenceRuleCopyWithImpl;
  @override
  @useResult
  $Res call(
      {Frequency frequency,
      int interval,
      int? count,
      DateTime? until,
      List<int> byWeekDay,
      List<int> byMonthDay,
      List<int> byMonth});
}

/// @nodoc
class __$RecurrenceRuleCopyWithImpl<$Res>
    implements _$RecurrenceRuleCopyWith<$Res> {
  __$RecurrenceRuleCopyWithImpl(this._self, this._then);

  final _RecurrenceRule _self;
  final $Res Function(_RecurrenceRule) _then;

  /// Create a copy of RecurrenceRule
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? frequency = null,
    Object? interval = null,
    Object? count = freezed,
    Object? until = freezed,
    Object? byWeekDay = null,
    Object? byMonthDay = null,
    Object? byMonth = null,
  }) {
    return _then(_RecurrenceRule(
      frequency: null == frequency
          ? _self.frequency
          : frequency // ignore: cast_nullable_to_non_nullable
              as Frequency,
      interval: null == interval
          ? _self.interval
          : interval // ignore: cast_nullable_to_non_nullable
              as int,
      count: freezed == count
          ? _self.count
          : count // ignore: cast_nullable_to_non_nullable
              as int?,
      until: freezed == until
          ? _self.until
          : until // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      byWeekDay: null == byWeekDay
          ? _self._byWeekDay
          : byWeekDay // ignore: cast_nullable_to_non_nullable
              as List<int>,
      byMonthDay: null == byMonthDay
          ? _self._byMonthDay
          : byMonthDay // ignore: cast_nullable_to_non_nullable
              as List<int>,
      byMonth: null == byMonth
          ? _self._byMonth
          : byMonth // ignore: cast_nullable_to_non_nullable
              as List<int>,
    ));
  }
}

// dart format on
