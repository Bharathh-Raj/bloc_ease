# bloc_ease
A dart library to solve boilerplate issues with flutter_bloc

## Problems this library addresses
1. Writing same type of states for every blocs / cubits (Initial, Loading, Success, Failure).
2. Overriding == and hashcode, or using Equatable package for all states.
3. Need to handle every states in the UI even-though we just need success state.
4. Return same widget for same kind of state across all blocs / cubits (ProgressIndicator for Loading state).
5. Need to handle buildWhen so that we don't need to handle every states.
6. Choosing bad practice of using Single-state class instead of Inheritance so that its easy for us to handle in UI.
7. Choosing bad practice of managing multiple states together because of boilerplate.

We are going to solve these using
  - Generics (Inherited states)
  - Inherited Widget (Global state widgets)
  - Builders (Snippet attached)
  - typedefs (Snippet attached)
Don't worry about any of these. This package will take care of everything.

## Solutions this library provides
1. Don't need to write state classes for any Bloc / Cubit. Instead using the state comes with this package with generics (SucceedState<Auth> vs SucceedState<User>).
2. Globally handling common states like Initial, Loading, Failure states in UI. Don't need to worry about these state where-ever we are using Bloc / Cubit.
3. Comes with a builder that provides the success object in typesafe manner and it could handle other states by itself.
4. Using typedefs to easily differentiate between states (typedef AuthSucceedState = SucceedState<Auth>). (Snippet included for Intellij and VSCode)

## Details
`InitialState` `LoadingState` `SucceedState` `FailedState`. Trust me, we could hold any state with one of these states. If we could not hold our state within these states, we are probably handling multiple states together.
- Asynchronous CRUD Operation state can usually be either of these 4 states.
  - Backend fetching
  - Device IO Job
  - Multi-threaded operations
- Some synchronous Operation state can be either of 3 states other than `LoadingState`.
  - Parsing logic
  - Encryption / Decryption logic
  - Filtering a list with some condition
- Some synchronous operation can hold just `SucceedState` or `FailedState`.
  - Calculation (`SucceedState<double>(10)` vs `FailedState<double>(DivideByZeroException())`)
- Some state can only be depicted as `SucceedState`. 
  - Flutter's Default counter app state `SucceedState<Int>(0)`
  - Selecting app currency `SucceedState<Currency>(USD())` or unit of temperature `SucceedState<TemperatureUnit>(Celsius())`

## Example Snippets
### Fetching current user
Fetching user usually needs 4 states. 
  - Initial state - When not logged in
  - Loading state - When fetching in progress
  - Succeed state - When successfully fetched
  - Failed state - User not available / Failed to fetch
#### Usual implementation
```dart
import 'package:flutter_bloc/flutter_bloc.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit(this.userRepo) : super(const UserInitialState());

  final UserRepo userRepo;

  void fetchUser() async {
    emit(const UserLoadingState());

    try {
      final user = userRepo.fetchUser();
      emit(UserSucceedState(user));
    } catch (e) {
      emit(UserFailedState('Failed to fetch user', e));
    }
  }
}

sealed class UserState {}

class UserInitialState implements UserState {
  const UserInitialState();
}

class UserLoadingState implements UserState {
  const UserLoadingState();
}

class UserSucceedState implements UserState {
  final User user;

  UserSucceedState(this.user);
}

class UserFailedState implements UserState {
  final String message;
  final dynamic exception;

  UserFailedState(this.message, this.exception);
}
```

#### bloc_ease implementation
```dart
import 'package:bloc_ease/bloc_ease.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// We just need to define these typedefs instead of writing state classes ourselves.
// Don't worry, code template I added will automatically write this for you.
typedef UserState = FourStates<User>;
typedef UserInitialState = InitialState<User>;
typedef UserLoadingState = LoadingState<User>;
typedef UserSucceedState = SucceedState<User>;
typedef UserFailedState = FailedState<User>;

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(const UserInitialState());

  // Essentially we just need to write this part of code.
  void fetchUser() async {
    emit(const UserLoadingState());

    try {
      final user = userRepo.fetchUser();
      emit(UserSucceedState(user));
    } catch (e) {
      emit(UserFailedState('Failed to fetch user', e));
    }
  }
}
```

## Additional information

TODO: Tell users more about the package: where to find more information, how to
contribute to the package, how to file issues, what response they can expect
from the package authors, and more.
