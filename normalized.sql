-- setup / reset of environment

\c bryan;

drop database if exists normal_cars;
drop role if exists normal_user;

-- new user and database

create user normal_user;

create database normal_cars owner normal_user;


-- import the denormalized data

\c normal_cars;

\i ./scripts/denormal_data.sql;


-- create new car_make table

create table if not exists car_makes (

  id smallserial primary key,
  make_code character varying(125) NOT NULL,
  make_title character varying(125) NOT NULL

);


-- insert car_make data from car_denormal table into car_makes table

insert into car_makes (make_code, make_title)
select distinct denormal_make_code, denormal_make_title
from car_denormal;


-- create new car_model table

create table if not exists car_models (

  id serial primary key,
  model_code character varying(125) NOT NULL,
  model_title character varying(125) NOT NULL

);


-- insert car_model data from car_denormal table into car_models table

insert into car_models (model_code, model_title)
select distinct denormal_model_code, denormal_model_title
from car_denormal;


-- create car_year table

create table if not exists car_years (

  id smallserial primary key,
  year smallint NOT NULL

);


-- insert car_year data from car_denormal table into car_years table

insert into car_years ( year )
select distinct denormal_year
from car_denormal;


-- create car_normal table

create table if not exists car_normal (

  car_id serial primary key,
  make_id int references car_makes(id),
  model_id int references car_models(id),
  year_id smallint references car_years(id)

);


-- insert make_id data from car_makes table into car_normal table

insert into car_normal ( make_id, model_id, year_id )
select car_makes.id, car_models.id, car_years.id
from car_makes, car_models, car_years, car_denormal
where car_makes.make_code = car_denormal.denormal_make_code AND car_models.model_code = car_denormal.denormal_model_code AND car_years.year = car_denormal.denormal_year;


--