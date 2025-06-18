import { Platform } from 'react-native';

export const fonts = {
  picosans: 'picosans',
  picotype: 'picotype',
  picotypepro: 'picotypepro'
};

export const weights = {
  regular: 'regular',
  bold: 'bold',
  black: 'black'
};

export const styles = {
  italic: 'italic'
};

export const getFontName = (family, weight = 'regular', style) => {
  return `${family}-${weights[weight]}${styles[style] ? `-${styles[style]}` : ''}`;
};

export const loadFonts = async () => {
  if (Platform.OS === 'web') {
    return Promise.resolve();
  }

  try {
    const fontModule = await import('expo-font');
    const { Font } = fontModule;

    const fontPromises = Object.values(fonts).map(family => {
      const fontStyles = {};
      
      // Add all weight combinations
      Object.keys(weights).forEach(weight => {
        const fontName = getFontName(family, weight);
        const italicFontName = getFontName(family, weight, 'italic');
        fontStyles[weight] = [`${fontName}.ttf`, `${fontName}.otf`, `${italicFontName}.ttf`, `${italicFontName}.otf`];
      });

      const availableStyles = Object.entries(fontStyles).reduce((acc, [style, filenames]) => {
        for (const filename of filenames) {
          try {
            require(`../fonts/${family}/${filename}`);
            acc[getFontName(family, style)] = require(`../fonts/${family}/${filename}`);
            break;
          } catch (e) {
          }
        }
        return acc;
      }, {});

      return Font.loadAsync(availableStyles);
    });

    await Promise.all(fontPromises);
    return true;
  } catch (error) {
    console.error('Error loading fonts:', error);
    return false;
  }
}; 