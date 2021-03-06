import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:postgrad_tracker/Controller/DegreeController.dart';
import 'package:postgrad_tracker/main.dart';
import 'package:http/http.dart' as http;

class MockDegreeController extends Mock implements DegreeController{}
void main() {
  test(
      'populates degree array if the http call completes successfully', () async {
    final client = DegreeController();
    http.Client httpClient=new http.Client();
    await client.getDegrees(httpClient,url: 'https://lamp.ms.wits.ac.za/~s1611821/getDegreeTypes.php');

    expect(degrees.length, greaterThan(0));

  });

}