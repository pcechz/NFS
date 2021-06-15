// import 'package:flutter/material.dart';
// import 'package:intl/date_symbol_data_local.dart';
// import 'package:table_calendar/table_calendar.dart';

// // Example holidays
// final Map<DateTime, List> _holidays = {
//   DateTime(2020, 1, 1): ['New Year\'s Day'],
//   DateTime(2020, 1, 6): ['Epiphany'],
//   DateTime(2020, 2, 14): ['Valentine\'s Day'],
//   DateTime(2020, 4, 21): ['Easter Sunday'],
//   DateTime(2020, 4, 22): ['Easter Monday'],
// };

// void main() {
//   initializeDateFormatting().then((_) => runApp(BibleVerse()));
// }

// // class BibleVerse extends StatelessWidget {

// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       home: Scaffold(
// //         appBar: AppBar(
// //           title: const Text('Bible Verses'),
// //         ),
// //         body: ListView.builder(
// //           itemCount: data.length,
// //           itemBuilder: (BuildContext context, int index) => EntryItem(
// //             data[index],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// class BibleVerse extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Daily Bible Verse',
//       theme: ThemeData(
//         primarySwatch: Colors.purple,
//       ),
//       home: MyHomePage(title: 'Daily Bible Verse'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key key, this.title}) : super(key: key);

//   final String title;

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
//   Map<DateTime, List> _events;
//   List _selectedEvents;
//   AnimationController _animationController;
//   CalendarController _calendarController;

//   @override
//   void initState() {
//     super.initState();
//     final _selectedDay = DateTime.now();

//     _events = {
//       _selectedDay.subtract(Duration(days: 30)): ['Verse A0'],
//       _selectedDay.subtract(Duration(days: 27)): ['Verse A1'],
//       _selectedDay.subtract(Duration(days: 20)): ['Verse A2'],
//       _selectedDay.subtract(Duration(days: 16)): ['Verse A3'],
//       _selectedDay.subtract(Duration(days: 10)): ['Verse A4'],
//       _selectedDay.subtract(Duration(days: 4)): ['Verse A5'],
//       _selectedDay.subtract(Duration(days: 2)): ['Verse A6'],
//       _selectedDay: [
//         '''Pray for the success of all Cardinal programs in Lokoja Zone. Ask for divine direction, financial provisions, and Students understanding of the Vision and Mission of NIFES. Pray that all NIFES Student Leaders will encounter Jesus afresh
// Pray for the Leadership of the Churches in Kogi State Particularly Anglican Communion, ECWA, UEC, CEFN, and all other denominations. That God will keep them focused on Him to whom all flesh must bow. Ask that God will help them to lead in righteousness with Jesus being the centre of attraction.
// Offer sacrifices of Praise to God for answering our Prayers in the first half of NIFES 2020/2021Ministry year.

// NOTE:

// Thank you for praying with us this first half of the NIFES 2020 / 2021 Ministry year, may the Lord reward you abundantly and grant you His unique presence.

// For Partnership and Support, Please contact:

// Julius Ayodele Ogunlade

// Director of Missions and Evangelism

// NIFES Headquarters, Jos, Plateau State

// October 2020

// Ja_ogunlade@yahoo.com, Julius.ogunlade@78.141.207.206

// 07036698789'''
//       ],
//       _selectedDay.add(Duration(days: 1)): ['Verse A8'],
//       _selectedDay.add(Duration(days: 3)): Set.from(['Verse A9']).toList(),
//       _selectedDay.add(Duration(days: 7)): ['Verse A10'],
//       _selectedDay.add(Duration(days: 11)): ['Verse A11'],
//       _selectedDay.add(Duration(days: 17)): ['Verse A12'],
//       _selectedDay.add(Duration(days: 22)): ['Verse A13'],
//       _selectedDay.add(Duration(days: 26)): ['Verse A14'],
//     };

//     _selectedEvents = _events[_selectedDay] ?? [];
//     _calendarController = CalendarController();

//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 400),
//     );

//     _animationController.forward();
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     _calendarController.dispose();
//     super.dispose();
//   }

//   void _onDaySelected(DateTime day, List events, List holidays) {
//     print('CALLBACK: _onDaySelected');
//     setState(() {
//       _selectedEvents = events;
//     });
//   }

//   void _onVisibleDaysChanged(
//       DateTime first, DateTime last, CalendarFormat format) {
//     print('CALLBACK: _onVisibleDaysChanged');
//   }

//   void _onCalendarCreated(
//       DateTime first, DateTime last, CalendarFormat format) {
//     print('CALLBACK: _onCalendarCreated');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//         automaticallyImplyLeading: true,
//       ),
//       body: Column(
//         mainAxisSize: MainAxisSize.max,
//         children: <Widget>[
//           // Switch out 2 lines below to play with TableCalendar's settings
//           //-----------------------
//           _buildTableCalendar(),
//           // _buildTableCalendarWithBuilders(),
//           const SizedBox(height: 8.0),
//           // _buildButtons(),
//           const SizedBox(height: 8.0),
//           Expanded(child: _buildEventList()),
//         ],
//       ),
//     );
//   }

//   // Simple TableCalendar configuration (using Styles)
//   Widget _buildTableCalendar() {
//     return TableCalendar(
//       calendarController: _calendarController,
//       events: _events,
//       holidays: null,
//       startingDayOfWeek: StartingDayOfWeek.sunday,
//       calendarStyle: CalendarStyle(
//         selectedColor: Colors.deepOrange[400],
//         todayColor: Colors.deepOrange[200],
//         markersColor: Colors.brown[700],
//         outsideDaysVisible: false,
//       ),
//       headerStyle: HeaderStyle(
//         formatButtonTextStyle:
//             TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
//         formatButtonDecoration: BoxDecoration(
//           color: Colors.deepOrange[400],
//           borderRadius: BorderRadius.circular(16.0),
//         ),
//       ),
//       onDaySelected: _onDaySelected,
//       onVisibleDaysChanged: _onVisibleDaysChanged,
//       onCalendarCreated: _onCalendarCreated,
//     );
//   }

//   // More advanced TableCalendar configuration (using Builders & Styles)
//   Widget _buildTableCalendarWithBuilders() {
//     return TableCalendar(
//       locale: 'pl_PL',
//       calendarController: _calendarController,
//       events: _events,
//       holidays: _holidays,
//       initialCalendarFormat: CalendarFormat.month,
//       formatAnimation: FormatAnimation.slide,
//       startingDayOfWeek: StartingDayOfWeek.sunday,
//       availableGestures: AvailableGestures.all,
//       availableCalendarFormats: const {
//         CalendarFormat.month: '',
//         CalendarFormat.week: '',
//       },
//       calendarStyle: CalendarStyle(
//         outsideDaysVisible: false,
//         weekendStyle: TextStyle().copyWith(color: Colors.blue[800]),
//         holidayStyle: TextStyle().copyWith(color: Colors.blue[800]),
//       ),
//       daysOfWeekStyle: DaysOfWeekStyle(
//         weekendStyle: TextStyle().copyWith(color: Colors.blue[600]),
//       ),
//       headerStyle: HeaderStyle(
//         centerHeaderTitle: true,
//         formatButtonVisible: false,
//       ),
//       builders: CalendarBuilders(
//         selectedDayBuilder: (context, date, _) {
//           return FadeTransition(
//             opacity: Tween(begin: 0.0, end: 1.0).animate(_animationController),
//             child: Container(
//               margin: const EdgeInsets.all(4.0),
//               padding: const EdgeInsets.only(top: 5.0, left: 6.0),
//               color: Colors.deepOrange[300],
//               width: 100,
//               height: 100,
//               child: Text(
//                 '${date.day}',
//                 style: TextStyle().copyWith(fontSize: 16.0),
//               ),
//             ),
//           );
//         },
//         todayDayBuilder: (context, date, _) {
//           return Container(
//             margin: const EdgeInsets.all(4.0),
//             padding: const EdgeInsets.only(top: 5.0, left: 6.0),
//             color: Colors.amber[400],
//             width: 100,
//             height: 100,
//             child: Text(
//               '${date.day}',
//               style: TextStyle().copyWith(fontSize: 16.0),
//             ),
//           );
//         },
//         // markersBuilder: (context, date, events, holidays) {
//         //   final children = <Widget>[];

//         //   // if (events.isNotEmpty) {
//         //   //   children.add(
//         //   //     Positioned(
//         //   //       right: 1,
//         //   //       bottom: 1,
//         //   //       child: _buildEventsMarker(date, events),
//         //   //     ),
//         //   //   );
//         //   // }

//         //   // if (holidays.isNotEmpty) {
//         //   //   children.add(
//         //   //     Positioned(
//         //   //       right: -2,
//         //   //       top: -2,
//         //   //       child: _buildHolidaysMarker(),
//         //   //     ),
//         //   //   );
//         //   // }

//         //   return children;
//         // },
//       ),
//       onDaySelected: (date, events, holidays) {
//         _onDaySelected(date, events, holidays);
//         _animationController.forward(from: 0.0);
//       },
//       onVisibleDaysChanged: _onVisibleDaysChanged,
//       onCalendarCreated: _onCalendarCreated,
//     );
//   }

//   Widget _buildEventsMarker(DateTime date, List events) {
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 300),
//       decoration: BoxDecoration(
//         shape: BoxShape.rectangle,
//         color: _calendarController.isSelected(date)
//             ? Colors.brown[500]
//             : _calendarController.isToday(date)
//                 ? Colors.brown[300]
//                 : Colors.blue[400],
//       ),
//       width: 16.0,
//       height: 16.0,
//       child: Center(
//         child: Text(
//           '${events.length}',
//           style: TextStyle().copyWith(
//             color: Colors.white,
//             fontSize: 12.0,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildHolidaysMarker() {
//     return Icon(
//       Icons.add_box,
//       size: 20.0,
//       color: Colors.blueGrey[800],
//     );
//   }

//   Widget _buildButtons() {
//     final dateTime = _events.keys.elementAt(_events.length - 2);

//     return Column(
//       children: <Widget>[
//         Row(
//           mainAxisSize: MainAxisSize.max,
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: <Widget>[
//             RaisedButton(
//               child: Text('Month'),
//               onPressed: () {
//                 setState(() {
//                   _calendarController.setCalendarFormat(CalendarFormat.month);
//                 });
//               },
//             ),
//             RaisedButton(
//               child: Text('2 weeks'),
//               onPressed: () {
//                 setState(() {
//                   _calendarController
//                       .setCalendarFormat(CalendarFormat.twoWeeks);
//                 });
//               },
//             ),
//             RaisedButton(
//               child: Text('Week'),
//               onPressed: () {
//                 setState(() {
//                   _calendarController.setCalendarFormat(CalendarFormat.week);
//                 });
//               },
//             ),
//           ],
//         ),
//         const SizedBox(height: 8.0),
//         RaisedButton(
//           child: Text(
//               'Set day ${dateTime.day}-${dateTime.month}-${dateTime.year}'),
//           onPressed: () {
//             _calendarController.setSelectedDay(
//               DateTime(dateTime.year, dateTime.month, dateTime.day),
//               runCallback: true,
//             );
//           },
//         ),
//       ],
//     );
//   }

//   Widget _buildEventList() {
//     return ListView(
//       children: _selectedEvents
//           .map((event) => Container(
//                 alignment: Alignment.center,
//                 margin: EdgeInsets.all(20),
//                 height: 500,
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius:
//                       BorderRadius.circular(30), //border corner radius
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.withOpacity(0.5), //color of shadow
//                       spreadRadius: 5, //spread radius
//                       blurRadius: 7, // blur radius
//                       offset: Offset(0, 2), // changes position of shadow
//                       //first paramerter of offset is left-right
//                       //second parameter is top to down
//                     ),
//                     //you can set more BoxShadow() here
//                   ],
//                 ),

//                 // decoration: BoxDecoration(
//                 //   border: Border.all(width: 0.8),
//                 //   borderRadius: BorderRadius.circular(12.0),
//                 // ),
//                 // margin:
//                 //     const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
//                 child: SingleChildScrollView(
//                   child: ListTile(
//                     title: Text(event.toString()),
//                     onTap: () => print('$event tapped!'),
//                   ),
//                 ),
//               ))
//           .toList(),
//     );
//   }
// }

import 'package:app/model/lesson.dart';
import 'package:flutter/material.dart';
import 'package:app/model/planets.dart';
import 'package:app/pages/details/detail_page.dart';

void main() {
  runApp(BibleVerse());
}

class BibleVerse extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Bulletins',
      theme: new ThemeData(
          primaryColor: Color.fromRGBO(58, 66, 86, 1.0), fontFamily: 'Raleway'),
      home: new ListPage(title: 'Bulletins'),
      // home: DetailPage(),
    );
  }
}

class ListPage extends StatefulWidget {
  ListPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  List lessons;

  Planet det = Planet(
      id: "1",
      name: "Mars",
      location: "Milkyway Galaxy",
      distance: "54.6m Km",
      gravity: "3.711 m/s ",
      description:
          "Mars is the fourth planet from the Sun and the second-smallest planet in the Solar System after Mercury. In English, Mars carries a name of the Roman god of war, and is often referred to as the 'Red Planet' because the reddish iron oxide prevalent on its surface gives it a reddish appearance that is distinctive among the astronomical bodies visible to the naked eye. Mars is a terrestrial planet with a thin atmosphere, having surface features reminiscent both of the impact craters of the Moon and the valleys, deserts, and polar ice caps of Earth.",
      image: "assets/img/mars.png",
      picture:
          "https://www.nasa.gov/sites/default/files/thumbnails/image/pia21723-16.jpg");

  @override
  void initState() {
    lessons = getLessons();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ListTile makeListTile(Lesson lesson) => ListTile(
          contentPadding:
              EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          leading: Container(
            padding: EdgeInsets.only(right: 12.0),
            decoration: new BoxDecoration(
                border: new Border(
                    right: new BorderSide(width: 1.0, color: Colors.white24))),
            child: Icon(Icons.book_outlined, color: Colors.white),
          ),
          title: Text(
            lesson.title,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

          subtitle: Row(
            children: <Widget>[
              Expanded(
                  flex: 1,
                  child: Container(
                    // tag: 'hero',
                    child: LinearProgressIndicator(
                        backgroundColor: Color.fromRGBO(209, 224, 224, 0.2),
                        value: lesson.indicatorValue,
                        valueColor: AlwaysStoppedAnimation(Colors.green)),
                  )),
              Expanded(
                flex: 4,
                child: Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(lesson.level,
                        style: TextStyle(color: Colors.white))),
              )
            ],
          ),
          trailing:
              Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => DetailPage()));
          },
        );

    Card makeCard(Lesson lesson) => Card(
          elevation: 8.0,
          margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          child: Container(
            decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
            child: makeListTile(lesson),
          ),
        );

    final makeBody = Container(
      // decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, 1.0)),
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: lessons.length,
        itemBuilder: (BuildContext context, int index) {
          return makeCard(lessons[index]);
        },
      ),
    );

    // final makeBottom = Container(
    //   height: 55.0,
    //   child: BottomAppBar(
    //     color: Color.fromRGBO(58, 66, 86, 1.0),
    //     child: Row(
    //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //       children: <Widget>[
    //         IconButton(
    //           icon: Icon(Icons.home, color: Colors.white),
    //           onPressed: () {},
    //         ),
    //         IconButton(
    //           icon: Icon(Icons.blur_on, color: Colors.white),
    //           onPressed: () {},
    //         ),
    //         IconButton(
    //           icon: Icon(Icons.hotel, color: Colors.white),
    //           onPressed: () {},
    //         ),
    //         IconButton(
    //           icon: Icon(Icons.account_box, color: Colors.white),
    //           onPressed: () {},
    //         )
    //       ],
    //     ),
    //   ),
    // );

    final topAppBar = AppBar(
      elevation: 0.1,
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      title: Text(widget.title),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.calendar_today),
          onPressed: () {},
        )
      ],
    );

    return Scaffold(
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        appBar: topAppBar,
        body: makeBody);
  }
}

List getLessons() {
  return [
    Lesson(
        title: "Introduction to Driving",
        level: "Beginner",
        indicatorValue: 0.33,
        price: 20,
        content:
            "Start by taking a couple of minutes to read the info in this section. Launch your app and click on the Settings menu.  While on the settings page, click the Save button.  You should see a circular progress indicator display in the middle of the page and the user interface elements cannot be clicked due to the modal barrier that is constructed."),
    Lesson(
        title: "Observation at Junctions",
        level: "Beginner",
        indicatorValue: 0.33,
        price: 50,
        content:
            "Start by taking a couple of minutes to read the info in this section. Launch your app and click on the Settings menu.  While on the settings page, click the Save button.  You should see a circular progress indicator display in the middle of the page and the user interface elements cannot be clicked due to the modal barrier that is constructed."),
    Lesson(
        title: "Reverse parallel Parking",
        level: "Intermidiate",
        indicatorValue: 0.66,
        price: 30,
        content:
            "Start by taking a couple of minutes to read the info in this section. Launch your app and click on the Settings menu.  While on the settings page, click the Save button.  You should see a circular progress indicator display in the middle of the page and the user interface elements cannot be clicked due to the modal barrier that is constructed."),
    Lesson(
        title: "Reversing around the corner",
        level: "Intermidiate",
        indicatorValue: 0.66,
        price: 30,
        content:
            "Start by taking a couple of minutes to read the info in this section. Launch your app and click on the Settings menu.  While on the settings page, click the Save button.  You should see a circular progress indicator display in the middle of the page and the user interface elements cannot be clicked due to the modal barrier that is constructed."),
    Lesson(
        title: "Incorrect Use of Signal",
        level: "Advanced",
        indicatorValue: 1.0,
        price: 50,
        content:
            "Start by taking a couple of minutes to read the info in this section. Launch your app and click on the Settings menu.  While on the settings page, click the Save button.  You should see a circular progress indicator display in the middle of the page and the user interface elements cannot be clicked due to the modal barrier that is constructed."),
    Lesson(
        title: "Engine Challenges",
        level: "Advanced",
        indicatorValue: 1.0,
        price: 50,
        content:
            "Start by taking a couple of minutes to read the info in this section. Launch your app and click on the Settings menu.  While on the settings page, click the Save button.  You should see a circular progress indicator display in the middle of the page and the user interface elements cannot be clicked due to the modal barrier that is constructed."),
    Lesson(
        title: "Self Driving Car",
        level: "Advanced",
        indicatorValue: 1.0,
        price: 50,
        content:
            "Start by taking a couple of minutes to read the info in this section. Launch your app and click on the Settings menu.  While on the settings page, click the Save button.  You should see a circular progress indicator display in the middle of the page and the user interface elements cannot be clicked due to the modal barrier that is constructed.  ")
  ];
}
