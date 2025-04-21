// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:firebase_storage/firebase_storage.dart' as _i457;
import 'package:get_it/get_it.dart' as _i174;
import 'package:google_sign_in/google_sign_in.dart' as _i116;
import 'package:injectable/injectable.dart' as _i526;

import '../../data/repositories/auth_repository.dart' as _i481;
import '../../data/repositories/legal_repository.dart' as _i962;
import '../../data/repositories/user_repository.dart' as _i517;
import '../../data/services/auth/auth_service.dart' as _i145;
import '../../data/services/auth/auth_service_interface.dart' as _i363;
import '../../data/services/auth/email_auth_service.dart' as _i472;
import '../../data/services/auth/google_auth_service.dart' as _i591;
import '../../data/services/auth/phone_auth_service.dart' as _i912;
import '../../data/services/legal_service.dart' as _i182;
import '../../data/services/terms_verification_service.dart' as _i814;
import '../../domain/repositories/auth_repository_interface.dart' as _i907;
import '../../domain/repositories/legal_repository_interface.dart' as _i867;
import '../../domain/repositories/user_repository_interface.dart' as _i688;
import '../../presentation/blocs/auth/auth_bloc.dart' as _i141;
import 'modules/service_module.dart' as _i681;

// initializes the registration of main-scope dependencies inside of GetIt
_i174.GetIt init(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i526.GetItHelper(getIt, environment, environmentFilter);
  final serviceModule = _$ServiceModule();
  gh.lazySingleton<_i59.FirebaseAuth>(() => serviceModule.firebaseAuth);
  gh.lazySingleton<_i974.FirebaseFirestore>(() => serviceModule.firestore);
  gh.lazySingleton<_i457.FirebaseStorage>(() => serviceModule.storage);
  gh.lazySingleton<_i116.GoogleSignIn>(() => serviceModule.googleSignIn);
  gh.factory<_i472.EmailAuthService>(
    () => _i472.EmailAuthService(gh<_i59.FirebaseAuth>()),
  );
  gh.factory<_i912.PhoneAuthService>(
    () => _i912.PhoneAuthService(gh<_i59.FirebaseAuth>()),
  );
  gh.factory<_i182.LegalService>(
    () => _i182.LegalService(gh<_i974.FirebaseFirestore>()),
  );
  gh.factory<_i591.GoogleAuthService>(
    () => _i591.GoogleAuthService(
      gh<_i59.FirebaseAuth>(),
      gh<_i116.GoogleSignIn>(),
    ),
  );
  gh.lazySingleton<_i688.UserRepositoryInterface>(
    () => _i517.UserRepository(
      gh<_i974.FirebaseFirestore>(),
      gh<_i59.FirebaseAuth>(),
    ),
  );
  gh.lazySingleton<_i363.AuthServiceInterface>(
    () => _i145.AuthService(
      gh<_i59.FirebaseAuth>(),
      gh<_i472.EmailAuthService>(),
      gh<_i591.GoogleAuthService>(),
      gh<_i912.PhoneAuthService>(),
    ),
  );
  gh.lazySingleton<_i907.AuthRepositoryInterface>(
    () => _i481.AuthRepository(gh<_i363.AuthServiceInterface>()),
  );
  gh.lazySingleton<_i867.LegalRepositoryInterface>(
    () => _i962.LegalRepository(gh<_i182.LegalService>()),
  );
  gh.factory<_i814.TermsVerificationService>(
    () => _i814.TermsVerificationService(
      gh<_i867.LegalRepositoryInterface>(),
      gh<_i59.FirebaseAuth>(),
    ),
  );
  gh.factory<_i141.AuthBloc>(
    () => _i141.AuthBloc(
      gh<_i907.AuthRepositoryInterface>(),
      gh<_i688.UserRepositoryInterface>(),
      gh<_i867.LegalRepositoryInterface>(),
    ),
  );
  return getIt;
}

class _$ServiceModule extends _i681.ServiceModule {}
