# Timers Project

## Timers Project

The **Timers Project** is a timer management application built with Flutter. It provides functionality for:

- Managing multiple timers
- Tracking completed timers
- Exporting timer history as JSON files
### User Assumptions
This application is designed with the following user expectations:
- Users understand basic timer functionality (start/stop/reset)
- Users will name timers meaningfully for identification
- Typical timer durations will be between 1 second to 24 hours
- Users will manually export data for backup purposes
- Dark/light mode preference is a personal choice
- Completed timer history is primarily for reference
- No cloud sync (using SharedPreferences for local storage only)
- Android storage permissions will be granted when requested

### Development Assumptions
The application was built with these foundational principles:
- Core functionality focused on timers and stopwatches
- Design inspired by digital wellbeing apps and system widgets
- Prioritizes essential timing functions over complex features
- Follows platform conventions for timer applications
- Optimized for quick start/stop functionality 


**Technical Implementation:**
- Uses BLoC (Business Logic Component) pattern for state management
- Implements Clean Architecture for scalable application structure
- Utilizes local storage via SharedPreferences package

## Table of Contents

- [Introduction](#introduction)
- [Setup Instructions](#setup-instructions)
- [Prerequisites](#prerequisites)
- [Running the Project](#running-the-project)
- [Export Timer Data](#export-timer-data)
- [Features](#features)

## Introduction

This application allows users to:

- Start, pause, reset, and complete timers.
- View a history of completed timers.
- Export the timer history as a JSON file.
- Toggle between light and dark themes.

It is built using **Flutter** and **BLoC** for state management, making it a fully reactive application.

## Setup Instructions

Follow the steps below to set up the project on your local machine and run it on a physical or virtual device.

### Step 1: Clone the Repository

First, clone the repository to your local machine. You can do this by running the following command in your terminal:


git clone https://github.com/Vinaykch18/Timers_Project.git .


### Step 2: Navigate to the Project Directory
cd Timers_Project

### Step 3: Get Flutter Dependencies
flutter pub get

### Step 4: Run The Application
flutter run

### Step 5: Build The application (Optional)
flutter build apk
flutter build apk --debug
flutter build apk --release

## Prerequisites
Before running this project, make sure you have the following installed and set up:
- Flutter SDK (version 3.22.3 or later)
- Dart SDK
- Android Studio or Visual Studio Code with Flutter extension
- At least one Android emulator or a physical device connected

Accept Android SDK licenses (if not done already):
flutter doctor --android-licenses

To verify everything is installed properly:
flutter doctor

## Export Timer Data
This app supports exporting completed timer history as a .json file.

How to Export:
1. Go to the History screen using the bottom navigation
2. Tap the Export icon in the AppBar
3. Timer data is saved as a JSON file in the app's documents directory

=> Ensure file system permissions are enabled for the app, especially on Android 11 and above

## Features
1. Create timers with custom names and durations
2. Start, pause, resume, and reset timers individually
3. Automatically complete timers when they finish
4. View a history of all completed timers
5. Toggle between light and dark mode
6. Export completed timers to a JSON file
7. Manage all timers using BLoC for smooth and reactive state management