# Find all .htm and .html files and process them
find . -type f \( -name "*.htm" -o -name "*.html" \) -print0 | while IFS= read -r -d $'\0' file; do
  echo "Processing $file"
  
  # Create a temporary file
  tmpfile=$(mktemp)

  # Convert file from windows-1251 to UTF-8
  iconv -f windows-1251 -t utf-8 "$file" > "$tmpfile" && \
  # Replace charset in the temp file (works on both GNU and BSD/macOS sed)
  sed -i.bak 's/charset=windows-1251/charset=UTF-8/ig' "$tmpfile" && \
  # Replace original file with the converted one
  mv "$tmpfile" "$file"

  # Clean up backup file created by sed
  rm -f "${tmpfile}.bak"
done

echo "Conversion complete."