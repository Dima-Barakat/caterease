import 'package:equatable/equatable.dart';

class RemoveCartItemResponse extends Equatable {
  final bool status;
  final String message;
  final RemovedItemData? data;

  const RemoveCartItemResponse({
    required this.status,
    required this.message,
    this.data,
  });

  @override
  List<Object?> get props => [status, message, data];
}

class RemovedItemData extends Equatable {
  final int removedItemId;
  final String removedItemName;
  final double removedItemTotal;
  final double newCartTotal;
  final int remainingItems;

  const RemovedItemData({
    required this.removedItemId,
    required this.removedItemName,
    required this.removedItemTotal,
    required this.newCartTotal,
    required this.remainingItems,
  });

  @override
  List<Object?> get props => [
        removedItemId,
        removedItemName,
        removedItemTotal,
        newCartTotal,
        remainingItems,
      ];
}

