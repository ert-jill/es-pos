import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/form.dart';
import '../services/discount_controller.dart';
import '../services/snack_bar_service.dart';
import '../utils/text_field_formater.dart';

class DiscountForm extends StatelessWidget {
  DiscountController discountController;
  DiscountFormModel discountFormModel = DiscountFormModel();
  RxBool isLoading = false.obs;
  RxBool isSubmitting = false.obs;
  Rx<String?> selectedAmountType = null.obs;

  TextEditingController _nameFieldController = TextEditingController();
  TextEditingController _codeFieldController = TextEditingController();
  TextEditingController _descriptionFieldController = TextEditingController();
  TextEditingController _amountFieldController = TextEditingController();

  DiscountForm({super.key, required this.discountController});
  final accountFormKey = GlobalKey<FormState>();

  submit() async {
    // print(discountFormModel.toJson().toString());
    if (accountFormKey.currentState!.validate()) {
      accountFormKey.currentState!.save();
      isSubmitting.value = true;
      try {
        var response = await discountController.addDiscount(discountFormModel);
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
    selectedAmountType.value = null;
    _nameFieldController.clear();
    _descriptionFieldController.clear();
    _codeFieldController.clear();
    _amountFieldController.clear();
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(28, 0, 0, 0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Add Discount',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 28, 0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Add Discount',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
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
                                                                        .discountFormModel
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
                                                              maxLength: 200,
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
                                                                this
                                                                        .discountFormModel
                                                                        .code =
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
                                                                  return 'Please enter description';
                                                                }
                                                                return null;
                                                              },
                                                              onSaved:
                                                                  (newValue) {
                                                                this
                                                                        .discountFormModel
                                                                        .description =
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
                                                              keyboardType:
                                                                  const TextInputType
                                                                      .numberWithOptions(
                                                                decimal: true,
                                                              ),
                                                              inputFormatters: [
                                                                AmountInputFormatter()
                                                              ],
                                                              controller:
                                                                  _amountFieldController,
                                                              maxLength: 100,
                                                              onFieldSubmitted:
                                                                  (text) {},
                                                              decoration: const InputDecoration(
                                                                  counterText:
                                                                      '',
                                                                  border:
                                                                      OutlineInputBorder(),
                                                                  labelText:
                                                                      "Amount"),
                                                              validator:
                                                                  (value) {
                                                                if (value ==
                                                                        null ||
                                                                    value
                                                                        .isEmpty) {
                                                                  return 'Please enter amount';
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
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        8,
                                                                    vertical:
                                                                        16),
                                                            child: LayoutBuilder(
                                                                builder: (context,
                                                                    constraints) {
                                                              return SizedBox(
                                                                  width: double
                                                                      .infinity,
                                                                  child: Obx(() =>
                                                                      DropdownButtonFormField<
                                                                          String>(
                                                                        validator:
                                                                            (value) {
                                                                          if (value == null ||
                                                                              value.isEmpty) {
                                                                            return 'Please enter amount type';
                                                                          }
                                                                          return null;
                                                                        },
                                                                        value: selectedAmountType
                                                                            .value,
                                                                        style: const TextStyle(
                                                                            overflow:
                                                                                TextOverflow.ellipsis),
                                                                        decoration:
                                                                            InputDecoration(
                                                                          counterText:
                                                                              '',
                                                                          labelText:
                                                                              'Amount Type',
                                                                          border:
                                                                              OutlineInputBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(5),
                                                                          ),
                                                                        ),
                                                                        onSaved:
                                                                            (newValue) {
                                                                          selectedAmountType.value =
                                                                              newValue;
                                                                          discountFormModel.amountType =
                                                                              newValue;
                                                                        },
                                                                        items: [
                                                                          DropdownMenuItem<
                                                                              String>(
                                                                            value:
                                                                                'Cash',
                                                                            child:
                                                                                Text(
                                                                              'Cash',
                                                                              softWrap: true,
                                                                              overflow: TextOverflow.ellipsis,
                                                                            ),
                                                                          ),
                                                                          DropdownMenuItem<
                                                                              String>(
                                                                            value:
                                                                                'Percent',
                                                                            child:
                                                                                Text(
                                                                              'Percent',
                                                                              softWrap: true,
                                                                              overflow: TextOverflow.ellipsis,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                        onChanged:
                                                                            (String?
                                                                                value) {},
                                                                        onTap:
                                                                            () {},
                                                                      )));
                                                            }),
                                                          ),
                                                          // Padding(
                                                          //   padding:
                                                          //       const EdgeInsets
                                                          //           .symmetric(
                                                          //           horizontal:
                                                          //               8,
                                                          //           vertical:
                                                          //               16),
                                                          //   child:
                                                          //       TextFormField(
                                                          //     maxLength: 100,
                                                          //     onTap: () {
                                                          //       showDialog(
                                                          //           context:
                                                          //               context,
                                                          //           builder:
                                                          //               (build0er) {
                                                          //             return DatePickerDialog(
                                                          //               restorationId:
                                                          //                   'date_picker_dialog',
                                                          //               initialEntryMode:
                                                          //                   DatePickerEntryMode.calendarOnly,
                                                          //               firstDate:
                                                          //                   DateTime(2021),
                                                          //               lastDate:
                                                          //                   DateTime(2022),
                                                          //             );
                                                          //           });
                                                          //     },
                                                          //     onFieldSubmitted:
                                                          //         (text) {},
                                                          //     decoration: const InputDecoration(
                                                          //         counterText:
                                                          //             '',
                                                          //         border:
                                                          //             OutlineInputBorder(),
                                                          //         labelText:
                                                          //             "Date Expired"),
                                                          //     validator:
                                                          //         (value) {
                                                          //       if (value ==
                                                          //               null ||
                                                          //           value
                                                          //               .isEmpty) {
                                                          //         return 'Please enter amount';
                                                          //       }
                                                          //       return null;
                                                          //     },
                                                          //   ),
                                                          // ),
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
