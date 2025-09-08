-- Create an app role and databases on first boot.
CREATE ROLE app WITH LOGIN PASSWORD 'app_password' SUPERUSER;

CREATE DATABASE app_development OWNER app;
CREATE DATABASE app_test        OWNER app;

GRANT ALL PRIVILEGES ON DATABASE app_development TO app;
GRANT ALL PRIVILEGES ON DATABASE app_test TO app;
