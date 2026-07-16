#!/usr/bin/env python3

import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from codeforces import CodeforcesParser
from atcoder import AtCoderParser
from cses import CSESParser
from codechef import CodeChefParser
from leetcode import LeetCodeParser

PARSERS = [AtCoderParser, CodeforcesParser, CSESParser, CodeChefParser, LeetCodeParser]


def detect_parser(name):
    """Detect which parser to use based on problem name."""
    for parser_class in PARSERS:
        if parser_class.match(name):
            return parser_class
    return None


def main():
    if len(sys.argv) < 3:
        print("Usage: scraper.py <problem-name> <path>")
        print("  Codeforces: scraper.py 1950A /path/to/solution")
        print("  AtCoder:    scraper.py abc466_a /path/to/solution")
        print("  CSES:       scraper.py 1068 /path/to/solution")
        print("  CodeChef:   scraper.py TRTR3 /path/to/solution")
        print("  LeetCode:   scraper.py add-two-numbers /path/to/solution")
        return

    name = sys.argv[1]
    path = sys.argv[2]

    parser_class = detect_parser(name)
    if not parser_class:
        return

    contest_id, problem_id = parser_class.parse_name(name)
    if not contest_id or not problem_id:
        return

    parser = parser_class(contest_id, problem_id)
    samples = parser.get_samples()

    if not samples:
        print("No samples found.")
        return

    for i, (inp, out) in enumerate(samples, 1):
        in_file = os.path.join(path, f'{i}.in')
        exp_file = os.path.join(path, f'{i}.exp')

        with open(in_file, 'w') as f:
            f.write(inp + '\n')

        with open(exp_file, 'w') as f:
            f.write(out + '\n')

    print(f"Loaded {len(samples)} sample(s).")

    # For LeetCode, also generate the .cpp template with helpers and main()
    if hasattr(parser, 'generate_cpp'):
        parser.generate_cpp(path)


if __name__ == '__main__':
    main()
