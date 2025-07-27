#!/bin/bash

# Generate API Documentation from OpenAPI Specification
# Usage: ./scripts/generate-api-docs.sh [openapi-file] [output-dir]

set -e

# Default values
OPENAPI_FILE="${1:-openapi.yaml}"
OUTPUT_DIR="${2:-docs/api/endpoints}"
TEMPLATE_DIR="docs/templates/api"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Helper functions
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if OpenAPI file exists
if [ ! -f "$OPENAPI_FILE" ]; then
    log_error "OpenAPI file not found: $OPENAPI_FILE"
    echo "Usage: $0 [openapi-file] [output-dir]"
    exit 1
fi

# Check if templates exist
if [ ! -f "$TEMPLATE_DIR/endpoint-template.md" ]; then
    log_error "Endpoint template not found: $TEMPLATE_DIR/endpoint-template.md"
    exit 1
fi

# Create output directory
mkdir -p "$OUTPUT_DIR"

log_info "Generating API documentation from $OPENAPI_FILE"
log_info "Output directory: $OUTPUT_DIR"

# Check if we have required tools
command -v yq >/dev/null 2>&1 || {
    log_warn "yq not found. Installing..."
    # Install yq if not present
    if command -v brew >/dev/null 2>&1; then
        brew install yq
    elif command -v apt-get >/dev/null 2>&1; then
        sudo apt-get update && sudo apt-get install -y yq
    else
        log_error "Cannot install yq. Please install it manually."
        exit 1
    fi
}

# Function to generate documentation for each endpoint
generate_endpoint_doc() {
    local path="$1"
    local method="$2"
    local operation_data="$3"
    
    # Clean path for filename (replace / and {} with -)
    local filename=$(echo "${path}_${method}" | sed 's/[^a-zA-Z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-\|-$//g')
    local output_file="$OUTPUT_DIR/${filename}.md"
    
    log_info "Generating documentation for $method $path"
    
    # Copy template
    cp "$TEMPLATE_DIR/endpoint-template.md" "$output_file"
    
    # Extract information from OpenAPI spec
    local summary=$(echo "$operation_data" | yq e '.summary // "API Endpoint"' -)
    local description=$(echo "$operation_data" | yq e '.description // "Description not provided"' -)
    local tags=$(echo "$operation_data" | yq e '.tags[]? // "untagged"' - | tr '\n' ', ' | sed 's/,$//')
    
    # Replace placeholders in template
    sed -i "s/\[Endpoint Name\]/$summary/g" "$output_file"
    sed -i "s|\[METHOD\] /api/v1/endpoint|$method $path|g" "$output_file"
    
    # Add description if available
    if [ "$description" != "Description not provided" ]; then
        sed -i "/^Brief description/c\\$description" "$output_file"
    fi
    
    # Extract parameters
    local params=$(echo "$operation_data" | yq e '.parameters[]?' -)
    if [ ! -z "$params" ]; then
        # TODO: Generate parameter tables from OpenAPI spec
        log_info "  Found parameters for $method $path"
    fi
    
    # Extract request body
    local request_body=$(echo "$operation_data" | yq e '.requestBody?' -)
    if [ ! -z "$request_body" ] && [ "$request_body" != "null" ]; then
        log_info "  Found request body for $method $path"
    fi
    
    # Extract responses
    local responses=$(echo "$operation_data" | yq e '.responses?' -)
    if [ ! -z "$responses" ] && [ "$responses" != "null" ]; then
        log_info "  Found responses for $method $path"
    fi
    
    log_info "  Generated: $output_file"
}

# Read OpenAPI spec and generate documentation
log_info "Parsing OpenAPI specification..."

# Extract base information
API_TITLE=$(yq e '.info.title // "API Documentation"' "$OPENAPI_FILE")
API_VERSION=$(yq e '.info.version // "1.0.0"' "$OPENAPI_FILE")
API_DESCRIPTION=$(yq e '.info.description // ""' "$OPENAPI_FILE")

log_info "API: $API_TITLE v$API_VERSION"

# Generate main API documentation file
cat > "$OUTPUT_DIR/../README.md" << EOF
# $API_TITLE

Version: $API_VERSION

## Description
$API_DESCRIPTION

## Endpoints

Generated from OpenAPI specification on $(date)

EOF

# Process each path and method
paths=$(yq e '.paths | keys | .[]' "$OPENAPI_FILE")

while IFS= read -r path; do
    if [ ! -z "$path" ]; then
        log_info "Processing path: $path"
        
        # Get methods for this path
        methods=$(yq e ".paths[\"$path\"] | keys | .[]" "$OPENAPI_FILE")
        
        while IFS= read -r method; do
            if [ ! -z "$method" ]; then
                # Get operation data
                operation_data=$(yq e ".paths[\"$path\"][\"$method\"]" "$OPENAPI_FILE")
                
                # Generate documentation
                generate_endpoint_doc "$path" "$method" "$operation_data"
                
                # Add to main README
                summary=$(echo "$operation_data" | yq e '.summary // "Endpoint"' -)
                filename=$(echo "${path}_${method}" | sed 's/[^a-zA-Z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-\|-$//g')
                echo "- [\`$method $path\`](./endpoints/${filename}.md) - $summary" >> "$OUTPUT_DIR/../README.md"
            fi
        done <<< "$methods"
    fi
done <<< "$paths"

# Generate schema documentation if schemas exist
schemas=$(yq e '.components.schemas // {} | keys | .[]?' "$OPENAPI_FILE")
if [ ! -z "$schemas" ]; then
    log_info "Generating schema documentation..."
    mkdir -p "docs/api/schemas"
    
    while IFS= read -r schema_name; do
        if [ ! -z "$schema_name" ]; then
            log_info "  Generating schema: $schema_name"
            
            # Copy schema template
            cp "$TEMPLATE_DIR/schema-template.md" "docs/api/schemas/${schema_name}.md"
            
            # Replace schema name
            sed -i "s/SchemaName/$schema_name/g" "docs/api/schemas/${schema_name}.md"
            
            # Extract schema definition
            schema_def=$(yq e ".components.schemas[\"$schema_name\"]" "$OPENAPI_FILE")
            # TODO: Generate actual schema content from OpenAPI
            
            echo "- [$schema_name](./schemas/${schema_name}.md)" >> "$OUTPUT_DIR/../README.md"
        fi
    done <<< "$schemas"
fi

echo "" >> "$OUTPUT_DIR/../README.md"
echo "---" >> "$OUTPUT_DIR/../README.md"
echo "Generated automatically from \`$OPENAPI_FILE\` on $(date)" >> "$OUTPUT_DIR/../README.md"

log_info "Documentation generation complete!"
log_info "Main file: $OUTPUT_DIR/../README.md"
log_info "Endpoint docs: $OUTPUT_DIR/"

# Validate generated documentation
if [ -f "scripts/validate-docs.sh" ]; then
    log_info "Running documentation validation..."
    ./scripts/validate-docs.sh "$OUTPUT_DIR"
fi