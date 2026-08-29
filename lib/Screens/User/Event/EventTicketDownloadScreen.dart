import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart' hide Column, Row, Border, Radius, BoxDecoration, CustomPaint, Alignment;
import 'package:flutter/material.dart' as flutter;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'package:gotilo_new/Api/ApiCalls.dart';
import 'package:gotilo_new/Api/Request/User/Event/RequestEventTicketDownload.dart';
import 'package:gotilo_new/Api/Response/User/Event/ResponseEventTicketDownload.dart';
import 'package:gotilo_new/Api/Request/User/Event/RequestAssignTicketName.dart';
import 'package:gotilo_new/Api/Response/User/Event/ResponseAssignTicketName.dart';
import 'package:gotilo_new/Constant/AppPref.dart';
import 'package:gotilo_new/CustomeWidgets/CustomAppbar.dart';
import 'package:gotilo_new/CustomeWidgets/SharedWidgets.dart';
import 'package:gotilo_new/MyApplication/MyApplication.dart';

class EventTicketDownloadScreen extends flutter.StatefulWidget {
  final String? bookingId;
  const EventTicketDownloadScreen({super.key, this.bookingId});

  @override
  flutter.State<EventTicketDownloadScreen> createState() => _EventTicketDownloadScreenState();
}

class _EventTicketDownloadScreenState extends flutter.State<EventTicketDownloadScreen> {
  EventTicketDownload? eventTicketDownload;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _callEventTicketDownload();
  }

  Future<void> _callEventTicketDownload() async {
    bool internet = await MyApplication.checkInternet();
    if (internet) {
      try {
        ResponseEventTicketDownload? response = await ApiCalls.callEventTicketDownload(
          RequestEventTicketDownload(
            userId: AppPrefs.userId,
            bookingId: widget.bookingId,
          ),
        );

        if (response != null &&
            response.result != null &&
            response.result!.toLowerCase().contains("pass")) {
          setState(() {
            eventTicketDownload = response.data;
          });
        }
      } catch (e) {
        log("$e");
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        SharedWidgets.showTopSnackBar(context, message: "No Internet Connection");
      }
    }
  }

  // API Integration for Assign Ticket Name
  Future<bool> _callAssignTicketName({required String ticketId, required String newName}) async {
    bool isSuccess = false;
    bool internet = await MyApplication.checkInternet();
    if (internet) {
      try {
        ResponseAssignTicketName? response = await ApiCalls.callAssignTicketName(
          RequestAssignTicketName(
            userId: AppPrefs.userId,
            userName: newName,
            ticketId: ticketId,
          ),
        );

        if (response != null) {
          if (response.result != null &&
              response.result!.isNotEmpty &&
              response.result!.toLowerCase().contains("pass")) {
            if (mounted) {
              SharedWidgets.showTopSnackBar(context, message: response.message ?? "Name updated successfully!");
            }
            isSuccess = true;
          } else {
            if (mounted) {
              SharedWidgets.showTopSnackBar(context, message: response.message ?? "Failed to update name");
            }
          }
        }
      } on Exception catch (e) {
        log("$e");
      } catch (e) {
        log("$e");
      }
    } else {
      if (mounted) {
        SharedWidgets.showTopSnackBar(context, message: "No Internet Connection");
      }
    }
    return isSuccess;
  }

  // Storage permission request helper
  Future<bool> _requestStoragePermission() async {
    if (Platform.isAndroid) {
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        status = await Permission.storage.request();
      }
      return status.isGranted || await Permission.manageExternalStorage.isGranted;
    }
    return true;
  }

  // Generate PDF document matching EXACT screen UI design
  Future<Uint8List> _generatePdf(List<Tickets> tickets) async {
    final pdf = pw.Document();

    for (var ticket in tickets) {
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(20),
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Container(
                width: 500,
                decoration: pw.BoxDecoration(
                  borderRadius: pw.BorderRadius.circular(16),
                  boxShadow: const [
                    pw.BoxShadow(
                      color: PdfColors.grey300,
                      blurRadius: 10,
                      spreadRadius: 2,
                    )
                  ],
                ),
                child: pw.Column(
                  mainAxisSize: pw.MainAxisSize.min,
                  children: [
                    // Main Ticket Card Container
                    pw.Container(
                      decoration: pw.BoxDecoration(
                        color: PdfColor.fromHex("#E0F7FA"),
                        borderRadius: const pw.BorderRadius.only(
                          topLeft: pw.Radius.circular(16),
                          topRight: pw.Radius.circular(16),
                        ),
                      ),
                      child: pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        children: [
                          // Left Content Section
                          pw.Expanded(
                            flex: 66,
                            child: pw.Padding(
                              padding: const pw.EdgeInsets.all(16),
                              child: pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  // Slot Name Tag
                                  pw.Container(
                                    padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: pw.BoxDecoration(
                                      color: PdfColor.fromHex("#00838F"),
                                      borderRadius: pw.BorderRadius.circular(20),
                                    ),
                                    child: pw.Text(
                                      (ticket.slotName ?? "EVENING EVENT").toUpperCase(),
                                      style: pw.TextStyle(
                                        fontSize: 9,
                                        fontWeight: pw.FontWeight.bold,
                                        color: PdfColors.white,
                                      ),
                                    ),
                                  ),
                                  pw.SizedBox(height: 10),
                                  // Event Title
                                  pw.Text(
                                    ticket.event?.title ?? "Test Event",
                                    style: pw.TextStyle(
                                      fontSize: 18,
                                      fontWeight: pw.FontWeight.bold,
                                      color: PdfColor.fromHex("#0F2027"),
                                    ),
                                  ),
                                  pw.SizedBox(height: 6),
                                  // Attendee Name
                                  pw.Row(
                                    children: [
                                      pw.Text(
                                        "Attendee: ",
                                        style: pw.TextStyle(
                                          fontSize: 12,
                                          color: PdfColors.grey700,
                                        ),
                                      ),
                                      pw.Text(
                                        (ticket.attendeeName != null && ticket.attendeeName!.isNotEmpty)
                                            ? ticket.attendeeName!
                                            : "Not Set",
                                        style: pw.TextStyle(
                                          fontSize: 13,
                                          fontWeight: pw.FontWeight.bold,
                                          color: PdfColors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                  pw.SizedBox(height: 12),
                                  // Dashed Horizontal Divider
                                  pw.Container(
                                    height: 1,
                                    child: pw.Row(
                                      children: List.generate(
                                        25,
                                            (index) => pw.Expanded(
                                          child: pw.Container(
                                            color: index % 2 == 0 ? PdfColors.grey400 : PdfColors.white,
                                            height: 1,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  pw.SizedBox(height: 12),
                                  // Key Event Details
                                  pw.Row(
                                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                    children: [
                                      _buildPdfDetail("DATE", ticket.event?.eventDate ?? "2026-08-07"),
                                      _buildPdfDetail("TIME", ticket.event?.eventTime ?? "11:53 PM"),
                                      _buildPdfDetail("CATEGORY", ticket.category?.categoryName ?? "VVIP", isBadge: true),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Vertical Dashed Line Divider
                          pw.Container(
                            width: 1,
                            height: 140,
                            child: pw.Column(
                              children: List.generate(
                                20,
                                    (index) => pw.Expanded(
                                  child: pw.Container(
                                    color: index % 2 == 0 ? PdfColor.fromHex("#00838F") : PdfColors.white,
                                    width: 1,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // Right Section (Ticket No & QR Code)
                          pw.Expanded(
                            flex: 34,
                            child: pw.Container(
                              padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                              child: pw.Column(
                                mainAxisAlignment: pw.MainAxisAlignment.center,
                                children: [
                                  pw.Text(
                                    "#${ticket.ticketNumber ?? '2V0QPEII'}",
                                    style: pw.TextStyle(
                                      fontSize: 11,
                                      fontWeight: pw.FontWeight.bold,
                                      color: PdfColor.fromHex("#00695C"),
                                    ),
                                  ),
                                  pw.SizedBox(height: 10),
                                  pw.Container(
                                    padding: const pw.EdgeInsets.all(6),
                                    decoration: pw.BoxDecoration(
                                      color: PdfColors.white,
                                      borderRadius: pw.BorderRadius.circular(8),
                                    ),
                                    child: pw.BarcodeWidget(
                                      barcode: pw.Barcode.qrCode(),
                                      data: ticket.qr?.qrCode ?? ticket.ticketNumber ?? "N/A",
                                      width: 70,
                                      height: 70,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Ticket Bottom Status Bar
                    pw.Container(
                      padding: const pw.EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: const pw.BoxDecoration(
                        color: PdfColors.white,
                        borderRadius: pw.BorderRadius.only(
                          bottomLeft: pw.Radius.circular(16),
                          bottomRight: pw.Radius.circular(16),
                        ),
                      ),
                      child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Row(
                            children: [
                              pw.Text(
                                "✔ Valid Entry Pass",
                                style: pw.TextStyle(
                                  fontSize: 11,
                                  fontWeight: pw.FontWeight.bold,
                                  color: PdfColors.green700,
                                ),
                              ),
                            ],
                          ),
                          pw.Text(
                            "Gotilo Events",
                            style: pw.TextStyle(
                              fontSize: 10,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColor.fromHex("#00838F"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    }
    return pdf.save();
  }

  // Helper Widget for PDF Details
  static pw.Widget _buildPdfDetail(String label, String value, {bool isBadge = false}) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(
            fontSize: 8,
            fontWeight: pw.FontWeight.bold,
            color: PdfColor.fromHex("#546E7A"),
          ),
        ),
        pw.SizedBox(height: 3),
        isBadge
            ? pw.Container(
          padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: pw.BoxDecoration(
            color: PdfColor.fromHex("#FFD54F"),
            borderRadius: pw.BorderRadius.circular(4),
          ),
          child: pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: 10,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.black,
            ),
          ),
        )
            : pw.Text(
          value,
          style: pw.TextStyle(
            fontSize: 11,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.black,
          ),
        ),
      ],
    );
  }

  // Save PDF & Launch Share Intent
  Future<void> _saveAndDownloadTicket(List<Tickets> tickets, String fileName) async {
    try {
      final pdfBytes = await _generatePdf(tickets);

      await Printing.sharePdf(bytes: pdfBytes, filename: '$fileName.pdf');

      final directory = await getApplicationDocumentsDirectory();
      final file = File("${directory.path}/$fileName.pdf");
      await file.writeAsBytes(pdfBytes);

      if (mounted) {
        SharedWidgets.showTopSnackBar(context, message: "Saved to downloads: $fileName.pdf");
      }
    } catch (e) {
      log("Save ticket error: $e");
      if (mounted) {
        SharedWidgets.showTopSnackBar(context, message: "Failed to download ticket!");
      }
    }
  }

  void _downloadSingleTicket(Tickets ticket) {
    _saveAndDownloadTicket([ticket], "Ticket_${ticket.ticketNumber ?? 'Pass'}");
  }

  void _downloadAllTickets() {
    if (eventTicketDownload?.tickets != null && eventTicketDownload!.tickets!.isNotEmpty) {
      _saveAndDownloadTicket(eventTicketDownload!.tickets!, "All_Event_Tickets_${widget.bookingId ?? 'Pass'}");
    }
  }

  // Edit Attendee Name Dialog with API Trigger
  void _showEditNameDialog(Tickets ticket) {
    flutter.TextEditingController nameController = flutter.TextEditingController(text: ticket.attendeeName ?? '');
    bool isSaving = false;

    flutter.showDialog(
      context: context,
      builder: (context) {
        return flutter.StatefulBuilder(
          builder: (context, setDialogState) {
            return flutter.AlertDialog(
              shape: flutter.RoundedRectangleBorder(borderRadius: flutter.BorderRadius.circular(16)),
              title: const flutter.Text("Edit Attendee Name", style: flutter.TextStyle(fontWeight: flutter.FontWeight.bold)),
              content: flutter.TextField(
                controller: nameController,
                enabled: !isSaving,
                decoration: flutter.InputDecoration(
                  hintText: "Enter Attendee Name",
                  border: flutter.OutlineInputBorder(borderRadius: flutter.BorderRadius.circular(10)),
                  focusedBorder: flutter.OutlineInputBorder(
                    borderRadius: flutter.BorderRadius.circular(10),
                    borderSide: const flutter.BorderSide(color: flutter.Color(0xFF00ACC1), width: 2),
                  ),
                ),
              ),
              actions: [
                flutter.TextButton(
                  onPressed: isSaving ? null : () => flutter.Navigator.pop(context),
                  child: const flutter.Text("Cancel", style: flutter.TextStyle(color: flutter.Colors.grey)),
                ),
                flutter.ElevatedButton(
                  style: flutter.ElevatedButton.styleFrom(
                    backgroundColor: const flutter.Color(0xFF00838F),
                    shape: flutter.RoundedRectangleBorder(borderRadius: flutter.BorderRadius.circular(8)),
                  ),
                  onPressed: isSaving
                      ? null
                      : () async {
                    String enteredName = nameController.text.trim();
                    if (enteredName.isEmpty) {
                      SharedWidgets.showTopSnackBar(context, message: "Please enter a valid name");
                      return;
                    }

                    setDialogState(() {
                      isSaving = true;
                    });

                    bool updated = await _callAssignTicketName(
                      ticketId: ticket.ticketId ?? "",
                      newName: enteredName,
                    );

                    if (updated) {
                      setState(() {
                        ticket.attendeeName = enteredName;
                      });
                      if (mounted) flutter.Navigator.pop(context);
                    } else {
                      setDialogState(() {
                        isSaving = false;
                      });
                    }
                  },
                  child: isSaving
                      ? const flutter.SizedBox(
                    width: 20,
                    height: 20,
                    child: flutter.CircularProgressIndicator(color: flutter.Colors.white, strokeWidth: 2),
                  )
                      : const flutter.Text("Save", style: flutter.TextStyle(color: flutter.Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  flutter.Widget build(flutter.BuildContext context) {
    return flutter.Scaffold(
      backgroundColor: const flutter.Color(0xFFF3F7F9),
      appBar: CustomAppBar(
        title: "Event Tickets",
        showAction: false,
        showBackButton: true,
      ),
      body: isLoading
          ? const flutter.Center(child: flutter.CircularProgressIndicator(color: flutter.Color(0xFF00838F)))
          : eventTicketDownload == null || (eventTicketDownload?.tickets ?? []).isEmpty
          ? const flutter.Center(child: flutter.Text("No Tickets Found"))
          : flutter.Column(
        children: [
          flutter.Expanded(
            child: flutter.ListView.builder(
              padding: const flutter.EdgeInsets.all(16),
              itemCount: eventTicketDownload!.tickets!.length,
              itemBuilder: (context, index) {
                final ticket = eventTicketDownload!.tickets![index];
                return _buildFaduTicketItem(ticket);
              },
            ),
          ),
          flutter.Container(
            padding: const flutter.EdgeInsets.all(16),
            decoration: flutter.BoxDecoration(
              color: flutter.Colors.white,
              boxShadow: [
                flutter.BoxShadow(
                  color: flutter.Colors.black.withOpacity(0.06),
                  blurRadius: 10,
                  offset: const flutter.Offset(0, -4),
                )
              ],
            ),
            child: flutter.Container(
              decoration: flutter.BoxDecoration(
                gradient: const flutter.LinearGradient(
                  colors: [flutter.Color(0xFF00838F), flutter.Color(0xFF00ACC1)],
                ),
                borderRadius: flutter.BorderRadius.circular(12),
                boxShadow: [
                  flutter.BoxShadow(
                    color: const flutter.Color(0xFF00ACC1).withOpacity(0.4),
                    blurRadius: 12,
                    offset: const flutter.Offset(0, 4),
                  ),
                ],
              ),
              child: flutter.ElevatedButton.icon(
                style: flutter.ElevatedButton.styleFrom(
                  minimumSize: const flutter.Size(double.infinity, 52),
                  backgroundColor: flutter.Colors.transparent,
                  shadowColor: flutter.Colors.transparent,
                  shape: flutter.RoundedRectangleBorder(borderRadius: flutter.BorderRadius.circular(12)),
                ),
                onPressed: _downloadAllTickets,
                icon: const flutter.Icon(flutter.Icons.file_download, color: flutter.Colors.white),
                label: flutter.Text(
                  "DOWNLOAD ALL TICKETS (${eventTicketDownload?.totalTickets ?? 0})",
                  style: const flutter.TextStyle(
                    fontSize: 15,
                    fontWeight: flutter.FontWeight.w800,
                    letterSpacing: 0.8,
                    color: flutter.Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  flutter.Widget _buildFaduTicketItem(Tickets ticket) {
    return flutter.Container(
      margin: const flutter.EdgeInsets.only(bottom: 20),
      decoration: flutter.BoxDecoration(
        boxShadow: [
          flutter.BoxShadow(
            color: const flutter.Color(0xFF00ACC1).withOpacity(0.12),
            blurRadius: 16,
            spreadRadius: 2,
            offset: const flutter.Offset(0, 6),
          ),
        ],
      ),
      child: flutter.Column(
        children: [
          flutter.ClipPath(
            clipper: TicketClipper(),
            child: flutter.Container(
              decoration: const flutter.BoxDecoration(
                gradient: flutter.LinearGradient(
                  colors: [flutter.Color(0xFFE0F7FA), flutter.Color(0xFFB2EBF2)],
                  begin: flutter.Alignment.topLeft,
                  end: flutter.Alignment.bottomRight,
                ),
              ),
              child: flutter.Row(
                children: [
                  flutter.Expanded(
                    flex: 66,
                    child: flutter.Padding(
                      padding: const flutter.EdgeInsets.all(16),
                      child: flutter.Column(
                        crossAxisAlignment: flutter.CrossAxisAlignment.start,
                        children: [
                          flutter.Row(
                            children: [
                              flutter.Container(
                                padding: const flutter.EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: flutter.BoxDecoration(
                                  color: const flutter.Color(0xFF00838F),
                                  borderRadius: flutter.BorderRadius.circular(20),
                                ),
                                child: flutter.Text(
                                  (ticket.slotName ?? "EVENING EVENT").toUpperCase(),
                                  style: const flutter.TextStyle(
                                    fontSize: 10,
                                    fontWeight: flutter.FontWeight.w800,
                                    color: flutter.Colors.white,
                                    letterSpacing: 0.6,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const flutter.SizedBox(height: 10),
                          flutter.Text(
                            ticket.event?.title ?? "Test Event",
                            style: const flutter.TextStyle(
                              fontSize: 18,
                              fontWeight: flutter.FontWeight.w900,
                              color: flutter.Color(0xFF0F2027),
                            ),
                          ),
                          const flutter.SizedBox(height: 6),
                          flutter.Row(
                            children: [
                              const flutter.Icon(flutter.Icons.person, size: 14, color: flutter.Color(0xFF00838F)),
                              const flutter.SizedBox(width: 4),
                              flutter.Text(
                                (ticket.attendeeName != null && ticket.attendeeName!.isNotEmpty)
                                    ? ticket.attendeeName!
                                    : "Not Set",
                                style: const flutter.TextStyle(
                                  fontSize: 14,
                                  fontWeight: flutter.FontWeight.bold,
                                  color: flutter.Colors.black87,
                                ),
                              ),
                              const flutter.SizedBox(width: 6),
                              flutter.InkWell(
                                onTap: () => _showEditNameDialog(ticket),
                                child: const ContainerEditIcon(),
                              ),
                            ],
                          ),
                          const flutter.SizedBox(height: 14),
                          flutter.CustomPaint(
                            size: const flutter.Size(double.infinity, 1),
                            painter: HorizontalDashedLinePainter(),
                          ),
                          const flutter.SizedBox(height: 12),
                          flutter.Row(
                            mainAxisAlignment: flutter.MainAxisAlignment.spaceBetween,
                            children: [
                              _buildLuxuryDetail("DATE", ticket.event?.eventDate ?? "2026-08-07"),
                              _buildLuxuryDetail("TIME", ticket.event?.eventTime ?? "11:53 PM"),
                              _buildLuxuryDetail("CATEGORY", ticket.category?.categoryName ?? "VVIP", isBadge: true),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  flutter.CustomPaint(
                    size: const flutter.Size(1, 160),
                    painter: VerticalDashedLinePainter(),
                  ),
                  flutter.Expanded(
                    flex: 34,
                    child: flutter.Container(
                      padding: const flutter.EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                      child: flutter.Column(
                        mainAxisAlignment: flutter.MainAxisAlignment.center,
                        children: [
                          flutter.Text(
                            "#${ticket.ticketNumber ?? '2V0QPEII'}",
                            style: const flutter.TextStyle(
                              fontSize: 12,
                              fontWeight: flutter.FontWeight.w900,
                              color: flutter.Color(0xFF00695C),
                              letterSpacing: 0.5,
                            ),
                          ),
                          const flutter.SizedBox(height: 10),
                          flutter.Container(
                            padding: const flutter.EdgeInsets.all(6),
                            decoration: flutter.BoxDecoration(
                              color: flutter.Colors.white,
                              borderRadius: flutter.BorderRadius.circular(10),
                              boxShadow: [
                                flutter.BoxShadow(
                                  color: flutter.Colors.black.withOpacity(0.05),
                                  blurRadius: 6,
                                )
                              ],
                            ),
                            child: QrImageView(
                              data: ticket.qr?.qrCode ?? ticket.ticketNumber ?? "N/A",
                              version: QrVersions.auto,
                              size: 72.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          flutter.Container(
            padding: const flutter.EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: const flutter.BoxDecoration(
              color: flutter.Colors.white,
              borderRadius: flutter.BorderRadius.only(
                bottomLeft: flutter.Radius.circular(16),
                bottomRight: flutter.Radius.circular(16),
              ),
            ),
            child: flutter.Row(
              mainAxisAlignment: flutter.MainAxisAlignment.spaceBetween,
              children: [
                const flutter.Row(
                  children: [
                    flutter.Icon(flutter.Icons.verified_outlined, size: 16, color: flutter.Colors.green),
                    flutter.SizedBox(width: 4),
                    flutter.Text(
                      "Valid Entry Pass",
                      style: flutter.TextStyle(fontSize: 11, fontWeight: flutter.FontWeight.bold, color: flutter.Colors.green),
                    ),
                  ],
                ),
                flutter.InkWell(
                  onTap: () => _downloadSingleTicket(ticket),
                  child: const flutter.Row(
                    children: [
                      flutter.Icon(flutter.Icons.download_for_offline_rounded, size: 18, color: flutter.Color(0xFF00838F)),
                      flutter.SizedBox(width: 4),
                      flutter.Text(
                        "Save PDF",
                        style: flutter.TextStyle(
                          fontSize: 12,
                          fontWeight: flutter.FontWeight.bold,
                          color: flutter.Color(0xFF00838F),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  flutter.Widget _buildLuxuryDetail(String label, String value, {bool isBadge = false}) {
    return flutter.Column(
      crossAxisAlignment: flutter.CrossAxisAlignment.start,
      children: [
        flutter.Text(
          label,
          style: const flutter.TextStyle(
            fontSize: 9,
            fontWeight: flutter.FontWeight.w800,
            color: flutter.Color(0xFF546E7A),
            letterSpacing: 0.5,
          ),
        ),
        const flutter.SizedBox(height: 3),
        isBadge
            ? flutter.Container(
          padding: const flutter.EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: flutter.BoxDecoration(
            color: const flutter.Color(0xFFFFD54F),
            borderRadius: flutter.BorderRadius.circular(4),
          ),
          child: flutter.Text(
            value,
            style: const flutter.TextStyle(fontSize: 11, fontWeight: flutter.FontWeight.w900, color: flutter.Colors.black),
          ),
        )
            : flutter.Text(
          value,
          style: const flutter.TextStyle(
            fontSize: 12,
            fontWeight: flutter.FontWeight.w800,
            color: flutter.Colors.black87,
          ),
        ),
      ],
    );
  }
}

class ContainerEditIcon extends flutter.StatelessWidget {
  const ContainerEditIcon({super.key});

  @override
  flutter.Widget build(flutter.BuildContext context) {
    return flutter.Container(
      padding: const flutter.EdgeInsets.all(3),
      decoration: flutter.BoxDecoration(
        color: const flutter.Color(0xFF00838F).withOpacity(0.1),
        shape: flutter.BoxShape.circle,
      ),
      child: const flutter.Icon(flutter.Icons.edit_rounded, size: 14, color: flutter.Color(0xFF00838F)),
    );
  }
}

class TicketClipper extends flutter.CustomClipper<flutter.Path> {
  @override
  flutter.Path getClip(flutter.Size size) {
    flutter.Path path = flutter.Path();
    double radius = 12.0;
    double cutoutXRatio = 0.66;

    path.lineTo(size.width * cutoutXRatio - radius, 0);
    path.arcToPoint(
      flutter.Offset(size.width * cutoutXRatio + radius, 0),
      radius: flutter.Radius.circular(radius),
      clockwise: false,
    );
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width * cutoutXRatio + radius, size.height);
    path.arcToPoint(
      flutter.Offset(size.width * cutoutXRatio - radius, size.height),
      radius: flutter.Radius.circular(radius),
      clockwise: false,
    );
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(flutter.CustomClipper<flutter.Path> oldClipper) => false;
}

class VerticalDashedLinePainter extends flutter.CustomPainter {
  @override
  void paint(flutter.Canvas canvas, flutter.Size size) {
    double dashHeight = 5, dashSpace = 4, startY = 0;
    final paint = flutter.Paint()
      ..color = const flutter.Color(0xFF00838F).withOpacity(0.3)
      ..strokeWidth = 1.2;

    while (startY < size.height) {
      canvas.drawLine(flutter.Offset(0, startY), flutter.Offset(0, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(flutter.CustomPainter oldDelegate) => false;
}

class HorizontalDashedLinePainter extends flutter.CustomPainter {
  @override
  void paint(flutter.Canvas canvas, flutter.Size size) {
    double dashWidth = 4, dashSpace = 3, startX = 0;
    final paint = flutter.Paint()
      ..color = flutter.Colors.black12
      ..strokeWidth = 1;

    while (startX < size.width) {
      canvas.drawLine(flutter.Offset(startX, 0), flutter.Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(flutter.CustomPainter oldDelegate) => false;
}