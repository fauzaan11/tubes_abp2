import 'package:flutter/material.dart';
import '../dataType.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Wisata extends StatelessWidget {
  const Wisata({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const WisataPage();
  }
}

class WisataPage extends StatefulWidget {
  const WisataPage({Key? key}) : super(key: key);

  @override
  _WisataPage createState() => _WisataPage();
}

class _WisataPage extends State<WisataPage> {
  List<WisataType> daftarWisata = [];

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
    var url = "http://127.0.0.1:8000/api/daftar-wisata";
    var res = await apiCall(url);
    var body = json.decode(res.body);
    if (res.statusCode == 200) {
      List<WisataType> listTemp = [];
      for (var i = 0; i < body['data'].length; i++) {
        var temp = body['data'][i];
        WisataType wisata = WisataType(
            temp['id'] ?? 0,
            temp['nama_wisata'] ?? "",
            temp['alamat'] ?? "",
            "http://127.0.0.1:8000/storage/images/" + (temp['gambar'] ?? ""),
            1,
            temp['deskripsi'] ?? "");
        listTemp.add(wisata);
      }

      setState(() {
        daftarWisata = listTemp;
      });
    }
  }

  void detailWisataScreen(context, argument) {
    Navigator.pushNamed(context, '/detailWisata', arguments: argument);
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
                "Daftar Wisata",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: daftarWisata.length,
                itemBuilder: (BuildContext context, int index) {
                  return TextButton(
                      onPressed: () {
                        detailWisataScreen(context, daftarWisata[index]);
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
                            Text(daftarWisata[index].namaWisata,
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black)),
                            const Padding(
                                padding: EdgeInsets.symmetric(vertical: 5)),
                            Text(
                              daftarWisata[index].alamat,
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
