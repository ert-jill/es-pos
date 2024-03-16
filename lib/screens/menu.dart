import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/screens/dine.dart';

import '../services/cash_registry_service.dart';

enum MenuModule { search, dineIn, takeOut, deliver }

class Menu extends StatelessWidget {
  CashRegistryService cashRegistryService = Get.find<CashRegistryService>();
  Rx<MenuModule> selectedMenu = MenuModule.search.obs;
  Menu({
    super.key,
  });

  getWidget(MenuModule selected) {
    switch (selected) {
      case MenuModule.search:
        return getSearchWidget();
      case MenuModule.takeOut:
        return getTakeOutWidget();
      case MenuModule.dineIn:
        return DineWidget();
      default:
        return getSearchWidget();
    }
  }

  Column getTakeOutWidget() {
    return Column(
      children: [
        // Container(
        //   color: Colors.white,
        //   child: Padding(
        //     padding:
        //         const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        //     child: TextFormField(
        //       maxLength: 200,
        //       onFieldSubmitted: (text) {},
        //       decoration: const InputDecoration(
        //           counterText: '',
        //           border: OutlineInputBorder(),
        //           labelText: "Search Order"),
        //       validator: (value) {
        //         if (value == null || value.isEmpty) {
        //           return 'Please enter name';
        //         }
        //         return null;
        //       },
        //       onSaved: (newValue) {},
        //     ),
        //   ),
        // ),
        Expanded(
            child: GridView(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4, childAspectRatio: 1.5),
          children: [
            Card(
              color: Colors.blueGrey,
              child: Center(child: Text('Add New')),
            ),
            Card(
              child: Center(child: Text('found')),
            ),
            Card(
              child: Center(child: Text('found')),
            ),
            Card(
              child: Center(child: Text('found')),
            ),
            Card(
              child: Center(child: Text('found')),
            ),
            Card(
              child: Center(child: Text('found')),
            ),
            Card(
              child: Center(child: Text('found')),
            ),
            Card(
              child: Center(child: Text('found')),
            ),
            Card(
              child: Center(child: Text('found')),
            ),
          ],
        ))
      ],
    );
  }

  Column getSearchWidget() {
    return Column(
      children: [
        Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextFormField(
              maxLength: 200,
              onFieldSubmitted: (text) {},
              decoration: const InputDecoration(
                  counterText: '',
                  border: OutlineInputBorder(),
                  labelText: "Search Order"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter name';
                }
                return null;
              },
              onSaved: (newValue) {},
            ),
          ),
        ),
        Expanded(
            child: GridView(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4, childAspectRatio: 1.5),
          children: [
            Card(
              child: Center(child: Text('found')),
            ),
            Card(
              child: Center(child: Text('found')),
            ),
            Card(
              child: Center(child: Text('found')),
            ),
            Card(
              child: Center(child: Text('found')),
            ),
            Card(
              child: Center(child: Text('found')),
            ),
            Card(
              child: Center(child: Text('found')),
            ),
            Card(
              child: Center(child: Text('found')),
            ),
            Card(
              child: Center(child: Text('found')),
            ),
            Card(
              child: Center(child: Text('found')),
            ),
          ],
        ))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
              child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.blue,
            child: Obx(() => getWidget(selectedMenu.value)),
          )),
          Container(
            padding: EdgeInsets.all(5),
            width: double.infinity,
            height: 100,
            color: Colors.black,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: InkWell(
                    onTap: () {
                      selectedMenu.value = MenuModule.search;
                    },
                    child: Container(
                      color: Colors.orange,
                      width: 150,
                      height: double.infinity,
                      alignment: Alignment.center,
                      child: Text('SEARCH',
                          style: TextStyle(fontSize: 20, color: Colors.white)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: InkWell(
                    onTap: () {
                      selectedMenu.value = MenuModule.takeOut;
                    },
                    child: Container(
                        color: Colors.white,
                        height: double.infinity,
                        width: 150,
                        alignment: Alignment.center,
                        child: Text('TO GO', style: TextStyle(fontSize: 20))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: InkWell(
                      onTap: () {
                        selectedMenu.value = MenuModule.dineIn;
                      },
                      child: Container(
                          color: Colors.white,
                          height: double.infinity,
                          width: 150,
                          alignment: Alignment.center,
                          child:
                              Text('DINING', style: TextStyle(fontSize: 20)))),
                ),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Container(
                      alignment: Alignment.center,
                      color: Colors.white,
                      height: double.infinity,
                      width: 150,
                      child: Text('DELIVERY', style: TextStyle(fontSize: 20))),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Container(
                    color: Colors.red,
                    height: double.infinity,
                    width: 150,
                    alignment: Alignment.center,
                    child: InkWell(
                      onTap: () {
                        cashRegistryService
                            .navigateTo(CashRegistryModule.clockIn);
                      },
                      child: Text(
                        'CLOCK OUT',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
