# ToDo App

## Overview
A simple and intuitive native iOS task management application built with Objective-C. It allows users to efficiently track their tasks, categorize them by status (To Do, In Progress, Done), filter by priority levels (High, Medium, Low), and persistently store data locally on the device.

## Key Features
- **Task Management**: Create, read, update, and delete tasks.
- **Progress Tracking**: Organize and filter tasks based on their current status (To Do, In Progress, Done).
- **Priority Categorization**: Assign priority levels (High, Medium, Low) to tasks and group them accordingly with visual indicators.
- **Search Functionality**: Quickly search and filter tasks by name.
- **Local Persistence**: All task data is saved locally on the device for seamless offline access.

## Tech Stack
- **Language**: Objective-C
- **UI Framework**: UIKit
- **Core Framework**: Foundation
- **State & Data Management**: `NSUserDefaults` for persistent local data storage
- **External Dependencies**: None (Pure native implementation)

## Architecture
The application follows the classic **MVC (Model-View-Controller)** structural design pattern:
- **Model**: The `Task` object encapsulates task-related data (name, description, priority, status, date) and handles dictionary serialization for persistence.
- **View**: Utilizes Storyboards (`Main.storyboard`) and standard UIKit components like `UITableView`, `UISearchBar`, and `UISegmentedControl` to build the user interface.
- **Controller**: Manages user interactions and data flow. Key controllers include:
  - `ViewController`: Manages the main task list, segmented filters, and search functionalities.
  - `NewTaskViewController`: Handles the creation of new tasks.
  - `TaskDetailsViewController`: Handles viewing, editing, and deleting existing tasks.

## Setup & Installation
Follow these steps to build and run the project locally:
1. **Clone the repository** to your local machine.
2. Open the project in Xcode by double-clicking the `ToDo App.xcodeproj` file.
3. Wait for Xcode to index the project. No external dependencies or package managers need to be installed.
4. Select your preferred iOS Simulator or a connected physical iOS device from the Xcode toolbar.
5. Click the **Run** button (or press `Cmd + R`) to build and launch the application.
