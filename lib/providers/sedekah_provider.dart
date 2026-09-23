import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:masjid_app/core/network/api_endpoints.dart';
import 'package:masjid_app/core/storage/preferences_service.dart';
import 'package:masjid_app/models/sedekah_models.dart';
import 'package:masjid_app/providers/api_providers.dart';

// Transient keys inherited from the GetStorage era. Kept identical so the
// multi-page payment flow keeps working across the migration.
const String kInputPembayaranKey = 'inputDataPembayaran';
const String kDataInvoiceKey = 'dataInvoice';

Map<String, dynamic> readInputPembayaran() {
  final raw = PreferencesService.getString(kInputPembayaranKey);
  if (raw == null || raw.isEmpty) return <String, dynamic>{};
  try {
    final decoded = jsonDecode(raw);
    return decoded is Map<String, dynamic> ? decoded : <String, dynamic>{};
  } catch (e) {
    return <String, dynamic>{};
  }
}

Future<void> writeInputPembayaran(Map<String, dynamic> data) =>
    PreferencesService.setString(kInputPembayaranKey, jsonEncode(data));

String readDataInvoice() => PreferencesService.getString(kDataInvoiceKey) ?? '';

int _asInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

final campaignListProvider = FutureProvider<List<CampaignModel>>((ref) async {
  final apiClient = ref.watch(apiClientProvider);
  try {
    final response = await apiClient.get<List<CampaignModel>>(
      ApiEndpoints.campaign,
      fromJson: (json) {
        if (json is List) {
          return json.map((item) => CampaignModel.fromJson(item as Map<String, dynamic>)).toList();
        }
        return [];
      },
    );
    return response.data ?? [];
  } catch (e) {
    return [];
  }
});

/// Raw `/campaign` payload — the sedekah list UI reads the original keys
/// (`judul`, `deadline`, `dana_kebutuhan`, `total`, `lineprogress`, `persentase`)
/// that [CampaignModel] does not carry.
final campaignRawListProvider = FutureProvider<List<dynamic>>((ref) async {
  final apiClient = ref.watch(apiClientProvider);
  try {
    final response = await apiClient.get<List<dynamic>>(
      ApiEndpoints.campaign,
      fromJson: (json) => json is List ? json : <dynamic>[],
    );
    return response.data ?? [];
  } catch (e) {
    return [];
  }
});

final campaignDetailProvider =
    FutureProvider.family<Map<String, dynamic>, String>((ref, id) async {
  final apiClient = ref.watch(apiClientProvider);
  try {
    final response = await apiClient.get<Map<String, dynamic>>(
      '${ApiEndpoints.campaign}/$id',
      fromJson: (json) =>
          json is Map<String, dynamic> ? json : <String, dynamic>{},
    );
    return response.data ?? <String, dynamic>{};
  } catch (e) {
    return <String, dynamic>{};
  }
});

final paymentMethodsProvider = FutureProvider<List<PaymentMethodModel>>((ref) async {
  final apiClient = ref.watch(apiClientProvider);
  try {
    final response = await apiClient.get<List<PaymentMethodModel>>(
      ApiEndpoints.paymentList,
      fromJson: (json) {
        if (json is List) {
          return json.map((item) => PaymentMethodModel.fromJson(item as Map<String, dynamic>)).toList();
        }
        return [];
      },
    );
    return response.data ?? [];
  } catch (e) {
    return [];
  }
});

/// Raw `/transaksi/list_payment` payload — keyed by `ewallet` / `bank`, each
/// entry holding `_id` and `data` (name, img).
final paymentChannelProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final apiClient = ref.watch(apiClientProvider);
  try {
    final response = await apiClient.get<Map<String, dynamic>>(
      ApiEndpoints.paymentList,
      fromJson: (json) =>
          json is Map<String, dynamic> ? json : <String, dynamic>{},
    );
    return response.data ?? <String, dynamic>{};
  } catch (e) {
    return <String, dynamic>{};
  }
});

final invoiceDetailProvider =
    FutureProvider.family<Map<String, dynamic>, String>((ref, invoice) async {
  final apiClient = ref.watch(apiClientProvider);
  try {
    final response = await apiClient.get<Map<String, dynamic>>(
      '${ApiEndpoints.invoiceDetail}/$invoice',
      fromJson: (json) =>
          json is Map<String, dynamic> ? json : <String, dynamic>{},
    );
    return response.data ?? <String, dynamic>{};
  } catch (e) {
    return <String, dynamic>{};
  }
});

class CreateOrderParams {
  final int campaignId;
  final int nominal;
  final String name;
  final String email;
  final String phone;
  final String pesan;
  final bool isAnonim;
  final String paymentMethod;
  final String metode;

  CreateOrderParams({
    required this.campaignId,
    required this.nominal,
    required this.name,
    required this.email,
    required this.phone,
    required this.pesan,
    this.isAnonim = false,
    required this.paymentMethod,
    this.metode = '',
  });

  Map<String, dynamic> toJson() => {
    'id_campaign': campaignId,
    'nominal': nominal,
    'name': name,
    'email': email,
    'phone': phone,
    'pesan': pesan,
    'anonim': isAnonim,
    'paymentMethod': paymentMethod,
    'metode': metode,
  };
}

class SedekahOrderNotifier extends StateNotifier<AsyncValue<InvoiceModel?>> {
  final Ref ref;

  SedekahOrderNotifier(this.ref) : super(const AsyncValue.data(null));

  Future<InvoiceModel?> createOrder(CreateOrderParams params) async {
    state = const AsyncValue.loading();
    try {
      final apiClient = ref.read(apiClientProvider);
      final response = await apiClient.post<InvoiceModel>(
        ApiEndpoints.order,
        data: params.toJson(),
        fromJson: (json) => InvoiceModel.fromJson(json as Map<String, dynamic>),
      );
      final invoice = response.data;
      state = AsyncValue.data(invoice);
      return invoice;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return null;
    }
  }

  /// Port of the old `postData()` flow: rebuilds the order payload from the
  /// stored [kInputPembayaranKey] map, posts it and stores the resulting
  /// invoice number under [kDataInvoiceKey]. Returns true on success.
  Future<bool> createOrderFromStorage() async {
    final input = readInputPembayaran();
    final invoice = await createOrder(
      CreateOrderParams(
        campaignId: _asInt(input['id_campaign']),
        nominal: _asInt(input['nominal']),
        name: input['nama']?.toString() ?? '',
        email: input['email']?.toString() ?? '',
        phone: input['nomor']?.toString() ?? '',
        pesan: input['pesan']?.toString() ?? '',
        isAnonim: input['anonim'] == true,
        paymentMethod: input['idPayment']?.toString() ?? '',
        metode: input['metode']?.toString() ?? '',
      ),
    );
    if (invoice == null || invoice.invoiceNumber.isEmpty) return false;
    await PreferencesService.setString(kDataInvoiceKey, invoice.invoiceNumber);
    return true;
  }
}

final sedekahOrderProvider =
    StateNotifierProvider.autoDispose<SedekahOrderNotifier, AsyncValue<InvoiceModel?>>((ref) {
  return SedekahOrderNotifier(ref);
});
