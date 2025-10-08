//==============================================================================
// game_definitions.vh - Shared Constants and Definitions for Game Project
//==============================================================================
// Purpose:
//   This header file provides centralized definitions for all constants used
//   across the game modules, including level states, display dimensions,
//   sprite sizes, colors, and movement parameters.
//
// Usage:
//   Include this file at the top of any Verilog module using:
//   `include "game_definitions.vh"
//
// Note:
//   Include guards prevent multiple inclusion issues during compilation.
//==============================================================================

`ifndef GAME_DEFINITIONS_VH
`define GAME_DEFINITIONS_VH

//==============================================================================
// Level State Constants (2-bit values)
//==============================================================================
// These constants define the game's finite state machine levels
// Used by: game_fsm.v, score_counter.v, drawcon.v, top_game.v

`define LEVEL1      2'd0        // First level state
`define LEVEL2      2'd1        // Second level state
`define LEVEL3      2'd2        // Third level state
`define WIN_STATE   2'd3        // Final win state (game complete)

//==============================================================================
// Player Sprite Dimensions (pixels)
//==============================================================================
// Dimensions of the player character sprite (Pacman)
// Used by: top_game.v, drawcon.v for collision detection and rendering

`define BLK_SIZE_X  100         // Player sprite width in pixels
`define BLK_SIZE_Y  100         // Player sprite height in pixels

//==============================================================================
// VGA Display Constants (pixels)
//==============================================================================
// Standard VGA resolution used for the game display
// Used by: vga.v and drawing modules

`define SCREEN_WIDTH    640     // Horizontal resolution in pixels
`define SCREEN_HEIGHT   480     // Vertical resolution in pixels

//==============================================================================
// Tile System Constants
//==============================================================================
// The game uses a tile-based maze system where each level is divided into
// a grid of tiles. These constants define tile properties.
// Used by: level1.v, level2.v, level_3.v, drawcon.v, top_game.v

`define TILE_MARGIN     3       // Wall thickness/margin in pixels (for collision)
`define TILE_W          288     // Tile width in pixels (standard for level1)
`define TILE_H          160     // Tile height in pixels (standard for level1)

// Note: Level tile grid is typically 5×5 tiles = 1440×800 pixels total
// Each level may have different configurations, but these are reference values

//==============================================================================
// Infobar Dimensions
//==============================================================================
// The infobar displays level information at the top of the screen
// It is stored at 400×25 pixels but scaled 4× for display
// Used by: drawcon.v for rendering the level information bar

`define INFO_W      400         // Infobar source width in pixels
`define INFO_H      25          // Infobar source height in pixels
`define INFO_SCALE  4           // Scale factor for infobar display (2^2 = 4x)

// Note: Displayed infobar size is 400×100 pixels on screen (INFO_W × INFO_H × INFO_SCALE)
// The infobar occupies the top 100 pixels of the screen (y = 0 to 99)

//==============================================================================
// Color Definitions (12-bit RGB format: [11:8]=R, [7:4]=G, [3:0]=B)
//==============================================================================
// Color constants used throughout the game rendering
// Format: 12'hRGB where each component is 4-bit (0-15)
// Used by: drawcon.v for rendering walls, backgrounds, and sprites

`define COLOR_WALL          12'hFFF     // White (R=15, G=15, B=15) - maze walls
`define COLOR_BACKGROUND    12'hF5F     // Magenta/Pink (R=15, G=5, B=15) - default background

//==============================================================================
// Movement Constants
//==============================================================================
// Constants controlling game timing and player movement speed
// Used by: top_game.v for game clock generation and player movement

`define GAME_CLK_DIV    21'd200_000     // Clock divider for game tick (at 100MHz input)
                                        // Creates ~500Hz game clock (200,000 cycles)
                                        
`define MOVE_STEP_SIZE  2               // Player movement speed in pixels per game tick
                                        // Player moves 2 pixels per frame when button pressed

//==============================================================================
// End of Include Guard
//==============================================================================

`endif // GAME_DEFINITIONS_VH
