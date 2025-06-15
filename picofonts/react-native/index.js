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
    const fontPromises = Object.values(fonts).map(family => 
      Font.loadAsync({
        [getFontName(family, 'regular')]: require(`../fonts/${family}/${family}-Regular.ttf`),
        [getFontName(family, 'bold')]: require(`../fonts/${family}/${family}-Bold.ttf`)
      })
    );

    await Promise.all(fontPromises);
    return true;
  } catch (error) {
    console.error('Error loading fonts:', error);
    return false;
  }
}; 