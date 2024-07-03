import 'package:flutter/material.dart';
import 'package:kbm_carwash_admin/common/functions/date_utils.dart';
import 'package:kbm_carwash_admin/features/rewards/models/reward_config.dart';

import '../../../common/functions/common_functions.dart';
import '../../../common/functions/logger_utils.dart';
import '../../../common/services/common_api_service.dart';
import '../../../common/widgets/custom_action_button.dart';
import '../../../common/widgets/custom_calendar.dart';
import '../../../common/widgets/custom_dropdown.dart';
import '../../../common/widgets/custom_text_field.dart';
import '../../../common/widgets/error_dialog.dart';

class RewardConfigScreen extends StatefulWidget {
  late RewardConfig rewardConfig;

  RewardConfigScreen({
    super.key,
    required this.rewardConfig,
  });

  @override
  State<RewardConfigScreen> createState() => _RewardConfigScreenState();
}

class _RewardConfigScreenState extends State<RewardConfigScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _descriptionController =
      TextEditingController();
  late final TextEditingController _rewardTypeController =
      TextEditingController();
  late final TextEditingController _rewardValueController =
      TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _discountTypeController = TextEditingController();
  final TextEditingController _rewardCodeController = TextEditingController();
  final TextEditingController _frequencyTypeController =
      TextEditingController();
  final TextEditingController _frequencyCountController =
      TextEditingController();
  final TextEditingController _fromDateController = TextEditingController();
  final TextEditingController _toDateController = TextEditingController();
  final TextEditingController _activeController = TextEditingController();

  List<String> titleList = [
    "Select reward title",
    "Loyalty Reward",
    "Birth day reward",
  ];

  List<String> rewardTypeList = [
    "Select reward type",
    "Discount",
    "Free Services",
    "Refferal Discount",
  ];

  List<String> frequencyList = [
    "Select Frequency",
    "Once Off",
    "Daily",
    "Weekly",
    "Monthly",
    "Yearly",
  ];

  List<String> discountList = [
    "Select discount type",
    "Percentage",
    "Fixed Amount",
  ];
  String selectedTitle = "Select reward title";
  String selectedRewardType = "Select reward type";
  String selectedFrequency = "Select Frequency";
  String selectedDiscountType = "Select discount type";

  @override
  void initState() {
    super.initState();
    update(widget.rewardConfig);
  }

  void update(RewardConfig rewardConfig) {
    if (rewardConfig.id > 0) {
      _activeController.text = "${rewardConfig.active}";
      _descriptionController.text = rewardConfig.description!;
      _discountTypeController.text = rewardConfig.discountType!;
      _frequencyTypeController.text = rewardConfig.frequencyType!;
      _frequencyCountController.text = "${rewardConfig.frequencyCount}";
      _fromDateController.text = formatDateTime(rewardConfig.fromDate!);
      _toDateController.text = formatDateTime(rewardConfig.toDate!);
      _rewardCodeController.text = rewardConfig.rewardCode!;
      _rewardTypeController.text = rewardConfig.rewardType!;
      _rewardValueController.text = "${rewardConfig.rewardValue!}";
      _titleController.text = rewardConfig.title!;

      selectedDiscountType = rewardConfig.discountType!;
      selectedFrequency = rewardConfig.frequencyType!;
    }
  }

  void clearControllers() {
    _activeController.clear();
    _descriptionController.clear();
    _titleController.clear();
    _discountTypeController.clear();
    _frequencyTypeController.clear();
    _frequencyCountController.clear();
    _fromDateController.clear();
    _toDateController.clear();
    _rewardCodeController.clear();
    _rewardTypeController.clear();
    _rewardValueController.clear();
  }

  void _saveForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      int key = widget.rewardConfig.id;

      widget.rewardConfig.active = true;
      widget.rewardConfig.description = _descriptionController.text;
      widget.rewardConfig.discountType = _discountTypeController.text;
      widget.rewardConfig.frequencyCount =
          int.tryParse(_frequencyCountController.text);
      widget.rewardConfig.frequencyType = _frequencyTypeController.text;
      widget.rewardConfig.fromDate =
          DateTime.now(); //DateTime.parse(_fromDateController.text);
      widget.rewardConfig.rewardCode = _rewardCodeController.text;
      widget.rewardConfig.rewardType = _rewardTypeController.text;
      widget.rewardConfig.rewardValue =
          double.tryParse(_rewardValueController.text);
      widget.rewardConfig.title = _titleController.text;
      widget.rewardConfig.toDate =
          DateTime.now(); //DateTime.parse(_toDateController.text);

      String responseMessage;
      if (key < 1) {
        key = await CommonApiService().getLatestID("reward_config");
        widget.rewardConfig.id = key;
        widget.rewardConfig.createdAt = DateTime.now();
        responseMessage = await CommonApiService()
            .save(widget.rewardConfig.toJson(), "reward_config");
      } else {
        widget.rewardConfig.id = key;
        responseMessage = await CommonApiService()
            .update(key, "reward_config", widget.rewardConfig.toJson());
      }
      logger.d("responseMessage $responseMessage");
      await showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(message: responseMessage);
          });

      if (responseMessage.contains("successfully")) {
        //logEvent("liger_review_sumbit_successful");

        Navigator.of(context).pop(widget.rewardConfig);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Reward config details',
          style: TextStyle(color: Colors.black)),
      content: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              CustomDropDown(
                  sizeOptions: titleList,
                  selected: selectedTitle,
                  controller: _titleController),
              CustomDropDown(
                  sizeOptions: rewardTypeList,
                  selected: selectedRewardType,
                  controller: _rewardTypeController),
              CustomDropDown(
                  sizeOptions: discountList,
                  selected: selectedDiscountType,
                  controller: _discountTypeController),
              CustomTextField(
                width: 200,
                controller: _rewardValueController,
                hintText: "Reward Value ",
                label: "Reward Value",
                isObscre: false,
                validator: (value) {
                  return getFieldValidationMessage("Reward Value", value);
                },
              ),
              CustomDropDown(
                  sizeOptions: frequencyList,
                  selected: selectedFrequency,
                  controller: _frequencyTypeController),
              CustomTextField(
                width: 200,
                controller: _frequencyCountController,
                hintText: "Frequency count",
                label: "Frequency count",
                isObscre: false,
                validator: (value) {
                  return getFieldValidationMessage("Frequency count", value);
                },
              ),
              CustomTextField(
                width: 200,
                controller: _descriptionController,
                hintText: "Description",
                label: "Description",
                isObscre: false,
                validator: (value) {
                  return getFieldValidationMessage("Description", value);
                },
              ),
              CustomCalender(
                width: 200,
                label: "From date",
                controller: _fromDateController,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 30000)),
                selectedDate: DateTime.now(),
              ),
              CustomCalender(
                width: 200,
                label: "To date",
                controller: _toDateController,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 30000)),
                selectedDate: DateTime.now(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: CustomElevatedButton(
                      text: "Save",
                      onPressed: _saveForm,
                    ),
                  ),
                  Center(
                    child: CustomElevatedButton(
                      text: "Close",
                      onPressed: () {
                        Navigator.of(context).pop(widget.rewardConfig);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
