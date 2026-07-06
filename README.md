# :dove: - A collection of past exam problems!

## Pages

You can view the distribution at [GitHub Pages](https://okik-en.github.io/dove/)!

## Dir

```tree
.
├─answers     # answers (will be removed)
├─dist        # pdf for distribution
├─docs        # html for GitHub Pages
├─scripts     # hooks
├─src         # source files in Typst
├─template    # template files for pdf/html
└─typst       # Typst templates/utils
```

We will be including answers in distributed pdf files or doc html files instead of providing them as separate pdf files in the answers directory.
You can find the distributed pdf files in the `dist` directory, files with `answer` prefix including the partial answers as for now.

## Init

You do not need to follow these steps if you just want to view the problems. These are for those who want to contribute or build the PDF and/or HTML files by themselves.

### Clone repo

```bash
git clone https://github.com/okik-en/dove.git
```

### Install Typst

You can skip this step if you have already installed Typst.

Refer to [GitHub](https://github.com/typst/typst#installation) for installation instructions, or use the following commands:
```bash
brew install typst  # for macOS
```
```bash
winget install typst  # for Windows
  ```

## Add pre-commit hooks

When contributing, add pre-commit hooks and make sure to build before your commitment.

### Install pre-commit

Refer to the [official documentation](https://pre-commit.com/#installation) for installation instructions, or use the following command:
```bash
pip install pre-commit
```

### Install hooks

Following command enables pre-commit hooks for this repository.

```bash
pre-commit install
```
