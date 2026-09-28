import 'package:flutter_test/flutter_test.dart';
import 'package:project/app/services/pdf_invoice_service.dart';
import 'package:project/app/services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('PdfInvoiceService generates valid PDF bytes', () async {
    SharedPreferences.setMockInitialValues({});
    final storageService = StorageService();
    await storageService.init();

    final testActivity = {
      'id': 1740000000000,
      'code': 'MS-740000',
      'workshop': 'MotoServ Sukajadi - Bandung',
      'workshopAddress': 'Jl. Sukajadi No. 142, Bandung',
      'scheduleDate': 'Senin, 28 Sep 2026',
      'time': '09:00 WIB',
      'subtotal': 180000.0,
      'discount': 35000.0,
      'totalPrice': 145000.0,
      'paymentMethod': 'Bayar di Bengkel',
      'activities': [
        {
          'vehicleID': 1,
          'vehicle': {
            'id': 1,
            'brand': 'Honda',
            'model': 'Vario 160',
            'number': 'B 1234 XYZ',
            'year': 2022,
          },
          'serviceIds': [1, 2],
          'notes': 'Cek rem depan',
        },
      ],
      'pitAssignments': [
        {
          'pit': 'Pit 1',
          'vehicleId': 1,
          'mechanic': 'Budi Santoso',
          'time': '09:00 - 10:00',
          'status': 2,
        },
      ],
    };

    final bytes = await PdfInvoiceService.generateInvoicePdf(
      activity: testActivity,
      storageService: storageService,
    );

    expect(bytes, isNotNull);
    expect(bytes.isNotEmpty, isTrue);
    // PDF files start with "%PDF-"
    final header = String.fromCharCodes(bytes.sublist(0, 5));
    expect(header, equals('%PDF-'));
  });
}
