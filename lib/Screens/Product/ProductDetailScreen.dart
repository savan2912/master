import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_html/flutter_html.dart'; // HTML render karva mate
import 'package:gotilo_new/Api/ApiCalls.dart';
import 'package:gotilo_new/Api/Request/Product/RequestProductDetail.dart';
import 'package:gotilo_new/Api/Response/Product/ResponseProductDetail.dart';
import 'package:gotilo_new/CustomeWidgets/CustomAppbar.dart';
import 'package:gotilo_new/CustomeWidgets/SharedWidgets.dart';
import 'package:gotilo_new/MyApplication/MyApplication.dart';

import '../../Api/Request/Cart/RequestAddCart.dart';
import '../../Api/Response/Cart/ResponseAddCart.dart';
import '../../Constant/AppPref.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;
  final int listId;
  const ProductDetailScreen({super.key, required this.productId,required this.listId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  ProductDetail? product;
  int quantity = 1;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    callProductDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        title: "Product Information",
        showBackButton: true,
        showAction: false,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : product == null
          ? const Center(child: Text("Product not found"))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey.shade200),
                    image: DecorationImage(
                      image: NetworkImage(product?.thumbnail ?? ""),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Text(
                          "In Stock",
                          style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        product?.name ?? "Product Name",
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF2D3436),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "₹ ${product?.unitPrice ?? "0.00"}",
                        style: GoogleFonts.montserrat(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFFE91E63),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildQuantitySelector(),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),

            RichText(
              text: TextSpan(
                text: 'Category: ',
                style: GoogleFonts.montserrat(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
                children: [
                  TextSpan(
                    text: product?.categoryName ?? "General",
                    style: GoogleFonts.montserrat(fontWeight: FontWeight.w400, color: Colors.grey.shade700),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Text(
              "Description:",
              style: GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Html(
              data: product?.details ?? "No description available.",
              style: {
                "body": Style(
                  fontSize: FontSize(14.0),
                  color: Colors.grey.shade600,
                  fontFamily: 'Montserrat',
                  margin: Margins.zero,
                  padding: HtmlPaddings.zero,
                ),
                "p": Style(
                  lineHeight: LineHeight(1.5),
                ),
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: product != null ? _buildBottomAction() : null,
    );
  }

  Widget _buildQuantitySelector() {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            if (quantity > 1) setState(() => quantity--);
          },
          child: const Icon(Icons.remove_circle, color: Color(0xFF2D3436), size: 28),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            "$quantity",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        GestureDetector(
          onTap: () => setState(() => quantity++),
          child: const Icon(Icons.add_circle, color: Color(0xFF2D3436), size: 28),
        ),
      ],
    );
  }

  Widget _buildBottomAction() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton.icon(
            onPressed: () {
              callAddCart(
                name: product?.name,
                price: product?.unitPrice,
                productid: int.parse(product!.id!),
                qty: quantity
              );
            },
            icon: const Icon(Icons.shopping_cart_outlined, size: 18, color: Colors.white),
            label: const Text("Add to Cart"),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E2124),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> callProductDetail() async {
    bool internet = await MyApplication.checkInternet();
    if (internet) {
      try {
        setState(() => isLoading = true);
        ResponseProductDetail? response = await ApiCalls.callProductDetail(
          RequestProductDetail(productId: widget.productId),
        );
        if (response != null && response.result?.toLowerCase().contains("pass") == true) {
          product = response.data;
        }
      } catch (e) {
        log("Error fetching product: $e");
      } finally {
        setState(() => isLoading = false);
      }
    } else {
      setState(() => isLoading = false);
      SharedWidgets.showTopSnackBar(context, message: "No Internet Available",title:"fail");
    }
  }

  Future<void> callAddCart({int? productid, int? price, int? qty, String? name}) async {
    MyApplication.checkInternet().then((internet) async {
      if(internet){
        try{
          ResponseAddCart? response= await ApiCalls.callAddCart(RequestAddCart(
              userId: AppPrefs.userId,
              listingId: widget.listId ?? 0,
              productId: productid,
              productName: name,
              productPrice: price,
              quantity: qty
          ));
          if(response != null){
            if(response.result!.isNotEmpty && response.result != null &&
                response.result!.toLowerCase().contains("pass")){
              Get.back();
              SharedWidgets.showTopSnackBar(context, message: response.message!,title: "pass");
            }else{
              SharedWidgets.showTopSnackBar(context, message: response.message!,title: "fail");
            }
          }
        }on Exception catch(e){
          log("$e");
        }catch(e){
          log("$e");
        }finally{

        }
      }else{
        SharedWidgets.showTopSnackBar(context, message: "No Internet Available",title:"fail");
      }
    },);
  }

}