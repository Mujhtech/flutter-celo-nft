import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';

part 'art_state.dart';

class ArtCubit extends Cubit<ArtState> {
  ArtCubit() : super(const ArtState());

  /// Get greeting from
  Future<void> fetchNewArt() async {
    try {
      emit(FetchArtLoading());

      final http.Response res = await http.Client().post(
          Uri.parse('https://api.openai.com/v1/images/generations'),
          headers: <String, String>{
            'Authorization': 'Bearer ${dotenv.get('OPENAI_API_KEY')}',
            'Content-Type': 'application/json',
          },
          body: jsonEncode(
              '{"prompt": "A colorful abstract painting with geometric shapes", "n": 2, "size": "1024x1024"}'));

      if (!<int>[200, 201, 202].contains(res.statusCode)) {
        throw 'Failed to fetch data';
      }

      // final Uint8List imageData = res.bodyBytes;
      // final String base64Image = base64Encode(imageData);
      // final String imageUrl = 'data:image/jpeg;base64,$base64Image';
      final Map<String, dynamic> data = jsonDecode(res.body);
      final List<dynamic> rawData = data['data'] as List<dynamic>;

      emit(FetchArtSuccess(url: rawData[0]['url']));
    } catch (e) {
      emit(FetchArtFailed(errorCode: '', message: e.toString()));
    }
  }
}
