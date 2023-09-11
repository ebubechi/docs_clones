// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
// import 'dart:developer';

import 'package:flutter_app/constants/url.dart';
import 'package:flutter_app/models/error_model.dart';
import 'package:flutter_app/models/user_model.dart';
import 'package:flutter_app/repository/local_storage_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' show Client, Response;
// import 'package:riverpod_annotation/riverpod_annotation.dart';

// part 'auth_repository.g.dart';

//* Providers
// @riverpod
// AuthRepository authRepository(AuthRepositoryRef ref) {
//   return AuthRepository(
//     googleSignIn: GoogleSignIn(),
//     client: Client(),
//     localStorageRepository: LocalStorageRepository(),
//   );
// }

// final authRepositoryProvider = Provider(
//   (ref) => AuthRepository(
//     googleSignIn: GoogleSignIn(),
//     client: Client(),
//     localStorageRepository: LocalStorageRepository(),
//   ),
// );

// final userProvider = StateProvider<UserModel?>((ref) => null);
// //* End of Providers

// //* Repositories
// class AuthRepository {
//   final GoogleSignIn _googleSignIn;
//   final Client _client;
//   final LocalStorageRepository _localStorageRepository;
//   AuthRepository({
//     required GoogleSignIn googleSignIn,
//     required Client client,
//     required LocalStorageRepository localStorageRepository,
//   })  : _googleSignIn = googleSignIn,
//         _client = client,
//         _localStorageRepository = localStorageRepository;

//   Future<ErrorModel> signInWithGoogle() async {
//     ErrorModel error = ErrorModel(
//       error: 'some error occurred',
//       data: null,
//     );
//     try {
//       final GoogleSignInAccount? user = await _googleSignIn.signIn();
//       final isAuth = user?.authentication;
//       log(isAuth.toString());
//       final isAuthHead = user?.authHeaders;
//       log(isAuthHead.toString());
//       //  await _googleSignIn.signOut();
//       if (user != null) {
//         final userAcc = UserModel(
//           name: user.displayName!,
//           email: user.email,
//           profilePic: user.photoUrl!,
//           uid: '', //user.id,
//           token: '', //user.serverAuthCode!,
//         );
//         Response res = await _client.post(
//           Uri.parse("$host/api/signup"),
//           body: userAcc.toJson(),
//           headers: {
//             'Content-Type': 'application/json; charset=UTF-8',
//           },
//         );
//         final myData = jsonDecode(res.body);
//         switch (res.statusCode) {
//           case 200:
//             final newUser = userAcc.copyWith(
//               uid: myData['user']['_id'],
//               token: myData['token'],
//             );
//             error = ErrorModel(error: null, data: newUser);
//             _localStorageRepository.setToken(newUser.token);
//             break;
//           default:
//             throw 'Some error happened';
//         }
//       }
//     } catch (e) {
//       error = ErrorModel(error: e.toString(), data: null);
//     }
//     return error;
//   }

//   Future<ErrorModel> getUserData() async {
//     ErrorModel error = ErrorModel(
//       error: 'some error occurred',
//       data: null,
//     );
//     try {
//       String? token = await _localStorageRepository.getToken();
//       //  await _googleSignIn.signOut();
//       if (token != null) {
//         Response res = await _client.get(
//           Uri.parse("$host/"),
//           headers: {
//             'Content-Type': 'application/json; charset=UTF-8',
//             'x-auth-token': token,
//           },
//         );
//         final myUser = jsonDecode(res.body)['user'];
//         switch (res.statusCode) {
//           case 200:
//             final newUser = UserModel.fromJson(
//               jsonEncode(myUser),
//             ).copyWith(token: token);
//             error = ErrorModel(error: null, data: newUser);
//             break;
//         }
//       }
//     } catch (e) {
//       error = ErrorModel(error: e.toString(), data: null);
//     }
//     return error;
//   }

//   void signOut() async {
//     await _googleSignIn.signOut();
//     _localStorageRepository.setToken('');
//   }
// }

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    googleSignIn: GoogleSignIn(),
    client: Client(),
    localStorageRepository: LocalStorageRepository(),
  ),
);

final userProvider = StateProvider<UserModel?>((ref) => null);

class AuthRepository {
  final GoogleSignIn _googleSignIn;
  final Client _client;
  final LocalStorageRepository _localStorageRepository;
  AuthRepository({
    required GoogleSignIn googleSignIn,
    required Client client,
    required LocalStorageRepository localStorageRepository,
  })  : _googleSignIn = googleSignIn,
        _client = client,
        _localStorageRepository = localStorageRepository;

  Future<ErrorModel> signInWithGoogle() async {
    ErrorModel error = ErrorModel(
      error: 'Some unexpected error occurred.',
      data: null,
    );
    try {
      final user = await _googleSignIn.signIn();
      if (user != null) {
        final userAcc = UserModel(
          email: user.email,
          name: user.displayName ?? '',
          profilePic: user.photoUrl ?? '',
          uid: '',
          token: '',
        );

        Response res = await _client.post(Uri.parse('$host/api/signup'), body: userAcc.toJson(), headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        });

        switch (res.statusCode) {
          case 200:
            final newUser = userAcc.copyWith(
              uid: jsonDecode(res.body)['user']['_id'],
              token: jsonDecode(res.body)['token'],
            );
            error = ErrorModel(error: null, data: newUser);
            _localStorageRepository.setToken(newUser.token);
            break;
        }
      }
    } catch (e) {
      error = ErrorModel(
        error: e.toString(),
        data: null,
      );
    }
    return error;
  }

  Future<ErrorModel> getUserData() async {
    ErrorModel error = ErrorModel(
      error: 'Some unexpected error occurred.',
      data: null,
    );
    try {
      String? token = await _localStorageRepository.getToken();

      if (token != null) {
        var res = await _client.get(Uri.parse('$host/'), headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        });
        switch (res.statusCode) {
          case 200:
            final newUser = UserModel.fromJson(
              jsonEncode(
                jsonDecode(res.body)['user'],
              ),
            ).copyWith(token: token);
            error = ErrorModel(error: null, data: newUser);
            _localStorageRepository.setToken(newUser.token);
            break;
        }
      }
    } catch (e) {
      error = ErrorModel(
        error: e.toString(),
        data: null,
      );
    }
    return error;
  }

  void signOut() async {
    await _googleSignIn.signOut();
    _localStorageRepository.setToken('');
  }
}