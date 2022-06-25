import 'package:flutter/material.dart';
import '../dataType.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Event extends StatelessWidget {
  const Event({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const EventPage();
  }
}

class EventPage extends StatefulWidget {
  const EventPage({Key? key}) : super(key: key);

  @override
  _EventPage createState() => _EventPage();
}

class _EventPage extends State<EventPage> {
  List<EventType> daftarEvent = [];

  //fungsi untuk memanggil API
  Future<http.Response> apiCall(url) async {
    return await http.get(Uri.parse(url), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    });
  }

  @override
  void initState() {
    super.initState();
    getWisata();
  }

  void getWisata() async {
    var url = "http://127.0.0.1:8000/api/daftar-event";
    var res = await apiCall(url);
    var body = json.decode(res.body);
    print(body);
    if (res.statusCode == 200) {
      List<EventType> listTemp = [];
      for (var i = 0; i < body['data'].length; i++) {
        var temp = body['data'][i];
        EventType event = EventType(
            temp['nama_event'] ?? "",
            temp['alamat'] ?? "",
            temp['tanggal'] ?? "",
            "http://127.0.0.1:8000/storage/images/" + (temp['gambar'] ?? ""),
            temp['id'] ?? 0);
        listTemp.add(event);
      }

      setState(() {
        daftarEvent = listTemp;
      });
    }
  }

  void detailEventScreen(context, argument) {
    Navigator.pushNamed(context, '/detailEvent', arguments: argument);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 20, top: 10),
              child: const Text(
                "Daftar Event",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: daftarEvent.length,
                itemBuilder: (BuildContext context, int index) {
                  return TextButton(
                      onPressed: () {
                        detailEventScreen(context, daftarEvent[index]);
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        decoration: BoxDecoration(
                            color: Colors.amber[100],
                            borderRadius: BorderRadius.circular(10)),
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(daftarEvent[index].namaEvent,
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black)),
                            const Padding(
                                padding: EdgeInsets.symmetric(vertical: 5)),
                            Text(
                              daftarEvent[index].tanggal,
                              style: const TextStyle(color: Colors.black),
                            ),
                            const Padding(
                                padding: EdgeInsets.symmetric(vertical: 5)),
                            Text(
                              daftarEvent[index].alamat,
                              style: const TextStyle(color: Colors.black),
                            )
                          ],
                        ),
                      ));
                },
              ),
            )
          ],
        ),
      ),
    ));
  }
}
