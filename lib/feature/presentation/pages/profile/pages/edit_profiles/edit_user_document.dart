import 'dart:io';

import 'package:ams/feature/presentation/pages/login/controller/login_controller.dart';
import 'package:ams/feature/presentation/pages/profile/model/profile_model.dart';
import 'package:ams/feature/presentation/pages/profile/pages/edit_profiles/edit_user_bank.dart';
import 'package:ams/feature/presentation/pages/profile/pages/edit_profiles/edit_user_info.dart';
import 'package:ams/feature/presentation/pages/profile/widget/image_uploader.dart';
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
  final ProfileController profileController =
      Get.put(ProfileController(profileRepo: Get.find()));

  List<int> _deletedFileIds = [];
  List<int> _deletedDocumentIds = [];

  Map<int, File?> _selectedFiles = {};

  Map<int, Map<String, TextEditingController>> documentControllers = {};

  final TextEditingController newDocumentTitleController =
      TextEditingController();
  final TextEditingController newDocumentIssuedDateController =
      TextEditingController();
  final TextEditingController newDocumentIdentifierController =
      TextEditingController();

  Map<int, List<int>> _filesToKeep = {};

  final Map<int, String> selectedDocumentTypes = {};
  String newDocumentType = "";

  Future<void> pickFile(int documentId) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null) {
      setState(() {
        _selectedFiles[documentId] = File(result.files.single.path!);
        print(
            "Selected file for Document $documentId: ${result.files.single.path}");
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeDocuments();
  }

  // @override
  // void dispose() {
  //   for (var controllers in documentControllers.values) {
  //     for (var controller in controllers.values) {
  //       controller.dispose();
  //     }
  //   }
  //   newDocumentTitleController.dispose();
  //   newDocumentIssuedDateController.dispose();
  //   newDocumentIdentifierController.dispose();
  //   super.dispose();
  // }

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
      Get.snackbar(
        'Cannot Delete',
        'You must keep at least one document',
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
                  });

                  // Get.back();

                  // Get.snackbar(
                  //   'Success',
                  //   'Document deleted successfully',
                  //   snackPosition: SnackPosition.TOP,
                  //   backgroundColor: Colors.green,
                  //   colorText: Colors.white,
                  // );

                  await profileController.getProfile();
                } catch (e) {
                  Get.back();

                  Get.snackbar(
                    'Error',
                    'Failed to delete document: $e',
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

  Future<void> _submitDocuments() async {
    try {
      final userId = profileController.profile.first.id;
      bool hasError = false;
      String errorMessage = '';

      for (var entry in documentControllers.entries) {
        int documentId = entry.key;
        // Skip deleted documents
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
            identifier: int.tryParse(controllers['identifier']?.text ?? ""),
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
        Get.snackbar(
          'Error',
          errorMessage,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return Future.error(errorMessage);
      } else {
        // Get.snackbar(
        //   'Success',
        //   'Documents updated successfully',
        //   snackPosition: SnackPosition.TOP,
        //   backgroundColor: Colors.green,
        //   colorText: Colors.white,
        // );
        Get.to(() => const EditUserBank());
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update documents: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return Future.error(e);
    }
  }

  bool _validateInputs() {
    // Validate existing documents
    for (var entry in documentControllers.entries) {
      // Skip validation for deleted documents
      if (_deletedDocumentIds.contains(entry.key)) {
        continue;
      }

      int documentId = entry.key;
      Map<String, TextEditingController> controllers = entry.value;

      // Check document type
      if (!selectedDocumentTypes.containsKey(documentId) ||
          selectedDocumentTypes[documentId]!.isEmpty) {
        Get.snackbar(
          'Error',
          'Please select a document type for all documents',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }

      // Check title
      if (controllers['title']?.text.isEmpty ?? true) {
        Get.snackbar(
          'Error',
          'Please fill all required document title fields',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }

      // Check issued date
      if (controllers['issuedDate']?.text.isEmpty ?? true) {
        Get.snackbar(
          'Error',
          'Please select an issued date for all documents',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }

      // Check identifier
      if (controllers['identifier']?.text.isEmpty ?? true) {
        Get.snackbar(
          'Error',
          'Please fill all required document identifier fields',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    }

    // Validate new document if checkbox is checked
    if (profileController.isAddNewDocumentChecked.value) {
      // Check new document type
      if (newDocumentType.isEmpty) {
        Get.snackbar(
          'Error',
          'Please select a type for the new document',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }

      // Check new document title
      if (newDocumentTitleController.text.isEmpty) {
        Get.snackbar(
          'Error',
          'Please enter a title for the new document',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }

      // Check new document issued date
      if (newDocumentIssuedDateController.text.isEmpty) {
        Get.snackbar(
          'Error',
          'Please select an issued date for the new document',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }

      // Check new document identifier
      if (newDocumentIdentifierController.text.isEmpty) {
        Get.snackbar(
          'Error',
          'Please enter an identifier for the new document',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }

      // Check if file is uploaded for new document
      if (!_selectedFiles.containsKey(-1) || _selectedFiles[-1] == null) {
        Get.snackbar(
          'Error',
          'Please upload a file for the new document',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    }

    return true;
  }

  Widget _buildDateField(
      String title, TextEditingController controller, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          labelText: title,
          border: const OutlineInputBorder(),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          labelStyle: smallStyle.copyWith(
              color: isDarkMode ? Colors.white70 : Colors.black54),
          suffixIcon: const Icon(Icons.calendar_today),
        ),
        style: smallStyle.copyWith(
            color: isDarkMode ? Colors.white : Colors.black),
        onTap: () => _selectDate(context, controller),
      ),
    );
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
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
              headlineMedium: TextStyle(fontSize: 18),
              bodyLarge: TextStyle(fontSize: 16),
              bodyMedium: TextStyle(fontSize: 14),
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
      controller.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  Widget _buildSectionTitle(String title, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(title,
          style: smallStyle.copyWith(
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
            // "Others"
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
                // const Divider(thickness: 2),
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
            // Delete document button
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
              selectedDocumentTypes[document.id!] = value;
            }
          },
        ),
        const SizedBox(height: 10),
        _buildTextField("Title", controllers['title']!, isDarkMode),
        const SizedBox(height: 10),
        _buildDateField("Issued Date", controllers['issuedDate']!, isDarkMode),
        const SizedBox(height: 10),
        _buildTextField(
          "Identifier",
          controllers['identifier']!,
          isDarkMode,
          // keyboardType: const TextInputType.numberWithOptions(),
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
                          Get.snackbar(
                            'Error',
                            'Could not open the document',
                            snackPosition: SnackPosition.TOP,
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
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
                print(
                    "Selected file for Document ${document.id}: ${result.files.single.path}");
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
        // const SizedBox(height: 10.0),
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
              newDocumentType = value;
            }
          },
        ),
        const SizedBox(height: 16),
        _buildTextField(
            "New Document Title", newDocumentTitleController, isDarkMode),
        const SizedBox(height: 16),
        _buildDateField("New Document Issued Date",
            newDocumentIssuedDateController, isDarkMode),
        const SizedBox(height: 16),
        _buildTextField(
          "New Document Identifier",
          newDocumentIdentifierController,
          isDarkMode,
          // keyboardType: const TextInputType.numberWithOptions(),
        ),
        const SizedBox(height: 16),
        ImageUploadField(
          title: "Add Document",
          hintText: "Choose a File to Upload (Images or Documents)",
          onFilePicked: (FilePickerResult? result) {
            if (result != null) {
              setState(() {
                _selectedFiles[-1] = File(result.files.single.path!);
                print(
                    "Selected file for new document: ${result.files.single.path}");
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
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(title, isDarkMode),
        const SizedBox(height: 8),
        Container(
          height: 50.0,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13.0),
            color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade50,
            border: Border.all(color: Colors.black, width: 1.0),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: FormBuilderDropdown<String>(
              name: 'document_type',
              onChanged: onChanged,
              hint: Text(
                "Select",
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
              decoration: const InputDecoration(border: InputBorder.none),
              items: items.map<DropdownMenuItem<String>>((type) {
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
              initialValue: initialValue,
            ),
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
              // Dismiss any open dialogs before navigating back
              if (Get.isDialogOpen == true) {
                Get.back();
              }
              Get.to(
                  () => EditUserInfo()); // Navigate back to the previous page
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
