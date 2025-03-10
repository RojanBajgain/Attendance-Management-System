import 'package:ams/config/resources/styles.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class ImageUploadField extends StatefulWidget {
  final String title;
  final String hintText;
  final String? currentImagePath;
  final Function(FilePickerResult?) onFilePicked;

  const ImageUploadField({
    Key? key,
    required this.title,
    required this.hintText,
    this.currentImagePath,
    required this.onFilePicked,
  }) : super(key: key);

  @override
  _ImageUploadFieldState createState() => _ImageUploadFieldState();
}

class _ImageUploadFieldState extends State<ImageUploadField> {
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    _imagePath = widget.currentImagePath;
  }

  Future<void> _pickImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
        // allowedExtensions: ['jpg', 'jpeg', 'png'], // Limit to image extensions
      );

      if (result != null) {
        setState(() {
          _imagePath = result.files.single.path;
        });
        widget.onFilePicked(result);
      } else {
        setState(() {
          _imagePath = widget.currentImagePath;
        });
        widget.onFilePicked(null);
      }
    } catch (e) {
      print("Error picking image: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to pick image: $e"),
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
        Text(
          widget.title,
          style: smallStyle.copyWith(
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _pickImage,
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
                    child: _imagePath != null && _imagePath!.isNotEmpty
                        ? Row(
                            children: [
                              Icon(
                                Icons.image,
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  _imagePath!
                                      .split('/')
                                      .last, // Show image file name
                                  style: smallStyle.copyWith(
                                    color: isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                  overflow: TextOverflow
                                      .ellipsis, // Truncate with ellipsis
                                ),
                              ),
                            ],
                          )
                        : Text(
                            widget.hintText,
                            style: smallStyle.copyWith(
                              color: Colors.grey,
                            ),
                          ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _pickImage, // Trigger the image picker on tap
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
