#!/bin/bash

# Build PDFs

awk -F: '/^[^[:space:]]/ { print $1 }' appendix.yaml | while read -r key; do
  echo "Building $key..."

  echo -e "\t- $key-question.pdf"
  typst compile --input srcdir="$key" typst/pdf.typ dist/"$key"-question.pdf --root "$PWD"
  git add dist/"$key"-question.pdf

  echo -e "\t- $key-answer.pdf"
  typst compile --input hint=true --input srcdir="$key" typst/pdf.typ dist/"$key"-answer.pdf --root "$PWD"
  git add dist/"$key"-answer.pdf

  echo -e "\t- $key.html"
  mkdir -p "docs/$key"
  typst compile src/$key/html.typ docs/$key/index.html --input html=true --features html --format html --pretty --root "$PWD"
  git add docs/$key/index.html
done
