/*
 * Autor: Juan Daniel Valido Jeronimo
 * Correo: jvalidojeronimo@gmail.com
 * Fecha de creación: 07/07/2023
 */

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:surco/features/products/presentation/providers/partys_provider.dart';
import 'package:surco/features/products/presentation/widgets/party_card.dart';
import 'package:surco/features/shared/shared.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      drawer: SideMenu(scaffoldKey: scaffoldKey),
      appBar: AppBar(
        title: const Text('Bienvenido'),
      ),
      body: const _ProductsView(),

      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Añadir'),
        icon: const Icon(Icons.add),
        onPressed: () {
          context.push('/partys/new');
        },
      ),
      
    );
  }
}

class _ProductsView extends ConsumerStatefulWidget {
  const _ProductsView();

  @override
  _ProductsViewState createState() => _ProductsViewState();
}

class _ProductsViewState extends ConsumerState {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if(scrollController.position.pixels + 400 >= scrollController.position.maxScrollExtent){
        ref.read(partysProvider.notifier).loadNextPage();
      }
    });


  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final partysState = ref.watch(partysProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: MasonryGridView.count(
        physics: const BouncingScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 20,
        crossAxisSpacing: 35,
        itemCount: partysState.partys.length,
        itemBuilder: (context, index) {
          final party = partysState.partys[index];
          return GestureDetector(
            onTap: () =>context.push('/partys/${party.id}'),
            child: PartyCard(party: party)
          );
        },
      ),
    );
  }
}
