# Contributing to Blockchain Sim+

Thank you for your interest in contributing to Blockchain Sim+! We welcome contributions from everyone.

## Getting Started

1.  **Fork** the repository on GitHub.
2.  **Clone** your fork locally.

## Project Structure

This project uses **Swift Package Manager (SPM)** to modularize the core logic (`Domain` and `Data` layers), making it easier to test and develop without opening the full Xcode workspace.

-   `Blockchain/Blockchain/Domain`: Core business logic and models (Platform independent).
-   `Blockchain/Blockchain/Data`: Data repositories and services.
-   `Blockchain/Blockchain/Presentation`: SwiftUI Views and ViewModels.
-   `Blockchain/Blockchain/App`: App lifecycle and configuration.

## Running Tests

We have enabled unit tests for the core logic. You can run these tests using the command line (if you have Swift installed) or via Xcode.

### Command Line
```bash
swift test
```

### Xcode
Open `Package.swift` or the `.xcodeproj` file and run the test scheme.

## Pull Request Process

1.  Create a new branch for your feature or bugfix (`git checkout -b feature/amazing-feature`).
2.  Commit your changes with clear messages.
3.  Push your branch to your fork.
4.  Open a Pull Request against the `main` branch.
5.  Ensure that the **CI/CD** checks (GitHub Actions) pass.

## Code Style

-   Follow standard Swift naming conventions.
-   Keep the logic in the `Domain` layer as pure as possible.
