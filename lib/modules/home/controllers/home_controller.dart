import 'package:animated_float_action_button/animated_floating_action_button.dart';
import 'package:cash_denomination/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:numbers_to_text/numbers_to_text.dart';

import '../../../services/db_helper.dart';
import '../models/denomination_model.dart';

class HomeController extends GetxController {

   RxInt totalOfProduct = 0.obs;
  RxString amtInString = "".obs;
  RxBool isEditMode = false.obs;
  var currentId = 0.obs;
  // Example methods to toggle states for demonstration
  void toggleEditMode() {
    isEditMode.value = !isEditMode.value;
  }
  
  void setAmount(int amount, String amountString) {
    totalOfProduct.value = amount;
    amtInString.value = amountString;
  }
  
  void clearAmount() {
    totalOfProduct.value = 0;
    amtInString.value = "";
  }
  late final NumbersToTextConverter converter;
  final DatabaseHelper dbHelper = DatabaseHelper();
 
  
  

  @override
  void onInit() {
    super.onInit();
    converter = NumbersToTextConverter("en");
  }

  final GlobalKey<AnimatedFloatingActionButtonState> fabKey = GlobalKey();

  var et2k = TextEditingController();
  var et500 = TextEditingController();
  var et200 = TextEditingController();
  var et100 = TextEditingController();
  var et50 = TextEditingController();
  var et20 = TextEditingController();
  var et10 = TextEditingController();
  var et5 = TextEditingController();
  var et2 = TextEditingController();
  var et1 = TextEditingController();

  var productFor2k = 0.obs;
  var productFor500 = 0.obs;
  var productFor200 = 0.obs;
  var productFor100 = 0.obs;
  var productFor50 = 0.obs;
  var productFor20 = 0.obs;
  var productFor10 = 0.obs;
  var productFor5 = 0.obs;
  var productFor2 = 0.obs;
  var productFor1 = 0.obs;

 

  void calculateProduct({
    required int fixedAmt,
    required int value,
    required RxInt product,
  }) {
    product.value = fixedAmt * value;
    print("product=====>> ${product.value}");

    totalOfProduct.value = productFor2k.value +
        productFor500.value +
        productFor200.value +
        productFor100.value +
        productFor50.value +
        productFor20.value +
        productFor10.value +
        productFor5.value +
        productFor2.value +
        productFor1.value;

    amtInString.value = converter.fromInt(totalOfProduct.value);
  }

  // Show save dialog
  void showSaveDialog() {
    final titleController = TextEditingController();
    final remarkController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: Text(isEditMode.value ? 'Update Entry' : 'Save Entry'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              style: TextStyle(color: darkBlueC),
              decoration: InputDecoration(
                labelText: 'Title',
                hintText: 'Enter a title for this entry',
              ),
            ),
            SizedBox(height: 10),
            TextField(
              style: TextStyle(color: darkBlueC),
              controller: remarkController,
              decoration: InputDecoration(
                labelText: 'Remark',
                hintText: 'Enter any remarks (optional)',
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.trim().isEmpty) {
                Get.snackbar(
                  'Error',
                  'Title is required',
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

              if (isEditMode.value) {
                _updateEntry(titleController.text, remarkController.text);
              } else {
                _saveEntry(titleController.text, remarkController.text);
              }

              Get.back();
            },
            child: Text(isEditMode.value ? 'Update' : 'Save'),
          ),
        ],
      ),
    );
  }

  // Save entry to database
  void _saveEntry(String title, String remark) async {
    final entry = DenominationModel(
      title: title,
      remark: remark,
      total: totalOfProduct.value,
      amountText: amtInString.value,
      d2000: int.tryParse(et2k.text) ?? 0,
      d500: int.tryParse(et500.text) ?? 0,
      d200: int.tryParse(et200.text) ?? 0,
      d100: int.tryParse(et100.text) ?? 0,
      d50: int.tryParse(et50.text) ?? 0,
      d20: int.tryParse(et20.text) ?? 0,
      d10: int.tryParse(et10.text) ?? 0,
      d5: int.tryParse(et5.text) ?? 0,
      d2: int.tryParse(et2.text) ?? 0,
      d1: int.tryParse(et1.text) ?? 0,
      createdAt: DateTime.now().toIso8601String(),
    );

    await dbHelper.insertDenomination(entry.toMap());
    Get.snackbar(
      'Success',
      'Entry saved successfully',
      backgroundColor: greenC,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      icon: const Icon(Icons.check_circle, color: Colors.white),
      duration: const Duration(seconds: 2),
    );
  }

  // Update entry in database
  void _updateEntry(String title, String remark) async {
    final entry = DenominationModel(
      id: currentId.value,
      title: title,
      remark: remark,
      total: totalOfProduct.value,
      amountText: amtInString.value,
      d2000: int.tryParse(et2k.text) ?? 0,
      d500: int.tryParse(et500.text) ?? 0,
      d200: int.tryParse(et200.text) ?? 0,
      d100: int.tryParse(et100.text) ?? 0,
      d50: int.tryParse(et50.text) ?? 0,
      d20: int.tryParse(et20.text) ?? 0,
      d10: int.tryParse(et10.text) ?? 0,
      d5: int.tryParse(et5.text) ?? 0,
      d2: int.tryParse(et2.text) ?? 0,
      d1: int.tryParse(et1.text) ?? 0,
      createdAt: DateTime.now().toIso8601String(),
    );

    await dbHelper.updateDenomination(entry.toMap());
    Get.snackbar(
      'Success',
      'Entry updated successfully',
      backgroundColor: greenC,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      icon: const Icon(Icons.check_circle, color: Colors.white),
      duration: const Duration(seconds: 2),
    );

    // Reset edit mode
    isEditMode.value = false;
    currentId.value = 0;
  }

  // Load entry for editing
  void loadEntry(DenominationModel entry) {
    isEditMode.value = true;
    currentId.value = entry.id!;

    et2k.text = entry.d2000.toString();
    et500.text = entry.d500.toString();
    et200.text = entry.d200.toString();
    et100.text = entry.d100.toString();
    et50.text = entry.d50.toString();
    et20.text = entry.d20.toString();
    et10.text = entry.d10.toString();
    et5.text = entry.d5.toString();
    et2.text = entry.d2.toString();
    et1.text = entry.d1.toString();

    // Recalculate all products
    calculateProduct(fixedAmt: 2000, value: entry.d2000, product: productFor2k);
    calculateProduct(fixedAmt: 500, value: entry.d500, product: productFor500);
    calculateProduct(fixedAmt: 200, value: entry.d200, product: productFor200);
    calculateProduct(fixedAmt: 100, value: entry.d100, product: productFor100);
    calculateProduct(fixedAmt: 50, value: entry.d50, product: productFor50);
    calculateProduct(fixedAmt: 20, value: entry.d20, product: productFor20);
    calculateProduct(fixedAmt: 10, value: entry.d10, product: productFor10);
    calculateProduct(fixedAmt: 5, value: entry.d5, product: productFor5);
    calculateProduct(fixedAmt: 2, value: entry.d2, product: productFor2);
    calculateProduct(fixedAmt: 1, value: entry.d1, product: productFor1);
  }

  // Clear all fields
  void clearFields() {
    et2k.clear();
    et500.clear();
    et200.clear();
    et100.clear();
    et50.clear();
    et20.clear();
    et10.clear();
    et5.clear();
    et2.clear();
    et1.clear();

    productFor2k.value = 0;
    productFor500.value = 0;
    productFor200.value = 0;
    productFor100.value = 0;
    productFor50.value = 0;
    productFor20.value = 0;
    productFor10.value = 0;
    productFor5.value = 0;
    productFor2.value = 0;
    productFor1.value = 0;

    totalOfProduct.value = 0;
    amtInString.value = "";

    isEditMode.value = false;
    currentId.value = 0;
  }
}
