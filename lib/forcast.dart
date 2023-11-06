import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart'as http;
import 'package:forecast/constants/constrains.dart' as constant;
import 'package:forecast/forcast.dart';

class ForeCasting extends StatefulWidget {
  const ForeCasting({super.key});

  @override
  State<ForeCasting> createState() => _ForeCastingState();
}

class _ForeCastingState extends State<ForeCasting> {
  String city='';
  String discription='';
  num ?temp ;
  num ?max;
  num ?min;
  num ? humidity ;
  num ?windspeed;
  bool isLoaded=false;
  String day = DateTime.now().toString();
  DateTime now = DateTime. now();
  String formattedDate='';
  String formattedSunRTime='';
  String formattedSunSTime='';
  void initState() {
    super.initState();
    getCurrentLocation();
    formattedDate = DateFormat('EEEE, MMM d, yyyy').format(now);
    int sunraise = 1695775549;
    DateTime sunriseTime = DateTime.fromMillisecondsSinceEpoch(sunraise * 1000);
    int sunset = 1695819019;
    DateTime sunsetTime = DateTime.fromMillisecondsSinceEpoch(sunset * 1000);
    formattedSunRTime = DateFormat('hh:mm a').format(sunriseTime);
    formattedSunSTime= DateFormat('hh:mm a').format(sunsetTime);

  }
  getCurrentLocation()async{
    var position =await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.low,
      forceAndroidLocationManager: true,
    );
    print(position);
    if(position!=null){
      print('lat:${position.latitude},long:${position.longitude}');
      getCurrentCityWeather(position);
    }
    else{
      print("Data Unavailable");
    }

  }
  getCurrentCityWeather(Position pos)async{
    var url='${constant.domain}lat=${pos.latitude}&lon=${pos.longitude}&appid=${constant.apikey}';
    var uri=Uri.parse(url);
    var responce=await http.get(uri);
    if(responce.statusCode==200){
      var data=responce.body;
      var decodedData=jsonDecode(data);
      print(data);
      updateUI(decodedData);
      setState(() {
        isLoaded=true;
      });
    }else{
      print(responce.statusCode);
    }
  }


  updateUI(var decodedData){
    print(decodedData);
    setState(() {
      if(decodedData==null){
        city="Note available";
        temp=0;
        humidity=0;
        discription="Note Available";
        max=0;
        min=0;
        windspeed=0;

      }else{
        temp=decodedData['main']['temp']-273;
        city=decodedData['name'];
        humidity=decodedData['main']['humidity'];
        discription=decodedData['weather'][0]['description'];
        max = (decodedData['main']['temp_max'] - 273).toInt();
        min = (decodedData['main']['temp_min'] - 273).toInt();
        windspeed = decodedData['wind']['speed'];

      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body:
      SingleChildScrollView(
        child: Container(
          width: double.maxFinite,
          decoration:BoxDecoration(
           color: Colors.black
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(city,style: TextStyle(fontSize: 30,color: Colors.white,fontWeight: FontWeight.bold),),
                Text(discription,style: TextStyle(fontSize: 30,color: Colors.white,),),
                Icon(Icons.cloud,color: Colors.white,size: 50,),
                Text("${temp?.toInt()}°C",style: TextStyle(fontSize: 70,color: Colors.white),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("min",style: TextStyle(fontSize: 30,color: Colors.white),),
                    VerticalDivider(
                      color: Colors.white,
                      thickness: 2,
                    ),

                    Text("max",style: TextStyle(fontSize: 30,color: Colors.white),),
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("${min}°C",style: TextStyle(fontSize: 30,color: Colors.white),),
                    SizedBox(width: 30,),
                    Text("${max}°C",style: TextStyle(fontSize: 30,color: Colors.white),),
                  ],
                ),
                Divider(
                  height: 100,
                  color: Colors.white,
                  thickness: 1,
                  indent : 10,
                  endIndent : 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("21°C",style: TextStyle(fontSize: 30,color: Colors.white)),
                    SizedBox(width: 10,),
                    Text("21°C",style: TextStyle(fontSize: 30,color: Colors.white)),
                    SizedBox(width: 10,),
                    Text("21°C",style: TextStyle(fontSize: 30,color: Colors.white)),
                    SizedBox(width: 10,),
                    Text("21°C",style: TextStyle(fontSize: 30,color: Colors.white)),
                    SizedBox(width: 10,),
                    Text("21°C",style: TextStyle(fontSize: 30,color: Colors.white)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.cloudy_snowing,color: Colors.white,size: 50,),
                    SizedBox(width: 10,),
                    Icon(Icons.cloudy_snowing,color: Colors.white,size: 50,),
                    SizedBox(width: 10,),
                    Icon(Icons.sunny,color: Colors.white,size: 50,),
                    SizedBox(width: 10,),
                    Icon(Icons.sunny,color: Colors.white,size: 50,),
                    SizedBox(width: 10,),
                    Icon(Icons.cloud,color: Colors.white,size: 50,),
                  ],
                ),
                Divider(
                  height: 100,
                  color: Colors.white,
                  thickness: 1,
                  indent : 10,
                  endIndent : 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Windspeed",style: TextStyle(fontSize: 20,color: Colors.white)),
                    SizedBox(width: 10,),
                    Text("sunrise",style: TextStyle(fontSize: 20,color: Colors.white)),
                    SizedBox(width: 10,),
                    Text("sunrise",style: TextStyle(fontSize: 20,color: Colors.white)),
                    SizedBox(width: 10,),
                    Text("Humidity",style: TextStyle(fontSize: 20,color: Colors.white)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("${windspeed?.toInt()}",style: TextStyle(fontSize: 20,color: Colors.white)),
                    SizedBox(width: 10,),
                    Text(formattedSunSTime,style: TextStyle(fontSize: 20,color: Colors.white)),
                    SizedBox(width: 10,),
                    Text(formattedSunRTime,style: TextStyle(fontSize: 20,color: Colors.white)),
                    SizedBox(width: 10,),
                    Text("${humidity?.toInt()}",style: TextStyle(fontSize: 20,color: Colors.white)),
                  ],
                ),





              ],
            ),
          ),
        ),
      ),


    );
  }
}