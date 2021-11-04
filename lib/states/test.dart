import 'package:flutter/material.dart';
import 'package:flutter2_test_firebase/widgets/show_signout.dart';
import 'package:geolocator/geolocator.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage>
{
  double? lat;
  double? lng;

  double? gps_lat;
  double? gps_lng;


  @override
  void initState()
  {
    // TODO: implement initState
    super.initState();
    findLatLng();
  }

  Future<Null> findLatLng() async
  {
    Position? position = await findPosition();

    setState(() {
      lat = position!.latitude;
      lng = position.longitude;
    });
  }

  Future<Position?> findPosition() async
  {
    Position position;
    try
    {
      position = await Geolocator.getCurrentPosition();
      return position;
    }
    catch(e)
    {
      return null;
    }
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: Text("Buyer"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children:
          [
            Row(
              children:
              [
                Text("Geolocator", style: TextStyle( fontWeight: FontWeight.bold ),),
              ],
            ),
            SizedBox(width: 10, height: 5,),
            Row(
              children:
              [
                Text("Lat : " + lat.toString()),
              ],
            ),
            Row(
              children:
              [
                Text("Lng : " + lng.toString()),
              ],
            ),

            SizedBox(width: 10, height: 15,),

          ],
        ),
      ),
    );
  }

}
