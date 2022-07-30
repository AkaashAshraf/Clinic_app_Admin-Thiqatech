import 'dart:io';

import 'package:demoadmin/model/appointmentModel.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:pdf/widgets.dart' as pw;

class User {
  final name;
  final age;
  final email;
  final city;
  final date;
  final time;
  final type;
  final payment;
  final amount;
  final id;
  final gender;
  final sn;

  const User(
      {this.sn,
      this.name,
      this.age,
      this.id,
      this.gender,
      this.email,
      this.city,
      this.date,
      this.amount,
      this.payment,
      this.type,
      this.time});
}

class PdfApi {
  static Future<File> generateTable(List<AppointmentModel> appModel) async {
    final pdf = Document();

    final headers = [
      'SN',
      'Name',
      'Age',
      'Gender',
      "Email",
      'City',
      'Appointment Date',
      'Time',
      'Type',
      'Payment',
      'Amount',
      'Appointment ID'
    ];

    final List<User> users = [];
    int sn = 1;
    for (var e in appModel) {
      users.add(User(
          sn: sn,
          gender: e.gender,
          city: e.pCity,
          age: e.age,
          email: e.pEmail,
          id: e.id,
          name: e.pFirstName + " " + e.pLastName,
          amount: e.amount,
          date: e.appointmentDate,
          payment: e.paymentStatus,
          time: e.appointmentTime,
          type: e.serviceName));
      sn = sn + 1;
    }
    final data = users
        .map((user) => [
              user.sn,
              user.name,
              user.age,
              user.gender,
              user.email,
              user.city,
              user.date,
              user.time,
              user.type,
              user.payment,
              user.amount,
              user.id
            ])
        .toList();

    pdf.addPage(Page(
      pageFormat: PdfPageFormat.a4,
      build: (context) => Table.fromTextArray(
        headers: headers,
        data: data,
        headerStyle: pw.TextStyle(fontSize: 7),
        cellStyle: pw.TextStyle(fontSize: 7),
      ),
    ));

    return saveDocument(name: 'Appointment History.pdf', pdf: pdf);
  }

  static Future<File> generateImage() async {
    final pdf = Document();

    final imageSvg = await rootBundle.loadString('assets/fruit.svg');
    final imageJpg =
        (await rootBundle.load('assets/person.jpg')).buffer.asUint8List();

    final pageTheme = PageTheme(
      pageFormat: PdfPageFormat.a4,
      buildBackground: (context) {
        if (context.pageNumber == 1) {
          return FullPage(
            ignoreMargins: true,
            child: Image(MemoryImage(imageJpg), fit: BoxFit.cover),
          );
        } else {
          return Container();
        }
      },
    );

    pdf.addPage(
      MultiPage(
        pageTheme: pageTheme,
        build: (context) => [
          Container(
            height: pageTheme.pageFormat.availableHeight - 1,
            child: Center(
              child: Text(
                'Foreground Text',
                style: TextStyle(color: PdfColors.white, fontSize: 48),
              ),
            ),
          ),
          SvgImage(svg: imageSvg),
          Image(MemoryImage(imageJpg)),
          Center(
            child: ClipRRect(
              horizontalRadius: 32,
              verticalRadius: 32,
              child: Image(
                MemoryImage(imageJpg),
                width: pageTheme.pageFormat.availableWidth / 2,
              ),
            ),
          ),
          GridView(
            crossAxisCount: 3,
            childAspectRatio: 1,
            children: [
              SvgImage(svg: imageSvg),
              SvgImage(svg: imageSvg),
              SvgImage(svg: imageSvg),
              SvgImage(svg: imageSvg),
              SvgImage(svg: imageSvg),
              SvgImage(svg: imageSvg),
            ],
          )
        ],
      ),
    );

    return saveDocument(name: 'my_example.pdf', pdf: pdf);
  }

  static Future<File> saveDocument({
    String? name,
    Document? pdf,
  }) async {
    final bytes = await pdf!.save();

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');

    await file.writeAsBytes(bytes);

    return file;
  }

  static Future openFile(File file) async {
    final url = file.path;

    await OpenFile.open(url);
  }
}
