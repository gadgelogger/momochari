import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;
import 'package:momochari/model/info_model.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoView extends StatefulWidget {
  const InfoView({super.key});

  @override
  InfoViewState createState() => InfoViewState();
}

class InfoViewState extends State<InfoView> {
  List<InfoModel> _infoList = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    fetchInfoData();
  }

  Future<void> fetchInfoData() async {
    final response =
        await http.get(Uri.parse('https://www.momochari.jp/news/index.html'));

    if (response.statusCode == 200) {
      String responseBody = utf8.decode(response.bodyBytes);

      final document = parser.parse(responseBody);
      final infoList = <InfoModel>[];

      final newsBoxes = document.getElementsByClassName('news-box');
      for (final newsBox in newsBoxes) {
        final title = newsBox.querySelector('.txt')?.text.trim() ?? '';
        final date = newsBox.querySelector('.date')?.text.trim() ?? '';
        final imageUrl =
            newsBox.querySelector('.pic img')?.attributes['src'] ?? '';
        final articleUrl =
            'https://www.momochari.jp${newsBox.querySelector('.txt a')?.attributes['href']}';

        infoList.add(InfoModel(
          title: title,
          date: date,
          imageUrl: imageUrl,
          articleUrl: articleUrl,
        ));
      }

      setState(() {
        _infoList = infoList;
        _loading = false;
      });
    } else {
      setState(() {
        _loading = false;
      });
    }
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('お知らせ'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _infoList.length,
              itemBuilder: (context, index) {
                final info = _infoList[index];
                return ListTile(
                  leading: ClipOval(
                    child: Image.network(
                      info.imageUrl,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(info.title),
                  subtitle: Text(info.date),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  onTap: () => _launchURL(info.articleUrl),
                );
              },
            ),
    );
  }
}
