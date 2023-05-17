// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class NftModel {
  int? tokenId;
  String? tokenUri;
  NftModel({
    this.tokenId,
    this.tokenUri,
  });

  NftModel copyWith({
    int? tokenId,
    String? tokenUri,
  }) {
    return NftModel(
      tokenId: tokenId ?? this.tokenId,
      tokenUri: tokenUri ?? this.tokenUri,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'tokenId': tokenId,
      'tokenUri': tokenUri,
    };
  }

  factory NftModel.fromMap(Map<String, dynamic> map) {
    return NftModel(
      tokenId: map['tokenId'] != null ? map['tokenId'] as int : null,
      tokenUri: map['tokenUri'] != null ? map['tokenUri'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory NftModel.fromJson(String source) =>
      NftModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'NftModel(tokenId: $tokenId, tokenUri: $tokenUri)';

  @override
  bool operator ==(covariant NftModel other) {
    if (identical(this, other)) return true;

    return other.tokenId == tokenId && other.tokenUri == tokenUri;
  }

  @override
  int get hashCode => tokenId.hashCode ^ tokenUri.hashCode;
}
