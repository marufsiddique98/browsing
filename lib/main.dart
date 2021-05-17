import 'package:admob_flutter/admob_flutter.dart';
import 'NewPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'function.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Admob.initialize();
  runApp(MyMaterialApp());
}

class MyMaterialApp extends StatefulWidget {
  @override
  _MyMaterialAppState createState() => _MyMaterialAppState();
}

class _MyMaterialAppState extends State<MyMaterialApp> {
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey();
  AdmobBannerSize bannerSize;
  AdmobInterstitial interstitialAd;

  String linkText;

  @override
  void initState() {
    super.initState();
    bannerSize = AdmobBannerSize.BANNER;
    interstitialAd = AdmobInterstitial(
      adUnitId: getInterstitialAdUnitId(),
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
        if (event == AdmobAdEvent.closed) interstitialAd.load();
        handleEvent(event, args, 'Interstitial');
      },
    );

    interstitialAd.load();
  }

  void handleEvent(
      AdmobAdEvent event, Map<String, dynamic> args, String adType) {
    switch (event) {
      case AdmobAdEvent.loaded:
        showSnackBar('$adType Ad loaded!');
        break;
      case AdmobAdEvent.opened:
        showSnackBar('$adType Ad opened!');
        break;
      case AdmobAdEvent.closed:
        showSnackBar('$adType Ad closed!');
        break;
      case AdmobAdEvent.failedToLoad:
        showSnackBar('$adType failed to load. :(');
        break;
      case AdmobAdEvent.rewarded:
        showDialog(
          context: scaffoldState.currentContext,
          builder: (BuildContext context) {
            return WillPopScope(
              child: AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text('Reward callback fired. Thanks Andrew!'),
                    Text('Type: ${args['type']}'),
                    Text('Amount: ${args['amount']}'),
                  ],
                ),
              ),
              onWillPop: () async {
                scaffoldState.currentState.hideCurrentSnackBar();
                return true;
              },
            );
          },
        );
        break;
      default:
    }
  }

  void showSnackBar(String content) {
    scaffoldState.currentState.showSnackBar(
      SnackBar(
        content: Text(content),
        duration: Duration(milliseconds: 1500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: Builder(
        builder: (BuildContext context) => Scaffold(
          key: scaffoldState,
          appBar: AppBar(
            title: const Text('Browsing'),
          ),
          bottomNavigationBar: Builder(
            builder: (BuildContext context) {
              return Container(
                color: Colors.white,
                child: SafeArea(
                  child: SizedBox(
                    height: 60,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        AdmobBanner(
                          adUnitId: getBannerAdUnitId(),
                          adSize: bannerSize,
                          listener:
                              (AdmobAdEvent event, Map<String, dynamic> args) {
                            handleEvent(event, args, 'Banner');
                          },
                          onBannerCreated:
                              (AdmobBannerController controller) {},
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          body: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: IconButton(
                          icon: FaIcon(FontAwesomeIcons.mobileAlt),
                          onPressed: () async {
                            if (await interstitialAd.isLoaded) {
                              interstitialAd.show();
                            } else {
                              showSnackBar('Your ad is still loading...');
                            }
                          },
                        ),
                      ),
                      Expanded(
                        flex: 7,
                        child: TextField(
                          onChanged: (link) {
                            setState(() {
                              linkText = link;
                            });
                          },
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 0.0,
                              horizontal: 10.0,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(30),
                              ),
                            ),
                            hintText: 'Link',
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: IconButton(
                          icon: FaIcon(FontAwesomeIcons.arrowRight),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NewPage(
                                  link: linkText,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: IconButton(
                          icon: FaIcon(FontAwesomeIcons.google),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    NewPage(link: 'https://google.com'),
                              ),
                            );
                          },
                        ),
                      ),
                      Expanded(
                        child: IconButton(
                          icon: FaIcon(FontAwesomeIcons.facebook),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    NewPage(link: 'https://facebook.com'),
                              ),
                            );
                          },
                        ),
                      ),
                      Expanded(
                        child: IconButton(
                          icon: FaIcon(FontAwesomeIcons.youtube),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    NewPage(link: 'https://youtube.com'),
                              ),
                            );
                          },
                        ),
                      ),
                      Expanded(
                        child: IconButton(
                          icon: FaIcon(FontAwesomeIcons.linkedin),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    NewPage(link: 'https://linkedin.com'),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  AdmobBanner(
                    adUnitId: getBannerAdUnitId(),
                    adSize: bannerSize,
                    listener: (AdmobAdEvent event, Map<String, dynamic> args) {
                      handleEvent(event, args, 'Banner');
                    },
                    onBannerCreated: (AdmobBannerController controller) {},
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: IconButton(
                          icon: FaIcon(FontAwesomeIcons.twitter),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    NewPage(link: 'https://twitter.com'),
                              ),
                            );
                          },
                        ),
                      ),
                      Expanded(
                        child: IconButton(
                          icon: FaIcon(FontAwesomeIcons.instagram),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    NewPage(link: 'https://instagram.com'),
                              ),
                            );
                          },
                        ),
                      ),
                      Expanded(
                        child: IconButton(
                          icon: FaIcon(FontAwesomeIcons.wikipediaW),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    NewPage(link: 'https://wikipedia.com'),
                              ),
                            );
                          },
                        ),
                      ),
                      Expanded(
                        child: IconButton(
                          icon: FaIcon(FontAwesomeIcons.github),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    NewPage(link: 'https://github.com'),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    // .withBottomAdmobBanner(context);
  }

  @override
  void dispose() {
    interstitialAd.dispose();
    super.dispose();
  }
}

// AdmobBanner(
// adUnitId: getBannerAdUnitId(),
// adSize: bannerSize,
// listener: (AdmobAdEvent event,
//     Map<String, dynamic> args) {
// handleEvent(event, args, 'Banner');
// },
// onBannerCreated:
// (AdmobBannerController controller) {},
// ),
