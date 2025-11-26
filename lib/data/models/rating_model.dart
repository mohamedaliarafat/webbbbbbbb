class RatingModel {
  final String id;
  final String userId;
  final String ratingType;
  final String targetId;
  final String targetModel;
  final int rating;
  final RatingSubRatings subRatings;
  final String comment;
  final List<String> tags;
  final List<RatingImage> images;
  final bool isPublic;
  final bool isVerified;
  final int helpfulCount;
  final int reportedCount;
  final bool isFlagged;
  final String adminNotes;
  final DateTime createdAt;
  final DateTime updatedAt;

  RatingModel({
    required this.id,
    required this.userId,
    required this.ratingType,
    required this.targetId,
    required this.targetModel,
    required this.rating,
    required this.subRatings,
    required this.comment,
    required this.tags,
    required this.images,
    required this.isPublic,
    required this.isVerified,
    required this.helpfulCount,
    required this.reportedCount,
    required this.isFlagged,
    required this.adminNotes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      ratingType: json['ratingType'] ?? 'service',
      targetId: json['targetId'] ?? '',
      targetModel: json['targetModel'] ?? 'Order',
      rating: json['rating'] ?? 5,
      subRatings: RatingSubRatings.fromJson(json['subRatings'] ?? {}),
      comment: json['comment'] ?? '',
      tags: List<String>.from(json['tags'] ?? []),
      images: List<RatingImage>.from(
          (json['images'] ?? []).map((x) => RatingImage.fromJson(x))),
      isPublic: json['isPublic'] ?? true,
      isVerified: json['isVerified'] ?? false,
      helpfulCount: json['helpfulCount'] ?? 0,
      reportedCount: json['reportedCount'] ?? 0,
      isFlagged: json['isFlagged'] ?? false,
      adminNotes: json['adminNotes'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ratingType': ratingType,
      'targetId': targetId,
      'targetModel': targetModel,
      'rating': rating,
      'subRatings': subRatings.toJson(),
      'comment': comment,
      'tags': tags,
      'images': images.map((x) => x.toJson()).toList(),
      'isPublic': isPublic,
    };
  }

  // double get averageSubRating {
  //   final subRatings = [
  //     subRatings.punctuality,
  //     subRatings.professionalism,
  //     subRatings.communication,
  //     subRatings.serviceQuality,
  //     subRatings.valueForMoney,
  //   ].where((rating) => rating > 0).toList();
    
  //   if (subRatings.isEmpty) return rating.toDouble();
  //   return subRatings.reduce((a, b) => a + b) / subRatings.length;
  // }
}

class RatingSubRatings {
  final int punctuality;
  final int professionalism;
  final int communication;
  final int serviceQuality;
  final int valueForMoney;

  RatingSubRatings({
    required this.punctuality,
    required this.professionalism,
    required this.communication,
    required this.serviceQuality,
    required this.valueForMoney,
  });

  factory RatingSubRatings.fromJson(Map<String, dynamic> json) {
    return RatingSubRatings(
      punctuality: json['punctuality'] ?? 5,
      professionalism: json['professionalism'] ?? 5,
      communication: json['communication'] ?? 5,
      serviceQuality: json['serviceQuality'] ?? 5,
      valueForMoney: json['valueForMoney'] ?? 5,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'punctuality': punctuality,
      'professionalism': professionalism,
      'communication': communication,
      'serviceQuality': serviceQuality,
      'valueForMoney': valueForMoney,
    };
  }
}

class RatingImage {
  final String url;
  final String caption;

  RatingImage({
    required this.url,
    required this.caption,
  });

  factory RatingImage.fromJson(Map<String, dynamic> json) {
    return RatingImage(
      url: json['url'] ?? '',
      caption: json['caption'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'caption': caption,
    };
  }
}