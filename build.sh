#!/bin/bash

# Interactive Font Generator
# Processes font families with metadata patcher and optionally generates nerd fonts

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Default directories
SRC_DIR="./src"
BUILD_DIR="./build"

# Global variable to store metadata options
METADATA_OPTIONS=""

# Function to print colored output
print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_header() {
    echo -e "${CYAN}▶${NC} $1"
}

# Function to ask yes/no question
ask_yes_no() {
    local question="$1"
    local default="${2:-n}"
    local response
    
    if [ "$default" = "y" ]; then
        printf "${YELLOW}?${NC} %s [Y/n]: " "$question"
    else
        printf "${YELLOW}?${NC} %s [y/N]: " "$question"
    fi
    
    read -r response
    response=${response:-$default}
    
    case "$response" in
        [yY]|[yY][eE][sS]) return 0 ;;
        *) return 1 ;;
    esac
}

# Function to show font family preview
show_family_preview() {
    local family_dir="$1"
    local family_name=$(basename "$family_dir")
    
    echo
    print_header "Font Family: $family_name"
    
    # Look for style subdirectories first
    local style_dirs=($(find "$family_dir" -mindepth 1 -maxdepth 1 -type d | sort))
    
    if [ ${#style_dirs[@]} -gt 0 ]; then
        echo "  Styles found:"
        for style_dir in "${style_dirs[@]}"; do
            local style_name=$(basename "$style_dir")
            local font_files=($(find "$style_dir" -maxdepth 1 -name "*.ttf" -o -name "*.otf" -o -name "*.TTF" -o -name "*.OTF" | sort))
            
            if [ ${#font_files[@]} -gt 0 ]; then
                echo "    • $style_name (${#font_files[@]} file(s))"
                for font_file in "${font_files[@]}"; do
                    echo "      - $(basename "$font_file")"
                done
            else
                echo "    • $style_name (no font files found)"
            fi
        done
    else
        # No style subdirectories, check for direct font files
        local font_files=($(find "$family_dir" -maxdepth 1 -name "*.ttf" -o -name "*.otf" -o -name "*.TTF" -o -name "*.OTF" | sort))
        
        if [ ${#font_files[@]} -gt 0 ]; then
            echo "  Direct font files:"
            for font_file in "${font_files[@]}"; do
                echo "    • $(basename "$font_file")"
            done
        else
            echo "  No font files found"
        fi
    fi
    
    echo "  Output will be: $BUILD_DIR/$family_name/"
}

# Function to run metadata patcher
run_metadata_patcher() {
    local family_name="$1"
    local extra_args="$2"
    
    print_info "Running metadata patcher for $family_name..."
    
    # Build command
    local cmd="python3 font-metadata-patcher.py --src '$SRC_DIR' --family '$family_name' --output '$BUILD_DIR'"
    
    # Add extra arguments if provided
    if [ -n "$extra_args" ]; then
        cmd="$cmd $extra_args"
    fi
    
    echo "Command: $cmd"
    echo
    
    # Execute command
    if eval "$cmd"; then
        print_success "Metadata patcher completed for $family_name"
        return 0
    else
        print_error "Metadata patcher failed for $family_name"
        return 1
    fi
}

# Function to run nerd fonts generator
run_nerd_fonts_generator() {
    local family_name="$1"
    
    print_info "Running nerd fonts generator for $family_name..."
    
    # Check if generate-nerd-fonts script exists
    if [ ! -f "./generate-nerd-fonts" ]; then
        print_error "generate-nerd-fonts script not found"
        return 1
    fi
    
    # Check if build directory exists
    if [ ! -d "$BUILD_DIR/$family_name" ]; then
        print_error "Build directory not found: $BUILD_DIR/$family_name"
        return 1
    fi
    
    echo "Command: ./generate-nerd-fonts '$family_name'"
    echo
    
    # Execute command
    if "./generate-nerd-fonts" "$family_name"; then
        print_success "Nerd fonts generator completed for $family_name"
        return 0
    else
        print_error "Nerd fonts generator failed for $family_name"
        return 1
    fi
}

# Function to get metadata patcher options (stores in global METADATA_OPTIONS)
get_metadata_options() {
    local options=""
    
    echo
    print_header "Metadata Patcher Options"
    
    if ask_yes_no "Use lowercase font names?" "y"; then
        options="$options --lowercase"
    fi
    
    if ask_yes_no "Set font type to monospace?" "y"; then
        options="$options --type monospace"
    elif ask_yes_no "Set font type to sans serif?" "y"; then
        options="$options --type sans"
    elif ask_yes_no "Set font type to serif?" "y"; then
        options="$options --type serif"
    fi
    
    printf "${YELLOW}?${NC} Enter custom version (or press Enter to keep original): "
    read -r version
    if [ -n "$version" ]; then 
        options="$options --version '$version'"
    fi
    
    printf "${YELLOW}?${NC} Enter output extension (ttf/otf or press Enter to keep original): "
    read -r extension
    if [ -n "$extension" ]; then
        options="$options --extension '$extension'"
    fi
    
    printf "${YELLOW}?${NC} Enter designer URL (or press Enter to skip): "
    read -r designer_url
    if [ -n "$designer_url" ]; then
        options="$options --designerurl '$designer_url'"
    fi
    
    printf "${YELLOW}?${NC} Enter license URL (or press Enter to skip): "
    read -r license_url
    if [ -n "$license_url" ]; then
        options="$options --licenseurl '$license_url'"
    fi
    
    printf "${YELLOW}?${NC} Enter license/copyright text (or press Enter to skip): "
    read -r license_text
    if [ -n "$license_text" ]; then
        options="$options --license '$license_text'"
    fi
    
    if ask_yes_no "Enable debug logging?"; then
        options="$options --debug"
    fi
    
    METADATA_OPTIONS="$options"
}

# Main function
main() {
    echo -e "${CYAN}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║                  Interactive Font Generator                  ║"
    echo "║          Metadata Patcher + Nerd Fonts Generator             ║"
    echo "║                       by pico cherry                         ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    # Check if source directory exists
    if [ ! -d "$SRC_DIR" ]; then
        print_error "Source directory not found: $SRC_DIR"
        exit 1
    fi
    
    # Check if font-metadata-patcher.py exists
    if [ ! -f "font-metadata-patcher.py" ]; then
        print_error "font-metadata-patcher.py not found in current directory"
        exit 1
    fi
    
    # Find all family directories
    local family_dirs=($(find "$SRC_DIR" -mindepth 1 -maxdepth 1 -type d | sort))
    
    if [ ${#family_dirs[@]} -eq 0 ]; then
        print_error "No font family directories found in $SRC_DIR"
        exit 1
    fi
    
    print_info "Found ${#family_dirs[@]} font families in $SRC_DIR:"
    for family_dir in "${family_dirs[@]}"; do
        local family_name=$(basename "$family_dir")
        echo "  • $family_name"
    done
    echo
    
    # Ask for global metadata options
    local use_global_options=false
    local global_options=""
    
    echo "Setting the patcher options"
    if ask_yes_no "Would you like to process all families with same options
  (e.g. --lowercase --type monospace)?" "y"; then
        use_global_options=true
        get_metadata_options
        global_options="$METADATA_OPTIONS"
        echo
        print_info "Will use options: $global_options"
        echo
        
        # Ask about batch processing
        local process_all_families=false
        local generate_all_nerd_fonts=false
        
        if ask_yes_no "Generate all font families?" "y"; then
            process_all_families=true
            if ask_yes_no "Also generate nerd fonts for all families?" "y"; then
                generate_all_nerd_fonts=true
                print_info "Will process all families and generate nerd fonts for all"
            else
                print_info "Will process all families (no nerd fonts)"
            fi
        else
            print_info "Will ask for each family individually"
        fi
        echo
    fi
    
    # Process each family
    local processed_count=0
    local nerd_count=0
    
    for family_dir in "${family_dirs[@]}"; do
        local family_name=$(basename "$family_dir")
        
        # Show family preview
        show_family_preview "$family_dir"
        echo
        
        # Determine if we should process this family
        local should_process=false
        local should_generate_nerd=false
        
        if [ "$use_global_options" = true ] && [ "$process_all_families" = true ]; then
            # Batch mode - process all families
            should_process=true
            should_generate_nerd="$generate_all_nerd_fonts"
            print_info "Processing $family_name (batch mode)"
        else
            # Interactive mode - ask for each family
            if ask_yes_no "Process $family_name with metadata patcher?" "y"; then
                should_process=true
            else
                print_info "Skipping $family_name"
            fi
        fi
        
        if [ "$should_process" = true ]; then
            local options="$global_options"
            
            # Get family-specific options if not using global
            if [ "$use_global_options" = false ]; then
                get_metadata_options
                options="$METADATA_OPTIONS"
                echo
            fi
            
            # Run metadata patcher
            if run_metadata_patcher "$family_name" "$options"; then
                ((processed_count++))
                echo
                
                # Handle nerd fonts generation
                if [ "$use_global_options" = true ] && [ "$process_all_families" = true ]; then
                    # Batch mode - use predetermined choice
                    if [ "$should_generate_nerd" = true ]; then
                        if run_nerd_fonts_generator "$family_name"; then
                            ((nerd_count++))
                        fi
                    fi
                else
                    # Interactive mode - ask for each family
                    if ask_yes_no "Generate nerd fonts version of $family_name?"; then
                        if run_nerd_fonts_generator "$family_name"; then
                            ((nerd_count++))
                        fi
                    fi
                fi
            fi
        fi
        
        echo
        echo "────────────────────────────────────────────────────────────────"
        echo
    done
    
    # Summary
    echo
    print_header "Processing Complete!"
    print_success "Processed $processed_count font families with metadata patcher"
    print_success "Generated $nerd_count nerd font versions"
    
    if [ $processed_count -gt 0 ]; then
        echo
        print_info "Generated fonts can be found in: $BUILD_DIR"
        
        if [ $nerd_count -gt 0 ]; then
            print_info "Nerd font versions have 'nerd' suffix in their directory names"
        fi
    fi
}

# Check for help flag
if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
    echo "Interactive Font Generator"
    echo
    echo "This script processes font families in the src/ directory using the metadata"
    echo "patcher and optionally generates nerd fonts versions."
    echo
    echo "Usage: $0"
    echo
    echo "The script will:"
    echo "1. Scan src/ directory for font families"
    echo "2. Show preview of each family"
    echo "3. Ask if you want to process each family"
    echo "4. Run font-metadata-patcher.py with your chosen options"
    echo "5. Ask if you want to generate nerd fonts version"
    echo "6. Run generate-nerd-fonts script if requested"
    echo
    echo "Requirements:"
    echo "- font-metadata-patcher.py in current directory"
    echo "- generate-nerd-fonts script (for nerd fonts generation)"
    echo "- FontForge with Python bindings"
    echo
    exit 0
fi

# Run main function
main 