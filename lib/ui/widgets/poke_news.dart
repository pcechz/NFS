import 'package:app/model/blog_model.dart';
import 'package:app/ui/screens/blog_screen.dart';
import 'package:flutter/material.dart';
import 'package:app/configs/colors.dart';
import 'package:app/core/extensions/context.dart';
import 'package:app/utils/constants.dart';

class PokeNews extends StatelessWidget {
  const PokeNews(
      {@required this.title,
      @required this.time,
      @required this.thumbnail,
      @required this.blog});

  final String thumbnail;
  final String time;
  final String title;
  final Blog blog;

  Widget _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: context.responsive(6)),
        Text(
          time,
          style: TextStyle(
            fontSize: 10,
            color: AppColors.black.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 28,
        vertical: context.responsive(16),
      ),
      child: GestureDetector(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Flexible(
              flex: 2,
              child: _buildContent(context),
            ),
            SizedBox(width: 36),
            Flexible(
              flex: 1,
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: thumbnail == null
                    ? Image.asset(Constants.NEWS_PLACEHOLDER_IMAGE_ASSET_URL,
                        fit: BoxFit.fill)
                    : Image.network(thumbnail, fit: BoxFit.fill),
              ),
            ),
          ],
        ),
        onTap: () {
          //final Blog blog = Blog(name: title,)
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => BlogScreen(blog: blog)));
        },
      ),
    );
  }
}
