import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/models/account.dart';
import 'package:pos/models/user_type.dart';
import 'package:pos/services/user_type_controller.dart';
import '../models/form.dart';
import '../services/account_controller.dart';
import '../services/snack_bar_service.dart';
import '../services/user_service.dart';

class AccountForm extends StatelessWidget {
  final AccountController accountController =
      Get.put<AccountController>(AccountController());
  AccountFormModel accountFormModel = AccountFormModel();
  String? _password;
  RxBool isLoading = false.obs;
  RxBool isSubmitting = false.obs;
  RxBool _shouldValidate = true.obs;

  TextEditingController _nameFieldController = TextEditingController();
  TextEditingController _ownerFieldController = TextEditingController();
  TextEditingController _emailFieldController = TextEditingController();
  TextEditingController _contactNumberFieldController = TextEditingController();
  TextEditingController _addressFieldController = TextEditingController();

  AccountForm({
    super.key,
  });
  final accountFormKey = GlobalKey<FormState>();

  submit() async {
    // print(accountFormModel.toJson().toString());
    if (accountFormKey.currentState!.validate()) {
      accountFormKey.currentState!.save();
      isSubmitting.value = true;
      try {
        var response = await accountController.addAccount(accountFormModel);
        if (response.isOk) {
          accountFormKey.currentState!.reset();
          clearAllTextControllers();
        } else {
          //   print('failed not ok');
        }
      } catch (e) {
        SnackBarService.presentSnackBar('Error', e.toString(), AlertType.error);
      }

      isSubmitting.value = false;
    } else {
      print('failed');
    }
  }

  void clearAllTextControllers() {
    _nameFieldController.text = '';
    _emailFieldController.clear();
    _ownerFieldController.clear();
    _contactNumberFieldController.clear();
    _addressFieldController.clear();
    _shouldValidate.value = false;
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
                              'Add Account',
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
                                            key: accountFormKey,
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
                                                              autovalidateMode: _shouldValidate
                                                                      .value
                                                                  ? AutovalidateMode
                                                                      .onUserInteraction
                                                                  : AutovalidateMode
                                                                      .disabled,
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
                                                                        .accountFormModel
                                                                        .name =
                                                                    newValue;
                                                              },
                                                            ),
                                                          ),
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
                                                                  _ownerFieldController,
                                                              autovalidateMode: _shouldValidate
                                                                      .value
                                                                  ? AutovalidateMode
                                                                      .onUserInteraction
                                                                  : AutovalidateMode
                                                                      .disabled,
                                                              maxLength: 200,
                                                              onFieldSubmitted:
                                                                  (text) {},
                                                              decoration: const InputDecoration(
                                                                  counterText:
                                                                      '',
                                                                  border:
                                                                      OutlineInputBorder(),
                                                                  labelText:
                                                                      "Owner"),
                                                              validator:
                                                                  (value) {
                                                                if (value ==
                                                                        null ||
                                                                    value
                                                                        .isEmpty) {
                                                                  return 'Please enter owner';
                                                                }
                                                                return null;
                                                              },
                                                              onSaved:
                                                                  (newValue) {
                                                                this
                                                                        .accountFormModel
                                                                        .ownerName =
                                                                    newValue;
                                                              },
                                                            ),
                                                          ),
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
                                                                  _emailFieldController,
                                                              autovalidateMode: _shouldValidate
                                                                      .value
                                                                  ? AutovalidateMode
                                                                      .onUserInteraction
                                                                  : AutovalidateMode
                                                                      .disabled,
                                                              maxLength: 200,
                                                              onFieldSubmitted:
                                                                  (text) {},
                                                              decoration: const InputDecoration(
                                                                  counterText:
                                                                      '',
                                                                  border:
                                                                      OutlineInputBorder(),
                                                                  labelText:
                                                                      "Email"),
                                                              validator:
                                                                  (value) {
                                                                if (value ==
                                                                        null ||
                                                                    value
                                                                        .isEmpty) {
                                                                  return 'Please enter email';
                                                                }
                                                                return null;
                                                              },
                                                              onSaved:
                                                                  (newValue) {
                                                                this
                                                                        .accountFormModel
                                                                        .email =
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
                                                                  _contactNumberFieldController,
                                                              autovalidateMode: _shouldValidate
                                                                      .value
                                                                  ? AutovalidateMode
                                                                      .onUserInteraction
                                                                  : AutovalidateMode
                                                                      .disabled,
                                                              maxLength: 100,
                                                              onFieldSubmitted:
                                                                  (text) {},
                                                              onChanged:
                                                                  (value) {
                                                                _password =
                                                                    value;
                                                                accountFormModel
                                                                        .contactNumber =
                                                                    value;
                                                              },
                                                              decoration: const InputDecoration(
                                                                  counterText:
                                                                      '',
                                                                  border:
                                                                      OutlineInputBorder(),
                                                                  labelText:
                                                                      "Contact Number"),
                                                              validator:
                                                                  (value) {
                                                                if (value ==
                                                                        null ||
                                                                    value
                                                                        .isEmpty) {
                                                                  return 'Please enter contact number';
                                                                }
                                                                return null;
                                                              },
                                                            ),
                                                          ),
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
                                                              onSaved:
                                                                  (newValue) {
                                                                accountFormModel
                                                                        .address =
                                                                    newValue;
                                                              },
                                                              controller:
                                                                  _addressFieldController,
                                                              autovalidateMode: _shouldValidate
                                                                      .value
                                                                  ? AutovalidateMode
                                                                      .onUserInteraction
                                                                  : AutovalidateMode
                                                                      .disabled,
                                                              maxLength: 100,
                                                              onFieldSubmitted:
                                                                  (text) {},
                                                              decoration: const InputDecoration(
                                                                  counterText:
                                                                      '',
                                                                  border:
                                                                      OutlineInputBorder(),
                                                                  labelText:
                                                                      "Address"),
                                                              validator:
                                                                  (value) {
                                                                if (value ==
                                                                        null ||
                                                                    value
                                                                        .isEmpty) {
                                                                  return 'Please enter address';
                                                                }

                                                                return null;
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
                                                        onPressed: () {
                                                          submit();
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
