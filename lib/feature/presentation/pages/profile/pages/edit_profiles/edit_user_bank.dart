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

  List<int> _deletedBankIds = [];

  int? _selectedPayrollBankId;
  bool _isAddNewBankDetail = false;
  bool _isNewBankPayRoll = false;

  // List of available banks
  final List<String> _availableBanks = [
    'Agricultural Development Bank Limited',
    'Bank of Kathmandu Limited',
    'Citizens Bank International Limited',
    'Civil Bank Limited',
    'Deutsche Bank AG Nepal',
    'Everest Bank Limited',
    'Global IME Bank Limited',
    'Himalayan Bank Limited',
    'Janata Bank Nepal Limited',
    'Kumari Bank Limited',
    'Lumbini Bank Limited',
    'Mega Bank Nepal Limited',
    'Nepal Bank Limited',
    'Nepal Investment Bank Limited',
    'Nepal Rastra Bank',
    'NMB Bank Limited',
    'Prabhu Bank Limited',
    'Rastriya Banijya Bank Limited',
    'Sanima Bank Limited',
    'Siddhartha Bank Limited',
    'Standard Chartered Bank Nepal Limited',
    'Synergy Finance Limited',
    'Universal Bank Limited',
  ];

  final RxList<String?> _selectedBanks = <String?>[].obs;

  String? _newSelectedBank;

  final TextEditingController newBankbranchname = TextEditingController();
  final TextEditingController newBankaccountname = TextEditingController();
  final TextEditingController newBankaccountnumber = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeBankDetails();
    // profilecontroller.getProfile();
  }

  void _initializeBankDetails() {
    final profiledata = profilecontroller.profile;

    if (profiledata.isNotEmpty && profiledata.first.bankDetails != null) {
      _bankDetailsList.assignAll(
        profiledata.first.bankDetails!.map((bankDetail) {
          if (bankDetail.isPayroll == true) {
            _selectedPayrollBankId = bankDetail.id;
          }

          _selectedBanks.add(bankDetail.bankName);

          return {
            'id': bankDetail.id,
            'bankName': bankDetail.bankName ?? "",
            'bankBranch': bankDetail.bankBranch ?? "",
            'bankAccountName': bankDetail.bankAccountName ?? "",
            'bankAccount': bankDetail.bankAccount ?? "",
            'isPayroll': bankDetail.isPayroll ?? false,
            'controllers': {
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

  int get activeBankDetailsCount {
    return _bankDetailsList
        .where((bank) => !_deletedBankIds.contains(bank['id']))
        .length;
  }

  Future<void> _deleteBankDetail(int bankId) async {
    if (activeBankDetailsCount <= 1) {
      Get.snackbar(
        'Cannot Delete',
        'You must keep at least one bank detail',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.amber,
        colorText: Colors.black,
        duration: const Duration(seconds: 3),
      );
      return;
    }

    // Check if this bank is marked as payroll
    bool isPayrollBank = false;
    for (var bank in _bankDetailsList) {
      if (bank['id'] == bankId && bank['isPayroll'] == true) {
        isPayrollBank = true;
        break;
      }
    }

    if (isPayrollBank) {
      Get.snackbar(
        'Cannot Delete',
        'You cannot delete a bank detail marked as payroll',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.amber,
        colorText: Colors.black,
        duration: const Duration(seconds: 3),
      );
      return;
    }

    Get.dialog(
      Builder(builder: (context) {
        final isDarkMode = Theme.of(context).brightness == Brightness.dark;

        return AlertDialog(
          title: Center(
              child: Text(
            'Confirm Deletion',
            style: normalStyle.copyWith(
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          )),
          content: Text(
            'Are you sure you want to delete this bank detail?',
            style: smallStyle.copyWith(
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text(
                'Cancel',
                style: smallStyle.copyWith(
                  color: Colors.blue,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                Get.back();

                try {
                  await profilecontroller.deleteuserBankDetails(id: bankId);

                  setState(() {
                    _deletedBankIds.add(bankId);

                    if (_selectedPayrollBankId == bankId) {
                      _selectedPayrollBankId = null;
                    }

                    int bankIndex = _bankDetailsList
                        .indexWhere((bank) => bank['id'] == bankId);
                    if (bankIndex != -1) {
                      final controllers = _bankDetailsList[bankIndex]
                          ['controllers'] as Map<String, TextEditingController>;
                      controllers.values
                          .forEach((controller) => controller.dispose());

                      _bankDetailsList.removeAt(bankIndex);
                      _selectedBanks.removeAt(bankIndex);
                    }
                  });
                  // Get.snackbar(
                  //   'Success',
                  //   'Bank detail deleted successfully',
                  //   snackPosition: SnackPosition.TOP,
                  //   backgroundColor: Colors.green,
                  //   colorText: Colors.white,
                  // );

                  await profilecontroller.getProfile();
                } catch (e) {
                  Get.snackbar(
                    'Error',
                    'Failed to delete bank detail: $e',
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                }
              },
              child: Text(
                'Delete',
                style: smallStyle.copyWith(
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  void _handlePayrollCheckbox(int bankId, bool? value) {
    setState(() {
      if (value == true) {
        for (var bank in _bankDetailsList) {
          bank['isPayroll'] = false;
        }
        _selectedPayrollBankId = bankId;
      } else {
        _selectedPayrollBankId = null;
      }

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

      for (int i = 0; i < _bankDetailsList.length; i++) {
        final bank = _bankDetailsList[i];

        if (_deletedBankIds.contains(bank['id'])) {
          continue;
        }

        final controllers =
            bank['controllers'] as Map<String, TextEditingController>;

        await profilecontroller.postuserBankDetails(
          bankdetailID: bank['id'],
          userID: userID,
          bankname: _selectedBanks[i] ?? "",
          bankbranch: controllers['bankBranch']!.text,
          bankaccountname: controllers['bankAccountName']!.text,
          bankaccount: controllers['bankAccount']!.text,
          ispayroll: bank['id'] == _selectedPayrollBankId ? "true" : "false",
        );
      }

      if (_isAddNewBankDetail) {
        await profilecontroller.postnewBankDetails(
          userID: userID,
          bankName: _newSelectedBank ?? "",
          bankBranch: newBankbranchname.text,
          bankaccountName: newBankaccountname.text,
          bankAccount: newBankaccountnumber.text,
          isPayroll: _isNewBankPayRoll ? "true" : "false",
        );
      }

      Get.offAll(() => const BottomNavPage());
    } catch (e) {
      _showErrorSnackbar("Failed to update bank details: $e");
    }
  }

  // void _onPreviousPressed() {
  //   Get.back();
  // }

  bool _validateInputs() {
    // Check if there's at least one payroll bank selected
    bool hasPayrollBank = false;

    // Check existing bank details
    for (var bank in _bankDetailsList) {
      if (!_deletedBankIds.contains(bank['id']) && bank['isPayroll'] == true) {
        hasPayrollBank = true;
        break;
      }
    }

    // Check new bank detail if being added
    if (!hasPayrollBank && _isAddNewBankDetail && _isNewBankPayRoll) {
      hasPayrollBank = true;
    }

    if (!hasPayrollBank) {
      _showErrorSnackbar("There should be at least one bank as payroll");
      return false;
    }

    // Original validation code
    for (int i = 0; i < _bankDetailsList.length; i++) {
      final bank = _bankDetailsList[i];

      if (_deletedBankIds.contains(bank['id'])) {
        continue;
      }

      final controllers =
          bank['controllers'] as Map<String, TextEditingController>;

      String accountNumber = controllers['bankAccount']!.text.trim();

      if (_selectedBanks[i] == null ||
          _selectedBanks[i]!.isEmpty ||
          controllers['bankBranch']!.text.isEmpty ||
          controllers['bankAccountName']!.text.isEmpty ||
          accountNumber.isEmpty) {
        _showErrorSnackbar("Please fill all fields in existing bank details");
        return false;
      }

      if (accountNumber.length > 20) {
        _showErrorSnackbar("Bank account number cannot exceed 20 digits");
        return false;
      }
    }

    if (_isAddNewBankDetail) {
      String newAccountNumber = newBankaccountnumber.text.trim();

      if (_newSelectedBank == null ||
          newBankbranchname.text.isEmpty ||
          newBankaccountname.text.isEmpty ||
          newAccountNumber.isEmpty) {
        _showErrorSnackbar("Please fill all fields in new bank details");
        return false;
      }

      if (newAccountNumber.length > 20) {
        _showErrorSnackbar("Bank account number cannot exceed 20 digits");
        return false;
      }
    }

    return true;
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar(
      "Error",
      message,
      snackPosition: SnackPosition.TOP,
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
                ..._bankDetailsList.asMap().entries.map((entry) {
                  final index = entry.key;
                  final bank = entry.value;

                  if (_deletedBankIds.contains(bank['id'])) {
                    return const SizedBox.shrink();
                  }

                  return _buildBankDetailSection(bank, index, isDarkMode);
                }),
              ],
              _buildAddNewBankSection(isDarkMode),
              _buildBottomButtons(isDarkMode),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildBankDetailSection(
      Map<String, dynamic> bank, int index, bool isDarkMode) {
    final controllers =
        bank['controllers'] as Map<String, TextEditingController>;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSectionTitle("Bank Details", isDarkMode),
            IconButton(
              icon: Icon(Icons.delete,
                  color: activeBankDetailsCount > 1 ? Colors.red : Colors.grey),
              onPressed: (activeBankDetailsCount > 1 && !bank['isPayroll'])
                  ? () => _deleteBankDetail(bank['id'])
                  : null,
              tooltip: bank['isPayroll']
                  ? 'Cannot delete payroll bank'
                  : (activeBankDetailsCount <= 1
                      ? 'Cannot delete the last bank detail'
                      : 'Delete Bank Detail'),
            ),
          ],
        ),
        _buildBankDropdown(index, isDarkMode),
        _buildTextField("Branch Name", controllers['bankBranch']!, isDarkMode),
        _buildTextField(
            "Account Name", controllers['bankAccountName']!, isDarkMode),
        _buildTextField(
          "Account Number",
          controllers['bankAccount']!,
          isDarkMode,
          // keyboardType: const TextInputType.numberWithOptions(),
        ),
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

  Widget _buildBankDropdown(int index, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: isDarkMode ? Colors.white54 : Colors.black54,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: _selectedBanks[index],
              hint: Text('Select Bank',
                  style: smallStyle.copyWith(
                    color: isDarkMode ? Colors.white70 : Colors.black54,
                  )),
              dropdownColor: isDarkMode ? Colors.grey[800] : Colors.white,
              style: smallStyle.copyWith(
                color: isDarkMode ? Colors.white : Colors.black,
              ),
              items: _availableBanks.map((String bank) {
                return DropdownMenuItem<String>(
                  value: bank,
                  child: Text(bank),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedBanks[index] = newValue;
                });
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNewBankDropdown(bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: isDarkMode ? Colors.white54 : Colors.black54,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: _newSelectedBank,
              hint: Text('Select Bank',
                  style: smallStyle.copyWith(
                    color: isDarkMode ? Colors.white70 : Colors.black54,
                  )),
              dropdownColor: isDarkMode ? Colors.grey[800] : Colors.white,
              style: smallStyle.copyWith(
                color: isDarkMode ? Colors.white : Colors.black,
              ),
              items: _availableBanks.map((String bank) {
                return DropdownMenuItem<String>(
                  value: bank,
                  child: Text(bank),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _newSelectedBank = newValue;
                });
              },
            ),
          ),
        ),
      ),
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
          _buildNewBankDropdown(isDarkMode),
          _buildTextField("Branch Name", newBankbranchname, isDarkMode),
          _buildTextField("Account Name", newBankaccountname, isDarkMode),
          _buildTextField(
            "Account Number",
            newBankaccountnumber,
            isDarkMode,
            // keyboardType: const TextInputType.numberWithOptions(),
          ),
          Row(
            children: [
              Checkbox(
                value: _isNewBankPayRoll,
                onChanged: (value) => setState(() {
                  _isNewBankPayRoll = value ?? false;
                  if (_isNewBankPayRoll) {
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
      String title, TextEditingController controller, bool isDarkMode,
      {bool enabled = true, TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        enabled: enabled,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: title,
          border: const OutlineInputBorder(),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          labelStyle: smallStyle.copyWith(
              color: isDarkMode ? Colors.white70 : Colors.black54),
          filled: !enabled,
          fillColor: !enabled
              ? (isDarkMode ? Colors.grey[700] : Colors.grey[200])
              : null,
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
            onPressed: () {
              // Dismiss any open dialogs before navigating back
              if (Get.isDialogOpen == true) {
                Get.back();
              }
              Get.back();
            },
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
                Get.dialog(const Center(child: CircularProgressIndicator()));
                _submitUserBankDetails();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isDarkMode ? Colors.blueAccent : Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
    for (var bank in _bankDetailsList) {
      final controllers =
          bank['controllers'] as Map<String, TextEditingController>;
      controllers.values.forEach((controller) => controller.dispose());
    }
    newBankbranchname.dispose();
    newBankaccountname.dispose();
    newBankaccountnumber.dispose();
    super.dispose();
  }
}
