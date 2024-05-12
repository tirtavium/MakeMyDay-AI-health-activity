import 'package:MakeMyDay/screens/mealScreen/add_meal_screen.dart';
import 'package:flutter/material.dart';
import 'package:MakeMyDay/screens/actionScreen/screens/ActionRequiredScreen.dart';
import 'package:MakeMyDay/screens/add_post_screen.dart';
import 'package:MakeMyDay/screens/diaryScreen/my_diary/my_diary_screen.dart';
import 'package:MakeMyDay/screens/feed_screen.dart';
import 'package:MakeMyDay/screens/profile/profile_screen.dart';

const webScreenSize = 600;


List<Widget> homeScreenItems = [
  const MyDiaryScreen(),
  const FeedScreen(),
  const AddPostScreen(),
  const AddMealScreen(),
  const ProfileScreenMenu(),
];


