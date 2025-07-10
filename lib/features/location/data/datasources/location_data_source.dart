
import "package:geolocator/geolocator.dart";
import "package:permission_handler/permission_handler.dart";

abstract class LocationDataSource {
  Future<Position> getCurrentLocation();
  Future<bool> requestPermission();
}

class LocationDataSourceImpl implements LocationDataSource {
  @override
  Future<Position> getCurrentLocation() async {
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  @override
  Future<bool> requestPermission() async {
    var status = await Permission.locationWhenInUse.request();
    return status.isGranted;
  }
}


