import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:photo_view/photo_view.dart';
import 'package:om_appcart/view/widgets/full_image_viewer.dart';
import '../../constants/colors.dart';
import '../../utils/responsive_helper.dart';
import '../../feature/lost_and_found/model/lost_found_table_record.dart'; // Import model
import 'cust_text.dart';

class FileUploadSection extends StatefulWidget {
  final List<dynamic> files; // Can be File or FoundAttachment
  final Function(List<dynamic>) onFilesChanged;

  const FileUploadSection({
    Key? key,
    required this.files,
    required this.onFilesChanged,
  }) : super(key: key);

  @override
  State<FileUploadSection> createState() => _FileUploadSectionState();
}

class _FileUploadSectionState extends State<FileUploadSection> {
  Future<void> _pickFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.any,
      );

      if (result != null) {
        List<File> processedFiles = [];
        for (var path in result.paths) {
          if (path == null) continue;
          File file = File(path);
          String extension = path.split('.').last.toLowerCase();

          if (['jpg', 'jpeg', 'png'].contains(extension)) {
            // Crop Image
            File? croppedFile = await _cropImage(file);
            if (croppedFile != null) {
              // Compress Image
              File? compressedFile = await _compressImage(croppedFile);
              if (compressedFile != null) {
                processedFiles.add(compressedFile);
              } else {
                 processedFiles.add(croppedFile); // Fallback to cropped if compression fails
              }
            }
          } else {
            processedFiles.add(file);
          }
        }
        
        if (processedFiles.isNotEmpty) {
           widget.onFilesChanged([...widget.files, ...processedFiles]);
        }
      }
    } catch (e) {
      print('Error picking files: $e');
    }
  }

  Future<File?> _cropImage(File file) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: file.path,
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: AppColors.gradientStart,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
            hideBottomControls: true),
        IOSUiSettings(
          title: 'Crop Image',
          aspectRatioPickerButtonHidden: true,
          resetButtonHidden: true,
        ),
      ],
    );
    return croppedFile != null ? File(croppedFile.path) : null;
  }

  Future<File?> _compressImage(File file) async {
    String targetPath = file.path.replaceFirst(RegExp(r'\.(jpg|jpeg|png)$', caseSensitive: false), '_compressed.jpg'); 
    
    var result = await FlutterImageCompress.compressAndGetFile(
      file.path,
      targetPath,
      quality: 85, 
    );

    return result != null ? File(result.path) : null;
  }

  void _removeFile(int index) {
    List<dynamic> updatedFiles = List.from(widget.files);
    updatedFiles.removeAt(index);
    widget.onFilesChanged(updatedFiles);
  }

  String _getFileSize(dynamic item) {
    if (item is File) {
      int bytes = item.lengthSync();
      if (bytes < 1024) return '$bytes B';
      if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(2)} KB';
      return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    } else if (item is FoundAttachment) {
      return item.fileSize ?? 'N/A';
    }
    return 'N/A';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: GestureDetector(
              onTap: _pickFiles,
              child: Stack(
                children: [
                  CustomPaint(
                    size: const Size(double.infinity, 120),
                    painter: DashedBorderPainter(
                      color: Colors.black,
                      strokeWidth: 1.0,
                      dashWidth: 5.0,
                      dashSpace: 5.0,
                    ),
                  ),
                  Positioned.fill(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.cloud_upload_outlined, size: 40, color: AppColors.textColor3),
                        const SizedBox(height: 8),
                        CustText(
                          name: 'Choose file to upload',
                          size: 1.8,
                          fontWeightName: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (widget.files.isNotEmpty) ...[
          SizedBox(height: ResponsiveHelper.spacing(context, 16)),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: ResponsiveHelper.spacing(context, 16),
              horizontal: ResponsiveHelper.spacing(context, 16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustText(
                  name: '${widget.files.length} Files',
                  size: 2.2,
                ),
                SizedBox(height: ResponsiveHelper.spacing(context, 8)),
                ...widget.files.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  String name = '';
                  String size = _getFileSize(item);
                  String? thumbUrl;

                  if (item is File) {
                    name = item.path.split('/').last;
                  } else if (item is FoundAttachment) {
                    name = item.fileName;
                    thumbUrl = item.filePath;
                  }

                  return _buildFileListItem(
                    name,
                    size,
                    () => _removeFile(index),
                    thumbUrl: thumbUrl,
                    localFile: item is File ? item : null,
                  );
                }).toList(),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildFileListItem(String fileName, String fileSize, VoidCallback onRemove, {String? thumbUrl, File? localFile}) {
    return GestureDetector(
        onTap: () {
          final extension = fileName.split('.').last.toLowerCase();
          if (['jpg', 'jpeg', 'png'].contains(extension)) {
            final provider = thumbUrl != null
                ? NetworkImage(thumbUrl)
                : localFile != null
                    ? FileImage(localFile)
                    : const AssetImage("assets/images/drawer/profile_pic.png") as ImageProvider;
            
            FullImageViewer.show(
              context,
              imageProvider: provider,
              heroTag: 'file_${fileName}_${thumbUrl ?? localFile?.path}',
            );
          }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8.0),
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        decoration: BoxDecoration(
          color: AppColors.dividerColor,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          children: [
            Hero(
                tag: 'file_${fileName}_${thumbUrl ?? localFile?.path}',
                child: Container(
                  height: ResponsiveHelper.height(context, 40),
                  width: ResponsiveHelper.height(context, 40),
                  decoration: BoxDecoration(
                    color: AppColors.containerColor,
                    borderRadius: BorderRadius.circular(5),
                    image: thumbUrl != null
                      ? DecorationImage(image: NetworkImage(thumbUrl), fit: BoxFit.cover)
                      : localFile != null && ['.jpg', '.jpeg', '.png'].any((ext) => localFile.path.toLowerCase().endsWith(ext))
                        ? DecorationImage(image: FileImage(localFile), fit: BoxFit.cover)
                        : null,
                  ),
                  child: (thumbUrl == null && localFile == null) ? const Icon(Icons.file_present, size: 20) : null,
                ),
              ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustText(
                    name: fileName,
                    size: 1.7,
                    fontWeightName: FontWeight.w500,
                    color: Colors.black,
                  ),
                  CustText(
                    name: fileSize,
                    size: 1.4,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close, size: 20, color: Colors.grey),
              onPressed: onRemove,
            ),
          ],
        ),
      ),
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;

  DashedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.dashWidth,
    required this.dashSpace,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    final dashPath = Path();
    final dashCount = (size.width / (dashWidth + dashSpace)).floor();
    final dashCountVertical = (size.height / (dashWidth + dashSpace)).floor();

    // Draw horizontal dashes
    for (int i = 0; i < dashCount; i++) {
      final startX = i * (dashWidth + dashSpace);
      dashPath.moveTo(startX, 0);
      dashPath.lineTo(startX + dashWidth, 0);
    }

    // Draw vertical dashes
    for (int i = 0; i < dashCountVertical; i++) {
      final startY = i * (dashWidth + dashSpace);
      dashPath.moveTo(size.width, startY);
      dashPath.lineTo(size.width, startY + dashWidth);
    }

    // Draw bottom horizontal dashes
    for (int i = 0; i < dashCount; i++) {
      final startX = i * (dashWidth + dashSpace);
      dashPath.moveTo(startX, size.height);
      dashPath.lineTo(startX + dashWidth, size.height);
    }

    // Draw left vertical dashes
    for (int i = 0; i < dashCountVertical; i++) {
      final startY = i * (dashWidth + dashSpace);
      dashPath.moveTo(0, startY);
      dashPath.lineTo(0, startY + dashWidth);
    }

    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
} 