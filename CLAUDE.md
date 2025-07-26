# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Common Development Commands

### Running the Game
- `task dev` - Open project in Godot Editor
- `task run` - Run the game directly
- `task run:headless` - Run in headless mode (for CI/testing)

### Building
- `task build` - Build for current platform (debug)
- `task build:release` - Build release version
- `task build:all` - Build for all platforms (Windows, macOS, Linux)
- `task build:web` - Build for web/HTML5
- `task serve:web` - Serve web build locally on port 8000

### Testing & Validation
- `task validate` - Validate project files and scenes
- `task test` - Run tests (requires GUT framework)
- `task check` - Run full quality check (validate + test + build)

### Code Quality
- `task lint` - Check GDScript style (requires gdtoolkit: `pip install gdtoolkit`)
- `task format` - Format GDScript code (requires gdtoolkit)

### Git Shortcuts
- `task git:commit` - Stage all changes and commit
- `task git:push` - Push to remote
- `task git:pull` - Fetch and merge

### Other
- `task clean` - Clean build artifacts and temporary files
- `task setup` - Initial project setup
- `task package` - Create distribution package

## Project Structure

This is a Godot 4.4+ game project for GMTK Game Jam 2025. The project uses:
- **Godot Engine 4.4+** as the game engine
- **Task** (Taskfile) for build automation
- **GDScript** as the primary scripting language (though no scripts exist yet)

### Key Directories
- `/IntroToGodot/` - Contains game scenes and assets
  - Character scenes: cam_character.tscn, ian_character.tscn, jed_character.tscn, sean_character.tscn
  - Level: test_level.tscn
  - `/Backgrounds/` - Background assets and elements
- `/builds/` - Build output directory (created by build tasks)
- `/dist/` - Distribution packages

### Input Configuration
The game has WASD + Arrow key support configured for movement:
- `move_left`: A, Left Arrow
- `move_right`: D, Right Arrow  
- `move_up`: W, Up Arrow
- `move_down`: S, Down Arrow

### Development Notes
- The project is currently in early development with basic character and level scenes
- No GDScript files exist yet - gameplay logic needs to be implemented
- Export presets must be configured in Godot Editor before using platform-specific build commands
- The Godot executable path can be customized in Taskfile.yml if needed