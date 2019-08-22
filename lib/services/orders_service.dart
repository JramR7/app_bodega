import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../helpers/constants.dart';

class OrdersService {
  static Dio dio = new Dio();

  static postOrder(_image, _imageName) async {
    var postUrl = 'http://${Constants.httpUrl}/images';
    FormData formData = new FormData.from({
      "image[image]": new UploadFileInfo(_image, _image.path),
      "image[name]": _imageName,
    });

    await dio.post(postUrl, data: formData).then((response) {
      print(response);
      return response.data['data'];
    }).catchError((err) {
      return err;
    });
  }

  static Future<dynamic> getOrders() async {
    final response = await http.get('http://${Constants.httpUrl}/images');

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      return json.decode(response.body);
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
  }

  static Future<dynamic> updateOrderStatus(orderId, state) async {
    FormData formData = new FormData.from({"image[state]": state});
    var putUrl = 'http://${Constants.httpUrl}/images/$orderId';

    await dio.put(putUrl, data: formData).then((response) {
      print(response);
      return response.data['data'];
    }).catchError((err) {
      return err;
    });
  }

  static Future<dynamic> updateOrderImage(imageFile, order) async {
    var putUrl = 'http://${Constants.httpUrl}/images/${order['id']}';
    FormData formData = new FormData.from({
      "image[image]": new UploadFileInfo(imageFile, imageFile.path),
    });

    await dio.put(putUrl, data: formData).then((response) {
      print(response);
      return response.data['data'];
    }).catchError((err) {
      return err;
    });
  }

  static startConnection(channelCon, channel) {
    var identifier = {'channel': channel};
    var data = {'command': 'subscribe', 'identifier': jsonEncode(identifier)};
    channelCon.sink.add(jsonEncode(data));
  }
}
