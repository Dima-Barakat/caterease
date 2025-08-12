import 'package:equatable/equatable.dart';

abstract class PackagesEvent extends Equatable {
  const PackagesEvent();

  @override
  List<Object> get props => [];
}

class GetPackagesForBranchEvent extends PackagesEvent {
  final int branchId;

  const GetPackagesForBranchEvent(this.branchId);

  @override
  List<Object> get props => [branchId];
}
