from flask import Flask, jsonify, request, send_file
from db_utils_cinema import get_available_seats, cinema_seats, add_reservation, delete_reservation

app = Flask(__name__)

#used to display the image of the cinema
@app.route("/cinema/<date>")
def show_image(date):
    mapped_seats, available_seats = get_available_seats(date)
    image = cinema_seats(mapped_seats)
    return send_file(image, mimetype='image/png')

#used to get the available seats
@app.route("/cinema/<date>/seats")
def get_availability(date):
    mapped_seats, available_seats = get_available_seats(date)
    return jsonify(available_seats.tolist())


#used to add reservation
@app.route("/cinema", methods=['PUT'])
def put_reservation():
    reservation = request.get_json()
    result = add_reservation(
        seat_id = reservation["seat_id"],
        movie_date = reservation["movie_date"],
        customer_first_name = reservation["customer_first_name"],
        customer_last_name = reservation["customer_last_name"],
        customer_phone_number = reservation["customer_phone_number"],
        customer_email = reservation["customer_email"],
    )
    print(reservation)
    return jsonify(reservation)


#used to delete reservation
@app.route('/cinema/delete', methods=['DELETE'])
def delete_reserved_seat():
    reservation_to_delete = request.get_json()
    result = delete_reservation(
        movie_date = reservation_to_delete["movie_date"],
        customer_email = reservation_to_delete["customer_email"])
    print(result)
    if result == "Nothing":
        return jsonify(result), 404     
    return jsonify(result)


if __name__ == "__main__":
    app.run(debug=True, port=5001)