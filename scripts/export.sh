#!/bin/bash

# Builds probability-and-statistics

typst compile probability-and-statistics/probability-and-statistics.typ probability-and-statistics/probability-and-statistics.pdf --root "$PWD"
typst compile --input no-hint=true probability-and-statistics/probability-and-statistics.typ probability-and-statistics/probability-and-statistics-without-hints.pdf --root "$PWD"

# Builds database

typst compile database/database.typ database/database.pdf --root "$PWD"
typst compile --input no-hint=true database/database.typ database/database-without-hints.pdf --root "$PWD"

# Add to commit

git add probability-and-statistics/probability-and-statistics.pdf
git add probability-and-statistics/probability-and-statistics-without-hints.pdf

git add database/database.pdf
git add database/database-without-hints.pdf

echo "Compilation Succeeded."
