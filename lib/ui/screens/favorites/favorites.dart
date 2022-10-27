import 'package:flutter/material.dart';
import 'package:population_app/models/stamp.dart';
import 'package:population_app/settings/config.dart';
import 'package:population_app/ui/widgets/stamp.dart';
import 'package:population_app/viewmodel/favorites_viewmodel.dart';
import 'package:provider/provider.dart';

class FavoritesScreen extends StatefulWidget {
  FavoritesScreen({Key? key}) : super(key: key);

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late ScrollController controller;

  List<Stamp> allItems = [];

  List<Stamp> items = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FavoritesViewModel(),
      child: Scaffold(
          body: SafeArea(
              child: Column(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/', (route) => false);
                      },
                      child: SizedBox(
                        width: context.width * .5,
                        child: const Text(
                          "POPULATION APP",
                          style: TextStyle(
                              fontFamily: "AGD",
                              fontWeight: FontWeight.w900,
                              fontSize: 35),
                        ),
                      ),
                    ),
                    Container(
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        iconSize: 30,
                        splashRadius: 25,
                        color: Colors.black,
                        onPressed: () {
                        },
                        icon: const Icon(
                          Icons.favorite,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const Divider(
                //height: ,
                color: Colors.black,
                thickness: 3,
              )
            ],
          ),
          Expanded(child: Center(child:
              Consumer<FavoritesViewModel>(builder: (context, notif, child) {
                items = notif.favorites;
            if (notif.hasData) {
              return SingleChildScrollView(
                child: SizedBox(
                  height: 600,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      controller: controller,
                      itemBuilder: (context, index) {
                        if (index % 2 == 0) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                              children: [
                                StampWidget(
                                  fav : true,
                                    onDelete: () async {
                                      await notif.deleteFav(items[index]);
                                    },
                                    stamp: items[index]..fav = true),
                                if (index + 1 < items.length)
                                  StampWidget(
                                    fav : true,
                                      onDelete: () async {
                                        await notif
                                            .deleteFav(items[index + 1]);
                                      },
                                      stamp: items[index + 1]..fav = true)
                                else
                                  SizedBox(width: context.width * .45)
                              ],
                            ),
                          );
                        } else {
                          return const SizedBox();
                        }
                      },
                      itemCount: items.length,
                    ),
                  ),
                ),
              );
            } else if (notif.isLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.orange,
                ),
              );
            } else {
              return const Center(
                child: Text(
                  "No data was found",
                  style: TextStyle(fontFamily: "AGD"),
                ),
              );
            }
          })))
        ],
      ))),
    );
  }

  onEndOfPage() {
    setState(() {});
  }
}
