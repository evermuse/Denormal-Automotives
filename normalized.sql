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


-- query to get a list of all make_title values in the car_models table

select distinct make_title
from car_makes
inner join car_normal
on car_makes.id = car_normal.model_id;


-- query to list all model_title values where the make_code is 'VOLKS'

select distinct car_models.model_title
from car_normal
inner join car_makes
on car_normal.make_id = car_makes.id
inner join car_models
on car_normal.model_id = car_models.id
where car_makes.make_code = 'VOLKS';


-- Create a query to list all make_code, model_code, model_title, and year from car_models where the make_code is 'LAM'

select distinct car_makes.make_code, car_models.model_code, car_models.model_title, car_years.year
from car_normal
inner join car_makes
on car_normal.make_id = car_makes.id
inner join car_models
on car_normal.model_id = car_models.id
inner join car_years
on car_normal.year_id = car_years.id
where car_makes.make_code = 'LAM';


-- written again using aliases

select distinct cm.make_code as make, cd.model_code as model, cd.model_title as title, cy.year
from car_normal cn
inner join car_makes cm
on cn.make_id = cm.id
inner join car_models cd
on cn.model_id = cd.id
inner join car_years cy
on cn.year_id = cy.id
where cm.make_code = 'LAM';


-- list all fields from all car_models in years between 2010 and 2015

select cm.model_code
from car_normal cn
inner join car_models cm
on cn.model_id = cm.id
inner join car_years cy
on cn.year_id = cy.id
-- where year > 2009 AND year < 2016;
where year between 2010 AND 2015; -- can also use between
