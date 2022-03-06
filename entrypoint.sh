#!/bin/bash
# Docker entrypoint script.

# Wait until Postgres is ready

echo "Establishing connection to database, please wait..."; 
echo "Attempt $i"; 

while !</dev/tcp/db/${POSTGRES_PORT}; 
do sleep 1; 
let i+=1;
echo "Attempt $i"; 
done;

echo "Database connection established"; 

mix ecto.setup

exec mix phx.server