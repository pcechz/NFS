import 'package:app/models/Anchors.dart';
import 'package:app/pages/details/parallax_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app/Feature/Reader/bible_bloc.dart';
import 'package:app/Foundation/Provider/ReferenceProvider.dart';
import 'package:app/Project/Pages/ReaderPage.dart';
import 'package:app/configs/colors.dart';
import 'package:app/configs/images.dart';
import 'package:app/domain/entities/category.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/core/extensions/context.dart';
import 'package:app/model/lesson.dart';
import 'package:app/model/planets.dart';
import 'package:app/pages/bible/bible_page.dart';
import 'package:app/pages/details/bulletin_page.dart';
import 'package:app/pages/details/detail_page.dart';
import 'package:app/pages/lists/anchors_page.dart';
import 'package:app/pages/lists/lists.dart';
import 'package:app/routers/routes.dart';
import 'package:app/ui/screens/blog_home_screen.dart';
import 'package:app/ui/screens/home/WebViewPage.dart';
import 'package:app/ui/screens/home/updates_page.dart';
import 'package:app/ui/screens/home/updates_page2.dart';
import 'package:app/ui/screens/home/wikipedia_explorer.dart';
// part 'package:app/ui/screens/pokedex/widgets/pokemon_grid.dart';

class PokeCategoryCard extends StatelessWidget {
  const PokeCategoryCard(
    this.category,
    this.anchors,
    this.bulletins, {
    this.onPress,
  });

  final Category category;
  final Function onPress;
  final Anchors anchors;
  final Anchors bulletins;

  Widget _buildCircleDecoration({@required double height}) {
    return Positioned(
      top: -height * 0.616,
      left: -height * 0.53,
      child: CircleAvatar(
        radius: (height * 1.03) / 2,
        backgroundColor: Colors.white.withOpacity(0.14),
      ),
    );
  }

  Widget _buildPokemonDecoration({@required double height}) {
    return Positioned(
      top: -height * 0.16,
      right: -height * 0.25,
      child: Image(
        image: AppImages.pokeball,
        width: height * 1.388,
        height: height * 1.388,
        color: Colors.white.withOpacity(0.14),
      ),
    );
  }
  //final ScrollController _scrollController = ScrollController();

  Future _onRefresh() async {
    //context.read(pokemonsStateProvider).getPokemons(reset: true);
  }
  //   Widget _buildPokemonGrid() {
  //   return Expanded(
  //     child: Consumer(builder: (_, watch, __) {

  //       return _PokemonGrid(
  //         pokemons: category,
  //         canLoadMore: false,
  //         controller: null,
  //         onRefresh: _onRefresh,
  //         onSelectPokemon: (index, pokemon) {

  //           AppNavigator.push(Routes.expandable, pokemon);
  //         },
  //       );
  //     }),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constrains) {
        final itemHeight = constrains.maxHeight;
        final itemWidth = constrains.maxWidth;
        // final anchors =

        return Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.bottomCenter,
              child: _Shadows(color: category.color, width: itemWidth * 0.82),
            ),
            Material(
              color: category.color,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                splashColor: Colors.white10,
                highlightColor: Colors.white10,
                onTap:
                    // () {
                    //   print(category.route);
                    //  // category.route;
                    //   Navigator.push(context,
                    //        MaterialPageRoute(builder: (context) => category.route);
                    //    AppNavigator.push(category.route);
                    // },
                    () {
                  if (category.name == "Anchor") {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ParallaxPage(lesson: anchors, type: 1)));
                  } else if (category.name == "Prayer Bulletin") {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ParallaxPage(lesson: bulletins, type: 2)));
                  } else if (category.name == "Bible") {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => BiblePage()));
                  } else if (category.name == "NIFES Updates") {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => UpdatesPage()));
                  } else if (category.name == "NVM") {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WebViewPage(
                                "https://nifes.org.ng/elearning/", "NVM")));
                  } else if (category.name == "Land of Promise") {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WebViewPage(
                                "https://conferencecentre.nifes.org.ng/",
                                "Land of Promise")));
                  }
                },
                child: Stack(
                  children: [
                    _buildPokemonDecoration(height: itemHeight),
                    _buildCircleDecoration(height: itemHeight),
                    _CardContent(category.name),
                  ],
                ),
              ),
            )
          ],
        );
      },
    );
  }
}

class _CardContent extends StatelessWidget {
  const _CardContent(this.name);

  final String name;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(
          name,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _Shadows extends StatelessWidget {
  const _Shadows({this.color, this.width});

  final Color color;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width * 0.82,
      height: context.responsive(11),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: color,
            offset: Offset(0, context.responsive(3)),
            blurRadius: 23,
          ),
        ],
      ),
    );
  }
}
