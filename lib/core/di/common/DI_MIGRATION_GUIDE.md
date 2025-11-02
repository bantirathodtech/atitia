# Dependency Injection Migration Guide

## Overview

This guide explains how to use the new DI abstraction layer that allows swapping between Firebase, Supabase, and REST API backends without changing business logic code.

## Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    ViewModels                            │
│  (No changes needed when swapping backends)             │
└────────────────────┬────────────────────────────────────┘
                     │ Uses
                     ▼
┌─────────────────────────────────────────────────────────┐
│                    Repositories                          │
│  (Use IDatabaseService, IStorageService interfaces)     │
└────────────────────┬────────────────────────────────────┘
                     │ Uses
                     ▼
┌─────────────────────────────────────────────────────────┐
│              Interface Layer (Abstract)                  │
│  IDatabaseService, IStorageService, IAuthService, etc.  │
└────────────────────┬────────────────────────────────────┘
                     │ Implemented by
                     ▼
┌─────────────────────────────────────────────────────────┐
│            Adapter Layer (Concrete)                      │
│  FirebaseDatabaseAdapter, SupabaseAdapter, RestAdapter  │
└────────────────────┬────────────────────────────────────┘
                     │ Wraps
                     ▼
┌─────────────────────────────────────────────────────────┐
│          Service Layer (Concrete)                        │
│  FirestoreServiceWrapper, SupabaseStorage, etc.         │
└─────────────────────────────────────────────────────────┘
```

## Current Status

### ✅ Completed
- Interface definitions (`IDatabaseService`, `IStorageService`, `IAuthService`, `IAnalyticsService`)
- DI configuration (`DIConfig`, `BackendProvider`)
- Service factory pattern
- Firebase database adapter (`FirebaseDatabaseAdapter`)
- Unified service locator structure

### ⚠️ In Progress / TODO
- Complete Firebase adapters for Auth, Analytics, Storage
- Supabase adapter implementations
- REST API adapter implementations
- Repository migration to use interfaces
- ViewModel injection via constructor (currently uses direct instantiation)

## Usage Examples

### Switching Backend Provider

```dart
// In main.dart or initialization code
import 'package:atitia/core/di/common/di_config.dart';
import 'package:atitia/core/di/common/unified_service_locator.dart';

// Switch to Supabase
DIConfig.switchProvider(BackendProvider.supabase);
await UnifiedServiceLocator.initialize();

// Or switch to REST API
DIConfig.switchProvider(BackendProvider.restApi);
await UnifiedServiceLocator.initialize();

// Default is Firebase
// DIConfig.switchProvider(BackendProvider.firebase);
```

### Using Services in Repositories

**Before (Direct Firebase dependency):**
```dart
class GuestProfileRepository {
  final _firestoreService = getIt.firestore; // Direct dependency
  // ...
}
```

**After (Interface dependency):**
```dart
import 'package:atitia/core/di/common/unified_service_locator.dart';
import 'package:atitia/core/interfaces/database/database_service_interface.dart';

class GuestProfileRepository {
  final IDatabaseService _databaseService; // Interface dependency
  
  GuestProfileRepository({IDatabaseService? databaseService}) 
    : _databaseService = databaseService ?? UnifiedServiceLocator.getIt.database;
  
  Future<GuestProfile?> getProfile(String userId) async {
    final doc = await _databaseService.getDocument('users', userId);
    // ...
  }
}
```

### Injecting Repositories into ViewModels

**Before (Direct instantiation):**
```dart
class GuestProfileViewModel {
  final _repository = GuestProfileRepository(); // Direct instantiation
  // ...
}
```

**After (Constructor injection):**
```dart
class GuestProfileViewModel {
  final GuestProfileRepository _repository;
  
  GuestProfileViewModel({GuestProfileRepository? repository})
    : _repository = repository ?? GuestProfileRepository();
  // ...
}
```

## Migration Steps

1. **Update Service Registration** (In progress)
   - Register both concrete services and interface implementations
   - Use instance names to differentiate implementations

2. **Update Repositories** (TODO)
   - Change from `getIt.firestore` to `IDatabaseService` injection
   - Accept services via constructor with default fallback

3. **Update ViewModels** (TODO)
   - Accept repositories via constructor
   - Register factories in dependency container

4. **Create Adapters** (In progress)
   - Firebase adapters (Database ✅, Auth/Analytics/Storage TODO)
   - Supabase adapters (All TODO)
   - REST API adapters (All TODO)

5. **Update Dependency Containers**
   - Use factories that inject dependencies
   - Register ViewModels with repository dependencies

## Benefits

1. **Easy Backend Migration**: Switch between Firebase, Supabase, REST API by changing one line
2. **Testability**: Mock interfaces for unit testing
3. **Code Reusability**: Business logic unchanged when swapping backends
4. **Future-Proof**: Easy to add new backend providers

## Current Limitations

- Firebase adapters partially implemented
- Supabase/REST adapters not yet implemented
- Repositories still use direct service access
- ViewModels still instantiate repositories directly

These will be addressed in future iterations.

