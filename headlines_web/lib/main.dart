import 'package:flutter/material.dart';
import 'package:news/HedlineDetailScreen.dart';
import 'package:news/utils/news.dart';
import 'package:news/utils/api.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  await Hive.initFlutter();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HEADINGS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Roboto Slab",
        primarySwatch: Colors.blue,
      ),
      home: SafeArea(
          child: MultiProvider(providers: [
        ChangeNotifierProvider(create: (ctx) => GetDataProvider()),
      ], child: MyHomePage())),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);
  // List<news> result = List<news>.empty();
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Box? box;
  @override
  void initState() {
    final dataProvider = Provider.of<GetDataProvider>(context, listen: false);
    dataProvider.getMyData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<GetDataProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "HEADLINES",
            style: TextStyle(fontSize: 29, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          dataProvider.getMyData();
        },
        child: Container(
          color: const Color.fromRGBO(70, 70, 70, 1),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1000),
              child: ListView.builder(
                  itemCount: dataProvider.responseData.length,
                  itemBuilder: (context, index) {
                    news newNews = dataProvider.responseData[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HeadlineDetailScreen(
                                      imageUrl: newNews.url != null
                                              ? newNews.url.toString()
                                              : ""
                                          ,
                                      date: newNews.date != null
                                              ? newNews.date.toString().toString():"",
                                      description:newNews.description != null
                                              ? newNews.description.toString():"",
                                      headline: newNews.headline != null
                                              ? newNews.headline.toString():"",
                                      site: newNews.site != null
                                              ? newNews.site.toString():"",
                                    )));
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.7,

                        // padding: const EdgeInsets.all(12),
                        margin:
                            const EdgeInsets.only(left: 16, right: 16, top: 16),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(
                                newNews.url.toString(),
                              ),
                              onError: (exception, stackTrace) =>
                                  print("No image Found"),
                              fit: BoxFit.fill),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: InfoWidget(newNews),
                      ),
                    );
                  }),
            ),
          ),
        ),
      ),
    );
  }

  Container InfoWidget(news newNews) {
    return Container(
      color: Colors.black45,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            color: Colors.black38,
            margin: const EdgeInsets.only(bottom: 24),
            padding: const EdgeInsets.all(5),
            child: Text(
              newNews.headline.toString(),
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(5),
            color: Colors.black38,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Flexible(
                  child: Text(
                    newNews.site.toString(),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    DateTime.parse(newNews.date.toString()).year.toString() +
                        "-" +
                        DateTime.parse(newNews.date.toString())
                            .month
                            .toString() +
                        "-" +
                        DateTime.parse(newNews.date.toString()).day.toString(),
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
