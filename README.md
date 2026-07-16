# tpp

## Overview
`tpp` is a command line tool for competitive programmers that optimizes code compilation, testing, and debugging time.

## Installing

```bash
git clone https://github.com/Kleiber/tpp.git ~/tpp
~/tpp/install.sh
source ~/.zshrc
```

That's it. Works on macOS and Linux.

## Commands

| Command | Description |
|---------|-------------|
| `tpp init <name>` | Create a new solution |
| `tpp add [name]` | Add a new test case |
| `tpp build [name]` | Compile |
| `tpp run [case] [name]` | Run (interactive or with input file) |
| `tpp test [name]` | Run all test cases and compare |
| `tpp prepare [name]` | Generate submission file (strips debug) |
| `tpp open [name]` | Open in editor |
| `tpp in [case] [name]` | Edit input file |
| `tpp exp [case] [name]` | Edit expected file |
| `tpp out [case] [name]` | View output file |
| `tpp judge <judge> [name]` | Set judge name |
| `tpp tag <tag> [name]` | Set tag name |
| `tpp clone <source> <target>` | Copy a solution |
| `tpp ls` | List all solutions |
| `tpp submit [name]` | Push to GitHub repo |

All commands work from anywhere with solution name, or from inside the solution directory without it.

## Auto-fill Samples

Set `TPP_FILL=1` in your profile and name your solution with the problem code:

```bash
tpp init 1950A       # Codeforces → fetches samples
tpp init abc466_a    # AtCoder → fetches samples
```

## Test Output

```
Case 1: PASSED (0.04s)
Case 2: FAILED (0.03s, line 5)
  Expected:
    42
  Output:
    43
Case 3: TLE (4.01s)
Case 4: EMPTY
```

## File Format

```
solution/
├── solution.cpp
├── 1.in, 1.exp
├── 2.in, 2.exp
├── 3.in, 3.exp
└── .tpp/config
```

## Vim Commands

When using `tpp open`:

| Command | Action |
|---------|--------|
| `:test` | Save + test |
| `:run` | Save + run (interactive) |
| `:run 1` | Save + run with case 1 |
| `:build` | Save + build |
| `:prepare` | Save + prepare |
| `:add` | Add test case |
| `:in 1` | Edit input case 1 |
| `:exp 2` | Edit expected case 2 |
| `:out 1` | View output case 1 |
| `Ctrl+S` | Save |
| `Ctrl+F` | Search |

## Configuration

All defaults are in `~/tpp/tpp.profile`. Override by setting vars before the source line in your `.zshrc`:

```bash
export TPP_WORKSPACE="$HOME/code"
export TPP_IDE="vi"
export TPP_GCC="c++17"
export TPP_TL=4
export TPP_FILL=1
```

## Debug

Use `debug()` in your code to print variables to stderr:

```cpp
#include "debug.h"

debug(myVar);           // prints value
debugm(a, b, c);        // prints multiple
debugt("solve") { ... } // prints execution time
```

All debug output is stripped by `tpp prepare`.
