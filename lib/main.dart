import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'Users.dart';
import 'customerview.dart';
import 'database.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Users> newusers = [];

  final Color _color1 = const Color(0xff777777);
  final Color _color2 = const Color(0xFF515151);

  final GlobalKey<AnimatedListState> _listKey = GlobalKey();

  TextEditingController _etSearch = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    refreshList();
    super.initState();
  }

  refreshList() async {
    newusers = await DBProvider.db.getAllUsers();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final double boxImageSize = (MediaQuery.of(context).size.width / 4);
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          elevation: 0,
          title: const Text(
            ' Clients',
            style: TextStyle(
                fontSize: 18,
                color: Colors.black
            ),
          ),
          backgroundColor: Colors.white,
          // create search text field in the app bar
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                      color: Colors.grey[100]!,
                      width: 1.0,
                    )
                ),
              ),
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              height: kToolbarHeight,
              child: TextFormField(
                textAlignVertical: TextAlignVertical.bottom,
                maxLines: 1,
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                onChanged: (textValue) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  fillColor: Colors.grey[100],
                  filled: true,
                  hintText: 'Search ',
                  prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
                  suffixIcon:
                    GestureDetector(
                      onTap: () {

                      },
                      child: Icon(Icons.close, color: Colors.grey[500])),
                  focusedBorder: UnderlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                      borderSide: BorderSide(color: Colors.grey[200]!)),
                  enabledBorder: UnderlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                    borderSide: BorderSide(color: Colors.grey[200]!),
                  ),
                ),
              ),
            ),
          ),
          actions: [
            GestureDetector(
                onTap: () {

                },
                child: Icon(Icons.person)),

          ],
        ),
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.of(context).padding.top + 5,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: FutureBuilder(
                  future: DBProvider.db.getAllUsers(),
                  builder: (context, AsyncSnapshot<List<Users>> snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          itemCount: snapshot.data?.length,
                          itemBuilder: (context, index) {
                            var project = snapshot.data![index];
                            return _buildItem( boxImageSize,index, project);

                              // buildCard(context, project);
                          });
                    }
                    return const CircularProgressIndicator();
                  }),
            ),
          ),
        ],
      ),
    ));
  }

  Widget _buildItem( boxImageSize, index,var snapshot){
    final user = snapshot;
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 6, 12, 0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 2,
        color: Colors.white,
        child: Container(
          margin: const EdgeInsets.all(8),
          child: Column(
            children: [
              GestureDetector(
                onTap: (){

                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                          user.username,
                            style: TextStyle(
                                fontSize: 26,
                                color: _color2,
                              fontWeight: FontWeight.w800
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 5),
                            child: Text( user.email,
                                style: const TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey
                                )),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 5),
                            child:  Text( "₹ ${user.balance}",
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.grey
                                )),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 12),
                child: Row(
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        showDialogBox(context, user.username, user.balance);
                      },
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                        height: 30,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                width: 1, color: Colors.grey[300]!)),
                        child: Icon(Icons.details,
                            color: _color1, size: 20),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: OutlinedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const CustomerView(),
                                  settings: RouteSettings(
                                      arguments: [ user.username,user.balance])),
                            );
                          },
                          style: ButtonStyle(
                              minimumSize: MaterialStateProperty.all(
                                  const Size(0, 30)
                              ),
                              overlayColor: MaterialStateProperty.all(Colors.transparent),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  )
                              ),
                              side: MaterialStateProperty.all(
                                const BorderSide(
                                    color: Colors.blue,
                                    width: 1.0
                                ),
                              )
                          ),
                          child: const Text(
                            'Transfer ',
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 13
                            ),
                            textAlign: TextAlign.center,
                          )
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  Widget buildCard(context, var snapshot) {
    final user = snapshot;
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: const BorderSide(color: Colors.black)
      ),
      color: Colors.grey[100],
      elevation: 0,
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {
          showDialogBox(context, user.username, user.balance);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.username,
                        style: const TextStyle(
                          fontFamily: 'heav',
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        user.email,
                        style: const TextStyle(fontFamily: 'mic', fontSize: 15),
                      )
                    ]),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Text(
                  "₹ ${user.balance}",
                  style: const TextStyle(
                      color: Colors.black45,
                      fontFamily: 'luc',
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }



  showDialogBox(context, username, balance) {
    return showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: Material(
              type: MaterialType.transparency,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                padding: const EdgeInsets.all(20),
                height: 320,
                width: MediaQuery.of(context).size.width * 0.7,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        FlutterLogo(
                          size: 50,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "GoBank",
                          style: TextStyle(fontSize: 30, fontFamily: 'heav'),
                        )
                      ],
                    ),
                    Text(
                      "Name: $username",
                      style: const TextStyle(
                        fontFamily: 'TCM',
                        fontSize: 25,
                      ),
                    ),
                    Text(
                      "Current Balance: ₹$balance",
                      style: const TextStyle(fontFamily: 'TCM', fontSize: 25),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    FlatButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const CustomerView(),
                                settings: RouteSettings(
                                    arguments: [username, balance])),
                          );
                        },
                        child: const Text("Transfer"))
                  ],
                ),
              ),
            ),
          );
        });
  }

}

