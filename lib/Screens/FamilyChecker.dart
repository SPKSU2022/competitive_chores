import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:competative_chores/Amplify.dart';
import 'package:competative_chores/Classes/Families.dart';
import 'package:competative_chores/Classes/Formatting.dart';
import 'package:competative_chores/MainPage.dart';
import 'package:competative_chores/Services/APICalls.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FamilyChecker extends StatefulWidget {
  const FamilyChecker({Key? key}) : super(key: key);

  @override
  State<FamilyChecker> createState() => _FamilyCheckerState();
}

class _FamilyCheckerState extends State<FamilyChecker> {
  final GlobalKey<FormState> joinerKey = GlobalKey<FormState>();
  TextEditingController familyID = TextEditingController();
  TextEditingController familyName = TextEditingController();

  final GlobalKey<FormState> creatorKey = GlobalKey<FormState>();
  TextEditingController familyCreator = TextEditingController();

  void validateAndSave(GlobalKey<FormState> key) {
    final FormState? form = key.currentState;
    if (form!.validate()) {
      debugPrint('Form is valid');
    } else {
      debugPrint('Form is invalid');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Formatting.bannerRed, borderRadius: BorderRadius.circular(5)),
      width: MediaQuery.of(context).size.width / 3,
      height: MediaQuery.of(context).size.height / 3,
      child: DefaultTabController(
          length: 2,
          child: Scaffold(
              appBar: TabBar(
                labelColor: Formatting.textColor,
                tabs: const [
                  Tab(
                    text: 'Join Family',
                  ),
                  Tab(
                    text: 'Create Family',
                  )
                ],
              ),
              backgroundColor: Colors.transparent,
              body: TabBarView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Form(
                      key: joinerKey,
                      child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 2 / 9,
                          child: TextFormField(
                            validator: (value) {
                              return (value!.isEmpty ||
                                      !Families.allFamilyNames.contains(familyName.text) ||
                                      !Families.allFamilyIDs.contains(int.parse(familyID.text)))
                                  ? 'This family doesn\'t Exist.'
                                  : null;
                            },
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            decoration: const InputDecoration(labelText: 'Family #'),
                            controller: familyID,
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 2 / 9,
                          child: TextFormField(
                            validator: (value) {
                              return (value!.isEmpty ||
                                      !Families.allFamilyNames.contains(familyName.text) ||
                                      !Families.allFamilyIDs.contains(int.parse(familyID.text)))
                                  ? 'This family doesn\'t Exist.'
                                  : null;
                            },
                            maxLength: 200,
                            decoration: const InputDecoration(labelText: 'Family Name', helperMaxLines: 200),
                            controller: familyName,
                          ),
                        ),
                        ElevatedButton(
                          child: const Text('Join Family'),
                          onPressed: () async {
                            await getAllFamilies().then((value) async {
                              validateAndSave(joinerKey);
                              if (joinerKey.currentState!.validate()) {
                                await Amplify.Auth.updateUserAttribute(
                                        userAttributeKey: CognitoUserAttributeKey.custom("custom:familyid"), value: familyID.text)
                                    .then((value) async {
                                  await Amplify.Auth.updateUserAttribute(
                                          userAttributeKey: CognitoUserAttributeKey.custom("custom:familyName"), value: familyName.text)
                                      .then((value) async {
                                    await Amp.getCurrentUser().then((value) {}).then((value) {
                                      Navigator.push(context, MaterialPageRoute(builder: ((context) => Material(child: MainPage()))));
                                    });
                                  });
                                });
                              }
                            });
                          },
                        )
                      ]),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Form(
                      key: creatorKey,
                      child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 2 / 9,
                          child: TextFormField(
                            validator: ((value) {
                              return (value!.isEmpty || Families.allFamilyNames.contains(familyCreator.text)) ? 'This family name is taken.' : null;
                            }),
                            maxLength: 200,
                            decoration: const InputDecoration(labelText: 'Family Name', helperMaxLines: 200),
                            controller: familyCreator,
                          ),
                        ),
                        ElevatedButton(
                          child: const Text('Create & Join Family'),
                          onPressed: () async {
                            await getAllFamilies().then(
                              (value) {
                                validateAndSave(creatorKey);
                                if (creatorKey.currentState!.validate()) {
                                  insertFamily(familyCreator.text).then((value) async {
                                    await getAllFamilies().then((value) async {
                                      String ID = '';
                                      for (int i = 0; i < Families.allFamilies.length; i++) {
                                        if (Families.allFamilies[i][1].toString() == familyCreator.text) {
                                          Amplify.Auth.updateUserAttribute(
                                              userAttributeKey: CognitoUserAttributeKey.custom("custom:familyid"),
                                              value: Families.allFamilies[i][0].toString());
                                        }
                                      }
                                      await Amplify.Auth.updateUserAttribute(
                                              userAttributeKey: CognitoUserAttributeKey.custom("custom:familyName"), value: familyCreator.text)
                                          .then((value) {
                                        Navigator.push(context, MaterialPageRoute(builder: ((context) => MainPage())));
                                      });
                                    });
                                  });
                                }
                              },
                            );
                          },
                        )
                      ]),
                    ),
                  ),
                ],
              ))),
    );
  }
}
