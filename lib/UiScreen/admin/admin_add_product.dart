import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:overlay_support/overlay_support.dart';
import 'package:snow_remover/components/product_details_form.dart';
import 'package:snow_remover/components/toast_message/ios_Style.dart';
import 'package:snow_remover/constant.dart' as constant;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:snow_remover/models/product_model.dart';
import 'package:snow_remover/utility.dart' as utility;

class AddEditProduct extends StatefulWidget {
  const AddEditProduct({Key? key}) : super(key: key);

  @override
  State<AddEditProduct> createState() => _AddEditProductState();
}

class _AddEditProductState extends State<AddEditProduct> {
  bool show = false;
  // String fileExtension = "";
  File? _image;
  var imagePicker;
  String imageSource = "Gallery";
  @override
  void initState() {
    imagePicker = ImagePicker();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            bottom: const PreferredSize(
              preferredSize: Size.fromHeight(20),
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  "Product Details",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            )),
        body: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(70, 0, 40, 20),
                  child: Center(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          show = !show;
                        });
                      },
                      child: _image != null
                          ? Image.file(
                              _image!,
                              height: screenHeight * 0.35,
                              width: screenWidth * 0.50,
                            )
                          : Image(
                              height: screenHeight * 0.35,
                              width: screenWidth * 0.50,
                              image: NetworkImage(constant.dummyUploadImg)),
                    ),
                  ),
                ),
                ProductDetailsForm(
                  resetImage: resetImage,
                  postData: postProductToFirestore,
                )
              ]),
        ),
        bottomSheet: _showBottomSheet());
  }

  Widget? _showBottomSheet() {
    if (show) {
      return BottomSheet(
        onClosing: () {},
        builder: (context) {
          return popText(context);
        },
      );
    } else {
      return null;
    }
  }

  Widget popText(BuildContext context) {
    return Container(
      color: constant.primaryColor,
      height: 100,
      child: Container(
        width: double.infinity,
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
              // crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                    child: Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  child: InkWell(
                      onTap: () async {
                        XFile? image = await retrieveImagePath("Camera");
                        // fileExtension = p.extension(image!.path);
                        setState(() {
                          show = false;
                          _image = image != null ? File(image.path) : _image;
                        });
                      },
                      child: const Text(
                        "Camera",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.white),
                      )),
                )),
                const SizedBox(height: 5, child: Divider(color: Colors.black)),
                Expanded(
                    child: Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  child: InkWell(
                      onTap: () async {
                        XFile? image = await retrieveImagePath("Gallery");
                        setState(() {
                          show = false;
                          _image = image != null ? File(image.path) : _image;
                        });
                      },
                      child: const Text(
                        "Gallery",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.white),
                      )),
                )),
              ]),
        ),
      ),
    );
  }

  Future<XFile?> retrieveImagePath(String source) async {
    ImagePicker picker = ImagePicker();
    ImageSource sourcePicked = ImageSource.gallery;
    switch (source) {
      case 'Gallery':
        sourcePicked = ImageSource.gallery;
        break;
      case 'Camera':
        sourcePicked = ImageSource.camera;
        break;
    }
    return await picker.pickImage(
        source: sourcePicked,
        imageQuality: 50,
        preferredCameraDevice: CameraDevice.front);
  }

  void resetImage() {
    print("did this execute");
    setState(() {
      _image = null;
    });
  }

  postProductToFirestore(ProductModel obj) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    ProductModel prod = obj;
    obj.mainImage = fileName;
    await firebaseFirestore.collection("products").add(obj.toMap());
    utility.uploadFile(_image!, "products", fileName);
    showOverlay((context, t) {
      return Opacity(
        opacity: t,
        child: const IosStyleToast(label: "Product Added Successfully"),
      );
    });
  }
}
