import 'package:ams/feature/presentation/pages/bottom_nav/bottom_nav_page.dart';
import 'package:ams/feature/presentation/pages/login/controller/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ams/config/resources/styles.dart';
import 'package:ams/feature/presentation/pages/profile/controller/profile_controller.dart';

class EditUserBank extends StatefulWidget {
  final String? profileId;

  const EditUserBank({super.key, this.profileId});

  @override
  State<EditUserBank> createState() => _EditUserBankState();
}

class _EditUserBankState extends State<EditUserBank> {
  final authcontroller = Get.find<AuthController>();
  final ProfileController profilecontroller =
      Get.put(ProfileController(profileRepo: Get.find()));

  final RxList<Map<String, dynamic>> _bankDetailsList =
      <Map<String, dynamic>>[].obs;

  int? _selectedPayrollBankId;
  bool _isAddNewBankDetail = false;
  bool _isNewBankPayRoll = false;

  // Controllers for new bank details
  final TextEditingController newBankname = TextEditingController();
  final TextEditingController newBankbranchname = TextEditingController();
  final TextEditingController newBankaccountname = TextEditingController();
  final TextEditingController newBankaccountnumber = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeBankDetails();
  }

  void _initializeBankDetails() {
    final profiledata = profilecontroller.profile;

    if (profiledata.isNotEmpty && profiledata.first.bankDetails != null) {
      _bankDetailsList.assignAll(
        // ✅ Use `assignAll()` instead of just `=`
        profiledata.first.bankDetails!.map((bankDetail) {
          if (bankDetail.isPayroll == true) {
            _selectedPayrollBankId = bankDetail.id;
          }

          return {
            'id': bankDetail.id,
            'bankName': bankDetail.bankName ?? "",
            'bankBranch': bankDetail.bankBranch ?? "",
            'bankAccountName': bankDetail.bankAccountName ?? "",
            'bankAccount': bankDetail.bankAccount?.toString() ?? "",
            'isPayroll': bankDetail.isPayroll ?? false,
            'controllers': {
              'bankName':
                  TextEditingController(text: bankDetail.bankName ?? ""),
              'bankBranch':
                  TextEditingController(text: bankDetail.bankBranch ?? ""),
              'bankAccountName':
                  TextEditingController(text: bankDetail.bankAccountName ?? ""),
              'bankAccount': TextEditingController(
                  text: bankDetail.bankAccount?.toString() ?? ""),
            }
          };
        }).toList(),
      );
    }
  }

  void _handlePayrollCheckbox(int bankId, bool? value) {
    setState(() {
      if (value == true) {
        // Uncheck all other banks
        for (var bank in _bankDetailsList) {
          bank['isPayroll'] = false;
        }
        _selectedPayrollBankId = bankId;
      } else {
        _selectedPayrollBankId = null;
      }

      // Update current bank's payroll status
      for (var bank in _bankDetailsList) {
        if (bank['id'] == bankId) {
          bank['isPayroll'] = value ?? false;
        }
      }
    });
  }

  Future<void> _submitUserBankDetails() async {
    try {
      final userID = profilecontroller.profile.first.id;

      // Update existing bank details
      for (var bank in _bankDetailsList) {
        final controllers =
            bank['controllers'] as Map<String, TextEditingController>;

        await profilecontroller.postuserBankDetails(
          bankdetailID: bank['id'],
          userID: userID,
          bankname: controllers['bankName']!.text,
          bankbranch: controllers['bankBranch']!.text,
          bankaccountname: controllers['bankAccountName']!.text,
          bankaccount: int.tryParse(controllers['bankAccount']!.text) ?? 0,
          ispayroll: bank['id'] == _selectedPayrollBankId ? "true" : "false",
        );
      }

      // Add new bank details
      if (_isAddNewBankDetail) {
        await profilecontroller.postuserBankDetails(
          bankdetailID: 0,
          userID: userID,
          bankname: newBankname.text,
          bankbranch: newBankbranchname.text,
          bankaccountname: newBankaccountname.text,
          bankaccount: int.tryParse(newBankaccountnumber.text) ?? 0,
          ispayroll: _isNewBankPayRoll ? "true" : "false",
        );
      }

      Get.back();
      // Get.to(() => const BottomNavPage());
    } catch (e) {
      Get.back();
      _showErrorSnackbar("Failed to update bank details: $e");
    }
  }

  bool _validateInputs() {
    // Validate existing banks
    for (var bank in _bankDetailsList) {
      final controllers =
          bank['controllers'] as Map<String, TextEditingController>;
      if (controllers['bankName']!.text.isEmpty ||
          controllers['bankBranch']!.text.isEmpty ||
          controllers['bankAccountName']!.text.isEmpty ||
          controllers['bankAccount']!.text.isEmpty) {
        _showErrorSnackbar("Please fill all fields in existing bank details");
        return false;
      }
    }

    // Validate new bank
    if (_isAddNewBankDetail &&
        (newBankname.text.isEmpty ||
            newBankbranchname.text.isEmpty ||
            newBankaccountname.text.isEmpty ||
            newBankaccountnumber.text.isEmpty)) {
      _showErrorSnackbar("Please fill all fields in new bank details");
      return false;
    }

    return true;
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar(
      "Error",
      message,
      snackPosition: SnackPosition.BOTTOM,
      colorText: Colors.white,
      backgroundColor: Colors.red,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit User Bank Detail",
            style: smallStyle.copyWith(
              fontWeight: FontWeight.w700,
              color: isDarkMode ? Colors.white : Colors.black,
            )),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Obx(() {
          final hasBankDetails = _bankDetailsList.isNotEmpty;

          return Column(
            children: [
              if (hasBankDetails) ...[
                ..._bankDetailsList
                    .map((bank) => _buildBankDetailSection(bank, isDarkMode)),
              ],
              _buildAddNewBankSection(isDarkMode),
              _buildBottomButtons(isDarkMode),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildBankDetailSection(Map<String, dynamic> bank, bool isDarkMode) {
    final controllers =
        bank['controllers'] as Map<String, TextEditingController>;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        _buildSectionTitle("Bank Details", isDarkMode),
        _buildTextField("Bank Name", controllers['bankName']!, isDarkMode),
        _buildTextField("Branch Name", controllers['bankBranch']!, isDarkMode),
        _buildTextField(
            "Account Name", controllers['bankAccountName']!, isDarkMode),
        _buildTextField(
            "Account Number", controllers['bankAccount']!, isDarkMode),
        Row(
          children: [
            Checkbox(
              value: bank['isPayroll'],
              onChanged: (value) => _handlePayrollCheckbox(bank['id'], value),
              activeColor: isDarkMode ? Colors.blueAccent : Colors.black,
            ),
            Text("Is Payroll",
                style: smallStyle.copyWith(
                  color: isDarkMode ? Colors.white : Colors.black,
                )),
          ],
        ),
        const Divider(),
      ],
    );
  }

  Widget _buildAddNewBankSection(bool isDarkMode) {
    return Column(
      children: [
        Row(
          children: [
            Checkbox(
              value: _isAddNewBankDetail,
              onChanged: (value) =>
                  setState(() => _isAddNewBankDetail = value ?? false),
              activeColor: isDarkMode ? Colors.blueAccent : Colors.black,
            ),
            Text("Add New Bank",
                style: smallStyle.copyWith(
                  color: isDarkMode ? Colors.white : Colors.black,
                )),
          ],
        ),
        if (_isAddNewBankDetail) ...[
          _buildSectionTitle("New Bank Details", isDarkMode),
          _buildTextField("Bank Name", newBankname, isDarkMode),
          _buildTextField("Branch Name", newBankbranchname, isDarkMode),
          _buildTextField("Account Name", newBankaccountname, isDarkMode),
          _buildTextField("Account Number", newBankaccountnumber, isDarkMode),
          Row(
            children: [
              Checkbox(
                value: _isNewBankPayRoll,
                onChanged: (value) => setState(() {
                  _isNewBankPayRoll = value ?? false;
                  if (_isNewBankPayRoll) {
                    // Uncheck all existing payrolls
                    for (var bank in _bankDetailsList) {
                      bank['isPayroll'] = false;
                    }
                    _selectedPayrollBankId = null;
                  }
                }),
                activeColor: isDarkMode ? Colors.blueAccent : Colors.black,
              ),
              Text("Is Payroll",
                  style: smallStyle.copyWith(
                    color: isDarkMode ? Colors.white : Colors.black,
                  )),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildSectionTitle(String title, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(title,
          style: normalStyle.copyWith(
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black,
          )),
    );
  }

  Widget _buildTextField(
      String title, TextEditingController controller, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: title,
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          labelStyle: smallStyle.copyWith(
              color: isDarkMode ? Colors.white70 : Colors.black54),
        ),
        style: smallStyle.copyWith(
            color: isDarkMode ? Colors.white : Colors.black),
      ),
    );
  }

  Widget _buildBottomButtons(bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: () => Get.back(),
            style: ElevatedButton.styleFrom(
              backgroundColor: isDarkMode ? Colors.blueAccent : Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.arrow_back, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  "Previous",
                  style: smallStyle.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (_validateInputs()) {
                Get.dialog(Center(child: CircularProgressIndicator()));
                _submitUserBankDetails();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isDarkMode ? Colors.blueAccent : Colors.black,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text("Save Changes",
                style: smallStyle.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                )),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Dispose all controllers
    for (var bank in _bankDetailsList) {
      final controllers =
          bank['controllers'] as Map<String, TextEditingController>;
      controllers.values.forEach((controller) => controller.dispose());
    }
    super.dispose();
  }
}
