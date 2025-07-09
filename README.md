📝 TodoList App
A simple Flutter note-taking app with support for creating, editing, deleting, pinning, and searching notes. Features light/dark mode and local data storage using SQLite.

🚀 Features

Add, edit, delete notes
Pin/unpin notes
Local storage with SQLite
Light/Dark mode (saved with preferences)
Real-time search
Clean UI with Google Fonts

📁 Project Structure

lib/
├── db/                 # SQLite logic
├── models/             # Note model
├── providers/          # Theme provider
├── screens/            # UI pages
├── widgets/            # Custom widgets
└── main.dart           # App entry point

🛠️ Dependencies
sqflite
path
provider
shared_preferences
google_fonts

Add them in pubspec.yaml and run:
flutter pub get

▶️ Run the App
flutter run

📌 Notes
Theme preference is saved using SharedPreferences
Notes are stored locally in notes.db
Search works on both title and content
