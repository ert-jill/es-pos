import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/models/account.dart';
import 'package:pos/models/user_type.dart';
import 'package:pos/services/user_type_controller.dart';

import '../models/form.dart';
import '../models/product.dart';
import '../services/account_controller.dart';
import '../services/product_service.dart';
import '../services/snack_bar_service.dart';
import '../services/user_service.dart';

class ProductForm extends StatelessWidget {
  final ProductService productService = Get.find<ProductService>();
  final RxList<Product> dropDownProducts = RxList.empty();
  final TextEditingController _controller = TextEditingController();
  RxList<TextEditingController> _controllerList = RxList.empty();
  ProductFormModel productForm = ProductFormModel();
  String? _password;
  RxBool isLoading = false.obs;
  RxBool isSubmitting = false.obs;
  RxBool isGroup = false.obs;
  RxList<ProductGroupItemFormModel> productGroupItems = RxList.empty();
  // Rx<User> newUser = User(
  //         id: 0,
  //         username: '',
  //         password: '',
  //         firstName: '',
  //         lastName: '',
  //         email: '',
  //         account: Account(
  //             id: 0,
  //             name: '',
  //             ownerName: '',
  //             email: '',
  //             contactNumber: '',
  //             address: '',
  //             status: true),
  //         userType: UserType(
  //             id: Convert.parseToBigInt('0'),
  //             name: '',
  //             description: '',
  //             isActive: true))
  //     .obs;

  TextEditingController _skuFieldController = TextEditingController();
  TextEditingController _nameFieldController = TextEditingController();
  TextEditingController _descriptionFieldController = TextEditingController();
  TextEditingController _priceFieldController = TextEditingController();
  TextEditingController _stockFieldController = TextEditingController();

  ProductForm({
    super.key,
  });
  final userFormKey = GlobalKey<FormState>();
  onInit() async {
    isLoading.value = true;
    // _controller.addListener(() async {
    //   dropDownProducts.value =
    //       await productService.searchProducts(_controller.text);
    //   dropDownProducts.refresh();
    // });
    isLoading.value = false;
  }

  onSearchDropdown(String? searchString) async {
    //
  }

  submit() async {
    if (userFormKey.currentState!.validate()) {
      productForm.productItems = productGroupItems.value;
      userFormKey.currentState!.save();
      isSubmitting.value = true;
      try {
        var response = await productService.addProduct(productForm);
        print(response.bodyString);
        if (response.isOk) {
          userFormKey.currentState!.reset();
          clearAllTextControllers();
        }
      } catch (e) {
        SnackBarService.presentSnackBar('Error', e.toString(), AlertType.error);
      }
      isSubmitting.value = false;
    } else {
      print('failed');
    }
  }

  addController() {
    _controllerList.add(TextEditingController());
    _controllerList[_controllerList.length - 1].addListener(() async {
      dropDownProducts.value = await productService
          .searchProducts(_controllerList[_controllerList.length - 1].text);
      dropDownProducts.refresh();
    });
  }

  addProductItem() {
    if (isGroup.value) {
      addController();
      productGroupItems.add(ProductGroupItemFormModel());
    }
  }

  toggleIsCombo(newValue) async {
    isGroup.value = newValue;
    if (isGroup.value) {
      // await onSearchDropdown(null);
      addController();
      productGroupItems.add(ProductGroupItemFormModel());
    } else {
      productGroupItems.clear();
    }
  }

  void clearAllTextControllers() {
    isGroup.value = false;
    productGroupItems.clear();
    _skuFieldController.clear();
    _nameFieldController.clear();
    _descriptionFieldController.clear();
    _priceFieldController.clear();
    _stockFieldController.clear();
  }

  @override
  Widget build(BuildContext context) {
    onInit();

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
                              'Add Product',
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
                                      child: Obx(
                                        () => Form(
                                          key: userFormKey,
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
                                                                  horizontal: 8,
                                                                  vertical: 16),
                                                          child: TextFormField(
                                                            controller:
                                                                _skuFieldController,
                                                            // autovalidateMode:
                                                            //     AutovalidateMode
                                                            //         .onUserInteraction,
                                                            maxLength: 200,
                                                            onFieldSubmitted:
                                                                (text) {},
                                                            decoration:
                                                                const InputDecoration(
                                                                    counterText:
                                                                        '',
                                                                    border:
                                                                        OutlineInputBorder(),
                                                                    labelText:
                                                                        "Sku"),
                                                            validator: (value) {
                                                              if (value ==
                                                                      null ||
                                                                  value
                                                                      .isEmpty) {
                                                                return 'Please enter your sku';
                                                              }
                                                              return null;
                                                            },
                                                            onSaved:
                                                                (newValue) {
                                                              this
                                                                  .productForm
                                                                  .sku = newValue;
                                                            },
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal: 8,
                                                                  vertical: 16),
                                                          child: TextFormField(
                                                            controller:
                                                                _nameFieldController,
                                                            // autovalidateMode:
                                                            //     AutovalidateMode
                                                            //         .onUserInteraction,
                                                            maxLength: 200,
                                                            onFieldSubmitted:
                                                                (text) {},
                                                            decoration:
                                                                const InputDecoration(
                                                                    counterText:
                                                                        '',
                                                                    border:
                                                                        OutlineInputBorder(),
                                                                    labelText:
                                                                        "Name"),
                                                            validator: (value) {
                                                              if (value ==
                                                                      null ||
                                                                  value
                                                                      .isEmpty) {
                                                                return 'Please enter your name';
                                                              }
                                                              return null;
                                                            },
                                                            onSaved:
                                                                (newValue) {
                                                              this
                                                                      .productForm
                                                                      .name =
                                                                  newValue;
                                                            },
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal: 8,
                                                                  vertical: 16),
                                                          child: TextFormField(
                                                            controller:
                                                                _descriptionFieldController,
                                                            // autovalidateMode:
                                                            //     AutovalidateMode
                                                            //         .onUserInteraction,
                                                            maxLength: 200,
                                                            onFieldSubmitted:
                                                                (text) {},
                                                            decoration: const InputDecoration(
                                                                counterText: '',
                                                                border:
                                                                    OutlineInputBorder(),
                                                                labelText:
                                                                    "Description"),
                                                            validator: (value) {
                                                              if (value ==
                                                                      null ||
                                                                  value
                                                                      .isEmpty) {
                                                                return 'Please enter your description';
                                                              }
                                                              return null;
                                                            },
                                                            onSaved:
                                                                (newValue) {
                                                              this
                                                                      .productForm
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
                                                                  horizontal: 8,
                                                                  vertical: 16),
                                                          child: TextFormField(
                                                            controller:
                                                                _priceFieldController,
                                                            // autovalidateMode:
                                                            //     AutovalidateMode
                                                            //         .onUserInteraction,
                                                            maxLength: 200,
                                                            onFieldSubmitted:
                                                                (text) {},
                                                            decoration:
                                                                const InputDecoration(
                                                                    counterText:
                                                                        '',
                                                                    border:
                                                                        OutlineInputBorder(),
                                                                    labelText:
                                                                        "Price"),
                                                            validator: (value) {
                                                              if (value ==
                                                                      null ||
                                                                  value
                                                                      .isEmpty) {
                                                                return 'Please enter your price';
                                                              }
                                                              return null;
                                                            },
                                                            onSaved:
                                                                (newValue) {
                                                              this
                                                                      .productForm
                                                                      .price =
                                                                  newValue;
                                                            },
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal: 8,
                                                                  vertical: 16),
                                                          child: TextFormField(
                                                            controller:
                                                                _stockFieldController,
                                                            // autovalidateMode:
                                                            //     AutovalidateMode
                                                            //         .onUserInteraction,
                                                            maxLength: 100,
                                                            onFieldSubmitted:
                                                                (text) {},
                                                            decoration:
                                                                const InputDecoration(
                                                                    counterText:
                                                                        '',
                                                                    border:
                                                                        OutlineInputBorder(),
                                                                    labelText:
                                                                        "Stocks"),
                                                            validator: (value) {
                                                              if (value ==
                                                                      null ||
                                                                  value
                                                                      .isEmpty) {
                                                                return 'Please enter your stocks';
                                                              }
                                                              return null;
                                                            },
                                                            onSaved:
                                                                (newValue) {
                                                              this
                                                                      .productForm
                                                                      .stocks =
                                                                  int.parse(
                                                                      newValue!);
                                                              ;
                                                            },
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal: 8,
                                                                  vertical: 16),
                                                          child: SwitchListTile(
                                                            value:
                                                                isGroup.value,
                                                            onChanged: (bool?
                                                                value) async {
                                                              await toggleIsCombo(
                                                                  value);
                                                            },
                                                            title: const Text(
                                                                'Combo'),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              if (isGroup.value)
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 8,
                                                      vertical: 16),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      IconButton(
                                                          onPressed: () {
                                                            addProductItem();
                                                          },
                                                          icon: Icon(
                                                            Icons.add_outlined,
                                                          ))
                                                    ],
                                                  ),
                                                ),
                                              if (isGroup.value)
                                                ...productGroupItems
                                                    .asMap()
                                                    .entries
                                                    .map((pi) {
                                                  return Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 8,
                                                        vertical: 16),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Obx(
                                                            () => DropdownMenu<
                                                                    Product>(
                                                                  controller:
                                                                      _controllerList[
                                                                          pi.key],
                                                                  width: 300,
                                                                  // initialSelection: ColorLabel.green,
                                                                  // controller: colorController,
                                                                  // requestFocusOnTap is enabled/disabled by platforms when it is null.
                                                                  // On mobile platforms, this is false by default. Setting this to true will
                                                                  // trigger focus request on the text field and virtual keyboard will appear
                                                                  // afterward. On desktop platforms however, this defaults to true.
                                                                  enableFilter:
                                                                      false,
                                                                  requestFocusOnTap:
                                                                      true,
                                                                  label: const Text(
                                                                      'Product Item'),
                                                                  onSelected:
                                                                      (Product?
                                                                          prodcut) {
                                                                    pi.value.sku =
                                                                        prodcut!
                                                                            .sku;
                                                                  },
                                                                  dropdownMenuEntries:
                                                                      dropDownProducts
                                                                          .map((element) =>
                                                                              DropdownMenuEntry<Product>(
                                                                                value: element,
                                                                                label: element.name,
                                                                                enabled: true,
                                                                              ))
                                                                          .toList(),
                                                                )),
                                                        Container(
                                                          width: 150,
                                                          child: TextFormField(
                                                            // autovalidateMode:
                                                            //     AutovalidateMode
                                                            //         .onUserInteraction,
                                                            maxLength: 100,
                                                            onFieldSubmitted:
                                                                (text) {},
                                                            decoration: const InputDecoration(
                                                                counterText: '',
                                                                border:
                                                                    OutlineInputBorder(),
                                                                labelText:
                                                                    "Quantity"),
                                                            validator: (value) {
                                                              if (value ==
                                                                      null ||
                                                                  value
                                                                      .isEmpty) {
                                                                return 'Please enter your quantity';
                                                              }
                                                              return null;
                                                            },
                                                            onSaved:
                                                                (newValue) {
                                                              pi.value.quantity =
                                                                  newValue!;
                                                            },
                                                          ),
                                                        ),
                                                        Container(
                                                          width: 150,
                                                          child: TextFormField(
                                                            maxLength: 100,
                                                            onFieldSubmitted:
                                                                (text) {},
                                                            decoration:
                                                                const InputDecoration(
                                                                    counterText:
                                                                        '',
                                                                    border:
                                                                        OutlineInputBorder(),
                                                                    labelText:
                                                                        "Price"),
                                                            onSaved:
                                                                (newValue) {},
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                }).toList(),
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
                                        ),
                                      ),
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
