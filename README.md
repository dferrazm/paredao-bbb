# Paredao BBB

This is a sample Ruby on Rails web application to simulate an eviction poll for the Big Brother reality show. It is based on the Brazilian version.

It is playground to play out with different scenarios of high traffic requests, scalability, performance, etc (real world issues and requirements for the TV show, watched by millions of people).

## Considerations

The app itself simulates an eviction poll by 2+ contestants to see who is going to leave the Big Borther house.

To handle the high number of requests per second when the poll is running, the votes are not persisted in real time, because this would generate a high number of I/O operations. Instead, the votes are stored in a memory cache (Redis) and a background job runs every second, reads them and performs a bulk insert into the DB.

### Setting up & Running

The environment was based on a Ubuntu 14.04. To set it up, execute:

````
./bin/provision.sh
````

After provisioning, run the app with:

````
foreman start
````

### Testing

The tests need [PhantomJS](http://phantomjs.org/build.html) to be installed. To run the tests execute `rspec`.

### Admin

To access the admin dashboard for the voting stats and results, access `http://localhost:3000/stats`. Use `admin@example.com` as user and `password` as password.

### Deploy

Using `capistrano` for deploy. All the configs are in `config/deploy.rb` and `config/deploy/` folder. The deploy is done through `cap production deploy`.
