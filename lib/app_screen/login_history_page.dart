import 'package:flutter/material.dart';
import 'package:flutter_application_1/network/server_request_new.dart';

// import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';

class LoginHistoryPage extends StatefulWidget {
  // Map loginHistory = {};
  // int pageItems;
  // int totalItems;
  // int totalPages;
  LoginHistoryPage({
    Key? key,
  }) : super(key: key);
  var items;
  @override
  State<LoginHistoryPage> createState() => _LoginHistoryPageState();
}

class _LoginHistoryPageState extends State<LoginHistoryPage> {
  bool reachTheBottom = false;
  bool serverResponseValidate = false;

  List lst = [];
  // int pNum = 8;
  int page = 1;
  int size = 8;
  bool requestCountFromServer = true;
  int sizeFromServer = 0;
  final ScrollController scrollController = ScrollController();
  DateTime dateTime = DateTime.now();

  Future<void> _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    fetchDataList();
    setState(() {});
  }

  @override
  void initState() {
    // activeSessionResponseData = await getProfileAPI();
    // print(widget.loginHistory);

    fetchDataList();

    scrollController.addListener(() {
      if (scrollController.offset >=
          scrollController.position.maxScrollExtent) {
        // reachTheBottom = true;
        if (lst.length < sizeFromServer) {
          // reachTheBottom = false;
          print("reach the bottom");

          setState(() {
            page += 1;
            size = 8;
            requestCountFromServer = false;
            // fetchDataList();
            // pNum = pNum + 8;
          });
        }
        if (scrollController.offset <=
            scrollController.position.minScrollExtent) {
          print("reach the top");
        }
      }
    });

    super.initState();
  }

  Widget dateTimeFixer(DateTime? data) {
    if (data != null) {
      var now = data.toLocal();
      String convertedDateTime =
          "Date:${now.year.toString()}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}  Time:${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
      // print(convertedDateTime);
      // String formattedDate = DateFormat('yyyy-MM-dd - kk:mm').format(now);
      return Text(convertedDateTime);
    } else {
      return const Text('');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.red,
        title: const Text('Login History List'),
      ),
      body: Center(
        child: FutureBuilder(
          future: fetchDataList(),
          builder: (context, AsyncSnapshot snapshot) => Stack(
            children: [
              snapshot.hasData && lst.isNotEmpty
                  ? Scrollbar(
                      thickness: 10,
                      child: ListView.builder(
                        // addAutomaticKeepAlives: true,
                        controller: scrollController,
                        itemCount: snapshot.data.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            shape: const Border(
                                left:
                                    BorderSide(color: Colors.grey, width: 10)),
                            elevation: 5,
                            child: ListTile(
                              tileColor: Colors.grey[100],
                              title: const SizedBox(
                                width: 100,
                                child: Text('Logged by:'),
                              ),
                              subtitle: SizedBox(
                                width: 100,
                                child: Text(
                                    '${snapshot.data[index]['client']['info']}'),
                              ),
                              leading: Text('${sizeFromServer - index}'),
                              trailing: SizedBox(
                                width: 150,
                                child: dateTimeFixer(
                                  DateTime.tryParse(
                                      '${snapshot.data[index]['time']}'),
                                ),
                              ),
                              // isThreeLine: true,
                            ),
                          );
                        },
                      ),
                    )
                  : lst.isNotEmpty
                      ? Positioned(
                          bottom: 35,
                          left: MediaQuery.of(context).size.width * 0.45,
                          child: const Align(
                              alignment: Alignment.topCenter,
                              child: CircularProgressIndicator()),
                        )
                      : Positioned(
                          child: RefreshIndicator(
                            onRefresh: _onRefresh,
                            child: Shimmer.fromColors(
                              baseColor: Colors.black26,
                              highlightColor: Colors.black12,
                              child: ListView.builder(
                                itemCount: 8,
                                itemBuilder: (BuildContext context, index) =>
                                    const Padding(
                                  padding: EdgeInsets.all(1),
                                  child: Card(
                                    shape: Border(
                                      left: BorderSide(
                                          color: Colors.grey, width: 10),
                                    ),
                                    elevation: 10,
                                    child: ListTile(
                                      tileColor: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
              snapshot.connectionState == ConnectionState.active ||
                      snapshot.connectionState == ConnectionState.none ||
                      snapshot.connectionState == ConnectionState.waiting ||
                      !snapshot.hasData
                  ? Positioned(
                      bottom: 35,
                      left: MediaQuery.of(context).size.width * 0.45,
                      child: const Align(
                          alignment: Alignment.topCenter,
                          child: CircularProgressIndicator()),
                    )
                  : const SizedBox(
                      width: 0,
                      height: 0,
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List> fetchDataList() async {
    var _response = await getLoginHistory(page, size, requestCountFromServer);
    if (_response.success) {
      serverResponseValidate = true;
      if (requestCountFromServer == true) {
        sizeFromServer = _response.data!.pagination!['total_items'];
        // print(int.parse(_rawData['payload']['pagination']['total_items']));
      }
      if (page <= 1) {
        lst = (_response.data!.list)!;
      } else {
        lst.addAll(_response.data!.list!.toList());
      }
    }
    return lst;
  }

  //   var _rawData = await serverRequest.getLoginHistoryAPI(
  //       page, size, requestCountFromServer);
  //   if (_rawData['success'] == true) {
  //     serverResponseValidate = true;
  //     if (requestCountFromServer == true) {
  //       sizeFromServer = _rawData['payload']['pagination']['total_items'];
  //       // print(int.parse(_rawData['payload']['pagination']['total_items']));
  //     }
  //     if (page <= 1) {
  //       lst = (_rawData['payload']['list']);
  //     } else {
  //       lst.addAll(_rawData['payload']['list']);
  //       // lst = lst.toSet().toList(); //remove duplicate items from list
  //     }

  //     // print(lst.length);
  //     // print(lst);

  //   }
  //   return lst;
  // }
}
