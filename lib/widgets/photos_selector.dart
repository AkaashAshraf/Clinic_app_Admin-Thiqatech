import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class PhotosSelector extends StatefulWidget {
  final List<dynamic> photos;
  final int limit;
  final void Function(List<dynamic>)? onChanged;

  const PhotosSelector({
    required this.photos,
    this.limit = 5,
    this.onChanged,
  });

  @override
  _PhotosSelectorState createState() => _PhotosSelectorState();
}

class _PhotosSelectorState extends State<PhotosSelector> {
  final ImagePicker _picker = ImagePicker();
  List<dynamic> _photos = [];

  @override
  void initState() {
    _photos = widget.photos;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(16.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'photos',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                SizedBox(width: 8.0),
                IconButton(
                  onPressed: _addPhoto,
                  icon: Icon(Icons.add),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            if (_photos.isEmpty)
              Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.14,
                  right: MediaQuery.of(context).size.width * 0.14,
                  bottom: 24.0,
                ),
                child: Text(
                  '',
                  textAlign: TextAlign.center,
                ),
              )
            else
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: _photos
                    .map(
                      (photo) => Column(
                    children: [
                      if (photo is File)
                        Image.file(
                          photo,
                          width: 50.0,
                          height: 50.0,
                          fit: BoxFit.cover,
                        )
                      else if (photo is String)
                        Image.network(
                          'https://talibcenter.com/$photo',
                          width: 50.0,
                          height: 50.0,
                          fit: BoxFit.cover,
                        ),
                      TextButton(
                        onPressed: () => setState(() {
                          _photos.removeAt(_photos.indexOf(photo));
                          if (widget.onChanged != null) {
                            widget.onChanged!(_photos);
                          }
                        }),
                        style: TextButton.styleFrom(
                          primary: Colors.red,
                        ),
                        child: Text('Remove'),
                      ),
                    ],
                  ),
                )
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _addPhoto() async {
    final List<XFile>? pickedFile = await _picker.pickMultiImage(
      // source: ImageSource.gallery,
      // imageQuality: 25,
    );
    // final images = await _picker.pickMultiImage();

    if (pickedFile != null && pickedFile.isNotEmpty) {
      if (_photos.length < widget.limit) {
        setState(() {
          for (var file in pickedFile) {
            if (_photos.length < widget.limit) {
              _photos.add(File(file.path));
            }
          }
          if (widget.onChanged != null) {
            widget.onChanged!(_photos);
          }
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            'Photos limit reached. Can only add ${widget.limit} photos.',
          ),
        ));
      }
    }
  }
}
