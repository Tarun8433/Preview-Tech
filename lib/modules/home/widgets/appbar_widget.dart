import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/colors.dart';

 

class EnhancedSliverAppBar extends StatelessWidget {
  final RxInt totalOfProduct;
  final RxString amtInString;
  final RxBool isEditMode;
  final Color whiteC;
  final Color darkBlueC;

  const EnhancedSliverAppBar({
    super.key,
    required this.totalOfProduct,
    required this.amtInString,
    required this.isEditMode,
    this.whiteC = Colors.white,
    this.darkBlueC = const Color(0xFF0A2463),
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 180,
      stretch: true,
      floating: false,
      elevation: 0,
      backgroundColor: darkBlueC,
      title: _buildDenominationView(),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Background image with gradient overlay
            ShaderMask(
              shaderCallback: (rect) {
                return LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    primaryC.withValues(alpha:0.7),
                    primaryC.withValues(alpha:0.5),
                  ],
                ).createShader(rect);
              },
              blendMode: BlendMode.darken,
              child: Image.asset(
                "assets/images/currency_banner.jpg",
                fit: BoxFit.cover,
              ),
            ),

            // Blur overlay in edit mode
            Obx(() => AnimatedOpacity(
                  duration: Duration(milliseconds: 300),
                  opacity: isEditMode.value ? 1.0 : 0.0,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                    child: Container(color: Colors.transparent),
                  ),
                )),

            // Content at the bottom
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Obx(() => AnimatedSwitcher(
                      duration: Duration(milliseconds: 400),
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: Offset(0.0, 0.2),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          ),
                        );
                      },
                      child: totalOfProduct.value != 0
                          ? _buildTotalAmountView()
                          : SizedBox()
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalAmountView() {
    return Column(
      key: ValueKey('total-amount'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: whiteC.withValues(alpha:0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "Total Amount",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: whiteC,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            Spacer(),
            Obx(() =>
                isEditMode.value ? _buildEditModeIndicator() : SizedBox.shrink()),
          ],
        ),
        SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "${totalOfProduct.value}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 32,
                color: whiteC,
                letterSpacing: -0.5,
                height: 1,
              ),
            ),
            SizedBox(width: 8),
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                "₹",
                style: TextStyle(
                  color: yellowC[300],
                  fontSize: 24,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 4),
        SizedBox(
          width: Get.width - 40,
          child: Text(
            amtInString.value.isNotEmpty
                ? amtInString.value[0].toUpperCase() + amtInString.value.substring(1)
                : "",
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16,
              color: whiteC.withValues(alpha:0.9),
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDenominationView() {
    return Row(
      key: ValueKey('denomination'),
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              "₹",
              style: TextStyle(
                color: yellowC[300],
                fontSize: 24,
              ),
            ),
            SizedBox(width: 10),
            Text(
              "Denomination",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: whiteC,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        Obx(() =>
            isEditMode.value ? _buildEditModeIndicator() : SizedBox.shrink()),
      ],
    );
  }

  Widget _buildEditModeIndicator() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [yellowC, orangeC],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .2),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.edit,
            color: darkBlueC,
            size: 14,
          ),
          SizedBox(width: 4),
          Text(
            "Edit Mode",
            style: TextStyle(
              color: darkBlueC,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

}
