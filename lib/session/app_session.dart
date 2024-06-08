import '../features/booking/models/appointment_model.dart';

class AppSessionModel {
  String? _token;
  DateTime? _expiryDate;
  // Future<List<CarWashService>>? _carwashServiceList;
  Future<List<CarWashAppointment>>? _appointmentList;
  // Future<List<Reward>>? _rewardsAllocation;
  // Future<List<RewardRunningTotal>>? _rewardRunningTotal;

  static final AppSessionModel _instance = AppSessionModel._internal();

  factory AppSessionModel() {
    return _instance;
  }

  AppSessionModel._internal();

  // UserModel? get loggedOnUser => _loggedOnUser;
  String? get token => _token;
  DateTime? get expiryDate => _expiryDate;
  // Future<List<CarWashService>>? get carwashServiceList => _carwashServiceList;
  Future<List<CarWashAppointment>>? get appointmentList => _appointmentList;
  // Future<List<Reward>>? get rewardsAllocation => _rewardsAllocation;

  // Future<List<RewardRunningTotal>>? get rewardRunningTotal =>
  //     _rewardRunningTotal;

  // void setRewardRunningTotal(
  //     Future<List<RewardRunningTotal>>? rewardRunningTotal) {
  //   _rewardRunningTotal = rewardRunningTotal;
  // }

  // void setRewardAllocation(Future<List<Reward>>? rewardsAllocation) {
  //   _rewardsAllocation = rewardsAllocation;
  // }

  // void setCarwashServiceList(Future<List<CarWashService>>? carwashServiceList) {
  //   _carwashServiceList = carwashServiceList;
  // }

  void setAppointmentList(Future<List<CarWashAppointment>>? appointmentList) {
    _appointmentList = appointmentList;
  }

  // void setLoggedInUser(UserModel? loggedOnUser) {
  //   _loggedOnUser = loggedOnUser;
  // }

  void setToken(String? token) {
    _token = token;
  }

  void setExpiryDate(DateTime? expiryDate) {
    _expiryDate = expiryDate;
  }
}
