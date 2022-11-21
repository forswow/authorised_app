import 'package:http/http.dart' as http;

class Data {
  String url = 'https://auth-f4485..firebaseio.com/';

  Future<void> connect() async {
    var request = await http.get(Uri.parse(url));
    if (request.statusCode == 200) {
      var body = request.body;
    }
  }
}
