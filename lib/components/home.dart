import 'package:flutter/material.dart';
import 'package:mobile/components/loading.dart';
import 'package:mobile/dataType.dart';
import 'package:mobile/screens/detail_wisata.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const HomePage();
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  String _name = "";
  bool loading = false;
  var upComingEvent = EventType(
      'Tari',
      "Jl. Pura Telaga Mas Lempuyang, Tri Buana, Kec. Abang, Kabupaten Karangasem, Bali 80852",
      "25 Juni 2020",
      "https://source.unsplash.com/SXM0NC45wU0",
      1);
  var wisataPopuler = WisataType(
      1,
      'Pura',
      "Jl. Pura Telaga Mas Lempuyang, Tri Buana, Kec. Abang, Kabupaten Karangasem, Bali 80852",
      "https://source.unsplash.com/SXM0NC45wU0",
      1,
      "");

  Future<http.Response> apiCall(url) async {
    return await http.get(Uri.parse(url), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    });
  }

  void setLoading() {
    setState(() {
      loading = !loading;
    });
  }

  void getDashboardData() async {
    setLoading();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = json.decode(prefs.getString('user') ?? "{}");
    _name = data!['nama'] ?? "";
    String url = "http://127.0.0.1:8000/api/dashboard";
    var res = await apiCall(url);
    var body = jsonDecode(res.body);
    if (res.statusCode == 200) {
      setLoading();
      setState(() {
        var wisata = body['data']['wisata_populer'];
        var event = body['data']['upcoming_event'];
        wisataPopuler = WisataType(
            wisata['id'],
            wisata['nama_wisata'],
            wisata['alamat'],
            "http://127.0.0.1:8000/storage/images/" + wisata['gambar'],
            wisata['rating'],
            wisata['deskripsi']);
        upComingEvent = EventType(
          event['nama_event'],
          event['alamat'],
          event['tanggal'],
          "http://127.0.0.1:8000/storage/images/" + event['gambar'],
          1,
        );
      });
    } else {
      setLoading();
    }
  }

  @override
  void initState() {
    super.initState();
    getDashboardData();
  }

  void detailEventScreen(context, argument) {
    Navigator.pushNamed(context, '/detailEvent', arguments: argument);
  }

  void detailWisataScreen(context, argument) {
    Navigator.pushNamed(context, '/detailWisata', arguments: argument);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: loading
            ? const Loading()
            : SingleChildScrollView(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hai " + _name,
                      style: const TextStyle(
                          fontSize: 32, fontWeight: FontWeight.w700),
                    ),
                    const Text("selamat datang di balikuyy"),
                    const SizedBox(height: 20),
                    const Text("Event yang akan datang",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w500)),
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                    ),
                    TextButton(
                      onPressed: () {
                        detailEventScreen(context, upComingEvent);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.amber[100]),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 200,
                              width: double.infinity,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: FadeInImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(upComingEvent.foto),
                                  placeholder: const AssetImage(
                                      'images/placeholder.png'),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                upComingEvent.namaEvent,
                                style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Text(upComingEvent.tanggal,
                                  style: const TextStyle(color: Colors.black)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 10, top: 40),
                    ),
                    const Text("Wisata populer",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w500)),
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                    ),
                    TextButton(
                      onPressed: () {
                        detailWisataScreen(context, wisataPopuler);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.only(bottom: 20),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.amber[100]),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 200,
                              width: double.infinity,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: FadeInImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(wisataPopuler.foto),
                                  placeholder: const AssetImage(
                                      'images/placeholder.png'),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                wisataPopuler.namaWisata,
                                style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Text(wisataPopuler.alamat,
                                  style: const TextStyle(color: Colors.black)),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
