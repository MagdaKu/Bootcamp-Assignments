import requests
import time
from random import randint
import html
#if any modules need to be installed, it can be done with a command "pip install [module_name]" in a terminal


def delay_message(message, time_delayed = 0.03): #this function prints the text, but delayed
    for letter in message:
        print(letter, end='', flush=True)
        time.sleep(time_delayed)

#this function makes a request to get all categories from the API and enables user to choose a category
def choose_category():
    endpoint = 'https://opentdb.com/api_category.php'
    response = requests.get(endpoint)
    data = response.json()

    message1 = "Hello! Welcome to a mini quiz, where you can test your general knowledge in various fields. \
        \n Pick a number or choose 0 for a random category: \n "
    delay_message(message1)

    for counter, category in enumerate(data["trivia_categories"]):
        if "Entertainment:" in category["name"]:
            category["name"] = category["name"][15:] #string slicing to get rid of the word "Entertainment" in a few categories
        print(str(counter + 1) + ") " + category["name"])

    while True: #this loop is used to make sure that we get a correct number from the user
        try:
            selected_category= int(input(f"Choose a number from 0 to {counter}: "))
            if 0 <= selected_category <= counter:
                break
            else:
                print(f"Please choose a number from 0 to {counter}.")
        except ValueError:
            print("Please enter an integer number ")

    if selected_category == 0: #this enables user to choose a random category
        selected_category = randint(1, counter)

    message2 = "Alright, your category is '" + data["trivia_categories"][selected_category - 1]["name"] + "'! \n"
    delay_message(message2)
    id = data["trivia_categories"][selected_category - 1]["id"] #id will be used to make a request and get questions from a chosen category
    return id

#this function is responsible for the quiz - printing questions, counting points etc...
def main(id):
    trivia_request  = "https://opentdb.com/api.php?amount=5&category=" + str(id) + "&type=boolean"
    response2 = requests.get(trivia_request)
    data2 = response2.json()

    answer_result_list = [] #a list to store the results of the quiz
    message3 = " You will be asked 5 True or False questions. For each question, type 't' if you think the statement is true, or 'f' if you think it's false. \n"
    delay_message(message3)

    with open("quiz results.txt", "w") as file:
        for counter, result in enumerate(data2["results"]):
            question = html.unescape(result["question"]) #gets rid of html entities
            print(str(counter + 1) + ") " + question)
            file.write(str(counter + 1) + ") " + question + "\n") #saves questions to a file

            while True: #this loop makes sure that we get a "t" or "f" answer
                answer= input("Type t or f: ").lower()
                if answer == "t":
                    answer = True
                    break
                elif answer == "f":
                    answer = False
                    break
                else:
                    print("Try again, type 'T' or 'F': ")

            file.write("Your answer: " + str(answer) + "\n")
            correct_answer = eval(result["correct_answer"]) #converts string to a boolean value
            file.write("Correct answer: " + str(correct_answer) + "\n")

            if correct_answer == answer :
                print("Great!")
                answer_result_list.append(True)
            else: 
                print("Wrong answer...")
                answer_result_list.append(False)

            file.write("\n")
        points = sum(answer_result_list) #counts the points
        file.write("Your points: " + str(points) + "\n")
            
    message4 = "Congratulations! You got " + str(points) + " points! You can view your answers in a file 'quiz results.txt'. I hope you enjoyed the quiz! "
    delay_message(message4)


if __name__ == "__main__":
    id = choose_category()
    main(id)
