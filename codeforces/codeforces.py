import os
import sys
import requests
from bs4 import BeautifulSoup
from multiprocessing import Process

class Codeforces:
    def __init__(self, contestId, problemId):
        self.headers = {'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'}
        self.base = 'https://codeforces.com'
        self.parser = 'html.parser'

        self.inputFile = 'in.tpp'
        self.expectedFile = 'exp.tpp'

        self.contestId = contestId
        self.problemId = problemId

        self.soup = self.getRequest()

    def getRequest(self):
        url = f'{self.base}/contest/{self.contestId}/problem/{self.problemId}'

        session = requests.Session()
        response = session.get(url, headers=self.headers)
        soup = BeautifulSoup(response.text, self.parser)

        return soup

    def writeFile(self, filepath, content):
        file = open(filepath, "w")
        file.write(content)
        file.close()

    def getSampleInputs(self, filepath):
        preList = self.soup.find_all('pre')

        inputs = []
        for pre in preList:
            divList = pre.find_all('div')

            inputStr = ''
            # old format
            if len(divList) == 0:
                lines = pre.text.split('\n')
                for line in lines:
                    if len(inputStr) > 0: inputStr += '\n'
                    inputStr += line
            # new format
            else:
                for div in divList:
                    if len(inputStr) > 0: inputStr += '\n'
                    if len(divList) == 0:
                        inputStr += div
                    else:
                        inputStr += div.string

            inputs.append(inputStr)

        if len(inputs) > 0: self.writeFile(filepath, inputs[0])

    def getSampleOutputs(self, filepath):
        preList = self.soup.find_all('pre')

        outputs = []
        for pre in preList:
            lines = pre.text.split('\n')

            outputStr = ''
            for line in lines:
                if len(outputStr) > 0: outputStr += '\n'
                outputStr += line

            outputs.append(outputStr)

        if len(outputs) > 1: self.writeFile(filepath, outputs[1])

def getMetadata(problemName):
    index = 0
    for letter in problemName:
        if letter.isalpha(): break
        index += 1

    return problemName[:index], problemName[index]

def main():
    problemName = sys.argv[1]
    inputFilename = sys.argv[2]
    outputFilename = sys.argv[3]
    path = sys.argv[4]

    contestId, problemId = getMetadata(problemName)
    if len(contestId) == 0 or len(problemId) == 0: return

    inputFilename = os.path.join(path, inputFilename)
    outputFilename = os.path.join(path, outputFilename)

    cf = Codeforces(contestId, problemId)

    processI = Process(target=cf.getSampleInputs, args=(inputFilename,))
    processI.start()

    processE = Process(target=cf.getSampleOutputs, args=(outputFilename,))
    processE.start()

    processI.join()
    processE.join()

# python3 -W ignore codeforces.py 1950A in.tpp exp.tpp .
if __name__ == '__main__':
    main()
