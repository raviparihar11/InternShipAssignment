import 'package:flutter/material.dart';
import 'package:internetstudio/models/PostModel.dart';
import 'package:internetstudio/screens/Event%20Details.dart';
import 'package:intl/intl.dart';

class SearchBarPage extends StatefulWidget {
  final PostModel postModel;

  SearchBarPage(this.postModel);

  @override
  _SearchBarPageState createState() => _SearchBarPageState();
}

class _SearchBarPageState extends State<SearchBarPage> {
  List<Data> searchResults = [];

  void performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        searchResults.clear();
      });
      return;
    }

    final filteredData = widget.postModel.content?.data
        ?.where((data) =>
    data.title?.toLowerCase().contains(query.toLowerCase()) ?? false)
        .toList();

    if (filteredData != null) {
      setState(() {
        searchResults = filteredData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black,size: 28,), // Change arrow color to black
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text('Search',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 28),),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18.0), // Set border radius
                color: Colors.white, // Add a white background color
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min, // Make the row take the minimum width
                mainAxisAlignment: MainAxisAlignment.center, // Align items in the center horizontally
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset('assets/img_2.png', height: 25, width: 25),
                  ),
                  Flexible(
                    child: TextField(
                      onChanged: performSearch,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Type Event Name',
                        contentPadding: EdgeInsets.symmetric(vertical: 12.0), // Add vertical padding
                      ),
                    ),
                  ),
                ],
              ),
            ),

          ),
          Expanded(
            child: ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                final conference = searchResults[index];
                final dateTimeString = conference.dateTime;
                final dateTime = DateTime.parse(dateTimeString!);
                final formattedDate = DateFormat('E, MMM d, h:mm a').format(dateTime);
                return Card(
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EventDetails(conference: conference),
                        ),
                      );
                    },
                    leading: Image.network(conference.organiserIcon.toString(),errorBuilder: (context, error, stackTrace) {
                      return Image.asset('assets/img_4.png'); // Replace 'assets/alternate_image.png' with the path to your alternate image
                    },),
                    title: Text(
                      formattedDate ?? '',
                      style: TextStyle(fontSize: 12.0, color: Colors.blueAccent),
                    ),
                    subtitle:Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(conference.title ?? '' ,style: TextStyle(fontSize: 20.0,color: Colors.black,fontWeight: FontWeight.w300)),
                      SizedBox(height: 10,),
                      // Text('${conference.venueCity.toString()}•${conference.venueCountry.toString()}',style: TextStyle(color: Colors.black45),),
                    ],
                  )
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

