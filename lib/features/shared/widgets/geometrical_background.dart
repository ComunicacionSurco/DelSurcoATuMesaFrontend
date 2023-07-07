/*
 * Autor: Juan Daniel Valido Jeronimo
 * Correo: jvalidojeronimo@gmail.com
 * Fecha de creación: 07/07/2023
 */

import 'package:flutter/material.dart';


class GeometricalBackground extends StatelessWidget {
  final Widget child;
  const GeometricalBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final borderSize = size.width / 7; // Este es el tamaño para colocar 7 elementos


/*     final shapeWidgets = [
      _Square(borderSize),
    ]; */


    return SizedBox.expand(
      child: Stack(
        children: [

          Positioned(child: Container(color: backgroundColor)),

          // Background with shapes
          Container(
            height: size.height * 0.7,
            decoration: const BoxDecoration(
              color: Colors.black,
            ),
            child: Column(
              children: [
                //ShapeRow(shapeWidgets: shapeWidgets),
              ],
            )
          ),

          

          // Child widget
          child,
        ],
      ),
    );
  }
}

/// El objetivo de este widget es crear una final de figuras geometricas
/// Es Stateful porque quiero mantener el estado del mismo
/// El initState rompe la referencia para que lo pueda usar en varios lugares
class ShapeRow extends StatefulWidget {
  const ShapeRow({
    super.key,
    required this.shapeWidgets,
  });

  final List<Widget> shapeWidgets;

  @override
  State<ShapeRow> createState() => _ShapeRowState();
}

class _ShapeRowState extends State<ShapeRow> {

  late List<Widget> shapeMixedUp;

  @override
  void initState() {
    super.initState();
    shapeMixedUp = [...widget.shapeWidgets];
    shapeMixedUp.shuffle();
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: shapeMixedUp);
  }
}



class _Square extends StatelessWidget {
  final double borderSize;

  const _Square(this.borderSize);


  @override
  Widget build(BuildContext context) {
    return Container(
      width: borderSize,
      height: borderSize,
      decoration: const BoxDecoration(
        color: Colors.black,
      ),
    );
  }
}




