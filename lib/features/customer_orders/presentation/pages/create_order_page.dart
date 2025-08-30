import 'dart:convert';
import 'package:caterease/features/profile/presentation/screens/address/add_address_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart' as latlong;

import 'package:caterease/core/theming/app_theme.dart';
import 'package:caterease/features/customer_orders/presentation/bloc/customer_order_bloc.dart';
import 'package:caterease/features/customer_orders/presentation/bloc/customer_order_event.dart';
import 'package:caterease/features/customer_orders/presentation/bloc/customer_order_state.dart';
import 'package:caterease/features/customer_orders/domain/entities/customer_order.dart';
import 'package:caterease/features/profile/domain/entities/address.dart';
import 'package:caterease/features/profile/presentation/controller/bloc/address/address_bloc.dart';
import 'package:caterease/features/profile/presentation/controller/bloc/address/address_event.dart';
import 'package:caterease/features/profile/presentation/controller/bloc/address/address_state.dart';

class CreateOrderPage extends StatefulWidget {
  final List<int> cartItemIds;

  const CreateOrderPage({super.key, required this.cartItemIds});

  @override
  State<CreateOrderPage> createState() => _CreateOrderPageState();
}

class _CreateOrderPageState extends State<CreateOrderPage> {
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();
  final _searchController = TextEditingController();

  DateTime? _selectedDeliveryTime;
  String _addressType = 'existing';
  int? _selectedExistingAddressId;
  List<Address> _existingAddresses = [];

  // New address fields
  int? _selectedCityId;
  final _streetController = TextEditingController();
  final _buildingController = TextEditingController();
  final _floorController = TextEditingController();
  final _apartmentController = TextEditingController();

  latlong.LatLng? _selectedLocation;
  final MapController _mapController = MapController();
  Position? _currentPosition;

  bool _isSearching = false;
  String? _selectedAddressLabel;

  @override
  void initState() {
    super.initState();
    context.read<AddressBloc>().add(GetAllAddressesEvent());
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _notesController.dispose();
    _searchController.dispose();
    _streetController.dispose();
    _buildingController.dispose();
    _floorController.dispose();
    _apartmentController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("خدمة الموقع غير مفعلة.")),
          );
        }
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("تم رفض أذونات الموقع.")),
            );
          }
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("تم رفض أذونات الموقع بشكل دائم.")),
          );
        }
        return;
      }

      _currentPosition = await Geolocator.getCurrentPosition();
      final here = latlong.LatLng(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
      );
      setState(() {
        _selectedLocation = here;
      });
      _mapController.move(here, 15.0);
      await _reverseGeocode(here);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("حدث خطأ أثناء تحديد الموقع: $e")),
        );
      }
    }
  }

  // ======= البحث: Nominatim أولاً، ثم geocoding كخطة بديلة =======

  Future<latlong.LatLng?> _searchWithNominatim(String query) async {
    final url = Uri.parse(
      "https://nominatim.openstreetmap.org/search?q=${Uri.encodeComponent(query)}&format=json&limit=1&addressdetails=1&accept-language=ar",
    );
    try {
      final res = await http.get(
        url,
        headers: {
          'User-Agent': 'caterease/1.0 (support@caterease.example )',
        },
      );
      if (res.statusCode == 200) {
        final decoded = json.decode(res.body);
        if (decoded is List && decoded.isNotEmpty) {
          final item = decoded.first;
          final lat = double.tryParse(item['lat'].toString());
          final lon = double.tryParse(item['lon'].toString());
          if (lat != null && lon != null) {
            return latlong.LatLng(lat, lon);
          }
        }
      }
    } catch (e) {
      // يمكنك تسجيل الخطأ هنا إذا أردت
      // print("Nominatim search error: $e");
    }
    return null;
  }

  Future<latlong.LatLng?> _searchWithGeocoding(String query) async {
    try {
      final locations = await locationFromAddress(
        query,
        localeIdentifier: 'ar',
      );
      if (locations.isNotEmpty) {
        final l = locations.first;
        return latlong.LatLng(l.latitude, l.longitude);
      }
    } catch (e) {
      // تجاهل الخطأ، خاصةً UnknownFormatConversionException
      // print("Geocoding search error: $e");
    }
    return null;
  }

  Future<void> _searchLocation(String query) async {
    if (query.trim().isEmpty) return;
    setState(() => _isSearching = true);

    // 1. ابدأ بـ Nominatim لأنه أكثر استقراراً للبحث
    latlong.LatLng? point = await _searchWithNominatim(query);

    // 2. استخدم geocoding كخطة بديلة فقط إذا فشل Nominatim
    point ??= await _searchWithGeocoding(query);

    setState(() => _isSearching = false);

    if (point != null) {
      setState(() {
        _selectedLocation = point;
      });
      _mapController.move(point, 16.0);
      await _reverseGeocode(point);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'لم يتم العثور على الموقع. حاول استخدام كلمات بحث مختلفة.')),
        );
      }
    }
  }

  // ======= Reverse Geocoding: geocoding أولاً، ثم Nominatim =======

  Future<void> _reverseGeocode(latlong.LatLng pos) async {
    String? label;
    bool filled = false;

    try {
      final places = await placemarkFromCoordinates(
        pos.latitude,
        pos.longitude,
        localeIdentifier: 'ar',
      );
      if (places.isNotEmpty) {
        final p = places.first;
        label = [
          p.street,
          p.subLocality,
          p.locality,
          p.administrativeArea,
        ].where((e) => (e ?? '').trim().isNotEmpty).join('، ');

        final street = [p.street, p.thoroughfare]
            .where((e) => (e ?? '').trim().isNotEmpty)
            .join(' - ');
        final building = [
          p.subThoroughfare,
          p.name,
        ].where((e) => (e ?? '').trim().isNotEmpty).join(' ');

        if (street.trim().isNotEmpty) {
          _streetController.text = street;
          filled = true;
        }
        if (building.trim().isNotEmpty) {
          _buildingController.text = building;
          filled = true;
        }
      }
    } catch (_) {
      // تجاهل وسنجرّب Nominatim
    }

    if (label == null || label.trim().isEmpty || !filled) {
      try {
        final url = Uri.parse(
            "https://nominatim.openstreetmap.org/reverse?lat=${pos.latitude}&lon=${pos.longitude}&format=json&addressdetails=1&zoom=18&accept-language=ar");
        final res = await http.get(url, headers: {
          'User-Agent': 'caterease/1.0 (support@caterease.example )',
        });
        if (res.statusCode == 200) {
          final data = json.decode(res.body);
          final addr = (data['address'] ?? {}) as Map;
          final road = (addr['road'] ??
              addr['pedestrian'] ??
              addr['residential'] ??
              '') as String;
          final house = (addr['house_number'] ?? '') as String;
          final suburb =
              (addr['suburb'] ?? addr['neighbourhood'] ?? '') as String;
          final city = (addr['city'] ??
              addr['town'] ??
              addr['village'] ??
              addr['county'] ??
              '') as String;

          label = [
            if (road.toString().trim().isNotEmpty) road,
            if (suburb.toString().trim().isNotEmpty) suburb,
            if (city.toString().trim().isNotEmpty) city,
          ].join('، ');

          if (_streetController.text.trim().isEmpty && road.trim().isNotEmpty) {
            _streetController.text = road;
          }
          if (_buildingController.text.trim().isEmpty &&
              house.trim().isNotEmpty) {
            _buildingController.text = house;
          }
        }
      } catch (_) {}
    }

    setState(() {
      _selectedAddressLabel = label;
    });
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: 'ابحث عن مكان...',
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Icon(Icons.search, color: AppTheme.darkBlue),
                suffixIcon: _isSearching
                    ? const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : (_searchController.text.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              _searchController.clear();
                              // يمكنك إضافة منطق إضافي هنا إذا أردت
                            },
                            icon: const Icon(Icons.clear),
                          )
                        : null),
              ),
              onSubmitted: (value) => _searchLocation(value),
            ),
          ),
          IconButton(
            icon: Icon(Icons.my_location, color: AppTheme.darkBlue),
            onPressed: _getCurrentLocation,
            tooltip: 'موقعي الحالي',
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<CustomerOrderBloc, CustomerOrderState>(
          listener: (context, state) {
            if (state is CustomerOrderSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.of(context).pop();
            } else if (state is CustomerOrderError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        ),
        BlocListener<AddressBloc, AddressState>(
          listener: (context, state) {
            if (state is AddressLoaded) {
              setState(() {
                _existingAddresses = state.addresses;
              });
            } else if (state is AddressError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("خطأ في تحميل العناوين: ${state.message}"),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text("إنشاء طلب جديد"),
          backgroundColor: AppTheme.darkBlue,
          foregroundColor: Colors.white,
        ),
        body: BlocBuilder<CustomerOrderBloc, CustomerOrderState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _notesController,
                        decoration: InputDecoration(
                          labelText: 'ملاحظات',
                          filled: true,
                          fillColor: Colors.grey[100],
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'يرجى إدخال الملاحظات';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      ListTile(
                        title: Text(
                          _selectedDeliveryTime == null
                              ? 'اختر وقت التوصيل'
                              : 'وقت التوصيل: ${_selectedDeliveryTime.toString()}',
                        ),
                        trailing: Icon(Icons.calendar_today,
                            color: AppTheme.darkBlue),
                        onTap: _selectDeliveryTime,
                        tileColor: AppTheme.lightGray,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'نوع العنوان:',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.fontBlack),
                      ),
                      RadioListTile<String>(
                        title: const Text('عنوان موجود'),
                        value: 'existing',
                        groupValue: _addressType,
                        activeColor: AppTheme.darkBlue,
                        onChanged: (value) {
                          setState(() {
                            _addressType = value!;
                          });
                        },
                      ),
                      RadioListTile<String>(
                        title: const Text('عنوان جديد'),
                        value: 'new',
                        groupValue: _addressType,
                        activeColor: AppTheme.darkBlue,
                        onChanged: (value) {
                          setState(() {
                            _addressType = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      if (_addressType == 'existing')
                        ..._buildExistingAddressFields(),
                      if (_addressType == 'new') _buildNewAddress(),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: state is CustomerOrderLoading
                              ? null
                              : _submitOrder,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.darkBlue,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: state is CustomerOrderLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : const Text(
                                  'إنشاء الطلب',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  List<Widget> _buildExistingAddressFields() {
    return [
      DropdownButtonFormField<int>(
        value: _selectedExistingAddressId,
        decoration: InputDecoration(
          labelText: 'اختر العنوان',
          filled: true,
          fillColor: Colors.grey[100],
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
        items: _existingAddresses.isEmpty
            ? []
            : _existingAddresses.map((address) {
                return DropdownMenuItem<int>(
                  value: address.id,
                  child: Text('${address.street}, ${address.building}'),
                );
              }).toList(),
        onChanged: (value) {
          setState(() {
            _selectedExistingAddressId = value;
          });
        },
        validator: (value) {
          if (value == null) {
            return 'يرجى اختيار العنوان';
          }
          return null;
        },
      ),
    ];
  }

  Widget _buildNewAddress() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: ElevatedButton.icon(
        icon: const Icon(Icons.add_location_alt),
        label: const Text("Add New Address"),
        onPressed: () {
          final addressBloc = context.read<AddressBloc>();
          // Open the popup
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (ctx) {
              return BlocProvider.value(
                value: addressBloc, // pass the same instance
                child: const AddAddressPopup(),
              );
            },
          ).whenComplete(() {
            // Refresh addresses after popup closes
            addressBloc.add(GetAllAddressesEvent());
          });
        },
      ),
    );
  }

  /* List<Widget> _buildNewAddressFields() {
    return [
      Text(
        'تفاصيل العنوان الجديد:',
        style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.fontBlack),
      ),
      const SizedBox(height: 8),
      DropdownButtonFormField<int>(
        value: _selectedCityId,
        decoration: InputDecoration(
          labelText: 'المحافظة',
          filled: true,
          fillColor: Colors.grey[100],
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
        items: _syrianGovernorates.map((city) {
          return DropdownMenuItem<int>(
            value: city["id"],
            child: Text(city["name"]),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _selectedCityId = value;
          });
        },
        validator: (value) {
          if (value == null) {
            return 'يرجى اختيار المحافظة';
          }
          return null;
        },
      ),
      const SizedBox(height: 12),
      TextFormField(
        controller: _streetController,
        decoration: InputDecoration(
          labelText: 'الشارع',
          filled: true,
          fillColor: Colors.grey[100],
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'يرجى إدخال الشارع';
          }
          return null;
        },
      ),
      const SizedBox(height: 12),
      TextFormField(
        controller: _buildingController,
        decoration: InputDecoration(
          labelText: 'المبنى',
          filled: true,
          fillColor: Colors.grey[100],
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'يرجى إدخال المبنى';
          }
          return null;
        },
      ),
      const SizedBox(height: 12),
      TextFormField(
        controller: _floorController,
        decoration: InputDecoration(
          labelText: 'الطابق',
          filled: true,
          fillColor: Colors.grey[100],
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'يرجى إدخال الطابق';
          }
          return null;
        },
      ),
      const SizedBox(height: 12),
      TextFormField(
        controller: _apartmentController,
        decoration: InputDecoration(
          labelText: 'الشقة',
          filled: true,
          fillColor: Colors.grey[100],
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'يرجى إدخال الشقة';
          }
          return null;
        },
      ),
      const SizedBox(height: 16),
      _buildSearchBar(),
      Container(
        height: 320,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppTheme.darkBlue.withOpacity(0.1),
              blurRadius: 5,
              spreadRadius: 2,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: _currentPosition == null
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 10),
                      Text("جاري تحديد موقعك الحالي..."),
                    ],
                  ),
                )
              : FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _selectedLocation ??
                        const latlong.LatLng(
                            33.5138, 36.2765), // دمشق افتراضيًا
                    initialZoom: 15.0,
                    onTap: (tapPosition, latLng) async {
                      setState(() {
                        _selectedLocation = latLng;
                      });
                      await _reverseGeocode(latLng);
                    },
                    onMapReady: () {
                      if (_selectedLocation != null) {
                        _mapController.move(_selectedLocation!, 15.0);
                      }
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                      subdomains: const ['a', 'b', 'c'],
                      userAgentPackageName: 'com.your.app.name',
                    ),
                    if (_selectedLocation != null)
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: _selectedLocation!,
                            width: 80,
                            height: 80,
                            child: Icon(
                              Icons.location_pin,
                              color: AppTheme.darkBlue,
                              size: 40,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
        ),
      ),
      if (_selectedAddressLabel != null &&
          _selectedAddressLabel!.trim().isNotEmpty)
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.place, size: 18, color: AppTheme.darkBlue),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  _selectedAddressLabel!,
                  style: TextStyle(fontSize: 13, color: AppTheme.fontBlack),
                ),
              ),
            ],
          ),
        ),
      const SizedBox(height: 12),
    ];
  } */

  Future<void> _selectDeliveryTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDeliveryTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  void _submitOrder() {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedDeliveryTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى اختيار وقت التوصيل'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Map<String, dynamic> address = {'type': _addressType};

    if (_addressType == 'existing') {
      if (_selectedExistingAddressId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("يرجى اختيار عنوان موجود."),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      address['existing_id'] = _selectedExistingAddressId;
    } else {
      if (_selectedLocation == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("يرجى تحديد الموقع على الخريطة."),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      address["new_city_id"] = _selectedCityId;
      address["new_street"] = _streetController.text.trim();
      address["new_building"] = _buildingController.text.trim();
      address["new_floor"] = _floorController.text.trim();
      address["new_apartment"] = _apartmentController.text.trim();
      address["new_latitude"] = _selectedLocation!.latitude;
      address["new_longitude"] = _selectedLocation!.longitude;
    }

    final customerOrder = CustomerOrder(
      notes: _notesController.text.trim(),
      deliveryTime: _selectedDeliveryTime!.toIso8601String(),
      cartItemIds: widget.cartItemIds,
      address: address,
    );

    context.read<CustomerOrderBloc>().add(
          CreateOrderEvent(customerOrder: customerOrder),
        );
  }
}
