import 'package:flutter/material.dart';
import 'package:photo_talk/Services/merge_provider.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Flutter Learning'),
          centerTitle: true,
          backgroundColor: Colors.green,
        ),
        body: Consumer<MergeProvider>(
          builder: (context, prov, _) {
            return Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  prov.loading
                      ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: Colors.green),
                      SizedBox(width: 15),
                      Text('Processing...',
                          style: TextStyle(color: Colors.black))
                    ],
                  )
                      : Container(),

                  SizedBox(height: 15),
                  Center(
                    child: MaterialButton(
                      onPressed: () async {
                        // await prov.mergeIntoVideo(
                        //   audioPath: ,
                        //   imagesPath: ,
                        // );
                        // if (!prov.loading) _showAlertDialog(context, prov);
                      },
                      child: Text('Merge',
                          style: TextStyle(color: Colors.black)),
                      color: Colors.green,
                      splashColor: Colors.red,
                    ),
                  ),
                  SizedBox(height: 15),
                  Center(
                    child: SfSlider(
                      min: 5,
                      max: 15,
                      stepSize: 5,
                      activeColor: Colors.black,
                      inactiveColor: Colors.blue,
                      value: prov.limit,
                      interval: 5,
                      showTicks: true,
                      showLabels: true,
                      enableTooltip: true,
                      minorTicksPerInterval: 1,
                      onChanged: (dynamic value) {
                        prov.setTimeLimit(value);
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ));
  }
}
