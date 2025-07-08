import 'package:hadirin_app/model/batch_response.dart';
import 'package:hadirin_app/model/training_respons.dart';
import 'package:hadirin_app/utils/endpoint.dart';
import 'package:http/http.dart' as http;

class TrainingApi {
  static Future<ListPelatihan> getTraining() async {
    final response = await http.get(
      Uri.parse(Endpoint.training),
      headers: {"Accept": "application/json"},
    );
    if (response.statusCode == 200) {
      return listPelatihanFromJson(response.body);
    } else {
      throw Exception("Gagal Mengambil data pelatihan ${response.statusCode}");
    }
  }

  static Future<ListBatch> getBatch() async {
    final response = await http.get(
      Uri.parse(Endpoint.batch),
      headers: {"Accept": "application/json"},
    );
    if (response.statusCode == 200) {
      return listBatchFromJson(response.body);
    } else {
      throw Exception("Gagal Mengambil data pelatihan ${response.statusCode}");
    }
  }
}
