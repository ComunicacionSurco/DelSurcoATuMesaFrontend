/*
 * Autor: Juan Daniel Valido Jeronimo
 * Correo: jvalidojeronimo@gmail.com
 * Fecha de creación: 07/07/2023
 */

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:go_router/go_router.dart';
import 'package:surco/features/auth/presentation/providers/auth_provider.dart';
import 'package:surco/features/auth/presentation/providers/providers.dart';
import 'package:surco/features/products/domain/domain.dart';
import 'package:surco/features/products/presentation/providers/partys_repository_provider.dart';
import 'package:surco/features/products/presentation/providers/providers.dart';
import 'package:surco/features/products/presentation/screens/products_screen.dart';
import 'package:surco/features/shared/shared.dart';
import 'package:surco/features/shared/widgets/full_screen_loader.dart';
import '../../../shared/widgets/custom_product_field.dart';
import '../providers/party_provider.dart';
import 'package:http/http.dart' as http;

class ProductScreen extends ConsumerWidget {
  final String productId;

  const ProductScreen({super.key, required this.productId});

  void showSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text(
        "Producto Editado",
        style: TextStyle(color: Colors.black),
      ),
      backgroundColor: Color.fromRGBO(251, 217, 139, 0.889),
    ));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final partyState = ref.watch(partyProvider(productId));

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Editar Producto",
            style: TextStyle(fontSize: 20),
          ),
          actions: [
            IconButton(
                onPressed: () async {
                  final photoPath =
                      await CameraGalleyServiceImpl().selectPhoto();
                  if (photoPath == null) return;

                  ref
                      .read(partyFromProvider(partyState.party!).notifier)
                      .updatePartyImage(photoPath);
                },
                icon: const Icon(Icons.photo_library_rounded)),
            IconButton(
                onPressed: () async {
                  final photoPath = await CameraGalleyServiceImpl().takePhoto();
                  if (photoPath == null) return;

                  ref
                      .read(partyFromProvider(partyState.party!).notifier)
                      .updatePartyImage(photoPath);
                },
                icon: const Icon(Icons.camera_alt_rounded))
          ],
        ),
        body: partyState.isLoading
            ? const FullScreenLoader()
            : _ProductView(party: partyState.party!),
        floatingActionButton: SpeedDial(
          spaceBetweenChildren: 10,
          spacing: 10,
          animatedIcon: AnimatedIcons.menu_close,
          animatedIconTheme: const IconThemeData(size: 22.0),
          curve: Curves.bounceIn,
          overlayColor: const Color.fromARGB(255, 255, 255, 255),
          overlayOpacity: 0.5,
          tooltip: 'Speed Dial',
          heroTag: 'speed-dial-hero-tag',
          backgroundColor: const Color.fromARGB(255, 193, 251, 131),
          foregroundColor: Colors.black,
          elevation: 8.0,
          shape: const CircleBorder(),
          children: [
            SpeedDialChild(
                child: const Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
                backgroundColor: const Color.fromARGB(255, 255, 56, 112),
                label: 'Borrar',
                labelBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
                onTap: () async {
                  String url =
                      'http://192.168.1.68:3000/api/products/${partyState.id}';
                  String token = ref.read(authProvider).user!.token;

                  http.delete(
                    Uri.parse(url),
                    headers: {'Authorization': 'Bearer $token'},
                  );
                    final user = partyState.party!.user!.email;
                    ref.read(loginFormProvider.notifier).loginUserCallback(user,"Password1234");
                    showSnackbar(context);

                  if (!context.canPop()) return;
                  context.pop();
                }),
            SpeedDialChild(
              child: const Icon(Icons.replay_outlined, color: Colors.white),
              backgroundColor: const Color.fromARGB(255, 131, 175, 251),
              label: 'Actualizar',
              labelBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
              onTap: () {
                if (partyState.party == null) return;
                ref
                    .read(partyFromProvider(partyState.party!).notifier)
                    .onFormSubmit()
                    .then((value) {
                  if (!value) return;
                  if (!context.canPop()) return;
                  context.pop();
                  showSnackbar(context);
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductView extends ConsumerWidget {
  final Party party;

  const _ProductView({required this.party});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final partyForm = ref.watch(partyFromProvider(party));
    final textStyles = Theme.of(context).textTheme;

    return ListView(
      children: [
        SizedBox(
          height: 250,
          width: 600,
          child: _ImageGallery(images: partyForm.images),
        ),
        const SizedBox(height: 10),
        Center(
            child: Text(
          partyForm.title.value,
          style: textStyles.titleSmall,
          textAlign: TextAlign.center,
        )),
        const SizedBox(height: 10),
        _ProductInformation(party: party),
      ],
    );
  }
}

class _ProductInformation extends ConsumerWidget {
  final Party party;
  const _ProductInformation({required this.party});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final partyForm = ref.watch(partyFromProvider(party));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 15),
          CustomProductField(
            isTopField: true,
            isBottomField: true,
            label: 'Nombre',
            initialValue: partyForm.title.value,
            onChanged:
                ref.read(partyFromProvider(party).notifier).onTitleChange,
            errorMessage: partyForm.title.errorMessage,
          ),
          const SizedBox(height: 25),
          CustomProductField(
            isTopField: true,
            isBottomField: true,
            label: 'Precio',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            initialValue: partyForm.price.value.toString(),
            onChanged: (value) => ref
                .read(partyFromProvider(party).notifier)
                .onPriceChange(double.tryParse(value) ?? -1.0),
            errorMessage: partyForm.price.errorMessage,
          ),
          const SizedBox(height: 25),
          CustomProductField(
            isTopField: true,
            isBottomField: true,
            label: 'Existencias',
            keyboardType: const TextInputType.numberWithOptions(decimal: false),
            initialValue: partyForm.inStock.value.toString(),
            onChanged: (value) => ref
                .read(partyFromProvider(party).notifier)
                .onStockChange(int.tryParse(value) ?? -1),
            errorMessage: partyForm.inStock.errorMessage,
          ),
          const SizedBox(height: 25),
        ],
      ),
    );
  }
}

class _ImageGallery extends StatelessWidget {
  final List<String> images;
  const _ImageGallery({required this.images});

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) {
      return ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          child: Image.asset('assets/images/fondo_2.png', fit: BoxFit.cover));
    }

    return PageView(
      scrollDirection: Axis.horizontal,
      controller: PageController(viewportFraction: 0.7),
      children: images.map((image) {
        late ImageProvider imageProvider;

        if (image.startsWith('http')) {
          imageProvider = NetworkImage(image);
        } else {
          imageProvider = FileImage(File(image));
        }

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              child: FadeInImage(
                fit: BoxFit.cover,
                image: imageProvider,
                placeholder: const AssetImage('assets/images/fondo_2.png'),
              )),
        );
      }).toList(),
    );
  }
}
