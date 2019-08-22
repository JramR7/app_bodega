import 'package:web_socket_channel/io.dart';
import 'package:flutter/material.dart';
import '../helpers/constants.dart';
import '../services/orders_service.dart';
import 'dart:convert';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';
import '../services/fcm_message_service.dart';

class SeeOrdersScreen extends StatefulWidget {
  @override
  _SeeOrdersScreenState createState() => _SeeOrdersScreenState();
}

class _SeeOrdersScreenState extends State<SeeOrdersScreen> {
  FcmMessageService _fcmMessageService = new FcmMessageService();
  final channel =
      IOWebSocketChannel.connect('ws://${Constants.httpUrl}/cable/');
  var _data = [];
  var _orderList = Carousel(images: []);
  double _screenWidth;
  double _screenHeight;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => OrdersService.startConnection(channel, 'RoomImageChannel'));
    _fcmMessageService.firebaseCloudMessaging_Listeners(context);
  }

  // reset screen orientation
  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Scaffold(
          body: Stack(
            children: <Widget>[
              Opacity(
                opacity: 0.95,
                child: RotatedBox(
                  quarterTurns: -5,
                  child: Image.asset(
                    'images/lines.png',
                    colorBlendMode: BlendMode.multiply,
                    color: Colors.white,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              _wsListener(),
            ],
          ),
        ),
      ),
    );
  }

  List _allOrders(orders) {
    List ordersWidgets = new List();
    for (var order in orders) {
      if (order['state'] == 'En proceso') {
        ordersWidgets.add(_singleOrder(order));
      }
    }
    return ordersWidgets;
  }

  StreamBuilder _wsListener() {
    return StreamBuilder(
        stream: channel.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData && jsonDecode(snapshot.data)['type'] != 'ping') {
            return _futureGet();
          }
          return _orderList;
        });
  }

  FutureBuilder _futureGet() {
    return FutureBuilder(
      future: OrdersService.getOrders(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _data = snapshot.data;
          _orderList = Carousel(
            images: _allOrders(snapshot.data),
            dotIncreasedColor: Color.fromRGBO(231, 190, 66, 0.9),
            autoplay: false,
            dotSize: 8.0,
            dotSpacing: 15.0,
            indicatorBgPadding: 5.0,
          );
          return SizedBox(
            height: _screenHeight,
            width: _screenWidth,
            child: _orderList,
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }

        // By default, show a loading spinner.
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _singleOrder(order) {
    // get from order image, id, name and status
    var orderName = order['name'];
    var imageUrl = order['image_url'];
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          color: Color.fromRGBO(231, 190, 66, 0.9),
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Center(
              child: Text(
                orderName,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.all(5.0),
          height: screenHeight - 90,
          width: screenWidth,
          color: Colors.transparent,
          child: PhotoView(
              backgroundDecoration: BoxDecoration(color: Colors.transparent),
              imageProvider: NetworkImage(
                imageUrl,
              )),
        ),
      ],
    );
  }
}
