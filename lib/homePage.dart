//@dart=2.9
import 'package:fiberly/loginPage.dart';
import 'package:fiberly/userDetails.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  final UserDetails userDetails;
  HomePage({Key key, this.userDetails}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController _controller;
  int _page = 1;
  final int _limit = 10;
  final _baseUrl = 'https://picsum.photos/v2/list';
  bool _isFirstLoadRunning = false;
  bool _isLoadMoreRunning = false;
  List _posts = [];

  void _firstLoad() async {
    setState(() {
      _isFirstLoadRunning = true;
    });
    try {
      final res =
          await http.get(Uri.parse("$_baseUrl?page=$_page&limit=$_limit"));
      setState(() {
        _posts = jsonDecode(res.body);
      });
      // ignore: empty_catches
    } catch (err) {}
    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  void _loadMore() async {
    if (_isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _controller.position.extentAfter < 100) {
      setState(() {
        _isLoadMoreRunning = true;
      });
      _page++;
      try {
        final res =
            await http.get(Uri.parse("$_baseUrl?page=$_page&limit=$_limit"));
        final List fetchedPosts = json.decode(res.body);
        if (fetchedPosts.isNotEmpty) {
          setState(() {
            _posts.addAll(fetchedPosts);
          });
        }
        // ignore: empty_catches
      } catch (err) {}
      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _firstLoad();
    _controller = ScrollController()..addListener(_loadMore);
  }

  @override
  void dispose() {
    _controller.removeListener(_loadMore);
    super.dispose();
  }

  void removePrefs() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("username");
    prefs.remove("password");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.95),
      appBar: AppBar(
        title: const Text(
          "FiberLy",
        ),
        actions: [
          MaterialButton(
              onPressed: () {
                removePrefs();
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ));
              },
              child: const Icon(
                Icons.logout_outlined,
                color: Colors.white,
              ))
        ],
      ),
      body: ListView(
        controller: _controller,
        children: [
          const SizedBox(height: 20),
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Username: ${widget.userDetails.username}"),
                  const SizedBox(height: 20),
                  Text("Password: ${widget.userDetails.password}"),
                ],
              ),
            ),
          ),
          _isFirstLoadRunning
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 100.0),
                    child: CircularProgressIndicator(),
                  ),
                )
              : ListView.builder(
                  // controller: _controller,
                  itemCount: _posts.length,
                  shrinkWrap: true,
                  primary: false,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (_, index) {
                    return Container(
                      height: 200,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 10),
                      child: Image.network(_posts[index]['download_url']),
                    );
                  }),
          if (_isLoadMoreRunning == true)
            const Padding(
              padding: EdgeInsets.only(top: 10, bottom: 40),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
