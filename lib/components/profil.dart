import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/dataType.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Profil extends StatelessWidget {
  const Profil({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ProfilePage();
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilPage createState() => _ProfilPage();
}

class _ProfilPage extends State<ProfilePage> {
  String _name = '';
  String _email = '';
  String _token = "";
  int _id = 0;
  bool loading = false;
  List<FeedbackType> daftarFeedback = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void setLoading() {
    setState(() {
      loading = !loading;
    });
  }

  //fungsi untuk memanggil API
  Future<http.Response> apiCall(url) async {
    return await http.get(Uri.parse(url), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    });
  }

  void getFeedback(id) async {
    setLoading();
    var url = "http://127.0.0.1:8000/api/feedback-user?id=" + id.toString();
    var res = await apiCall(url);
    var body = json.decode(res.body);
    if (res.statusCode == 200) {
      setLoading();
      List<FeedbackType> listTemp = [];
      for (var i = 0; i < body['data'].length; i++) {
        var temp = body['data'][i];
        FeedbackType event = FeedbackType(temp['feedback'] ?? "",
            temp['bintang'] ?? "", temp['nama_wisata'] ?? "");
        listTemp.add(event);
      }
      setState(() {
        daftarFeedback = listTemp;
      });
    } else {
      setLoading();
      final snackbar = SnackBar(
        content: Text(body['meta']['message']),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }

  _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      var data = json.decode(prefs.getString('user') ?? "");
      _name = data['nama'] ?? "";
      _email = data['email'] ?? "";
      _token = json.decode(prefs.getString('token') ?? "");
      _id = data['id'] ?? "";
      getFeedback(_id);
    });
  }

  //fungsi untuk memanggil API
  Future<http.Response> logoutApiCall(token, url) async {
    return await http.post(Uri.parse(url), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': "Bearer " + token
    });
  }

  void logout(context) async {
    var url = 'http://127.0.0.1:8000/api/logout-user';
    await logoutApiCall(_token, url);
    Navigator.of(context).pushNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Nama",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            Text(_name),
            Container(
              margin: const EdgeInsets.only(bottom: 20),
            ),
            const Text(
              "Email",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            Text(_email),
            Container(
              margin: const EdgeInsets.only(bottom: 20),
            ),
            ElevatedButton(
                onPressed: () {
                  logout(super.context);
                },
                child: const Text("Logout")),
            Container(margin: const EdgeInsets.only(bottom: 10)),
            const Text("Riwayat Feedback"),
            Container(margin: const EdgeInsets.only(bottom: 5)),
            Expanded(
                child: ListView.builder(
              itemCount: daftarFeedback.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.circular(10)),
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(daftarFeedback[index].deskripsi,
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.black)),
                      const Padding(padding: EdgeInsets.symmetric(vertical: 2)),
                      const Text("Rating",
                          style: TextStyle(color: Colors.grey)),
                      Text(daftarFeedback[index].rating.toString() + " / 5"),
                      const Padding(padding: EdgeInsets.symmetric(vertical: 2)),
                      const Text(
                        "Nama wisata",
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(
                        daftarFeedback[index].dari,
                        style: const TextStyle(color: Colors.black),
                      )
                    ],
                  ),
                );
              },
            )),
          ],
        ),
      )),
    );
  }
}
