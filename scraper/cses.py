import requests
from bs4 import BeautifulSoup


class CSESParser:
    BASE_URL = "https://cses.fi"

    def __init__(self, contest_id, problem_id):
        self.url = f"{self.BASE_URL}/problemset/task/{problem_id}"
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

        content = soup.find('div', class_='content')
        if not content:
            return []

        # Find the "Example" heading
        example_heading = None
        for h1 in content.find_all('h1'):
            if 'example' in h1.get_text().strip().lower():
                example_heading = h1
                break

        if not example_heading:
            return []

        # Collect all <pre> tags after the Example heading
        pres = []
        for sibling in example_heading.find_next_siblings():
            if sibling.name == 'pre':
                pres.append(sibling.get_text().strip())
            elif sibling.name == 'h1':
                break

        # Pair them: input, output, input, output, ...
        samples = []
        for i in range(0, len(pres) - 1, 2):
            samples.append((pres[i], pres[i + 1]))

        return samples

    @staticmethod
    def match(name):
        """Check if problem name matches CSES format: pure digits (e.g. 1068)."""
        return name.isdigit()

    @staticmethod
    def parse_name(name):
        """Extract task_id from name like '1068'.
        Returns (contest_id, problem_id) where contest_id is unused."""
        return 'problemset', name
