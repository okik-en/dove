#!/bin/bash

# Resolve Typst

if [ -n "$LOCALAPPDATA" ]; then
  WINGET_TYPST_PATH=$(cygpath -u "$LOCALAPPDATA/Microsoft/WinGet/Packages/Typst.Typst_Microsoft.Winget.Source_8wekyb3d8bbwe/typst-x86_64-pc-windows-msvc")
  export PATH="$PATH:$WINGET_TYPST_PATH"
fi
export PATH="$PATH:/c/Program Files/Typst:/c/Program Files (x86)/Typst"

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
