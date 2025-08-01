import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/package_detail.dart';
import '../bloc/packages_bloc.dart';
import '../bloc/packages_event.dart';
import '../bloc/packages_state.dart';
import '../widgets/package_detail_widget.dart';

class PackageDetailPage extends StatefulWidget {
  final int packageId;

  const PackageDetailPage({Key? key, required this.packageId})
      : super(key: key);

  @override
  State<PackageDetailPage> createState() => _PackageDetailPageState();
}

class _PackageDetailPageState extends State<PackageDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<PackagesBloc>().add(GetPackageDetailEvent(widget.packageId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<PackagesBloc, PackagesState>(
        builder: (context, state) {
          if (state is PackageDetailLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is PackageDetailLoaded) {
            return PackageDetailWidget(packageDetail: state.packageDetail);
          } else if (state is PackageDetailError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'حدث خطأ: ${state.message}',
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<PackagesBloc>().add(
                            GetPackageDetailEvent(widget.packageId),
                          );
                    },
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            );
          }
          return const Center(
            child: Text('لا توجد بيانات'),
          );
        },
      ),
    );
  }
}
