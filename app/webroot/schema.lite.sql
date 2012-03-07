create table if not exists users (
  id integer primary key autoincrement, 
  name varchar(250), 
  email varchar(250),
  password varchar(250)
);

create table if not exists unified_models (
  id integer primary key autoincrement,
  name varchar(250),
  description text,
  user_id int
);

create table if not exists generic_entities (
  id integer primary key autoincrement,
  name varchar(250), 
  unified_model_id int
);

create table if not exists concrete_entities (
  id integer primary key autoincrement,
  name varchar(250),
  unified_model_id int,
  generic_entity_id int
);

create table if not exists generic_attributes (
  id integer primary key autoincrement,
  name varchar(250),
  value varchar(500),
  generic_entity_id int
);

create table if not exists concrete_attributes (
  id integer primary key autoincrement,
  name varchar(250),
  value varchar(250),
  concrete_entity_id int
);

create table if not exists generic_processes (
  id integer primary key autoincrement,
  name varchar(250),
  unified_model_id int
);

create table if not exists concrete_processes (
  id integer primary key autoincrement,
  name varchar(250),
  generic_process_id int,
  unified_model_id int  
);

create table if not exists generic_equations (
  id integer primary key autoincrement,
  is_algebraic boolean,
  generic_attribute_id int,
  right_hand_side varchar(500),
  generic_process_id int,
  generic_process_argument_id int
);

create table if not exists concrete_equations (
  id integer primary key autoincrement,
  is_algebraic boolean,
  concrete_attribute_id int,
  right_hand_side varchar(500),
  concrete_process_id int
);

create table if not exists generic_process_arguments (
  id integer primary key autoincrement,
  generic_process_id int,
  generic_entity_id int
);

create table if not exists concrete_process_arguments (
  id integer primary key autoincrement,
  concrete_process_id int,
  concrete_entity_id int
);

create table if not exists generic_process_attributes (
  id integer primary key autoincrement,
  name varchar(250),
  value varchar(250),
  generic_process_id int
);

create table if not exists concrete_process_attributes (
  id integer primary key autoincrement,
  name varchar(250),
  value varchar(250),
  concrete_process_id int
);

create table if not exists generic_terms (
  id integer primary key autoincrement,
  generic_equation_id int,
  left_id int,
  left_type_id int,
  right_id int,
  right_type_id int,
  operand_id int
);

create table if not exists term_types (
  id integer primary key autoincrement,
  name varchar(250)
);

create table if not exists operands (
  id integer primary key autoincrement,
  symbol varchar(50)
);

-- create table if not exists exogenous_values (
--   id integer primary key autoincrement,
--   timestep integer,
--   concrete_attribute_id integer,
--   value varchar(250),
--   unified_model_id integer  
-- );

create table if not exists exogenous_values (
  id integer primary key autoincrement, 
  value longtext,
  unified_model_id integer
);

create table if not exists empirical_observations (
  id integer primary key autoincrement,
  value longtext, 
  unified_model_id integer
);

create table if not exists generic_conditions (
  id integer primary key autoincrement,
  value varchar(500),
  generic_process_id integer
);

create table if not exists concrete_conditions (
  id integer primary key autoincrement,
  value varchar(500),
  concrete_process_id integer,
  generic_condition_id integer
);