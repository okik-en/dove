#!/bin/bash

# Build PDFs

typst compile probability-and-statistics/pdf.typ probability-and-statistics/probability-and-statistics-answer.pdf --root "$PWD"
typst compile --input no-hint=true probability-and-statistics/pdf.typ probability-and-statistics/probability-and-statistics-question.pdf --root "$PWD"

typst compile database/pdf.typ database/database-answer.pdf --root "$PWD"
typst compile --input no-hint=true database/pdf.typ database/database-question.pdf --root "$PWD"

mkdir -p docs/probability-and-statistics
typst compile probability-and-statistics/html.typ docs/probability-and-statistics/index.html --input html=true --features html --format html --root "$PWD"

mkdir -p docs/database
typst compile database/html.typ docs/database/index.html --input html=true --features html --format html --root "$PWD"

# Add to commit

git add probability-and-statistics/probability-and-statistics-answer.pdf
git add probability-and-statistics/probability-and-statistics-question.pdf

git add database/database-answer.pdf
git add database/database-question.pdf

git add docs/probability-and-statistics/index.html
git add docs/database/index.html
