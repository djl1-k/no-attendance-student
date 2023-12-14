// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final dbr = FirebaseDatabase.instance.ref();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Available Rooms Viewer'),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder(
        stream: dbr.onValue, 
        builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
           if (snapshot.hasData && snapshot.data != null) {

            Map<dynamic, dynamic>? data = snapshot.data!.snapshot.value as Map<dynamic, dynamic>?;

            bool? isRoomAvailable = data?['RoomAvailability'] as bool?;
            int? isRoomRented = data?['RoomRented'] as int?;

            // Check if the room is available and if it has been rented
            if (isRoomAvailable == true && isRoomRented == 0)  {
              // Display the list tile when the room is available
                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: GestureDetector(
                    onTap: (){
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Wanna rent this room?"),
                            content: Text("Please go to the room renting machine and scan your card to rent room."),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(); // Close the dialog
                                },
                                child: Text("OK"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: ListView(
                      children: [Container(
                        decoration: BoxDecoration(
                          color: Colors.blue[300],
                          border: Border.all(
                          color: Colors.grey,
                          width: 1.0, 
                          ),
                          borderRadius: BorderRadius.circular(20)
                        ),
                        
                        child: ListTile(
                          contentPadding: EdgeInsets.all(16.0),
                          title: Text('Room 401'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [Text("Available from 1:00 - 3:30", style: TextStyle(fontSize: 17),)],
                          )
                        ),
                      ),]
                    ),
                  ),
                );
            } else {
              return Center(
                child: Text(
                  'There are no rooms available at this moment.',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold
                  ),
                  )
              );
            }
          } else if (snapshot.hasError) {
            // Handle the error case if necessary
            return Text('Error: ${snapshot.error}');
          } else {
            return CircularProgressIndicator();
          }
        }),
    );
  }
}