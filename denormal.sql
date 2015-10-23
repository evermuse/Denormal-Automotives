-- setup / reset of environment

\c bryan;

drop database if exists denormal_cars;
drop role if exists denormal_user;

create user denormal_user;

create database denormal_cars owner denormal_user;

\c denormal_cars;

\i ./scripts/denormal_data.sql;

-- 5 list of all make_title values in the car_models table, without any duplicate rows

--select distinct make_title from car_models;


-- 6 list all model_title values where the make_code is 'VOLKS', without any duplicate rows

--select distinct model_title from car_models where make_code = 'VOLKS';


-- 7 list all make_code, model_code, model_title, and year from car_models where the make_code is 'LAM'

--select make_code, model_code, model_title, year from car_models where make_code = 'LAM';


-- 8 list all fields from all car_models in years between 2010 and 2015

--select * from car_models where year > 2009 AND year < 2016;

