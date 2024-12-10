// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widget/list_item_widget.dart';

class LocationSearch extends StatefulWidget {
  List<dynamic> station;
  LocationSearch({
    Key? key,
    required this.station,
  }) : super(key: key);

  @override
  State<LocationSearch> createState() => _LocationSearchState();
}

class _LocationSearchState extends State<LocationSearch> {
  TextEditingController controller = new TextEditingController();
  List<dynamic> _searchResult = [];
  // List<dynamic> fulldata = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ค้นหาศูนย์บริหารจัดการคุณภาพน้ำ'),
        elevation: 0.0,
      ),
      body: Stack(
        children: [
          Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: ExactAssetImage('asset/images/waterbg.jpg'),
          fit: BoxFit.fill,
        ),
      ),),
          Column(
            children: <Widget>[
              Container(
                color:Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    color: Colors.white,
                    child: ListTile(
                      leading: const Icon(Icons.search),
                      title: TextField(
                        controller: controller,
                        decoration: const InputDecoration(
                            hintText: 'ค้นหาศูนย์บำบัดน้ำ',
                            border: InputBorder.none),
                        onChanged: onSearchTextChanged,
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.cancel),
                        onPressed: () {
                          controller.clear();
                          onSearchTextChanged('');
                        },
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: _searchResult.isNotEmpty || controller.text.isNotEmpty
                    ? ListView.builder(
                        itemCount: _searchResult.length,
                        itemBuilder: (context, i) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.pop(context, _searchResult[i]['id']);
                            },
                            child: Card(
                              margin: const EdgeInsets.all(10.0),
                              child: ListTile(
                                // leading: new CircleAvatar(
                                //   backgroundImage: new NetworkImage(
                                //     _searchResult[i].profileUrl,
                                //   ),
                                // ),
                                title: Text(_searchResult[i]['name']),
                              ),
                            ),
                          );
                        },
                      )
                    : ListView.builder(
                        itemCount: widget.station.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.pop(context, widget.station[index]['id']);
                            },
                            child: Card(
                              margin: const EdgeInsets.all(10.0),
                              child: ListTile(
                                title: Text(widget.station[index]['name']),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  onSearchTextChanged(String text) async {


    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    for (var i = 0; i < widget.station.length; i++) {
      if (widget.station[i]['name'].contains(text))
        _searchResult.add(widget.station[i]);
    }

    setState(() {});
  }
}
