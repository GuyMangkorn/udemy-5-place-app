import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/great_places.dart';
import '../screens/place_detail_screen.dart';
import '../screens/add_place_screen.dart';

class PlacesListScreen extends StatelessWidget {
  const PlacesListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Places'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AddPlaceScreen.routeName);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<GreatPlaces>(context, listen: false)
            .fetchAndSetPlaces(),
        builder: (ctx, snapShot) => snapShot.connectionState ==
                ConnectionState.waiting
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Consumer<GreatPlaces>(
                child: const Center(
                  child: Text('Got no place start adding some!'),
                ),
                builder: (ctx, greatPlace, ch) {
                  return greatPlace.items.isEmpty
                      ? ch!
                      : ListView.builder(
                          itemBuilder: (ctx, index) => ListTile(
                            leading: CircleAvatar(
                              backgroundImage:
                                  FileImage(greatPlace.items[index].image),
                            ),
                            title: Text(
                              greatPlace.items[index].title,
                            ),
                            subtitle: Text(
                              greatPlace.items[index].location.address,
                            ),
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                PlaceDetail.routeName,
                                arguments: {'id': greatPlace.items[index].id},
                              );
                            },
                          ),
                          itemCount: greatPlace.items.length,
                        );
                },
              ),
      ),
    );
  }
}
