import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitr/models/Message.dart';
import 'package:fitr/models/MySharedPrefrences.dart';
import 'package:fitr/models/User.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sqflite/sqflite.dart';
//import 'package:fluttertoast/fluttertoast.dart';

import '/shared/cubit/states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  // await MySharedPreferences.init();

  bool create = MySharedPreferences.getCreate();

  static AppCubit getObject(BuildContext context) => BlocProvider.of(context);

  /// auth logic
  String typeUser = 'as';

  ///

  int nbPersonneTotal = 1;
  int nbPersonneCurrent = 0;
  var name = TextEditingController();

  Map<String, int> nbSinf = {
    'couscous': 0,
    'smid': 0,
    'farine': 0,
    'kam7': 0,
    '3des': 0,
    'loubya': 0,
    '7missa': 0,
    'riz': 0,
    'jalbana': 0,
    'm7amsa': 0,
    'tamr': 0,
    'zbib': 0
  };

  Map<String, double> priceKgSinf = {
    'couscous': 0.0,
    'smid': 0.0,
    'farine': 0.0,
    'kam7': 0.0,
    '3des': 0.0,
    'loubya': 0.0,
    '7missa': 0.0,
    'riz': 0.0,
    'jalbana': 0.0,
    'm7amsa': 0.0,
    'tamr': 0.0,
    'zbib': 0.0
  };

  Map<String, double> stockSinf = {
    'couscous': 0.0,
    'smid': 0.0,
    'farine': 0.0,
    'kam7': 0.0,
    '3des': 0.0,
    'loubya': 0.0,
    '7missa': 0.0,
    'riz': 0.0,
    'jalbana': 0.0,
    'm7amsa': 0.0,
    'tamr': 0.0,
    'zbib': 0.0
  };

  Map<String, int> allowedSinf = {
    'couscous': 20,
    'smid': 20,
    'farine': 20,
    'kam7': 20,
    '3des': 20,
    'loubya': 20,
    '7missa': 20,
    'riz': 20,
    'jalbana': 20,
    'm7amsa': 20,
    'tamr': 20,
    'zbib': 20
  };

  void addPersonne() {
    nbPersonneTotal++;
    emit(AddPersonneState());
  }

  void subPersonne() {
    if (nbPersonneTotal > 1) nbPersonneTotal--;
    emit(SubPersonneState());
  }

  void incrementSinf(String idSinf) {
    /* Map<dynamic, dynamic> currentSinf = sinf.firstWhere(
        (element) => (element['idSinf'] as String).compareTo(idSinf) == 0);
    double stock = currentSinf['stock'];
    double weight = currentSinf['weight'];
    int allowedNbPersonne = (stock / weight).round(); */

    if (nbPersonneCurrent < nbPersonneTotal) {
      if (allowedSinf[idSinf] != 0) {
        nbSinf[idSinf] = nbSinf[idSinf]! + 1;
        allowedSinf[idSinf] = allowedSinf[idSinf]! - 1;

        nbPersonneCurrent++;
      }
      /* bool isAllowed =
          allowedSinf['$idSinf']! - nbSinf['$idSinf']! >= 0 ? true : false;
      if (isAllowed) */
      /* else {
        print("your Stock is empty");
        Fluttertoast.showToast(
          msg: "نفد المخزون",
          fontSize: 20,
          backgroundColor: Colors.red,
        );
      }*/
    }
    //print("${currentSinf['stock']}");
    //print("allowed=${allowedNbPersonne - nbPersonneCurrent}");
    emit(IncrementSinf());
  }

  void decrementSinf(String idSinf) {
    if (nbSinf[idSinf]! > 0) {
      nbSinf[idSinf] = nbSinf[idSinf]! - 1;
      allowedSinf[idSinf] = allowedSinf[idSinf]! + 1;
      nbPersonneCurrent--;
    }
    emit(IncrementSinf());
  }

  void clearData() {
    nbPersonneTotal = 1;
    nbPersonneCurrent = 0;
    name.clear();
    nbSinf.updateAll((key, value) => value = 0);
    emit(ClearDataState());
  }

  bool parseStringToBool(String txt) {
    return txt == 'true' ? true : false;
  }

  ///

  List<String> allAsnafNameList = [
    'كسكس',
    'سميد',
    'فرينة',
    'قمح',
    'عدس',
    'لوبيا',
    'حمُّص',
    'أرز',
    'جلبانة مكسرة',
    'محمصة',
    'تمر',
    'زبيب',
  ];

  ///

  Database? myDb;

  List<Map<dynamic, dynamic>> client = [];
  List<Map<dynamic, dynamic>> sinf = [];
  List<Map<dynamic, dynamic>> ikhraj = [];
  List<bool> asnafDisponible = [];

  //int idCurrentClient;

  Future<void> createDatabase() async {
    openDatabase(
      'fitr.db',
      version: 1,
      onCreate: (db, version) async {
        print('Database created');
        db
            .execute('''create table sinf(
                 idSinf text Primary key,
                 nameSinf text,
                 weight real, 
                 prixKg real,
                 disponibilite text,
                 imageUrl text ,
                 weightTotal real,
                 stock real
                    )''')
            .then((value) => print('Sinf Table created'))
            .catchError((error) => print(error.toString()));
        db
            .execute('''create table client( 
                idClient integer primary key autoincrement,
                nameClient text,
                nbPersonne integer,
                prixTotal Real
                   )''')
            .then((value) => print('Client Table created'))
            .catchError((error) => print(error.toString()));

        db
            .execute('''create table ikhraj( 
                idClient integer,
                idSinf text ,
                fois integer,
                foreign key (idClient) references client(idClient),
                foreign key (idSinf) references sinf(idSinf),
                primary key (idClient,idSinf)
                  )''')
            .then((value) => print('Ikhraj Table created'))
            .catchError((error) => print(error.toString()));
      },
      onOpen: (db) async {
        getDataFromDatabase(db);
      },
    ).then((value) async {
      myDb = value;
      getDataFromDatabase(myDb!);
      emit(CreateDatabaseState());
    }).then((value) async {
      if (create) {
        print('Im in');
        insertToSinf();
        await MySharedPreferences.setCreate(false);
      } else
        print('Im out');
      getDataFromDatabase(myDb!);
    });
  }

  insertToSinf() async {
    String lienImages = "assets/images/asnaf/";
    myDb!.transaction(
      (txn) async {
        txn
            .rawInsert(
                "insert into sinf values('couscous','${allAsnafNameList[0]}', 2, 100.0, 'true', '${lienImages}couscous.png', 0.0, 20.0)")
            .then((value) {
          print('$value inserted successfully');
          emit(InsertToDatabaseState());
        }).catchError((e) {
          print('Error when inserted new record $e');
        });

        txn
            .rawInsert(
                "insert into sinf values('smid', '${allAsnafNameList[1]}', 2, 100.0, 'true', '${lienImages}smid.png', 0.0, 20.0 )")
            .then((value) {
          print('$value inserted successfully');
          emit(InsertToDatabaseState());
        }).catchError((e) {
          print('Error when inserted new record $e');
        });

        txn
            .rawInsert(
                "insert into sinf values('farine', '${allAsnafNameList[2]}', 1.5, 100.0, 'true', '${lienImages}farine.png', 0.0, 20.0 )")
            .then((value) {
          print('$value inserted successfully');
          emit(InsertToDatabaseState());
        }).catchError((e) {
          print('Error when inserted new record $e');
        });

        txn
            .rawInsert(
                "insert into sinf values('kam7','${allAsnafNameList[3]}', 2.1, 100.0, 'true', '${lienImages}kam7.png', 0.0, 20.0)")
            .then((value) {
          print('$value inserted successfully');
          emit(InsertToDatabaseState());
        }).catchError((e) {
          print('Error when inserted new record $e');
        });

        txn
            .rawInsert(
                "insert into sinf values('3des','${allAsnafNameList[4]}', 2.1, 100.0, 'true', '${lienImages}3des.png', 0.0, 20.0)")
            .then((value) {
          print('$value inserted successfully');
          emit(InsertToDatabaseState());
        }).catchError((e) {
          print('Error when inserted new record $e');
        });

        txn
            .rawInsert(
                "insert into sinf values('loubya','${allAsnafNameList[5]}', 2.1, 100.0, 'true','${lienImages}loubya.png',0.0, 20.0)")
            .then((value) {
          print('$value inserted successfully');
          emit(InsertToDatabaseState());
        }).catchError((e) {
          print('Error when inserted new record $e');
        });

        txn
            .rawInsert(
                "insert into sinf values('7missa','${allAsnafNameList[6]}', 2, 100.0, 'true','${lienImages}7missa.png',0.0, 20.0)")
            .then((value) {
          print('$value inserted successfully');
          emit(InsertToDatabaseState());
        }).catchError((e) {
          print('Error when inserted new record $e');
        });

        txn
            .rawInsert(
                "insert into sinf values('riz','${allAsnafNameList[7]}', 2.3, 100.0, 'true','${lienImages}riz.png',0.0, 20.0)")
            .then((value) {
          print('$value inserted successfully');
          emit(InsertToDatabaseState());
        }).catchError((e) {
          print('Error when inserted new record $e');
        });

        txn
            .rawInsert(
                "insert into sinf values('jalbana','${allAsnafNameList[8]}', 2.3, 100.0, 'true','${lienImages}jalbana.png', 0.0, 20.0)")
            .then((value) {
          print('$value inserted successfully');
          emit(InsertToDatabaseState());
        }).catchError((e) {
          print('Error when inserted new record $e');
        });

        txn
            .rawInsert(
                "insert into sinf values('m7amsa','${allAsnafNameList[9]}', 2, 100.0 , 'true','${lienImages}m7amsa.png',0.0, 20.0)")
            .then((value) {
          print('$value inserted successfully');
          emit(InsertToDatabaseState());
        }).catchError((e) {
          print('Error when inserted new record $e');
        });

        txn
            .rawInsert(
                "insert into sinf values('tamr','${allAsnafNameList[10]}', 1.8, 100.0, 'true','${lienImages}tamr.png', 0.0, 20.0)")
            .then((value) {
          print('$value inserted successfully');
          emit(InsertToDatabaseState());
        }).catchError((e) {
          print('Error when inserted new record $e');
        });

        txn
            .rawInsert(
                "insert into sinf values('zbib','${allAsnafNameList[11]}', 1.7, 100.0, 'true','${lienImages}zbib.png', 0.0, 20.0) ")
            .then((value) {
          print('$value inserted successfully');
          emit(InsertToDatabaseState());
        }).catchError((e) {
          print('Error when inserted new record $e');
        });
      },
    ).then((value) => getDataFromDatabase(myDb!));
    //emit(InsertToDatabaseState());
  }

  Future<int> getIdCurrentClient(Database db) async {
    List<Map> c = await db.rawQuery('select * from client');
    return c.last['idClient'];
  }

  void getDataFromDatabase(Database db) {
    client = [];
    sinf = [];
    ikhraj = [];

    emit(GetDatabaseLoadingState());

    db.rawQuery('select * from client').then((value) {
      client = value;
      print("\n\nclients= ");
      client.forEach((element) {
        print("$element\n");
      });
      emit(GetDatabaseState());
    });

    db.rawQuery('select * from ikhraj').then((value) {
      ikhraj = value;
      print("\n\nikhraj= $ikhraj");
      emit(GetDatabaseState());
    });

    db.rawQuery('select * from sinf').then((value) {
      sinf = value;
      print("\n\nsinfs= ");
      sinf.forEach((element) {
        print("$element\n");
      });
      asnafDisponible = [];
      sinf.forEach((element) {
        asnafDisponible.add(parseStringToBool(element['disponibilite']));
      });

      sinf.forEach((element) {
        String idSinf = element['idSinf'] as String;
        double stock = element['stock']! as double;
        double weight = element['weight'] as double;
        int allow = (stock / weight).round();

        allowedSinf[idSinf] = allow;
      });

      print("\n\nasnafDisponible= $asnafDisponible");
      emit(GetDatabaseState());
    });

    //return Future.value(5);
  }

  Future<void> insertToClient({
    required String nameClient,
    required int nbPersonne,
    required double prixTotal,
  }) async {
    return myDb!.transaction((txn) async {
      txn
          .rawInsert(
              'INSERT INTO client (nameClient,nbPersonne,prixTotal) values ("$nameClient","$nbPersonne","$prixTotal")')
          .then((value) {
        print('$value inserted successfully in CLIENT');
        emit(InsertToDatabaseState());
        getDataFromDatabase(myDb!);
      }).catchError((e) {
        print('Error when inserted new record ${e.toString()}');
      });
    });
  }

  Future<void> insertToIkhraj(
      {required int idClient,
      required String idSinf,
      required int fois}) async {
    return myDb!.transaction((txn) async {
      txn
          .rawInsert(
              'INSERT INTO ikhraj (idClient,idSinf,fois) values ("$idClient","$idSinf","$fois")')
          .then((value) {
        print('$value inserted successfully in IKHRAJ');
        emit(InsertToDatabaseState());
        getDataFromDatabase(myDb!);
      }).catchError((e) {
        print('Error when inserted new record ${e.toString()}');
      });
    });
  }

  double calculateClientPrice() {
    double price = 0;

    /// 1. Calculate the price
    nbSinf.forEach((idSinf, countSelect) {
      if (countSelect != 0) {
        /// 1.1. Extract how many time this sinf has been selected
        Map selectedSinf = sinf.firstWhere(
            (element) => (element['idSinf'] as String).compareTo(idSinf) == 0);
        print('selectedSinf= $selectedSinf');

        /// 1.2. Calculate...
        price = price +
            (countSelect * (selectedSinf['prixKg'] * selectedSinf['weight']));
        print('price= $price');
      }
    });
    print("totalPrice= $price");
    return price;
  }

  void updateClientPrice({required double price, required int idClient}) {
    myDb!.rawUpdate('UPDATE client SET prixTotal= ? WHERE idClient= ?',
        ['$price', '$idClient']).then((value) {
      emit(UpdateDatabaseState());
      getDataFromDatabase(myDb!);
    });
  }

  calculateSinfWeightTotal(Map asnafSelected) {
    double weightTotal = 0;

    /// 3. Calculate the total weight of every sinf
    asnafSelected.forEach((idSinf, countSelect) {
      weightTotal = 0;
      if (countSelect != 0) {
        /// 3.1. Extract how many time this sinf has been selected
        Map s = sinf.firstWhere(
            (element) => (element['idSinf'] as String).compareTo(idSinf) == 0);

        /// 3.2. Calculate...
        weightTotal = s['weightTotal'] + (s['weight'] * countSelect);
        print('$weightTotal');

        /// 3.3. Update weightTotal

        updateSinfWeightTotal(weightTotal: weightTotal, idSinf: idSinf);

        /// 3.4. Update stock

        double oldStock = sinf.firstWhere((element) =>
            (element['idSinf'] as String).compareTo(idSinf) == 0)['stock'];
        double newStock = oldStock - (s['weight'] * countSelect);
        updateSinfStock(stock: ceilToDouble2(newStock), idSinf: idSinf);
      }
    });
  }

  addToStock({required String idSinf, required double stockAdd}) {
    double oldStock = sinf.firstWhere((element) =>
        (element['idSinf'] as String).compareTo(idSinf) == 0)['stock'];
    double newStock = oldStock + stockAdd;
    updateSinfStock(stock: ceilToDouble2(newStock), idSinf: idSinf);
  }

  subToStock({required String idSinf, required double stockSub}) {
    double oldStock = sinf.firstWhere((element) =>
        (element['idSinf'] as String).compareTo(idSinf) == 0)['stock'];
    double newStock = oldStock - stockSub;
    updateSinfStock(stock: ceilToDouble2(newStock), idSinf: idSinf);
  }

  updateSinfWeightTotal({required double weightTotal, required String idSinf}) {
    myDb!.rawUpdate('UPDATE sinf SET weightTotal= ? WHERE idSinf= ?',
        ['${ceilToDouble2(weightTotal)}', '$idSinf']).then((value) {
      emit(UpdateDatabaseState());
      getDataFromDatabase(myDb!);
    });
  }

  void updateSinfDisponibilite(
      {required bool disponibilite, required String idSinf}) {
    myDb!.rawUpdate('UPDATE sinf SET disponibilite= ? WHERE idSinf= ?',
        ['${disponibilite.toString()}', '$idSinf']).then((value) {
      emit(UpdateDatabaseState());
      getDataFromDatabase(myDb!);
    });
  }

  void updateSinfPrixKg({required double prixKg, required String idSinf}) {
    myDb!.rawUpdate('UPDATE sinf SET prixKg= ? WHERE idSinf= ?',
        ['$prixKg', idSinf]).then((value) {
      emit(UpdateDatabaseState());
      getDataFromDatabase(myDb!);
    });
  }

  Future<void> updateSinfStock(
      {required double stock, required String idSinf}) async {
    Map<dynamic, dynamic> currentSinf = sinf.firstWhere(
        (element) => (element['idSinf'] as String).compareTo(idSinf) == 0);
    int currentSinfIndex = sinf.indexOf(currentSinf);
    print("currentSinfIndex=$currentSinfIndex");
    double currentSinfWeight = currentSinf['weight'];
    if (stock < currentSinfWeight) {
      /// update disponibilite in asnafDisponible
      asnafDisponible[currentSinfIndex + 1] = false;

      /// update Disponibilite in database
      print("rani bdit nbedel f db");
      int i = 0;
      sinf.forEach(
        (element) {
          updateSinfDisponibilite(
            disponibilite: asnafDisponible[i],
            idSinf: element['idSinf'],
          );
          i++;
        },
      );
      i = 0;
      print("rani kmlt");
    }

    /// update the stock in database
    myDb!.rawUpdate('UPDATE sinf SET stock= ? WHERE idSinf= ?',
        ['$stock', idSinf]).then((value) {
      emit(UpdateDatabaseState());
      getDataFromDatabase(myDb!);
    });
  }

  void deleteClient({required int idClient}) {
    final asnafClient =
        ikhraj.where((element) => element['idClient'] == idClient);
    asnafClient.forEach((elementIkhraj) {
      Map currentSinf = sinf.firstWhere(
          (elementSinf) => elementSinf['idSinf'] == elementIkhraj['idSinf']);
      double currentSinfWeight = currentSinf['weight'];
      double currentSinfWeightTotal =
          currentSinfWeight * (elementIkhraj['fois'] as int);
      double newWeightTotal =
          currentSinf['weightTotal'] - currentSinfWeightTotal;
      updateSinfWeightTotal(
          weightTotal: newWeightTotal, idSinf: elementIkhraj['idSinf']);
    });
    myDb!.rawDelete('DELETE FROM client WHERE idClient= ?', [idClient]).then(
        (_) {
      emit(DeleteDatabaseState());
      getDataFromDatabase(myDb!);
      myDb!.rawDelete('DELETE FROM ikhraj WHERE idClient= ?', [idClient]).then(
          (_) {
        emit(DeleteDatabaseState());
        getDataFromDatabase(myDb!);
      });
    });
  }

  /// for storing
  double ceilToDouble2(double number) {
    double dec = number - number.round();
    dec = (dec * 100).roundToDouble();
    dec = dec / 100;

    return number.round() + dec;
  }

  /// charity add needs Logic

  TextEditingController sinfController = TextEditingController();

  Future<void> insertNeed(Map<String, dynamic> sinfNeed) async {
    String uId = FirebaseAuth.instance.currentUser!.uid;
    print(uId);
    Map<String, dynamic> asnafNeed = {};
    emit(InsertNeedsLoadingState());
    try {
      DocumentSnapshot res =
          await FirebaseFirestore.instance.collection('needs').doc(uId).get();
      asnafNeed = res.data()!;
    } catch (error) {
      print(error);
    }
    asnafNeed.addAll(sinfNeed);
    FirebaseFirestore.instance
        .collection('needs')
        .doc(uId)
        .set(asnafNeed)
        .then((value) {
      emit(InsertNeedsSuccessState());
      getNeeds();
    }).catchError((onError) {
      emit(InsertNeedsErrorState());
    });
  }

  Map<String, dynamic> myNeeds = {};

  void getNeeds() async {
    myNeeds = {};
    String uId = FirebaseAuth.instance.currentUser!.uid;
    emit(GetNeedsLoadingState());
    FirebaseFirestore.instance.collection('needs').doc(uId).get().then((value) {
      myNeeds = value.data()!;
      emit(GetNeedsState());
    }).catchError((error) {
      emit(GetNeedErrorState());
    });
  }

  void updateNeed(String idSinf, double newNeed) {
    String uId = FirebaseAuth.instance.currentUser!.uid;
    emit(UpdateNeedLoadingState());
    FirebaseFirestore.instance
        .collection('needs')
        .doc(uId)
        .update({idSinf: newNeed}).then((value) {
      emit(UpdateNeedSuccessState());
      getNeeds();
    }).catchError((error) {
      emit(UpdateNeedErrorState());
    });
  }

  void deleteNeed(String idSinf) {
    String uId = FirebaseAuth.instance.currentUser!.uid;
    emit(DeleteNeedLoadingState());
    final updates = <String, dynamic>{
      idSinf: FieldValue.delete(),
    };
    FirebaseFirestore.instance
        .collection('needs')
        .doc(uId)
        .update(updates)
        .then((value) {
      emit(DeleteNeedSuccessState());
      getNeeds();
    }).catchError((error) {
      emit(DeleteNeedErrorState());
    });
  }

  List<QueryDocumentSnapshot> allNeeds = [];

  void getAllNeeds() {
    emit(GetNeedsLoadingState());
    allNeeds = [];
    FirebaseFirestore.instance.collection('needs').get().then((value) {
      allNeeds = value.docs;
      allNeeds.forEach((element) {
        print("${element.id} : " + "${element.data()}");
      });
      emit(GetNeedsState());
    }).catchError((error) {
      emit(GetNeedErrorState());
    });
  }

  List<UserM> allUsers = [];

  void getAllUsers() {
    allUsers = [];
    emit(GetUsersLoadingState());
    FirebaseFirestore.instance.collection('users').get().then((value) {
      value.docs.forEach((element) {
        allUsers.add(UserM.fromJson(json: element.data()));
        // print(element.data());
      });
      emit(GetUsersState());
    }).catchError((error) {
      emit(GetUsersErrorState());
    });
  }

  UserM getUserDetail(String id) {
    return allUsers.firstWhere((element) => element.uId == id);
  }

  /// chatlogic
  bool isStream=true;

  void sendMessage({
    required String receiverId,
    required String text,
    required String dateTime,
  }) {
    String senderId = FirebaseAuth.instance.currentUser!.uid;
    Message message = Message(
      text: text,
      receiverId: receiverId,
      senderId: senderId,
      dateTime: dateTime,
    );

    /// set my chats
    FirebaseFirestore.instance
        .collection('users')
        .doc(senderId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(message.toMap())
        .then((value) {
      emit(SendMessageSuccessState());
      UserM user=allUsers.firstWhere((element) => element.uId==receiverId);

      FirebaseFirestore.instance
          .collection('users')
          .doc(senderId)
          .collection('friends').doc(receiverId).set(user.toMap()).then((value) {
        emit(AddFriendSuccessState());
      }).catchError((error) {
        emit(AddFriendErrorState());
      });
    }).catchError((error) {
      emit(SendMessageErrorState());
      //getMessages(receiverId: receiverId);
    });

    /// set receiver chats
    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(senderId)
        .collection('messages')
        .add(message.toMap())
        .then((value) {
      emit(SendMessageSuccessState());
      UserM user=allUsers.firstWhere((element) => element.uId==senderId);
      FirebaseFirestore.instance
          .collection('users')
          .doc(receiverId)
          .collection('friends').doc(senderId).set(user.toMap()).then((value) {
        emit(AddFriendSuccessState());
      }).catchError((error) {
        emit(AddFriendErrorState());
      });
    }).catchError((error) {
      emit(SendMessageErrorState());
    });
  }

  List<Message> messages = [];

  void getMessages({required String receiverId}) {
    String senderId = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance
        .collection('users')
        .doc(senderId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .snapshots()
        .listen((event) {
      messages = [];
      event.docs.forEach((element) {
        messages.add(Message.fromJson(json: element.data()));
      });
      emit(GetMessageSuccessState());
    });
  }


  ///Chek Connexion Internet
  Future<bool> checkConnexion()async{

    try{
      var result=await InternetAddress.lookup("Google.com");
      if(result.isNotEmpty && result[0].rawAddress.isNotEmpty)
        return true;
      return false;
    }catch(_){

    }
    return false;

  }


}
