import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:sixam_mart/features/category/controllers/category_controller.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/features/item/domain/models/item_model.dart';
import 'package:sixam_mart/features/store/domain/models/store_model.dart';
import 'package:sixam_mart/features/subcategory/subcategory_shimmer.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/cart_widget.dart';
import 'package:sixam_mart/common/widgets/item_view.dart';
import 'package:sixam_mart/common/widgets/menu_drawer.dart';
import 'package:sixam_mart/common/widgets/veg_filter_widget.dart';
import 'package:sixam_mart/common/widgets/web_menu_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;


import '../../../common/widgets/custom_image.dart';
import '../../../common/widgets/title_widget.dart';
import '../../../util/app_constants.dart';
import '../../brands/controllers/brands_controller.dart';
import '../../brands/domain/models/brands_model.dart';
import '../../brands/widgets/brands_view_shimmer_widget.dart';

class CategoryItemScreen extends StatefulWidget {
  final String? categoryID;
  final String categoryName;
  const CategoryItemScreen({super.key, required this.categoryID, required this.categoryName});

  @override
  CategoryItemScreenState createState() => CategoryItemScreenState();
}

class CategoryItemScreenState extends State<CategoryItemScreen> with TickerProviderStateMixin {
  final ScrollController scrollController = ScrollController();
  final ScrollController storeScrollController = ScrollController();
  TabController? _tabController;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  var sub_category_ids = [];
  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
    Get.find<CategoryController>().getSubCategoryList(widget.categoryID);
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent
          && Get.find<CategoryController>().categoryItemList != null
          && !Get.find<CategoryController>().isLoading) {
        int pageSize = (Get.find<CategoryController>().pageSize! / 10).ceil();
        if (Get.find<CategoryController>().offset < pageSize) {
          if (kDebugMode) {
            print('end of the page');
          }
          Get.find<CategoryController>().showBottomLoader();
          Get.find<CategoryController>().getCategoryItemList(
            Get.find<CategoryController>().subCategoryIndex == 0 ? widget.categoryID
                : Get.find<CategoryController>().subCategoryList![Get.find<CategoryController>().subCategoryIndex].id.toString(),
            Get.find<CategoryController>().offset+1, Get.find<CategoryController>().type, false,
          );
        }
      }
    });
    storeScrollController.addListener(() {
      if (storeScrollController.position.pixels == storeScrollController.position.maxScrollExtent
          && Get.find<CategoryController>().categoryStoreList != null
          && !Get.find<CategoryController>().isLoading) {
        int pageSize = (Get.find<CategoryController>().restPageSize! / 10).ceil();
        if (Get.find<CategoryController>().offset < pageSize) {
          if (kDebugMode) {
            print('end of the page');
          }
          Get.find<CategoryController>().showBottomLoader();
          Get.find<CategoryController>().getCategoryStoreList(
            Get.find<CategoryController>().subCategoryIndex == 0 ? widget.categoryID
                : Get.find<CategoryController>().subCategoryList![Get.find<CategoryController>().subCategoryIndex].id.toString(),
            Get.find<CategoryController>().offset+1, Get.find<CategoryController>().type, false,
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoryController>(builder: (catController) {
      List<Item>? item;
      List<Store>? stores;
      if(catController.isSearching ? catController.searchItemList != null : catController.categoryItemList != null) {
        item = [];
        if (catController.isSearching) {
          item.addAll(catController.searchItemList!);
        } else {
          item.addAll(catController.categoryItemList!);
        }
      }
      if(catController.isSearching ? catController.searchStoreList != null : catController.categoryStoreList != null) {
        stores = [];
        if (catController.isSearching) {
          stores.addAll(catController.searchStoreList!);
        } else {
          stores.addAll(catController.categoryStoreList!);
        }
      }
      getBrandByCategoryList(String? categoryID,  ) async {
        // '${AppConstants.brandCategoryUri}/$categoryID'
        String url = "${AppConstants.baseUrl}${AppConstants.brandCategoryUri}/$categoryID";
        final  response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          var sub_cat = jsonDecode(response.body);
          print("response 2222 =========> ${ sub_cat }");
          if(sub_cat['brands'] == 0){
            sub_category_ids = [];
          }else{
            sub_category_ids = sub_cat['brands'];
          }
          print("response 1111 =========> ${ sub_cat['brands'] }");
        }

      }

      getProductByBrandList (String? categoryID) async {

      }
      return PopScope(
        canPop: true,
        onPopInvoked: (didPop) async {
          if(catController.isSearching) {
            catController.toggleSearch();
          }else {
            return;
          }
        },
        child: Scaffold(
          appBar: (ResponsiveHelper.isDesktop(context) ? const WebMenuBar() : AppBar(
            title: catController.isSearching ? TextField(
              autofocus: true,
              textInputAction: TextInputAction.search,
              decoration: const InputDecoration(
                hintText: 'Search...',
                border: InputBorder.none,
              ),
              style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
              onSubmitted: (String query) {
                catController.searchData(
                  query, catController.subCategoryIndex == 0 ? widget.categoryID
                    : catController.subCategoryList![catController.subCategoryIndex].id.toString(),
                  catController.type,
                );
              }
            ) : Text(widget.categoryName, style: robotoRegular.copyWith(
              fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge!.color,
            )),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              color: Theme.of(context).textTheme.bodyLarge!.color,
              onPressed: () {
                if(catController.isSearching) {
                  catController.toggleSearch();
                }else {
                  Get.back();
                }
              },
            ),
            backgroundColor: Theme.of(context).cardColor,
            elevation: 0,
            actions: [
              IconButton(
                onPressed: () => catController.toggleSearch(),
                icon: Icon(
                  catController.isSearching ? Icons.close_sharp : Icons.search,
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                ),
              ),
              IconButton(
                onPressed: () => Get.toNamed(RouteHelper.getCartRoute()),
                icon: CartWidget(color: Theme.of(context).textTheme.bodyLarge!.color, size: 25),
              ),

              VegFilterWidget(type: catController.type, fromAppBar: true, onSelected: (String type) {
                if(catController.isSearching) {
                  catController.searchData(
                    catController.subCategoryIndex == 0 ? widget.categoryID
                        : catController.subCategoryList![catController.subCategoryIndex].id.toString(), '1', type,
                  );
                }else {
                  if(catController.isStore) {
                    catController.getCategoryStoreList(
                      catController.subCategoryIndex == 0 ? widget.categoryID
                          : catController.subCategoryList![catController.subCategoryIndex].id.toString(), 1, type, true,
                    );
                  }else {
                    catController.getCategoryItemList(
                      catController.subCategoryIndex == 0 ? widget.categoryID
                          : catController.subCategoryList![catController.subCategoryIndex].id.toString(), 1, type, true,
                    );
                  }
                }
              }),
            ],
          )),
          endDrawer: const MenuDrawer(),endDrawerEnableOpenDragGesture: false,
          body: GetBuilder<BrandsController>(
            builder: (brandsController) {
              return LayoutBuilder(
                  builder: (ctx, constraints) {
                  return Center(child: SizedBox(
                     width: Dimensions.webMaxWidth,
                    child: Column(children: [

                      //subcategories list text
                      // (catController.subCategoryList != null && !catController.isSearching) ? Center(child: Container(
                      //   height: 40, width: Dimensions.webMaxWidth, color: Theme.of(context).cardColor,
                      //   padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
                      //   child: ListView.builder(
                      //     key: scaffoldKey,
                      //     scrollDirection: Axis.horizontal,
                      //     itemCount: catController.subCategoryList!.length,
                      //     padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
                      //     physics: const BouncingScrollPhysics(),
                      //     itemBuilder: (context, index) {
                      //       return InkWell(
                      //         onTap: () => catController.setSubCategoryIndex(index, widget.categoryID),
                      //         child: Container(
                      //           width: 60,
                      //
                      //           padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
                      //           margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                      //           decoration: BoxDecoration(
                      //             borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      //             // color: index == catController.subCategoryIndex ? Theme.of(context).primaryColor.withOpacity(0.1) : Colors.transparent,
                      //             color: Colors.transparent,
                      //           ),
                      //           child: Column(mainAxisAlignment: MainAxisAlignment.center,
                      //               children: [
                      //
                      //                 Text(
                      //                   maxLines: 1,
                      //                   overflow: TextOverflow.ellipsis,
                      //                   catController.subCategoryList![index].name!,
                      //                   style: index == catController.subCategoryIndex
                      //                   ? robotoMedium.copyWith(fontSize: Dimensions.paddingSizeSmall, color: Theme.of(context).primaryColor)
                      //                   : robotoRegular.copyWith(fontSize: Dimensions.paddingSizeSmall),
                      //             ),
                      //
                      //
                      //             //image
                      //             // catController.subCategoryList![index].name != "All" ? CustomImage(
                      //             //   image: '${Get.find<SplashController>().configModel!.baseUrls!.categoryImageUrl}/${catController.subCategoryList![index].image}',
                      //             //   height: 75, width: 75, fit: BoxFit.cover,
                      //             // ) : const SizedBox(),
                      //           ]),
                      //         ),
                      //       );
                      //     },
                      //   ),
                      // )) : const SizedBox(),

                      //subcategories list image


                      Center(child: Container(
                        width: Dimensions.webMaxWidth,
                        color: Theme.of(context).cardColor,
                        child: TabBar(
                          physics: NeverScrollableScrollPhysics(),
                          controller: _tabController,
                          indicatorColor: Theme.of(context).primaryColor,
                          indicatorWeight: 3,
                          labelColor: Theme.of(context).primaryColor,
                          unselectedLabelColor: Theme.of(context).disabledColor,
                          unselectedLabelStyle: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall),
                          labelStyle: robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
                          tabs: [
                            Tab(text: 'item'.tr),
                            Tab(text: Get.find<SplashController>().configModel!.moduleConfig!.module!.showRestaurantText!
                                ? 'restaurants'.tr : 'stores'.tr),
                          ],
                        ),
                      )),


                      Expanded(child: NotificationListener(
                        onNotification: (dynamic scrollNotification) {
                          if (scrollNotification is ScrollEndNotification) {
                            if((_tabController!.index == 1 && !catController.isStore) || _tabController!.index == 0 && catController.isStore) {
                              catController.setRestaurant(_tabController!.index == 1);
                              if(catController.isSearching) {
                                catController.searchData(
                                  catController.searchText, catController.subCategoryIndex == 0 ? widget.categoryID
                                    : catController.subCategoryList![catController.subCategoryIndex].id.toString(), catController.type,
                                );
                              }else {
                                if(_tabController!.index == 1) {
                                  catController.getCategoryStoreList(
                                    catController.subCategoryIndex == 0 ? widget.categoryID
                                        : catController.subCategoryList![catController.subCategoryIndex].id.toString(),
                                    1, catController.type, false,
                                  );
                                }else {
                                  catController.getCategoryItemList(
                                    catController.subCategoryIndex == 0 ? widget.categoryID
                                        : catController.subCategoryList![catController.subCategoryIndex].id.toString(),
                                    1, catController.type, false,
                                  );
                                }
                              }
                            }
                          }
                          return false;
                        },
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            SingleChildScrollView(
                              controller: scrollController,
                              child: Column(
                                children: [

                                  (catController.subCategoryList != null && !catController.isSearching) ? Center(
                                      child: Container(
                                        // height: 100,
                                        width: Dimensions.webMaxWidth, color: Theme.of(context).cardColor,
                                        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),

                                        // child: ListView.builder(
                                        //   // key: scaffoldKey,
                                        //   scrollDirection: Axis.horizontal,
                                        //   itemCount: catController.subCategoryList!.length,
                                        //   padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
                                        //   physics: const BouncingScrollPhysics(),
                                        //   itemBuilder: (context, index) {
                                        //     return InkWell(
                                        //       onTap: () => catController.setSubCategoryIndex(index, widget.categoryID),
                                        //       child: Container(
                                        //         width: 100,
                                        //
                                        //         padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
                                        //         margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                                        //         decoration: BoxDecoration(
                                        //           borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                        //           color: index == catController.subCategoryIndex ? Theme.of(context).primaryColor.withOpacity(0.1) : Colors.transparent,
                                        //         ),
                                        //         child: Column(mainAxisAlignment: MainAxisAlignment.center,
                                        //             children: [
                                        //
                                        //
                                        //               // image
                                        //               catController.subCategoryList![index].name != "All" ? Expanded(
                                        //                 flex: 3,
                                        //                 child: CustomImage(
                                        //                   image: '${Get.find<SplashController>().configModel!.baseUrls!.categoryImageUrl}/${catController.subCategoryList![index].image}',
                                        //                   height: 70, width: 75, fit: BoxFit.cover,
                                        //                 ),
                                        //               ) : Image.asset('assets/image/all_product.png'),
                                        //
                                        //               Expanded(
                                        //                 child: Text(
                                        //
                                        //                   catController.subCategoryList![index].name!,
                                        //                   style: index == catController.subCategoryIndex
                                        //                       ? robotoMedium.copyWith(fontSize: Dimensions.paddingSizeSmall, color: Theme.of(context).primaryColor)
                                        //                       : robotoRegular.copyWith(fontSize: Dimensions.paddingSizeSmall),
                                        //                 ),
                                        //               ),
                                        //             ]),
                                        //       ),
                                        //     );
                                        //   },
                                        // ),

                                        child:  GridView.builder(
                                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 4, // number of items in each row
                                            mainAxisSpacing:5, // spacing between rows
                                            crossAxisSpacing: 0, // spacing between columns
                                          ),
                                          // physics: NeverScrollableScrollPhysics(),
                                          padding: EdgeInsets.zero,
                                          // scrollDirection: Axis.vertical,
                                          itemCount: catController.subCategoryList!.length,
                                          shrinkWrap: true,
                                          itemBuilder: (BuildContext context, int index) {
                                            return InkWell(
                                              onTap: () {
                                                catController.setSubCategoryIndex(index, widget.categoryID);
                                                print("catController.setSubCategory ====> ${catController.GetsetSubCategoryIndex(index, widget.categoryID)}");
                                                getBrandByCategoryList(catController.GetsetSubCategoryIndex(index, widget.categoryID));
                                              },
                                              child: Container(
                                                width: 50,
                                                height: 50,
                                                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
                                                margin: const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                                  color: index == catController.subCategoryIndex ? Theme.of(context).primaryColor.withOpacity(0.1) : Colors.transparent,
                                                ),
                                                child: Column(mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [

                                                      // image
                                                      catController.subCategoryList![index].name != "all".tr? Expanded(
                                                        flex: 1,
                                                        child: CustomImage(
                                                          image: '${Get.find<SplashController>().configModel!.baseUrls!.categoryImageUrl}/${catController.subCategoryList![index].image}',
                                                          height: 70, width: 75, fit: BoxFit.cover,
                                                        ),
                                                      ) : Image.asset('assets/image/all_products.png'),

                                                      catController.subCategoryList![index].name != "all".tr? Expanded(
                                                        flex: 1,
                                                        child: Text(

                                                          catController.subCategoryList![index].name!,
                                                          style: index == catController.subCategoryIndex
                                                              ? robotoMedium.copyWith(fontSize: Dimensions.paddingSizeSmall, color: Theme.of(context).primaryColor)
                                                              : robotoRegular.copyWith(fontSize: Dimensions.paddingSizeSmall),
                                                        ),
                                                      ) : const SizedBox(),

                                                    ]),
                                              ),
                                            );

                                          },
                                        ),
                                      )) : const SubCategorViewShimmer(),

                                  // Padding(
                                  //   padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                                  //   child: TitleWidget(
                                  //     title: 'brands'.tr,
                                  //     onTap: () => Get.toNamed(RouteHelper.getBrandsScreen()),
                                  //   ),
                                  // ),
                                  sub_category_ids.length !=0 ? GridView.builder(
                                      shrinkWrap: true,
                                     // scrollDirection: Axis.horizontal,
                                      padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 5,
                                          crossAxisSpacing: 1,
                                          mainAxisSpacing: 0,
                                          childAspectRatio: 1.0,
                                        ),
                                  itemCount: sub_category_ids.length,

                                  itemBuilder: (BuildContext context, int index) {
                                    // return Container(
                                    //   height: 50,
                                    //   color: Colors.lightBlue,
                                    //   child: Column(
                                    //       children:
                                    //       [
                                    //         CustomImage(
                                    //           image: '${Get.find<SplashController>().configModel!.baseUrls!.brandImageUrl}storage/app/public/brand/${sub_category_ids[index]['image']}',
                                    //           height: 70, width: 75, fit: BoxFit.cover,
                                    //         ),
                                    //         Text('${sub_category_ids[index]['name']}'),
                                    //       ],
                                    //
                                    //   ),
                                    // );
                                    return Column(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).disabledColor.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                          ),
                                          child: InkWell(
                                            onTap: () {
                                              //Get.toNamed(RouteHelper.getBrandsItemScreen(brandsController.brandList![index].id!, brandsController.brandList![index].name!));
                                              getBrandByCategoryList(catController.GetsetSubCategoryIndex(index, widget.categoryID));
                                            },
                                            child: ClipRRect(
                                            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                            child: CustomImage(
                                              image: '${Get.find<SplashController>().configModel!.baseUrls!.brandImageUrl}/${sub_category_ids[index]['image']}',
                                              height: 40, width: 60, fit: BoxFit.cover,
                                            ),
                                          ),
                                          ),


                                        ),
                                        // SizedBox(height: 1,),
                                        Text('${sub_category_ids[index]['name']}'),
                                      ],
                                    );
                                  }
                              ) : Container(),
                                  // brandsController.brandList != null ? GridView.builder(
                                  //   // scrollDirection: Axis.horizontal,
                                  //   shrinkWrap: true,
                                  //   // physics: const NeverScrollableScrollPhysics(),
                                  //   padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                                  //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  //     crossAxisCount: 5,
                                  //     crossAxisSpacing: 13, mainAxisSpacing: 0,
                                  //     childAspectRatio: 1.0,
                                  //   ),
                                  //   itemCount: brandsController.brandList!.length > 8 ? 8 : brandsController.brandList!.length,
                                  //   itemBuilder: (context, index) {
                                  //     return Container(
                                  //       padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                                  //       decoration: BoxDecoration(
                                  //         color: Theme.of(context).disabledColor.withOpacity(0.1),
                                  //         borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                  //       ),
                                  //       child: InkWell(
                                  //         onTap: () => Get.toNamed(RouteHelper.getBrandsItemScreen(brandsController.brandList![index].id!, brandsController.brandList![index].name!)),
                                  //         child: ClipRRect(
                                  //           borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                  //           child: CustomImage(
                                  //             image: '${Get.find<SplashController>().configModel!.baseUrls!.brandImageUrl}/${brandsController.brandList![index].image}',
                                  //             height: 60, width: 60,
                                  //           ),
                                  //         ),
                                  //       ),
                                  //     );
                                  //   },
                                  // ) : const BrandViewShimmer(),

                                  SizedBox(height: 8,),
                                  ItemsView(
                                    isStore: false, items: item, stores: null, noDataText: 'no_category_item_found'.tr,
                                  ),
                                ],
                              ),
                            ),
                            SingleChildScrollView(
                              controller: storeScrollController,
                              child: ItemsView(
                                isStore: true, items: null, stores: stores,
                                noDataText: Get.find<SplashController>().configModel!.moduleConfig!.module!.showRestaurantText!
                                    ? 'no_category_restaurant_found'.tr : 'no_category_store_found'.tr,
                              ),
                            ),
                          ],
                        ),
                      )),

                      catController.isLoading ? Center(child: Padding(
                        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                        child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
                      )) : const SizedBox(),

                    ]),
                  ));
                }
              );
            }
          ),
        ),
      );
    });
  }
}


