import '../common/model/city_model.dart';
import '../common/model/province.dart';
import '../features/booking/models/appointment_model.dart';

class AppSessionModel {
  String? _token;
  DateTime? _expiryDate;
  late Future<List<Province>> _provinceList;
  late Future<List<City>> _cityList;
  Future<List<Appointment>>? _appointmentList;

  static final AppSessionModel _instance = AppSessionModel._internal();

  factory AppSessionModel() {
    return _instance;
  }

  AppSessionModel._internal();

  String? get token => _token;
  DateTime? get expiryDate => _expiryDate;
  Future<List<Appointment>>? get appointmentList => _appointmentList;
  Future<List<Province>> get provinceList => _provinceList;
  Future<List<City>> get cityList => _cityList;

  void setAppointmentList(Future<List<Appointment>>? appointmentList) {
    _appointmentList = appointmentList;
  }

  void setToken(String? token) {
    _token = token;
  }

  void setExpiryDate(DateTime? expiryDate) {
    _expiryDate = expiryDate;
  }

  void setCity(Future<List<City>> cityList) {
    _cityList = cityList;
  }

  void setProvince(Future<List<Province>> provinceList) {
    _provinceList = provinceList;
  }
}
