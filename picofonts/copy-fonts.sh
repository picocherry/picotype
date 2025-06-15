#!/bin/bash

# Create necessary directories
mkdir -p fonts
mkdir -p css

# Get all font families from build directory (excluding nerd fonts)
for family_dir in ./build/*/; do
  family=$(basename "$family_dir")
  # Skip nerd font directories
  if [[ "$family" != *"nerd"* ]]; then
    echo "Copying $family..."
    cp -r "$family_dir" "fonts/"
  fi
done

# Create CSS files for each font family
for family_dir in fonts/*/; do
  family=$(basename "$family_dir")
  echo "Creating CSS for $family..."
  
  cat > "css/${family}.css" << EOF
@font-face {
  font-family: '${family}';
  src: url('./fonts/${family}/${family}-regular.ttf') format('truetype');
  font-weight: normal;
  font-style: normal;
  font-display: swap;
}

@font-face {
  font-family: '${family}';
  src: url('./fonts/${family}/${family}-bold.ttf') format('truetype');
  font-weight: bold;
  font-style: normal;
  font-display: swap;
}
EOF

  # Check and add black weight if it exists
  if [ -f "fonts/${family}/${family}-black.ttf" ]; then
    cat >> "css/${family}.css" << EOF

@font-face {
  font-family: '${family}';
  src: url('./fonts/${family}/${family}-black.ttf') format('truetype');
  font-weight: 900;
  font-style: normal;
  font-display: swap;
}
EOF
  fi

  # Check and add italic if it exists
  if [ -f "fonts/${family}/${family}-italic.ttf" ]; then
    cat >> "css/${family}.css" << EOF

@font-face {
  font-family: '${family}';
  src: url('./fonts/${family}/${family}-italic.ttf') format('truetype');
  font-weight: normal;
  font-style: italic;
  font-display: swap;
}
EOF
  fi

  # Check and add bolditalic if it exists
  if [ -f "fonts/${family}/${family}-bolditalic.ttf" ]; then
    cat >> "css/${family}.css" << EOF

@font-face {
  font-family: '${family}';
  src: url('./fonts/${family}/${family}-bolditalic.ttf') format('truetype');
  font-weight: bold;
  font-style: italic;
  font-display: swap;
}
EOF
  fi
done

# Create all.css that imports all font families
cat > "css/all.css" << EOF
$(for family_dir in fonts/*/; do
  family=$(basename "$family_dir")
  echo "@import './${family}.css';"
done)
EOF 