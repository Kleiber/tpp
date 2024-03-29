import requests
import bs4
import os
import sys

def get_input_problem(soup):
    list_pre = soup.find_all("pre")

    input_data = []
    for row in list_pre:
        lines = row.find_all('div')

        input_string = ""
        for line in lines:
            if(len(input_string) > 0):
                input_string += "\n"
            input_string += line.string

        input_data.append(input_string)

    return input_data

def get_output_problem(soup):
    list_pre = soup.find_all("pre")

    output_data = []
    for row in list_pre:
        lines = row.text.split("\n")

        output_string = ""
        for line in lines:
            if(len(output_string) > 0):
                output_string += "\n"
            if(len(line) > 0):
                output_string += line

        output_data.append(output_string)

    return output_data

def write_file(path, name, content):
    filepath = os.path.join(path, name)

    file = open(filepath, "w")
    file.write(content)
    file.close()

def main():
    problemName = sys.argv[1]
    path = sys.argv[2]
    input_name = sys.argv[3]
    output_name = sys.argv[4]

    tokens = problemName.split("_")
    contestId = tokens[0][:len(tokens[0]) - 1]
    problemLetter = tokens[0][len(tokens[0]) - 1:]

    problem = "https://codeforces.com/problemset/problem/" + contestId + "/" + problemLetter
    markup = requests.get(problem).text
    soup = bs4.BeautifulSoup(markup, "lxml")

    # fetch input data
    input_problem = get_input_problem(soup)
    if(len(input_problem) >  0):
        write_file(path, input_name, input_problem[0])
    else:
        print("Cannot fetch input data for this problem!")

    # fetch output data
    output_problem = get_output_problem(soup)
    if(len(input_problem) >  1):
        write_file(path, output_name, output_problem[1])
    else:
        print("Cannot fetch output data for this problem!")

# python3 codeforces.py [contest] [problemId] [path] [input] [output]
# python3 codeforces.py 1950A_name . in.tpp exp.tpp
if __name__ == '__main__':
    main()