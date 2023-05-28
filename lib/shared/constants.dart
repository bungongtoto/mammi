import 'package:flutter/material.dart';
import 'package:mammi/colors/colors.dart';

const textInputDecoration =  InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2.0),
                  ),
              
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.mainColor, width: 2.0
                    ),
                  ), 
);