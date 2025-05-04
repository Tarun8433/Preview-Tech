import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/colors.dart';

Widget inputTextHelper({
  required int fixedAmt,
  required TextEditingController controller,
  required RxInt product,
  required ValueChanged<String> ontap,
}) {
  return Column(
    children: [
      Wrap(
        alignment: WrapAlignment.end,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              "₹ ${fixedAmt.toString()} X",
              style: TextStyle(
                  color: whiteC, fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 150,
              child: TextFormField(
                controller: controller,
                style: TextStyle(color: whiteC),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: whiteC)),
                    disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: whiteC)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: whiteC))),
                onChanged: ontap,
              ),
            ),
          ),
          Obx(() => Text(
                " = ₹ ${product.value.toString()}",
                style: TextStyle(
                    color: whiteC, fontSize: 20, fontWeight: FontWeight.bold),
              )),
        ],
      )
    ],
  );
}
