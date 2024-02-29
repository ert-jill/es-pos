import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/form.dart';
import '../services/account_controller.dart';
import '../services/printer_controller.dart';
import '../services/snack_bar_service.dart';

class PrinterForm extends StatelessWidget {
  PrinterFormModel printerFormModel = PrinterFormModel();
  final PrinterController printerController;
  RxBool isLoading = false.obs;
  RxBool isSubmitting = false.obs;

  TextEditingController _nameFieldController = TextEditingController();
  TextEditingController _descriptionFieldController = TextEditingController();
  TextEditingController _connectionFieldController = TextEditingController();

  PrinterForm({
    super.key,
    required this.printerController,
  });
  final printerFormKey = GlobalKey<FormState>();

  submit() async {
    // print(printerFormModel.toJson().toString());
    if (printerFormKey.currentState!.validate()) {
      printerFormKey.currentState!.save();
      isSubmitting.value = true;
      try {
        var response = await printerController.addPrinter(printerFormModel);
        if (response.isOk) {
          printerFormKey.currentState!.reset();
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
    _connectionFieldController.clear();
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
                                            key: printerFormKey,
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
                                                                        .printerFormModel
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
                                                                  return 'Please enter owner';
                                                                }
                                                                return null;
                                                              },
                                                              onSaved:
                                                                  (newValue) {
                                                                this
                                                                        .printerFormModel
                                                                        .description =
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
                                                                  _connectionFieldController,
                                                              maxLength: 200,
                                                              onFieldSubmitted:
                                                                  (text) {},
                                                              decoration: const InputDecoration(
                                                                  counterText:
                                                                      '',
                                                                  border:
                                                                      OutlineInputBorder(),
                                                                  labelText:
                                                                      "Connection"),
                                                              validator:
                                                                  (value) {
                                                                if (value ==
                                                                        null ||
                                                                    value
                                                                        .isEmpty) {
                                                                  return 'Please enter connection';
                                                                }
                                                                return null;
                                                              },
                                                              onSaved:
                                                                  (newValue) {
                                                                this
                                                                        .printerFormModel
                                                                        .connection =
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
