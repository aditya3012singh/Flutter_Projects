// valueNotifier: Hold the data
// ValueListenerBuilder : listen to the data(in this case dont need the setstate)

import 'package:flutter/material.dart';

ValueNotifier<int> selectedPageNotifier = ValueNotifier(0);
ValueNotifier<bool> isDarkModeNotifier = ValueNotifier(true);