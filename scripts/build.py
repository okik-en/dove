#!/usr/bin/env python3

from pathlib import Path
import subprocess
import yaml

try:
  with open("appendix.yaml", "r", encoding="utf-8") as file:
    appendix = yaml.safe_load(file)

  for subject in appendix:
    print(f"Building {subject}...")

    print(f"  * pdf export")

    print(f"    - {subject}-question.pdf")
    subprocess.run([
      "typst",
      "compile",
      "--input",
      f"srcdir={subject}",
      "--root",
      ".",
      "template/pdf/index.typ",
      f"dist/{subject}-question.pdf"
    ], check=True, capture_output=True, text=True, encoding="utf-8")
    subprocess.run([
      "git",
      "add",
      f"dist/{subject}-question.pdf"
    ], check=True, capture_output=True, text=True, encoding="utf-8")

    print(f"    - {subject}-answer.pdf")
    subprocess.run([
      "typst",
      "compile",
      "--input",
      "hint=true",
      "--input",
      f"srcdir={subject}",
      "--root",
      ".",
      "template/pdf/index.typ",
      f"dist/{subject}-answer.pdf"
    ], check=True, capture_output=True, text=True, encoding="utf-8")
    subprocess.run([
      "git",
      "add",
      f"dist/{subject}-answer.pdf"
    ], check=True, capture_output=True, text=True, encoding="utf-8")

    print(f"  * html export")

    Path(f"docs/{subject}").mkdir(exist_ok=True)

    for i in range(len(appendix[subject]["chapters"])):
      chapter = appendix[subject]["chapters"][i][0]
      print(f"    - {chapter}.html")
      Path(f"docs/{subject}/{chapter}").mkdir(exist_ok=True)
      subprocess.run([
        "typst",
        "compile",
        "--input",
        f"srcdir={subject}",
        "--input",
        f"chapter={chapter}",
        "--input",
        "html=true",
        "--features",
        "html",
        "--pretty",
        "--root",
        ".",
        "template/html/chapter.typ",
        f"docs/{subject}/{chapter}/index.html"
      ], check=True, capture_output=True, text=True, encoding="utf-8")
      subprocess.run(["git", "add", f"docs/{subject}/{chapter}/index.html"])
  print("Building index.html...")
  subprocess.run([
    "typst",
    "compile",
    "--input",
    "html=true",
    "--features",
    "html",
    "--pretty",
    "--root",
    ".",
    "template/html/index.typ",
    "docs/index.html"
  ], check=True, capture_output=True, text=True, encoding="utf-8")
  subprocess.run(["git", "add", f"docs/index.html"])
except subprocess.CalledProcessError as e:
  print(e.stderr)
  exit(1)
