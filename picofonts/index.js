// Import all CSS files
import './all.css';
import './picosans.css';
import './picotype.css';
import './picotypepro.css';

// Export individual CSS imports
export const css = {
  all: './all.css',
  picosans: './picosans.css',
  picotype: './picotype.css',
  picotypepro: './picotypepro.css'
};

const families = {
  picosans: {
    name: 'picosans',
    styles: ['Regular', 'Bold', 'Italic', 'BoldItalic'],
    path: './fonts/picosans'
  },
  picotype: {
    name: 'picotype',
    styles: ['Regular', 'Bold', 'Black'],
    path: './fonts/picotype'
  },
  picotypepro: {
    name: 'picotypepro',
    styles: ['Regular', 'Bold', 'Black'],
    path: './fonts/picotypepro'
  }
};

module.exports = families; 