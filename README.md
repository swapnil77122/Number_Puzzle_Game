

---

# Number Puzzle Game

A classic sliding number puzzle implemented in Flutter. Arrange tiles in ascending order by moving them into the empty spot.

---

## Demo

*(Insert animated GIF or screenshot here if available.)*

---

## Table of Contents

* [Setup & Installation](#setup--installation)
* [Level Structure](#level-structure)
* [Architecture](#architecture)
* [Game Rules](#game-rules)
* [APK & Demo Video](#apk--demo-video)
* [Contact](#contact)

---

## Setup & Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/swapnil77122/Number_Puzzle_Game.git
   cd Number_Puzzle_Game
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Run the app**

   ```bash
   flutter run
   ```

4. **Build a release APK**

   ```bash
   flutter build apk --release
   ```

---

## Level Structure

* The game starts with a **3×3 grid** containing numbers 1–8 and one empty space.
* Levels increase in complexity (if implemented), such as:

  * **Level Progression**: Each level shuffles tiles more thoroughly or deepens the puzzle's randomness.
  * **Move Limits / Time Constraints**: Future enhancements can introduce move or time-based challenges.
* Currently, the game ends when the player arranges the tiles in ascending order.

---

## Architecture

```
lib/
├── main.dart              # Entry point
├── game_page.dart         # UI for puzzle layout and interaction
├── game_logic.dart        # Core logic: tile movement, win detection
└── models/
    └── tile.dart          # (Optional) Tile model with position/value
```

* **`main.dart`**: Initializes the app and displays the main puzzle screen.
* **`game_logic.dart`**: Handles tile swapping, boundary checks, and verifies completion.
* **`game_page.dart`**: Renders the grid using Flutter widgets and captures touch gestures.
* **State Management**: Uses `setState`, or optionally `Provider` or `Riverpod` for scalability.
* **Responsive UI**: Adapts to device size using flexible layouts and paddings.

---

## Game Rules

1. Slide adjacent tiles into the empty slot.
2. Goal: Order tiles sequentially from **1** to **8**, with the empty tile in the final position.
3. Only one move per tap or swipe.
4. Win condition triggers when all tiles are in correct order.

---

## APK & Demo Video

* **APK**: Available in the [**Releases**](https://github.com/swapnil77122/Number_Puzzle_Game/releases) section.
* **Demo Video**: A short (30–60 sec) screen recording demonstrating gameplay is available here:
  \[Insert Video Link]

---

## Contact

For questions or feedback, reach out at:

* **Email**: [your.email@example.com](mailto:your.email@example.com)
* **GitHub**: [@swapnil77122](https://github.com/swapnil77122)

---

Thank you for checking out my game! I hope you enjoy playing it as much as I enjoyed building it.

---
