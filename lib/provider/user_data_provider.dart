import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i_chef_application/firebase/user_firestore.dart';
import '../model/user_data.dart';

class UserDataNotifier extends StateNotifier<UserData> {
  final UserFirestoreService firestore;

  UserDataNotifier(this.firestore)
    : super(
        UserData(
          name: '',
          email: '',
          username: '',
          cuisine: '',
          allergies: [],
          intolerances: [],
          age: 0,
          gender: '',
        ),
      );
  void removeAllergy(String allergy) {
    state = state.copyWith(
      allergies: state.allergies.where((a) => a != allergy).toList(),
    );
  }

  void addAllergy(String allergy) {
    // avoid duplicates
    if (state.allergies.contains(allergy)) return;

    final updated = [...state.allergies, allergy];
    state = state.copyWith(allergies: updated);
  }

  // Intolerances
  void addIntolerance(String value) {
    if (!state.intolerances.contains(value)) {
      state = state.copyWith(intolerances: [...state.intolerances, value]);
    }
  }

  void removeIntolerance(String value) {
    state = state.copyWith(
      intolerances: state.intolerances.where((v) => v != value).toList(),
    );
  }

  // --- SETTERS ---
  void setName(String name) => state = state.copyWith(name: name);
  void setEmail(String email) => state = state.copyWith(email: email);
  void setUsername(String username) =>
      state = state.copyWith(username: username);
  void setCountry(String country) => state = state.copyWith(country: country);
  void setAllergies(List<String> allergies) =>
      state = state.copyWith(allergies: allergies);
  void setIntolerances(List<String> intolerances) =>
      state = state.copyWith(intolerances: intolerances);
  void setAge(int age) => state = state.copyWith(age: age);
  void setGender(String gender) => state = state.copyWith(gender: gender);

  // --- SAVE ---
  Future<void> createUserInFirebase() async {
    await firestore.saveUser(state);
  }

  // --- FETCH ---
  Future<void> getUserDataFromFirebase() async {
    final data = await firestore.fetchUser();
    state = data;
  }
}

final userFirestoreProvider = Provider((ref) => UserFirestoreService());

final userDataProvider = StateNotifierProvider<UserDataNotifier, UserData>(
  (ref) => UserDataNotifier(ref.read(userFirestoreProvider)),
);
