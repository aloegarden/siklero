import 'dart:io';
import 'package:flutter/services.dart';
import 'package:siklero/admin/api/pdf_api.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:siklero/admin/bikefailures_records_screen.dart';
import 'package:intl/intl.dart';

class PdfReportsApi {
  static Future<File> generate(
      List<RecordsCard> records, String tableTitle) async {
    final pdf = Document();

    final imageJpg = (await rootBundle.load('asset/img/siklero-logo.png'))
        .buffer
        .asUint8List();
    final date = DateTime.now();

    pdf.addPage(MultiPage(
      //means you can create multiple widgets inside.
      build: (context) => [
        buildLogo(imageJpg),
        buildTitle(date),
        SizedBox(height: 2 * PdfPageFormat.cm),
        buildTableTitle(tableTitle),
        SizedBox(height: 1 * PdfPageFormat.cm),
        buildRecords(records),
      ],
      footer: (context) => buildFooter(),
    ));

    return PdfApi.saveDocument(name: 'bicycle_failures_records.pdf', pdf: pdf);
  }

  static Widget buildTableTitle(String tableTitle) => Center(
        child: Text(tableTitle,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center),
      );

  static Widget buildTitle(DateTime date) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Bicycle Failure Records',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center),
          SizedBox(height: 0.5 * PdfPageFormat.mm),
          Text('As of ${DateFormat('MMMM dd, yyyy').format(date)}',
              textAlign: TextAlign.center),
          SizedBox(height: 0.5 * PdfPageFormat.mm),
          Text(DateFormat('hh:mm a').format(date), textAlign: TextAlign.center),
        ],
      );

  static Widget buildLogo(final image) => Center(
        child: Image(MemoryImage(image), height: 70),
      );

  static Widget buildRecords(List<RecordsCard> records) {
    final headers = ['No.', 'Caller', 'Responder', 'Date', 'Time', 'Location'];
    int number = 1;

    final data = records.map((record) {
      return [
        number++,
        record.caller,
        record.responder,
        record.date,
        record.time,
        record.location
      ];
    }).toList();

    return Table.fromTextArray(
        headers: headers,
        data: data,
        border: null,
        headerStyle: TextStyle(fontWeight: FontWeight.bold),
        headerDecoration: BoxDecoration(color: PdfColors.grey300),
        cellHeight: 30,
        cellAlignments: {
          0: Alignment.center,
          1: Alignment.center,
          2: Alignment.center,
          3: Alignment.center,
          4: Alignment.center,
          5: Alignment.center,
        });
  }

  static Widget buildFooter() => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Divider(),
          SizedBox(height: 2 * PdfPageFormat.mm),
          Text('Development of a Mobile Application for NCR Cyclists'),
          SizedBox(height: 1 * PdfPageFormat.mm),
          Text('Siklero App', style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      );
}
