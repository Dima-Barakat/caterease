// lib/features/packages/presentation/pages/packages_page.dart

import 'package:caterease/features/packages/presentation/bloc/packages_bloc.dart';
import 'package:caterease/features/packages/presentation/bloc/packages_event.dart';
import 'package:caterease/features/packages/presentation/bloc/packages_state.dart';
import 'package:caterease/features/packages/presentation/widgets/package_item.dart'; // <-- استدعاء الويدجت
import 'package:caterease/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PackagesPage extends StatefulWidget {
  final int branchId;
  final String branchName;

  const PackagesPage({
    Key? key,
    required this.branchId,
    required this.branchName,
  }) : super(key: key);

  @override
  State<PackagesPage> createState() => _PackagesPageState();
}

class _PackagesPageState extends State<PackagesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.branchName} Packages'),
      ),
      body: BlocProvider(
        create: (_) =>
            sl<PackagesBloc>()..add(GetPackagesForBranchEvent(widget.branchId)),
        child: BlocBuilder<PackagesBloc, PackagesState>(
          builder: (context, state) {
            if (state is PackagesLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PackagesLoaded) {
              return ListView.builder(
                itemCount: state.packages.length,
                itemBuilder: (context, index) {
                  final pkg = state.packages[index];
                  return PackageItem(
                    package: pkg,
                    onTap: () {
                      // لو حابب تنقل لتفاصيل الباكج
                      Navigator.pushNamed(
                        context,
                        '/packageDetails',
                        arguments: pkg,
                      );
                    },
                  );
                },
              );
            } else if (state is PackagesError) {
              return Center(child: Text(state.message));
            }
            return const Center(child: Text('Select a branch to see packages'));
          },
        ),
      ),
    );
  }
}
