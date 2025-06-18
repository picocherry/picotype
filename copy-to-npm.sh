#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

# Check if picofonts directory exists
if [ ! -d "picofonts" ]; then
    print_error "picofonts directory not found"
    exit 1
fi

# Check if build directory exists
if [ ! -d "build" ]; then
    print_error "build directory not found"
    exit 1
fi

print_info "Copying fonts to npm package..."

# Create necessary directories
mkdir -p picofonts/fonts

# Copy font files from build directory (excluding nerd fonts)
for family_dir in build/*/; do
    family=$(basename "$family_dir")
    # Skip nerd font directories
    if [[ "$family" != *"nerd"* ]]; then
        echo "  • Copying $family..."
        # Create family directory
        mkdir -p "picofonts/fonts/$family"
        # Copy only .ttf and .otf files
        find "$family_dir" -type f \( -name "*.ttf" -o -name "*.otf" \) -exec cp {} "picofonts/fonts/$family/" \;
    fi
done

# Create CSS files for each font family
for family_dir in picofonts/fonts/*/; do
    family=$(basename "$family_dir")
    echo "  • Creating CSS for $family..."
    
    cat > "picofonts/${family}.css" << EOF
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
done

# Create all.css that imports all font families
cat > "picofonts/all.css" << EOF
$(for family_dir in picofonts/fonts/*/; do
  family=$(basename "$family_dir")
  echo "@import '/${family}.css';"
done)
EOF

print_success "Fonts copied to npm package successfully"
print_info "You can now:"
echo "  1. Test the changes locally"
echo "  2. Update version in package.json if needed"
echo "  3. Run 'npm publish' in picofonts directory" 