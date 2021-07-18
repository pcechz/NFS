part of '../home.dart';

class _HeaderAppBar extends StatelessWidget {
  static const double heightFraction = 0.66;

  const _HeaderAppBar({
    @required this.height,
    @required this.showTitle,
    @required this.category,
    @required this.anchors,
    @required this.bulletins,
  });

  final double height;
  final bool showTitle;
  final List<Category> category;
  final Anchors anchors;
  final Anchors bulletins;

  Widget _buildTitle(visible) {
    if (!visible) {
      return null;
    }

    return Text(
      'NIFES APP',
      style: TextStyle(
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildCategories(BuildContext context) {
    final spacing = context.responsive(10);
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 28,
          vertical: context.responsive(40),
        ),
        child: LayoutBuilder(
          builder: (_, constrains) {
            final width = constrains.maxWidth;
            final height = constrains.maxHeight;
            final itemHeight = (height - 2 * spacing) / 3;

            return Wrap(
              alignment: WrapAlignment.spaceBetween,
              runAlignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: category
                  .map(
                    (e) => SizedBox(
                      width: (width - spacing) / 2,
                      height: itemHeight,
                      child: PokeCategoryCard(
                        e,
                        anchors,
                        bulletins,
                        onPress: () => AppNavigator.push(e.route),
                      ),
                    ),
                  )
                  .toList(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30),
        ),
      ),
      child: PokeballBackground(
        buildChildren: (_) => [
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              VSpacer(context.responsive(60) + context.padding.top),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 28),
                child: Text(
                  'Welcome',
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.4 * context.responsive(30) / 30,
                    fontWeight: FontWeight.w900,
                    color: AppColors.blue,
                  ),
                ),
              ),
              VSpacer(context.responsive(10)),
              //SearchBar(),
              _buildCategories(context),

              //  VSpacer(context.responsive(28)),
              // Padding(
              //  padding: EdgeInsets.symmetric(horizontal: 28),
              //  child:

              //   child: Text(
              //     '"But while they were on their way to buy the oil, the bridegroom arrived. The virgins who were ready went in with him to the wedding banquet. And the door was shut"',
              //     style: TextStyle(
              //       fontSize: 15,
              //       height: 1.4 * context.responsive(30) / 30,
              //       fontWeight: FontWeight.w900,
              //     ),
              //   ),
              //),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      // automaticallyImplyLeading: false,

      expandedHeight: height,
      floating: true,
      pinned: true,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30),
        ),
      ),
      iconTheme: IconThemeData(color: Colors.blue.shade900),
      backgroundColor: AppColors.red,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        centerTitle: true,
        title: _buildTitle(showTitle),
        background: _buildCard(context),
      ),
    );
  }
}
