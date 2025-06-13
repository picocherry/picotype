# Font Metadata Patcher

A Python script that processes fonts in the `src` folder and adds proper metadata for each font family and style.

## Features

- Automatically detects font families and styles from directory structure
- Sets comprehensive font metadata including PS Names, OS/2 properties, and TTF Names
- Supports both directory-based and filename-based style detection
- Configurable output formats and naming conventions
- Proper weight class and style mapping

## Directory Structure

The script expects the following directory structure:

```
src/
├── picosans/
│   ├── regular/
│   │   └── PicoSans-Regular.ttf
│   ├── italic/
│   │   └── PicoSans-Italic.ttf
│   ├── bold/
│   │   └── PicoSans-Bold.ttf
│   └── bolditalic/
│       └── PicoSans-BoldItalic.ttf
├── picotypepro/
│   ├── regular/
│   │   └── PicoTypePro-Regular.otf
│   └── bold/
│       └── PicoTypePro-Bold.otf
└── picotype/
    └── PicoType-Regular.ttf  # Direct files also supported
```

Output structure:

```
build/
├── picosans/
│   ├── picosans-regular.ttf
│   ├── picosans-italic.ttf
│   ├── picosans-bold.ttf
│   └── picosans-bolditalic.ttf
├── picotypepro/
│   ├── picotypepro-regular.otf
│   └── picotypepro-bold.otf
└── picotype/
    └── picotype-regular.ttf
```

## Usage

### Basic Usage

```bash
# Process all families in src/ directory
python3 font-metadata-patcher.py

# Process specific family
python3 font-metadata-patcher.py --family picosans

# Use custom source and output directories
python3 font-metadata-patcher.py --src fonts --output dist
```

### Advanced Options

```bash
# Set custom version
python3 font-metadata-patcher.py --version "2.000"

# Convert names to lowercase
python3 font-metadata-patcher.py --lowercase

# Set width class for condensed fonts
python3 font-metadata-patcher.py --width condensed

# Set font type for monospace fonts
python3 font-metadata-patcher.py --type monospace

# Change output format
python3 font-metadata-patcher.py --extension otf

# Enable debug logging
python3 font-metadata-patcher.py --debug
```

## Command Line Options

| Option | Description | Default |
|--------|-------------|---------|
| `--src`, `-s` | Source directory containing font families | `src` |
| `--output`, `-o` | Output directory for processed fonts | `build` |
| `--version`, `-v` | Set font version (e.g., "1.000") | Keep original |
| `--width` | Set OS/2 width class | `normal` |
| `--type` | Set PFM family type | None |
| `--extension`, `-ext` | Output file extension | Keep original |
| `--lowercase` | Convert all font names to lowercase | False |
| `--debug` | Enable debug logging | False |
| `--family` | Process only a specific font family | All families |

### Width Options

- `ultracondensed` (50%)
- `extracondensed` (62.5%)  
- `condensed` (75%)
- `semicondensed` (87.5%)
- `normal` (100%) - default
- `medium` (100%)
- `semiexpanded` (112.5%)
- `expanded` (125%)
- `extraexpanded` (150%)
- `ultraexpanded` (200%)

### Type Options

- `serif` - Serif fonts
- `sans` - Sans-serif fonts  
- `monospace` - Monospaced fonts
- `script` - Script/handwriting fonts
- `decorative` - Display/decorative fonts

## Metadata Set by the Script

### PS Names
- **Fontname**: `familyname-style` (e.g., `picosans-bold`)
- **Family Name**: `familyname` (e.g., `picosans`)  
- **Name For Humans**: `familyname style` (e.g., `picosans bold`)
- **Weight**: Detected from style or filename
- **Version**: Original version or custom if specified

### OS/2 Properties
- **Weight Class**: Mapped from detected weight (e.g., 700 for Bold)
- **Width Class**: Set via `--width` parameter (default: 100% Medium)
- **PFM Family**: Set via `--type` parameter
- **Style Map**: Bold and Italic flags based on detected style

### TTF Names (SFNT)
- **English(US) Preferred Family**: Family name
- **English(US) Preferred Styles**: Font style
- **English(US) UniqueID**: `familyname-style`
- **English(US) Styles (SubFamily)**: Font style
- **English(US) Family**: Family name
- **English(US) Fullname**: Full human-readable name
- **English(US) PostScriptName**: PostScript-compatible name

## Weight Detection

The script automatically detects weights from folder names and filenames:

- `thin` → 100
- `extralight`, `ultralight` → 200  
- `light` → 300
- `regular`, `normal` → 400
- `medium` → 500
- `semibold`, `demibold` → 600
- `bold` → 700
- `extrabold`, `ultrabold` → 800
- `black`, `heavy` → 900

## Style Detection

The script detects styles from:
1. **Folder names** (preferred): `regular/`, `italic/`, `bold/`, `bolditalic/`
2. **Filenames**: `PicoSans-BoldItalic.ttf`

Both methods support variations like:
- `bold_italic`, `bold-italic`, `bolditalic`
- `oblique` (treated as italic)

## Requirements

- Python 3.6+
- FontForge with Python bindings

### Installing FontForge

**macOS:**
```bash
brew install fontforge
```

**Ubuntu/Debian:**
```bash
sudo apt install fontforge python3-fontforge
```

## Examples

### Example 1: Basic Processing
```bash
python3 font-metadata-patcher.py
```
Processes all font families in `src/` and outputs to `build/` with proper metadata.

### Example 2: Monospace Font Family
```bash
python3 font-metadata-patcher.py --family picosans --type monospace --version "1.500"
```
Processes only the `picosans` family, sets it as monospace type, and updates version.

### Example 3: Condensed Font with Lowercase Names
```bash
python3 font-metadata-patcher.py --width condensed --lowercase --extension otf
```
Processes all families with condensed width, lowercase names, and OTF output.

### Example 4: Custom Directories
```bash
python3 font-metadata-patcher.py --src fonts/source --output fonts/processed --debug
```
Uses custom source and output directories with debug logging enabled.

## Error Handling

The script includes comprehensive error handling:
- Validates source and output directories
- Handles missing font files gracefully  
- Provides detailed error messages
- Continues processing other families if one fails
- Debug mode shows full stack traces

## License

This script is provided as-is for font processing purposes. 