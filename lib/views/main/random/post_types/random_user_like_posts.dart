import 'package:flutter/material.dart';

class RandomUserLikePosts extends StatefulWidget {
  const RandomUserLikePosts({super.key});

  @override
  State<RandomUserLikePosts> createState() => _RandomUserLikePostsState();
}

class _RandomUserLikePostsState extends State<RandomUserLikePosts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Text("likes")),
    );
  }
}
