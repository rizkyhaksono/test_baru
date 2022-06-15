import 'dart:ui';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:test_firebase/Screens/BuktiTransfer/bukti_screen.dart';
import 'package:test_firebase/Screens/Database/storage_service.dart';
import 'package:test_firebase/constants.dart';

var filePathBukti;

class BuktiBody extends StatefulWidget {
  const BuktiBody({Key? key}) : super(key: key);

  @override
  State<BuktiBody> createState() => _BuktiBodyState();
}

class _BuktiBodyState extends State<BuktiBody> {
  final Storage storage = Storage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundcolor,
        shadowColor: Colors.transparent,
        title: const Padding(
          padding: EdgeInsets.only(left: 55),
          child: Text(
            "Bukti Transfer",
            style: TextStyle(
              fontFamily: "Poppin",
              fontSize: 22,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 250,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(100),
                bottomRight: Radius.circular(100),
              ),
              color: backgroundcolor,
            ),
            child: const Padding(
              padding: EdgeInsets.only(top: 75, left: 55),
              child: Text(
                "Upload Bukti Transfer",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontFamily: "Poppin",
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20, top: 10),
            child: IconButton(
              icon: const Icon(
                Icons.add_a_photo,
                size: 50,
              ),
              onPressed: (() async {
                final result = await FilePicker.platform.pickFiles(
                  allowMultiple: false,
                  type: FileType.custom,
                  allowedExtensions: ['png', 'jpg'],
                );
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Data sudah tersimpan!')));

                if (result == null) {
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('No file selected'),
                    ),
                  );
                  return null;
                }

                final path = result.files.single.path!;
                final fileName = result.files.single.name;

                filePathBukti = fileName;

                storage
                    .uploadFile(path, fileName)
                    .then((value) => print("Done"));
              }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: kPrimaryDarkColor,
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const BuktiBody()));
                    // check if filePath is null
                    if (filePathBukti == null) {
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Tolong upload file terlebih dahulu!'),
                        ),
                      );
                      return null;
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BuktiTF(),
                        ),
                      );
                    }
                  },
                  child: const Text("See image"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                  ),
                  onPressed: () async {
                    await firebase_storage.FirebaseStorage.instance
                        .ref('BuktiTransfer/$filePathBukti')
                        .delete();
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Data sudah terhapus!')));
                  },
                  child: const Text("Delete Image"),
                ),
              ],
            ),
          ),
          // delete image
          SizedBox(
            width: double.infinity,
            height: 308,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Positioned(
                  bottom: 0,
                  child: Image.asset("assets/images/wavedashboard-1.png"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
