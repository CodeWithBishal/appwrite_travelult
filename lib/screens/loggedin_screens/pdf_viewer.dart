import 'dart:io';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter/material.dart';
import 'package:travelult/widgets/appbar.dart';

class PdfViewerPage extends StatefulWidget {
  final File pdf;
  const PdfViewerPage({
    Key? key,
    required this.pdf,
  }) : super(key: key);

  @override
  State<PdfViewerPage> createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  int? pages = 0;
  int? currentPage = 0;
  late PDFViewController controller;
  @override
  Widget build(BuildContext context) {
    final pageNumber = "${currentPage! + 1} of $pages";
    final fileName = widget.pdf.path.split("/").last;
    return Scaffold(
      appBar: commonAppBar(
        title: fileName,
        elevation: 0,
        centerTitle: true,
        context: context,
        actions: [
          IconButton(
            onPressed: () {
              final page = currentPage == 0 ? pages : currentPage! - 1;
              controller.setPage(page!);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 20,
            ),
            enableFeedback: false,
          ),
          Center(
            child: Text(
              pageNumber,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              final page = currentPage == pages! - 1 ? 0 : currentPage! + 1;
              controller.setPage(page);
            },
            icon: const Icon(
              Icons.arrow_forward_ios,
              size: 20,
            ),
            enableFeedback: false,
          ),
        ],
      ),
      body: PDFView(
        filePath: widget.pdf.path,
        defaultPage: currentPage!,
        preventLinkNavigation: false,
        onRender: (pagess) {
          setState(() {
            pages = pagess;
          });
        },
        onViewCreated: (controller) => setState(() {
          this.controller = controller;
        }),
        onPageChanged: (currentPage, _) => setState(() {
          this.currentPage = currentPage;
        }),
      ),
    );
  }
}
