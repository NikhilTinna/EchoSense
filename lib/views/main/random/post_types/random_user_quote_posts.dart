import 'package:flutter/material.dart';

class RandomUserQuotePosts extends StatefulWidget {
  const RandomUserQuotePosts({super.key});

  @override
  State<RandomUserQuotePosts> createState() => _RandomUserQuotePostsState();
}

class _RandomUserQuotePostsState extends State<RandomUserQuotePosts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Text("quotes")),
    );
  }
}
