import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/form.dart';
import '../services/snack_bar_service.dart';
import '../services/user_service.dart';

class UserTypeForm extends StatelessWidget {
  UserTypeFormModel userTypeFormModel = UserTypeFormModel();
  final UserService userService = Get.find<UserService>();
  String? _password;
  RxBool isLoading = false.obs;
  RxBool isSubmitting = false.obs;
  RxBool _shouldValidate = true.obs;
  AutovalidateMode _autovalidateMode = AutovalidateMode.onUserInteraction;

  TextEditingController _nameFieldController = TextEditingController();
  TextEditingController _descriptionFieldController = TextEditingController();

  UserTypeForm({
    super.key,
  });
  final userTypeFormKey = GlobalKey<FormState>();

  submit() async {
    // print(userTypeFormModel.toJson().toString());
    if (userTypeFormKey.currentState!.validate()) {
      userTypeFormKey.currentState!.save();
      isSubmitting.value = true;
      _shouldValidate.value = false;
      try {
        var response = await userService.addUserType(userTypeFormModel);
        if (response.isOk) {
          userTypeFormKey.currentState!.reset();
          clearAllTextControllers();
        } else {
          //   print('failed not ok');
        }
      } catch (e) {
        SnackBarService.presentSnackBar('Error', e.toString(), AlertType.error);
      }
      _shouldValidate.value = true;
      isSubmitting.value = false;
    } else {
      print('failed');
    }
  }

  void clearAllTextControllers() {
    _nameFieldController.clear();
    _descriptionFieldController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 800,
      height: 525,
      child: Material(
          borderRadius: BorderRadius.circular(20),
          child: Obx(() => Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(28, 0, 0, 0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Add User Type',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Expanded(
                            child: SingleChildScrollView(
                          child: Column(children: [
                            LayoutBuilder(
                              builder: (context, constraints) {
                                return Center(
                                  child: ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      maxWidth: 800, // Set maximum width
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 0, 20, 20),
                                      child: Obx(() => Form(
                                            key: userTypeFormKey,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                if (isLoading.value)
                                                  const Center(
                                                      child:
                                                          LinearProgressIndicator()),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        8,
                                                                    vertical:
                                                                        16),
                                                            child:
                                                                TextFormField(
                                                              controller:
                                                                  _nameFieldController,
                                                              maxLength: 200,
                                                              onFieldSubmitted:
                                                                  (text) {},
                                                              decoration: const InputDecoration(
                                                                  counterText:
                                                                      '',
                                                                  border:
                                                                      OutlineInputBorder(),
                                                                  labelText:
                                                                      "Name"),
                                                              validator:
                                                                  (value) {
                                                                if (value ==
                                                                        null ||
                                                                    value
                                                                        .isEmpty) {
                                                                  return 'Please enter name';
                                                                }
                                                                return null;
                                                              },
                                                              onSaved:
                                                                  (newValue) {
                                                                this
                                                                        .userTypeFormModel
                                                                        .name =
                                                                    newValue;
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Column(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        8,
                                                                    vertical:
                                                                        16),
                                                            child:
                                                                TextFormField(
                                                              controller:
                                                                  _descriptionFieldController,
                                                              maxLength: 200,
                                                              onFieldSubmitted:
                                                                  (text) {},
                                                              decoration: const InputDecoration(
                                                                  counterText:
                                                                      '',
                                                                  border:
                                                                      OutlineInputBorder(),
                                                                  labelText:
                                                                      "Description"),
                                                              validator:
                                                                  (value) {
                                                                if (value ==
                                                                        null ||
                                                                    value
                                                                        .isEmpty) {
                                                                  return 'Please enter description';
                                                                }
                                                                return null;
                                                              },
                                                              onSaved:
                                                                  (newValue) {
                                                                this
                                                                        .userTypeFormModel
                                                                        .description =
                                                                    newValue;
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 8,
                                                          vertical: 16),
                                                      child: TextButton(
                                                        onPressed: () {
                                                          Get.back();
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(15),
                                                          child: const Text(
                                                              'Cancel'),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 8,
                                                          vertical: 16),
                                                      child: FilledButton(
                                                        onPressed: () async {
                                                          await submit();
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(15),
                                                          child: const Text(
                                                              'Submit'),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          )),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ]),
                        ))
                      ],
                    ),
                  ),
                  if (isSubmitting.value)
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                ],
              ))),
    );
  }
}
