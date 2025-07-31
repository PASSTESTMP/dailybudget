
import 'package:equatable/equatable.dart';

class SettingsState extends Equatable {
  final double budget;
  final double maxLimit;
  final int payday;
  final double borrow;
  final double limit;
  final bool isLoading;

  const SettingsState({
    required this.budget,
    required this.maxLimit,
    required this.payday,
    required this.borrow,
    required this.limit,
    this.isLoading = false,
  });

  factory SettingsState.initial() => const SettingsState(
        budget: 0,
        maxLimit: 100,
        payday: 10,
        borrow: 0,
        limit: 0,
        isLoading: true,
      );

  SettingsState copyWith({
    double? budget,
    double? maxLimit,
    int? payday,
    double? borrow,
    double? limit,
    bool? isLoading,
  }) {
    return SettingsState(
      budget: budget ?? this.budget,
      maxLimit: maxLimit ?? this.maxLimit,
      payday: payday ?? this.payday,
      borrow: borrow ?? this.borrow,
      limit: limit ?? this.limit,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object> get props => [budget, maxLimit, payday, borrow, limit, isLoading];
}
