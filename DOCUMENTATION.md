# tpp — Documentation

> Version: 2.0.0

`tpp` is a command-line tool for competitive programmers that optimizes the workflow of code compilation, testing, debugging, and submission.

---

## Table of Contents

- [Installation](#installation)
- [Environment Variables](#environment-variables)
- [Solution Structure](#solution-structure)
- [Commands](#commands)
- [Debug Header](#debug-header)
- [Codeforces Auto-Fill](#codeforces-auto-fill)
- [Split Views](#split-views)
- [Workflow Example](#workflow-example)

---

## Installation

### Linux / Windows (Git Bash)

```bash
cd $HOME
git clone https://github.com/Kleiber/tpp.git
echo 'export PATH=$PATH:$HOME/tpp:' >> ~/.bashrc
source ~/.bashrc
```

### macOS

```bash
cd $HOME
git clone https://github.com/Kleiber/tpp.git
echo 'export PATH=$PATH:$HOME/tpp:' >> ~/.zshrc
source ~/.zshrc
```

### Requirements

- **g++** with C++11 or higher
- **perl** (preinstalled on macOS/Linux, used for timing)
- **Python 3** with `requests` and `bs4` (only for Codeforces auto-fill)

---

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `TPP_WORKSPACE` | `$HOME/CodeWorkspace` | Directory where all solutions are stored |
| `TPP_IDE` | `vi` | Editor command |
| `TPP_TEST` | `0` | Enable test validation (`1` = enabled) |
| `TPP_FILL` | `0` | Enable Codeforces sample auto-fill (`1` = enabled) |
| `TPP_VIEWS` | `0` | Enable split views when opening (`1` = enabled) |
| `TPP_GCC` | `c++11` | C++ standard passed to `g++ -std=` |
| `TPP_TL` | `4` | Time limit in seconds per test case file |
| `TPP_GITHUB` | `tpp_github` | GitHub repository URL for submissions |
| `TPP_REPO` | `$HOME/tpp_repo` | Local clone path of the GitHub repository |
| `TPP_BRANCH` | `main` | Branch to push submissions to |

---

## Solution Structure

```
$TPP_WORKSPACE/
└── myProblem/
    ├── myProblem.cpp      # Your solution
    ├── 1.in               # Test case 1 input
    ├── 1.exp              # Test case 1 expected output
    ├── 2.in               # Test case 2 input
    ├── 2.exp              # Test case 2 expected output
    └── .tpp/
        └── config         # Solution metadata
```

After `tpp test`: `1.out`, `2.out` are generated.
After `tpp prepare`: `myProblem_ready.cpp` is generated.
After `tpp build`: `build` executable is generated.

---

## Commands

### init

```bash
tpp init <solution-name>
```

Creates a new solution with `1.in`, `1.exp`, and a C++ template.

### add

```bash
tpp add [solution-name]
```

Creates the next numbered test case pair (`2.in` + `2.exp`, etc.) and opens them in editor.

### build

```bash
tpp build [solution-name]
```

Compiles the solution: `g++ -std=$TPP_GCC -o build <name>.cpp`

### run

```bash
tpp run [solution-name]
```

Compiles and executes using `1.in` as input. If `1.in` is empty, runs interactively.

### test

```bash
tpp test [solution-name]
```

Compiles and tests ALL cases. Output per case:

```
Case 1: PASSED (0.04s)
Case 2: FAILED (0.03s, line 5)
  Expected:
    42
  Output:
    43
Case 3: TLE (4.01s)
Case 4: SKIPPED (empty input)
```

Requires `TPP_TEST=1`. Time limit controlled by `TPP_TL` (default 4s).

### prepare

```bash
tpp prepare [solution-name]
```

Strips `debug.h` include, `debug()`, `debugm()`, `debugt()` calls. Generates `<name>_ready.cpp`. If `TPP_TEST=1`, also tests the prepared file.

### clone

```bash
tpp clone <source-name> <target-name>
```

Copies a solution as a starting point. Renames cpp, resets timestamps and test status, removes build/ready files.

### open

```bash
tpp open [solution-name]
```

Opens the `.cpp` file. With `TPP_VIEWS=1`: 3-pane vim layout (code + expected + input).

### in / exp / out

```bash
tpp in [case-number] [solution-name]
tpp exp [case-number] [solution-name]
tpp out [case-number] [solution-name]
```

Opens specific test case file. Defaults to case 1 if no number given. `tpp in` and `tpp exp` create the file if it doesn't exist.

### judge / tag

```bash
tpp judge <judge-name> [solution-name]
tpp tag <tag-name> [solution-name]
```

Sets metadata. Supports any characters including `/`.

### ls

```bash
tpp ls
```

Lists all solutions with judge, tag, test status, ready state, last update.

### submit

```bash
tpp submit [solution-name]
```

Pushes `<name>_ready.cpp` to GitHub repo under `<judge>/<tag>/` path.

### install

```bash
tpp install
```

One-time Vim setup: copies vimrc, installs Vundle + vim-auto-save, adds shell aliases.

---

## Debug Header

`debug.h` provides runtime debugging to stderr:

| Macro | Usage | Description |
|-------|-------|-------------|
| `debug(var)` | `debug(myVec)` | Print variable with line number |
| `debugm(a, b, c)` | `debugm(x, y, z)` | Print multiple variables on one line |
| `debugt("name")` | `debugt("solve") { ... }` | Measure execution time of a block |

Supports: bool, char, string, pair, tuple, vector, set, map, queue, stack, C-arrays, 2D arrays.

All debug output goes to `stderr` — judges ignore it. Removed by `tpp prepare`.

---

## Codeforces Auto-Fill

When `TPP_FILL=1`, `tpp init` fetches sample input/output from Codeforces:

```bash
tpp init 1950A    # Contest 1950, Problem A
```

Requires `pip install requests bs4`.

---

## Split Views

When `TPP_VIEWS=1`, `tpp open` launches vim with:

```
┌────────────────────┬───────────────┐
│                    │   1.exp       │
│   solution.cpp     ├───────────────┤
│                    │   1.in        │
└────────────────────┴───────────────┘
```

---

## Workflow Example

```bash
# Setup (one-time in ~/.zshrc)
export TPP_WORKSPACE="$HOME/code"
export TPP_TEST=1
export TPP_FILL=1
export TPP_TL=4

# Create and solve
tpp init 1950A
tpp open 1950A
tpp add 1950A          # add more test cases
tpp test 1950A         # run all cases

# Prepare and submit
tpp prepare 1950A
tpp judge Codeforces 1950A
tpp tag Greedy 1950A
tpp submit 1950A

# Clone for variant
tpp clone 1950A 1950B

# Check status
tpp ls
```

---

## Platform Support

| Feature | Linux | macOS |
|---------|-------|-------|
| All commands | ✅ | ✅ |
| Template | `bits/stdc++.h` | Individual includes |
| Timing | perl Time::HiRes | perl Time::HiRes |
| Config parsing | `grep -oP` | `perl -nle` |
