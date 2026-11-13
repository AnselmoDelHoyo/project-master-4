-- 1. Identificador y ruta de los vuelos On Time
SELECT flight_id, route_no, status
FROM bookings.flights
WHERE status = 'On Time';


-- 2. Reservas cuyo importe supera 1.000.000
SELECT *
FROM bookings.bookings
WHERE total_amount > 1000000;


-- 3. Modelos de avión disponibles
SELECT *
FROM bookings.airplanes_data;


-- 4. Identificadores de vuelos realizados con el avión código 733
SELECT DISTINCT f.flight_id
FROM bookings.flights AS f
JOIN bookings.routes AS r
  ON r.route_no = f.route_no
 AND f.scheduled_departure <@ r.validity
WHERE r.airplane_code = '733';


-- 5. Tickets de pasajeros cuyo nombre contiene Irina
SELECT *
FROM bookings.tickets
WHERE passenger_name ILIKE '%Irina%';


-- 6. Ciudades con más de un aeropuerto
SELECT city ->> 'en' AS ciudad, COUNT(*) AS numero_aeropuertos
FROM bookings.airports_data
GROUP BY city ->> 'en'
HAVING COUNT(*) > 1
ORDER BY numero_aeropuertos DESC, ciudad;


-- 7. Número de vuelos por modelo de avión
SELECT a.model ->> 'en' AS modelo, COUNT(*) AS numero_vuelos
FROM bookings.flights AS f
JOIN bookings.routes AS r
  ON r.route_no = f.route_no
 AND f.scheduled_departure <@ r.validity
JOIN bookings.airplanes_data AS a
  ON a.airplane_code = r.airplane_code
GROUP BY a.model ->> 'en'
ORDER BY numero_vuelos DESC;


-- 8. Reservas con más de un ticket
SELECT b.*, COUNT(t.ticket_no) AS numero_tickets
FROM bookings.bookings AS b
JOIN bookings.tickets AS t
  ON t.book_ref = b.book_ref
GROUP BY b.book_ref
HAVING COUNT(t.ticket_no) > 1
ORDER BY numero_tickets DESC;


-- 9. Vuelos con más de una hora de retraso en la salida
SELECT flight_id, route_no, scheduled_departure, actual_departure
FROM bookings.flights
WHERE actual_departure > scheduled_departure + INTERVAL '1 hour'
ORDER BY scheduled_departure;