import 'package:culturapp/domain/models/actividad.dart';
import 'package:culturapp/presentacio/controlador_presentacio.dart';
import 'package:culturapp/presentacio/widgets/widgetsUtils/image_category.dart';
import 'package:culturapp/presentacio/widgets/widgetsUtils/text_with_link.dart';
import 'package:culturapp/translations/AppLocalizations';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class ListaActividadesDisponibles extends StatefulWidget {
  final List<Actividad> actividades;
  final ControladorPresentacion controladorPresentacion;
  const ListaActividadesDisponibles({super.key, required this.actividades, required this.controladorPresentacion});

  @override
  State<ListaActividadesDisponibles> createState() => _ListaActividadesDisponiblesState(controladorPresentacion);
}

class _ListaActividadesDisponiblesState extends State<ListaActividadesDisponibles> {
  late ControladorPresentacion _controladorPresentacion;
      final List<String> catsAMB = [
    "Residus",
    "territori.espai_public_platges",
    "Sostenibilitat",
    "Aigua",
    "territori.espai_public_parcs",
    "Espai públic - Rius",
    "Espai públic - Parcs",
    "Portal de transparència",
    "Mobilitat sostenible",
    "Internacional",
    "Activitat econòmica",
    "Polítiques socials",
    "territori.espai_public_rius",
    "Espai públic - Platges"
  ];

  _ListaActividadesDisponiblesState(ControladorPresentacion controladorPresentacion){
    _controladorPresentacion = controladorPresentacion;
  }

  @override
  void initState() {
    super.initState();
  }

    Image _retornaIcon(String categoria) {
    if (catsAMB.contains(categoria)) {
      return Image.asset(
        'assets/categoriareciclar.png',
        width: 45.0,
      );
    } else {
      switch (categoria) {
        case 'carnavals':
          return Image.asset(
            'assets/categoriacarnaval.png',
            width: 45.0,
          );
        case 'teatre':
          return Image.asset(
            'assets/categoriateatre.png',
            width: 45.0,
          );
        case 'concerts':
          return Image.asset(
            'assets/categoriaconcert.png',
            width: 45.0,
          );
        case 'circ':
          return Image.asset(
            'assets/categoriacirc.png',
            width: 45.0,
          );
        case 'exposicions':
          return Image.asset(
            'assets/categoriaarte.png',
            width: 45.0,
          );
        case 'conferencies':
          return Image.asset(
            'assets/categoriaconfe.png',
            width: 45.0,
          );
        case 'commemoracions':
          return Image.asset(
            'assets/categoriacommemoracio.png',
            width: 45.0,
          );
        case 'rutes-i-visites':
          return Image.asset(
            'assets/categoriaruta.png',
            width: 45.0,
          );
        case 'cursos':
          return Image.asset(
            'assets/categoriaexpo.png',
            width: 45.0,
          );
        case 'activitats-virtuals':
          return Image.asset(
            'assets/categoriavirtual.png',
            width: 45.0,
          );
        case 'infantil':
          return Image.asset(
            'assets/categoriainfantil.png',
            width: 45.0,
          );
        case 'festes':
          return Image.asset(
            'assets/categoriafesta.png',
            width: 45.0,
          );
        case 'festivals-i-mostres':
          return Image.asset(
            'assets/categoriafesta.png',
            width: 45.0,
          );
        case 'dansa':
          return Image.asset(
            'assets/categoriafesta.png',
            width: 45.0,
          );
        case 'cicles':
          return Image.asset(
            'assets/categoriaexpo.png',
            width: 45.0,
          );
        case 'cultura-digital':
          return Image.asset(
            'assets/categoriavirtual.png',
            width: 45.0,
          );
        case 'fires-i-mercats':
          return Image.asset(
            'assets/categoriainfantil.png',
            width: 45.0,
          );
        case 'gegants':
          return Image.asset(
            'assets/categoriafesta.png',
            width: 45.0,
          );
        default:
          return Image.asset(
            'assets/categoriarecom.png',
            width: 45.0,
          );
      }
    }
  }

  String getCategoria(Actividad actividad) {
  try {
    return actividad.categoria.toString();
  } catch (error) {
    return "default";
  }
}

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    body: SingleChildScrollView(
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () async {
            await _controladorPresentacion.actualizaOrg();
            List<String> act = [
              widget.actividades[index].name,
              widget.actividades[index].code,
              widget.actividades[index].categoria.join(', '),
               widget.actividades[index].imageUrl,
               widget.actividades[index].descripcio,
               widget.actividades[index].dataInici,
               widget.actividades[index].dataFi,
               widget.actividades[index].ubicacio,
               widget.actividades[index].latitud.toString(),
               widget.actividades[index].longitud.toString()
            ];
            _controladorPresentacion.mostrarVerActividad(
              context, 
              act, 
               widget.actividades[index].urlEntrades
            );
            },
             child: Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 16.0,
                            bottom: 24.0,
                            right: 16.0,
                            left: 16.0,
                          ),
                          child: Column(children: [
                          Row(
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: SizedBox(
                                  height:  widget.actividades[index].dataInici !=  widget.actividades[index].dataFi ? 150.0 : 120.0,
                                  width:  widget.actividades[index].dataInici !=  widget.actividades[index].dataFi ? 150.0 : 120.0, 
                                  child: Image.network(
                                     widget.actividades[index].imageUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Center(
                                        child: Icon(
                                          Icons.error_outline,
                                          color: Colors.red,
                                          size: 48,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10.0),
                              Flexible(
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .start,
                                      children: [
                                        Flexible(
                                          child: Text(
                                             widget.actividades[index].name,
                                            style: const TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFFF4692A),
                                            ),
                                          ),
                                        ),
                                        const Padding(
                                            padding: EdgeInsets.only(right: 5.0)),
                                        _retornaIcon( widget.actividades[index].categoria[
                                            0]),
                                      ],
                                    ),
                                    const Padding(padding: EdgeInsets.only(top: 7.5)),
                                    Row(
                                      children: [
                                        const Icon(Icons.location_on),
                                        const Padding(
                                            padding: EdgeInsets.only(right: 7.5)),
                                        Expanded(
                                          child: Text(
                                             widget.actividades[index].ubicacio,
                                            overflow: TextOverflow
                                                .ellipsis, 
                                          ),
                                        ),
                                      ],
                                    ),
                              Row(
                                children: [
                                  const Icon(Icons.calendar_month),
                                  const Padding(padding: EdgeInsets.only(right: 7.5)),
                                  Text( widget.actividades[index].dataInici),
                                ],
                              ),
                               widget.actividades[index].dataInici !=  widget.actividades[index].dataFi
                                  ? Row(
                                      children: [
                                        const Icon(Icons.calendar_month),
                                        const Padding(padding: EdgeInsets.only(right: 7.5)),
                                        Text( widget.actividades[index].dataFi),
                                      ],
                                    )
                                  : Container(),
                                    Row(
                                      children: [
                                        const Icon(Icons.local_atm),
                                        const Padding(
                                            padding: EdgeInsets.only(right: 7.5)),
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              launchUrl( widget.actividades[index]
                                                  .urlEntrades);
                                            },
                                            child: Text(
                                              'tickets_info'.tr(context),
                                              style: const TextStyle(
                                                decoration: TextDecoration
                                                    .underline, color: Colors.blue,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                  ],
                                ),
                              ),
                            ],
                          ),
                          ],),
                        ),
                      ),
                    ),
          );
        },
        itemCount: widget.actividades.length,
      ),
    ),
  );
}
}