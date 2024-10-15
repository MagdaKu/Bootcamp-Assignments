import mysql.connector
import numpy as np
import matplotlib.pyplot as plt
import io
from config import HOST, USER, PASSWORD


#create a custom error
class DbConnectionError(Exception):
    pass

#establish the connection with mysql
def connect_to_db(database_name):
    cnx = mysql.connector.connect(
        host=HOST,
        user=USER,
        password=PASSWORD,
        database= database_name)
    return cnx


#returns matrix in shape of the cinema with values "Reserved" or "Available",  list of available seats
def map_values(result):
    mapped_seats = np.array([])
    available_seats = np.array([])
    for item in result:
        if item[1] !=None :
            mapped_seats = np.append(mapped_seats, "Reserved")
        else:
            mapped_seats = np.append(mapped_seats, "Available")
            available_seats = np.append(available_seats, item[0])
    
    return(mapped_seats.reshape((5,8)), available_seats)


# reads all records by date and returns mapped seats
def get_available_seats(date):
    database_name = "cinema"
    try:
        db_connection = connect_to_db(database_name) 
        cursor = db_connection.cursor()  
        print(f'Connected to DB {database_name}')
        query = f'SELECT * FROM cinema_seats WHERE movie_date = "{date}" ORDER BY seat_id;'
        cursor.execute(query) 
        results = cursor.fetchall()  
        cursor.close() 
    except Exception as error:
        raise DbConnectionError("Failed to read data from DB")
    finally:
        if db_connection: 
            db_connection.close()  
            print('DB connection is closed')
    
    return map_values(results)


#returns the view of the cinema with red or green rectangles symbolising availability
def cinema_seats(availability):
    x_labels = ['1', '2', '3', '4', '5',"6","7","8"]  
    y_labels = ['A', 'B', 'C', 'D', 'E']

    fig, ax = plt.subplots(figsize=(8, 5))
    ax.set_title("Screen")
    ax.set_xlabel("Seats")
    ax.set_ylabel("Rows")
    
    # creates a grid which shows the seats, but doesn't show labels and ticks
    ax.set_xticks(np.arange(len(x_labels) + 1))  
    ax.set_yticks(np.arange(len(y_labels) + 1))
    ax.set_xticklabels([])
    ax.set_yticklabels([])
    ax.grid(True, which='major', color='black', linestyle='-', linewidth=1)
    ax.tick_params(which='major', length=0)

    # this allows to label the seats correctly
    ax.set_xticks(np.arange(len(x_labels)) + 0.5, minor=True)  
    ax.set_yticks(np.arange(len(y_labels)) + 0.5, minor=True) 
    ax.set_xticklabels(x_labels, minor=True)
    ax.set_yticklabels(y_labels[::-1], minor=True)
    ax.grid(False, which='minor')

    #colors the seats red or green
    for i in range(len(y_labels)):
        for j in range(len(x_labels)):
            if availability[i][j] == 'Reserved':
                ax.add_patch(plt.Rectangle((j,len(y_labels)-1-i), 1, 1, color='red')) 
            else:
                ax.add_patch(plt.Rectangle((j, len(y_labels)-1-i), 1, 1, color='green'))

    img = io.BytesIO()
    plt.savefig(img, format='png', bbox_inches='tight') 
    plt.close(fig)  
    img.seek(0) 
    return img


#used to add reservation, first it checks if the customer is in the database, if not it creates a query to add new customer
#then it updates table cinema_seats to book the chosen seats with customer_id
def add_reservation(seat_id, movie_date, customer_first_name, customer_last_name, customer_phone_number, customer_email):
    try:
        database_name = "cinema"
        db_connection = connect_to_db(database_name)
        cursor = db_connection.cursor()
        print(f"Connected to DB: {database_name}")
        #checking if the client is in the database
        query = f"""SELECT customer_id FROM customers WHERE email = %s"""
        cursor.execute(query, (customer_email, ))
        result = cursor.fetchone()
        if result:
            customer_id = result[0] 
        else:
            # If customer does not exist, inserts a new customer
            query = """INSERT INTO customers (customer_first_name, customer_last_name, phone_number, email) 
                       VALUES (%s, %s, %s, %s)"""
            cursor.execute(query, (customer_first_name, customer_last_name, customer_phone_number, customer_email))
            db_connection.commit()
            customer_id = cursor.lastrowid
        
        #updating cinema seats, taking a list of seats into account
        seat_id_str = ','.join([f"'{seat}'" for seat in seat_id])
        query = f"""UPDATE cinema_seats
            SET customer_id =  %s
            WHERE seat_id IN ({seat_id_str}) AND movie_date = %s;"""
        cursor.execute(query, (customer_id, movie_date))
        db_connection.commit()
        print(f"Reservation successful for customer_id {customer_id}")
        cursor.close()
    except Exception:
        raise DbConnectionError("Failed to read data from DB")
    finally:
        if db_connection:
            db_connection.close()
            print("DB connection closed")



#used to delete the reservation, first it checks with email if the customer is in the database 
#then it deletes the reservation, if the customer has no more reservations, it deletes the customer's data as well
def delete_reservation(movie_date, customer_email):
    try:
        database_name = "cinema"
        db_connection = connect_to_db(database_name)
        cursor = db_connection.cursor()
        print(f"Connected to DB: {database_name}")
        #checking if the client is in the database
        query = f"""SELECT customer_id FROM customers WHERE email = %s"""
        cursor.execute(query, (customer_email, ))
        result = cursor.fetchone()
        if result:
            customer_id = result[0] 
            query = f"""UPDATE cinema_seats
                SET customer_id = NULL 
                WHERE customer_id = %s 
                AND movie_date = %s;"""
            cursor.execute(query, (customer_id, movie_date))
            db_connection.commit()
            print(f"Reservation successfully deleted for customer_id {customer_id}")
            # If no remaining reservations, deletes the customer
            query = """SELECT * FROM cinema_seats WHERE customer_id = %s;"""
            cursor.execute(query, (customer_id,))
            remaining_reservations = cursor.fetchall()
            if len(remaining_reservations) == 0:
                query = """DELETE FROM customers WHERE customer_id = %s;"""
                cursor.execute(query, (customer_id,))
                db_connection.commit()
        else:
            print("There is no reservation for this email")
            return "Nothing"
        cursor.close()
    except Exception:
        raise DbConnectionError("Failed to read data from DB")
    finally:
        if db_connection:
            db_connection.close()
            print("DB connection closed")
