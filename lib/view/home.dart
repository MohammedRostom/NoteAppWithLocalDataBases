import 'package:databases_with_sqlite/dataBAsesHelper/DataBases%20helper.dart';
import 'package:databases_with_sqlite/view/modle/usermodel.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key});

  @override
  State<Home> createState() => _HomeState();
}

List<User?> userList = [];

int? id;
String? nname, eemail, pphone;
GlobalKey<FormState> formKey = GlobalKey<FormState>();

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    // getDataAll();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: _flotingMtehod(),
        appBar: AppBar(),
        body: FutureBuildergetDataAll());
  }

  _flotingMtehod() {
    return FloatingActionButton(
      onPressed: () {
        return OpenshowAlert();
      },
      child: Text("add"),
    );
  }

  OpenshowAlert() {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              content: Container(
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: nname,
                        onSaved: (value) {
                          nname = value;
                        },
                        decoration:
                            InputDecoration(border: OutlineInputBorder()),
                      ),
                      TextFormField(
                        initialValue: eemail,
                        onSaved: (value) {
                          eemail = value;
                        },
                        decoration:
                            InputDecoration(border: OutlineInputBorder()),
                      ),
                      TextFormField(
                        initialValue: pphone,
                        onSaved: (value) {
                          pphone = value;
                        },
                        decoration:
                            InputDecoration(border: OutlineInputBorder()),
                      ),
                      ElevatedButton(
                          onPressed: () {
                            addUser();
                            formKey.currentState!.reset();

                            nname = '';
                            eemail = '';
                            pphone = '';
                          },
                          child: Text("addnote"))
                    ],
                  ),
                ),
              ),
            ));
  }

  void addUser() async {
    formKey.currentState!.save();
    var databasesHelper = DataBasesHelper.db;

    User Instan = User(name: nname, email: eemail, phone: pphone);

    await databasesHelper.insertDataInUserModel(Instan).then((value) {
      Navigator.pop(context);
    });

    setState(() {});
    print("${Instan.Id}\n");
    print("${Instan.name}\n");
    print("${Instan.email}");
    print("${Instan.phone}");
  }

  FutureBuildergetDataAll() {
    return FutureBuilder(
        future: _getdata(),
        builder: (context, snapshot) {
          return creatListvew(context, snapshot);
        });
  }

  Future<List<User?>> _getdata() async {
    final databasesHelper = DataBasesHelper.db;
    List<User?> users = await databasesHelper.GetDataAll();
    print(users.length);
    userList = users;
    return users;
  }

  creatListvew(BuildContext context, AsyncSnapshot<Object?> snapshot) {
    return ListView.builder(
        itemCount: userList.length,
        itemBuilder: (_, index) => bulidItem(userList[index], index));
  }

  bulidItem(User? userListITem, index) {
    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Text("${userListITem!.name}"),
              Text("${userListITem!.email}"),
              Text("${userListITem!.phone}"),
            ],
          ),
          ElevatedButton(
              onPressed: () {
                onEdit(userListITem, index);
              },
              child: Text("edit")),
          ElevatedButton(
              onPressed: () {
                onDelete(userListITem);
              },
              child: Text("delete")),
        ],
      ),
    );
  }

  void onEdit(User? userListITem, index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: Container(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  initialValue: userListITem?.name,
                  onSaved: (value) {
                    nname = value;
                  },
                  decoration: InputDecoration(border: OutlineInputBorder()),
                ),
                TextFormField(
                  initialValue: userListITem?.email,
                  onSaved: (value) {
                    eemail = value;
                  },
                  decoration: InputDecoration(border: OutlineInputBorder()),
                ),
                TextFormField(
                  initialValue: userListITem?.phone,
                  onSaved: (value) {
                    pphone = value;
                  },
                  decoration: InputDecoration(border: OutlineInputBorder()),
                ),
                ElevatedButton(
                  onPressed: () {
                    updateUser(userListITem);
                    Navigator.pop(context);
                  },
                  child: Text("Update"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onDelete(User? user) async {
    var databasesHelper = DataBasesHelper.db;
    await databasesHelper.DeleteDataOnlyOneRow(user!.Id!);
    setState(() {
      userList.remove(user);
    });
  }

  void updateUser(User? user) async {
    formKey.currentState!.save();
    var databasesHelper = DataBasesHelper.db;

    User updatedUser = User(
      Id: user?.Id,
      name: nname,
      email: eemail,
      phone: pphone,
    );

    await databasesHelper.UpdattDataInUserModel(updatedUser);
    setState(() {});

    formKey.currentState!.reset();
    nname = '';
    eemail = '';
    pphone = '';
  }
}
