# bloc_ease
A dart library to solve boilerplate issues with flutter_bloc

![image](https://github.com/Bharathh-Raj/bloc_ease/assets/42716432/80d77660-059e-4828-a94f-a5129ecd58bb)

![image](https://github.com/Bharathh-Raj/bloc_ease/assets/42716432/115729d6-4e51-4b42-9c4c-80ef683cb294)

## Problems this library addresses
1. Writing same type of state classes for every blocs / cubits (Initial, Loading, Success, Failure).
2. Overriding == and hashcode, or using Equatable package for all states.
3. Separate files for cubits / blocs and its states.
4. Need to handle every states in the UI even-though we just need success state.
5. Return same widget for same kind of state across all blocs / cubits (ProgressIndicator for Loading state).
6. Need to handle buildWhen so that we don't need to handle every states.
7. Choosing bad practice of using Single-state class instead of Inheritance so that its easy for us to handle in UI.
8. Choosing bad practice of managing multiple states together because of boilerplate.

We are going to solve these using
- Generics (Inherited states)
- InheritedWidget (Global state widgets)
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

## Steps to implement
### Step 1 - Provide widgets for common states.
We need to wrap the widget BlocEaseStateWidgetsProvider over MaterialApp by configuring default widget for `InitialState`, `LoadingState` and `FailedState`.
```dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Wrap this BlocEaseStateWidgetsProvider widget over MaterialApp.
    return BlocEaseStateWidgetsProvider(
      initialStateBuilder: () => const Placeholder(),
      loadingStateBuilder: ([progress]) => const Center(child: CircularProgressIndicator()),
      failureStateBuilder: ([exception, message]) => Center(child: Text(message ?? 'Something went wrong!')),
      child: MaterialApp(
        //..
      ),
    );
  }
}
```

### Step 2 - Write Cubit or Bloc with template
Use the template `bloceasecubit` which will write the typedefs for you with Cubit name. Remember none of these typedefs need to be written by us. The template will takes care of it all.
```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_ease/bloc_ease.dart';

// Template code start
typedef UserState = FourStates<User>;           //<--  Similar to `sealed class UserState{}`

typedef UserInitialState = InitialState<User>;  //<--  Similar to `class UserInitialState implements UserState{}`
typedef UserLoadingState = LoadingState<User>;  //<--  Similar to `class UserLoadingState implements UserState{...}`
typedef UserSucceedState = SucceedState<User>;  //<--  Similar to `class UserSucceedState implements UserState{...}`
typedef UserFailedState = FailedState<User>;    //<--  Similar to `class UserFailedState implements UserState{...}`

typedef UserBuilder = BlocBuilder<UserCubit, UserState>;  //<-- UserBuilder can be used instead of BlocBuilder<UserCubit, UserState>
typedef UserBlocEaseBuilder = FourStateBuilder<UserCubit, User>;  //<-- UserBlocEaseBuilder automatically handles Initial, Loading, Failed state
// Template code end

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
```

### Step 3 - Accessing `SucceedState` using builders
Usually we need to use `BlocBuilder` or `BlocConsumer` to access user states. But we need to manage all the states when-ever we are using these builders.
By using `UserBlocEaseBuilder` created in the cubit file, we can just directly access `SucceedState`. For all the other states `InitialState`, `LoadingState` and `FailedState`, this `UserBlocEaseBuilder` uses widgets provided in `BlocEaseStateWidgetsProvider` at the first step.
To remember: Don't forget to provide the UserCubit with BlocProvider before using this widget. Or use `bloc` field in this builder widget to provide cubit/bloc. 
```dart
class SomeWidget extends StatelessWidget {
  const SomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // 3. Access user object with `UserBlocEaseBuilder`. 
    return UserBlocEaseBuilder(
      succeedBuilder: (user) => SomeOtherWidget(user.name),
    );
  }
}
```




## Example Snippets
### Fetching current user
Fetching user usually needs 4 states.
- Initial state - When not logged in
- Loading state - When fetching in progress
- Succeed state - When successfully fetched
- Failed state - User not available / Failed to fetch

![image](https://github.com/Bharathh-Raj/bloc_ease/assets/42716432/80d77660-059e-4828-a94f-a5129ecd58bb)

### Fetching item details on opening item page
Since we need to fetch the item on opening the page, this usually holds 3 states.
- Loading state - When fetching in progress
- Succeed state - when item fetched successfully
- Failed state - When failed to fetch item






