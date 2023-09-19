import 'package:responsive_framework/responsive_framework.dart';

 class Constants{

  static List<Breakpoint> breakpoints = [

    const Breakpoint(start: 0, end: 250, name: MOBILE),
    const Breakpoint(start: 251, end: 500, name: TABLET),
    const Breakpoint(start: 501, end: 1920, name: DESKTOP),
    const Breakpoint(start: 1921, end: double.infinity, name: '4K')

    // const Breakpoint(start: 0, end: 450, name: MOBILE),
    // const Breakpoint(start: 451, end: 800, name: TABLET),
    // const Breakpoint(start: 801, end: 1920, name: DESKTOP),
    // const Breakpoint(start: 1921, end: double.infinity, name: '4K')
  ];


}