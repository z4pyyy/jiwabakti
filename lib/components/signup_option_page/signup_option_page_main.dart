import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

class SignupOptionPageMain extends StatefulWidget {
  const SignupOptionPageMain({super.key});

  @override
  State<SignupOptionPageMain> createState() => SignupOptionPageMainState();
}

class SignupOptionPageMainState extends State<SignupOptionPageMain> {

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 15),
            const Text(
              "Please choose your signup options",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 15),
            // SizedBox(
            //   width: 70.w,
            //   child: ElevatedButton(
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: Colors.white,
            //       foregroundColor: Colors.black,
            //       elevation: 0,
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(12), // Rounded border
            //         side: const BorderSide(color: Colors.black, width: 1.5), // Optional border
            //       ),
            //       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            //     ),
            //     onPressed: (){
            //       context.push("/signup/apple");
            //     },
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.start,
            //       mainAxisSize: MainAxisSize.max,
            //       children: [
            //         Container(
            //           margin: EdgeInsets.only(left: 10.w),
            //           width: 30,
            //           child: const Icon(FontAwesomeIcons.apple, size: 26,),
            //         ),
            //         const SizedBox(width: 10,),
            //         const Text(
            //           "Continue with Apple",
            //           style: TextStyle(
            //             fontSize: 16,
            //             fontWeight: FontWeight.w500,
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            // SizedBox(
            //   width: 70.w,
            //   child: ElevatedButton(
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: Colors.white,
            //       foregroundColor: Colors.black,
            //       elevation: 0,
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(12), // Rounded border
            //         side: const BorderSide(color: Colors.black, width: 1.5), // Optional border
            //       ),
            //       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            //     ),
            //     onPressed: (){
            //       final user = FirebaseAuth.instance.currentUser;
            //       if (user == null) {
            //         // If there's no authenticated user, pass empty values or handle accordingly
            //         context.push(
            //           "/signup/google",
            //           extra: GoogleSignupData(
            //             uid: "",
            //             email: "",
            //             name: null,
            //             photo: null,
            //           ),
            //         );
            //       } else {
            //         context.push(
            //           "/signup/google",
            //           extra: GoogleSignupData(
            //             uid: user.uid,
            //             email: user.email ?? "",
            //             name: user.displayName,
            //             photo: user.photoURL,
            //           ),
            //         );
            //       }
            //     },
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.start,
            //       mainAxisSize: MainAxisSize.max,
            //       children: [
            //         Container(
            //           margin: EdgeInsets.only(left: 10.w),
            //           width: 30,
            //           child: const Icon(FontAwesomeIcons.google, size: 20,),
            //         ),
            //         const SizedBox(width: 10,),
            //         const Text(
            //           "Continue with Google",
            //           style: TextStyle(
            //             fontSize: 16,
            //             fontWeight: FontWeight.w500,
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            const SizedBox(height: 15),
            SizedBox(
              width: 70.w,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Rounded border
                    side: const BorderSide(color: Colors.black, width: 1.5), // Optional border
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
                onPressed: (){
                  context.push("/signup/email");
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 10.w),
                      width: 30,
                      child: const Icon(Icons.mail_outline_rounded, size: 26,),
                    ),
                    const SizedBox(width: 10,),
                    const Text(
                      "Continue with Email",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
      );
    }
  }
