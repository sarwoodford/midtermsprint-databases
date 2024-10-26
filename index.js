const { Pool } = require('pg');

// PostgreSQL connection
const pool = new Pool({
  user: 'sara', //This _should_ be your username, as it's the default one Postgres uses
  host: 'localhost',
  database: 'midtermsprint', //This should be changed to reflect your actual database
  password: 'sara', //This should be changed to reflect the password you used when setting up Postgres
  port: 5432,
});

/**
 * Creates the database tables, if they do not already exist.
 */
async function createTable() {
  // TODO: Add code to create Movies, Customers, and Rentals tables
  // create movies table
  const createMoviesTable =   
  `CREATE TABLE IF NOT EXISTS movies(
    movie_id SERIAL PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    release_year INT NOT NULL,
    genre VARCHAR(100) NOT NULL,
    director_name VARCHAR(100) NOT NULL
  );
  `;

  const createCustomersTable = 
  `CREATE TABLE IF NOT EXISTS customers(
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL,
    phone_num VARCHAR(10) NOT NULL
  );
  `;

  const createRentalsTable = 
  `CREATE TABLE IF NOT EXISTS rentals(
    rental_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    movie_id INT REFERENCES movies(movie_id),
    rental_date DATE NOT NULL,
    return_date DATE 
  );
  `;

    
  await pool.query(createMoviesTable);
  await pool.query(createCustomersTable);
  await pool.query(createRentalsTable);

};
  

/**
 * Inserts a new movie into the Movies table.
 * 
 * @param {string} title Title of the movie
 * @param {number} year Year the movie was released
 * @param {string} genre Genre of the movie
 * @param {string} director Director of the movie
 */
async function insertMovie(title, release_year, genre, director_name) {
  // TODO: Add code to insert a new movie into the Movies table
  const query = 'INSERT INTO movies (title, release_year, genre, director_name) VALUES ($1, $2, $3, $4) RETURNING *';
  const result = await pool.query(query, [title, release_year, genre, director_name])
  console.log(`Added movie: ${result.rows[0].title}, ${result.rows[0].release_year}. ${result.rows[0].genre} 
              movie directed by ${result.rows[0].director_name}`);
};

/**
 * Prints all movies in the database to the console
 */
async function displayMovies() {
  // TODO: Add code to retrieve and print all movies from the Movies table
  const result = await pool.query('SELECT * FROM movies');
  console.log('Movies: ');
  result.rows.forEach(movie => {
    console.log(`${movie.movie_id}: ${movie.title}, ${movie.release_year} - a ${movie.genre} by ${movie.director_name}`);
  });

};

/**
 * Updates a customer's email address.
 * 
 * @param {number} customerId ID of the customer
 * @param {string} newEmail New email address of the customer
 */
async function updateCustomerEmail(customerId, newEmail) {
  // TODO: Add code to update a customer's email address
  const query = 'UPDATE customers SET email = $1 WHERE customer_id = $2 RETURNING *';
  const result = await pool.query(query [newEmail, customerId]);
  console.log(`changed customer ${customerId} email to ${newEmail}`)
};

/**
 * Removes a customer from the database along with their rental history.
 * 
 * @param {number} customerId ID of the customer to remove
 */
async function removeCustomer(customerId) {
  // TODO: Add code to remove a customer and their rental history
  const removeRentalsQuery = 'DELETE FROM rentals WHERE customer_id = $1';
  const removeCustomerQuery = 'DELETE FROM customers WHERE customer_id = $1';
  
  await pool.query(removeRentalsQuery, [customerId]);
  const result = await pool.query(removeCustomerQuery, [customerId]);
  console.log(`Customer ${customerId} and associated rentals deleted.`)

};

/**
 * Prints a help message to the console
 */
function printHelp() {
  console.log('Usage:');
  console.log('  insert <title> <year> <genre> <director> - Insert a movie');
  console.log('  show - Show all movies');
  console.log('  update <customer_id> <new_email> - Update a customer\'s email');
  console.log('  remove <customer_id> - Remove a customer from the database');
}

/**
 * Runs our CLI app to manage the movie rentals database
 */
async function runCLI() {
  await createTable();

  const args = process.argv.slice(2);
  switch (args[0]) {
    case 'insert':
      if (args.length !== 5) {
        printHelp();
        return;
      }
      await insertMovie(args[1], parseInt(args[2]), args[3], args[4]);
      break;
    case 'show':
      await displayMovies();
      break;
    case 'update':
      if (args.length !== 3) {
        printHelp();
        return;
      }
      await updateCustomerEmail(parseInt(args[1]), args[2]);
      break;
    case 'remove':
      if (args.length !== 2) {
        printHelp();
        return;
      }
      await removeCustomer(parseInt(args[1]));
      break;
    default:
      printHelp();
      break;
  }
};

runCLI();
