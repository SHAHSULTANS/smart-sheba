//lib/data/repositories/auth_repository_impl.dart
import '../../core/error/exceptions.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<void> sendOtp(String phoneNumber) async {
    // For development, we can skip network check when using mock
    if (remoteDataSource is AuthRemoteDataSourceMock) {
      return await remoteDataSource.sendOtp(phoneNumber);
    }
    
    // For real implementation
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.sendOtp(phoneNumber);
      } catch (e) {
        throw ServerException();
      }
    } else {
      throw NetworkException();
    }
  }

  @override
  Future<User> verifyOtpAndLogin(String phoneNumber, String otp) async {
    // For development, we can skip network check when using mock
    if (remoteDataSource is AuthRemoteDataSourceMock) {
      final userModel = await remoteDataSource.verifyOtpAndLogin(phoneNumber, otp);
      await localDataSource.cacheUser(userModel);
      await localDataSource.saveAuthToken(userModel.token);
      return userModel.toEntity();
    }
    
    // For real implementation
    if (await networkInfo.isConnected) {
      try {
        final userModel = await remoteDataSource.verifyOtpAndLogin(phoneNumber, otp);
        await localDataSource.cacheUser(userModel);
        await localDataSource.saveAuthToken(userModel.token);
        return userModel.toEntity();
      } catch (e) {
        throw ServerException();
      }
    } else {
      throw NetworkException();
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    try {
      final token = await localDataSource.getAuthToken();
      if (token != null) {
        final userModel = await localDataSource.getCachedUser();
        return userModel?.toEntity();
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> logout() async {
    await localDataSource.clearAuthToken();
    await localDataSource.clearCachedUser();
  }

  @override
  Future<bool> isLoggedIn() async {
    final token = await localDataSource.getAuthToken();
    return token != null;
  }
}
