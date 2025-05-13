import 'package:ams/feature/presentation/pages/bottom_nav/bottom_nav_page.dart';
import 'package:ams/feature/presentation/pages/login/controller/login_controller.dart';
import 'package:ams/feature/utils/ssnackbar_utils.dart';
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
  final ProfileController profilecontroller = Get.put(ProfileController());

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

  // Error state for each field
  final Map<String, String> _fieldErrors = {};

  @override
  void initState() {
    super.initState();
    _initializeBankDetails();
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
      SSnackbarUtil.showSnackbar(
        'Cannot Delete',
        'You must keep at least one bank detail',
        SnackbarType.warning,
      );
      return;
    }

    bool isPayrollBank = false;
    for (var bank in _bankDetailsList) {
      if (bank['id'] == bankId && bank['isPayroll'] == true) {
        isPayrollBank = true;
        break;
      }
    }

    if (isPayrollBank) {
      SSnackbarUtil.showSnackbar(
        'Cannot Delete',
        'You cannot delete a bank detail marked as payroll',
        SnackbarType.warning,
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
                      _fieldErrors.removeWhere(
                          (key, value) => key.startsWith('bank_$bankId'));
                    }
                  });

                  await profilecontroller.getProfile();
                } catch (e) {
                  SSnackbarUtil.showSnackbar(
                    'Error',
                    'Failed to delete bank detail: $e',
                    SnackbarType.error,
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
        _isNewBankPayRoll = false;
      } else {
        _selectedPayrollBankId = null;
      }

      for (var bank in _bankDetailsList) {
        if (bank['id'] == bankId) {
          bank['isPayroll'] = value ?? false;
        }
      }
      _fieldErrors.remove('payroll');
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
      SSnackbarUtil.showSnackbar(
        'Error',
        'Failed to update bank details: $e',
        SnackbarType.error,
      );
    }
  }

  bool _validateInputs() {
    setState(() {
      _fieldErrors.clear();
    });

    bool isValid = true;

    // Check for at least one payroll bank
    bool hasPayrollBank = false;
    for (var bank in _bankDetailsList) {
      if (!_deletedBankIds.contains(bank['id']) && bank['isPayroll'] == true) {
        hasPayrollBank = true;
        break;
      }
    }
    if (_isAddNewBankDetail && _isNewBankPayRoll) {
      hasPayrollBank = true;
    }
    if (!hasPayrollBank) {
      _fieldErrors['payroll'] = 'At least one bank must be marked as payroll';
      isValid = false;
    }

    // Validate existing bank details
    for (int i = 0; i < _bankDetailsList.length; i++) {
      final bank = _bankDetailsList[i];
      final bankId = bank['id'];

      if (_deletedBankIds.contains(bankId)) {
        continue;
      }

      final controllers =
          bank['controllers'] as Map<String, TextEditingController>;

      // Validate bank name
      if (_selectedBanks[i] == null || _selectedBanks[i]!.isEmpty) {
        _fieldErrors['bank_${bankId}_name'] = 'Bank name is required';
        isValid = false;
      }

      // Validate branch name
      if (controllers['bankBranch']!.text.isEmpty) {
        _fieldErrors['bank_${bankId}_branch'] = 'Branch name is required';
        isValid = false;
      }

      // Validate account name
      if (controllers['bankAccountName']!.text.isEmpty) {
        _fieldErrors['bank_${bankId}_accountName'] = 'Account name is required';
        isValid = false;
      }

      // Validate account number
      String accountNumber = controllers['bankAccount']!.text.trim();
      if (accountNumber.isEmpty) {
        _fieldErrors['bank_${bankId}_account'] = 'Account number is required';
        isValid = false;
      }
      // else if (!RegExp(r'^\d+$').hasMatch(accountNumber)) {
      //   _fieldErrors['bank_${bankId}_account'] =
      //       'Account number must be numeric';
      //   isValid = false;
      // }
      else if (accountNumber.length > 20) {
        _fieldErrors['bank_${bankId}_account'] =
            'Account number cannot exceed 20 digits';
        isValid = false;
      }
    }

    // Validate new bank details if being added
    if (_isAddNewBankDetail) {
      if (_newSelectedBank == null || _newSelectedBank!.isEmpty) {
        _fieldErrors['new_bank_name'] = 'Bank name is required';
        isValid = false;
      }
      if (newBankbranchname.text.isEmpty) {
        _fieldErrors['new_bank_branch'] = 'Branch name is required';
        isValid = false;
      }
      if (newBankaccountname.text.isEmpty) {
        _fieldErrors['new_bank_accountName'] = 'Account name is required';
        isValid = false;
      }
      String newAccountNumber = newBankaccountnumber.text.trim();
      if (newAccountNumber.isEmpty) {
        _fieldErrors['new_bank_account'] = 'Account number is required';
        isValid = false;
      }
      // else if (!RegExp(r'^\d+$').hasMatch(newAccountNumber)) {
      //   _fieldErrors['new_bank_account'] = 'Account number must be numeric';
      //   isValid = false;
      // }
      else if (newAccountNumber.length > 20) {
        _fieldErrors['new_bank_account'] =
            'Account number cannot exceed 20 digits';
        isValid = false;
      }
    }

    // if (!isValid) {
    //   SSnackbarUtil.showSnackbar(
    //     'Error',
    //     'Please fill out all required fields correctly',
    //     SnackbarType.error,
    //   );
    // }

    return isValid;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit User Bank Detail",
          style: smallStyle.copyWith(
            fontWeight: FontWeight.w700,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
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
    final bankId = bank['id'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSectionTitle("Bank Details", isDarkMode),
            IconButton(
              icon: Icon(
                Icons.delete,
                color: activeBankDetailsCount > 1 && !bank['isPayroll']
                    ? Colors.red
                    : Colors.grey,
              ),
              onPressed: (activeBankDetailsCount > 1 && !bank['isPayroll'])
                  ? () => _deleteBankDetail(bankId)
                  : null,
              tooltip: bank['isPayroll']
                  ? 'Cannot delete payroll bank'
                  : (activeBankDetailsCount <= 1
                      ? 'Cannot delete the last bank detail'
                      : 'Delete Bank Detail'),
            ),
          ],
        ),
        _buildBankDropdown(
          index,
          isDarkMode,
          fieldKey: 'bank_${bankId}_name',
        ),
        _buildTextField(
          "Branch Name",
          controllers['bankBranch']!,
          isDarkMode,
          fieldKey: 'bank_${bankId}_branch',
        ),
        _buildTextField(
          "Account Name",
          controllers['bankAccountName']!,
          isDarkMode,
          fieldKey: 'bank_${bankId}_accountName',
        ),
        _buildTextField(
          "Account Number",
          controllers['bankAccount']!,
          isDarkMode,
          // keyboardType: TextInputType.number,
          fieldKey: 'bank_${bankId}_account',
        ),
        Row(
          children: [
            Checkbox(
              value: bank['isPayroll'],
              onChanged: (value) => _handlePayrollCheckbox(bankId, value),
              activeColor: isDarkMode ? Colors.blueAccent : Colors.black,
            ),
            Text(
              "Is Payroll",
              style: smallStyle.copyWith(
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
        if (_fieldErrors.containsKey('payroll') && bank['isPayroll'] == false)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 12),
            child: Text(
              _fieldErrors['payroll']!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
        const Divider(),
      ],
    );
  }

  Widget _buildBankDropdown(
    int index,
    bool isDarkMode, {
    required String fieldKey,
  }) {
    final hasError = _fieldErrors.containsKey(fieldKey);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: hasError
                    ? Colors.red
                    : (isDarkMode ? Colors.white54 : Colors.black54),
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
                  hint: Text(
                    hasError ? _fieldErrors[fieldKey]! : 'Select Bank',
                    style: smallStyle.copyWith(
                      color: hasError
                          ? Colors.red
                          : (isDarkMode ? Colors.white70 : Colors.black54),
                    ),
                  ),
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
                      _fieldErrors.remove(fieldKey);
                    });
                  },
                ),
              ),
            ),
          ),
          if (hasError)
            Padding(
              padding: const EdgeInsets.only(top: 4, left: 12),
              child: Text(
                _fieldErrors[fieldKey]!,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNewBankDropdown(bool isDarkMode) {
    const fieldKey = 'new_bank_name';
    final hasError = _fieldErrors.containsKey(fieldKey);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: hasError
                    ? Colors.red
                    : (isDarkMode ? Colors.white54 : Colors.black54),
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
                  hint: Text(
                    hasError ? _fieldErrors[fieldKey]! : 'Select Bank',
                    style: smallStyle.copyWith(
                      color: hasError
                          ? Colors.red
                          : (isDarkMode ? Colors.white70 : Colors.black54),
                    ),
                  ),
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
                      _fieldErrors.remove(fieldKey);
                    });
                  },
                ),
              ),
            ),
          ),
          if (hasError)
            Padding(
              padding: const EdgeInsets.only(top: 4, left: 12),
              child: Text(
                _fieldErrors[fieldKey]!,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
        ],
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
              onChanged: (value) {
                setState(() {
                  _isAddNewBankDetail = value ?? false;
                  _fieldErrors
                      .removeWhere((key, value) => key.startsWith('new_bank_'));
                  if (!_isAddNewBankDetail) {
                    _isNewBankPayRoll = false;
                    _newSelectedBank = null;
                    newBankbranchname.clear();
                    newBankaccountname.clear();
                    newBankaccountnumber.clear();
                  }
                });
              },
              activeColor: isDarkMode ? Colors.blueAccent : Colors.black,
            ),
            Text(
              "Add New Bank",
              style: smallStyle.copyWith(
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
        if (_isAddNewBankDetail) ...[
          _buildSectionTitle("New Bank Details", isDarkMode),
          _buildNewBankDropdown(isDarkMode),
          _buildTextField(
            "Branch Name",
            newBankbranchname,
            isDarkMode,
            fieldKey: 'new_bank_branch',
          ),
          _buildTextField(
            "Account Name",
            newBankaccountname,
            isDarkMode,
            fieldKey: 'new_bank_accountName',
          ),
          _buildTextField(
            "Account Number",
            newBankaccountnumber,
            isDarkMode,
            // keyboardType: TextInputType.number,
            fieldKey: 'new_bank_account',
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
                  _fieldErrors.remove('payroll');
                }),
                activeColor: isDarkMode ? Colors.blueAccent : Colors.black,
              ),
              Text(
                "Is Payroll",
                style: smallStyle.copyWith(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
          if (_fieldErrors.containsKey('payroll') && !_isNewBankPayRoll)
            Padding(
              padding: const EdgeInsets.only(top: 4, left: 12),
              child: Text(
                _fieldErrors['payroll']!,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
        ],
      ],
    );
  }

  Widget _buildSectionTitle(String title, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: normalStyle.copyWith(
          fontWeight: FontWeight.bold,
          color: isDarkMode ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  Widget _buildTextField(
    String title,
    TextEditingController controller,
    bool isDarkMode, {
    bool enabled = true,
    TextInputType? keyboardType,
    required String fieldKey,
  }) {
    final hasError = _fieldErrors.containsKey(fieldKey);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: controller,
            enabled: enabled,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              labelText: title,
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: hasError
                      ? Colors.red
                      : (isDarkMode ? Colors.white54 : Colors.black54),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: hasError
                      ? Colors.red
                      : (isDarkMode ? Colors.white54 : Colors.black54),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: hasError
                      ? Colors.red
                      : (isDarkMode ? Colors.blueAccent : Colors.black),
                  width: 2.0,
                ),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              labelStyle: smallStyle.copyWith(
                color: hasError
                    ? Colors.red
                    : (isDarkMode ? Colors.white70 : Colors.black54),
              ),
              filled: !enabled,
              fillColor: !enabled
                  ? (isDarkMode ? Colors.grey[700] : Colors.grey[200])
                  : null,
            ),
            style: smallStyle.copyWith(
              color: isDarkMode ? Colors.white : Colors.black,
            ),
            onChanged: (value) {
              if (hasError) {
                setState(() {
                  _fieldErrors.remove(fieldKey);
                });
              }
            },
          ),
          if (hasError)
            Padding(
              padding: const EdgeInsets.only(top: 4, left: 12),
              child: Text(
                _fieldErrors[fieldKey]!,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
        ],
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              "Save Changes",
              style: smallStyle.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
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
