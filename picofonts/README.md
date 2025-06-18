# PicoFonts

A collection of monospace pixel fonts including picotype, picotypepro, and picosans. These fonts are part of the [picotype](https://github.com/picocherry/picotype) project.

## Font Families

### picotype
An 8×5 pixel font with minimal legible width and height to not have ambiguities. Very pico.

### picotypepro
A 10×5 pixel font with a minimal legible width and height to ensure consistent baseline for better legibility.

### picosans
A 16×8 monospace sans serif pixel font with an italic version and manual kerning.

## Installation

```bash
npm install picofonts
```

## Usage

### Web Usage

#### Import All Fonts
```javascript
import 'picofonts';
```

#### Import Specific Font
```javascript
import 'picofonts/picosans';  // Just PicoSans
import 'picofonts/picotype';  // Just PicoType
import 'picofonts/picotypepro';  // Just PicoTypePro
```

#### CSS Usage
```css
/* The fonts will be available with these font-family names */
.picosans {
  font-family: 'picosans';
}

.picotype {
  font-family: 'picotype';
}

.picotypepro {
  font-family: 'picotypepro';
}
```

### React Native Usage

First, install the required dependencies:
```bash
npm install react-native expo-font
```

Then in your React Native app:

```jsx
import React, { useEffect, useState } from 'react';
import { View, Text, StyleSheet } from 'react-native';
import { loadFonts, fonts, weights, styles, getFontName } from 'picofonts/react-native';

export default function App() {
  const [fontsLoaded, setFontsLoaded] = useState(false);

  useEffect(() => {
    async function prepare() {
      try {
        await loadFonts();
        setFontsLoaded(true);
      } catch (e) {
        console.warn(e);
      }
    }

    prepare();
  }, []);

  if (!fontsLoaded) {
    return null; // or a loading screen
  }

  return (
    <View style={styles.container}>
      <Text style={styles.text}>Hello World!</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
  text: {
    fontFamily: getFontName(fonts.picosans, weights.regular),
    fontSize: 20,
  },
});
```

### Available Font Weights and Styles

Each font family supports:
- Regular
- Bold
- Black (except picosans)
- Italic (picosans only)
- Bold Italic (picosans only)

## Development

These fonts are built and maintained in the [picotype](https://github.com/picocherry/picotype) repository. The npm package is automatically generated from the built fonts.

## License

MIT 