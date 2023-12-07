// ignore_for_file: file_names
import 'package:http/http.dart' as http;

Future apiResponse(url) async {
  http.Response response = await http.get(url);
  return response.body;
}
