import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart' show rootBundle;

class PdfPage extends StatelessWidget {
  //Font ki mkc bohot dikkat diya important hai
  Future<pw.Font> loadRobotoFont() async {
    final fontData = await rootBundle.load("assets/fonts/Roboto-Regular.ttf");
    return pw.Font.ttf(fontData);
  }

// Load the image iski bhi mummy
  Future<pw.ImageProvider> loadImage() async {
    final imageBytes = await rootBundle.load('assets/main/logo.png');
    return pw.MemoryImage(imageBytes.buffer.asUint8List());
  }

  Future<void> createPdfAndPrint() async {
    final pdf = pw.Document(); // Create a PDF document
    final robotoFont = await loadRobotoFont(); //load font
    final image = await loadImage(); // load image

    pdf.addPage(
      // Add page to PDF
      pw.Page(
        build: (pw.Context context) {
          // Add content to page here
          return pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Row(children: [
                      pw.Image(image, width: 100, height: 100),
                      pw.SizedBox(width: 10),
                      pw.Text(
                        'Vanrakshak',
                        style: pw.TextStyle(
                            font: robotoFont,
                            fontSize: 24,
                            fontWeight: pw.FontWeight.bold),
                      ),
                      pw.SizedBox(width: 10),
                    ]),

                    pw.Divider(),
                    pw.Text(
                      'Bill Details',
                      style: pw.TextStyle(font: robotoFont, fontSize: 18),
                    ),
                    // Add more details here
                    pw.Text(
                      'Item: Some item\nPrice: \$20\nQuantity: 3\nTotal: \$60',
                      style: pw.TextStyle(font: robotoFont, fontSize: 18),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

    // Print the PDF
    await Printing.layoutPdf(
      onLayout: (format) => pdf.save(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('PDF Creation and Printing')),
      body: Center(
        child: ElevatedButton(
          child: Text('Create and Print PDF'),
          onPressed: createPdfAndPrint,
        ),
      ),
    );
  }
}
