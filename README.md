# Flutter Base — Clean Architecture

Base de aplicación Flutter lista para producción. Implementa Clean Architecture, autenticación JWT con Riverpod, navegación con GoRouter, tema claro/oscuro persistente y un feature de ejemplo (Tasks) con CRUD completo.

---

## Requisitos

- Flutter 3.x / Dart ≥ 3.0.0
- Android Studio o VS Code
- Dispositivo físico o emulador

---

## Inicio rápido

```bash
# 1. Instalar dependencias
flutter pub get

# 2. Generar código (Freezed + json_serializable)
dart run build_runner build --delete-conflicting-outputs

# 3. Ejecutar en modo desarrollo
flutter run
```

En modo DEV (`Environment.dev`) el login acepta credenciales mock:

| Usuario | Contraseña |
|---------|-----------|
| `demo`  | `demo123`  |
| `admin` | `admin123` |
| `test`  | `test123`  |

Para conectar a tu API real, edita `lib/core/config/env_config.dart` y cambia la `baseUrl`.

---

## Estructura del proyecto

```
lib/
├── core/                         # Código compartido por todos los features
│   ├── config/
│   │   └── env_config.dart       # Ambientes (dev / staging / prod)
│   ├── constants/
│   │   └── app_constants.dart    # Rutas, claves de storage, timeouts
│   ├── errors/
│   │   └── failures.dart         # Jerarquía de Failures (dartz Either)
│   ├── network/
│   │   ├── api_client.dart       # Dio + interceptores + token refresh mutex
│   │   ├── api_exceptions.dart   # Excepciones tipadas de red
│   │   └── endpoints.dart        # Constantes de endpoints
│   ├── services/
│   │   ├── connectivity_service.dart  # isConnectedProvider (StreamProvider)
│   │   └── snackbar_service.dart      # Snackbars sin BuildContext
│   ├── state/
│   │   ├── base_state.dart       # BaseState<T> genérico
│   │   └── paginated_notifier.dart    # PaginatedNotifier<T> con loadMore/refresh
│   ├── theme/
│   │   ├── app_theme.dart        # Colores, spacing, shadows, ThemeModeNotifier
│   │   ├── light_theme.dart
│   │   └── dark_theme.dart
│   ├── usecases/
│   │   └── use_case.dart         # UseCase<T, Params> + NoParams
│   ├── utils/
│   │   ├── app_logger.dart       # AppLogger (dart:developer)
│   │   └── validators.dart       # Validadores reutilizables en español
│   └── widgets/
│       ├── main_shell.dart       # Shell: Drawer + BottomNav + banner offline
│       └── app_drawer.dart       # Drawer lateral
│
├── features/
│   ├── auth/                     # Autenticación completa (JWT)
│   │   ├── data/
│   │   │   ├── datasources/      # AuthRemoteDataSource
│   │   │   ├── models/           # UserModel (Freezed)
│   │   │   └── repositories/     # AuthRepositoryImpl
│   │   ├── domain/
│   │   │   ├── entities/         # User
│   │   │   ├── repositories/     # AuthRepository (interfaz)
│   │   │   └── usecases/         # Login, Register, Logout, ForgotPassword
│   │   └── presentation/
│   │       ├── providers/        # authProvider, currentUserProvider
│   │       ├── login_screen.dart
│   │       ├── register_screen.dart
│   │       └── forgot_password_screen.dart
│   │
│   ├── profile/
│   │   └── presentation/
│   │       ├── profile_screen.dart        # Settings + logout
│   │       ├── profile_detail_screen.dart # Datos completos
│   │       ├── edit_profile_screen.dart   # Formulario de edición
│   │       └── change_password_screen.dart
│   │
│   ├── dashboard/                # Pantalla Home
│   ├── notifications/
│   └── example/                  # Feature de referencia: Tasks (CRUD completo)
│       ├── data/
│       │   └── datasources/      # TaskLocalDataSource (SharedPreferences)
│       ├── domain/
│       │   └── entities/         # Task, TaskStatus, TaskPriority
│       └── presentation/
│           ├── providers/        # taskProvider (StateNotifier)
│           ├── task_list_screen.dart
│           └── task_form_screen.dart
│
├── main.dart                     # Entry point, error handlers globales
└── routes.dart                   # GoRouter, ShellRoute, auth guard
```

---

## Arquitectura

### Capas por feature

```
Pantalla (Widget)
    │ ref.watch / ref.read
    ▼
StateNotifier  ──────────────── maneja estado UI
    │ await useCase(params)
    ▼
UseCase<T, Params>  ─────────── lógica de negocio
    │ repository.method()
    ▼
Repository (interfaz)  ─────── contrato del dominio
    │ implementado por
    ▼
RepositoryImpl  ────────────── orquesta fuentes de datos
    │
    ├── RemoteDataSource  ────── ApiClient (Dio → HTTP)
    └── LocalDataSource   ────── SharedPreferences / SecureStorage
```

Cada capa retorna `Either<Failure, T>` (paquete `dartz`):

```dart
// Use case
final result = await _repository.getProducts();

result.fold(
  (failure) => state = state.toError(failure.message),
  (data)    => state = state.toSuccess(data),
);
```

### Flujo de autenticación

```
Login → AuthRepositoryImpl → JWT guardado en FlutterSecureStorage
                           → GoRouter redirect evalúa authProvider
                           → Navega a /home
Logout → clearTokens() en ApiClient + SecureStorage → redirect a /login
```

El `routerProvider` **nunca** hace `ref.watch(authProvider)` — usa `ref.read` dentro del callback `redirect` para evitar recrear el router en cada cambio de estado.

---

## Cómo crear un nuevo feature

### Paso 1 — Registrar la ruta

En `lib/core/constants/app_constants.dart`:

```dart
static const String productListRoute = '/products';
static const String productDetailRoute = '/products/:id';
```

En `lib/routes.dart`:

```dart
import 'features/products/presentation/product_list_screen.dart';

// Dentro de ShellRoute.routes si va en el shell (con nav bar):
GoRoute(
  path: AppConstants.productListRoute,
  name: 'productList',
  pageBuilder: (context, state) => const NoTransitionPage(
    child: ProductListScreen(),
  ),
),

// Fuera del ShellRoute si es una pantalla de detalle:
GoRoute(
  path: AppConstants.productDetailRoute,
  name: 'productDetail',
  builder: (context, state) {
    final id = state.pathParameters['id']!;
    return ProductDetailScreen(productId: id);
  },
),
```

Si quieres que aparezca en el `BottomNavigationBar`, agrega el tab en `MainShell._tabs`:

```dart
_TabConfig(
  route: AppConstants.productListRoute,
  icon: Icons.inventory_2_outlined,
  activeIcon: Icons.inventory_2_rounded,
  label: 'Productos',
),
```

---

### Paso 2 — Capa Domain

**Entidad** `lib/features/products/domain/entities/product.dart`:

```dart
import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id;
  final String name;
  final double price;
  final String? imageUrl;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    this.imageUrl,
  });

  Product copyWith({String? name, double? price}) {
    return Product(
      id: id,
      name: name ?? this.name,
      price: price ?? this.price,
      imageUrl: imageUrl,
    );
  }

  @override
  List<Object?> get props => [id, name, price];
}
```

**Interfaz del repositorio** `lib/features/products/domain/repositories/product_repository.dart`:

```dart
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/product.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<Product>>> getProducts({int page = 1});
  Future<Either<Failure, Product>> getProductById(String id);
  Future<Either<Failure, Product>> createProduct(Product product);
  Future<Either<Failure, void>> deleteProduct(String id);
}
```

**Use case** `lib/features/products/domain/usecases/get_products_use_case.dart`:

```dart
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/use_case.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetProductsUseCase extends UseCase<List<Product>, NoParams> {
  final ProductRepository repository;
  GetProductsUseCase({required this.repository});

  @override
  Future<Either<Failure, List<Product>>> call(NoParams params) {
    return repository.getProducts();
  }
}
```

---

### Paso 3 — Capa Data

**Data source** `lib/features/products/data/datasources/product_remote_data_source.dart`:

```dart
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_exceptions.dart';
import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts({int page = 1});
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final ApiClient _apiClient;
  ProductRemoteDataSourceImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  @override
  Future<List<ProductModel>> getProducts({int page = 1}) async {
    final response = await _apiClient.get(
      '/products',
      queryParameters: {'page': page, 'limit': 20},
    );
    final List<dynamic> data = response.data['data'] as List;
    return data.map((e) => ProductModel.fromJson(e)).toList();
  }
}
```

**Implementación del repositorio** `lib/features/products/data/repositories/product_repository_impl.dart`:

```dart
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/api_exceptions.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_data_source.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource _remoteDataSource;

  ProductRepositoryImpl({required ProductRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<Failure, List<Product>>> getProducts({int page = 1}) async {
    try {
      final models = await _remoteDataSource.getProducts(page: page);
      return Right(models.map((m) => m.toEntity()).toList());
    } on ApiException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.statusCode));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
  // ...
}
```

---

### Paso 4 — Capa Presentation

**Provider y StateNotifier** `lib/features/products/presentation/providers/product_provider.dart`:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/state/base_state.dart';
import '../../data/datasources/product_remote_data_source.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/get_products_use_case.dart';
import '../../../../core/usecases/use_case.dart';

// ─── DI ───
final productRemoteDataSourceProvider = Provider((ref) =>
    ProductRemoteDataSourceImpl(apiClient: ref.watch(apiClientProvider)));

final productRepositoryProvider = Provider((ref) =>
    ProductRepositoryImpl(remoteDataSource: ref.watch(productRemoteDataSourceProvider)));

final getProductsUseCaseProvider = Provider((ref) =>
    GetProductsUseCase(repository: ref.watch(productRepositoryProvider)));

// ─── Estado ───
class ProductState extends BaseState<List<Product>> {
  const ProductState({super.data, super.status, super.error});
}

// ─── Notifier ───
class ProductNotifier extends StateNotifier<BaseState<List<Product>>> {
  final GetProductsUseCase _getProducts;

  ProductNotifier({required GetProductsUseCase getProducts})
      : _getProducts = getProducts,
        super(const BaseState()) {
    load();
  }

  Future<void> load() async {
    state = state.toLoading();
    final result = await _getProducts(const NoParams());
    result.fold(
      (failure) => state = state.toError(failure.message),
      (products) => state = state.toSuccess(products),
    );
  }

  Future<void> refresh() => load();
}

// ─── Provider ───
final productProvider =
    StateNotifierProvider<ProductNotifier, BaseState<List<Product>>>((ref) {
  return ProductNotifier(
    getProducts: ref.watch(getProductsUseCaseProvider),
  );
});
```

---

### Paso 5 — Pantalla

**Lista** `lib/features/products/presentation/product_list_screen.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/snackbar_service.dart';
import 'providers/product_provider.dart';

class ProductListScreen extends ConsumerWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(productProvider);

    // Mostrar error via snackbar (sin BuildContext en el notifier)
    ref.listen(productProvider, (_, next) {
      if (next.hasError) SnackbarService.showError(next.error!);
    });

    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.hasError && !state.hasData) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(state.error!),
            FilledButton(
              onPressed: () => ref.read(productProvider.notifier).refresh(),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    final products = state.data ?? [];

    return RefreshIndicator(
      onRefresh: () => ref.read(productProvider.notifier).refresh(),
      child: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ListTile(
            title: Text(product.name),
            subtitle: Text('\$${product.price}'),
            onTap: () => context.push(
              AppConstants.productDetailRoute.replaceFirst(':id', product.id),
            ),
          );
        },
      ),
    );
  }
}
```

---

## Cómo crear una pantalla con formulario

Sigue el patrón de `EditProfileScreen` o `ChangePasswordScreen`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/services/snackbar_service.dart';
import '../../../core/utils/validators.dart';

class MyFormScreen extends ConsumerStatefulWidget {
  const MyFormScreen({super.key});

  @override
  ConsumerState<MyFormScreen> createState() => _MyFormScreenState();
}

class _MyFormScreenState extends ConsumerState<MyFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  bool _isSaving = false;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    setState(() => _isSaving = true);

    // await ref.read(myProvider.notifier).save(...);
    await Future.delayed(const Duration(seconds: 1)); // reemplazar

    if (!mounted) return;
    setState(() => _isSaving = false);

    SnackbarService.showSuccess('Guardado correctamente');
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi formulario'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilledButton(
              onPressed: _isSaving ? null : _handleSave,
              child: const Text('Guardar'),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (v) => Validators.validateRequired(v, fieldName: 'El título'),
                enabled: !_isSaving,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

---

## Servicios del core

### SnackbarService

Muestra notificaciones desde cualquier capa, sin `BuildContext`:

```dart
SnackbarService.showSuccess('Operación exitosa');
SnackbarService.showError('Algo salió mal');
SnackbarService.showWarning('Revisa los datos');
SnackbarService.showInfo('Token actualizado');
```

Funciona porque `scaffoldMessengerKey` está registrado en `MaterialApp.router` en `main.dart`.

### AppLogger

```dart
AppLogger.debug('mensaje debug', tag: 'MI_FEATURE');
AppLogger.warning('advertencia');
AppLogger.error('error', error: e, stackTrace: st);
```

Solo registra cuando `enableLogging` es `true` (activo en dev/staging).

### Validators

```dart
TextFormField(
  validator: Validators.validateEmail,           // Requerido + formato
  validator: Validators.validatePassword,        // 8 chars, upper, lower, digit, especial
  validator: (v) => Validators.validateName(v, fieldName: 'El apellido'),
  validator: Validators.validatePhoneOptional,   // Acepta vacío
);
```

---

## Manejo de estado

### BaseState\<T\> — para datos simples

```dart
// En el notifier:
state = state.toLoading();
state = state.toSuccess(data);
state = state.toError('Error al cargar');

// En la pantalla:
if (state.isLoading) return const CircularProgressIndicator();
if (state.hasError)  return Text(state.error!);
final data = state.data!;
```

### PaginatedNotifier\<T\> — para listas con paginación

```dart
class ProductListNotifier extends PaginatedNotifier<Product> {
  final ProductRepository _repo;
  ProductListNotifier(this._repo);

  @override
  Future<PaginatedResponse<Product>> fetchPage(int page) {
    return _repo.getProductsPage(page);
  }
}

// En la pantalla, cargar más al llegar al final:
NotificationListener<ScrollEndNotification>(
  onNotification: (n) {
    if (n.metrics.extentAfter < 100) {
      ref.read(productListProvider.notifier).loadMore();
    }
    return false;
  },
  child: ListView.builder(...),
)
```

---

## Ambientes

Cambiar en `lib/main.dart`:

```dart
EnvConfig.initialize(Environment.dev);      // mock login, logs, banner naranja
EnvConfig.initialize(Environment.staging);  // API staging, sin mock
EnvConfig.initialize(Environment.prod);     // API producción, sin logs, sin errores expuestos
```

URLs base en `lib/core/config/env_config.dart`:

```dart
case Environment.dev:
  return EnvConfig._('https://api-dev.tuapp.com/v1', ...);
case Environment.staging:
  return EnvConfig._('https://api-staging.tuapp.com/v1', ...);
case Environment.prod:
  return EnvConfig._('https://api.tuapp.com/v1', ...);
```

---

## Comandos

```bash
# Desarrollo
flutter run
flutter run -d <device_id>

# Análisis
flutter analyze

# Tests
flutter test
flutter test test/features/auth/

# Generación de código (Freezed / json_serializable)
dart run build_runner build --delete-conflicting-outputs
dart run build_runner watch --delete-conflicting-outputs   # modo watch

# Builds de distribución
flutter build apk --release
flutter build appbundle --release
flutter build ipa --release
```

---

## Dependencias principales

| Paquete | Uso |
|---------|-----|
| `flutter_riverpod` | Estado reactivo (StateNotifier, Provider) |
| `go_router` | Navegación declarativa, ShellRoute, auth guard |
| `dio` | Cliente HTTP con interceptores |
| `dartz` | `Either<Failure, T>` para manejo funcional de errores |
| `flutter_secure_storage` | JWT tokens cifrados |
| `shared_preferences` | Preferencias ligeras (tema) |
| `freezed` + `json_serializable` | Modelos inmutables con serialización |
| `equatable` | Comparación por valor en entidades |
| `flutter_screenutil` | Diseño adaptativo (base 375×812) |
| `pretty_dio_logger` | Logs de requests HTTP (solo dev) |
| `connectivity_plus` | Estado de conexión en tiempo real |
