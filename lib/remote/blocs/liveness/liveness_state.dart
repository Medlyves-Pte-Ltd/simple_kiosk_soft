part of 'liveness_bloc.dart';

class LivenessState extends Equatable {
  final bool isConnected;
  final int errorCount;
  const LivenessState({this.isConnected = false, this.errorCount = 0});

  @override
  List<Object> get props => [isConnected, errorCount];

  LivenessState copyWith({
    bool? isConnected,
    int? errorCount,
  }) {
    return LivenessState(
      isConnected: isConnected ?? this.isConnected,
      errorCount: errorCount ?? this.errorCount,
    );
  }
}
