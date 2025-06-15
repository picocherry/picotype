import { Platform } from 'react-native';

export const fonts = {
  picosans: 'picosans',
  picotype: 'picotype',
  picotypepro: 'picotypepro'
};

export const weights = {
  regular: 'Regular',
  bold: 'Bold',
  black: 'Black'
};

export const getFontName = (family, weight = 'regular') => {
  return `${family}-${weights[weight]}`;
};

export const loadFonts = async () => {
  if (Platform.OS === 'web') {
    return Promise.resolve();
  }

  try {
    const fontModule = await import('expo-font');
    const { Font } = fontModule;

    const fontPromises = Object.values(fonts).map(family => {
      const fontStyles = {
        regular: `${family}-regular.ttf`,
        bold: `${family}-bold.ttf`,
        italic: `${family}-italic.ttf`,
        bolditalic: `${family}-bolditalic.ttf`,
        black: `${family}-black.ttf`
      };

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