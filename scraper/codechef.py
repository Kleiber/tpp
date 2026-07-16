import requests
from bs4 import BeautifulSoup


class CodeChefParser:
    API_URL = "https://www.codechef.com/api/contests/PRACTICE/problems"

    def __init__(self, contest_id, problem_id):
        self.problem_code = problem_id
        self.headers = {
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
        }

    def get_samples(self):
        url = f"{self.API_URL}/{self.problem_code}"
        try:
            response = requests.get(url, headers=self.headers, timeout=10)
            if response.status_code != 200:
                return []
        except requests.RequestException:
            return []

        try:
            data = response.json()
        except ValueError:
            return []

        # Try structured sampleTestCases first (newer problems)
        components = data.get('problemComponents', {})
        sample_cases = components.get('sampleTestCases', [])

        if sample_cases:
            samples = []
            for case in sample_cases:
                if case.get('isDeleted'):
                    continue
                inp = case.get('input', '').strip()
                out = case.get('output', '').strip()
                if inp and out:
                    samples.append((inp, out))
            if samples:
                return samples

        # Fallback: parse body HTML for older problems
        body = data.get('body', '')
        if not body:
            return []

        return self._parse_body(body)

    def _parse_body(self, body):
        """Parse sample I/O from problem body HTML (older CodeChef format)."""
        soup = BeautifulSoup(body, 'html.parser')

        inputs = []
        outputs = []

        # Pattern 1: <b>Input:</b> followed by text, then <b>Output:</b>
        for b_tag in soup.find_all(['b', 'strong']):
            text = b_tag.get_text().strip().lower()
            if 'input' in text and 'format' not in text:
                # Get text after this tag until next b/strong
                content = self._extract_after_tag(b_tag)
                if content:
                    inputs.append(content)
            elif 'output' in text and 'format' not in text:
                content = self._extract_after_tag(b_tag)
                if content:
                    outputs.append(content)

        # Pattern 2: <pre> tags after Example heading
        if not inputs:
            for tag in soup.find_all(['h3', 'h2', 'b', 'strong']):
                if 'example' in tag.get_text().strip().lower():
                    pres = tag.find_all_next('pre')
                    for i in range(0, len(pres) - 1, 2):
                        inputs.append(pres[i].get_text().strip())
                        outputs.append(pres[i + 1].get_text().strip())
                    break

        samples = list(zip(inputs, outputs))
        return samples

    def _extract_after_tag(self, tag):
        """Extract text content following a tag (from <br> separated content)."""
        lines = []
        for sibling in tag.next_siblings:
            if hasattr(sibling, 'name'):
                if sibling.name in ('b', 'strong', 'h3', 'h2', 'p'):
                    break
                if sibling.name == 'br':
                    continue
                if sibling.name == 'pre':
                    return sibling.get_text().strip()
                text = sibling.get_text().strip()
                if text:
                    lines.append(text)
            else:
                text = str(sibling).strip()
                if text:
                    lines.append(text)

        result = '\n'.join(lines).strip()
        return result if result else None

    @staticmethod
    def match(name):
        """Check if problem name matches CodeChef format: uppercase letters with optional digits.
        Examples: TRTR3, PALIN, TRFTRBEZ
        Must start with uppercase letter to distinguish from Codeforces (starts with digit)."""
        if not name or not name[0].isupper():
            return False
        return all(c.isupper() or c.isdigit() for c in name)

    @staticmethod
    def parse_name(name):
        """Extract problem code from name like 'TRTR3'.
        Returns (contest_id, problem_id)."""
        return 'PRACTICE', name
