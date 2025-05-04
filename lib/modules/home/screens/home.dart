import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/colors.dart';
import '../../history/view/history_view.dart';
import '../controllers/home_controller.dart';
import '../widgets/appbar_widget.dart';
import '../widgets/input_text_helper.dart';
import 'package:animated_float_action_button/animated_floating_action_button.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});
  final controller = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryC,
      body: CustomScrollView(
        slivers: [
          EnhancedSliverAppBar(
            totalOfProduct: controller.totalOfProduct,
            amtInString: controller.amtInString,
            isEditMode: controller.isEditMode,
            whiteC: whiteC,
            darkBlueC: darkBlueC,
          ),
        
          SliverToBoxAdapter(
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    inputTextHelper(
                      fixedAmt: 2000,
                      controller: controller.et2k,
                      product: controller.productFor2k,
                      ontap: (value) {
                        controller.calculateProduct(
                          fixedAmt: 2000,
                          value: int.tryParse(value) ?? 0,
                          product: controller.productFor2k,
                        );
                      },
                    ),
                    inputTextHelper(
                      fixedAmt: 500,
                      controller: controller.et500,
                      product: controller.productFor500,
                      ontap: (value) {
                        controller.calculateProduct(
                          fixedAmt: 500,
                          value: int.tryParse(value) ?? 0,
                          product: controller.productFor500,
                        );
                      },
                    ),
                    inputTextHelper(
                      fixedAmt: 200,
                      controller: controller.et200,
                      product: controller.productFor200,
                      ontap: (value) {
                        controller.calculateProduct(
                          fixedAmt: 200,
                          value: int.tryParse(value) ?? 0,
                          product: controller.productFor200,
                        );
                      },
                    ),
                    inputTextHelper(
                      fixedAmt: 100,
                      controller: controller.et100,
                      product: controller.productFor100,
                      ontap: (value) {
                        controller.calculateProduct(
                          fixedAmt: 100,
                          value: int.tryParse(value) ?? 0,
                          product: controller.productFor100,
                        );
                      },
                    ),
                    inputTextHelper(
                      fixedAmt: 50,
                      controller: controller.et50,
                      product: controller.productFor50,
                      ontap: (value) {
                        controller.calculateProduct(
                          fixedAmt: 50,
                          value: int.tryParse(value) ?? 0,
                          product: controller.productFor50,
                        );
                      },
                    ),
                    inputTextHelper(
                      fixedAmt: 20,
                      controller: controller.et20,
                      product: controller.productFor20,
                      ontap: (value) {
                        controller.calculateProduct(
                          fixedAmt: 20,
                          value: int.tryParse(value) ?? 0,
                          product: controller.productFor20,
                        );
                      },
                    ),
                    inputTextHelper(
                      fixedAmt: 10,
                      controller: controller.et10,
                      product: controller.productFor10,
                      ontap: (value) {
                        controller.calculateProduct(
                          fixedAmt: 10,
                          value: int.tryParse(value) ?? 0,
                          product: controller.productFor10,
                        );
                      },
                    ),
                    inputTextHelper(
                      fixedAmt: 5,
                      controller: controller.et5,
                      product: controller.productFor5,
                      ontap: (value) {
                        controller.calculateProduct(
                          fixedAmt: 5,
                          value: int.tryParse(value) ?? 0,
                          product: controller.productFor5,
                        );
                      },
                    ),
                    inputTextHelper(
                      fixedAmt: 2,
                      controller: controller.et2,
                      product: controller.productFor2,
                      ontap: (value) {
                        controller.calculateProduct(
                          fixedAmt: 2,
                          value: int.tryParse(value) ?? 0,
                          product: controller.productFor2,
                        );
                      },
                    ),
                    inputTextHelper(
                      fixedAmt: 1,
                      controller: controller.et1,
                      product: controller.productFor1,
                      ontap: (value) {
                        controller.calculateProduct(
                          fixedAmt: 1,
                          value: int.tryParse(value) ?? 0,
                          product: controller.productFor1,
                        );
                      },
                    ),
                  ],
                )),
          )
        ],
      ),
      floatingActionButton: AnimatedFloatingActionButton(
        key: controller.fabKey,
        fabButtons: <Widget>[
          saveButton(),
          historyButton(),
          clearButton(),
        ],
        colorStartAnimation: Colors.blue,
        colorEndAnimation: Colors.red,
        animatedIconData: AnimatedIcons.menu_close,
      ),
    );
  }

  Widget saveButton() {
    return FloatActionButtonText(
      onPressed: () {
        controller.fabKey.currentState!.animate();

        if (controller.totalOfProduct.value == 0) {
          Get.snackbar(
            'Error',
            'Please enter at least one denomination',
            backgroundColor: redC,
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP,
            margin: const EdgeInsets.all(16),
            borderRadius: 12,
            icon: const Icon(Icons.cancel, color: Colors.white),
            duration: const Duration(seconds: 2),
          );
          return;
        }

        controller.showSaveDialog();
      },
      icon: Icons.save,
      text: "Save",
      textLeft: -95,
    );
  }

  Widget historyButton() {
    return FloatActionButtonText(
      onPressed: () {
        controller.fabKey.currentState!.animate();
        Get.to(() => HistoryView());
      },
      icon: Icons.history,
      textLeft: -110,
      text: "History",
    );
  }

  Widget clearButton() {
    return FloatActionButtonText(
      onPressed: () {
        controller.fabKey.currentState!.animate();
        controller.clearFields();
      },
      icon: Icons.clear_all,
      textLeft: -100,
      text: "Clear",
    );
  }
}


