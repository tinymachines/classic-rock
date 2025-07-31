# Terminal Colors Greatest Hits

A curated collection of the finest terminal color code demonstrations and utilities.

## Attribution

This collection is based on content from:
- **Source**: Unix & Linux Stack Exchange
- **Post**: [tput setaf color table? How to determine color codes?](https://unix.stackexchange.com/questions/269077/tput-setaf-color-table-how-to-determine-color-codes)
- **Question ID**: 269077
- **Site**: unix.stackexchange.com

## Overview

This collection includes various methods for working with terminal colors, from basic 8-color support to full 16 million color (24-bit) displays.

## Features

### 1. Basic 8 Colors

The fundamental ANSI colors available in virtually all terminals:

| Color   | Code | Foreground | Background | RGB Values    |
|---------|------|------------|------------|---------------|
| Black   | 0    | 30         | 40         | 0, 0, 0       |
| Red     | 1    | 31         | 41         | max, 0, 0     |
| Green   | 2    | 32         | 42         | 0, max, 0     |
| Yellow  | 3    | 33         | 43         | max, max, 0   |
| Blue    | 4    | 34         | 44         | 0, 0, max     |
| Magenta | 5    | 35         | 45         | max, 0, max   |
| Cyan    | 6    | 36         | 46         | 0, max, max   |
| White   | 7    | 37         | 47         | max, max, max |

**Usage**: `\e[30-37m` for foreground, `\e[40-47m` for background

### 2. Extended 256 Colors

Modern terminals support 256 colors using the format:
- **Foreground**: `\e[38;5;COLORm`
- **Background**: `\e[48;5;COLORm`

Where COLOR is a number from 0-255:
- 0-15: Basic 16 colors (includes the basic 8 plus bright variants)
- 16-231: 216 colors in a 6×6×6 RGB cube
- 232-255: 24 grayscale colors

### 3. 16 Million Colors (24-bit/True Color)

For terminals supporting true color:
- **Foreground**: `\e[38;2;R;G;Bm`
- **Background**: `\e[48;2;R;G;Bm`

Where R, G, and B are values from 0-255.

## Utility Functions

### Color Index ↔ Hex Conversion

The script includes two useful conversion utilities:

1. **fromhex**: Converts a hex color (#RRGGBB) to the nearest 256-color palette index
2. **tohex**: Converts a color index (0-255) to its hex representation

## Usage Examples

```bash
# Show basic 8 colors
./terminal-colors.sh basic8

# Display all 256 colors
./terminal-colors.sh 256

# Show ordered, numbered 256-color grid
./terminal-colors.sh 256ordered

# Test 16 million color support
./terminal-colors.sh 16mil

# Display RGB color table
./terminal-colors.sh rgbtable

# Convert hex to color index
./terminal-colors.sh fromhex #00fc7b
# Output: Hex #00fc7b → Color index: 048

# Convert color index to hex
./terminal-colors.sh tohex 125
# Output: dec= 125 color= #af005f

# Run all demonstrations
./terminal-colors.sh all
```

## Terminal Compatibility

- **Basic 8 colors**: Universal support
- **256 colors**: Most modern terminals (xterm-256color, iTerm2, GNOME Terminal, etc.)
- **16 million colors**: Limited support (iTerm2, GNOME Terminal 3.12+, Konsole, etc.)

Check your terminal's color capability:
```bash
tput colors
```

## Color Space Organization (256 colors)

The 256-color palette is organized as follows:

1. **Colors 0-15**: System colors (basic 8 + bright variants)
2. **Colors 16-231**: 6×6×6 color cube
   - Formula: `16 + 36r + 6g + b` where r,g,b ∈ {0,1,2,3,4,5}
   - Actual RGB values: 0, 95, 135, 175, 215, 255
3. **Colors 232-255**: Grayscale ramp (24 shades)
   - From rgb(8,8,8) to rgb(238,238,238)

## Technical Notes

- Always reset colors with `\e[0m` after use
- Some terminals use `setf`/`setb` instead of `setaf`/`setab`
- The actual RGB values for "max" in basic colors are terminal-dependent
- True color support can be tested by displaying a smooth gradient

## License

This collection is compiled from publicly shared Stack Exchange content. Please refer to Stack Exchange's terms of service for usage rights. The original contributors retain copyright to their contributions.

## Contributing

For improvements or corrections to the original content, please contribute to the Stack Exchange post linked above.