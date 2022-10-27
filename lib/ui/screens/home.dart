import 'package:flag/flag_widget.dart';
import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:population_app/models/stamp.dart';
import 'package:population_app/settings/config.dart';
import 'package:population_app/ui/screens/favorites/favorites.dart';
import 'package:population_app/ui/widgets/stamp.dart';
import 'package:population_app/viewmodel/home_viewmodel.dart';
import 'package:provider/provider.dart';

import '../../models/flag.dart' as flagModel;

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ScrollController controller;

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

  List<Stamp> items = [];
  late List<Stamp> allItems;

  List<flagModel.Flag> flags = [];

  String? selectedCountry;
  late HomeViewModel notif;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeViewModel(),
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50))),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            iconSize: 30,
                            splashRadius: 25,
                            color: Colors.black,
                            onPressed: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(
                                      builder: (context) => FavoritesScreen()))
                                  .then((value) {
                                allItems.clear();
                                items.clear();
                                selectedCountry = null ;
                                notif.getStamps();
                              });
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
                    color: Colors.black,
                    thickness: 3,
                  )
                ],
              ),
              Expanded(
                child: Center(
                  child: Consumer<HomeViewModel>(
                    builder: (context, notif, child) {
                      this.notif = notif;
                      if (notif.hasData) {
                        allItems = notif.stamps;
                        flags = notif.flags;
                        items.addAll(allItems.sublist(
                            items.length,
                            (allItems.length > items.length + 10)
                                ? items.length + 10
                                : null));
                      }
                      return Column(
                        children: [
                          Expanded(
                            child: (notif.hasData)
                                ? SingleChildScrollView(
                                    child: SizedBox(
                                      height: 600,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 20.0),
                                        child: LazyLoadScrollView(
                                            onEndOfPage: onEndOfPage,
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              controller: controller,
                                              itemBuilder: (context, index) {
                                                if (index % 2 == 0) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        StampWidget(
                                                            onLongPress:
                                                                () async {
                                                              await notif
                                                                  .addFav(items[
                                                                      index]..fav=true);
                                                            },
                                                            onDelete: () async {
                                                              await notif
                                                                  .deleteFav(
                                                                      items[
                                                                          index]);
                                                            },
                                                            stamp:
                                                                items[index]),
                                                        if (index + 1 <
                                                            items.length)
                                                          StampWidget(
                                                              onLongPress:
                                                                  () async {
                                                                await notif
                                                                    .addFav(items[
                                                                        index +
                                                                            1]..fav = true);
                                                              },
                                                              onDelete:
                                                                  () async {
                                                                await notif
                                                                    .deleteFav(items[
                                                                        index +
                                                                            1]);
                                                              },
                                                              stamp: items[
                                                                  index + 1])
                                                        else
                                                          SizedBox(
                                                              width: context
                                                                      .width *
                                                                  .45)
                                                      ],
                                                    ),
                                                  );
                                                } else {
                                                  return const SizedBox();
                                                }
                                              },
                                              itemCount: items.length,
                                            )),
                                      ),
                                    ),
                                  )
                                : (notif.isLoading)
                                    ? const Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.orange,
                                        ),
                                      )
                                    : const Center(
                                        child: Text(
                                          "No data was found",
                                          style: TextStyle(fontFamily: "AGD"),
                                        ),
                                      ),
                          ),
                          Column(
                            children: [
                              const Divider(
                                color: Colors.black,
                                thickness: 3,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 8, bottom: 10, top: 4),
                                child: InkWell(
                                  onTap: () async {
                                    await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          scrollable: true,
                                          contentPadding: EdgeInsets.zero,
                                          backgroundColor: Colors.transparent,
                                          content: SizedBox(
                                            height: context.height,
                                            child: ListView.builder(
                                              itemBuilder: (context, index) {
                                                return InkWell(
                                                  onTap: () async  {

                                                    selectedCountry =
                                                          flags[index].name;
                                                    await this.notif.filter(selectedCountry!);

                                                    items.clear();
                                                    Navigator.pop(context);

                                                  },
                                                  child: Container(
                                                    height: 55,
                                                    padding:
                                                        const EdgeInsets.all(8),
                                                    margin: const EdgeInsets
                                                        .symmetric(vertical: 8),
                                                    decoration:
                                                        const BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            15)),
                                                            color:
                                                                Colors.white),
                                                    width: context.width * 1.2,
                                                    child: Row(
                                                      children: [
                                                        SizedBox(
                                                            height: 40,
                                                            width: 40,
                                                            child:
                                                                Flag.fromString(
                                                              flags[index]
                                                                      .iso2 ??
                                                                  "",
                                                              fit: BoxFit
                                                                  .fitHeight,
                                                              borderRadius: 80,
                                                              height: 40,
                                                              width: 40,
                                                            )),
                                                        Expanded(
                                                          child: Text(
                                                            flags[index].name,
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                              itemCount: flags.length,
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Image.asset("assets/images/icon.png"),
                                          SizedBox(
                                            width: context.width * .03,
                                          ),
                                          const Text(
                                            'Filter by country',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 17),
                                          ),
                                        ],
                                      ),
                                      if (selectedCountry != null)
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 8),
                                          width: 30,
                                          height: 30,
                                          decoration: const BoxDecoration(
                                              color: Colors.red,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(50))),
                                          child: IconButton(
                                            padding: EdgeInsets.zero,
                                            iconSize: 20,
                                            splashRadius: 17,
                                            onPressed: () {
                                              setState(() {
                                                items.clear();
                                                selectedCountry = null;
                                                notif.getStamps();
                                              });
                                            },
                                            icon: const Icon(
                                              Icons.close,
                                              color: Colors.white,
                                            ),
                                          ),
                                        )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  onEndOfPage() {
    setState(() {});
  }
}
