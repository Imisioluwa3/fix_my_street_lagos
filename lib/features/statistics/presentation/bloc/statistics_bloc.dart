// import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/user_statistics.dart';
// import '../../domain/usecases/get_user_statistics.dart';

// Events
abstract class StatisticsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadUserStatisticsEvent extends StatisticsEvent {}

class RefreshStatisticsEvent extends StatisticsEvent {}

// States
abstract class StatisticsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class StatisticsInitialState extends StatisticsState {}

class StatisticsLoadingState extends StatisticsState {}

class StatisticsLoadedState extends StatisticsState {
  final UserStatistics statistics;

  StatisticsLoadedState({required this.statistics});

  @override
  List<Object?> get props => [statistics];
}

class StatisticsErrorState extends StatisticsState {
  final String message;

  StatisticsErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}

// BLoC
// class StatisticsBloc extends Bloc<StatisticsEvent, StatisticsState> {
//   final GetUserStatistics getUserStatistics;

//   StatisticsBloc({
//     required this.getUserStatistics,
//   }) : super(StatisticsInitialState()) {
//     on<LoadUserStatisticsEvent>(_onLoadUserStatistics);
//     on<RefreshStatisticsEvent>(_onRefreshStatistics);
//   }

//   Future<void> _onLoadUserStatistics(
//     LoadUserStatisticsEvent event,
//     Emitter<StatisticsState> emit,
//   ) async {
//     emit(StatisticsLoadingState());

//     final result = await getUserStatistics();
//     result.fold(
//       (failure) => emit(StatisticsErrorState(message: failure.message)),
//       (statistics) => emit(StatisticsLoadedState(statistics: statistics)),
//     );
//   }

//   Future<void> _onRefreshStatistics(
//     RefreshStatisticsEvent event,
//     Emitter<StatisticsState> emit,
//   ) async {
//     // Don't show loading state for refresh
//     final result = await getUserStatistics();
//     result.fold(
//       (failure) => emit(StatisticsErrorState(message: failure.message)),
//       (statistics) => emit(StatisticsLoadedState(statistics: statistics)),
//     );
//   }
// }
