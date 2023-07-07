/*
 * Autor: Juan Daniel Valido Jeronimo
 * Correo: jvalidojeronimo@gmail.com
 * Fecha de creación: 07/07/2023
 */

import 'package:surco/features/shared/infraestructure/services/camera_gallery_service.dart';
import 'package:image_picker/image_picker.dart';

class CameraGalleyServiceImpl extends CameraGalleryService{
  final ImagePicker _picker = ImagePicker();


  @override
  Future<String?> selectPhoto() async {
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      );

      if(photo == null) return null;

      print("Tenemos una imagen ${photo.path}");

      return photo.path;
  }

  @override
  Future<String?> takePhoto() async {
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
      preferredCameraDevice: CameraDevice.rear
      );

      if(photo == null) return null;

      print("Tenemos una imagen ${photo.path}");

      return photo.path;

  }

}