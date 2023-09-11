import 'package:flutter/material.dart';
import 'package:flutter_app/constants/colors.dart';
// import 'package:flutter_app/constants/routes.dart';
import 'package:flutter_app/repository/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
import 'package:routemaster/routemaster.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({Key? key}) : super(key: key);

  void signInWithGoogle(WidgetRef ref, BuildContext context) async {
    final sMessenger = ScaffoldMessenger.of(context);
    // final navigator = context;
    final navigator = Routemaster.of(context);
    final errorModel = await ref.read(authRepositoryProvider).signInWithGoogle();
    if (errorModel.error == null) {
      ref.read(userProvider.notifier).update((state) => errorModel.data);
      // navigator.go('/');
      navigator.replace('/');
    } else {
      sMessenger.showSnackBar(
        SnackBar(
          content: Text(errorModel.error!),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () => signInWithGoogle(ref, context),
          icon: Image.asset(
            'assets/images/g-logo-2.png',
            height: 20,
          ),
          label: const Text(
            'Sign in with Google',
            style: TextStyle(
              color: AppColor.kBlackColor,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.kWhiteColor,
            minimumSize: const Size(150, 50),
          ),
        ),
      ),
    );
  }
}



// class LoginScreen extends ConsumerWidget {
//   const LoginScreen({super.key});

//   void signInWithGoogle(WidgetRef ref, BuildContext context) async {
//     final errorModel =
//         await ref.read(authRepositoryProvider).signInWithGoogle();
//     if (errorModel.error == null) {
//       if (context.mounted) {
//         ref.read(userProvider.notifier).update((state) => errorModel.data);
//         Navigator.of(context).pushNamed(Routes.homeScreen);
//       }
//     } else {
//       if (context.mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//             content: Text(
//           errorModel.error.toString(),
//         )));
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Scaffold(
//       body: Center(
//           child: SizedBox(
//         height: 50.0,
//         child: ElevatedButton.icon(
//           onPressed: () {
//             signInWithGoogle(ref, context);
//           },
//           icon: Image.asset('assets/images/g-logo-2.png'),
//           label: const Text(
//             'Google SignIn',
//             style: TextStyle(color: AppColor.kBlackColor),
//           ),
//           style:
//               ElevatedButton.styleFrom(backgroundColor: AppColor.kWhiteColor),
//         ),
//       )),
//     );
//   }
// }
