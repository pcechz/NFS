import 'package:flutter/material.dart';
import 'package:app/components/drag_and_drop/widget/drag_and_drop.dart';
// import 'package:app/components/expandable/widget/bible_verse.dart';
import 'package:app/components/expandable/widget/expandable.dart';
import 'package:app/components/follow/widget/follow.dart';
import 'package:app/components/parallax/widget/parallax.dart';
import 'package:app/components/parallax_content/widget/parallax_content.dart';
import 'package:app/components/profile/widget/profile.dart';
import 'package:app/components/rates/widget/rates.dart';
import 'package:app/components/swipe_to_dismiss/widget/swipe_to_dismiss.dart';
import 'package:app/components/image_gallery/widget/gallery.dart';
import 'package:app/core/fade_page_route.dart';
import 'package:app/pages/bible/bible_page.dart';

import 'package:app/pages/cards/cards_list.dart';
import 'package:app/pages/details/bulletin_page.dart';
import 'package:app/pages/details/detail_page.dart';
import 'package:app/pages/dialogs/dialogs_list.dart';
import 'package:app/pages/forgot_password/forgot_password_page.dart';
import 'package:app/pages/home/home_page.dart';
import 'package:app/pages/lists/lists.dart';
import 'package:app/pages/login/login_page.dart';
import 'package:app/pages/parallax/parallax_list.dart';
import 'package:app/pages/register/register_page.dart';
import 'package:app/pages/small_components/checkbox_sliders.dart';
import 'package:app/pages/tabs/tabs_page.dart';
import 'package:app/pages/wizards/walkthrough_page.dart';
import 'package:app/settings/Settings.dart';
import 'package:app/ui/screens/home/home.dart';
import 'package:app/ui/screens/pokedex/pokedex.dart';
import 'package:app/ui/screens/pokemon_info/pokemon_info.dart';
import 'package:app/ui/screens/splash/splash.dart';
import 'package:app/ui/screens/types/type_screen.dart';
import '../pages/splash/splash_screen_page.dart';
import 'package:app/pages/lists/lists.dart';

enum Routes { expandable, bulletin, home, pokedex, pokemonInfo, typeEffects }

class Rout {
  static final homePage = HomePage();
  static final splashScreenPage = SplashScreenPage();

  //LISTS
  static final components = ListPage();
  static final expandable = ListPage();
  static final bulletin = BulletinPage();
  static final swipeToDismiss = SwipeToDismiss();

  //CARDS
  static final cardList = CardsList();
  static final rates = Rates();
  static final follow = Follow();
  static final profile = Profile();

  //DIALOGS
  static final dialogList = DialogList();

  //Login - Register
  static final register = RegisterPage();
  static final login = LoginPage();
  static final forgotPassword = ForgotPasswordPage();

  //parallax
  static final parallaxList = ParallaxList();
  static final parallax = Parallax();
  static final parallaxContent = ParallaxContent();

  static final checkboxSliders = CheckboxSliders();

  static final tabs = TabsPage();

  static final gallery = Gallery();
  static final walkthrough = WalkthroughPage();
  static final splash = SplashScreen();
  static final home = HomeScreen();
  static final pokedex = BiblePage();
  static final pokemonInfo = PokedexScreen(); //PokemonInfo(Settings:);
  static final typeEffectsScreen = TypeEffectScreen();
}

class _Paths {
  static const String daily = '/home/pokedex';
  static const String home = '/home';
  static const String pokedex = '/home/pokedex';
  static const String pokemonInfo = '/home/pokemon';
  static const String typeEffectsScreen = '/home/type';
  static const Map<Routes, String> _pathMap = {
    Routes.expandable: _Paths.daily,
    // Routes.home: _Paths.home,
    // Routes.pokedex: _Paths.pokedex,
    // Routes.pokemonInfo: _Paths.pokemonInfo,
    // Routes.typeEffects: _Paths.typeEffectsScreen,
  };

  static String of(Routes route) => _pathMap[route];
}

class AppNavigator {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case _Paths.daily:
        return FadeRoute(page: Expandable());

      case _Paths.pokedex:
        return FadeRoute(page: PokedexScreen());

      case _Paths.pokemonInfo:
        return FadeRoute(page: PokemonInfo(settings.arguments));

      case _Paths.typeEffectsScreen:
        return FadeRoute(page: TypeEffectScreen());

      case _Paths.home:
      default:
        return FadeRoute(page: HomeScreen());
    }
  }

  static Future push<T>(Routes route, [T arguments]) =>
      state.pushNamed(_Paths.of(route), arguments: arguments);

  static Future replaceWith<T>(Routes route, [T arguments]) =>
      state.pushReplacementNamed(_Paths.of(route), arguments: arguments);

  static void pop() => state.pop();

  static NavigatorState get state => navigatorKey.currentState;
}
