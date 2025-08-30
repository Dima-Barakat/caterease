import 'package:equatable/equatable.dart';

class ScanCode extends Equatable {
  final int id;
  final String qr;

  const ScanCode({
    required this.id,
    required this.qr,
  });

  @override
  List<Object?> get props => [qr, id];
}
