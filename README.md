# Paredao BBB

This is a sample Ruby on Rails web application to simulate an eviction poll for the Big Brother reality show. It is based on the Brazilian version.

It is playground to play out with different scenarios of high traffic requests, scalability, performance, etc (real world issues and requirements for the TV show, watched by millions of people).

## Considerations

The app itself simulates an eviction poll by 2+ contestants to see who is going to leave the Big Borther house.

Para lidar com o alto número de requisições por segundo nas votações, foi decidido em não persistir em tempo real todos os votos enviados pelos usuários, pois isso geraria um alto número de operações de I/O no banco de dados por segundo. Com isso, os votos ficam na memória até que um scheduler job, rodando em background de 1 em 1 segundo, os le faz um bulk insert de todos os votos até aquele momento.

Além disso, a porcentagem do resultado da votação é cacheada também por um outro background job que roda de 1 em 1 segundo. Com isso, a tela com os resultados NÃO são apresentadas em tempo real, no pior dos casos com um delay de 1 segundo.

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
