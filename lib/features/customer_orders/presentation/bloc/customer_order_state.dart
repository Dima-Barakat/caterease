import 'package:equatable/equatable.dart';

abstract class CustomerOrderState extends Equatable {
  const CustomerOrderState();

  @override
  List<Object?> get props => [];
}

class CustomerOrderInitial extends CustomerOrderState {
  const CustomerOrderInitial();
}

class CustomerOrderLoading extends CustomerOrderState {
  const CustomerOrderLoading();
}

class CustomerOrderSuccess extends CustomerOrderState {
  final String message;

  const CustomerOrderSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class CustomerOrderError extends CustomerOrderState {
  final String message;

  const CustomerOrderError({required this.message});

  @override
  List<Object?> get props => [message];
}

