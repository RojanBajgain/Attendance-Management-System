import 'dart:io';

import 'package:ams/feature/presentation/pages/login/controller/login_controller.dart';
import 'package:ams/feature/presentation/pages/profile/model/profile_model.dart';
import 'package:ams/feature/presentation/pages/profile/pages/edit_profiles/edit_user_bank.dart';
import 'package:ams/feature/presentation/pages/profile/widget/image_uploader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:ams/config/resources/styles.dart';
import 'package:ams/feature/presentation/pages/profile/controller/profile_controller.dart';
import 'package:ams/feature/presentation/pages/profile/widget/file_uploader.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) => _initializeDocuments());
  }

  @override
  void dispose() {
    for (var controllers in documentControllers.values) {
      for (var controller in controllers.values) {
        controller.dispose();
      }
    }
    newDocumentTitleController.dispose();
    newDocumentIssuedDateController.dispose();
    newDocumentIdentifierController.dispose();
    super.dispose();
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

  Future<void> _submitDocuments() async {
    try {
      final userId = profileController.profile.first.id;

      for (var entry in documentControllers.entries) {
        int documentId = entry.key;
        Map<String, TextEditingController> controllers = entry.value;

        List<int> filesToKeep = List<int>.from(_filesToKeep[documentId] ?? []);

        File? selectedFile = _selectedFiles[documentId];

        await profileController.postuserDocuments(
          documentID: documentId,
          userID: userId,
          type: selectedDocumentTypes[documentId] ?? "N/A",
          title: controllers['title']?.text ?? "",
          identifier: int.tryParse(controllers['identifier']?.text ?? ""),
          issuedDate: controllers['issuedDate']?.text.isNotEmpty == true
              ? DateFormat('yyyy-MM-dd').parse(controllers['issuedDate']!.text)
              : null,
          profileId: profileController.profile.first.id,
          filesToKeep: filesToKeep,
          documentImage: selectedFile,
          documentFile: null,
        );
      }

      if (profileController.isAddNewDocumentChecked.value) {
        await profileController.postuserDocuments(
          documentID: 0,
          userID: userId,
          type: newDocumentType,
          title: newDocumentTitleController.text,
          identifier: int.tryParse(newDocumentIdentifierController.text),
          issuedDate: newDocumentIssuedDateController.text.isNotEmpty
              ? DateFormat('yyyy-MM-dd')
                  .parse(newDocumentIssuedDateController.text)
              : null,
          profileId: profileController.profile.first.id,
          filesToKeep: [], // Empty list for new documents
          documentImage: _selectedFiles[-1],
          documentFile: _selectedFiles[-1],
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update documents: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  bool _validateInputs() {
    for (var controllers in documentControllers.values) {
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
    }

    if (profileController.isAddNewDocumentChecked.value) {
      if (newDocumentType.isEmpty || newDocumentTitleController.text.isEmpty) {
        Get.snackbar(
          'Error',
          'Please fill all required fields for the new document',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    }

    return true;
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
            "Others"
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
                ...profileData.first.documents!.map((document) {
                  return _buildDocumentSection(
                    isDarkMode,
                    finalDocumentTypes,
                    document,
                  );
                }).toList(),
              const SizedBox(height: 16),
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
          children: [
            const Icon(Icons.edit_calendar_outlined),
            const SizedBox(width: 10.0),
            Text(
              "Edit Document - ${document.type ?? "N/A"}",
              style: normalStyle.copyWith(
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
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
        const SizedBox(height: 16),
        _buildInputTextField(
          title: "Title",
          controller: controllers['title']!,
          isDarkMode: isDarkMode,
        ),
        const SizedBox(height: 16),
        _buildInputTextField(
          title: "Issued Date",
          controller: controllers['issuedDate']!,
          isDarkMode: isDarkMode,
        ),
        const SizedBox(height: 16),
        _buildInputTextField(
          title: "Identifier",
          controller: controllers['identifier']!,
          isDarkMode: isDarkMode,
        ),
        const SizedBox(height: 16),
        if (document.files != null && document.files!.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Existing Documents",
                style: smallStyle.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
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
        SizedBox(height: 10.0),
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
        _buildInputTextField(
          title: "New Document Title",
          controller: newDocumentTitleController,
          isDarkMode: isDarkMode,
        ),
        const SizedBox(height: 16),
        _buildInputTextField(
          title: "New Document Issued Date",
          controller: newDocumentIssuedDateController,
          isDarkMode: isDarkMode,
        ),
        const SizedBox(height: 16),
        _buildInputTextField(
          title: "New Document Identifier",
          controller: newDocumentIdentifierController,
          isDarkMode: isDarkMode,
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
        Text(
          title,
          style: smallStyle.copyWith(
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
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

  Widget _buildInputTextField({
    required String title,
    required TextEditingController controller,
    required bool isDarkMode,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: smallStyle.copyWith(
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          style: smallStyle.copyWith(
            color: isDarkMode ? Colors.white : Colors.black,
          ),
          decoration: InputDecoration(
            isDense: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(
                width: 1,
                color: isDarkMode ? Colors.white70 : Colors.grey.shade300,
              ),
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
                Get.dialog(
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
                  barrierDismissible: false,
                );

                _submitDocuments().then((_) {
                  Get.back(); // Close loading dialog
                  Get.to(() => EditUserBank());
                }).catchError((error) {
                  Get.back(); // Close loading dialog
                });
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
