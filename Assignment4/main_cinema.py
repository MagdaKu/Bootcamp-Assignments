import requests
import json
from datetime import datetime

#returns the available seats
def get_seats_by_date(date):
    result = requests.get('http://127.0.0.1:5001/cinema/{}/seats'.format(date),
        headers={'content-type': 'application/json'})
    if result.status_code == 200:
        return result.json()
    
#adds reservation with the data provided by the customer
def add_seats_reservation(seat_id, movie_date, customer_data):
    reservation = {
        'seat_id': seat_id,
        'movie_date': movie_date.strftime('%Y-%m-%d'),
        'customer_first_name': customer_data[0],
        'customer_last_name': customer_data[1],
        'customer_phone_number':customer_data[2],
        'customer_email' : customer_data[3]
    }
    try:
        result = requests.put('http://127.0.0.1:5001/cinema',
            headers={'content-type': 'application/json'},
            json=reservation)
        result.raise_for_status()
        if result.status_code == 200:
            print("Your seats have been succesfully booked! Have a nice day!")
            return result.json()
    except:
        print("Failed to make the reservation, please try again")


#deletes the reservation using customer's email
def delete_seats_reservation(movie_date, customer_email):
    reservation_to_delete = {
        'movie_date': movie_date.strftime('%Y-%m-%d'),
        'customer_email' : str(customer_email)
    }
    try:
        result = requests.delete('http://127.0.0.1:5001/cinema/delete',
            headers={'content-type': 'application/json'},
            json=reservation_to_delete)
        result.raise_for_status()
        if result.status_code == 200:
            print("Your reservaation has been succesfully deleted, we hope to see you soon!")
            return result.json()  
    except Exception as e:
        print("There was no reservation for this email, please try again")
 


            
            
#this function helps the customer book their seats. It takes the date of the movie and prints available seats, then asks the
#customer to type how many tickets they want. After the seats and customer's personal data is given, it sends the values to function 
#add_seats_reservation()
def booking_seats():   
    start_date = datetime(2024, 10, 21)
    end_date = datetime(2024, 10, 24)             
    while True:
        chosen_date = input("Enter a date (yyyy-mm-dd) or type 'exit' to quit: ")
        if chosen_date.lower() == 'exit':
            print("See you soon!")
            return None
        try:
            chosen_date = datetime.strptime(chosen_date, '%Y-%m-%d')
            assert start_date <= chosen_date <= end_date
            break  
        except ValueError:
            print("Invalid date format. Please use yyyy-mm-dd.")
        except AssertionError:
            print(f"Date must be between {start_date.date()} and {end_date.date()}")

    available_seats = get_seats_by_date(chosen_date)
    print(f"Alright, you chose {chosen_date.date()}. Seats available for this day are: {available_seats}.")
    while True:
        ticket_number = input("Please choose the number of tickets you want to book. You can choose up to 5 tickets: ")
        try:
            ticket_number = int(ticket_number)
            assert 0 < ticket_number <= 5
            break
        except :
            print("Please choose the correct number of tickets: ")

    while True:
        chosen_seats = input("Please choose the seats, e.g A1, A2, A3 or type 'exit' to quit: ") 
        if chosen_seats.lower() == 'exit':
            print("See you soon!")
            return None
        chosen_seats = [seat.strip().upper() for seat in chosen_seats.split(',')]
        try:
            assert len(chosen_seats) == ticket_number
            assert len(chosen_seats) == len(set(chosen_seats))

            chosen_correctly = True
            for seat in chosen_seats:
                if seat not in available_seats:
                    print(f"The seat {seat} is not available. Please choose again.")
                    chosen_correctly = False
                    break  
            if chosen_correctly:
                break
        except AssertionError:
            print("Please provide the correct number of tickets in a correct format. Make sure you choose available seats.")

    print("Now we need some data to book the seats.")
    required_info = ["first name", "last name", "phone number", "email"]
    customer_data = []
    while True:
        try:
            for i in range(len(required_info)):
                answer = input(f"Please provide your {required_info[i]}: ")
                assert len(answer) > 1
                customer_data.append(answer)
            break
        except AssertionError:
            print("Please provide the information.")
    add_seats_reservation(chosen_seats, chosen_date, customer_data)
    

#this function enables the customer to delete the reservation, sending the date of the movie and customer's email to 
#function delete_seats_reservation()
def deleting_seats():
    start_date = datetime(2024, 10, 21)
    end_date = datetime(2024, 10, 24)             
    while True:
        chosen_date = input("Please enter the date of the movie for which you want to delete your reservation (yyyy-mm-dd) or type 'exit' to quit: ")
        if chosen_date.lower() == 'exit':
            print("See you soon!")
            return None
        try:
            chosen_date = datetime.strptime(chosen_date, '%Y-%m-%d')
            assert start_date <= chosen_date <= end_date
            break  
        except ValueError:
            print("Invalid date format. Please use yyyy-mm-dd.")
        except AssertionError:
            print(f"Date must be between {start_date.date()} and {end_date.date()}")
    customer_email = input("Please provide your email so we can delete your reservation: ")
    delete_seats_reservation(chosen_date, customer_email)
    




#this function runs at the beginning
def run():
    print('##################################################')
    print('Hello, welcome to the cinema!')
    print('##################################################')
    print('You can view the cinema seats availability by following this links, green seats are available: ')
    print('For 2024-10-21: http://127.0.0.1:5001/cinema/2024-10-21')
    print('For 2024-10-22: http://127.0.0.1:5001/cinema/2024-10-22')
    print('For 2024-10-23: http://127.0.0.1:5001/cinema/2024-10-23')
    print('For 2024-10-24: http://127.0.0.1:5001/cinema/2024-10-24')
    print('##################################################')
    while True:
        choice = input("Please type 'b' if you want to book seats for a movie or 'd' if you want to delete your reservation. Type 'exit' to exit: ")
        choice = choice.lower()
        if choice == 'exit':
            print("See you soon!")
            return None
        elif choice == 'b'or choice == 'd':
            break
        else:
            print("Please choose your action")
    if choice == "b":
        booking_seats()
    else:
        deleting_seats()
        pass



if __name__ == '__main__':
    run()