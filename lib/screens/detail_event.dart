import 'package:flutter/material.dart';
import 'package:mobile/dataType.dart';

class DetailEvent extends StatelessWidget {
  const DetailEvent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final EventType args =
        ModalRoute.of(context)!.settings.arguments as EventType;
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: const Text(
              "Detail event",
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: Padding(
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
                      placeholder: const AssetImage('images/placeholder.png'),
                    ),
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(10))),
                const Text("Nama"),
                Text(
                  args.namaEvent,
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
                const Text("Tanggal"),
                Text(args.tanggal,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500)),
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                ),
              ],
            ),
          )),
    );
  }
}
