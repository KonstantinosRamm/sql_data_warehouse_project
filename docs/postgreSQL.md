# Installation for postgreSQL on `UBUNTU` 🐧

## Update your system
```bash
sudo apt update
sudo apt upgrade -y
```

## Install PostgreSQL
```bash
sudo apt install postgresql postgresql-contrib -y
```
## Enable PostgreSQL Service
```bash
sudo systemctl start postgresql
sudo systemctl enable postgresql  # starts automatically on boot
```

## Connect to postgres server as postgres
```bash
sudo -i -u postgres
psql
```
## Set password for postgres user
```
ALTER USER postgres PASSWORD 'Add_Your_Password_here';
\q
```




