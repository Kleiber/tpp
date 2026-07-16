import json
import os
import re
import requests
from bs4 import BeautifulSoup


GRAPHQL_URL = "https://leetcode.com/graphql/"

# Map LeetCode metaData types to C++ types
TYPE_MAP = {
    'integer': 'int',
    'long': 'long long',
    'boolean': 'bool',
    'double': 'double',
    'float': 'float',
    'string': 'string',
    'character': 'char',
    'integer[]': 'vector<int>',
    'long[]': 'vector<long long>',
    'double[]': 'vector<double>',
    'string[]': 'vector<string>',
    'character[]': 'vector<char>',
    'integer[][]': 'vector<vector<int>>',
    'character[][]': 'vector<vector<char>>',
    'string[][]': 'vector<vector<string>>',
    'list<integer>': 'vector<int>',
    'list<string>': 'vector<string>',
    'list<String>': 'vector<string>',
    'list<list<integer>>': 'vector<vector<int>>',
    'list<list<string>>': 'vector<vector<string>>',
    'list<TreeNode>': 'vector<TreeNode*>',
    'ListNode': 'ListNode*',
    'ListNode[]': 'vector<ListNode*>',
    'TreeNode': 'TreeNode*',
    'void': 'void',
}

# I/O helper code blocks
HELPERS = {
    'TreeNode*': {
        'read': '''TreeNode* buildTree(const string& s) {
    if (s == "[]" || s.empty()) return nullptr;
    string data = s.substr(1, s.size() - 2);
    istringstream ss(data);
    string token;
    getline(ss, token, ',');
    TreeNode* root = new TreeNode(stoi(token));
    queue<TreeNode*> q;
    q.push(root);
    while (!q.empty()) {
        TreeNode* node = q.front(); q.pop();
        if (!getline(ss, token, ',')) break;
        if (token != "null") {
            node->left = new TreeNode(stoi(token));
            q.push(node->left);
        }
        if (!getline(ss, token, ',')) break;
        if (token != "null") {
            node->right = new TreeNode(stoi(token));
            q.push(node->right);
        }
    }
    return root;
}''',
        'print': '''string printTree(TreeNode* root) {
    if (!root) return "[]";
    string res = "[";
    queue<TreeNode*> q;
    q.push(root);
    vector<string> vals;
    while (!q.empty()) {
        TreeNode* node = q.front(); q.pop();
        if (node) {
            vals.push_back(to_string(node->val));
            q.push(node->left);
            q.push(node->right);
        } else {
            vals.push_back("null");
        }
    }
    while (!vals.empty() && vals.back() == "null") vals.pop_back();
    for (int i = 0; i < vals.size(); i++) {
        res += vals[i];
        if (i + 1 < vals.size()) res += ",";
    }
    res += "]";
    return res;
}''',
    },
    'ListNode*': {
        'read': '''ListNode* buildList(const string& s) {
    if (s == "[]" || s.empty()) return nullptr;
    string data = s.substr(1, s.size() - 2);
    istringstream ss(data);
    string token;
    ListNode dummy(0);
    ListNode* cur = &dummy;
    while (getline(ss, token, ',')) {
        cur->next = new ListNode(stoi(token));
        cur = cur->next;
    }
    return dummy.next;
}''',
        'print': '''string printList(ListNode* head) {
    string res = "[";
    while (head) {
        res += to_string(head->val);
        if (head->next) res += ",";
        head = head->next;
    }
    res += "]";
    return res;
}''',
    },
    'vector<int>': {
        'read': '''vector<int> readVecInt(const string& s) {
    vector<int> res;
    if (s == "[]" || s.empty()) return res;
    string data = s.substr(1, s.size() - 2);
    istringstream ss(data);
    string token;
    while (getline(ss, token, ',')) res.push_back(stoi(token));
    return res;
}''',
        'print': '''string printVecInt(const vector<int>& v) {
    string res = "[";
    for (int i = 0; i < (int)v.size(); i++) {
        res += to_string(v[i]);
        if (i + 1 < (int)v.size()) res += ",";
    }
    res += "]";
    return res;
}''',
    },
    'vector<vector<int>>': {
        'read': '''vector<vector<int>> readVecVecInt(const string& s) {
    vector<vector<int>> res;
    if (s == "[]" || s.empty()) return res;
    int i = 1;
    while (i < (int)s.size()) {
        if (s[i] == '[') {
            int j = s.find(']', i);
            res.push_back(readVecInt(s.substr(i, j - i + 1)));
            i = j + 2;
        } else {
            i++;
        }
    }
    return res;
}''',
        'print': '''string printVecVecInt(const vector<vector<int>>& v) {
    string res = "[";
    for (int i = 0; i < (int)v.size(); i++) {
        res += printVecInt(v[i]);
        if (i + 1 < (int)v.size()) res += ",";
    }
    res += "]";
    return res;
}''',
    },
    'vector<string>': {
        'read': '''vector<string> readVecStr(const string& s) {
    vector<string> res;
    if (s == "[]" || s.empty()) return res;
    int i = 1;
    while (i < (int)s.size()) {
        if (s[i] == '"') {
            int j = s.find('"', i + 1);
            res.push_back(s.substr(i + 1, j - i - 1));
            i = j + 2;
        } else {
            i++;
        }
    }
    return res;
}''',
        'print': '''string printVecStr(const vector<string>& v) {
    string res = "[";
    for (int i = 0; i < (int)v.size(); i++) {
        res += "\\"" + v[i] + "\\"";
        if (i + 1 < (int)v.size()) res += ",";
    }
    res += "]";
    return res;
}''',
    },
    'vector<char>': {
        'read': '''vector<char> readVecChar(const string& s) {
    vector<char> res;
    if (s == "[]" || s.empty()) return res;
    int i = 1;
    while (i < (int)s.size()) {
        if (s[i] == '"') {
            res.push_back(s[i + 1]);
            i += 4; // skip "x",
        } else {
            i++;
        }
    }
    return res;
}''',
        'print': '''string printVecChar(const vector<char>& v) {
    string res = "[";
    for (int i = 0; i < (int)v.size(); i++) {
        res += "\\""; res += v[i]; res += "\\"";
        if (i + 1 < (int)v.size()) res += ",";
    }
    res += "]";
    return res;
}''',
    },
    'vector<vector<char>>': {
        'read': '''vector<vector<char>> readVecVecChar(const string& s) {
    vector<vector<char>> res;
    if (s == "[]" || s.empty()) return res;
    int i = 1;
    while (i < (int)s.size()) {
        if (s[i] == '[') {
            int j = s.find(']', i);
            res.push_back(readVecChar(s.substr(i, j - i + 1)));
            i = j + 2;
        } else {
            i++;
        }
    }
    return res;
}''',
        'print': '''string printVecVecChar(const vector<vector<char>>& v) {
    string res = "[";
    for (int i = 0; i < (int)v.size(); i++) {
        res += printVecChar(v[i]);
        if (i + 1 < (int)v.size()) res += ",";
    }
    res += "]";
    return res;
}''',
    },
    'string': {
        'read': '''string readStr(const string& s) {
    if (s.size() >= 2 && s.front() == '"' && s.back() == '"')
        return s.substr(1, s.size() - 2);
    return s;
}''',
        'print': '''string printStr(const string& s) {
    return "\\"" + s + "\\"";
}''',
    },
    'vector<ListNode*>': {
        'read': '''vector<ListNode*> readVecList(const string& s) {
    vector<ListNode*> res;
    if (s == "[]" || s.empty()) return res;
    int i = 1;
    while (i < (int)s.size()) {
        if (s[i] == '[') {
            int j = s.find(']', i);
            res.push_back(buildList(s.substr(i, j - i + 1)));
            i = j + 2;
        } else {
            i++;
        }
    }
    return res;
}''',
        'print': '''string printVecList(const vector<ListNode*>& v) {
    string res = "[";
    for (int i = 0; i < (int)v.size(); i++) {
        res += printList(v[i]);
        if (i + 1 < (int)v.size()) res += ",";
    }
    res += "]";
    return res;
}''',
    },
    'vector<TreeNode*>': {
        'read': '''vector<TreeNode*> readVecTree(const string& s) {
    vector<TreeNode*> res;
    if (s == "[]" || s.empty()) return res;
    int i = 1;
    while (i < (int)s.size()) {
        if (s[i] == '[') {
            int j = s.find(']', i);
            res.push_back(buildTree(s.substr(i, j - i + 1)));
            i = j + 2;
        } else {
            i++;
        }
    }
    return res;
}''',
        'print': '''string printVecTree(const vector<TreeNode*>& v) {
    string res = "[";
    for (int i = 0; i < (int)v.size(); i++) {
        res += printTree(v[i]);
        if (i + 1 < (int)v.size()) res += ",";
    }
    res += "]";
    return res;
}''',
    },
}

# Map C++ type to read expression (variable 'line' holds the raw input)
READ_EXPR = {
    'TreeNode*': 'buildTree(line)',
    'ListNode*': 'buildList(line)',
    'vector<int>': 'readVecInt(line)',
    'vector<long long>': 'readVecInt(line)',
    'vector<vector<int>>': 'readVecVecInt(line)',
    'vector<string>': 'readVecStr(line)',
    'vector<char>': 'readVecChar(line)',
    'vector<vector<char>>': 'readVecVecChar(line)',
    'vector<ListNode*>': 'readVecList(line)',
    'vector<TreeNode*>': 'readVecTree(line)',
    'string': 'readStr(line)',
    'int': 'stoi(line)',
    'long long': 'stoll(line)',
    'bool': '(line == "true")',
    'double': 'stod(line)',
    'float': 'stof(line)',
    'char': 'line[1]',
}

# Map C++ type to print expression (variable 'result')
PRINT_EXPR = {
    'TreeNode*': 'printTree(result)',
    'ListNode*': 'printList(result)',
    'vector<int>': 'printVecInt(result)',
    'vector<vector<int>>': 'printVecVecInt(result)',
    'vector<string>': 'printVecStr(result)',
    'vector<char>': 'printVecChar(result)',
    'vector<vector<char>>': 'printVecVecChar(result)',
    'vector<ListNode*>': 'printVecList(result)',
    'vector<TreeNode*>': 'printVecTree(result)',
    'string': 'printStr(result)',
    'int': 'to_string(result)',
    'long long': 'to_string(result)',
    'bool': '(result ? "true" : "false")',
    'double': 'to_string(result)',
    'float': 'to_string(result)',
}


def _extract_definitions(code):
    """Extract struct definitions from comment block in code snippet."""
    defs = []
    for match in re.finditer(r'/\*\*[\s\S]*?\*/', code):
        comment = match.group()
        struct_lines = []
        for line in comment.split('\n'):
            cleaned = re.sub(r'^\s*[/*]*\s?', '', line).strip()
            if cleaned and not cleaned.startswith('Definition for'):
                struct_lines.append(cleaned)
        if struct_lines:
            defs.append('\n'.join(struct_lines))
    return defs


class LeetCodeParser:

    def __init__(self, contest_id, problem_id):
        self.slug = problem_id
        self.headers = {
            'Content-Type': 'application/json',
            'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36',
            'Referer': f'https://leetcode.com/problems/{problem_id}/',
        }
        self._question_data = None

    def _fetch_all(self):
        """Single API call to get content, metaData, and codeSnippets."""
        if self._question_data is not None:
            return self._question_data

        payload = {
            'query': '''query questionData($titleSlug: String!) {
                question(titleSlug: $titleSlug) {
                    title
                    content
                    metaData
                    codeSnippets { lang langSlug code }
                }
            }''',
            'variables': {'titleSlug': self.slug},
            'operationName': 'questionData'
        }

        try:
            response = requests.post(
                GRAPHQL_URL, headers=self.headers,
                json=payload, timeout=10
            )
            if response.status_code != 200:
                self._question_data = {}
                return self._question_data
        except requests.RequestException:
            self._question_data = {}
            return self._question_data

        try:
            data = response.json()
            self._question_data = data.get('data', {}).get('question') or {}
        except (ValueError, KeyError, TypeError):
            self._question_data = {}

        return self._question_data

    def get_samples(self):
        question = self._fetch_all()
        content = question.get('content', '')
        if not content:
            return []

        soup = BeautifulSoup(content, 'html.parser')

        samples = []
        for pre in soup.find_all('pre'):
            text = pre.get_text().strip()
            inp = self._extract_field(text, 'Input')
            out = self._extract_field(text, 'Output')
            if inp is not None and out is not None:
                samples.append((inp, out))

        return samples

    def generate_cpp(self, path):
        """Generate the LeetCode .cpp template, replacing the existing one."""
        cpp_file = None
        for f in os.listdir(path):
            if f.endswith('.cpp') and not f.endswith('_ready.cpp'):
                cpp_file = os.path.join(path, f)
                break

        if not cpp_file:
            return

        # Detect debug.h path from existing file
        debug_path = None
        try:
            with open(cpp_file, 'r') as f:
                for line in f:
                    m = re.search(r'#include\s+"([^"]+)/debug\.h"', line)
                    if m:
                        debug_path = m.group(1)
                        break
        except Exception:
            pass

        if not debug_path:
            debug_path = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

        template = self._build_template(debug_path)
        if template:
            with open(cpp_file, 'w') as f:
                f.write(template)

    def _build_template(self, debug_path):
        """Generate .cpp using already-fetched data (no extra API call)."""
        question = self._fetch_all()
        if not question:
            return None

        cpp_code = None
        for s in question.get('codeSnippets', []):
            if s['langSlug'] == 'cpp':
                cpp_code = s['code']
                break
        if not cpp_code:
            return None

        try:
            meta = json.loads(question['metaData'])
        except (ValueError, KeyError, TypeError):
            return None

        func_name = meta['name']
        params = [(TYPE_MAP.get(p['type'], p['type']), p['name']) for p in meta['params']]
        return_type = TYPE_MAP.get(meta['return']['type'], meta['return']['type'])

        definitions = _extract_definitions(cpp_code)

        # Collect needed helpers
        all_types = [t for t, _ in params] + [return_type]
        needed = set()
        for t in all_types:
            if t in HELPERS:
                needed.add(t)
        if 'vector<vector<int>>' in needed:
            needed.add('vector<int>')
        if 'vector<vector<char>>' in needed:
            needed.add('vector<char>')
        if 'vector<ListNode*>' in needed:
            needed.add('ListNode*')
        if 'vector<TreeNode*>' in needed:
            needed.add('TreeNode*')

        # Order (dependencies first)
        deps = {
            'vector<vector<int>>': ['vector<int>'],
            'vector<vector<char>>': ['vector<char>'],
            'vector<ListNode*>': ['ListNode*'],
            'vector<TreeNode*>': ['TreeNode*'],
        }
        helper_order = []
        added = set()
        for h in sorted(needed):
            for dep in deps.get(h, []):
                if dep not in added and dep in needed:
                    helper_order.append(dep)
                    added.add(dep)
            if h not in added:
                helper_order.append(h)
                added.add(h)

        # Build file
        lines = []
        from datetime import datetime
        now = datetime.now().strftime('%d-%m-%Y %H:%M:%S')

        import platform

        lines.append('/**')
        lines.append(f'*  Generated by tpp tool')
        lines.append(f'*  File: {self.slug}.cpp')
        lines.append(f'*  Created: {now}')
        lines.append('**/')
        lines.append('')

        if platform.system() == 'Darwin':
            lines.append('#include <iostream>')
            lines.append('#include <vector>')
            lines.append('#include <string>')
            lines.append('#include <algorithm>')
            lines.append('#include <bitset>')
            lines.append('#include <sstream>')
            lines.append('#include <set>')
            lines.append('#include <map>')
            lines.append('#include <unordered_map>')
            lines.append('#include <unordered_set>')
            lines.append('#include <queue>')
            lines.append('#include <stack>')
            lines.append('#include <cstdio>')
            lines.append('#include <cmath>')
            lines.append('#include <cstdlib>')
            lines.append('#include <cstring>')
        else:
            lines.append('#include <bits/stdc++.h>')

        lines.append('using namespace std;')
        lines.append('')
        lines.append('// remove this reference to debug.h before your submission')
        lines.append(f'#include "{debug_path}/debug.h"')
        lines.append('')

        for d in definitions:
            lines.append(d)
            lines.append('')

        for h in helper_order:
            lines.append(HELPERS[h]['read'])
            lines.append('')
            lines.append(HELPERS[h]['print'])
            lines.append('')

        clean_code = re.sub(r'/\*\*[\s\S]*?\*/', '', cpp_code).strip()
        lines.append(clean_code)
        lines.append('')

        lines.append('int main() {')
        lines.append('    ios::sync_with_stdio(false);')
        lines.append('    cin.tie(0);')
        lines.append('')
        lines.append('    Solution sol;')
        lines.append('    string line;')
        lines.append('')

        for ptype, pname in params:
            expr = READ_EXPR.get(ptype)
            if expr:
                lines.append(f'    getline(cin, line);')
                lines.append(f'    auto {pname} = {expr};')
            else:
                lines.append(f'    getline(cin, line);')
                lines.append(f'    // TODO: parse {ptype} {pname}')

        lines.append('')

        param_names = ', '.join(name for _, name in params)
        if return_type == 'void':
            lines.append(f'    sol.{func_name}({param_names});')
        else:
            print_expr = PRINT_EXPR.get(return_type, 'result')
            lines.append(f'    auto result = sol.{func_name}({param_names});')
            lines.append(f'    cout << {print_expr} << endl;')

        lines.append('')
        lines.append('    return 0;')
        lines.append('}')
        lines.append('')

        return '\n'.join(lines)

    def _extract_field(self, text, field):
        """Extract a field value from pre text like 'Input: x = 1, y = 2'."""
        match = re.search(rf'{field}:\s*(.+)', text)
        if not match:
            return None
        value = match.group(1).strip()
        parts = re.split(r',\s*\w+\s*=\s*', value)
        parts[0] = re.sub(r'^\w+\s*=\s*', '', parts[0])
        return '\n'.join(parts)

    @staticmethod
    def match(name):
        """Check if problem name matches LeetCode format: lowercase letters and optional hyphens."""
        if not name or name[0] == '-' or name[-1] == '-':
            return False
        return all(c.islower() or c == '-' for c in name)

    @staticmethod
    def parse_name(name):
        """Extract slug from name like 'add-two-numbers'."""
        return 'problems', name
