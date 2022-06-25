import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mobile/components/loading.dart';
import 'package:mobile/dataType.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class DetailWisata extends StatelessWidget {
  const DetailWisata({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: DetailWisataPage(),
    );
  }
}

class DetailWisataPage extends StatefulWidget {
  const DetailWisataPage({Key? key}) : super(key: key);

  @override
  _DetailWisata createState() => _DetailWisata();
}

// ignore: must_be_immutable
class _DetailWisata extends State<DetailWisataPage> {
  String desFeedback = "Bagus";
  double ratingVal = 3;
  bool loading = false;

  //fungsi untuk memanggil API
  Future<http.Response> apiCall(data, url) async {
    return await http.post(Uri.parse(url), body: jsonEncode(data), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    });
  }

  void setLoading() {
    setState(() {
      loading = !loading;
    });
  }

  //fungsi untuk addFeedback
  void addFeedback(context, wisataId) async {
    // data untuk menambah feedback
    Navigator.pop(context, 'OK');
    setLoading();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var user = json.decode(prefs.getString('user') ?? "");
    var userId = user['id'] ?? "";
    var data = {
      'user_id': userId,
      'wisata_id': wisataId,
      'feedback': desFeedback,
      'bintang': ratingVal
    };

    //panggil dan tunggu fungsi untuk memanggil API
    var res = await apiCall(data, 'http://127.0.0.1:8000/api/add-feedback');

    //ubah data dari API ke bentuk json
    var body = json.decode(res.body);

    //cek apakah addFeedback berhasil, code 200 berarti berhasil
    if (res.statusCode == 200) {
      setLoading();

      //jika gagal addFeedback
    } else {
      setLoading();
      // buka snackbar dengan pesan dari server
      final snackbar = SnackBar(
        content: Text(body['meta']['message']),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }

  @override
  Widget build(BuildContext context) {
    final WisataType args =
        ModalRoute.of(context)!.settings.arguments as WisataType;
    return loading
        ? const Loading()
        : SafeArea(
            child: Scaffold(
                appBar: AppBar(
                  title: const Text(
                    "Detail wisata",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                body: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          margin: const EdgeInsets.only(top: 20, bottom: 10),
                          width: double.infinity,
                          child: FadeInImage(
                            fit: BoxFit.cover,
                            height: 300,
                            image: NetworkImage(args.foto),
                            placeholder:
                                const AssetImage('images/placeholder.png'),
                          ),
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(10))),
                      const Text("Nama"),
                      Text(
                        args.namaWisata,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 20),
                      ),
                      const Text("Alamat"),
                      Text(args.alamat,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500)),
                      Container(
                        margin: const EdgeInsets.only(bottom: 20),
                      ),
                      const Text("Deskripsi"),
                      Text(args.deskripsi,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500)),
                      Container(
                        margin: const EdgeInsets.only(bottom: 20),
                      ),
                      const Text("Rating"),
                      Text(
                        args.totalRating.toString() + " / 5",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 20),
                      ),
                      Row(
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                Alert(context, args.id);
                              },
                              child: const Text("Beri Feedback")),
                          Container(
                            margin: const EdgeInsets.only(right: 10),
                          ),
                          ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/feedback',
                                    arguments: args);
                              },
                              child: const Text("Lihat feedback")),
                        ],
                      )
                    ],
                  ),
                )),
          );
  }

  // ignore: non_constant_identifier_names
  Future<void> Alert(BuildContext context, wisataId) async {
    var alert = AlertDialog(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Deskripsi feedback"),
          TextField(
            onChanged: (value) {
              desFeedback = value;
            },
          ),
          Container(margin: const EdgeInsets.only(bottom: 20)),
          const Text("Rating"),
          RatingBar.builder(
            initialRating: 3,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: false,
            itemCount: 5,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              ratingVal = rating;
            },
          ),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context, 'Tutup');
            },
            child: const Text('Tutup')),
        TextButton(
            onPressed: () {
              // Navigator.pop(context, 'OK');
              addFeedback(context, wisataId);
            },
            child: const Text('OK')),
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
