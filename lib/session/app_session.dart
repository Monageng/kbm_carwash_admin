import 'package:kbm_carwash_admin/features/franchise/models/franchise_model.dart';

import '../common/model/city_model.dart';
import '../common/model/province.dart';
import '../features/booking/models/appointment_model.dart';
import '../features/services/models/car_models_model.dart';
import '../features/services/models/car_wash_service_model.dart';
import '../features/users/models/user_model.dart';

class AppSessionModel {
  String? _token;
  UserModel? _loggedOnUser;
  DateTime? _expiryDate;
  late Future<List<Province>> _provinceList;
  late Future<List<City>> _cityList;
  Future<List<Appointment>>? _appointmentList;
  Future<List<CarModel>>? _carModelList;
  Future<List<CarWashService>>? _carwashServiceList;
  Future<List<Franchise>>? _franchiseList;
  Future<List<Franchise>>? get franchiseList => _franchiseList;
  Future<List<CarModel>>? get carModelList => _carModelList;

  static final AppSessionModel _instance = AppSessionModel._internal();

  factory AppSessionModel() {
    return _instance;
  }

  AppSessionModel._internal();

  void setFranchiseList(Future<List<Franchise>>? franchiseList) {
    _franchiseList = franchiseList;
  }

  void setCarModelList(Future<List<CarModel>>? carModelList) {
    _carModelList = carModelList;
  }

  void setCarwashServiceList(Future<List<CarWashService>>? carwashServiceList) {
    _carwashServiceList = carwashServiceList;
  }

  void setLoggedInUser(UserModel? loggedOnUser) {
    _loggedOnUser = loggedOnUser;
  }

  void setToken(String? token) {
    _token = token;
  }

  void setExpiryDate(DateTime? expiryDate) {
    _expiryDate = expiryDate;
  }

  UserModel? get loggedOnUser => _loggedOnUser;
  String? get token => _token;
  DateTime? get expiryDate => _expiryDate;
  Future<List<Appointment>>? get appointmentList => _appointmentList;
  Future<List<Province>> get provinceList => _provinceList;
  Future<List<City>> get cityList => _cityList;
  Future<List<CarWashService>>? get carwashServiceList => _carwashServiceList;

  void setAppointmentList(Future<List<Appointment>>? appointmentList) {
    _appointmentList = appointmentList;
  }

  void setCity(Future<List<City>> cityList) {
    _cityList = cityList;
  }

  void setProvince(Future<List<Province>> provinceList) {
    _provinceList = provinceList;
  }
}
