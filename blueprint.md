# Project Blueprint

## Overview

This document outlines the project, including its style, design, and features, from the initial version to the current state. It also details the plan for any requested changes.

## Implemented Features & Architecture

*   **Initial Project:** A new Flutter project.

*   **Theming Engine:**
    *   Implemented a Material 3 theme with a consistent color scheme and typography using `ColorScheme.fromSeed`.
    *   Added the `google_fonts` package for custom fonts.
    *   Integrated the `provider` package for state management.
    *   Created a `ThemeProvider` to handle light and dark mode toggling.

*   **SQflite Database Demo (`item_sqflite_demo.dart`):**
    *   **Architecture:** Implements a repository pattern using a `DatabaseService` singleton class to encapsulate all SQflite database operations. This separates the data logic from the UI.
    *   **UI:** A `StatefulWidget` that provides a user interface to:
        *   Add new items to the database.
        *   Remove items from the database by name.
        *   Delete the entire database file.
        *   View database metadata and contents in a dual-scrolling view (vertical and horizontal).
    *   **Bug Fix (ScrollController):** Resolved a runtime exception by implementing `ScrollController`s for the nested `SingleChildScrollView` widgets. The `Scrollbar.thumbVisibility` property, when set to `true`, requires a controller to be explicitly provided to both the `Scrollbar` and its corresponding scroll view. This was fixed by creating, assigning, and properly disposing of both a vertical and horizontal `ScrollController`.

## Current Plan

*   No active plan. Ready for the next request.
