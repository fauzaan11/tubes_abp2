import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/components/loading.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Register extends StatelessWidget {
  const Register({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [MyStatefulWidget()],
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  String name = "";
  bool loading = false;

  //fungsi untk menampilkan/menutup loading
  void setLoading() {
    setState(() {
      loading = !loading;
    });
  }

  //fungsi untuk memanggil API
  Future<http.Response> apiCall(data, url) async {
    return await http.post(Uri.parse(url), body: jsonEncode(data), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    });
  }

  //fungsi untuk register
  void register(context) async {
    setLoading();

    //data untuk register
    var data = {'email': email, 'password': password, 'name': name};

    //panggil dan tunggu fungsi untuk memanggil API
    var res = await apiCall(data, 'http://127.0.0.1:8000/api/register-user');

    //ubah data dari API ke bentuk json
    var body = json.decode(res.body);

    //cek apakah register berhasil, code 200 berarti berhasil
    if (body['meta']['code'] == 200) {
      setLoading();

      //simpan token dan data user ke localStorage(penyimpanan sementara aplikasi)
      SharedPreferences.setMockInitialValues({});
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString(
          'token', json.encode(body['data']['access_token']));
      localStorage.setString('user', json.encode(body['data']['user']));

      //pindah route ke dashboard
      Navigator.pushNamed(context, '/dashboard');

      //jika gagal register
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
    return loading
        ? const Loading()
        : SafeArea(
            child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Center(
                        child: Text(
                          "Register",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 32,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Enter your name',
                        ),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          } else {
                            name = value;
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Enter your email',
                        ),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          } else {
                            email = value;
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Enter your password',
                        ),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          } else {
                            password = value;
                          }
                          return null;
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Center(
                            child: ElevatedButton(
                          onPressed: () {
                            // Validate will return true if the form is valid, or false if
                            // the form is invalid.
                            if (_formKey.currentState!.validate()) {
                              // Process data.
                              register(context);
                            }
                          },
                          child: const Text('Submit'),
                        )),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Sudah punya akun?"),
                          TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/login');
                              },
                              child: const Text("Login"))
                        ],
                      )
                    ],
                  ),
                )));
  }
}
