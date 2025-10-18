/// Represents an authenticated user in the domain layer.
///
/// This is a pure domain entity with no external dependencies.
/// It contains only the essential user information needed for authentication.
class AppUser {
  /// Unique identifier for the user.
  final String id;

  /// User's email address.
  final String email;

  /// User's display name (optional).
  final String? name;

  /// Whether this is a guest user (temporary, no account).
  final bool isGuest;

  /// Creates an [AppUser] instance.
  const AppUser({
    required this.id,
    required this.email,
    this.name,
    this.isGuest = false,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AppUser &&
        other.id == id &&
        other.email == email &&
        other.name == name &&
        other.isGuest == isGuest;
  }

  @override
  int get hashCode =>
      id.hashCode ^ email.hashCode ^ name.hashCode ^ isGuest.hashCode;

  @override
  String toString() =>
      'AppUser(id: $id, email: $email, name: $name, isGuest: $isGuest)';
}
