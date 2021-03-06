import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'words.dart';

Future main() async {
  late final HttpServer server;
  try {
    server = await HttpServer.bind(InternetAddress.loopbackIPv4, 4044);
  } catch (e) {
    print("Couldn't bind to port 4044: $e");
    exit(-1);
  }
  print('Listening on http://${server.address.address}:${server.port}/');

  await for (HttpRequest req in server) {
    req.response.headers.contentType = ContentType.json;
    //CORS Header, so the anybody can use this
    req.response.headers.add(
      'Access-Control-Allow-Origin',
      '*',
      preserveHeaderCase: true,
    );
    print(req.method + ' ' + req.requestedUri.toString());
    if (req.method == 'GET') {
      try {
        switch (req.requestedUri.pathSegments.last) {
          case 'words':
            req.response.write(
              jsonEncode({
                'length': words.length,
                'language': 'tr',
                'words': words,
              }),
            );
            break;
          case 'random':
            final word = words[Random().nextInt(words.length)];
            req.response.write(
              jsonEncode({
                'word': word.toLowerCase(),
                'length': word.length,
                'starts_with': word.substring(0, 1),
                'letters':word.split(''),
              }),
            );
            break;
          default:
            req.response.statusCode = HttpStatus.badRequest;
        }
      } catch (e) {
        print('Something went wrong: $e');
        req.response.statusCode = HttpStatus.internalServerError;
      }
    }
    await req.response.close();
  }
}
