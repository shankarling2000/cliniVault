import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class View extends StatelessWidget {
  PdfViewerController? _pdfViewerController;
  final Reporturl;
  View({this.Reporturl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF VIEWER'),
      ),
      body: SfPdfViewer.network(
        Reporturl,
        controller: _pdfViewerController,
      ),
    );
  }
}
