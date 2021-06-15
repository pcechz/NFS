import 'package:app/Feature/InheritedBlocs.dart';
import 'package:app/Foundation/foundation.dart';
import 'package:flutter/material.dart';

import 'VerseText.dart';

class DismissableChapterViewer extends StatelessWidget {
  final Chapter chapter;
  final Chapter previousChapter;
  final Chapter nextChapter;
  final Book book;
  final int verseNumber;
  final bool shouldHaveBackgrounds;
  final bool showVerseNumbers;
  final Function scrollToVerseMethod;
  final bool showReferences;
  final double fontSize;

  DismissableChapterViewer(
      {this.chapter,
      this.book,
      this.shouldHaveBackgrounds,
      this.showVerseNumbers,
      this.verseNumber,
      this.scrollToVerseMethod,
      this.previousChapter,
      this.nextChapter,
      this.showReferences,
      this.fontSize});

  Widget build(BuildContext context) {
    return Dismissible(
      secondaryBackground: this.shouldHaveBackgrounds
          ? VerseText(
              book: book,
              chapter: nextChapter,
              verseNumber: 1,
              scrollToVerseMethod: scrollToVerseMethod,
              showReferences: this.showReferences,
              fontSize: this.fontSize,
            )
          : LoadingColumn(),
      background: this.shouldHaveBackgrounds
          ? VerseText(
              book: book,
              chapter: previousChapter,
              verseNumber: 1,
              scrollToVerseMethod: scrollToVerseMethod,
              showReferences: this.showReferences,
              fontSize: this.fontSize,
            )
          : LoadingColumn(),
      resizeDuration: null,
      onDismissed: (DismissDirection swipeDetails) async {
        if (swipeDetails == DismissDirection.endToStart) {
          InheritedBlocs.of(context).bibleBloc.goToNextChapter(this.chapter);
        } else {
          InheritedBlocs.of(context)
              .bibleBloc
              .goToPreviousChapter(this.chapter);
        }
      },
      child: VerseText(
        book: book,
        chapter: chapter,
        verseNumber: verseNumber,
        scrollToVerseMethod: scrollToVerseMethod,
        showReferences: this.showReferences,
        fontSize: this.fontSize,
      ),
      key: ValueKey(chapter.number),
    );
  }
}
