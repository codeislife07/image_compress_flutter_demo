
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Image Compress Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  File? inputFile;
  File? outputFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            inputFile==null?Container():Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    height: 100,
                    child: Image.file(inputFile!,fit: BoxFit.fill,)),
                Text((inputFile!.lengthSync()/1024).toString()+" KB")
              ],
            ),
            ElevatedButton(onPressed: () async {
              //get image from camera
              XFile? f=await ImagePicker().pickImage(source: ImageSource.camera);
              inputFile=File(f!.path);
              setState(() {

              });
            }, child: Text("click Image")),
            ElevatedButton(onPressed: () async {
              //get image from device gallery
              XFile? f=await ImagePicker().pickImage(source: ImageSource.gallery);
              inputFile=File(f!.path);
              setState(() {

              });
            }, child: Text("Pick Image")),
            ElevatedButton(onPressed: ()async{
              //compress image and passing to outputFile in
              Uint8List? f=await testCompressFile(inputFile!);//custom method to compress image
                var fileDirectory=await getApplicationCacheDirectory();//get app cache directory
              //create new file with same extensison
                var outFileNew=await File(fileDirectory.path+"/${DateTime.now().microsecond}.${basename(inputFile?.path??"")}").create();
             if(f!=null){
               //write new file with compress Uint8List
               outFileNew!.writeAsBytes(f!);
                 outputFile=outFileNew;
             }else{
               outputFile=inputFile;
             }
             setState(() {

             });
            }, child: Text("Compress Image")),
            outputFile==null?Container():Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    height: 100,
                    child: Image.file(outputFile!,fit: BoxFit.fill,)),//show compress image/file
                Text((outputFile!.lengthSync()/1024).toString()+" KB")//show size in kb
              ],
            )
          ],
        ),
      ));
  }
  Future<Uint8List?> testCompressFile(File file) async {
    var result = await FlutterImageCompress.compressWithFile(
      file.absolute.path,//file path
      // minHeight: 12, //pass min Height
      // minWidth: 12, //pass min Width
      quality: 80,//quality for output file
      rotate: 0,//if rotate require then pass it between 0 to 180
    ).onError((error, stackTrace){
      //if any error exit
      print(stackTrace.toString());
      print(error.toString());
    });
    print(file.lengthSync());
    print(result?.length??"0");
    return result;//return new image Uint8List
  }
}


