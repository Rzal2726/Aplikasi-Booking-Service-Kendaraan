import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:project/app/services/storage_service.dart';

class PdfInvoiceService {
  static final _currencyFormat = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  static String _formatRupiah(num amount) {
    return _currencyFormat.format(amount);
  }

  /// Generates a complete invoice PDF document as bytes
  static Future<Uint8List> generateInvoicePdf({
    required Map<String, dynamic> activity,
    required StorageService storageService,
  }) async {
    final pdf = pw.Document(
      title: 'Invoice_${activity['code'] ?? 'MotoServ'}',
      author: 'MotoServ Application',
    );

    // Extract activity fields with fallbacks
    final bookingCode = (activity['code'] as String?)?.isNotEmpty == true
        ? activity['code'] as String
        : 'MS-${(activity['id'] ?? DateTime.now().millisecondsSinceEpoch).toString().substring(0, 6)}';
    final workshopName = activity['workshop'] as String? ?? 'MotoServ Sukajadi - Bandung';
    final workshopAddress = activity['workshopAddress'] as String? ?? 'Jl. Sukajadi No. 142, Bandung';
    final scheduleDate = activity['scheduleDate'] as String? ?? '-';
    final time = activity['time'] as String? ?? '-';
    final paymentMethod = activity['paymentMethod'] as String? ?? 'Bayar di Bengkel';

    // Users and customer name
    final users = storageService.getUsers();
    final customer = users.isNotEmpty ? users.first : null;
    final customerName = (customer?['name'] as String?) ?? 'Pelanggan MotoServ';
    final customerEmail = (customer?['email'] as String?) ?? 'user@example.com';

    // Services and spare parts catalogue
    final allServices = storageService.getServices();
    final allParts = storageService.getSpareParts();
    final allVehicles = storageService.getVehicles();

    // Raw vehicle activities and pit assignments
    final rawActivities = (activity['activities'] as List?) ?? [];
    final pitAssignments = (activity['pitAssignments'] as List?) ?? [];

    // Calculate itemized list and prices
    double computedSubtotal = 0;
    final vehicleDetails = <Map<String, dynamic>>[];

    for (final act in rawActivities) {
      final actMap = Map<String, dynamic>.from(act as Map);
      final vId = actMap['vehicleID'];

      // Find vehicle info from snapshot or storage
      Map<String, dynamic>? vehicleInfo;
      if (actMap['vehicle'] != null) {
        vehicleInfo = Map<String, dynamic>.from(actMap['vehicle'] as Map);
      } else {
        vehicleInfo = allVehicles.cast<Map<String, dynamic>?>().firstWhere(
              (v) => v?['id']?.toString() == vId?.toString(),
              orElse: () => null,
            );
      }

      // Find pit assignment for this vehicle
      Map<String, dynamic>? pit;
      for (final p in pitAssignments) {
        final pMap = Map<String, dynamic>.from(p as Map);
        if (pMap['vehicleId']?.toString() == vId?.toString()) {
          pit = pMap;
          break;
        }
      }

      // Resolve items (services and spare parts)
      final List serviceIds = (actMap['serviceIds'] as List?) ?? [];
      final items = <Map<String, dynamic>>[];
      double vehicleSubtotal = 0;

      for (final sid in serviceIds) {
        // Try service first
        final svc = allServices.cast<Map<String, dynamic>?>().firstWhere(
              (s) => s?['id'] == sid,
              orElse: () => null,
            );
        if (svc != null) {
          final price = (svc['price'] as num?)?.toDouble() ?? 0;
          items.add({
            'name': svc['name'] ?? 'Layanan Servis',
            'type': 'Servis',
            'price': price,
          });
          vehicleSubtotal += price;
        } else {
          // Try spare part
          final part = allParts.cast<Map<String, dynamic>?>().firstWhere(
                (p) => p?['id'] == sid,
                orElse: () => null,
              );
          if (part != null) {
            final price = (part['price'] as num?)?.toDouble() ?? 0;
            items.add({
              'name': part['name'] ?? part['shortName'] ?? 'Suku Cadang',
              'type': 'Suku Cadang',
              'price': price,
            });
            vehicleSubtotal += price;
          }
        }
      }

      computedSubtotal += vehicleSubtotal;

      vehicleDetails.add({
        'vehicle': vehicleInfo,
        'pit': pit,
        'items': items,
        'subtotal': vehicleSubtotal,
        'notes': actMap['notes'] as String?,
      });
    }

    // Totals
    final savedSubtotal = (activity['subtotal'] as num?)?.toDouble();
    final subtotal = (savedSubtotal != null && savedSubtotal > 0)
        ? savedSubtotal
        : (computedSubtotal > 0 ? computedSubtotal : 150000.0);

    final discount = (activity['discount'] as num?)?.toDouble() ?? 0.0;
    final savedTotal = (activity['totalPrice'] as num?)?.toDouble();
    final totalPrice = (savedTotal != null && savedTotal > 0)
        ? savedTotal
        : ((subtotal - discount) > 0 ? (subtotal - discount) : subtotal);

    String printDate;
    try {
      await initializeDateFormatting('id_ID', null);
      printDate = DateFormat('dd MMM yyyy, HH:mm', 'id_ID').format(DateTime.now());
    } catch (_) {
      final now = DateTime.now();
      printDate =
          '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}, ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    }

    // Color definitions
    const primaryColor = PdfColor.fromInt(0xFFEE5304);
    const darkSlate = PdfColor.fromInt(0xFF0F172A);
    const mutedSlate = PdfColor.fromInt(0xFF64748B);
    const borderColor = PdfColor.fromInt(0xFFE2E8F0);
    const lightBg = PdfColor.fromInt(0xFFF8FAFC);
    const greenColor = PdfColor.fromInt(0xFF16A34A);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(36),
        header: (pw.Context context) {
          return pw.Container(
            padding: const pw.EdgeInsets.only(bottom: 12),
            margin: const pw.EdgeInsets.only(bottom: 16),
            decoration: const pw.BoxDecoration(
              border: pw.Border(
                bottom: pw.BorderSide(color: borderColor, width: 1.5),
              ),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Container(
                      width: 32,
                      height: 32,
                      decoration: pw.BoxDecoration(
                        color: primaryColor,
                        borderRadius: pw.BorderRadius.circular(6),
                      ),
                      child: pw.Center(
                        child: pw.Text(
                          'M',
                          style: pw.TextStyle(
                            color: PdfColors.white,
                            fontSize: 20,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    pw.SizedBox(width: 8),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'MotoServ',
                          style: pw.TextStyle(
                            fontSize: 18,
                            fontWeight: pw.FontWeight.bold,
                            color: darkSlate,
                          ),
                        ),
                        pw.Text(
                          'Perawatan Motor Modern & Terpercaya',
                          style: const pw.TextStyle(
                            fontSize: 8,
                            color: mutedSlate,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Container(
                      padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: pw.BoxDecoration(
                        color: const PdfColor.fromInt(0xFFFFF7ED),
                        borderRadius: pw.BorderRadius.circular(4),
                        border: pw.Border.all(color: const PdfColor.fromInt(0xFFFFEDD5)),
                      ),
                      child: pw.Text(
                        'ESTIMASI INVOICE',
                        style: pw.TextStyle(
                          color: primaryColor,
                          fontSize: 9,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                    pw.SizedBox(height: 3),
                    pw.Text(
                      bookingCode,
                      style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                        color: darkSlate,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
        footer: (pw.Context context) {
          return pw.Container(
            padding: const pw.EdgeInsets.only(top: 10),
            decoration: const pw.BoxDecoration(
              border: pw.Border(
                top: pw.BorderSide(color: borderColor, width: 1),
              ),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  'MotoServ | Dicetak pada $printDate WIB',
                  style: const pw.TextStyle(fontSize: 8, color: mutedSlate),
                ),
                pw.Text(
                  'Halaman ${context.pageNumber} dari ${context.pagesCount}',
                  style: const pw.TextStyle(fontSize: 8, color: mutedSlate),
                ),
              ],
            ),
          );
        },
        build: (pw.Context context) {
          return [
            // ── Information Cards (Customer & Workshop) ──
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Customer & Booking Schedule
                pw.Expanded(
                  child: pw.Container(
                    padding: const pw.EdgeInsets.all(12),
                    decoration: pw.BoxDecoration(
                      color: lightBg,
                      borderRadius: pw.BorderRadius.circular(8),
                      border: pw.Border.all(color: borderColor),
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'INFORMASI PELANGGAN & JADWAL',
                          style: pw.TextStyle(
                            fontSize: 9,
                            fontWeight: pw.FontWeight.bold,
                            color: mutedSlate,
                          ),
                        ),
                        pw.SizedBox(height: 6),
                        _buildLabelValue('Nama', customerName),
                        _buildLabelValue('Kontak', customerEmail),
                        _buildLabelValue('Jadwal Kedatangan', scheduleDate),
                        _buildLabelValue('Jam Kedatangan', time),
                        _buildLabelValue('Metode Bayar', paymentMethod),
                      ],
                    ),
                  ),
                ),
                pw.SizedBox(width: 14),
                // Workshop Info
                pw.Expanded(
                  child: pw.Container(
                    padding: const pw.EdgeInsets.all(12),
                    decoration: pw.BoxDecoration(
                      color: lightBg,
                      borderRadius: pw.BorderRadius.circular(8),
                      border: pw.Border.all(color: borderColor),
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'BENGKEL TUJUAN',
                          style: pw.TextStyle(
                            fontSize: 9,
                            fontWeight: pw.FontWeight.bold,
                            color: mutedSlate,
                          ),
                        ),
                        pw.SizedBox(height: 6),
                        _buildLabelValue('Bengkel', workshopName),
                        _buildLabelValue('Alamat', workshopAddress),
                        _buildLabelValue('Jumlah Unit', '${vehicleDetails.length} Kendaraan'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 16),

            // ── Vehicle & Service Details ──
            pw.Text(
              'RINCIAN PENGERJAAN & SUKU CADANG',
              style: pw.TextStyle(
                fontSize: 11,
                fontWeight: pw.FontWeight.bold,
                color: darkSlate,
              ),
            ),
            pw.SizedBox(height: 8),

            ...vehicleDetails.map((vDetail) {
              final vehicle = vDetail['vehicle'] as Map<String, dynamic>?;
              final pit = vDetail['pit'] as Map<String, dynamic>?;
              final items = (vDetail['items'] as List<Map<String, dynamic>>?) ?? [];
              final vSubtotal = (vDetail['subtotal'] as num?)?.toDouble() ?? 0;
              final notes = vDetail['notes'] as String?;

              final brand = vehicle?['brand'] ?? 'Motor';
              final model = vehicle?['model'] ?? '';
              final plate = vehicle?['number'] ?? vehicle?['plateNumber'] ?? '-';
              final year = vehicle?['year'] != null ? '(${vehicle!['year']})' : '';
              final pitName = pit?['pit'] ?? 'Pit -';
              final mechanicName = pit?['mechanic'] ?? 'Mekanik Servis';

              return pw.Container(
                margin: const pw.EdgeInsets.only(bottom: 12),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: borderColor),
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    // Vehicle Header bar
                    pw.Container(
                      padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: const pw.BoxDecoration(
                        color: lightBg,
                        border: pw.Border(
                          bottom: pw.BorderSide(color: borderColor),
                        ),
                      ),
                      child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Row(
                            children: [
                              pw.Text(
                                '$brand $model $year',
                                style: pw.TextStyle(
                                  fontSize: 10,
                                  fontWeight: pw.FontWeight.bold,
                                  color: darkSlate,
                                ),
                              ),
                              pw.SizedBox(width: 8),
                              pw.Container(
                                padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: pw.BoxDecoration(
                                  color: const PdfColor.fromInt(0xFFDFE3FC),
                                  borderRadius: pw.BorderRadius.circular(4),
                                ),
                                child: pw.Text(
                                  plate,
                                  style: pw.TextStyle(
                                    fontSize: 8,
                                    fontWeight: pw.FontWeight.bold,
                                    color: const PdfColor.fromInt(0xFF374151),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          pw.Text(
                            '$pitName | $mechanicName${vSubtotal > 0 ? " | ${_formatRupiah(vSubtotal)}" : ""}',
                            style: pw.TextStyle(
                              fontSize: 9,
                              fontWeight: pw.FontWeight.bold,
                              color: darkSlate,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Items Table
                    if (items.isNotEmpty)
                      pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        child: pw.Column(
                          children: [
                            pw.Row(
                              children: [
                                pw.Expanded(
                                  flex: 5,
                                  child: pw.Text(
                                    'Layanan / Suku Cadang',
                                    style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold, color: mutedSlate),
                                  ),
                                ),
                                pw.Expanded(
                                  flex: 2,
                                  child: pw.Text(
                                    'Tipe',
                                    style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold, color: mutedSlate),
                                  ),
                                ),
                                pw.Expanded(
                                  flex: 3,
                                  child: pw.Text(
                                    'Biaya',
                                    textAlign: pw.TextAlign.right,
                                    style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold, color: mutedSlate),
                                  ),
                                ),
                              ],
                            ),
                            pw.Divider(color: borderColor, height: 8),
                            ...items.map((item) {
                              return pw.Padding(
                                padding: const pw.EdgeInsets.symmetric(vertical: 3),
                                child: pw.Row(
                                  children: [
                                    pw.Expanded(
                                      flex: 5,
                                      child: pw.Text(
                                        item['name'] as String,
                                        style: const pw.TextStyle(fontSize: 9, color: darkSlate),
                                      ),
                                    ),
                                    pw.Expanded(
                                      flex: 2,
                                      child: pw.Text(
                                        item['type'] as String,
                                        style: const pw.TextStyle(fontSize: 8, color: mutedSlate),
                                      ),
                                    ),
                                    pw.Expanded(
                                      flex: 3,
                                      child: pw.Text(
                                        _formatRupiah(item['price'] as num),
                                        textAlign: pw.TextAlign.right,
                                        style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold, color: darkSlate),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ),
                      )
                    else
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(10),
                        child: pw.Text(
                          'Pemeriksaan dan rekomendasi di bengkel',
                          style: const pw.TextStyle(fontSize: 9, color: mutedSlate),
                        ),
                      ),

                    if (notes != null && notes.isNotEmpty)
                      pw.Container(
                        width: double.infinity,
                        padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: const pw.BoxDecoration(
                          color: lightBg,
                          border: pw.Border(top: pw.BorderSide(color: borderColor)),
                        ),
                        child: pw.Text(
                          'Catatan: $notes',
                          style: const pw.TextStyle(fontSize: 8, color: mutedSlate),
                        ),
                      ),
                  ],
                ),
              );
            }),

            pw.SizedBox(height: 6),

            // ── Financial Summary & QR Verification ──
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // QR Code and Instructions
                pw.Expanded(
                  flex: 5,
                  child: pw.Container(
                    padding: const pw.EdgeInsets.all(10),
                    decoration: pw.BoxDecoration(
                      borderRadius: pw.BorderRadius.circular(8),
                      border: pw.Border.all(color: borderColor),
                      color: lightBg,
                    ),
                    child: pw.Row(
                      children: [
                        pw.BarcodeWidget(
                          barcode: pw.Barcode.qrCode(),
                          data: bookingCode,
                          width: 54,
                          height: 54,
                        ),
                        pw.SizedBox(width: 10),
                        pw.Expanded(
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(
                                'Verifikasi Kedatangan',
                                style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold, color: darkSlate),
                              ),
                              pw.SizedBox(height: 3),
                              pw.Text(
                                'Scan QR ini di meja resepsionis atau beritahukan kode booking kepada petugas.',
                                style: const pw.TextStyle(fontSize: 7.5, color: mutedSlate),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                pw.SizedBox(width: 14),
                // Payment Summary Box
                pw.Expanded(
                  flex: 5,
                  child: pw.Container(
                    padding: const pw.EdgeInsets.all(12),
                    decoration: pw.BoxDecoration(
                      borderRadius: pw.BorderRadius.circular(8),
                      border: pw.Border.all(color: borderColor),
                      color: lightBg,
                    ),
                    child: pw.Column(
                      children: [
                        _buildSummaryRow('Subtotal Biaya', _formatRupiah(subtotal)),
                        if (discount > 0) ...[
                          pw.SizedBox(height: 4),
                          _buildSummaryRow(
                            'Diskon Multi-Motor',
                            '- ${_formatRupiah(discount)}',
                            color: greenColor,
                          ),
                        ],
                        pw.Divider(color: borderColor, height: 10),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text(
                              'Total Estimasi',
                              style: pw.TextStyle(
                                fontSize: 11,
                                fontWeight: pw.FontWeight.bold,
                                color: darkSlate,
                              ),
                            ),
                            pw.Text(
                              _formatRupiah(totalPrice),
                              style: pw.TextStyle(
                                fontSize: 12,
                                fontWeight: pw.FontWeight.bold,
                                color: primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            pw.SizedBox(height: 14),

            // ── Terms & Notes ──
            pw.Container(
              padding: const pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(
                borderRadius: pw.BorderRadius.circular(6),
                color: const PdfColor.fromInt(0xFFF1F5F9),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Catatan & Ketentuan:',
                    style: pw.TextStyle(
                      fontSize: 8,
                      fontWeight: pw.FontWeight.bold,
                      color: darkSlate,
                    ),
                  ),
                  pw.SizedBox(height: 3),
                  pw.Text(
                    '- Harap hadir 10-15 menit sebelum waktu servis yang ditentukan.',
                    style: const pw.TextStyle(fontSize: 7.5, color: mutedSlate),
                  ),
                  pw.Text(
                    '- Biaya ini bersifat estimasi sementara. Biaya final dapat disesuaikan apabila ada penggantian suku cadang tambahan atas persetujuan Anda.',
                    style: const pw.TextStyle(fontSize: 7.5, color: mutedSlate),
                  ),
                  pw.Text(
                    '- Pembayaran dapat dilakukan langsung di kasir bengkel setelah proses servis selesai dan motor siap diambil.',
                    style: const pw.TextStyle(fontSize: 7.5, color: mutedSlate),
                  ),
                ],
              ),
            ),
          ];
        },
      ),
    );

    return pdf.save();
  }

  static pw.Widget _buildLabelValue(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 3),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 90,
            child: pw.Text(
              label,
              style: const pw.TextStyle(fontSize: 8.5, color: PdfColor.fromInt(0xFF64748B)),
            ),
          ),
          pw.Expanded(
            child: pw.Text(
              value,
              style: pw.TextStyle(
                fontSize: 8.5,
                fontWeight: pw.FontWeight.bold,
                color: const PdfColor.fromInt(0xFF0F172A),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildSummaryRow(String label, String value, {PdfColor? color}) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          label,
          style: const pw.TextStyle(fontSize: 9, color: PdfColor.fromInt(0xFF64748B)),
        ),
        pw.Text(
          value,
          style: pw.TextStyle(
            fontSize: 9,
            fontWeight: pw.FontWeight.bold,
            color: color ?? const PdfColor.fromInt(0xFF0F172A),
          ),
        ),
      ],
    );
  }
}
