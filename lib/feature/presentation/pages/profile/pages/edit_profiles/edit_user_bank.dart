import 'package:ams/feature/presentation/pages/bottom_nav/bottom_nav_page.dart';
import 'package:ams/feature/presentation/pages/login/controller/login_controller.dart';
import 'package:ams/feature/presentation/pages/profile/model/profile_model.dart';
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
  final profilecontroller = Get.put(ProfileController(profileRepo: Get.find()));

  final RxList<BankDetail> _bankDetailsList = <BankDetail>[].obs;
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
    final profileData = profilecontroller.profile;

    if (profileData.isNotEmpty && profileData.first.bankDetails.isNotEmpty) {
      _bankDetailsList.assignAll(profileData.first.bankDetails);

      for (var bankDetail in profileData.first.bankDetails) {
        _selectedBanks.add(bankDetail.bankName);

        if (bankDetail.isPayroll) {
          _selectedPayrollBankId = bankDetail.id;
        }
      }
    }
  }

  int get activeBankDetailsCount {
    return _bankDetailsList
        .where((bank) => !_deletedBankIds.contains(bank.id))
        .length;
  }

  Future<void> _deleteBankDetail(int bankId) async {
    if (activeBankDetailsCount <= 1) {
      SSnackbarUtil.showFadeSnackbar(
        Get.context!,
        'You must keep at least one bank detail',
        SnackbarType.warning,
      );
      return;
    }

    bool isPayrollBank =
        _bankDetailsList.any((bank) => bank.id == bankId && bank.isPayroll);

    if (isPayrollBank) {
      SSnackbarUtil.showFadeSnackbar(
        Get.context!,
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
                        .indexWhere((bank) => bank.id == bankId);
                    if (bankIndex != -1) {
                      _bankDetailsList.removeAt(bankIndex);
                      _selectedBanks.removeAt(bankIndex);
                      _fieldErrors.removeWhere(
                          (key, value) => key.startsWith('bank_$bankId'));
                    }
                  });

                  await profilecontroller.getProfile();
                } catch (e) {
                  SSnackbarUtil.showFadeSnackbar(
                    Get.context!,
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
          bank.isPayroll = false;
        }
        _selectedPayrollBankId = bankId;
        _isNewBankPayRoll = false;
      } else {
        _selectedPayrollBankId = null;
      }

      for (var bank in _bankDetailsList) {
        if (bank.id == bankId) {
          bank.isPayroll = value ?? false;
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

        if (_deletedBankIds.contains(bank.id)) {
          continue;
        }

        await profilecontroller.postuserBankDetails(
          bankdetailID: bank.id,
          profileID: userID,
          bankname: _selectedBanks[i] ?? "",
          bankbranch: bank.bankBranch,
          bankaccountname: bank.bankAccountName,
          bankaccount: bank.bankAccount,
          ispayroll: bank.id == _selectedPayrollBankId ? "true" : "false",
        );
      }

      if (_isAddNewBankDetail) {
        await profilecontroller.postnewBankDetails(
          profileID: userID,
          bankName: _newSelectedBank ?? "",
          bankBranch: newBankbranchname.text,
          bankaccountName: newBankaccountname.text,
          bankAccount: newBankaccountnumber.text,
          isPayroll: _isNewBankPayRoll ? "true" : "false",
        );
      }

      Get.offAll(() => BottomNavPage());
    } catch (e) {
      SSnackbarUtil.showFadeSnackbar(
        Get.context!,
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
    bool hasPayrollBank = _bankDetailsList
        .any((bank) => !_deletedBankIds.contains(bank.id) && bank.isPayroll);

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
      final bankId = bank.id;

      if (_deletedBankIds.contains(bankId)) {
        continue;
      }

      // Validate bank name
      if (_selectedBanks[i] == null || _selectedBanks[i]!.isEmpty) {
        _fieldErrors['bank_${bankId}_name'] = 'Bank name is required';
        isValid = false;
      }

      // Validate branch name
      if (bank.bankBranch.isEmpty) {
        _fieldErrors['bank_${bankId}_branch'] = 'Branch name is required';
        isValid = false;
      }

      // Validate account name
      if (bank.bankAccountName.isEmpty) {
        _fieldErrors['bank_${bankId}_accountName'] = 'Account name is required';
        isValid = false;
      }

      // Validate account number
      String accountNumber = bank.bankAccount;
      if (accountNumber.isEmpty) {
        _fieldErrors['bank_${bankId}_account'] = 'Account number is required';
        isValid = false;
      } else if (accountNumber.length > 20) {
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
      } else if (newAccountNumber.length > 20) {
        _fieldErrors['new_bank_account'] =
            'Account number cannot exceed 20 digits';
        isValid = false;
      }
    }

    return isValid;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 20.0,
        title: Text(
          "Edit User Bank Detail",
          style: smallStyle.copyWith(
            fontWeight: FontWeight.w700,
            color: isDarkMode ? Colors.white : Colors.black,
            fontSize: 14,
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

                  if (_deletedBankIds.contains(bank.id)) {
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

  Widget _buildBankDetailSection(BankDetail bank, int index, bool isDarkMode) {
    final bankId = bank.id;

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
                color: activeBankDetailsCount > 1 && !bank.isPayroll
                    ? Colors.red
                    : Colors.grey,
              ),
              onPressed: (activeBankDetailsCount > 1 && !bank.isPayroll)
                  ? () => _deleteBankDetail(bankId)
                  : null,
              tooltip: bank.isPayroll
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
          initialValue: bank.bankName,
          onChanged: (String? newValue) {
            setState(() {
              _selectedBanks[index] = newValue;
              bank.bankName = newValue ?? "";
              _fieldErrors.remove('bank_${bankId}_name');
            });
          },
          fieldKey: 'bank_${bankId}_name',
        ),
        _buildBankTextField(
          "Branch Name",
          bank.bankBranch,
          isDarkMode,
          onChanged: (value) {
            bank.bankBranch = value;
            _fieldErrors.remove('bank_${bankId}_branch');
          },
          fieldKey: 'bank_${bankId}_branch',
        ),
        _buildBankTextField(
          "Account Name",
          bank.bankAccountName,
          isDarkMode,
          onChanged: (value) {
            bank.bankAccountName = value;
            _fieldErrors.remove('bank_${bankId}_accountName');
          },
          fieldKey: 'bank_${bankId}_accountName',
        ),
        _buildBankTextField(
          "Account Number",
          bank.bankAccount,
          isDarkMode,
          onChanged: (value) {
            bank.bankAccount = value;
            _fieldErrors.remove('bank_${bankId}_account');
          },
          fieldKey: 'bank_${bankId}_account',
        ),
        Row(
          children: [
            Checkbox(
              value: bank.isPayroll,
              onChanged: (value) => _handlePayrollCheckbox(bankId, value),
              activeColor: isDarkMode ? Colors.blueAccent : Colors.black,
            ),
            Text(
              "Is Payroll",
              style: smallStyle.copyWith(
                color: isDarkMode ? Colors.white : Colors.black,
                fontSize: 12,
              ),
            ),
          ],
        ),
        if (_fieldErrors.containsKey('payroll') && !bank.isPayroll)
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
    String? initialValue,
    required Function(String?) onChanged,
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
                    fontSize: 11,
                  ),
                  items: _availableBanks.map((String bank) {
                    return DropdownMenuItem<String>(
                      value: bank,
                      child: Text(bank),
                    );
                  }).toList(),
                  onChanged: onChanged,
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

  Widget _buildBankTextField(
    String title,
    String value,
    bool isDarkMode, {
    required Function(String) onChanged,
    required String fieldKey,
    TextInputType? keyboardType,
  }) {
    final hasError = _fieldErrors.containsKey(fieldKey);
    final controller = TextEditingController(text: value);
    controller.addListener(() => onChanged(controller.text));

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: controller,
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
                fontSize: 12,
                color: hasError
                    ? Colors.red
                    : (isDarkMode ? Colors.white70 : Colors.black),
              ),
            ),
            style: smallStyle.copyWith(
              color: isDarkMode ? Colors.white : Colors.black,
              fontSize: 11,
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
                      fontSize: 11,
                      color: hasError
                          ? Colors.red
                          : (isDarkMode ? Colors.white70 : Colors.black54),
                    ),
                  ),
                  dropdownColor: isDarkMode ? Colors.grey[800] : Colors.white,
                  style: smallStyle.copyWith(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontSize: 11,
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
                fontSize: 12,
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
                      bank.isPayroll = false;
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
          fontSize: 14,
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
                fontSize: 12,
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
              fontSize: 11,
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
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (_validateInputs()) {
                Get.dialog(const Center(
                    child: CircularProgressIndicator(
                  color: Colors.cyan,
                )));
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
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    newBankbranchname.dispose();
    newBankaccountname.dispose();
    newBankaccountnumber.dispose();
    super.dispose();
  }
}
