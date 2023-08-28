# bloc_ease
A dart library to solve boilerplate issues with [flutter_bloc](https://pub.dev/packages/flutter_bloc) by just using typedefs instead of defining state classes.

![image](https://github.com/Bharathh-Raj/bloc_ease/assets/42716432/f9a24509-a816-48fd-bd14-5b5163a97d00)

![image](https://github.com/Bharathh-Raj/bloc_ease/assets/42716432/115729d6-4e51-4b42-9c4c-80ef683cb294)

# Index
- [Problems this library addresses](#problems-this-library-addresses)
- [Solutions this library provides](#solutions-this-library-provides)
- [Readme](#readme)
- [How to use?](#how-to-use)
- [Example Snippets](#example-snippets)
- [Templates](#templates)
- [Tips and Tricks](#tips-and-tricks)
- [Example projects](#example-projects)

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
  - InheritedWidget (Global state widgets)
  - Builders
  - typedefs (Use [templates](#templates))
Don't worry about any of these. This package will take care of everything.

## Solutions this library provides
1. Don't need to write state classes for any Bloc / Cubit. Instead using the state comes with this package with generics (`SucceedState<Auth>` vs `SucceedState<User>`).
2. Globally handling common states like Initial, Loading, Failure states in UI. Don't need to worry about these state where-ever we are using Bloc / Cubit.
3. Comes with a builder that provides the success object in typesafe manner and it could handle other states by itself.
4. Using typedefs to easily differentiate between states (`typedef AuthSucceedState = SucceedState<Auth>`). (Snippet included for Intellij and VSCode)

## Readme
`InitialState` `LoadingState` `SucceedState` `FailedState`. Trust me, we could hold any state with one of these states. If we could not hold our state within these states, we are most probably managing multiple states together.
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

## How to use?
### Step 1 - Configuring `BlocEaseStateWidgetsProvider`
`BlocEaseStateWidgetsProvider` is used to configure the default widgets for `InitialState`, `LoadingState` and `FailedState`. 
Remember, make sure this widget is wrapped over the `MaterialApp` so that it is accessible from everywhere.
```dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocEaseStateWidgetsProvider( // <--
      initialStateBuilder: () => const Placeholder(),
      loadingStateBuilder: ([progress]) => const Center(child: CircularProgressIndicator()),
      failureStateBuilder: ([exceptionObject, failureMessage]) => Center(child: Text(failureMessage ?? 'Oops something went wrong!')),
      child: MaterialApp(
          //..
          ),
    );
  }
}
```
### Step 2 - Create Bloc/Cubit with the snippet/template provided below.
Use the shortcut `bloceasebloc` or `bloceasecubit` from the [template](#templates) to create bloc or cubit based on the need. That creates this template and you just need to edit 2 names.
1. Cubit name -> UserCubit
2. Success Object -> User (This is the object we expect from the success state of the bloc/cubit)

```dart
import 'package:bloc_ease/bloc_ease.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef UserState = FourStates<User>; // <-- Success Object

typedef UserInitialState = InitialState<User>;
typedef UserLoadingState = LoadingState<User>;
typedef UserSucceedState = SucceedState<User>;
typedef UserFailedState = FailedState<User>;

typedef UserBlocBuilder = BlocBuilder<UserCubit, UserState>;
typedef UserBlocListener = BlocListener<UserCubit, UserState>;
typedef UserBlocConsumer = BlocConsumer<UserCubit, UserState>;

typedef UserBlocEaseBuilder = FourStateBuilder<UserCubit, User>;
typedef UserBlocEaseListener = FourStateListener<UserCubit, User>;
typedef UserBlocEaseConsumer = FourStateConsumer<UserCubit, User>;

class UserCubit extends Cubit<UserState> { //<--Cubit name
  UserCubit(this.userRepo)
          : super(const UserInitialState());

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

### Step 3 - Use `<CubitName>BlocEaseBuilder` instead of BlocBuilder in the UI
`<CubitName>BlocEaseBuilder (UserBlocEaseBuilder)` is the builder we can use to access the Success Object we configured in Step 2 with `succeedBuilder` required field.
All the other states `InitialState`, `LoadingState` and `FailedState` uses the default widgets we configured in Step 1.

```dart
class SomeWidget extends StatelessWidget {
  const SomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return UserBlocEaseBuilder( //<-- <CubitName>BlocEaseBuilder
      succeedBuilder: (user)    //<-- This provides the Success Object we configured in the Step 2.
        => SomeOtherWidget(user),
    );
  }
}
```

## Example Snippets
### Fetching user details
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

Notice that, `ItemInitialState` not used even though it can be accessed.
![image](https://github.com/Bharathh-Raj/bloc_ease/assets/42716432/0b4020be-020f-4d0a-8190-90f995a629fd)

## Templates
### Intellij and Android Studio 

Copy both templates at once -> Intellij/Android studio Settings -> Live Templates -> Create new template group as BlocEase -> Paste

```dtd
<template name="bloceasebloc" value="import 'package:bloc_ease/bloc_ease.dart';&#10;import 'package:flutter_bloc/flutter_bloc.dart';&#10;&#10;part '$EventsFileName$';&#10;&#10;typedef $BlocName$State = FourStates&lt;$SuccessType$&gt;;&#10;&#10;typedef $BlocName$InitialState = InitialState&lt;$SuccessType$&gt;;&#10;typedef $BlocName$LoadingState = LoadingState&lt;$SuccessType$&gt;;&#10;typedef $BlocName$SucceedState = SucceedState&lt;$SuccessType$&gt;;&#10;typedef $BlocName$FailedState = FailedState&lt;$SuccessType$&gt;;&#10;&#10;typedef $BlocName$BlocBuilder = BlocBuilder&lt;$BlocName$Bloc, $BlocName$State&gt;;&#10;typedef $BlocName$BlocListener = BlocListener&lt;$BlocName$Bloc, $BlocName$State&gt;;&#10;typedef $BlocName$BlocConsumer = BlocConsumer&lt;$BlocName$Bloc, $BlocName$State&gt;;&#10;&#10;typedef $BlocName$BlocEaseBuilder = FourStateBuilder&lt;$BlocName$Bloc, $SuccessType$&gt;;&#10;typedef $BlocName$BlocEaseListener = FourStateListener&lt;$BlocName$Bloc, $SuccessType$&gt;;&#10;typedef $BlocName$BlocEaseConsumer = FourStateConsumer&lt;$BlocName$Bloc, $SuccessType$&gt;;&#10;&#10;class $BlocName$Bloc extends Bloc&lt;$BlocName$Event,$BlocName$State&gt; {&#10;  $BlocName$Bloc()&#10;      : super(const $BlocName$InitialState());&#10;      &#10;  $ImplementationStart$&#10;}" description="BlocEase Four state bloc template" toReformat="false" toShortenFQNames="true">
  <variable name="EventsFileName" expression="" defaultValue="" alwaysStopAt="true" />
  <variable name="BlocName" expression="" defaultValue="" alwaysStopAt="true" />
  <variable name="SuccessType" expression="" defaultValue="" alwaysStopAt="true" />
  <variable name="ImplementationStart" expression="" defaultValue="" alwaysStopAt="true" />
  <context>
    <option name="DART" value="true" />
    <option name="FLUTTER" value="true" />
  </context>
</template>
<template name="bloceasecubit" value="import 'package:bloc_ease/bloc_ease.dart';&#10;import 'package:flutter_bloc/flutter_bloc.dart';&#10;&#10;typedef $CubitName$State = FourStates&lt;$SuccessType$&gt;;&#10;&#10;typedef $CubitName$InitialState = InitialState&lt;$SuccessType$&gt;;&#10;typedef $CubitName$LoadingState = LoadingState&lt;$SuccessType$&gt;;&#10;typedef $CubitName$SucceedState = SucceedState&lt;$SuccessType$&gt;;&#10;typedef $CubitName$FailedState = FailedState&lt;$SuccessType$&gt;;&#10;&#10;typedef $CubitName$BlocBuilder = BlocBuilder&lt;$CubitName$Cubit, $CubitName$State&gt;;&#10;typedef $CubitName$BlocListener = BlocListener&lt;$CubitName$Cubit, $CubitName$State&gt;;&#10;typedef $CubitName$BlocConsumer = BlocConsumer&lt;$CubitName$Cubit, $CubitName$State&gt;;&#10;&#10;typedef $CubitName$BlocEaseBuilder = FourStateBuilder&lt;$CubitName$Cubit, $SuccessType$&gt;;&#10;typedef $CubitName$BlocEaseListener = FourStateListener&lt;$CubitName$Cubit, $SuccessType$&gt;;&#10;typedef $CubitName$BlocEaseConsumer = FourStateConsumer&lt;$CubitName$Cubit, $SuccessType$&gt;;&#10;&#10;class $CubitName$Cubit extends Cubit&lt;$CubitName$State&gt; {&#10;  $CubitName$Cubit()&#10;      : super(const $CubitName$InitialState());&#10;      &#10;  $ImplementationStart$&#10;}" description="BlocEase Four state cubit template" toReformat="false" toShortenFQNames="true">
  <variable name="CubitName" expression="" defaultValue="" alwaysStopAt="true" />
  <variable name="SuccessType" expression="" defaultValue="SuccessType" alwaysStopAt="true" />
  <variable name="ImplementationStart" expression="" defaultValue="" alwaysStopAt="true" />
  <context>
    <option name="DART" value="true" />
    <option name="FLUTTER" value="true" />
  </context>
</template>
```

![image](https://github.com/Bharathh-Raj/bloc_ease/assets/42716432/08135f7d-0daf-4d30-b06d-5b0c012b72d1)

### VSCode (TODO: Change and test)

Copy -> VSCode -> Cmd(Ctrl) + Shift + P -> "Snippets: Configure User Snippets" -> dart.json -> Paste

```json
{
  "BlocEase Bloc": {
    "prefix": ["bloceasebloc"],
    "description": "BlocEase Four state bloc template",
    "body": [
      "import 'package:bloc_ease/bloc_ease.dart';",
      "import 'package:flutter_bloc/flutter_bloc.dart';",
      "",
      "part '${1:eventsFileName}';",
      "",
      "typedef ${2:BlocName}State = FourStates<${3:SuccessType}>;",
      "",
      "typedef ${2}InitialState = InitialState<${3}>;",
      "typedef ${2}LoadingState = LoadingState<${3}>;",
      "typedef ${2}SucceedState = SucceedState<${3}>;",
      "typedef ${2}FailedState = FailedState<${3}>;",
      "",
      "typedef ${2}BlocBuilder = BlocBuilder<${2}Bloc, ${2}State>;",
      "typedef ${2}BlocListener = BlocListener<${2}Bloc, ${2}State>;",
      "typedef ${2}BlocConsumer = BlocConsumer<${2}Bloc, ${2}State>;",
      "",
      "typedef ${2}BlocEaseBuilder = FourStateBuilder<${2}Bloc, ${3}>;",
      "",
      "class ${2}Bloc extends Bloc<${2}Event,${2}State> {",
      "\t${2}Bloc() : super(const ${2}InitialState());",
      "",
      "\t${4}",
      "}",
    ]
  },
  "BlocEase Cubit": {
    "prefix": ["bloceasecubit"],
    "description": "BlocEase Four state cubit template",
    "body": [
      "import 'package:bloc_ease/bloc_ease.dart';",
      "import 'package:flutter_bloc/flutter_bloc.dart';",
      "",
      "typedef ${1:CubitName}State = FourStates<${2:SuccessType}>;",
      "",
      "typedef ${1}InitialState = InitialState<${2}>;",
      "typedef ${1}LoadingState = LoadingState<${2}>;",
      "typedef ${1}SucceedState = SucceedState<${2}>;",
      "typedef ${1}FailedState = FailedState<${2}>;",
      "",
      "typedef ${1}BlocBuilder = BlocBuilder<${1}Cubit, ${1}State>;",
      "typedef ${1}BlocListener = BlocListener<${1}Cubit, ${1}State>;",
      "typedef ${1}BlocConsumer = BlocConsumer<${1}Cubit, ${1}State>;",
      "",
      "typedef ${1}BlocEaseBuilder = FourStateBuilder<${1}Cubit, ${2}>;",
      "",
      "class ${1}Cubit extends Cubit<${1}State> {",
      "  ${1}Cubit() : super(const ${1}InitialState());",
      "",
      "  $3",
      "}"
    ]
  }
}
```

## Tips and Tricks
### Using `BlocEaseListener` and `BlocEaseConsumer`
The template also generates `<CubitName>BlocEaseListener` and `<CubitName>BlocEaseConsumer` which can be used instead of BlocListener and BlocConsumer.
```dart
class BlocEaseListenerExampleWidget extends StatelessWidget {
  const BlocEaseListenerExampleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // All fields are optional
    return UserBlocEaseListener( //<-- <CubitName>BlocEaseListener
      initialListener: () {},
      loadingListener: ([progress]) {},
      failureListener: ([failureMessage, exception]) {},
      succeedListener: (user) {},
      child: //..//,
    );
  }
}

class BlocEaseConsumerExampleWidget extends StatelessWidget {
  const BlocEaseConsumerExampleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Other than succeedBuilder, all fields are optional.
    return UserBlocEaseConsumer( //<-- <CubitName>BlocEaseConsumer
      initialListener: () {},
      loadingListener: ([progress]) {},
      failureListener: ([failureMessage, exception]) {},
      succeedListener: (user) {},

      initialBuilder: () {},
      loadingBuilder: ([progress]) {},
      failureBuilder: ([failureMessage, exception]) ={},
      succeedBuilder: (user) => SomeWidget(user),
    );
  }
}
```

### Work with Bloc
Use the shortcut `bloceasebloc` from the [template](#templates) to create a bloc based on your need with all the typedefs defined for you.
```dart
import 'package:bloc_ease/bloc_ease.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'user_event.dart';

typedef UserState = FourStates<User>;

typedef UserInitialState = InitialState<User>;
typedef UserLoadingState = LoadingState<User>;
typedef UserSucceedState = SucceedState<User>;
typedef UserFailedState = FailedState<User>;

typedef UserBlocBuilder = BlocBuilder<UserBloc, UserState>;
typedef UserBlocListener = BlocListener<UserBloc, UserState>;
typedef UserBlocConsumer = BlocConsumer<UserBloc, UserState>;

typedef UserBlocEaseBuilder = FourStateBuilder<UserBloc, User>;
typedef UserBlocEaseListener = FourStateListener<UserBloc, User>;
typedef UserBlocEaseConsumer = FourStateConsumer<UserBloc, User>;

class UserBloc extends Bloc<UserEvent,UserState> {
  UserBloc()
      : super(const UserInitialState()){
    // on...
  } 
}
```

### Accessing default widget using context.
Sometimes, we need to access the default loading widget without using builder or we need to wrap the default loading widget with some other widget.
We can access the default widgets with the help of context extensions.
- `context.initialStateWidget` -> Default initial state widget.
- `context.loadingStateWidget` -> Default loading state widget.
- `context.failedStateWidget` -> Default failed state widget.
```dart
class SomeWidget extends StatelessWidget {
  const SomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return UserBlocEaseBuilder(
      loadingBuilder: ([progress]) => ColoredBox(
        color: Colors.yellow,
        child: context.loadingStateWidget(progress), //<--Accessing default loading widget with 'context.loadingStateWidget'
      ),
      succeedBuilder: (user) => SomeOtherWidget(user),
    );
  }
}
```

### Take advantage of Records when defining SuccessObject type.
In some cases, we need multiple params as Success object. In that case, we could easily take advantage of Records instead of creating a data class for that.
```dart
import 'package:bloc_ease/bloc_ease.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef UserState = FourStates<(User, String)>; // <-- Success Object

typedef UserInitialState = InitialState<(User, String)>;
typedef UserLoadingState = LoadingState<(User, String)>;
typedef UserSucceedState = SucceedState<(User, String)>;
typedef UserFailedState = FailedState<(User, String)>;

typedef UserBlocBuilder = BlocBuilder<UserCubit, UserState>;
typedef UserBlocListener = BlocListener<UserCubit, UserState>;
typedef UserBlocConsumer = BlocConsumer<UserCubit, UserState>;

typedef UserBlocEaseBuilder = FourStateBuilder<UserCubit, (User, String)>;

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(const UserInitialState());

  //..//
}
```

### Testing
Testing is also totally straight-forward as just using Bloc/Cubit.
```dart
blocTest<UserCubit, UserState>(
        'emits UserSucceedState after fetching user',
        setUp: () {
          when(repo.fetchUser).thenAnswer((_) async => mockUser);
        },
        build: () => UserCubit(repository: repo),
        act: (cubit) => cubit.fetchUser(),
        expect: () => UserSucceedState(mockUser), //<--
        verify: (_) => verify(repository.fetchUser).called(1),
      );
```

### Take advantage of all typedefs generated by this template.
One of the painful work with using BlocBuilder is that we need to write the entire boilerplate everytime. Take advantage of the typedefs generated by the [template](#templates) provided.
- `UserBlocBuilder` instead of `BlocBuilder<UserCubit, UserState>`
- `UserBlocListener` instead of `BlocListener<UserCubit, UserState>`
- `UserBlocConsumer` instead of `BlocConsumer<UserCubit, UserState>`

### Overriding the default state widgets for a certain page or widget tree
If we wrap the same `BlocEaseStateWidgetsProvider` over some widget tree, all the default widgets gets overridden with this new implementation.
So all the BlocEaseBuilders comes under this widget use this overridden widgets as default case.
```dart
class SomePage extends StatelessWidget {
  const SomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocEaseStateWidgetsProvider(
      initialStateBuilder: () => const SizedBox(),
      loadingStateBuilder: ([progress]) => const CustomLoader(),
      failureStateBuilder: ([exception, message]) => Text(message ?? 'Oops something went wrong!'),
      child: //..//,
    );
  }
}
```

## Example projects
These example projects are taken from the official [flutter_bloc](https://pub.dev/packages/flutter_bloc) package examples. So that its easy to compare the implementation. Also it passes all the test cases.
1. [complex_list](https://github.com/Bharathh-Raj/bloc_ease/tree/main/examples/complex_list)
2. [flutter_shopping_cart](https://github.com/Bharathh-Raj/bloc_ease/tree/main/examples/flutter_shopping_cart)

## Features and bugs
Please file feature requests and bugs at the [issue tracker](https://github.com/Bharathh-Raj/bloc_ease/issues).

## Connect with me [@Bharath](https://linktr.ee/bharath.dev)

[![image](https://www.buymeacoffee.com/assets/img/guidelines/download-assets-sm-3.svg)](https://www.buymeacoffee.com/bharath213)