import 'package:ams/config/resources/styles.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class FileUploadField extends StatefulWidget {
  final String title;
  final String hintText;
  final String? currentFileName;
  final Function(FilePickerResult?) onFilePicked;

  const FileUploadField({
    Key? key,
    required this.title,
    required this.hintText,
    this.currentFileName,
    required this.onFilePicked,
  }) : super(key: key);

  @override
  _FileUploadFieldState createState() => _FileUploadFieldState();
}

class _FileUploadFieldState extends State<FileUploadField> {
  String? _fileName;

  @override
  void initState() {
    super.initState();
    _fileName = widget.currentFileName;
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        setState(() {
          _fileName = result.files.single.name;
        });
        widget.onFilePicked(result);
      } else {
        setState(() {
          _fileName = widget.currentFileName;
        });
        widget.onFilePicked(null);
      }
    } catch (e) {
      print("Error picking file: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to pick file: $e"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.title,
            style: smallStyle.copyWith(
              color: isDarkMode ? Colors.white : Colors.black,
              fontSize: 11,
            )),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _pickFile,
          child: Container(
            height: 50.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: Colors.grey),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(_fileName ?? widget.hintText,
                        style: smallStyle.copyWith(
                          color:
                              _fileName != null ? Colors.white : Colors.black,
                        )),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _pickFile,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
