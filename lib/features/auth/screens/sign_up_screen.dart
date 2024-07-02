import 'dart:convert';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:sixam_mart/features/language/controllers/language_controller.dart';
import 'package:sixam_mart/features/location/controllers/location_controller.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/features/auth/controllers/auth_controller.dart';
import 'package:sixam_mart/features/auth/domain/models/signup_body_model.dart';
import 'package:sixam_mart/features/auth/screens/sign_in_screen.dart';
import 'package:sixam_mart/features/auth/widgets/condition_check_box_widget.dart';
import 'package:sixam_mart/helper/custom_validator.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/custom_button.dart';
import 'package:sixam_mart/common/widgets/custom_snackbar.dart';
import 'package:sixam_mart/common/widgets/custom_text_field.dart';
import 'package:sixam_mart/common/widgets/menu_drawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  final FocusNode _isAddressFocus = FocusNode();
  final FocusNode _addressTypeFocus = FocusNode();
  final FocusNode _customerAddressFocus = FocusNode();
  final FocusNode _floorFocus = FocusNode();
  final FocusNode _roadFocus = FocusNode();
  final FocusNode _houseFocus = FocusNode();

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _contactPhoneFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  final FocusNode _referCodeFocus = FocusNode();

  final TextEditingController _firstNameController = TextEditingController();

  final TextEditingController _longitudeController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _contactPersonController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _referCodeController = TextEditingController();
  final TextEditingController _isAddressController = TextEditingController();
  final TextEditingController _addressTypeController = TextEditingController();
  final TextEditingController _customerAddressController = TextEditingController();
  final TextEditingController _floorController = TextEditingController();
  final TextEditingController _roadController = TextEditingController();
  final TextEditingController _houseController = TextEditingController();
  String? _countryDialCode;

  bool? value = false;
  String _currText = '';

  List<String> text = ["Is Adress"];

  @override
  void initState() {
    super.initState();

    _countryDialCode = CountryCode.fromCountryCode(Get.find<SplashController>().configModel!.country!).dialCode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ResponsiveHelper.isDesktop(context) ? Colors.transparent : Theme.of(context).cardColor,
      endDrawer: const MenuDrawer(), endDrawerEnableOpenDragGesture: false,
      body: SafeArea(child: Center(
        child: Container(
          width: context.width > 700 ? 700 : context.width,
          padding: context.width > 700 ? const EdgeInsets.all(0) : const EdgeInsets.all(Dimensions.paddingSizeLarge),
          margin: context.width > 700 ? const EdgeInsets.all(Dimensions.paddingSizeDefault) : null,
          decoration: context.width > 700 ? BoxDecoration(
            color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
          ) : null,
          child: GetBuilder<AuthController>(builder: (authController) {

            return SingleChildScrollView(
              child: Stack(
                children: [

                  ResponsiveHelper.isDesktop(context) ? Positioned(
                    top: 0,
                    right: 0,
                    child: Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        onPressed: () => Get.back(),
                        icon: const Icon(Icons.clear),
                      ),
                    ),
                  ) : const SizedBox(),


                  Padding(
                    padding: ResponsiveHelper.isDesktop(context) ? const EdgeInsets.all(40) : EdgeInsets.zero,
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

                      Image.asset(Images.logo, width: 125),
                      const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                      Align(
                        alignment: Alignment.topLeft,
                        child: Text('sign_up'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge)),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeDefault),

                      Row(children: [
                        Expanded(
                          child: CustomTextField(
                            titleText: 'first_name'.tr,
                            hintText: 'ex_jhon'.tr,
                            controller: _firstNameController,
                            focusNode: _firstNameFocus,
                            nextFocus: _lastNameFocus,
                            inputType: TextInputType.name,
                            capitalization: TextCapitalization.words,
                            prefixIcon: Icons.person,
                            showTitle: ResponsiveHelper.isDesktop(context),
                          ),
                        ),
                        const SizedBox(width: Dimensions.paddingSizeSmall),

                        Expanded(
                          child: CustomTextField(
                            titleText: 'last_name'.tr,
                            hintText: 'ex_doe'.tr,
                            controller: _lastNameController,
                            focusNode: _lastNameFocus,
                            nextFocus: _addressTypeFocus,
                            inputType: TextInputType.name,
                            capitalization: TextCapitalization.words,
                            prefixIcon: Icons.person,
                            showTitle: ResponsiveHelper.isDesktop(context),
                          ),
                        )
                      ]),
                      const SizedBox(height: Dimensions.paddingSizeDefault),



                      // Row(children: [
                      //   Expanded(
                      //     child: CustomTextField(
                      //       titleText: 'region'.tr,
                      //       hintText: 'ex_cairo'.tr,
                      //       controller: _regionController,
                      //       focusNode: _regionFocus,
                      //       nextFocus: _shopNameFocus,
                      //       inputType: TextInputType.name,
                      //       capitalization: TextCapitalization.words,
                      //       prefixIcon: Icons.place_outlined,
                      //       // showTitle: ResponsiveHelper.isDesktop(context),
                      //     ),
                      //   ),
                      //   const SizedBox(width: Dimensions.paddingSizeSmall),
                      //
                      //   Expanded(
                      //     child: CustomTextField(
                      //       titleText: 'shop_name'.tr,
                      //       hintText: 'ex_your_shop_name'.tr,
                      //       controller: _shopNameController,
                      //       focusNode: _shopNameFocus,
                      //       nextFocus: ResponsiveHelper.isDesktop(context) ? _emailFocus : _phoneFocus,
                      //       inputType: TextInputType.name,
                      //       capitalization: TextCapitalization.words,
                      //       prefixIcon: Icons.shop,
                      //       // showTitle: ResponsiveHelper.isDesktop(context),
                      //     ),
                      //   )
                      // ]),
                      // const SizedBox(height: Dimensions.paddingSizeDefault),

                      Row(
                        children: <Widget>[
                          SizedBox(width: 10,), //SizedBox
                          Text('You need to add address: ', style: TextStyle(fontSize: 15.0),), //Text
                          SizedBox(width: 10), //SizedBox
                          Checkbox(
                            value: value,
                            onChanged: (value) {
                              setState(() {
                                this.value = value;
                                _isAddressController.text="1";
                              });
                            },
                          ),
                        ],
                      ),



                      //Address
                      value! ? displayAddress(): SizedBox(height:  Dimensions.paddingSizeLarge ),
                      const SizedBox(height: Dimensions.paddingSizeDefault),



                      Row(
                        children: [

                          Expanded(
                            child: CustomTextField(
                              titleText: ResponsiveHelper.isDesktop(context) ? 'phone'.tr : 'enter_phone_number'.tr,
                              controller: _phoneController,
                              focusNode: _phoneFocus,
                              nextFocus: ResponsiveHelper.isDesktop(context) ? _passwordFocus : _contactPhoneFocus,
                              inputType: TextInputType.phone,
                              isPhone: true,
                              showTitle: ResponsiveHelper.isDesktop(context),
                              onCountryChanged: (CountryCode countryCode) {
                                _countryDialCode = countryCode.dialCode;
                              },
                              countryDialCode: _countryDialCode != null ? CountryCode.fromCountryCode(Get.find<SplashController>().configModel!.country!).code
                                  : Get.find<LocalizationController>().locale.countryCode,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: Dimensions.paddingSizeLarge),
                      !ResponsiveHelper.isDesktop(context) ? CustomTextField(
                        titleText: 'email'.tr,
                        hintText: 'enter_email'.tr,
                        controller: _emailController,
                        focusNode: _emailFocus,
                        nextFocus: _passwordFocus,
                        inputType: TextInputType.emailAddress,
                        prefixIcon: Icons.mail,
                      ) : const SizedBox(),
                      SizedBox(height: !ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeLarge : 0),

                      Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Expanded(
                          child: Column(children: [
                            CustomTextField(
                              titleText: 'password'.tr,
                              hintText: '8_character'.tr,
                              controller: _passwordController,
                              focusNode: _passwordFocus,
                              nextFocus: _confirmPasswordFocus,
                              inputType: TextInputType.visiblePassword,
                              prefixIcon: Icons.lock,
                              isPassword: true,
                              showTitle: ResponsiveHelper.isDesktop(context),
                            ),

                          ]),
                        ),
                        SizedBox(width: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeSmall : 0),

                        ResponsiveHelper.isDesktop(context) ? Expanded(child: CustomTextField(
                          titleText: 'confirm_password'.tr,
                          hintText: '8_character'.tr,
                          controller: _confirmPasswordController,
                          focusNode: _confirmPasswordFocus,
                          nextFocus: Get.find<SplashController>().configModel!.refEarningStatus == 1 ? _referCodeFocus : null,
                          inputAction: Get.find<SplashController>().configModel!.refEarningStatus == 1 ? TextInputAction.next : TextInputAction.done,
                          inputType: TextInputType.visiblePassword,
                          prefixIcon: Icons.lock,
                          isPassword: true,
                          showTitle: ResponsiveHelper.isDesktop(context),
                          onSubmit: (text) => (GetPlatform.isWeb) ? _register(authController, _countryDialCode!) : null,
                        )) : const SizedBox()

                      ]),
                      const SizedBox(height: Dimensions.paddingSizeLarge),

                      !ResponsiveHelper.isDesktop(context) ? CustomTextField(
                        titleText: 'confirm_password'.tr,
                        hintText: '8_character'.tr,
                        controller: _confirmPasswordController,
                        focusNode: _confirmPasswordFocus,
                        nextFocus: Get.find<SplashController>().configModel!.refEarningStatus == 1 ? _referCodeFocus : null,
                        inputAction: Get.find<SplashController>().configModel!.refEarningStatus == 1 ? TextInputAction.next : TextInputAction.done,
                        inputType: TextInputType.visiblePassword,
                        prefixIcon: Icons.lock,
                        isPassword: true,
                        onSubmit: (text) => (GetPlatform.isWeb) ? _register(authController, _countryDialCode!) : null,
                      ) : const SizedBox(),
                      SizedBox(height: !ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeLarge : 0),

                      (Get.find<SplashController>().configModel!.refEarningStatus == 1 ) ? CustomTextField(
                        titleText: 'refer_code'.tr,
                        hintText: 'enter_refer_code'.tr,
                        controller: _referCodeController,
                        focusNode: _referCodeFocus,
                        inputAction: TextInputAction.done,
                        inputType: TextInputType.text,
                        capitalization: TextCapitalization.words,
                        prefixImage: Images.referCode,
                        prefixSize: 14,
                        showTitle: ResponsiveHelper.isDesktop(context),
                      ) : const SizedBox(),
                      const SizedBox(height: Dimensions.paddingSizeLarge),

                      const ConditionCheckBoxWidget(forDeliveryMan: true),
                      const SizedBox(height: Dimensions.paddingSizeLarge),

                      CustomButton(
                        height: ResponsiveHelper.isDesktop(context) ? 45 : null,
                        width:  ResponsiveHelper.isDesktop(context) ? 180 : null,
                        radius: ResponsiveHelper.isDesktop(context) ? Dimensions.radiusSmall : Dimensions.radiusDefault,
                        isBold: !ResponsiveHelper.isDesktop(context),
                        fontSize: ResponsiveHelper.isDesktop(context) ? Dimensions.fontSizeExtraSmall : null,
                        buttonText: 'sign_up'.tr,
                        isLoading: authController.isLoading,
                        onPressed: authController.acceptTerms ? () => _register(authController, _countryDialCode!) : null,
                      ),

                      const SizedBox(height: Dimensions.paddingSizeLarge),

                      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Text('already_have_account'.tr, style: robotoRegular.copyWith(color: Theme.of(context).hintColor)),

                        InkWell(
                          onTap: () {
                            if(ResponsiveHelper.isDesktop(context)){
                              Get.back();
                              Get.dialog(const SignInScreen(exitFromApp: false, backFromThis: false));
                            }else{
                              if(Get.currentRoute == RouteHelper.signUp) {
                                Get.back();
                              } else {
                                Get.toNamed(RouteHelper.getSignInRoute(RouteHelper.signUp));
                              }
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                            child: Text('sign_in'.tr, style: robotoMedium.copyWith(color: Theme.of(context).primaryColor)),
                          ),
                        ),
                      ]),

                    ]),
                  ),

                ],
              ),
            );

          }),
        ),
      )),
    );
  }

  void _register(AuthController authController, String countryCode) async {
    String firstName = _firstNameController.text.trim();
    String lastName = _lastNameController.text.trim();
    String email = _emailController.text.trim();
    String number = _phoneController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();
    String referCode = _referCodeController.text.trim();

    String numberWithCountryCode = countryCode+number;
    PhoneValid phoneValid = await CustomValidator.isPhoneValid(numberWithCountryCode);
    numberWithCountryCode = phoneValid.phone;
    int isAddress=1;
    String addressType = _addressTypeController.text.trim();
    String customerAddress = _customerAddressController.text.trim();
    String floor = _floorController.text.trim();
    String road = _roadController.text.trim();
    String house = _houseController.text.trim();
    String longitude = '1';
    String latitude = '1';
    String contactPerson = _contactPersonController.text.trim();

    if (firstName.isEmpty) {
      showCustomSnackBar('enter_your_first_name'.tr);
    }else if (lastName.isEmpty) {
      showCustomSnackBar('enter_your_last_name'.tr);
    }else if (addressType.isEmpty) {
      showCustomSnackBar('enter_your_address_type');
    }else if (customerAddress.isEmpty) {
      showCustomSnackBar('enter_your_address'.tr);
    }else if (floor.isEmpty) {
      showCustomSnackBar('enter_your_floor'.tr);
    }else if (road.isEmpty) {
      showCustomSnackBar('enter_your_road'.tr);
    }else if (house.isEmpty) {
      showCustomSnackBar('enter_your_house'.tr);
    }else if (email.isEmpty) {
      showCustomSnackBar('enter_email_address'.tr);
    }else if (!GetUtils.isEmail(email)) {
      showCustomSnackBar('enter_a_valid_email_address'.tr);
    }else if (number.isEmpty) {
      showCustomSnackBar('enter_phone_number'.tr);
    }else if (!phoneValid.isValid) {
      showCustomSnackBar('invalid_phone_number'.tr);
    }else if (password.isEmpty) {
      showCustomSnackBar('enter_password'.tr);
    }else if (password.length < 6) {
      showCustomSnackBar('password_should_be'.tr);
    }else if (password != confirmPassword) {
      showCustomSnackBar('confirm_password_does_not_matched'.tr);
    }else {
      SignUpBodyModel signUpBody = SignUpBodyModel(
          fName: firstName, lName: lastName, email: email, phone: numberWithCountryCode,
          password: password, refCode: referCode,
          isAddress: isAddress, addressType: addressType,customerAddress: customerAddress,floor: floor,road: road,house: house,
        latitude: latitude, longitude: longitude,contactPerson: contactPerson
      );
      authController.registration(signUpBody).then((status) async {
        if (status.isSuccess) {
          if(Get.find<SplashController>().configModel!.customerVerification!) {
            List<int> encoded = utf8.encode(password);
            String data = base64Encode(encoded);
            Get.toNamed(RouteHelper.getVerificationRoute(numberWithCountryCode, status.message, RouteHelper.signUp, data));
          }else {
            Get.find<LocationController>().navigateToLocationScreen(RouteHelper.signUp);
            if(ResponsiveHelper.isDesktop(context)){
              Get.back();
            }
          }
        }else {
          showCustomSnackBar(status.message);
        }
      });
    }
  }

  Widget displayAddress() {
    return Column(
      children: [
        const SizedBox(height: Dimensions.paddingSizeDefault),
        Row(children: [

          Expanded(
            child: CustomTextField(
              titleText: 'address type',
              hintText: 'ex_home',
              controller: _addressTypeController,
              focusNode: _addressTypeFocus,
              nextFocus: _customerAddressFocus,
              inputType: TextInputType.name,
              capitalization: TextCapitalization.words,
              prefixIcon: Icons.home_work,
              // showTitle: ResponsiveHelper.isDesktop(context),
            ),
          ),
          const SizedBox(width: Dimensions.paddingSizeSmall),

          Expanded(
            child: CustomTextField(
              titleText: 'address',
              hintText: 'ex_cairo',
              controller: _customerAddressController,
              focusNode: _customerAddressFocus,
              nextFocus: _floorFocus,
              inputType: TextInputType.name,
              capitalization: TextCapitalization.words,
              prefixIcon: Icons.place_sharp,
              // showTitle: ResponsiveHelper.isDesktop(context),
            ),
          )
        ]),
        const SizedBox(height: Dimensions.paddingSizeDefault),

        Row(children: [
          Expanded(
            child: CustomTextField(
              titleText: 'floor',
              hintText: 'ex_ first',
              controller: _floorController,
              focusNode: _floorFocus,
              nextFocus: _roadFocus,
              inputType: TextInputType.name,
              capitalization: TextCapitalization.words,
              prefixIcon: Icons.place_outlined,
              // showTitle: ResponsiveHelper.isDesktop(context),
            ),
          ),
          const SizedBox(width: Dimensions.paddingSizeSmall),

          Expanded(
            child: CustomTextField(
              titleText: 'road',
              hintText: 'ex_bilbis road',
              controller: _roadController,
              focusNode: _roadFocus,
              nextFocus: _houseFocus,
              inputType: TextInputType.name,
              capitalization: TextCapitalization.words,
              prefixIcon: Icons.add_road,
              // showTitle: ResponsiveHelper.isDesktop(context),
            ),
          ),
          const SizedBox(width: Dimensions.paddingSizeSmall),

          Expanded(
            child: CustomTextField(
              titleText: 'house',
              hintText: 'ex_zahraa',
              controller: _houseController,
              focusNode: _houseFocus,
              nextFocus: _phoneFocus,
              inputType: TextInputType.name,
              capitalization: TextCapitalization.words,
              prefixIcon: Icons.house_outlined,
              // showTitle: ResponsiveHelper.isDesktop(context),
            ),
          ),


        ]),
        const SizedBox(height: Dimensions.paddingSizeDefault),

        Row(children: [
          ResponsiveHelper.isDesktop(context) ? Expanded(
            child: CustomTextField(
              titleText: 'email'.tr,
              hintText: 'enter_email'.tr,
              controller: _emailController,
              focusNode: _emailFocus,
              nextFocus: ResponsiveHelper.isDesktop(context) ? _phoneFocus : _passwordFocus,
              inputType: TextInputType.emailAddress,
              prefixImage: Images.mail,
              showTitle: ResponsiveHelper.isDesktop(context),
            ),
          ) : const SizedBox(),
          SizedBox(width: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeSmall : 0),





        ]),
        const SizedBox(height: Dimensions.paddingSizeLarge),

        Row(
          children:
          [
            const SizedBox(height: Dimensions.paddingSizeLarge),
            Expanded(
              child: CustomTextField(
                titleText: ResponsiveHelper.isDesktop(context) ? 'phone'.tr : 'Enter Contact Person number',
                controller: _contactPersonController,
                focusNode: _contactPhoneFocus,
                nextFocus: ResponsiveHelper.isDesktop(context) ? _passwordFocus : _emailFocus,
                inputType: TextInputType.phone,
                isPhone: true,
                onCountryChanged: (CountryCode countryCode) {
                  _countryDialCode = countryCode.dialCode;
                },
                countryDialCode: _countryDialCode != null ? CountryCode.fromCountryCode(Get.find<SplashController>().configModel!.country!).code
                    : Get.find<LocalizationController>().locale.countryCode,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
