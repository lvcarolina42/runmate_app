import 'package:runmate_app/data/user/datasource/user_datasource.dart';
import 'package:runmate_app/data/user/dto/user_dto.dart';
import 'package:runmate_app/domain/user/model/user.dart';
import 'package:runmate_app/domain/user/model/user_for_register.dart';
import 'package:runmate_app/domain/user/repository/user_repository.dart';
import 'package:runmate_app/domain/user/session_manager.dart';
import 'package:runmate_app/domain/utils/result.dart';

class UserRepositoryImpl implements UserRepository {
  UserDatasource datasource;

  UserRepositoryImpl({required this.datasource});

  @override
  Future<Result<bool, Exception>> register({
    required UserForRegister userForRegister,
  }) async {
    try {
      final body = {
        "email": userForRegister.email,
        "username": userForRegister.username,
        "name": userForRegister.fullName,
        "password": userForRegister.password,
        "birthDate": userForRegister.birthDate.toUtc().toIso8601String(),
      };

      await datasource.register(body: body);

      // final success = RegisterDto.fromDataResult(result);

      return Result.success(true);
    } catch (e) {
      return Result.failure(Exception(e.toString()));
    }
  }

  @override
  Future<Result<User, Exception>> login({
    required String username,
    required String password,
  }) async {
    try {
      final body = {
        "username": username,
        "password": password,
      };

      await datasource.login(body: body);

      final userResult = await datasource.getUser(username: username);

      var user = UserDTO.simpleFromDataResult(userResult);

      await SessionManager().saveUser(user);

      return Result.success(user);
      
    } catch (e) {
      return Result.failure(Exception(e.toString()));
    }
  }

  @override
  Future<Result<User, Exception>> getUserById() async {
    try {
      final userResult = await datasource.getUserById(id: SessionManager().currentUser!.id);

      var user = UserDTO.simpleFromDataResult(userResult);

      await SessionManager().saveUser(user);

      return Result.success(user);
      
    } catch (e) {
      return Result.failure(Exception(e.toString()));
    }
  }

  @override
  Future<Result<List<User>, Exception>> getUsers({required String id}) async {
    try {
      final result = await datasource.getUsers(id: id);

      final users = UserDTO.fromDataResultList(result);

      return Result.success(users);
    } catch (e) {
      return Result.failure(Exception(e.toString()));
    }
  }

  @override
  Future<Result<List<User>, Exception>> getFriends({required String id}) async {
    try {
      final result = await datasource.getFriends(id: id);

      final users = UserDTO.fromDataResultList(result);

      return Result.success(users);
    } catch (e) {
      return Result.failure(Exception(e.toString()));
    }
  }

  @override
  Future<Result<bool, Exception>> addFriend({required String userid, required String friendId}) async {
    try {
      final body = {
        "user_id": userid,
        "friend_id": friendId
      };
      await datasource.follow(body: body);

      return Result.success(true);
    } catch (e) {
      return Result.failure(Exception(e.toString()));
    }
  }

  @override
  Future<Result<bool, Exception>> removeFriend({required String userid, required String friendId}) async {
    try {
      final body = {
        "user_id": userid,
        "friend_id": friendId
      };
      await datasource.unfollow(body: body);

      return Result.success(true);
    } catch (e) {
      return Result.failure(Exception(e.toString()));
    }
  }

  @override
  Future<Result<bool, Exception>> updateToken ({required String token, required String userId}) async {
    try {
      final body = {
        "token": token
      };
      await datasource.updateToken(body: body, userId: userId);
      return Result.success(true);
    } catch (e) {
      return Result.failure(Exception(e.toString()));
    }
  }

  @override
  Future<Result<bool, Exception>> updateGoal({required String userId, required int distance, required int days}) async {
    try {
      final body = {
        "distance": distance,
        "days": days
      };
      await datasource.updateGoal(body: body, userId: userId);
      return Result.success(true);
    } catch (e) {
      return Result.failure(Exception(e.toString()));
    }
  }

  @override
  Future<Result<bool, Exception>> deleteGoal({required String userId}) async {
    try {
      await datasource.deleteGoal(userId: userId);
      return Result.success(true);
    } catch (e) {
      return Result.failure(Exception(e.toString()));
    }
  }

}