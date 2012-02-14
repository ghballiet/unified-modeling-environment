create table users (
  id integer primary key auto_increment, 
  name varchar(250), 
  email varchar(250),
  password varchar(250)
);

create table unified_models (
  id integer primary key auto_increment,
  name varchar(250),
  description text,
  user_id int
);

create table generic_entities (
  id integer primary key auto_increment,
  name varchar(250), 
  unified_model_id int
);

create table concrete_entities (
  id integer primary key auto_increment,
  name varchar(250),
  unified_model_id int,
  generic_entity_id int
);

create table generic_attributes (
  id integer primary key auto_increment,
  name varchar(250),
  value varchar(500),
  generic_entity_id int
);

create table concrete_attributes (
  id integer primary key auto_increment,
  name varchar(250),
  value varchar(250),
  concrete_entity_id int
);

create table generic_processes (
  id integer primary key auto_increment,
  name varchar(250),
  unified_model_id int
);

create table concrete_processes (
  id integer primary key auto_increment,
  name varchar(250),
  generic_process_id int,
  unified_model_id int  
);

create table generic_equations (
  id integer primary key auto_increment,
  is_algebraic boolean,
  generic_attribute_id int,
  right_hand_side varchar(500),
  generic_process_id int
);

create table concrete_equations (
  id integer primary key auto_increment,
  is_algebraic boolean,
  concrete_attribute_id int,
  right_hand_side varchar(500),
  concrete_process_id int
);

create table generic_process_arguments (
  id integer primary key auto_increment,
  generic_process_id int,
  generic_entity_id int
);

create table concrete_process_arguments (
  id integer primary key auto_increment,
  concrete_process_id int,
  concrete_entity_id int
);

create table generic_process_attributes (
  id integer primary key auto_increment,
  name varchar(250),
  value varchar(250),
  generic_process_id int
);

create table concrete_process_attributes (
  id integer primary key auto_increment,
  name varchar(250),
  value varchar(250),
  concrete_process_id int
);

create table generic_terms (
  id integer primary key auto_increment,
  generic_equation_id int,
  left_id int,
  left_type_id int,
  right_id int,
  right_type_id int,
  operand_id int
);

create table term_types (
  id integer primary key auto_increment,
  name varchar(250)
);

create table operands (
  id integer primary key auto_increment,
  symbol varchar(50)
);