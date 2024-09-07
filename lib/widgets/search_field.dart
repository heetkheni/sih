import 'package:flutter/material.dart';

class ModernSearchField extends StatelessWidget {


  const ModernSearchField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15,right: 15),
      child: TextField(
        //controller: controller,
        //onChanged: onChanged,
        decoration: InputDecoration(
          //hintText: hintText,
          hintText: "Search Location",
          hintStyle: TextStyle(
            
            fontSize: 16,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left:8.0),
            child: Icon(
              Icons.search,
              color: Colors.blue,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          // suffixIcon: controller.text.isNotEmpty
          //     ? IconButton(
          //         icon: Icon(Icons.clear, color: Colors.grey[600]),
          //         onPressed: () {
          //           controller.clear();
          //           if (onChanged != null) {
          //             onChanged!('');
          //           }
          //         },
          //       )
          //     : null,
        ),
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}
