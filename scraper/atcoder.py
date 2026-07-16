import requests
from bs4 import BeautifulSoup


class AtCoderParser:
    BASE_URL = "https://atcoder.jp"

    def __init__(self, contest_id, task_id):
        self.url = f"{self.BASE_URL}/contests/{contest_id}/tasks/{task_id}?lang=en"
        self.headers = {
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
        }

    def get_samples(self):
        try:
            response = requests.get(self.url, headers=self.headers, timeout=10)
            if response.status_code != 200:
                return []
        except requests.RequestException:
            return []

        soup = BeautifulSoup(response.text, 'html.parser')

        inputs = []
        outputs = []

        for h3 in soup.find_all('h3'):
            title = h3.get_text().strip()
            pre = h3.find_next('pre')
            if not pre:
                continue
            text = pre.get_text().strip()

            if 'Sample Input' in title or '入力例' in title:
                inputs.append(text)
            elif 'Sample Output' in title or '出力例' in title:
                outputs.append(text)

        # Deduplicate (bilingual pages have duplicates)
        seen = set()
        samples = []
        for i in range(min(len(inputs), len(outputs))):
            pair = (inputs[i], outputs[i])
            if pair not in seen:
                seen.add(pair)
                samples.append(pair)

        return samples

    @staticmethod
    def match(name):
        """Check if problem name matches AtCoder format: abc466_a, arc180_b"""
        prefixes = ('abc', 'arc', 'agc', 'ahc')
        return any(name.startswith(p) for p in prefixes)

    @staticmethod
    def parse_name(name):
        """Extract contest_id and task_id from name like 'abc466_a'"""
        if '_' in name:
            parts = name.split('_', 1)
            contest_id = parts[0]
            task_id = name
        else:
            # abc466a -> contest: abc466, task: abc466_a
            # Find where the prefix letters end and digits begin, then find trailing letter
            import re
            m = re.match(r'^([a-z]+\d+)([a-z]\d*)$', name)
            if m:
                contest_id = m.group(1)
                task_id = f"{contest_id}_{m.group(2)}"
            else:
                return None, None

        return contest_id, task_id
