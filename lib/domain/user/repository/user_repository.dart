import 'package:runmate_app/domain/user/model/user.dart';
import 'package:runmate_app/domain/user/model/user_for_register.dart';
import 'package:runmate_app/domain/utils/result.dart';

abstract class UserRepository {
  Future<Result<bool, Exception>> register({
    required UserForRegister userForRegister,
  });

  Future<Result<User, Exception>> login({
    required String username,
    required String password,
  });

  Future<Result<List<User>, Exception>> getUsers({required String id});

  Future<Result<List<User>, Exception>> getFriends({required String id});

  Future<Result<bool, Exception>> addFriend({required String userid, required String friendId});

  Future<Result<bool, Exception>> removeFriend({required String userid, required String friendId});

  Future<Result<User, Exception>> getUserById();

  Future<Result<bool, Exception>> updateToken ({required String token, required String userId});

  Future<Result<bool, Exception>> updateGoal({required String userId, required int distance, required int days});
  
  Future<Result<bool, Exception>> deleteGoal({required String userId});
}
