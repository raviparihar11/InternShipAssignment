import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:internetstudio/models/PostModel.dart';
import 'package:http/http.dart' as http;
import 'package:internetstudio/screens/Event%20Details.dart';
import 'package:internetstudio/screens/Search.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  late Future<PostModel> postModelFuture;

  @override
  void initState() {
    super.initState();
    postModelFuture = getEventApi();
  }


  Future<PostModel>getEventApi ()async{

    final response = await http.get(Uri.parse('https://sde-007.api.assignment.theinternetfolks.works/v1/event'));
    // var dat = jsonDecode(response.body.toString());
    final jsonMap = json.decode(response.body.toString());
    if(response.statusCode == 200){
          final postModel = PostModel.fromJson(jsonMap);
          return postModel;
    }
    else{
      return PostModel.fromJson(jsonMap);
        // throw Exception('Failed to Load Services');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:  AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          'Events',
          style: TextStyle(color: Colors.black, fontSize: 28.0, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () async{
              final postModel = await postModelFuture;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchBarPage(postModel),
                ),
              );
              // Handle search icon tap here
            },
            icon: Icon(Icons.search_outlined,color: Colors.black,size: 28,),
          ),
          PopupMenuButton(
            icon: Icon(Icons.more_vert,color: Colors.black,size:28), // Three-dot icon
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry>[
                PopupMenuItem(
                  child: Text('Option 1'),
                  // Add an onPressed callback for Option 1
                ),
                PopupMenuItem(
                  child: Text('Option 2'),
                  // Add an onPressed callback for Option 2
                ),
                // Add more PopupMenuItems as needed
              ];
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: FutureBuilder<PostModel>(
                future: getEventApi(),
                builder: (context,snapshot){
                  if (snapshot.connectionState == ConnectionState.waiting){
                    print(snapshot.data);
                    return const Center(child: CircularProgressIndicator(),);
                  }
                  else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData ||
                      snapshot.data!.content == null ||
                      snapshot.data!.content!.data == null) {
                    return Center(child: Text('No data available'));
                  }
                  else{

                    final data = snapshot.data!.content!.data ?? [];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        itemCount: data.length,
                          itemBuilder: (context,index){
                            final conference = data[index];
                            final dateTimeString = conference.dateTime;
                            final dateTime = DateTime.parse(dateTimeString!);
                            final formattedDate = DateFormat('E, MMM d •h:mm a').format(dateTime);
                            // DateTime now = conference.dateTime as DateTime;
                            // String formattedDate = DateFormat('E,MMM d , h:mm a').format(now);
                            return Container(
                                margin: const EdgeInsets.all(10.0), // Adjust margin as needed
                                decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0), // Adjust the border radius as needed
                                boxShadow: [
                                BoxShadow(
                                color: Colors.grey.withOpacity(0.1), // Shadow color
                                spreadRadius: 0.1, // Spread radius
                                blurRadius: 1, // Blur radius
                                offset: Offset(0, 1), // Offset
                            ),
                            ],
                                ),
                              child: Card(

                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: ListTileTheme(
                                  tileColor: Colors.transparent,

                                  child: ListTile(

                                    onTap: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>EventDetails(conference: conference)));
                                    },
                                    // var formatdate = conference.dateTime,
                                    leading: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12.0),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.1), // Shadow color
                                            spreadRadius: 0.1, // Spread radius
                                            blurRadius: 1, // Blur radius
                                            offset: Offset(0, 2), // Offset
                                          ),
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12.0),
                                        child: Image.network(conference.organiserIcon.toString(),errorBuilder: (context, error, stackTrace) {
                                          return Image.asset('assets/img_4.png'); // Replace 'assets/alternate_image.png' with the path to your alternate image
                                        }, ),
                                      ),
                                    ),
                                    title: Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(formattedDate ?? '' , style: TextStyle(fontSize: 12.0,color: Color(0xFF5669FF)),),
                                    ),
                                    subtitle: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(conference.title ?? '' ,style: TextStyle(fontSize: 20.0,color: Colors.black,fontWeight: FontWeight.w300)),
                                        SizedBox(height: 10,),
                                        Row(
                                          children: [
                                            Icon(Icons.location_pin, size: 14,),
                                            Expanded(
                                              child: Text(
                                                '${conference.venueName.toString()}',
                                                style: TextStyle(color: Colors.black45),
                                                overflow: TextOverflow.ellipsis, // Add this line to handle long text
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          '•${conference.venueCity.toString()}•${conference.venueCountry.toString()}',
                                          style: TextStyle(color: Colors.black45),
                                          overflow: TextOverflow.ellipsis, // Add this line to handle long text
                                        ),

                                        // Text('${conference.venueCity.toString()}•${conference.venueCountry.toString()}',style: TextStyle(color: Colors.black45),),
                                      ],
                                    )
                                  ),
                                ),
                              ),
                            );
                          }),
                    );
                  }


                },
              ),
          ),
        ],
      ),
    );
  }
}
