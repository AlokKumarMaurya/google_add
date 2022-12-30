import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_youtube_view/flutter_youtube_view.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:inshorts/models/latestNewsModel.dart';
import 'package:inshorts/screens/HomeScreen/video_screen.dart';
import 'package:inshorts/screens/HomeScreen/view_news.dart';
import '../../Apis/apiClient.dart';
import '../../models/categoyModel.dart';
import '../../utils/HelperFunctions.dart';
import 'more_setting.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Discover extends StatefulWidget {
  const Discover({Key? key}) : super(key: key);

  @override
  State<Discover> createState() => _DiscoverState();
}

class _DiscoverState extends State<Discover> {
  List<NewsInfo> trendingList = [];
  List<NewsInfo> mostReadList = [];
  List<NewsInfo> newsList = [];
  List<NewsInfo> videoList = [];
  List<CategoryInfo> categoryList = [];
  LatestNewsModel? modal;
  LatestNewsModel? mostReadModel;
  LatestNewsModel? newsModel;
  CategoryModel? ctegory;
  bool loading = false;
  bool loader = false;
  bool categoryLoader = false;
  String catName = "";
  String slugNAme = "";

  BannerAd? bannerAd;
  bool isLoaded=false;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    bannerAd=BannerAd(size: AdSize.banner,

                            //test id
        adUnitId: "ca-app-pub-3940256099942544/6300978111",

           
                            //mine alok
        // adUnitId: "ca-app-pub-5951042120036435/4393143791",


        listener: BannerAdListener(
        onAdLoaded:(val){
          debugPrint("add loaded ");
          setState(() {
            isLoaded=true;
          });
        }                           ,
        onAdFailedToLoad: (val,ee){debugPrint("failed to load error");
        debugPrint(ee.toString());
        }
    ), request: AdRequest()) ;
    bannerAd!.load();
  }
  
  
  
  
  
  getTrendNews() async {
    var id = await HelperFunctions.getDeviceId();
    print("sdfndjfkf " + id.toString());
    var res1 = await Provider().getTrendingNews(id.toString());
    setState(() {
      modal = res1;
      trendingList = modal!.newsInfo;
    });
    return trendingList;
  }

  getMostRead() async {
    var id = await HelperFunctions.getDeviceId();
    var res1 = await Provider().mostRead(id.toString());
    setState(() {
      mostReadModel = res1;
      mostReadList = mostReadModel!.newsInfo;
    });
    return mostReadList;
  }

  getCategory() async {
    var res1 = await Provider().getCategories();
    setState(() {
      ctegory = res1;
      categoryLoader = true;
      slugNAme = ctegory!.categoryInfo[0].slug;
      catName = ctegory!.categoryInfo[0].menuLavel;
      print("slugNAme:" + slugNAme.toString());
      getCategoriesNews();
    });
    return categoryList;
  }

  getCategoriesNews() async {
    var res1 = await Provider().getNewsByCategory(slugNAme);
    if (!mounted) return;
    setState(() {
      newsModel = res1;
      loader = true;
      newsList = newsModel!.newsInfo;
    });
    return newsList;
  }

  getVideo() async {
    var res1 = await Provider().getVideos();
    setState(() {
      newsModel = res1;
      loader = true;
      videoList = newsModel!.newsInfo;
      print("sddsfgdg " + newsModel.toString());
      print("sddsfgdg " + videoList.toString());
    });
    return videoList;
  }

  @override
  void initState() {
    getTrendNews();
    getMostRead();
    getCategory();
    getVideo();
    getCategoriesNews();
    super.initState();
  }

  @override
  void dispose() {
    getCategoriesNews();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.4,
        leading: IconButton(
          icon: const Icon(Icons.settings, color: Colors.black54),
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => Setting())),
        ),
        title: Column(
          children: [
            Text(
              "Discover",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  color: Colors.black54),
            ),
            Divider(
              thickness: 2,
              color: Colors.blue,
              indent: 60,
              endIndent: 60,
            )
          ],
        ),
        backgroundColor: Colors.white,
        actions: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Row(
                children: [
                  Text(
                    "All News",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black54),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 17,
                    color: Colors.blue,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            SizedBox(
              height: 15,
            ),

            Container(height: 100,color: Colors.black,),
             Container(
               height: 200,
               child: AdWidget(
                 ad: bannerAd!,
               ),
             ),

            /*  Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
              child: Container(
                width: width,
                height: 45,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.grey.shade100),
                child: TextFormField(
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Search for news',
                  ),
                  validator: (v) {
                    return null;
                  },
                ),
              ),
            ),*/
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border:
                        Border.all(color: Colors.grey.shade100, width: 1.5)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 5, top: 10),
                      child: Text(
                        "News by Categories",
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CategoryWidget(),
                    SizedBox(
                      height: 6,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Text(catName.toString(),
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black)),
                    ),
                    categoryNews(),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Notifications",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                  // Text(
                  //   "VIEW ALL",
                  //   style: TextStyle(
                  //       fontSize: 12,
                  //       fontWeight: FontWeight.w600,
                  //       color: Colors.blue),
                  // ),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),

            notificationWidget(),
            videosWidget(),
            SizedBox(
              height: 10,
            ),
            Divider(),
            SizedBox(
              height: 25,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Insights",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                  // Text(
                  //   "VIEW ALL",
                  //   style: TextStyle(
                  //       fontSize: 12,
                  //       fontWeight: FontWeight.w600,
                  //       color: Colors.blue),
                  // ),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            insigntWidget(),
            SizedBox(
              height: 25,
            ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 5.0),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Text(
            //         "Topics",
            //         style: TextStyle(
            //             fontSize: 16,
            //             fontWeight: FontWeight.w500,
            //             color: Colors.black),
            //       ),
            //       Text(
            //         "VIEW ALL",
            //         style: TextStyle(
            //             fontSize: 12,
            //             fontWeight: FontWeight.w600,
            //             color: Colors.blue),
            //       ),
            //     ],
            //   ),
            // ),
            // SizedBox(
            //   height: 5,
            // ),
            // topicWidget(),
            // SizedBox(
            //   height: 25,
            // ),
          ],
        ),
      ),
    );
  }

  Widget CategoryWidget() {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return categoryLoader
        ? Container(
            height: 120,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: ctegory!.categoryInfo.isNotEmpty
                  ? ctegory!.categoryInfo.length
                  : 0,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        slugNAme = ctegory!.categoryInfo[index].slug;
                        catName = ctegory!.categoryInfo[index].menuLavel;
                        print(slugNAme);
                        getCategoriesNews();
                      });
                    },
                    child: Column(
                      children: [
                        ctegory!.categoryInfo[index].categoryImgae != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(5.0),
                                child: Image.network(
                                  "https://primetvindia.com/" +
                                      "${ctegory!.categoryInfo[index].categoryImgae}",
                                  fit: BoxFit.cover,
                                  width: width / 2,
                                  height: 80,
                                  errorBuilder: (BuildContext context,
                                      Object exception,
                                      StackTrace? stackTrace) {
                                    return Image.asset(
                                      "assets/default_image.png",
                                      fit: BoxFit.cover,
                                      height: 80,
                                      width: width / 2,
                                    );
                                  },
                                ),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(5.0),
                                child: Image.asset(
                                  "assets/rnd_logo.png",
                                  height: 80.0,
                                  width: width / 2,
                                  fit: BoxFit.cover,
                                ),
                              ),
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                            alignment: Alignment.center,
                            child: Text(
                              ctegory!.categoryInfo[index].menuLavel,
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87),
                            ))
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        : Center(child: CircularProgressIndicator());
  }

  Widget categoryNews() {
    print("2332323232322323323232");
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Container(
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        physics: NeverScrollableScrollPhysics(),
        itemCount: newsList == null ? 0 : newsList.length,
        itemBuilder: (context, index) {
          print("SVBavshVSsdhSVBasSsab ${newsList.length}");
          return InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ViewAllNews(
                            index: index,
                            newsList: newsList,
                          )));
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: ListTile(
                title: Text(
                  newsList[index].title,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.black54),
                ),
                leading: newsList[index].imageThumb != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(5.0),
                        child: Image.network(
                          newsList[index].imageThumb,
                          fit: BoxFit.cover,
                          width: 110.0,
                          height: 110.0,
                          errorBuilder: (BuildContext context, Object exception,
                              StackTrace? stackTrace) {
                            return Image.asset("assets/default_image.png",
                                fit: BoxFit.cover);
                          },
                        )
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(5.0),
                        child: Image.asset(
                          "assets/rnd_logo.png",
                          width: 110.0,
                          height: 110.0,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget notificationWidget() {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Container(
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        physics: NeverScrollableScrollPhysics(),
        itemCount: trendingList == null ? 0 : trendingList.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ViewAllNews(
                            index: index,
                            newsList: trendingList,
                          )));
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 5),
              child: ListTile(
                title: Text(
                  trendingList[index].title,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.black54),
                ),
                trailing: trendingList[index].imageThumb != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(5.0),
                        child: Image.network(
                          trendingList[index].imageThumb,
                          width: 110.0,
                          height: 110.0,
                          fit: BoxFit.fill,
                          errorBuilder: (BuildContext context, Object exception,
                              StackTrace? stackTrace) {
                            return Image.asset(
                              "assets/default_image.png",
                              width: 110.0,
                              height: 110.0,
                              fit: BoxFit.fill,
                            );
                          },
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(5.0),
                        child: Image.asset(
                          "assets/rnd_logo.png",
                          width: 110.0,
                          height: 110.0,
                          fit: BoxFit.fill,
                        ),
                      ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget videosWidget() {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    print(" videoList.length" + videoList.length.toString());
    return videoList.isNotEmpty
        ? Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 5),
                child: Text(
                  "Videos",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 170,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: videoList == null ? 0 : videoList.length,
                  itemBuilder: (context, index) {
                    // final list = newsList[index];
                    return Card(
                        elevation: 2,
                        child: Container(
                          width: width / 2.3,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    height: 110,
                                    width: width,
                                    color: Colors.black,
                                    child: videoList[index].video != ""
                                        ? FlutterYoutubeView(
                                            scaleMode: YoutubeScaleMode.none,
                                            // <option> fitWidth, fitHeight
                                            params: YoutubeParam(
                                                videoId: videoList[index]
                                                    .video
                                                    .split("=")
                                                    .last,
                                                showUI: false, // <option>
                                                autoPlay: false))
                                        : Center(
                                            child: Text(
                                            "This video is unavailable !",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12),
                                          )),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => NewsVideo(
                                                      title: videoList[index]
                                                          .title,
                                                      dataList: videoList,
                                                      index: index,
                                                    )));
                                      });
                                    },
                                    child: Container(
                                      height: 110,
                                      width: width,
                                      color: Colors.transparent,
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  videoList[index].title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      color: Colors.black54),
                                ),
                              ),
                            ],
                          ),
                        ));
                  },
                ),
              ),
            ],
          )
        : Container();
  }

  Widget insigntWidget() {
    // this is link which will give u thumnail image of that video
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Container(
      height: 250,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        //if file/folder list is grabbed, then show here
        itemCount: mostReadList == null ? 0 : mostReadList.length,
        itemBuilder: (context, index) {
          // final String video_link =""+ mostReadList[index].getVideo().replace("https://www.youtube.com/watch?v=","");
          //
          // String img_url="http://img.youtube.com/vi/"+video_link.replace("?t=6","")+"/0.jpg";
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ViewAllNews(
                              index: index,
                              newsList: mostReadList,
                            )));
              },
              child: Container(
                width: width / 3,
                child: Column(
                  children: [
                    mostReadList[index].imageThumb != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(5.0),
                            child: Image.network(
                              mostReadList[index].imageThumb,
                              height: 140.0,
                              width: width / 3,
                              fit: BoxFit.cover,
                              errorBuilder: (BuildContext context,
                                  Object exception, StackTrace? stackTrace) {
                                return Image.asset(
                                  "assets/default_image.png",
                                  fit: BoxFit.cover,
                                  height: 140.0,
                                  width: width / 3,
                                );
                              },
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(5.0),
                            child: Image.asset(
                              "assets/rnd_logo.png",
                              height: 140.0,
                              width: width / 3,
                              fit: BoxFit.cover,
                            ),
                          ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      mostReadList[index].title,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 4,
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget topicWidget() {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Container(
      height: 150,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        //if file/folder list is grabbed, then show here
        itemCount: 5,
        itemBuilder: (context, index) {
          return Container(
            width: width / 3.7,
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(width: 0.2, color: Colors.grey)),
                ),
                SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Technology",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
