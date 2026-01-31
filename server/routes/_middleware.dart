import 'package:dart_frog/dart_frog.dart';
import 'package:dotenv/dotenv.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';

import '../lib/data_sources/mongo_data_source.dart';
import '../lib/repositories/user_repository.dart';
import '../lib/services/password_service.dart';
import '../lib/services/token_service.dart';

// Services
final _userRepository = UserRepository();
final _passwordService = PasswordService();
final _tokenService = TokenService();

bool _envLoaded = false;

Handler middleware(Handler handler) {
  return handler
      .use(requestLogger())
      .use(fromShelfMiddleware(corsHeaders()))
      .use((handler) {
        return (context) async {
          if (!_envLoaded) {
            var env = DotEnv(includePlatformEnvironment: true)..load();
            // We might need to manually put Env into Platform.environment if not handled strictly
            // But MongoDataSource uses Platform.environment
            _envLoaded = true;
            await MongoDataSource.init();
          }
          final response = await handler(context);
          return response;
        };
      })
      .use(provider<UserRepository>((_) => _userRepository))
      .use(provider<PasswordService>((_) => _passwordService))
      .use(provider<TokenService>((_) => _tokenService));
}
