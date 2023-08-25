# bloc_ease
A dart library to solve boilerplate issues with flutter_bloc

![image](https://github.com/Bharathh-Raj/bloc_ease/assets/42716432/f9a24509-a816-48fd-bd14-5b5163a97d00)

![image](https://github.com/Bharathh-Raj/bloc_ease/assets/42716432/115729d6-4e51-4b42-9c4c-80ef683cb294)

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

Notice that, `ItemInitialState` not used even though it can be accessed.
![image](https://github.com/Bharathh-Raj/bloc_ease/assets/42716432/0b4020be-020f-4d0a-8190-90f995a629fd)

## Templates
### Intellij and Android Studio 

Copy both templates at once -> Intellij/Android studio Settings -> Live Templates -> Create new template group as BlocEase -> Paste

```dtd
<template name="bloceasebloc" value="import 'package:bloc_ease/bloc_ease.dart';&#10;import 'package:flutter_bloc/flutter_bloc.dart';&#10;&#10;part '$EventsFileName$';&#10;&#10;typedef $BlocName$State = FourStates&lt;$SuccessType$&gt;;&#10;&#10;typedef $BlocName$InitialState = InitialState&lt;$SuccessType$&gt;;&#10;typedef $BlocName$LoadingState = LoadingState&lt;$SuccessType$&gt;;&#10;typedef $BlocName$SucceedState = SucceedState&lt;$SuccessType$&gt;;&#10;typedef $BlocName$FailedState = FailedState&lt;$SuccessType$&gt;;&#10;&#10;typedef $BlocName$Builder = BlocBuilder&lt;$BlocName$Bloc, $BlocName$State&gt;;&#10;typedef $BlocName$BlocEaseBuilder = FourStateBuilder&lt;$BlocName$Bloc, $SuccessType$&gt;;&#10;&#10;class $BlocName$Bloc extends Bloc&lt;$BlocName$Event,$BlocName$State&gt; {&#10;  $BlocName$Bloc()&#10;      : super($BlocName$InitialState());&#10;      &#10;  $ImplementationStart$&#10;}" description="BlocEase Four state bloc template" toReformat="false" toShortenFQNames="true">
  <variable name="EventsFileName" expression="" defaultValue="" alwaysStopAt="true" />
  <variable name="BlocName" expression="" defaultValue="" alwaysStopAt="true" />
  <variable name="SuccessType" expression="" defaultValue="" alwaysStopAt="true" />
  <variable name="ImplementationStart" expression="" defaultValue="" alwaysStopAt="true" />
  <context>
    <option name="DART" value="true" />
    <option name="FLUTTER" value="true" />
  </context>
</template>
<template name="bloceasecubit" value="import 'package:bloc_ease/bloc_ease.dart';&#10;import 'package:flutter_bloc/flutter_bloc.dart';&#10;&#10;typedef $CubitName$State = FourStates&lt;$SuccessType$&gt;;&#10;&#10;typedef $CubitName$InitialState = InitialState&lt;$SuccessType$&gt;;&#10;typedef $CubitName$LoadingState = LoadingState&lt;$SuccessType$&gt;;&#10;typedef $CubitName$SucceedState = SucceedState&lt;$SuccessType$&gt;;&#10;typedef $CubitName$FailedState = FailedState&lt;$SuccessType$&gt;;&#10;&#10;typedef $CubitName$Builder = BlocBuilder&lt;$CubitName$Cubit, $CubitName$State&gt;;&#10;typedef $CubitName$BlocEaseBuilder = FourStateBuilder&lt;$CubitName$Cubit, $SuccessType$&gt;;&#10;&#10;class $CubitName$Cubit extends Cubit&lt;$CubitName$State&gt; {&#10;  $CubitName$Cubit()&#10;      : super($CubitName$InitialState());&#10;      &#10;  $ImplementationStart$&#10;}" description="BlocEase Four state cubit template" toReformat="false" toShortenFQNames="true">
  <variable name="CubitName" expression="" defaultValue="" alwaysStopAt="true" />
  <variable name="SuccessType" expression="" defaultValue="SuccessType" alwaysStopAt="true" />
  <variable name="ImplementationStart" expression="" defaultValue="" alwaysStopAt="true" />
  <context>
    <option name="DART" value="true" />
    <option name="FLUTTER" value="true" />
  </context>
</template>
```

### VSCode

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
			"typedef ${2}Builder = BlocBuilder<${2}Bloc, ${2}State>;",
			"typedef ${2}BlocEaseBuilder = FourStateBuilder<${2}Bloc, ${3}>;",
			"",
			"class ${2}Bloc extends Bloc<${2}Event,${2}State> {",
			"\t${2}Bloc() : super(${2}InitialState());",
			"",
			"\t${4}",
			"}"
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
			"typedef ${1}Builder = BlocBuilder<${1}Cubit, ${1}State>;",
			"typedef ${1}BlocEaseBuilder = FourStateBuilder<${1}Cubit, ${2}>;",
			"",
			"class ${1}Cubit extends Cubit<${1}State> {",
			"  ${1}Cubit() : super(${1}InitialState());",
			"",	  
			"  $3",
			"}"
		]
	}
}
```
