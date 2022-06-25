import 'package:flutter/material.dart';
import 'package:mobile/components/loading.dart';
import 'package:mobile/dataType.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Feedback extends StatelessWidget {
  const Feedback({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const FeedbackPage();
  }
}

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({Key? key}) : super(key: key);
  @override
  _FeedbackPage createState() => _FeedbackPage();
}

class _FeedbackPage extends State<FeedbackPage> {
  List<FeedbackType> daftarFeedback = [];

  bool loading = false;
  String namaWisata = "";

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

  void getWisata(id) async {
    setLoading();
    var url = "http://127.0.0.1:8000/api/feedback-wisata?id=" + id.toString();
    var res = await apiCall(url);
    var body = json.decode(res.body);
    if (res.statusCode == 200) {
      setLoading();
      List<FeedbackType> listTemp = [];
      for (var i = 0; i < body['data'].length; i++) {
        var temp = body['data'][i];
        FeedbackType event = FeedbackType(
            temp['feedback'] ?? "", temp['bintang'] ?? "", temp['nama'] ?? "");
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

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      final WisataType args =
          ModalRoute.of(context)!.settings.arguments as WisataType;
      getWisata(args.id);
      namaWisata = args.namaWisata;
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text(
                "Feedback wisata " + namaWisata,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            body: SafeArea(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: ListView.builder(
                  itemCount: daftarFeedback.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.amber, width: 2),
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
                          const Padding(
                              padding: EdgeInsets.symmetric(vertical: 5)),
                          const Text("Rating",
                              style: TextStyle(color: Colors.grey)),
                          Text(
                              daftarFeedback[index].rating.toString() + " / 5"),
                          const Padding(
                              padding: EdgeInsets.symmetric(vertical: 5)),
                          const Text(
                            "Dari",
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
                ),
              ),
            ));
  }
}
