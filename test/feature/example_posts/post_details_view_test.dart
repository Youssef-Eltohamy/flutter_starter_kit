import 'package:flutter/material.dart';
import 'package:flutter_starter_kit/feature/example_posts/data/models/post.dart';
import 'package:flutter_starter_kit/feature/example_posts/presentation/screen/post_details_view.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows the post title and body', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: PostDetailsView(
            post: Post(id: 1, title: 'My title', body: 'My body'),
          ),
        ),
      ),
    );

    expect(find.text('My title'), findsOneWidget);
    expect(find.text('My body'), findsOneWidget);
  });

  testWidgets('shows a fallback when the post is null', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: PostDetailsView(post: null)),
      ),
    );

    expect(find.text('Post not found'), findsOneWidget);
  });
}
