// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class NftModel {
  String? tokenAddress;
  String? tokenId;
  String? tokenUri;
  String? contractType;
  NormalizedMetadata? normalizedMetadata;
  NftModel({
    this.tokenAddress,
    this.tokenId,
    this.tokenUri,
    this.contractType,
    this.normalizedMetadata,
  });

  NftModel copyWith({
    String? tokenAddress,
    String? tokenId,
    String? tokenUri,
    String? contractType,
    NormalizedMetadata? normalizedMetadata,
  }) {
    return NftModel(
      tokenAddress: tokenAddress ?? this.tokenAddress,
      tokenId: tokenId ?? this.tokenId,
      tokenUri: tokenUri ?? this.tokenUri,
      contractType: contractType ?? this.contractType,
      normalizedMetadata: normalizedMetadata ?? this.normalizedMetadata,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'token_address': tokenAddress,
      'token_id': tokenId,
      'token_uri': tokenUri,
      'contract_type': contractType,
      'normalized_metadata': normalizedMetadata?.toMap(),
    };
  }

  factory NftModel.fromMap(Map<String, dynamic> map) {
    return NftModel(
      tokenAddress:
          map['token_address'] != null ? map['token_address'] as String : null,
      tokenId: map['token_id'] != null ? map['token_id'] as String : null,
      tokenUri: map['token_uri'] != null ? map['token_uri'] as String : null,
      contractType:
          map['contract_type'] != null ? map['contract_type'] as String : null,
      normalizedMetadata: map['normalized_metadata'] != null
          ? NormalizedMetadata.fromMap(
              map['normalized_metadata'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory NftModel.fromJson(String source) =>
      NftModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'NftModel(tokenAddress: $tokenAddress, tokenId: $tokenId, tokenUri: $tokenUri, contractType: $contractType, normalizedMetadata: $normalizedMetadata)';
  }

  @override
  bool operator ==(covariant NftModel other) {
    if (identical(this, other)) return true;

    return other.tokenAddress == tokenAddress &&
        other.tokenId == tokenId &&
        other.tokenUri == tokenUri &&
        other.contractType == contractType &&
        other.normalizedMetadata == normalizedMetadata;
  }

  @override
  int get hashCode {
    return tokenAddress.hashCode ^
        tokenId.hashCode ^
        tokenUri.hashCode ^
        contractType.hashCode ^
        normalizedMetadata.hashCode;
  }
}

/// Check https://docs.moralis.io/web3-data-api/evm/reference/get-wallet-nfts?address=0xd8da6bf26964af9d7eed9e03e53415d37aa96045&chain=eth&format=decimal&token_addresses=[]&media_items=false
/// for the rest of meta data fields
class NormalizedMetadata {
  String? name;
  String? description;
  String? image;
  NormalizedMetadata({
    this.name,
    this.description,
    this.image,
  });

  NormalizedMetadata copyWith({
    String? name,
    String? description,
    String? image,
  }) {
    return NormalizedMetadata(
      name: name ?? this.name,
      description: description ?? this.description,
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'description': description,
      'image': image,
    };
  }

  factory NormalizedMetadata.fromMap(Map<String, dynamic> map) {
    return NormalizedMetadata(
      name: map['name'] != null ? map['name'] as String : null,
      description:
          map['description'] != null ? map['description'] as String : null,
      image: map['image'] != null ? map['image'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory NormalizedMetadata.fromJson(String source) =>
      NormalizedMetadata.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'NormalizedMetadata(name: $name, description: $description, image: $image)';

  @override
  bool operator ==(covariant NormalizedMetadata other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.description == description &&
        other.image == image;
  }

  @override
  int get hashCode => name.hashCode ^ description.hashCode ^ image.hashCode;
}
