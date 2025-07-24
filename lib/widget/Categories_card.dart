// // ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:hms/common/spacing.dart';

// class CategoriesCard extends StatelessWidget {
//   String category;
//   String image;
//   VoidCallback onTap;
//   CategoriesCard(
//       {Key? key,
//       required this.category,
//       required this.image,
//       required this.onTap})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       child: Container(
//         padding: EdgeInsets.all(14),
//         decoration: ShapeDecoration(
//           color: Colors.white,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.only(
//               topRight: Radius.circular(30),
//               bottomLeft: Radius.circular(30),
//               bottomRight: Radius.circular(30),
//             ),
//           ),
//           shadows: [
//             BoxShadow(
//               color: Color(0x7f2e8b57),
//               blurRadius: 4,
//               offset: Offset(1, 4),
//               spreadRadius: 0,
//             ),
//           ],
//         ),
//         child: Column(
//           children: [
//             SizedBox(
//               height: 70.h,
//               width: 70.w,
//               child: Image.asset(image),
//             ),
//             heightSpacer(10),
//             Text(
//               category,
//               textAlign: TextAlign.center,
//               style: TextStyle(color: Color(0xff333333), fontSize: 15.sp),
//             ),
//             heightSpacer(10),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newhms/common/spacing.dart';
//import 'package:flutter_svg/svg.dart';



class CategoryCard extends StatelessWidget {
  final String category;
  final String image;
  final VoidCallback onTap;
  const CategoryCard({
    super.key,
    required this.category,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        // width: 100.w,
        padding: const EdgeInsets.all(14),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(30.r),
              bottomLeft: Radius.circular(30.r),
              bottomRight: Radius.circular(30.r),
            ),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x7F2E8B57),
              blurRadius: 4,
              offset: Offset(1, 4),
              spreadRadius: 0,
            )
          ],
        ),
        child: Column(
          children: [
            SizedBox(
              width: 70.w,
              height: 70.h,
              child: Image.asset(
                image,
              ),
            ),
            heightSpacer(10),
            Text(
              category,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF333333),
                fontSize: 15,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                height: 0,
              ),
            ),
            heightSpacer(10),
          ],
        ),
      ),
    );
  }
}
