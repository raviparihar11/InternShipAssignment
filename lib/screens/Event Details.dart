import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:internetstudio/models/PostModel.dart';
import 'package:intl/intl.dart';
class EventDetails extends StatefulWidget {
  final Data conference;

  const EventDetails({Key? key, required this.conference}) : super(key: key);

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  Widget _buildListTile(String leadingImage, String title, String subtitle) {
    return ListTile(
      leading: Image.asset(leadingImage),
      title: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: Colors.black45),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    final dateTimeString = widget.conference.dateTime;
    final dateTime = DateTime.parse(dateTimeString!);
    final formattedDate1 = DateFormat('d MMMM , yyyy').format(dateTime);
    final formattedDate2 = DateFormat('E, h:mm a').format(dateTime);
    return Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                height: 200,
                width: MediaQuery.of(context).size.width,
                  child: Stack(
                    children: [
                      Image.network(widget.conference.bannerImage.toString(),),
                      Container(
                        color: Colors.black.withOpacity(0.2), // Adjust opacity as needed
                      ),
                       Positioned(child: Padding(

                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                                onTap: (){
                                  Navigator.of(context).pop();
                                },
                                child: Icon(Icons.arrow_back_ios_rounded,color: Colors.white,)),
                            Text('Event Details',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24,color: Colors.white),),
                            SizedBox(width: 80,),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset('assets/img_3.png',height: 36,width: 36,),
                            ),
                          ],
                        ),
                      )),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(widget.conference.organiserName.toString(),style: TextStyle(fontSize: 35,fontWeight: FontWeight.bold),),
                ),
                SizedBox(height: 10,),

                ListTile(
                  leading: Image.network(widget.conference.organiserIcon.toString(),errorBuilder: (context, error, stackTrace) {
                    return Image.asset('assets/img_4.png'); // Replace 'assets/alternate_image.png' with the path to your alternate image
                  },),
                  title: Text(widget.conference.organiserName.toString(),style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                  subtitle: Text("Organizer",style: TextStyle(color: Colors.black45),),
                ),
                SizedBox(height: 10,),
                _buildListTile('assets/img_1.png', formattedDate1, formattedDate2),
                SizedBox(height: 10,),
                _buildListTile('assets/img.png', widget.conference.venueName.toString(), '${widget.conference.venueName}, ${widget.conference.venueCountry}'),
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("About Event",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                ),
                SizedBox(height: 5,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(widget.conference.description.toString()),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Material(
                      elevation: 4,
                      borderRadius: BorderRadius.circular(15.0),
                      child: GestureDetector(
                        onTap: (){},
                        child: Container(
                          height: 58,
                          decoration: BoxDecoration(
                            color: Color(0xFF5669FF),
                            borderRadius: BorderRadius.circular(15.0),

                          ),
                          width: MediaQuery.of(context).size.width - 50,

                          child: Row(
                            children: [
                              SizedBox(width: 95,),
                              Text('Book Now',style: TextStyle(color: Colors.white,fontSize: 25),),
                              SizedBox(width: 50,),
                              Image.asset('assets/img_5.png',height: 30,width: 30,),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }
}
