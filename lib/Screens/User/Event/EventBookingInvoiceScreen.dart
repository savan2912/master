import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:gotilo_new/Api/ApiCalls.dart';
import 'package:gotilo_new/Api/Request/User/Event/RequestEventBookingInvoice.dart';
import 'package:gotilo_new/Api/Response/User/Event/ResponseEventBookingInvoice.dart';
import 'package:gotilo_new/Constant/AppPref.dart';
import 'package:gotilo_new/CustomeWidgets/CustomAppbar.dart';
import 'package:gotilo_new/CustomeWidgets/SharedWidgets.dart';
import 'package:gotilo_new/MyApplication/MyApplication.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class EventBookingInvoiceScreen extends StatefulWidget {
  final String? bookingId;
  const EventBookingInvoiceScreen({super.key, this.bookingId});

  @override
  State<EventBookingInvoiceScreen> createState() => _EventBookingInvoiceScreenState();
}

class _EventBookingInvoiceScreenState extends State<EventBookingInvoiceScreen> {
  EventBookingInvoice? eventBookingInvoice;
  bool isLoading = true;
  bool isDownloading = false;

  @override
  void initState() {
    super.initState();
    _callEventBookingInvoice();
  }

  Future<void> _callEventBookingInvoice() async {
    bool internet = await MyApplication.checkInternet();
    if (internet) {
      try {
        ResponseEventBookingInvoice? response = await ApiCalls.callEventBookingInvoice(
          RequestEventBookingInvoice(
            bookingId: widget.bookingId,
            userId: AppPrefs.userId,
          ),
        );
        if (response != null && response.result != null && response.result!.toLowerCase().contains("pass")) {
          eventBookingInvoice = response.data;
        }
      } catch (e) {
        log("Invoice API Error: $e");
      } finally {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      }
    } else {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      SharedWidgets.showTopSnackBar(context, message: "No Internet Connection");
    }
  }

  // Download / Print PDF Generator Function
  Future<void> _downloadPdf() async {
    if (eventBookingInvoice == null) return;

    setState(() {
      isDownloading = true;
    });

    try {
      final pdf = pw.Document();
      final event = eventBookingInvoice?.event;
      final receipt = eventBookingInvoice?.receipt;
      final items = eventBookingInvoice?.items ?? [];
      final totals = eventBookingInvoice?.financialTotals;

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // PDF Header
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text("INVOICE", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, color: PdfColors.teal)),
                        pw.SizedBox(height: 4),
                        pw.Text("Receipt No: ${receipt?.receiptNo ?? 'N/A'}"),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text("Booking Date: ${receipt?.bookingDate ?? ''}"),
                        pw.Text("Time: ${receipt?.bookingTime ?? ''}"),
                      ],
                    ),
                  ],
                ),
                pw.Divider(thickness: 1,),

                // Billed To & Event Details
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Expanded(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text("Billed To:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                          pw.Text(receipt?.userName ?? "N/A"),
                        ],
                      ),
                    ),
                    pw.Expanded(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          pw.Text("Event Details:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                          pw.Text(event?.title ?? "N/A"),
                          pw.Text("${event?.eventDate ?? ''} | ${event?.eventTime ?? ''}"),
                          pw.Text(event?.address ?? '', textAlign: pw.TextAlign.right, style: const pw.TextStyle(fontSize: 9)),
                        ],
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 20),

                // Table Items
                pw.TableHelper.fromTextArray(
                  headers: ["Category", "Slot", "Qty", "Price", "Total"],
                  data: items.map((e) => [
                    e.categoryName ?? "",
                    e.slotName ?? "",
                    "${e.quantity ?? 0}",
                    "Rs. ${e.price ?? 0}",
                    "Rs. ${e.total ?? 0}"
                  ]).toList(),
                  headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
                  headerDecoration: const pw.BoxDecoration(color: PdfColors.teal),
                  cellAlignment: pw.Alignment.centerLeft,
                  cellPadding: const pw.EdgeInsets.all(8),
                ),
                pw.SizedBox(height: 20),

                // Financial Totals
                pw.Align(
                  alignment: pw.Alignment.centerRight,
                  child: pw.Container(
                    width: 200,
                    child: pw.Column(
                      children: [
                        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                          pw.Text("Subtotal:"),
                          pw.Text("Rs. ${totals?.subtotal ?? 0}.00"),
                        ]),
                        pw.SizedBox(height: 4),
                        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                          pw.Text("GST (${totals?.gstRate ?? 0}%):"),
                          pw.Text("Rs. ${totals?.gstAmount ?? 0}.00"),
                        ]),
                        pw.Divider(),
                        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                          pw.Text("Total Amount:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                          pw.Text("Rs. ${totals?.total ?? 0}.00", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.teal)),
                        ]),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      );

      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
        name: 'Invoice_${widget.bookingId ?? "Event"}.pdf',
      );
    } catch (e) {
      log("PDF Download Error: $e");
      SharedWidgets.showTopSnackBar(context, message: "Failed to download invoice");
    } finally {
      if (mounted) {
        setState(() {
          isDownloading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final event = eventBookingInvoice?.event;
    final receipt = eventBookingInvoice?.receipt;
    final items = eventBookingInvoice?.items ?? [];
    final totals = eventBookingInvoice?.financialTotals;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: const CustomAppBar(
        title: "Booking Invoice",
        showAction: false,
        showBackButton: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF00C4CC)))
          : eventBookingInvoice == null
          ? _buildEmptyState()
          : Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              physics: const BouncingScrollPhysics(),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Invoice Title Bar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "INVOICE",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF00C4CC),
                                letterSpacing: 1,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "Receipt No: #${receipt?.receiptNo ?? 'N/A'}",
                              style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDCFCE7),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            "PAID",
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF166534)),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                    const Divider(color: Color(0xFFF1F5F9)),
                    const SizedBox(height: 16),

                    // Customer & Event Info Section
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Billed To", style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8), fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text(receipt?.userName ?? "N/A", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF0F172A))),
                              const SizedBox(height: 4),
                              Text("Date: ${receipt?.bookingDate ?? ''}", style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                              Text("Time: ${receipt?.bookingTime ?? ''}", style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text("Event Info", style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8), fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text(event?.title ?? "N/A", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)), textAlign: TextAlign.right),
                              const SizedBox(height: 4),
                              Text("${event?.eventDate ?? ''} | ${event?.eventTime ?? ''}", style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)), textAlign: TextAlign.right),
                              const SizedBox(height: 2),
                              Text(event?.address ?? '', style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)), textAlign: TextAlign.right, maxLines: 2, overflow: TextOverflow.ellipsis),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Items Table Section
                    const Text("Booking Breakdown", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                    const SizedBox(height: 10),

                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFF1F5F9)),
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: items.length,
                        separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFE2E8F0)),
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(item.categoryName ?? "", style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                                      const SizedBox(height: 2),
                                      Text("Slot: ${item.slotName ?? ''}", style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                                    ],
                                  ),
                                ),
                                Text("${item.quantity ?? 0} x ₹${item.price ?? 0}", style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                                const SizedBox(width: 16),
                                Text("₹${item.total ?? 0}.00", style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Financial Totals Summary Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          _buildPriceRow("Subtotal", "₹${totals?.subtotal ?? 0}.00"),
                          const SizedBox(height: 8),
                          _buildPriceRow("GST (${totals?.gstRate ?? 0}%)", "₹${totals?.gstAmount ?? 0}.00"),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Divider(height: 1, color: Color(0xFFCBD5E1)),
                          ),
                          _buildPriceRow("Total Amount", "₹${totals?.total ?? 0}.00", isTotal: true),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Download Invoice Button Bottom Bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: isDownloading ? null : _downloadPdf,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00C4CC),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: isDownloading
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Icon(Icons.download_rounded, color: Colors.white),
                  label: Text(
                    isDownloading ? "Generating PDF..." : "Download Invoice PDF",
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String amount, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 14 : 12,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: isTotal ? const Color(0xFF0F172A) : const Color(0xFF64748B),
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            fontSize: isTotal ? 16 : 13,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            color: isTotal ? const Color(0xFF00C4CC) : const Color(0xFF334155),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long_outlined, size: 70, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          const Text(
            "Invoice details not found!",
            style: TextStyle(color: Colors.blueGrey, fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}