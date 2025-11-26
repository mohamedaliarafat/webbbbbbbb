// import 'package:customer/data/models/petrol_order_model.dart';

// import 'location_model.dart';

// class ProductOrderModel {
//   final String id;
//   final String orderNumber;
//   final String customerId;
//   final String productId;
//   final int quantity;
//   final LocationModel deliveryLocation;
//   final String customerNotes;
//   final ProductOrderPricing pricing;
//   final ProductOrderPayment payment;
//   final String status;
//   final DateTime createdAt;
//   final DateTime updatedAt;

//   ProductOrderModel({
//     required this.id,
//     required this.orderNumber,
//     required this.customerId,
//     required this.productId,
//     required this.quantity,
//     required this.deliveryLocation,
//     required this.customerNotes,
//     required this.pricing,
//     required this.payment,
//     required this.status,
//     required this.createdAt,
//     required this.updatedAt,
//   });

//   factory ProductOrderModel.fromJson(Map<String, dynamic> json) {
//     return ProductOrderModel(
//       id: json['_id'] ?? '',
//       orderNumber: json['orderNumber'] ?? '',
//       customerId: json['customerId']?.toString() ?? '',
//       productId: json['productId']?.toString() ?? '',
//       quantity: json['quantity'] ?? 1,
//       deliveryLocation: LocationModel.fromJson(json['deliveryLocation'] ?? {}),
//       customerNotes: json['customerNotes'] ?? '',
//       pricing: ProductOrderPricing.fromJson(json['pricing'] ?? {}),
//       payment: ProductOrderPayment.fromJson(json['payment'] ?? {}),
//       status: json['status'] ?? 'pending',
//       createdAt: DateTime.parse(json['createdAt']),
//       updatedAt: DateTime.parse(json['updatedAt']),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'productId': productId,
//       'quantity': quantity,
//       'deliveryLocation': deliveryLocation.toJson(),
//       'customerNotes': customerNotes,
//     };
//   }
// }

// class ProductOrderPricing {
//   final double unitPrice;
//   final double totalPrice;
//   final bool priceVisible;

//   ProductOrderPricing({
//     required this.unitPrice,
//     required this.totalPrice,
//     required this.priceVisible,
//   });

//   factory ProductOrderPricing.fromJson(Map<String, dynamic> json) {
//     return ProductOrderPricing(
//       unitPrice: (json['unitPrice'] ?? 0).toDouble(),
//       totalPrice: (json['totalPrice'] ?? 0).toDouble(),
//       priceVisible: json['priceVisible'] ?? false,
//     );
//   }
// }

// class ProductOrderPayment {
//   final String status;
//   final PaymentProof proof;

//   ProductOrderPayment({
//     required this.status,
//     required this.proof,
//   });

//   factory ProductOrderPayment.fromJson(Map<String, dynamic> json) {
//     return ProductOrderPayment(
//       status: json['status'] ?? 'hidden',
//       proof: PaymentProof.fromJson(json['proof'] ?? {}),
//     );
//   }
// }