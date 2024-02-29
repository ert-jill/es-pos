import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/models/account.dart';
import 'package:pos/models/user_type.dart';
import 'package:pos/services/user_type_controller.dart';

import '../models/form.dart';
import '../services/account_controller.dart';
import '../services/snack_bar_service.dart';
import '../services/user_service.dart';

class UserForm extends StatelessWidget {
  final AccountController accountController = Get.put(AccountController());
  final UserTypeConroller userTypeConroller = Get.put(UserTypeConroller());
  final UserService userService = Get.find<UserService>();
  UserFormModel userForm = UserFormModel();
  String? _password;
  RxBool isLoading = false.obs;
  RxBool isSubmitting = false.obs;
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
  TextEditingController _usernameFieldController = TextEditingController();
  TextEditingController _emailFieldController = TextEditingController();
  TextEditingController _passwordFieldController = TextEditingController();
  TextEditingController _confirmPasswordFieldController =
      TextEditingController();
  TextEditingController _firstNameFieldController = TextEditingController();
  TextEditingController _lastNameFieldController = TextEditingController();

  UserForm({
    super.key,
  });
  final userFormKey = GlobalKey<FormState>();
  onInit() async {
    isLoading.value = true;
    await userTypeConroller.getUserTypes();
    await accountController.getAccountList();
    isLoading.value = false;
  }

  submit() async {
    if (userFormKey.currentState!.validate()) {
      userFormKey.currentState!.save();
      isSubmitting.value = true;
      try {
        var response = await userService.signUpUser(userForm);
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

  void clearAllTextControllers() {
    _usernameFieldController.clear();
    _emailFieldController.clear();
    _passwordFieldController.clear();
    _confirmPasswordFieldController.clear();
    _firstNameFieldController.clear();
    _lastNameFieldController.clear();
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
                              'Create User',
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
                                                                _firstNameFieldController,
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
                                                                    "First Name"),
                                                            validator: (value) {
                                                              if (value ==
                                                                      null ||
                                                                  value
                                                                      .isEmpty) {
                                                                return 'Please enter your username/email';
                                                              }
                                                              return null;
                                                            },
                                                            onSaved:
                                                                (newValue) {
                                                              this
                                                                      .userForm
                                                                      .firstName =
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
                                                                _lastNameFieldController,
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
                                                                    "Last Name"),
                                                            validator: (value) {
                                                              if (value ==
                                                                      null ||
                                                                  value
                                                                      .isEmpty) {
                                                                return 'Please enter your username/email';
                                                              }
                                                              return null;
                                                            },
                                                            onSaved:
                                                                (newValue) {
                                                              this
                                                                      .userForm
                                                                      .lastName =
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
                                                                _emailFieldController,
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
                                                                        "Email"),
                                                            validator: (value) {
                                                              if (value ==
                                                                      null ||
                                                                  value
                                                                      .isEmpty) {
                                                                return 'Please enter your username/email';
                                                              }
                                                              return null;
                                                            },
                                                            onSaved:
                                                                (newValue) {
                                                              this
                                                                      .userForm
                                                                      .email =
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
                                                          child: LayoutBuilder(
                                                              builder: (context,
                                                                  constraints) {
                                                            return SizedBox(
                                                                width: double
                                                                    .infinity,
                                                                child: Obx(() =>
                                                                    DropdownButtonFormField<
                                                                        Account>(
                                                                      style: const TextStyle(
                                                                          overflow:
                                                                              TextOverflow.ellipsis),
                                                                      value: userService
                                                                          .user
                                                                          .value!
                                                                          .account,
                                                                      decoration:
                                                                          InputDecoration(
                                                                        counterText:
                                                                            '',
                                                                        labelText:
                                                                            'User Account',
                                                                        border:
                                                                            OutlineInputBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(5),
                                                                        ),
                                                                      ),
                                                                      validator:
                                                                          (value) {
                                                                        if (value ==
                                                                            null) {
                                                                          return 'Please select an option';
                                                                        }
                                                                        return null;
                                                                      },
                                                                      onSaved:
                                                                          (newValue) {
                                                                        this.userForm.userAccount = newValue!
                                                                            .id
                                                                            .toString()
                                                                            .toString();
                                                                      },
                                                                      items: (userService.user.value?.account != null &&
                                                                              userService.user.value!.userType ==
                                                                                  null)
                                                                          ? [
                                                                              DropdownMenuItem<Account>(
                                                                                value: userService.user.value!.account,
                                                                                enabled: userService.user.value!.account!.status,
                                                                                child: Text(
                                                                                  userService.user.value!.account!.name,
                                                                                  softWrap: true,
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                ),
                                                                              )
                                                                            ]
                                                                          : accountController
                                                                              .accountList
                                                                              .map((element) => DropdownMenuItem<Account>(
                                                                                    value: element,
                                                                                    enabled: element.status,
                                                                                    child: Text(
                                                                                      element!.name,
                                                                                      softWrap: true,
                                                                                      overflow: TextOverflow.ellipsis,
                                                                                    ),
                                                                                  ))
                                                                              .toList(),
                                                                      onChanged:
                                                                          (Account?
                                                                              value) {},
                                                                      onTap: (userService.user.value?.account != null &&
                                                                              userService.user.value!.userType == null)
                                                                          ? null
                                                                          : () {},
                                                                    )));
                                                          }),
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
                                                          child: LayoutBuilder(
                                                              builder: (context,
                                                                  constraints) {
                                                            return SizedBox(
                                                                width: double
                                                                    .infinity,
                                                                child: Obx(() =>
                                                                    DropdownButtonFormField<
                                                                        UserType>(
                                                                      autovalidateMode:
                                                                          AutovalidateMode
                                                                              .onUserInteraction,
                                                                      decoration:
                                                                          const InputDecoration(
                                                                        labelText:
                                                                            'User Type',
                                                                        border:
                                                                            OutlineInputBorder(),
                                                                      ),
                                                                      validator:
                                                                          (value) {
                                                                        if (value ==
                                                                            null) {
                                                                          return 'Please select an option';
                                                                        }
                                                                        return null;
                                                                      },
                                                                      onSaved:
                                                                          (newValue) {
                                                                        this.userForm.userType = newValue!
                                                                            .id
                                                                            .toString()
                                                                            .toString();
                                                                      },
                                                                      items: userTypeConroller
                                                                          .userTypeList
                                                                          .map<DropdownMenuItem<UserType>>((UserType
                                                                              userType) {
                                                                        return DropdownMenuItem<
                                                                            UserType>(
                                                                          value:
                                                                              userType,
                                                                          child:
                                                                              Text(userType.name),
                                                                          // label: userType.name,
                                                                          // enabled: userType.isActive,
                                                                          // style: MenuItemButton.styleFrom(
                                                                          //   foregroundColor: color.color,
                                                                          // ),
                                                                        );
                                                                      }).toList(),
                                                                      onChanged:
                                                                          (UserType?
                                                                              value) {},
                                                                      // onChanged: null,r
                                                                      onTap: isLoading
                                                                              .value
                                                                          ? () {}
                                                                          : null,
                                                                    )));
                                                          }),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal: 8,
                                                                  vertical: 16),
                                                          child: TextFormField(
                                                            controller:
                                                                _usernameFieldController,
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
                                                                    "Username"),
                                                            validator: (value) {
                                                              if (value ==
                                                                      null ||
                                                                  value
                                                                      .isEmpty) {
                                                                return 'Please enter your username/email';
                                                              }
                                                              return null;
                                                            },
                                                            onSaved:
                                                                (newValue) {
                                                              this
                                                                      .userForm
                                                                      .userName =
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
                                                                _passwordFieldController,
                                                            // autovalidateMode:
                                                            //     AutovalidateMode
                                                            //         .onUserInteraction,
                                                            maxLength: 100,
                                                            onFieldSubmitted:
                                                                (text) {},
                                                            obscureText: true,
                                                            onChanged: (value) {
                                                              _password = value;
                                                              userForm.password =
                                                                  value;
                                                            },
                                                            decoration: const InputDecoration(
                                                                counterText: '',
                                                                border:
                                                                    OutlineInputBorder(),
                                                                labelText:
                                                                    "Password"),
                                                            validator: (value) {
                                                              if (value ==
                                                                      null ||
                                                                  value
                                                                      .isEmpty) {
                                                                return 'Please enter your username/email';
                                                              }
                                                              return null;
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
                                                                _confirmPasswordFieldController,
                                                            // autovalidateMode:
                                                            //     AutovalidateMode
                                                            //         .onUserInteraction,
                                                            maxLength: 100,
                                                            onFieldSubmitted:
                                                                (text) {},
                                                            obscureText: true,
                                                            decoration: const InputDecoration(
                                                                counterText: '',
                                                                border:
                                                                    OutlineInputBorder(),
                                                                labelText:
                                                                    "Confirm Password"),
                                                            validator: (value) {
                                                              if (value ==
                                                                      null ||
                                                                  value
                                                                      .isEmpty) {
                                                                return 'Please enter your username/email';
                                                              }
                                                              if (value.length <
                                                                  _password!
                                                                      .length) {
                                                                return '';
                                                              }
                                                              if (value !=
                                                                  _password) {
                                                                return 'Passwords do not match';
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
