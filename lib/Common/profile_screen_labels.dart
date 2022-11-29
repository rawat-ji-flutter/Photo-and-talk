
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:photo_talk/Widgets/app_colors.dart';

class ProfileScreenLabels extends StatelessWidget {

  final String title;
  final IconData iconName;
  final VoidCallback buttonCallback;


  ProfileScreenLabels(this.title, this.iconName, this.buttonCallback);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: buttonCallback,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
        ),
        padding:const EdgeInsets.fromLTRB(30, 0, 30, 0),
        child:
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(iconName,color: AppColors.buttonColor),
            const SizedBox(
              width: 10,
            ),
            AutoSizeText(title,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: Colors.grey[800]),
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios_outlined,
              color: Color.fromRGBO(122, 122, 122, 1),
              size: 17,
            )

          ],
        ),
      ),
    );
  }
}
