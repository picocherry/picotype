# PicoFonts

A collection of monospace pixel fonts including picosans, picotype, and picotypepro. These fonts are part of the [PicoType](https://github.com/picocherry/picotype) project.

## Font Families

### picosans
A 16×8 monospace sans serif pixel font with an italic version and manual kerning.

### picotype
An 8×5 pixel font with minimal legible width and height to not have ambiguities. Very pico.

### picotypepro
A 10×5 pixel font with a minimal legible width and height to ensure consistent baseline for better legibility.

## Installation

```bash
npm install picofonts
```

## Usage

### Web Usage

#### CSS Import

Import the CSS file for the font family you want to use:

```css
/* Import all fonts */
@import 'picofonts/css/all.css';

/* Or import specific font family */
@import 'picofonts/css/picosans.css';
@import 'picofonts/css/picotype.css';
@import 'picofonts/css/picotypepro.css';
```

#### React Usage

```jsx
import 'picofonts/css/picosans.css';

function App() {
  return (
    <div style={{ fontFamily: 'picosans' }}>
      Hello World!
    </div>
  );
}
```

### React Native Usage

First, install the required dependency:
```bash
npm install expo-font
```

Then in your React Native app:

```jsx
import React, { useEffect, useState } from 'react';
import { View, Text, StyleSheet } from 'react-native';
import { loadFonts, fonts, getFontName } from 'picofonts/react-native';

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
    fontFamily: getFontName(fonts.picosans, 'regular'),
    fontSize: 20,
  },
});
```

### Available Font Families

- picosans (16×8 monospace sans serif)
- picotype (8×5 pixel font)
- picotypepro (10×5 pixel font)

Each font family includes Regular and Bold weights.

## Development

These fonts are built and maintained in the [PicoType](https://github.com/picocherry/picotype) repository. The npm package is automatically generated from the built fonts.

## License

MIT 