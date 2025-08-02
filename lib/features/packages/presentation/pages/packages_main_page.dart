import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:caterease/features/packages/presentation/bloc/packages_bloc.dart';
import 'package:caterease/features/packages/presentation/bloc/packages_event.dart';
import 'package:caterease/features/packages/presentation/bloc/packages_state.dart';
import 'package:caterease/features/packages/presentation/widgets/package_item.dart';
import 'package:caterease/injection_container.dart';

class PackagesMainPage extends StatefulWidget {
  @override
  _PackagesMainPageState createState() => _PackagesMainPageState();
}

class _PackagesMainPageState extends State<PackagesMainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Packages'),
        centerTitle: true,
      ),
      body: BlocProvider(
        create: (_) => sl<PackagesBloc>(),
        child: BlocBuilder<PackagesBloc, PackagesState>(
          builder: (context, state) {
            if (state is PackagesLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PackagesLoaded) {
              return ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: state.packages.length,
                itemBuilder: (context, index) {
                  final pkg = state.packages[index];
                  return PackageItem(
                    package: pkg,
                    onTap: () {
                      // Navigate to package details if needed
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
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      state.message,
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.local_offer, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No packages available',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Check back later for exciting offers!',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

