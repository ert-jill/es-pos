import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/services/transaction_controller.dart';
import '../models/area.dart';
import '../models/form.dart';
import '../models/order.dart';
import '../models/table.dart';
import '../models/order.dart';
import '../services/area_controller.dart';
import '../services/cash_registry_service.dart';
import '../services/table_controller.dart';

enum DineModule { table, order }

class DineWidget extends StatelessWidget {
  final List<DraggableTableController> controllers =
      List.generate(3, (_) => DraggableTableController());
  Rx<DineModule> selectedModule = DineModule.table.obs;
  DineWidget({super.key});
  getDineModuleWidget(DineModule selectedModule) {
    switch (selectedModule) {
      case DineModule.table:
        return table();
      case DineModule.order:
        return Orders();
      default:
        return table();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Center(
            child: Obx(() => SegmentedButton<DineModule>(
                  showSelectedIcon: false,
                  segments: <ButtonSegment<DineModule>>[
                    ButtonSegment<DineModule>(
                      value: DineModule.table,
                      label: Text('Tables'),

                      // icon: Icon(Icons.calendar_view_day)
                    ),
                    ButtonSegment<DineModule>(
                      value: DineModule.order,
                      label: Text('Orders'),
                      // icon: Icon(Icons.calendar_view_week)
                    ),
                  ],
                  selected: <DineModule>{selectedModule.value},
                  onSelectionChanged: (Set<DineModule> newSelection) {
                    selectedModule.value = newSelection.first;
                  },
                )),
          ),
          Expanded(child: Obx(() => getDineModuleWidget(selectedModule.value))),
        ],
      ),
    );
  }

  table() {
    return AreaTableWidget();
  }
}

class Orders extends StatelessWidget {
  CashRegistryService cashRegistryService = Get.find<CashRegistryService>();
  Orders({
    super.key,
  });
  RxList<Order> orders = RxList.empty();
  onInit() async {
    orders.value = await cashRegistryService.orderController.getOrderList();
  }

  openOrder(Order order) async {
    cashRegistryService.navigateTo(CashRegistryModule.order);
  }

  @override
  Widget build(BuildContext context) {
    onInit();
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Text('Orders'),
          Expanded(
              child: Obx(() => ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, i) => Card(
                        child: ListTile(
                          onTap: () {
                            openOrder(orders[i]);
                          },
                          title: Text(orders[i].id.toString()),
                          subtitle: Text(orders[i].customer.toString()),
                        ),
                      ))))
        ],
      ),
    );
  }
}

class AreaTableWidget extends StatelessWidget {
  CashRegistryService cashRegistryService = Get.find<CashRegistryService>();
  List<DraggableTableController> controllers = List.empty();
  final AreaController areaController =
      Get.put<AreaController>(AreaController());
  final TableController tableController =
      Get.put<TableController>(TableController());

  final Rx<Area?> selectedArea = new Rx(null);

  RxString updatingTableLocation = ''.obs;
  onInit() async {
    await areaController.getAreaList();
    // tableController.get();
    selectedArea.value = areaController.areaList.firstOrNull;
    await getTables();
    controllers = List.generate(
        tableController.tableList.length, (_) => DraggableTableController());
  }

  selectArea(Area? area) {
    selectedArea.value = area;
    getTables();
  }

  getTables() async {
    await tableController.getTables(selectedArea.value!.id.toString());
    print(tableController.tableList.length.toString());
  }

  void onPanUpdate(Rx<dynamic> table, DragUpdateDetails details) {
    table.value.left += details.delta.dx;
    table.value.top += details.delta.dy;
    table.refresh();
    // print('${table.left.value} - ${table.top.value}');
  }

  makeAnOrder(String tables) async {
    Map<String, dynamic>? result = await Get.dialog<Map<String, dynamic>>(
      ConfirmationDialog(),
      barrierDismissible: false,
    );
    if (result != null && result['confirmed'] == true) {
      // User confirmed, proceed with action
      String customerName = result['customer'];
      OrderFormModel orderFormModel = OrderFormModel();
      orderFormModel.customer = customerName;
      orderFormModel.tables = tables;
      Response response =
          await cashRegistryService.orderController.createOrder(orderFormModel);
      if (response.isOk) {
        Order order = Order.fromJson(response.body);
        cashRegistryService.navigateTo(CashRegistryModule.order);
      }
    }
  }

  openOrder(BigInt id) async {
    await cashRegistryService.orderController.selectOrder(id);
    cashRegistryService.navigateTo(CashRegistryModule.order);
  }

  final List<Widget> icons = <Widget>[Icon(Icons.drag_indicator)];
  final RxList<RxBool> _selectedVegetables = <RxBool>[false.obs].obs;

  @override
  Widget build(BuildContext context) {
    onInit();
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 250,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: LayoutBuilder(builder: (context, constraints) {
                    return SizedBox(
                        width: double.infinity,
                        child: Obx(() => DropdownButtonFormField<Area>(
                              value: selectedArea.value,
                              style: const TextStyle(
                                  overflow: TextOverflow.ellipsis),
                              decoration: InputDecoration(
                                counterText: '',
                                labelText: 'Area',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              // onSaved: (newValue) {
                              //   selectedArea.value = newValue;
                              // },
                              items: areaController.areaList
                                  .map((element) => DropdownMenuItem<Area>(
                                        value: element,
                                        child: Text(
                                          element.name,
                                          softWrap: true,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ))
                                  .toList(),
                              onChanged: (Area? value) {
                                selectArea(value);
                              },
                              onTap: () {},
                            )));
                  }),
                ),
              ),
              Spacer(),
              Obx(() => ToggleButtons(
                    direction: Axis.horizontal,
                    onPressed: (int index) {
                      _selectedVegetables[index].value =
                          !_selectedVegetables[index].value;
                      _selectedVegetables.refresh();
                    },
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    // selectedBorderColor: Colors.green[700],
                    // selectedColor: Colors.white,
                    // fillColor: Colors.green[200],
                    // color: Colors.green[400],
                    constraints: const BoxConstraints(
                      minHeight: 40.0,
                      minWidth: 80.0,
                    ),
                    isSelected:
                        _selectedVegetables.map((e) => e.value).toList(),
                    children: icons,
                  )),
            ],
          ),
          Expanded(
            child: Obx(() => Stack(
                  children:
                      List.generate(tableController.tableList.length, (index) {
                    return Positioned(
                        left: tableController.tableList[index].value.left,
                        top: tableController.tableList[index].value.top,
                        child: Obx(() => GestureDetector(
                              onTap: () {
                                (tableController.tableList[index].value.order !=
                                        null)
                                    ? openOrder(tableController
                                            .tableList[index].value.order ??
                                        BigInt.from(0))
                                    : makeAnOrder(tableController
                                        .tableList[index].value.id
                                        .toString());
                              },
                              onPanUpdate: updatingTableLocation.value ==
                                          tableController
                                              .tableList[index].value.id
                                              .toString() ||
                                      _selectedVegetables.value[0].value ==
                                          false
                                  ? null
                                  : (details) {
                                      onPanUpdate(
                                          tableController.tableList[index],
                                          details);
                                      //  tableController.tableList[index].value.left += details.delta.dx;
                                      //   tableController.tableList[index].value.top += details.delta.dy;
                                      //   tableController.tableList[index].refresh();
                                    },
                              onPanEnd: updatingTableLocation.value ==
                                          tableController
                                              .tableList[index].value.id
                                              .toString() ||
                                      _selectedVegetables.value[0].value ==
                                          false
                                  ? null
                                  : (d) async {
                                      //save location
                                      TableFormModel tableFormModel =
                                          TableFormModel();
                                      tableFormModel.id = tableController
                                          .tableList[index].value.id
                                          .toString();
                                      tableFormModel.left = tableController
                                          .tableList[index].value.left
                                          .toString();
                                      tableFormModel.top = tableController
                                          .tableList[index].value.top
                                          .toString();
                                      updatingTableLocation.value =
                                          tableController
                                              .tableList[index].value.id
                                              .toString();
                                      await tableController
                                          .updateTable(tableFormModel);
                                      updatingTableLocation.value = '';
                                    },
                              child: Container(
                                width: 200,
                                height: 200,
                                color: Colors.blue,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Table : ${tableController.tableList[index].value.name}',
                                      // style: TextStyle(color: Colors.white),
                                    ),
                                    if (tableController
                                            .tableList[index].value.order !=
                                        null)
                                      Text(
                                          'Order No : ${tableController.tableList[index].value.order.toString()}')
                                  ],
                                ),
                              ),
                            )));
                  }),
                )),
          ),
        ],
      ),
    );
  }
}

class DraggableTableController extends GetxController {
  late RxDouble left = 0.0.obs;
  late RxDouble top = 0.0.obs;

  void onPanUpdate(DragUpdateDetails details) {
    left.value += details.delta.dx;
    top.value += details.delta.dy;
    print('${left.value} - ${top.value}');
  }
}

class ConfirmationDialog extends StatelessWidget {
  final TextEditingController customerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Confirm Action'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Are you sure you want to proceed?'),
          TextField(
            controller: customerController,
            decoration: InputDecoration(
              hintText: 'Enter customer name',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Get.back(result: {'confirmed': false});
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Get.back(result: {
              'confirmed': true,
              'customer': customerController.text
            });
          },
          child: Text('Confirm'),
        ),
      ],
    );
  }
}
