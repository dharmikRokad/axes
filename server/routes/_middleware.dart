import 'package:dart_frog/dart_frog.dart';
import 'package:dotenv/dotenv.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';

import '../lib/data_sources/mongo_data_source.dart';
import '../lib/repositories/user_repository.dart';
import '../lib/services/password_service.dart';
import '../lib/services/token_service.dart';

import '../lib/repositories/event_repository.dart';

// Services
final _userRepository = UserRepository();
final _eventRepository = EventRepository();
final _passwordService = PasswordService();
final _tokenService = TokenService();

bool _envLoaded = false;

Handler middleware(Handler handler) {
  return handler
      .use(requestLogger())
      .use(fromShelfMiddleware(corsHeaders(
        headers: {
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Methods':
              'GET, POST, PUT, PATCH, DELETE, OPTIONS',
          'Access-Control-Allow-Headers':
              'Origin, Content-Type, Authorization, Accept',
          'Access-Control-Allow-Credentials': 'true',
        },
      )))
      .use((handler) {
        return (context) async {
          if (!_envLoaded) {
            var env = DotEnv(includePlatformEnvironment: true)..load();
            _envLoaded = true;
            await MongoDataSource.init(env: env);
          }
          final response = await handler(context);
          return response;
        };
      })
      .use(provider<UserRepository>((_) => _userRepository))
      .use(provider<EventRepository>((_) => _eventRepository))
      .use(provider<PasswordService>((_) => _passwordService))
      .use(provider<TokenService>((_) => _tokenService));
}
