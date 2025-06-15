import { Platform } from 'react-native';

// Font family names
export const fonts = {
  picosans: 'picosans',
  picotype: 'picotype',
  picotypepro: 'picotypepro'
};

// Font weights
export const weights = {
  regular: 'Regular',
  bold: 'Bold'
};

// Helper to get the full font name
export const getFontName = (family, weight = 'regular') => {
  return `${family}-${weights[weight]}`;
};

// Platform specific font loading
export const loadFonts = async () => {
  if (Platform.OS === 'web') {
    // For web, we use CSS imports
    return Promise.resolve();
  }

  // For native platforms, we need to load the fonts
  try {
    const fontModule = await import('expo-font');
    const { Font } = fontModule;

    // Load all font variants
    const fontPromises = Object.values(fonts).map(family => {
      const fontStyles = {
        regular: `${family}-regular.ttf`,
        bold: `${family}-bold.ttf`,
        italic: `${family}-italic.ttf`,
        bolditalic: `${family}-bolditalic.ttf`,
        black: `${family}-black.ttf`
      };

      // Filter out styles that don't exist
      const availableStyles = Object.entries(fontStyles).reduce((acc, [style, filename]) => {
        try {
          require(`../fonts/${family}/${filename}`);
          acc[getFontName(family, style)] = require(`../fonts/${family}/${filename}`);
        } catch (e) {
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