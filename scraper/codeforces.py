import requests
from bs4 import BeautifulSoup


class CodeforcesParser:
    BASE_URL = "https://codeforces.com"

    def __init__(self, contest_id, problem_id):
        self.url = f"{self.BASE_URL}/contest/{contest_id}/problem/{problem_id}"
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

        input_divs = soup.find_all('div', class_='input')
        output_divs = soup.find_all('div', class_='output')

        samples = []
        for inp, out in zip(input_divs, output_divs):
            pre_in = inp.find('pre')
            pre_out = out.find('pre')

            if not pre_in or not pre_out:
                continue

            text_in = self._extract_pre(pre_in)
            text_out = self._extract_pre(pre_out)

            samples.append((text_in, text_out))

        return samples

    def _extract_pre(self, pre):
        divs = pre.find_all('div')
        if divs:
            return '\n'.join(d.get_text() for d in divs)
        return pre.get_text().strip()

    @staticmethod
    def match(name):
        """Check if problem name matches Codeforces format: digits + letter(s)"""
        i = 0
        for c in name:
            if c.isalpha():
                break
            i += 1
        return i > 0 and i < len(name) and name[:i].isdigit()

    @staticmethod
    def parse_name(name):
        """Extract contest_id and problem_id from name like '1950A' or '2244B1'"""
        i = 0
        for c in name:
            if c.isalpha():
                break
            i += 1
        return name[:i], name[i:]
