# Flutter Clean Architecture App

## 📱 Descripción

Aplicación Flutter con arquitectura limpia (Clean Architecture), modular, mantenible y lista para conectar con APIs externas. Implementa las mejores prácticas de desarrollo y patrones de diseño para aplicaciones de producción.

## 🚀 Características

- ✅ **Clean Architecture**: Separación clara entre capas (Presentación, Dominio, Datos)
- ✅ **Autenticación JWT**: Sistema completo de autenticación con tokens
- ✅ **Manejo de Estado**: Implementado con Riverpod
- ✅ **Cliente HTTP**: Configurado con Dio e interceptores
- ✅ **CRUD Funcional**: Ejemplo completo de Tasks (crear, leer, actualizar, eliminar)
- ✅ **Tema Claro/Oscuro**: Soporte completo para temas
- ✅ **Validaciones**: Sistema robusto de validaciones reutilizables
- ✅ **Navegación**: Implementada con GoRouter y redirección automática
- ✅ **Responsive**: Diseño adaptativo con ScreenUtil

## 🏗️ Arquitectura

```
lib/
├── core/                       # Núcleo de la aplicación
│   ├── network/               # Configuración de red
│   │   ├── api_client.dart   # Cliente HTTP con Dio
│   │   ├── api_exceptions.dart # Excepciones personalizadas
│   │   └── endpoints.dart    # Endpoints de la API
│   ├── errors/
│   │   └── failures.dart     # Manejo de errores del dominio
│   ├── theme/
│   │   ├── app_theme.dart    # Configuración de temas
│   │   ├── light_theme.dart  # Tema claro
│   │   └── dark_theme.dart   # Tema oscuro
│   ├── utils/
│   │   └── validators.dart   # Validadores reutilizables
│   └── constants/
│       └── app_constants.dart # Constantes de la app
│
├── features/                   # Features de la aplicación
│   ├── auth/                  # Autenticación
│   │   ├── data/
│   │   │   ├── models/       # Modelos con serialización
│   │   │   ├── datasources/  # Fuentes de datos
│   │   │   └── repositories/ # Implementación de repositorios
│   │   ├── domain/
│   │   │   ├── entities/     # Entidades del dominio
│   │   │   ├── repositories/ # Contratos de repositorios
│   │   │   └── usecases/     # Casos de uso
│   │   └── presentation/
│   │       ├── providers/    # Providers de Riverpod
│   │       └── screens/      # Pantallas de UI
│   │
│   └── example/               # Feature de ejemplo (Tasks)
│       ├── data/
│       ├── domain/
│       └── presentation/
│
├── main.dart                  # Punto de entrada
└── routes.dart               # Configuración de rutas
```

## 🛠️ Tecnologías Utilizadas

- **Flutter**: Framework de desarrollo multiplataforma
- **Dart**: Lenguaje de programación
- **Riverpod**: Manejo de estado reactivo
- **Dio**: Cliente HTTP potente
- **GoRouter**: Navegación declarativa
- **Freezed**: Generación de código para modelos inmutables
- **Flutter Secure Storage**: Almacenamiento seguro
- **Pretty Dio Logger**: Logs de peticiones HTTP

## 📦 Instalación

1. **Clonar el repositorio**
```bash
git clone https://github.com/tuusuario/flutter-clean-architecture.git
cd flutter-clean-architecture
```

2. **Instalar dependencias**
```bash
flutter pub get
```

3. **Generar código**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. **Configurar la API**
Editar el archivo `lib/core/network/endpoints.dart` y actualizar la URL base:
```dart
static const String baseUrl = 'https://tu-api.com/v1';
```

5. **Ejecutar la aplicación**
```bash
flutter run
```

## 🔐 Autenticación

El sistema de autenticación incluye:

- **Login**: Autenticación con email y contraseña
- **Registro**: Creación de nuevas cuentas
- **Recuperación de contraseña**: Envío de email para resetear contraseña
- **Tokens JWT**: Manejo automático de tokens y refresh tokens
- **Persistencia**: Almacenamiento seguro de credenciales
- **Auto-logout**: Cierre de sesión automático cuando expira el token

### Flujo de Autenticación

1. Usuario ingresa credenciales
2. App envía credenciales a la API
3. API valida y retorna tokens (access + refresh)
4. App almacena tokens de forma segura
5. Tokens se incluyen automáticamente en requests
6. Si el token expira, se intenta refrescar automáticamente
7. Si el refresh falla, se redirige al login

## 📝 CRUD de Ejemplo (Tasks)

El módulo de Tasks demuestra:

- **Listado**: Con filtros y paginación
- **Creación**: Formulario con validaciones
- **Edición**: Actualización de datos existentes
- **Eliminación**: Con confirmación
- **Filtros**: Por estado y prioridad
- **Estados**: Pending, In Progress, Completed, etc.
- **Prioridades**: Low, Medium, High, Urgent

## 🎨 Temas

La aplicación soporta:

- Tema claro
- Tema oscuro
- Cambio dinámico de tema
- Persistencia de preferencia
- Colores personalizados por tema

## 🔄 Manejo de Estado

Implementado con Riverpod:

- **Providers**: Para inyección de dependencias
- **StateNotifier**: Para estados complejos
- **FutureProvider**: Para operaciones asíncronas
- **StateProvider**: Para estados simples

## 🌐 Cliente HTTP

Configuración de Dio incluye:

- **Interceptores**: Para logs, auth, y errores
- **Timeout**: Configuración de timeouts
- **Headers**: Headers globales y dinámicos
- **Retry Logic**: Reintentos en caso de fallo
- **Error Handling**: Manejo centralizado de errores

## ✅ Validaciones

Validadores incluidos:

- Email
- Password (con requisitos de seguridad)
- Nombre
- Teléfono
- URLs
- Números
- Rangos
- Fechas
- Tarjetas de crédito
- Y más...

## 🚦 Testing

```bash
# Ejecutar tests
flutter test

# Con coverage
flutter test --coverage

# Generar reporte HTML
genhtml coverage/lcov.info -o coverage/html
```

## 📱 Pantallas

1. **Login**: Autenticación de usuarios
2. **Registro**: Creación de cuentas
3. **Recuperar Contraseña**: Reset de password
4. **Lista de Tareas**: Dashboard principal
5. **Formulario de Tarea**: Crear/Editar tareas
6. **Perfil**: Información del usuario

## 🔧 Configuración Adicional

### Variables de Entorno

Crear archivo `.env`:
```
API_BASE_URL=https://api.example.com
API_TIMEOUT=30000
```

### Build para Producción

```bash
# Android
flutter build apk --release
flutter build appbundle --release

# iOS
flutter build ipa --release
```

## 📄 Licencia

Este proyecto está bajo la Licencia MIT.

## 👥 Contribuir

1. Fork el proyecto
2. Crear una rama (`git checkout -b feature/AmazingFeature`)
3. Commit cambios (`git commit -m 'Add AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abrir Pull Request

## 📞 Contacto

Tu Nombre - [@tutwitter](https://twitter.com/tutwitter) - email@example.com

Link del Proyecto: [https://github.com/tuusuario/flutter-clean-architecture](https://github.com/tuusuario/flutter-clean-architecture)