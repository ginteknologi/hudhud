class CampaignModel {
  final int id;
  final String title;
  final String description;
  final int targetNominal;
  final int terkumpulNominal;
  final String image;
  final String endDate;

  CampaignModel({
    required this.id,
    required this.title,
    required this.description,
    this.targetNominal = 0,
    this.terkumpulNominal = 0,
    required this.image,
    this.endDate = '',
  });

  factory CampaignModel.fromJson(Map<String, dynamic> json) {
    return CampaignModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? '1') ?? 1,
      title: json['title'] as String? ?? json['judul'] as String? ?? '',
      description: json['description'] as String? ?? json['deskripsi'] as String? ?? '',
      targetNominal: json['target'] is int ? json['target'] as int : int.tryParse(json['target']?.toString() ?? '0') ?? 0,
      terkumpulNominal: json['terkumpul'] is int ? json['terkumpul'] as int : int.tryParse(json['terkumpul']?.toString() ?? '0') ?? 0,
      image: json['image'] as String? ?? json['foto'] as String? ?? '',
      endDate: json['end_date'] as String? ?? '',
    );
  }

  double get progressPercentage {
    if (targetNominal <= 0) return 0.0;
    final ratio = terkumpulNominal / targetNominal;
    return ratio > 1.0 ? 1.0 : ratio;
  }
}

class PaymentMethodModel {
  final String id;
  final String name;
  final String code;
  final String logo;
  final String category; // 'qris', 'va', 'ewallet'

  PaymentMethodModel({
    required this.id,
    required this.name,
    required this.code,
    required this.logo,
    this.category = 'qris',
  });

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return PaymentMethodModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? json['nama'] as String? ?? '',
      code: json['code'] as String? ?? '',
      logo: json['logo'] as String? ?? json['image'] as String? ?? '',
      category: json['category'] as String? ?? 'qris',
    );
  }
}

class InvoiceModel {
  final String invoiceNumber;
  final int nominal;
  final String status; // 'pending', 'paid', 'expired', 'failed'
  final String paymentUrl;
  final String qrCodeUrl;
  final String vaNumber;
  final String expiredAt;

  InvoiceModel({
    required this.invoiceNumber,
    required this.nominal,
    required this.status,
    this.paymentUrl = '',
    this.qrCodeUrl = '',
    this.vaNumber = '',
    this.expiredAt = '',
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    return InvoiceModel(
      invoiceNumber: json['invoice'] as String? ?? json['order_id'] as String? ?? '',
      nominal: json['nominal'] is int ? json['nominal'] as int : int.tryParse(json['nominal']?.toString() ?? '0') ?? 0,
      status: json['status'] as String? ?? 'pending',
      paymentUrl: json['payment_url'] as String? ?? json['snap_url'] as String? ?? '',
      qrCodeUrl: json['qr_code'] as String? ?? '',
      vaNumber: json['va_number'] as String? ?? '',
      expiredAt: json['expired_at'] as String? ?? '',
    );
  }
}
