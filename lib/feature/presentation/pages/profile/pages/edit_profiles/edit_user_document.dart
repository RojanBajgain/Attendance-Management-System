import 'dart:io';

import 'package:ams/feature/presentation/pages/login/controller/login_controller.dart';
import 'package:ams/feature/presentation/pages/profile/model/profile_model.dart';
import 'package:ams/feature/presentation/pages/profile/pages/edit_profiles/edit_user_bank.dart';
import 'package:ams/feature/presentation/pages/profile/pages/edit_profiles/edit_user_info.dart';
import 'package:ams/feature/presentation/pages/profile/widget/image_uploader.dart';
import 'package:ams/feature/utils/ssnackbar_utils.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:ams/config/resources/styles.dart';
import 'package:ams/feature/presentation/pages/profile/controller/profile_controller.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class EditUserDocument extends StatefulWidget {
  final String? profileId;

  const EditUserDocument({super.key, this.profileId});

  @override
  State<EditUserDocument> createState() => _EditUserDocumentState();
}

class _EditUserDocumentState extends State<EditUserDocument> {
  final authcontroller = Get.find<AuthController>();
  final ProfileController profileController = Get.put(ProfileController());

  final List<int> _deletedFileIds = [];
  final List<int> _deletedDocumentIds = [];

  final Map<int, File?> _selectedFiles = {};
  Map<int, Map<String, TextEditingController>> documentControllers = {};
  final TextEditingController newDocumentTitleController =
      TextEditingController();
  final TextEditingController newDocumentIssuedDateController =
      TextEditingController();
  final TextEditingController newDocumentIdentifierController =
      TextEditingController();

  final Map<int, List<int>> _filesToKeep = {};
  final Map<int, String> selectedDocumentTypes = {};
  String newDocumentType = "";

  // Error state for each field
  final Map<String, String> _fieldErrors = {};

  Future<void> pickFile(int documentId) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null) {
      setState(() {
        _selectedFiles[documentId] = File(result.files.single.path!);
        _fieldErrors.remove('file_$documentId');
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeDocuments();
  }

  void _initializeDocuments() {
    final profileData = profileController.profile;
    if (profileData.isNotEmpty && profileData.first.documents != null) {
      for (var document in profileData.first.documents!) {
        if (document.id != null) {
          documentControllers[document.id!] = {
            'title': TextEditingController(text: document.title ?? ""),
            'issuedDate': TextEditingController(
              text: document.issuedDate != null
                  ? DateFormat('yyyy-MM-dd').format(document.issuedDate!)
                  : "",
            ),
            'identifier':
                TextEditingController(text: document.identifier ?? ""),
          };

          selectedDocumentTypes[document.id!] = document.type ?? "N/A";

          if (document.files != null) {
            _filesToKeep[document.id!] =
                document.files!.map((file) => file.id ?? 0).toList();
          } else {
            _filesToKeep[document.id!] = [];
          }
        }
      }
    }
  }

  int get activeDocumentCount {
    final profileData = profileController.profile;
    if (profileData.isEmpty || profileData.first.documents == null) {
      return 0;
    }

    return profileData.first.documents!
        .where((doc) => doc.id != null && !_deletedDocumentIds.contains(doc.id))
        .length;
  }

  Future<void> _deleteDocument(int documentId) async {
    if (activeDocumentCount <= 1) {
      SSnackbarUtil.showSnackbar(
        'Cannot Delete',
        'You must keep at least one document',
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
            'Are you sure you want to delete this document?',
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
                  await profileController.deleteDocument(id: documentId);

                  setState(() {
                    _deletedDocumentIds.add(documentId);
                    documentControllers.remove(documentId);
                    selectedDocumentTypes.remove(documentId);
                    _filesToKeep.remove(documentId);
                    _selectedFiles.remove(documentId);
                    _fieldErrors.removeWhere(
                        (key, value) => key.startsWith('doc_$documentId'));
                  });

                  await profileController.getProfile();
                } catch (e) {
                  Get.back();

                  SSnackbarUtil.showSnackbar(
                    'Error',
                    'Failed to delete document: $e',
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

  Future<void> _submitDocuments() async {
    try {
      final userId = profileController.profile.first.id;
      bool hasError = false;
      String errorMessage = '';

      for (var entry in documentControllers.entries) {
        int documentId = entry.key;
        if (_deletedDocumentIds.contains(documentId)) {
          continue;
        }

        Map<String, TextEditingController> controllers = entry.value;
        List<int> filesToKeep = List<int>.from(_filesToKeep[documentId] ?? []);
        File? selectedFile = _selectedFiles[documentId];

        try {
          await profileController.postuserDocuments(
            documentID: documentId,
            userID: userId,
            type: selectedDocumentTypes[documentId] ?? "N/A",
            title: controllers['title']?.text ?? "",
            identifier: controllers['identifier']?.text ?? "",
            issuedDate: controllers['issuedDate']?.text.isNotEmpty == true
                ? DateFormat('yyyy-MM-dd')
                    .parse(controllers['issuedDate']!.text)
                : null,
            profileId: profileController.profile.first.id,
            filesToKeep: filesToKeep,
            documentImage: selectedFile,
            documentFile: null,
          );
        } catch (e) {
          hasError = true;
          errorMessage = 'Failed to update document: $e';
          break;
        }
      }

      if (!hasError && profileController.isAddNewDocumentChecked.value) {
        String? issuedDateStr = newDocumentIssuedDateController.text.isNotEmpty
            ? newDocumentIssuedDateController.text
            : null;

        try {
          await profileController.postNewUserDocument(
            type: newDocumentType,
            title: newDocumentTitleController.text,
            issuedDateStr: issuedDateStr,
            identifier: newDocumentIdentifierController.text,
            profileId: userId,
            documentFile: _selectedFiles[-1],
          );
        } catch (e) {
          hasError = true;
          errorMessage = 'Failed to add new document: $e';
        }
      }

      Get.back();

      if (hasError) {
        SSnackbarUtil.showSnackbar(
          'Error',
          errorMessage,
          SnackbarType.error,
        );
        return Future.error(errorMessage);
      } else {
        Get.to(() => const EditUserBank());
      }
    } catch (e) {
      SSnackbarUtil.showSnackbar(
        'Error',
        'Failed to update documents: $e',
        SnackbarType.error,
      );
      return Future.error(e);
    }
  }

  bool _validateInputs() {
    setState(() {
      _fieldErrors.clear();
    });

    bool isValid = true;

    // Validate existing documents
    for (var entry in documentControllers.entries) {
      int documentId = entry.key;
      if (_deletedDocumentIds.contains(documentId)) {
        continue;
      }

      Map<String, TextEditingController> controllers = entry.value;

      // Validate document type
      if (!selectedDocumentTypes.containsKey(documentId) ||
          selectedDocumentTypes[documentId] == "N/A") {
        _fieldErrors['doc_${documentId}_type'] = 'Document type is required';
        isValid = false;
      }

      // Validate title
      if (controllers['title']?.text.isEmpty ?? true) {
        _fieldErrors['doc_${documentId}_title'] = 'Title is required';
        isValid = false;
      }

      // Validate issued date
      if (controllers['issuedDate']?.text.isEmpty ?? true) {
        _fieldErrors['doc_${documentId}_issuedDate'] =
            'Issued date is required';
        isValid = false;
      }

      // Validate identifier
      if (controllers['identifier']?.text.isEmpty ?? true) {
        _fieldErrors['doc_${documentId}_identifier'] = 'Identifier is required';
        isValid = false;
      }

      // Validate file (optional, only if no existing files or all deleted)
      /* if (_filesToKeep[documentId]?.isEmpty ?? true) {
        if (!_selectedFiles.containsKey(documentId) ||
            _selectedFiles[documentId] == null) {
          _fieldErrors['file_$documentId'] = 'At least one file is required';
          isValid = false;
        }
      } */
    }

    // Validate new document if checkbox is checked
    if (profileController.isAddNewDocumentChecked.value) {
      if (newDocumentType.isEmpty || newDocumentType == "N/A") {
        _fieldErrors['new_doc_type'] = 'Document type is required';
        isValid = false;
      }
      if (newDocumentTitleController.text.isEmpty) {
        _fieldErrors['new_doc_title'] = 'Title is required';
        isValid = false;
      }
      if (newDocumentIssuedDateController.text.isEmpty) {
        _fieldErrors['new_doc_issuedDate'] = 'Issued date is required';
        isValid = false;
      }
      if (newDocumentIdentifierController.text.isEmpty) {
        _fieldErrors['new_doc_identifier'] = 'Identifier is required';
        isValid = false;
      }
      // if (!_selectedFiles.containsKey(-1) || _selectedFiles[-1] == null) {
      //   _fieldErrors['new_doc_file'] = 'A file is required';
      //   isValid = false;
      // }
    }

    if (!isValid) {
      // SSnackbarUtil.showSnackbar(
      //   'Error',
      //   'Please fill out all required fields correctly',
      //   SnackbarType.error,
      // );
    }

    return isValid;
  }

  Widget _buildDateField(
    String title,
    TextEditingController controller,
    bool isDarkMode, {
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
            readOnly: true,
            decoration: InputDecoration(
              labelText: title,
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: hasError
                      ? Colors.red
                      : (isDarkMode ? Colors.white70 : Colors.black54),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: hasError
                      ? Colors.red
                      : (isDarkMode ? Colors.white70 : Colors.black54),
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
              suffixIcon: Icon(Icons.calendar_today,
                  color: hasError ? Colors.red : null),
            ),
            style: smallStyle.copyWith(
              color: isDarkMode ? Colors.white : Colors.black,
            ),
            onTap: () => _selectDate(context, controller, fieldKey),
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

  Future<void> _selectDate(BuildContext context,
      TextEditingController controller, String fieldKey) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: controller.text.isNotEmpty
          ? DateFormat('yyyy-MM-dd').parse(controller.text)
          : DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            textTheme: const TextTheme(
              headlineMedium: TextStyle(fontSize: 14),
              bodyLarge: TextStyle(fontSize: 12),
              bodyMedium: TextStyle(fontSize: 10),
            ),
            colorScheme: Theme.of(context).brightness == Brightness.dark
                ? ColorScheme.dark(
                    primary: Colors.blueAccent,
                    onPrimary: Colors.white,
                    surface: Colors.grey[800]!,
                    onSurface: Colors.white,
                  )
                : const ColorScheme.light(
                    primary: Colors.black,
                    onPrimary: Colors.white,
                    surface: Colors.white,
                    onSurface: Colors.black,
                  ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(picked);
        _fieldErrors.remove(fieldKey);
      });
    }
  }

  Widget _buildSectionTitle(String title, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: smallStyle.copyWith(
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
                      : (isDarkMode ? Colors.white70 : Colors.black54),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: hasError
                      ? Colors.red
                      : (isDarkMode ? Colors.white70 : Colors.black54),
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

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(
          "Edit User Document",
          style: smallStyle.copyWith(
            fontWeight: FontWeight.w700,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          final profileData = profileController.profile;
          final predefinedDocumentTypes = [
            "PAN",
            "Citizenship",
            "Education",
            "Recommendation",
          ];

          final documentTypes =
              profileData.isNotEmpty && profileData.first.documents != null
                  ? profileData.first.documents!
                      .map((document) => document.type ?? "N/A")
                      .toList()
                  : [];

          final finalDocumentTypes = (documentTypes.isNotEmpty
                  ? {...predefinedDocumentTypes, ...documentTypes}.toList()
                  : predefinedDocumentTypes)
              .cast<String>();

          return Column(
            children: [
              if (profileData.isNotEmpty && profileData.first.documents != null)
                ...profileData.first.documents!
                    .where((doc) => !_deletedDocumentIds.contains(doc.id))
                    .map((document) {
                  return _buildDocumentSection(
                    isDarkMode,
                    finalDocumentTypes,
                    document,
                  );
                }).toList(),
              if (profileData.isNotEmpty &&
                  profileData.first.documents != null &&
                  profileData.first.documents!.isNotEmpty)
                const SizedBox(height: 20),
              _buildAddNewDocumentCheckbox(isDarkMode, profileController),
              if (profileController.isAddNewDocumentChecked.value)
                _buildAddNewDocumentSection(isDarkMode, finalDocumentTypes),
              const SizedBox(height: 16),
              _buildBottomButtons(isDarkMode),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildDocumentSection(
    bool isDarkMode,
    List<String> documentTypes,
    Document document,
  ) {
    if (document.id == null || !documentControllers.containsKey(document.id)) {
      return const SizedBox.shrink();
    }

    final controllers = documentControllers[document.id]!;
    final documentId = document.id!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.edit_calendar_outlined),
                const SizedBox(width: 10.0),
                Text(
                  "Edit Document - ${document.type ?? "N/A"}",
                  style: smallNStyle.copyWith(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
            IconButton(
              icon: Icon(
                Icons.delete,
                color: activeDocumentCount > 1 ? Colors.red : Colors.grey,
              ),
              onPressed: activeDocumentCount > 1
                  ? () => _deleteDocument(document.id!)
                  : null,
              tooltip: activeDocumentCount > 1
                  ? 'Delete Document'
                  : 'Cannot delete the last document',
            ),
          ],
        ),
        const SizedBox(height: 10),
        _buildDropdownField(
          title: "Type",
          items: documentTypes,
          isDarkMode: isDarkMode,
          initialValue: document.type ?? "N/A",
          onChanged: (value) {
            if (value != null && document.id != null) {
              setState(() {
                selectedDocumentTypes[document.id!] = value;
                _fieldErrors.remove('doc_${document.id}_type');
              });
            }
          },
          fieldKey: 'doc_${document.id}_type',
        ),
        const SizedBox(height: 10),
        _buildTextField(
          "Title",
          controllers['title']!,
          isDarkMode,
          fieldKey: 'doc_${documentId}_title',
        ),
        const SizedBox(height: 10),
        _buildDateField(
          "Issued Date",
          controllers['issuedDate']!,
          isDarkMode,
          fieldKey: 'doc_${documentId}_issuedDate',
        ),
        const SizedBox(height: 10),
        _buildTextField(
          "Identifier",
          controllers['identifier']!,
          isDarkMode,
          fieldKey: 'doc_${documentId}_identifier',
        ),
        const SizedBox(height: 10),
        if (document.files != null && document.files!.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle("Existing Documents", isDarkMode),
              const SizedBox(height: 8),
              ...document.files!
                  .where((file) => !_deletedFileIds.contains(file.id))
                  .map((file) {
                return Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.file_present),
                      onPressed: () async {
                        final Uri url = Uri.parse(file.file!);
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url);
                        } else {
                          SSnackbarUtil.showSnackbar(
                            'Error',
                            'Could not open the document',
                            SnackbarType.error,
                          );
                        }
                      },
                    ),
                    Expanded(
                      child: Text(
                        file.file!.split('/').last,
                        style: smallStyle.copyWith(
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        if (file.id != null) {
                          setState(() {
                            _deletedFileIds.add(file.id!);
                            if (_filesToKeep.containsKey(document.id!) &&
                                _filesToKeep[document.id!] != null) {
                              _filesToKeep[document.id!]!.remove(file.id!);
                            }
                            _fieldErrors.remove('file_$documentId');
                          });
                        }
                      },
                    ),
                  ],
                );
              }).toList(),
            ],
          ),
        const SizedBox(height: 16),
        ImageUploadField(
          title: "Add Document",
          hintText: "Choose a File to Upload (Images or Documents)",
          onFilePicked: (FilePickerResult? result) {
            if (result != null) {
              setState(() {
                _selectedFiles[document.id!] = File(result.files.single.path!);
                _fieldErrors.remove('file_$documentId');
              });
            } else {
              setState(() {
                _selectedFiles[document.id!] = null;
              });
            }
          },
        ),
        const SizedBox(height: 24),
        const Divider(),
      ],
    );
  }

  Widget _buildAddNewDocumentCheckbox(
      bool isDarkMode, ProfileController profileController) {
    return Row(
      children: [
        Checkbox(
          value: profileController.isAddNewDocumentChecked.value,
          onChanged: (value) {
            profileController.toggleAddNewDocument(value ?? false);
            setState(() {
              _fieldErrors
                  .removeWhere((key, value) => key.startsWith('new_doc_'));
            });
          },
          activeColor: isDarkMode ? Colors.blueAccent : Colors.black,
        ),
        Text(
          "Add New Document",
          style: smallStyle.copyWith(
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildAddNewDocumentSection(
      bool isDarkMode, List<String> documentTypes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        _buildDropdownField(
          title: "Type",
          items: documentTypes,
          isDarkMode: isDarkMode,
          onChanged: (value) {
            if (value != null) {
              setState(() {
                newDocumentType = value;
                _fieldErrors.remove('new_doc_type');
              });
            }
          },
          fieldKey: 'new_doc_type',
        ),
        const SizedBox(height: 16),
        _buildTextField(
          "New Document Title",
          newDocumentTitleController,
          isDarkMode,
          fieldKey: 'new_doc_title',
        ),
        const SizedBox(height: 16),
        _buildDateField(
          "New Document Issued Date",
          newDocumentIssuedDateController,
          isDarkMode,
          fieldKey: 'new_doc_issuedDate',
        ),
        const SizedBox(height: 16),
        _buildTextField(
          "New Document Identifier",
          newDocumentIdentifierController,
          isDarkMode,
          fieldKey: 'new_doc_identifier',
        ),
        const SizedBox(height: 16),
        ImageUploadField(
          title: "Add Document",
          hintText: "Choose a File to Upload (Images or Documents)",
          onFilePicked: (FilePickerResult? result) {
            if (result != null) {
              setState(() {
                _selectedFiles[-1] = File(result.files.single.path!);
                _fieldErrors.remove('new_doc_file');
              });
            } else {
              setState(() {
                _selectedFiles[-1] = null;
              });
            }
          },
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String title,
    required List<String> items,
    required bool isDarkMode,
    String? initialValue,
    Function(String?)? onChanged,
    required String fieldKey,
  }) {
    final hasError = _fieldErrors.containsKey(fieldKey);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(title, isDarkMode),
        const SizedBox(height: 8),
        DropdownButtonFormField2<String>(
          isExpanded: true,
          value: initialValue,
          onChanged: onChanged,
          items: items.map((type) {
            return DropdownMenuItem<String>(
              value: type,
              child: Text(
                type,
                style: smallStyle.copyWith(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            );
          }).toList(),
          // decoration: InputDecoration(
          //   contentPadding:
          //       const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          //   labelText: hasError ? _fieldErrors[fieldKey] : 'Select',
          //   labelStyle: smallStyle.copyWith(
          //     color: hasError
          //         ? Colors.red
          //         : (isDarkMode ? Colors.white70 : Colors.black54),
          //   ),
          //   border: OutlineInputBorder(
          //     borderSide: BorderSide(
          //       color: hasError
          //           ? Colors.red
          //           : (isDarkMode ? Colors.white70 : Colors.black54),
          //     ),
          //   ),
          //   enabledBorder: OutlineInputBorder(
          //     borderSide: BorderSide(
          //       color: hasError
          //           ? Colors.red
          //           : (isDarkMode ? Colors.white70 : Colors.black54),
          //     ),
          //   ),
          //   focusedBorder: OutlineInputBorder(
          //     borderSide: BorderSide(
          //       color: hasError
          //           ? Colors.red
          //           : (isDarkMode ? Colors.blueAccent : Colors.black),
          //       width: 2.0,
          //     ),
          //   ),
          // ),
          dropdownStyleData: DropdownStyleData(
            maxHeight: 300,
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey.shade800 : Colors.white,
              borderRadius: BorderRadius.circular(13),
            ),
          ),
          buttonStyleData: ButtonStyleData(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(13),
              color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade50,
              border: Border.all(
                color: hasError
                    ? Colors.red
                    : (isDarkMode ? Colors.white70 : Colors.black54),
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
    );
  }

  Widget _buildBottomButtons(bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: () {
              if (Get.isDialogOpen == true) {
                Get.back();
              }
              Get.to(() => EditUserInfo());
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
                Get.dialog(
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
                  barrierDismissible: false,
                );
                _submitDocuments();
              }
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
                Text(
                  "Next",
                  style: smallStyle.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward, color: Colors.white),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
