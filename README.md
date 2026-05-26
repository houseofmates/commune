# The Commune

A socialist/communist themed idle/incremental game built with Godot 4.3.

## Overview

In "The Commune", you build and manage a self-sustaining worker community. Manage resources, build infrastructure, and grow the collective through labor and knowledge.

## Architecture

The game uses 4 core autoload singletons:
- `EventBus`: Centralized signal management.
- `GameState`: Stores all game data (resources, buildings).
- `SaveManager`: Handles JSON persistence and offline progress.
- `ResourceManager`: Manages the game tick and resource production/consumption.

## Getting Started

### Prerequisites
- Godot Engine 4.3 (Forward Plus renderer recommended)

### Running the Game
```bash
make run
```

### Exporting
- **Android APK**: `make export-android`
- **Linux AppImage**: `make export-linux`

## Art Direction
- **Character (John)**: 70s aesthetic - brown curly hair, mustache, patterned shirt, bell-bottoms.
- **World**: Isometric pixel art (30x30 grid).

## Development
- Use `make import` to initialize the project in the Godot editor.
- Data definitions are located in `data/buildings.json` and `data/resources.json`.
