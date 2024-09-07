import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StockAddScreen extends StatefulWidget {
  final String hospitalId;

  const StockAddScreen({Key? key, required this.hospitalId}) : super(key: key);

  @override
  _StockAddScreenState createState() => _StockAddScreenState();
}

class _StockAddScreenState extends State<StockAddScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController qtyController = TextEditingController();

  String categoryDropdownValue = 'Medicines';
  String subcategoryDropdownValue = 'Painkillers';

  Map<String, List<String>> subcategories = {
    'Medicines': ['Painkillers', 'Antibiotics', 'Vitamins'],
    'Machines': ['X-Ray Machine', 'Ultrasound Machine', 'ECG Machine'],
    'Medical Supplies': ['Gloves', 'Syringes', 'Bandages'],
  };

  List<String> categories = [
    'Medicines',
    'Machines',
    'Medical Supplies',
  ];

  bool isLoading = false;

  Future<void> uploadStock() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Adding the stock to the Firestore database
      await FirebaseFirestore.instance.collection('hospitals').doc(widget.hospitalId).collection('stocks').add({
        'name': nameController.text,
        'category': categoryDropdownValue,
        'subcategory': subcategoryDropdownValue,
        'price': double.parse(priceController.text),
        'qty': int.parse(qtyController.text),
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Clear the text fields and reset dropdowns
      nameController.clear();
      priceController.clear();
      qtyController.clear();
      setState(() {
        categoryDropdownValue = 'Medicines';
        subcategoryDropdownValue = 'Painkillers';
      });

      // Show success dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Stock item added successfully!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      // Print the error to the console
      print('Error uploading stock: $e');

      // Show error dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to add stock item. Please try again.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Stock Item"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 16.0),
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Product Name",
                hintText: "Enter Product name",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              value: categoryDropdownValue,
              icon: Icon(Icons.keyboard_arrow_down),
              decoration: InputDecoration(
                labelText: "Category",
                border: OutlineInputBorder(),
              ),
              items: categories.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  categoryDropdownValue = newValue!;
                  subcategoryDropdownValue = subcategories[newValue]![0]; // Set default subcategory
                });
              },
            ),
            SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              value: subcategoryDropdownValue,
              icon: Icon(Icons.keyboard_arrow_down),
              decoration: InputDecoration(
                labelText: "Subcategory",
                border: OutlineInputBorder(),
              ),
              items: subcategories[categoryDropdownValue]!.map((String subcategory) {
                return DropdownMenuItem<String>(
                  value: subcategory,
                  child: Text(subcategory),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  subcategoryDropdownValue = newValue!;
                });
              },
            ),           
            SizedBox(height: 16.0),
            TextFormField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Price",
                hintText: "Enter product price",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: qtyController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Qty",
                hintText: "Enter quantity",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: isLoading ? null : uploadStock, // Disable button while loading
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                textStyle: TextStyle(fontSize: 18),
              ),
              child: isLoading
                  ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.upload),
                        SizedBox(width: 8),
                        Text("Add Stock"),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
