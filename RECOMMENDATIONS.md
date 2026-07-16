# tpp — Improvement Recommendations

> All items verified and tested against the codebase.

---

## Completed ✅

### Bug Fixes
1. ~~`sed -i -e` creates junk files on macOS~~ → Replaced sed with full config rewrite
2. ~~Help text says `kad` instead of `tpp`~~ → Fixed
3. ~~`run`/`test`/`prepare` with solution name argument fails~~ → Fixed (absolute path handling)
4. ~~`isValidName` confusingly named~~ → Inverted logic, now reads naturally
5. ~~Judge/tag names with `/` or special chars break sed~~ → Replaced with `write_config`

### Code Quality
6. ~~Extract path resolution into shared function~~ → `resolve_solution` eliminates ~150 lines of duplication
7. ~~Combine prepare sed passes~~ → Single `sed` command, no temp file
8. ~~Remove dead code~~ → Removed `test_cpp_file`, `sed_inplace`

### Features
9. ~~Multiple test cases~~ → `1.in`, `1.exp`, `2.in`, `2.exp` format with `tpp add`
10. ~~Time limit detection~~ → `TPP_TL=4` (default 4s), shows TLE per case
11. ~~Execution time display~~ → Shows `(0.23s)` for each case
12. ~~Better failure output~~ → Shows first different line with Expected/Output
13. ~~`tpp clone`~~ → Copy a solution as starting point

---

## Remaining Ideas (Future)

### Features
- **File watcher (`tpp watch`)** — auto-rerun tests on file save (needs `fswatch`)
- **Stress testing** — gen.cpp + brute.cpp random comparison
- **Shell completion** — tab complete solution names
- **`tpp config`** — show/set variables without editing .zshrc
- **Support languages beyond C++** — python, java

### Polish
- **`install` improvements** — backup .vimrc, don't shadow `open` command
- **Named view layouts** — `TPP_VIEWS="split"` instead of `0/1`
- **tmux integration** — editor + live test output

---

## Summary of Changes

| Metric | Before | After |
|--------|--------|-------|
| Files changed | - | 18 |
| Lines added | - | +575 |
| Lines removed | - | -553 |
| Dead code removed | ~200 lines | 0 |
| Commands | 13 | 16 (add, clone, + all original) |
| Test case format | `in.tpp` (single) | `1.in`, `2.in` (multiple) |
| TLE detection | None | Kill after TPP_TL seconds |
| Timing | None | Per-case wall clock |
| Config safety | sed (breaks on `/`) | Full rewrite (any chars) |
