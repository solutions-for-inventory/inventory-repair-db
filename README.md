# Database

###Build docker image
```
$ cd inventory-repair-db
$ docker build -t inventory-repair-db:1.0 ./ 
```

###Run DB docker container
```
$ docker run -it --net=host -p 5432:5432 -d inventory-repair-db:1.0
```

###Run DB flyway migration
```
$ docker run --rm flyway/flyway migrate
```
OR
```
$ docker run --rm flyway/flyway -url=jdbc:postgresql://192.168.99.100:5432/inventory_repair_db -user=inventory_user -password=
inventory_password migrate
```
OR
```
$ docker run --rm -v $PWD/inventory-repair-db/sql:/flyway/sql -v $PWD/inventory-repair-db/conf:/flyway/conf -v $PWD/inventory-repair-db/jars:/flyway/jars flyway/flyway migrate
```
