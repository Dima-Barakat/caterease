import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/package_detail.dart';
import '../bloc/packages_bloc.dart';
import '../bloc/packages_event.dart';
import '../bloc/packages_state.dart';
import '../widgets/package_edit_widget.dart';

class PackageEditPage extends StatefulWidget {
  final int packageId;
  final dynamic cartItem; // Cart item data for editing
  final bool isEditMode;

  const PackageEditPage({
    Key? key, 
    required this.packageId,
    this.cartItem,
    this.isEditMode = false,
  }) : super(key: key);

  @override
  State<PackageEditPage> createState() => _PackageEditPageState();
}

class _PackageEditPageState extends State<PackageEditPage> {
  @override
  void initState() {
    super.initState();
    // Use packageId if it's valid, otherwise try to use cartItem's packageId
    int idToFetch = widget.packageId;
    if (idToFetch == 0 && widget.cartItem != null && widget.cartItem.packageId != null) {
      idToFetch = int.tryParse(widget.cartItem.packageId.toString()) ?? 0;
    }
    context.read<PackagesBloc>().add(GetPackageDetailEvent(idToFetch));
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
            return PackageEditWidget(
              packageDetail: state.packageDetail,
              cartItem: widget.cartItem,
              isEditMode: widget.isEditMode,
            );
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
                      // Re-fetch using the original packageId or cartItem's packageId
                      int idToFetch = widget.packageId;
                      if (idToFetch == 0 && widget.cartItem != null && widget.cartItem.packageId != null) {
                        idToFetch = int.tryParse(widget.cartItem.packageId.toString()) ?? 0;
                      }
                      context.read<PackagesBloc>().add(
                            GetPackageDetailEvent(idToFetch),
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

