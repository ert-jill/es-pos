import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/models/area.dart';
import '../models/form.dart';
import '../services/area_controller.dart';
import '../services/snack_bar_service.dart';
import '../services/table_controller.dart';

class TableForm extends StatelessWidget {
  final TableController tableController;
  final AreaController areaController = Get.put(AreaController());
  TableFormModel tableFormModel = TableFormModel();
  RxBool isLoading = false.obs;
  RxBool isSubmitting = false.obs;

  TextEditingController _nameFieldController = TextEditingController();
  TextEditingController _codeFieldController = TextEditingController();
  TextEditingController _areaController = TextEditingController();

  TableForm({super.key, required this.tableController});
  final tableFormKey = GlobalKey<FormState>();

  oninit() {
    // area
    areaController.getAreaList();
  }

  submit() async {
    // print(tableFormModel.toJson().toString());
    if (tableFormKey.currentState!.validate()) {
      tableFormKey.currentState!.save();
      isSubmitting.value = true;
      try {
        var response = await tableController.addTable(tableFormModel);
        if (response.isOk) {
          tableFormKey.currentState!.reset();
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
    _areaController.clear();
    _nameFieldController.text = '';
    _codeFieldController.clear();
  }

  @override
  Widget build(BuildContext context) {
    oninit();
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
                              'Add Table',
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
                                            key: tableFormKey,
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
                                                                        .tableFormModel
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
                                                                  _codeFieldController,
                                                              maxLength: 100,
                                                              onFieldSubmitted:
                                                                  (text) {},
                                                              decoration: const InputDecoration(
                                                                  counterText:
                                                                      '',
                                                                  border:
                                                                      OutlineInputBorder(),
                                                                  labelText:
                                                                      "Code"),
                                                              onSaved:
                                                                  (newValue) {
                                                                tableFormModel
                                                                        .code =
                                                                    newValue;
                                                              },
                                                              validator:
                                                                  (value) {
                                                                if (value ==
                                                                        null ||
                                                                    value
                                                                        .isEmpty) {
                                                                  return 'Please enter code';
                                                                }
                                                                return null;
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Column(
                                                        children: [
                                                          Obx(
                                                              () =>
                                                                  DropdownMenu<
                                                                      Area>(
                                                                    width: 300,
                                                                    // initialSelection: ColorLabel.green,
                                                                    controller:
                                                                        _areaController,
                                                                    // requestFocusOnTap is enabled/disabled by platforms when it is null.
                                                                    // On mobile platforms, this is false by default. Setting this to true will
                                                                    // trigger focus request on the text field and virtual keyboard will appear
                                                                    // afterward. On desktop platforms however, this defaults to true.
                                                                    enableFilter:
                                                                        false,
                                                                    requestFocusOnTap:
                                                                        true,
                                                                    label: const Text(
                                                                        'Table Item'),
                                                                    onSelected:
                                                                        (Area?
                                                                            area) {
                                                                      tableFormModel
                                                                              .area =
                                                                          area!
                                                                              .id
                                                                              .toString();
                                                                    },
                                                                    dropdownMenuEntries: areaController
                                                                        .areaList
                                                                        .map((element) =>
                                                                            DropdownMenuEntry<Area>(
                                                                              value: element,
                                                                              label: element.name,
                                                                              enabled: true,
                                                                            ))
                                                                        .toList(),
                                                                  )),
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
