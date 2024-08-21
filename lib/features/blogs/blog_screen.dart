import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BlogScreen extends ConsumerStatefulWidget {
  const BlogScreen({super.key});

  @override
  ConsumerState createState() => _BlogScreenState();
}

class _BlogScreenState extends ConsumerState<BlogScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Card(
        elevation: 5,
        clipBehavior: Clip.hardEdge,
        margin: const EdgeInsets.only(bottom: 20),
        surfaceTintColor: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Hero(
              tag: "tag",
              child: Image.network(
                  "https://media.istockphoto.com/id/175403228/photo/suv-car-in-studio-isolated-on-white.jpg?s=2048x2048&w=is&k=20&c=geQF6kxoKMQxaaLKK6p_24CsZ6i7RlamfHKZQgHtplY=",
                  fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  Text("TITLE",
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Text("DESCRIPTION",
                      style:
                      const TextStyle(fontSize: 16, color: Colors.blueGrey)),
                  const SizedBox(height: 10),
                  ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                          radius: 20, backgroundImage: NetworkImage("https://media.istockphoto.com/id/175403228/photo/suv-car-in-studio-isolated-on-white.jpg?s=2048x2048&w=is&k=20&c=geQF6kxoKMQxaaLKK6p_24CsZ6i7RlamfHKZQgHtplY=")),
                      title: Text("AUTHOR",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ))),
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}
