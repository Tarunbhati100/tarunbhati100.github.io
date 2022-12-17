import 'package:flutter/material.dart';

class HeadlineDetailScreen extends StatelessWidget {
  String headline;
  String site;
  String date;
  String description;
  String imageUrl;
  HeadlineDetailScreen(
      {Key? key,
      this.imageUrl = "",
      this.date = "",
      this.description = "",
      this.headline = "",
      this.site = ""})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(imageUrl),
              fit: BoxFit.cover,
              onError: (exception, stackTrace) => print(exception),
            ),
            color: Colors.black,
          ),
          foregroundDecoration: BoxDecoration(color: Colors.black12),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.black38,
                    radius: 21,
                    child: IconButton(
                      iconSize: 42,
                      padding: const EdgeInsets.all(0),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.arrow_back_outlined,
                      ),
                    ),
                  ),
                ),
                Container(
                  color: Colors.black26,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24.0, vertical: 5),
                  child: Column(
                    children: [
                      Text(
                        headline,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 29,
                            fontWeight: FontWeight.w700),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 64, bottom: 16.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                site,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            ),
                            if (date != "")
                              Text(
                                DateTime.parse(date).year.toString() +
                                    "-" +
                                    DateTime.parse(date).month.toString() +
                                    "-" +
                                    DateTime.parse(date).day.toString(),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                          ],
                        ),
                      ),
                      Text(
                        description,
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
