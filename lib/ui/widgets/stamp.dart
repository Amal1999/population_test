// ignore_for_file: must_be_immutable

import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:population_app/settings/config.dart';

import '../../models/stamp.dart';

class StampWidget extends StatefulWidget {
  Stamp stamp;
  bool fav;

  void Function()? onLongPress;
  void Function()? onDelete;

  StampWidget(
      {Key? key,
      required this.stamp,
      this.onLongPress,
      this.onDelete,
      this.fav = false})
      : super(key: key);

  @override
  State<StampWidget> createState() => _StampWidgetState();
}

class _StampWidgetState extends State<StampWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      fav = widget.stamp.fav;
    });
  }

  late bool fav;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      onLongPress: () async {
        if (widget.onLongPress != null) {
          widget.onLongPress!.call();
          if (!widget.fav) {
            setState(() {
              widget.stamp.fav = true;

              fav = true;
            });
          }
        }
      },
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          SvgPicture.asset(
            "assets/images/stamp.svg",
            color: fav ? Colors.yellow.shade700 : Colors.grey,
            width: context.width * .45,
          ),
          Container(
            height: context.width * .45,
            width: context.width * .35,
            color: Colors.grey.shade200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 8.0,
                    left: 8.0,
                    right: 8.0,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),

                        /// URL && iso2 didn't work for some countries
                        child: getImage(),
                      ),
                      Expanded(
                          child: Text(
                        widget.stamp.city,
                        style: const TextStyle(
                          // fontFamily: "AGD",
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ))
                    ],
                  ),
                ),
                SizedBox(
                    width: context.width * .35,
                    child: Column(
                      children: [
                        const Text(
                          "Population",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.stamp.population,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )),
                SizedBox(
                  height: 25,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (fav)
                        InkWell(
                          child: const Icon(
                            Icons.star,
                            color: Colors.orange,
                          ),
                          onTap: () {
                            if (widget.onDelete != null) {
                              widget.onDelete!.call();
                              if (!widget.fav) {
                                setState(() {
                                  widget.stamp.fav = false;

                                  fav = false;
                                });
                              }
                            }
                          },
                        ),
                      Expanded(
                        child: Text(
                          widget.stamp.year,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.end,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  getImage() {
    return Flag.fromString(
      widget.stamp.flag!,
      borderRadius: 50,
      fit: BoxFit.fitHeight,
    );
  }
}
