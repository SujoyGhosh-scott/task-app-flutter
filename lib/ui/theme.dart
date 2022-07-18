import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color bluishClr = Color(0xff4e5ae8);
const Color yellowClr = Color(0xffffb746);
const Color pinkClr = Color(0xffff4667);
const Color white = Colors.white;
const Color primaryClr = bluishClr;
const Color darkGrayClr = Color(0xff121212);
const Color darkHeaderClr = Color(0xff424242);

class Themes {
  static final light = ThemeData(
      backgroundColor: Colors.white,
      primaryColor: Colors.red,
      brightness: Brightness.light,
      fontFamily: GoogleFonts.quicksand().fontFamily);

  static final dark = ThemeData(
      backgroundColor: darkGrayClr,
      primaryColor: darkGrayClr,
      brightness: Brightness.dark,
      fontFamily: GoogleFonts.quicksand().fontFamily);
}
