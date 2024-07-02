import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/common/widgets/custom_snackbar.dart';
import 'package:sixam_mart/features/cart/controllers/cart_controller.dart';
import 'package:sixam_mart/features/item/controllers/item_controller.dart';
import 'package:sixam_mart/features/item/domain/models/item_model.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';

import '../../features/cart/domain/models/cart_model.dart';
import '../../features/checkout/domain/models/place_order_body_model.dart';
import '../../features/splash/controllers/splash_controller.dart';
import '../../helper/price_converter.dart';
class CartCountView extends StatelessWidget {
  final Item? item;
  final Variation? variations;
  final Widget? child;
  const CartCountView({super.key,   this.item, this.child, this.variations});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(
      builder: (cartController) {
        return  GetBuilder<ItemController>
          (builder: (itemController) {
          int cartQty = cartController.cartQuantity(item!.id!);
          int cartIndex = cartController.isExistInCart(item!.id, cartController.cartVariant(item!.id!), false, null);
          int? maxqqq=0;
          int? stock = 0;
          cartController.getCartId(itemController.cartIndex);
          if(itemController.item != null && itemController.variationIndex != null){
            List<String> variationList = [];
            for (int index = 0; index < itemController.item!.choiceOptions!.length; index++) {
              variationList.add(itemController.item!.choiceOptions![index].options![itemController.variationIndex! [index]].replaceAll(' ', ''));
            }
            String variationType = '';
            bool isFirst = true;
            for (var variation in variationList) {
              if (isFirst) {
                variationType = '$variationType$variation';
                isFirst = false;
              } else {
                variationType = '$variationType-$variation';
              }
            }

            stock = itemController.item!.stock ?? 0;
             maxqqq=0;
            for (Variation v in itemController.item!.variations!) {
              if (v.type == variationType) {
                // stock = v.stock;
                maxqqq = v.maxVariations;
                break;
              }
            }

            double addonsCost = 0;
            List<AddOn> addOnIdList = [];
            List<AddOns> addOnsList = [];
            for (int index = 0; index < itemController.item!.addOns!.length; index++) {
              if (itemController.addOnActiveList[index]) {
                addonsCost = addonsCost + (itemController.item!.addOns![index].price! * itemController.addOnQtyList[index]!);
                addOnIdList.add(AddOn(id: itemController.item!.addOns![index].id, quantity: itemController.addOnQtyList[index]));
                addOnsList.add(itemController.item!.addOns![index]);
              }
            }


            _getSelectedAddonIds(addOnIdList: addOnIdList);
            _getSelectedAddonQtnList(addOnIdList: addOnIdList);

          }
          return cartQty != 0 ? Center(
            child: Container(
              width: 100,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
              ),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                InkWell(
                  onTap: cartController.isLoading ? null : () {
                    if (cartController.cartList[cartIndex].quantity! > 1) {
                      cartController.setQuantity(false, cartIndex, cartController.cartList[cartIndex].stock, cartController.cartList[cartIndex].item!.quantityLimit);
                    }else {
                      cartController.removeFromCart(cartIndex);
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: Theme.of(context).primaryColor),
                    ),
                    padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                    child: Icon(
                      Icons.remove, size: 16, color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                  child: !cartController.isLoading ? Text(
                    cartQty.toString(),
                    style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).cardColor),
                  ) : SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Theme.of(context).cardColor)),
                ),

                InkWell(
                  onTap: cartController.isLoading ? null : () {

                    // cartController.setQuantity(true, cartIndex, cartController.cartList[cartIndex].stock, cartController.cartList[cartIndex].quantityLimit);
                    if (cartController.cartList[cartIndex].quantity! < cartController.cartList[cartIndex].stock!) {
                      cartController.setQuantity(true, cartIndex, cartController.cartList[cartIndex].stock, cartController.cartList[cartIndex].item!.quantityLimit);
                    }else  {
                      showCustomSnackBar("This Product is Out Of Stock!",getXSnackBar: true);
                    }
                  },

                  // onTap: cartController.isLoading ? null : () {
                  //
                  //   if (itemController.item!.quantityLimit == null ){
                  //     itemController.item!.quantityLimit = itemController.item!.stock;
                  //
                  //   }else if (maxqqq == 0 ){
                  //     maxqqq = itemController.item!.quantityLimit;
                  //   }
                  //   else if(itemController.cartIndex != -1 ) {
                  //     print("var mohsen fffuyffyy=================>  ${maxqqq}");
                  //
                  //     cartController.setQuantity(true, cartIndex, cartController.cartList[cartIndex].stock, cartController.cartList[cartIndex].item!.quantityLimit);
                  //     //cartController.setQuantity(true, itemController.cartIndex, stock, cartController.cartList[itemController.cartIndex].quantityLimit);
                  //
                  //   }else if (itemController.quantity! +1 <= maxqqq! ){
                  //     print("var mohsen fffuyffyy=================>  ${maxqqq}");
                  //     print("var itemController.quantityy=================>  ${itemController.quantity}");
                  //     itemController.setQuantity(true, stock, itemController.item!.quantityLimit);
                  //
                  //   }else if( cartController.cartList[cartIndex].quantity! >= cartController.cartList[cartIndex].stock!){
                  //     showCustomSnackBar('out_of_stock'.tr );
                  //
                  //   }else {
                  //     showCustomSnackBar("Maximum order is ${maxqqq}");
                  //   }
                  // },

                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: Theme.of(context).primaryColor),
                    ),
                    padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                    child: Icon(
                      Icons.add, size: 16, color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ]),
            ),
          ) : InkWell(
            onTap: () {
              Get.find<ItemController>().itemDirectlyAddToCart(item, context);
            },
            child: child ?? Container(
              height: 25, width: 25,
              decoration: BoxDecoration(
                shape: BoxShape.circle, color: Theme.of(context).cardColor,
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)]
              ),
              child: Icon(Icons.add, size: 20, color: Theme.of(context).primaryColor),
            ),
          );
        });
      }
    );
  }
  List<int?> _getSelectedAddonIds({required List<AddOn> addOnIdList }) {
    List<int?> listOfAddOnId = [];
    for (var addOn in addOnIdList) {
      listOfAddOnId.add(addOn.id);
    }
    return listOfAddOnId;
  }

  List<int?> _getSelectedAddonQtnList({required List<AddOn> addOnIdList }) {
    List<int?> listOfAddOnQty = [];
    for (var addOn in addOnIdList) {
      listOfAddOnQty.add(addOn.quantity);
    }
    return listOfAddOnQty;
  }

}
