#!/bin/bash

# Documentation Validation Script
# Usage: ./scripts/validate-docs.sh [docs-directory]

set -e

# Default values
DOCS_DIR="${1:-docs}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Counters
ERRORS=0
WARNINGS=0
CHECKS=0

# Helper functions
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
    ((WARNINGS++))
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
    ((ERRORS++))
}

log_check() {
    echo -e "${BLUE}[CHECK]${NC} $1"
    ((CHECKS++))
}

# Check if documentation directory exists
if [ ! -d "$DOCS_DIR" ]; then
    log_error "Documentation directory not found: $DOCS_DIR"
    exit 1
fi

log_info "Validating documentation in: $DOCS_DIR"
echo

# Function to check markdown file structure
check_markdown_structure() {
    local file="$1"
    local filename=$(basename "$file")
    
    log_check "Checking structure of $filename"
    
    # Check if file has a title (# header)
    if ! grep -q "^# " "$file"; then
        log_error "$filename: Missing main title (# header)"
    fi
    
    # Check if file has an overview/description section
    if ! grep -q -i "overview\|description" "$file"; then
        log_warn "$filename: Missing overview or description section"
    fi
    
    # Check for empty sections
    if grep -q "^## .*$" "$file"; then
        while IFS= read -r section; do
            section_name=$(echo "$section" | sed 's/^## //')
            # Check if there's content after the section header
            section_line=$(grep -n "^## $section_name" "$file" | cut -d: -f1)
            next_section_line=$(tail -n +$((section_line + 1)) "$file" | grep -n "^##" | head -n1 | cut -d: -f1)
            
            if [ -z "$next_section_line" ]; then
                content=$(tail -n +$((section_line + 1)) "$file")
            else
                content=$(tail -n +$((section_line + 1)) "$file" | head -n $((next_section_line - 1)))
            fi
            
            # Remove empty lines and check if there's actual content
            if [ -z "$(echo "$content" | sed '/^$/d' | head -n1)" ]; then
                log_warn "$filename: Empty section '$section_name'"
            fi
        done <<< "$(grep "^## " "$file")"
    fi
}

# Function to check API endpoint documentation
check_api_endpoint() {
    local file="$1"
    local filename=$(basename "$file")
    
    log_check "Checking API endpoint documentation: $filename"
    
    # Required sections for API endpoints
    local required_sections=("Endpoint Details" "Parameters" "Response" "Examples")
    
    for section in "${required_sections[@]}"; do
        if ! grep -q "^## $section" "$file"; then
            log_error "$filename: Missing required section '$section'"
        fi
    done
    
    # Check for HTTP method and URL
    if ! grep -q "**URL:**" "$file"; then
        log_error "$filename: Missing URL specification"
    fi
    
    # Check for authentication info
    if ! grep -q "**Authentication:**" "$file"; then
        log_warn "$filename: Missing authentication information"
    fi
    
    # Check for examples
    if ! grep -q -E "```(bash|curl|javascript|python)" "$file"; then
        log_warn "$filename: Missing code examples"
    fi
    
    # Check for status codes
    if ! grep -q -E "(200|400|401|404|500)" "$file"; then
        log_warn "$filename: Missing HTTP status codes"
    fi
}

# Function to check component documentation
check_component_doc() {
    local file="$1"
    local filename=$(basename "$file")
    
    log_check "Checking component documentation: $filename"
    
    # Required sections for components
    local required_sections=("Props/Parameters" "Usage" "Examples")
    
    for section in "${required_sections[@]}"; do
        if ! grep -q "$section" "$file"; then
            log_error "$filename: Missing required section '$section'"
        fi
    done
    
    # Check for props table
    if ! grep -q "| Prop | Type | Required" "$file"; then
        log_warn "$filename: Missing props table"
    fi
    
    # Check for import statement
    if ! grep -q "import" "$file"; then
        log_warn "$filename: Missing import statement"
    fi
    
    # Check for examples
    if ! grep -q -E "```(javascript|jsx|typescript|tsx)" "$file"; then
        log_warn "$filename: Missing code examples"
    fi
}

# Function to check function documentation
check_function_doc() {
    local file="$1"
    local filename=$(basename "$file")
    
    log_check "Checking function documentation: $filename"
    
    # Required sections for functions
    local required_sections=("Signature" "Parameters" "Return Value" "Examples")
    
    for section in "${required_sections[@]}"; do
        if ! grep -q "$section" "$file"; then
            log_error "$filename: Missing required section '$section'"
        fi
    done
    
    # Check for function signature
    if ! grep -q -E "```(javascript|typescript|python|java)" "$file"; then
        log_warn "$filename: Missing function signature"
    fi
    
    # Check for parameter table
    if ! grep -q "| Parameter | Type | Required" "$file"; then
        log_warn "$filename: Missing parameters table"
    fi
}

# Function to check schema documentation
check_schema_doc() {
    local file="$1"
    local filename=$(basename "$file")
    
    log_check "Checking schema documentation: $filename"
    
    # Required sections for schemas
    local required_sections=("Schema Definition" "Properties" "Examples")
    
    for section in "${required_sections[@]}"; do
        if ! grep -q "$section" "$file"; then
            log_error "$filename: Missing required section '$section'"
        fi
    done
    
    # Check for JSON schema
    if ! grep -q -E "```json" "$file"; then
        log_warn "$filename: Missing JSON schema or examples"
    fi
    
    # Check for properties table
    if ! grep -q "| Property | Type | Required" "$file"; then
        log_warn "$filename: Missing properties table"
    fi
}

# Function to validate JSON in code blocks
check_json_validity() {
    local file="$1"
    local filename=$(basename "$file")
    
    # Extract JSON code blocks
    awk '/```json/,/```/' "$file" | grep -v '```' > /tmp/json_blocks.txt
    
    if [ -s /tmp/json_blocks.txt ]; then
        log_check "Validating JSON in $filename"
        
        # Split into individual JSON objects/arrays
        local json_obj=""
        local line_num=0
        
        while IFS= read -r line; do
            ((line_num++))
            if [[ "$line" =~ ^[[:space:]]*$ ]]; then
                # Empty line - might be end of JSON object
                if [ ! -z "$json_obj" ]; then
                    if ! echo "$json_obj" | python3 -m json.tool >/dev/null 2>&1; then
                        log_error "$filename: Invalid JSON at block starting near line $line_num"
                    fi
                    json_obj=""
                fi
            else
                json_obj+="$line"
            fi
        done < /tmp/json_blocks.txt
        
        # Check last object if exists
        if [ ! -z "$json_obj" ]; then
            if ! echo "$json_obj" | python3 -m json.tool >/dev/null 2>&1; then
                log_error "$filename: Invalid JSON at end of file"
            fi
        fi
    fi
    
    rm -f /tmp/json_blocks.txt
}

# Function to check for broken internal links
check_internal_links() {
    local file="$1"
    local filename=$(basename "$file")
    
    log_check "Checking internal links in $filename"
    
    # Extract markdown links
    grep -oE '\[([^\]]*)\]\(([^)]*)\)' "$file" | while read -r link; do
        # Extract the URL part
        url=$(echo "$link" | sed -n 's/.*](\([^)]*\)).*/\1/p')
        
        # Skip external links (http/https)
        if [[ "$url" =~ ^https?:// ]]; then
            continue
        fi
        
        # Skip anchor links
        if [[ "$url" =~ ^# ]]; then
            continue
        fi
        
        # Check if relative file exists
        if [[ "$url" =~ \.md$ ]]; then
            local target_file="$DOCS_DIR/$url"
            if [ ! -f "$target_file" ]; then
                log_error "$filename: Broken link to $url"
            fi
        fi
    done
}

# Function to check for consistent terminology
check_terminology() {
    local file="$1"
    local filename=$(basename "$file")
    
    # Common inconsistencies to check
    local inconsistencies=(
        "endpoint:Endpoint"
        "api:API"
        "json:JSON"
        "url:URL"
        "http:HTTP"
        "id:ID"
    )
    
    for inconsistency in "${inconsistencies[@]}"; do
        local lower=$(echo "$inconsistency" | cut -d: -f1)
        local upper=$(echo "$inconsistency" | cut -d: -f2)
        
        # Check if file uses both forms
        if grep -q "\b$lower\b" "$file" && grep -q "\b$upper\b" "$file"; then
            log_warn "$filename: Inconsistent use of '$lower' and '$upper'"
        fi
    done
}

# Main validation loop
log_info "Starting documentation validation..."
echo

# Check main README
if [ -f "$DOCS_DIR/../README.md" ]; then
    check_markdown_structure "$DOCS_DIR/../README.md"
    check_internal_links "$DOCS_DIR/../README.md"
fi

# Check API documentation
if [ -d "$DOCS_DIR/api" ]; then
    log_info "Validating API documentation..."
    
    # Check endpoint documentation
    if [ -d "$DOCS_DIR/api/endpoints" ]; then
        for file in "$DOCS_DIR/api/endpoints"/*.md; do
            if [ -f "$file" ]; then
                check_markdown_structure "$file"
                check_api_endpoint "$file"
                check_json_validity "$file"
                check_internal_links "$file"
                check_terminology "$file"
                echo
            fi
        done
    fi
    
    # Check schema documentation
    if [ -d "$DOCS_DIR/api/schemas" ]; then
        for file in "$DOCS_DIR/api/schemas"/*.md; do
            if [ -f "$file" ]; then
                check_markdown_structure "$file"
                check_schema_doc "$file"
                check_json_validity "$file"
                check_internal_links "$file"
                check_terminology "$file"
                echo
            fi
        done
    fi
fi

# Check component documentation
if [ -d "$DOCS_DIR/components" ]; then
    log_info "Validating component documentation..."
    
    for file in "$DOCS_DIR/components"/*.md; do
        if [ -f "$file" ]; then
            check_markdown_structure "$file"
            check_component_doc "$file"
            check_internal_links "$file"
            check_terminology "$file"
            echo
        fi
    done
fi

# Check function documentation
if [ -d "$DOCS_DIR/functions" ]; then
    log_info "Validating function documentation..."
    
    for file in "$DOCS_DIR/functions"/*.md; do
        if [ -f "$file" ]; then
            check_markdown_structure "$file"
            check_function_doc "$file"
            check_internal_links "$file"
            check_terminology "$file"
            echo
        fi
    done
fi

# Summary
echo "=================================="
echo "Documentation Validation Summary"
echo "=================================="
echo "Total checks performed: $CHECKS"
echo -e "Errors found: ${RED}$ERRORS${NC}"
echo -e "Warnings found: ${YELLOW}$WARNINGS${NC}"

if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo -e "${GREEN}✓ All documentation looks good!${NC}"
    exit 0
elif [ $ERRORS -eq 0 ]; then
    echo -e "${YELLOW}⚠ Documentation has warnings but no errors${NC}"
    exit 0
else
    echo -e "${RED}✗ Documentation has errors that need to be fixed${NC}"
    exit 1
fi