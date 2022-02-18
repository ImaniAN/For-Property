-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2021-03-25 12:56:00.53

-- tables
-- Table: area
CREATE TABLE area (
    id int NOT NULL AUTO_INCREMENT,
    real_estate_id int NOT NULL,
    area_name varchar(128) NOT NULL,
    UNIQUE INDEX area_ak_1 (real_estate_id,area_name),
    CONSTRAINT area_pk PRIMARY KEY (id)
) COMMENT 'parts of real estate, e.g. rooms';

-- Table: auto_message
CREATE TABLE auto_message (
    id int NOT NULL AUTO_INCREMENT,
    device_id int NOT NULL,
    message_text text NOT NULL,
    ts timestamp NOT NULL,
    `read` bool NOT NULL COMMENT '(un)read',
    CONSTRAINT auto_message_pk PRIMARY KEY (id)
) COMMENT 'messages generated by devices';

-- Table: command
CREATE TABLE command (
    id int NOT NULL AUTO_INCREMENT,
    recurring_command_id int NULL,
    user_account_id int NOT NULL,
    device_id int NOT NULL,
    command_type_id int NOT NULL,
    parameters text NOT NULL COMMENT 'list of selected parameters values',
    executed bool NOT NULL,
    ts timestamp NOT NULL,
    CONSTRAINT command_pk PRIMARY KEY (id)
) COMMENT 'commands sent from users to devices (could be future commends)';

-- Table: command_type
CREATE TABLE command_type (
    id int NOT NULL AUTO_INCREMENT,
    type_name varchar(128) NOT NULL,
    parameters text NOT NULL COMMENT 'list of all parameters that should be defined with default values',
    UNIQUE INDEX command_type_ak_1 (type_name),
    CONSTRAINT command_type_pk PRIMARY KEY (id)
);

-- Table: device
CREATE TABLE device (
    id int NOT NULL AUTO_INCREMENT,
    real_estate_id int NOT NULL,
    area_id int NULL,
    device_type_id int NOT NULL,
    device_parameters text NOT NULL COMMENT 'all parameters related to that device; including parameters important for operations, e.g. intervals when to store data',
    current_status text NOT NULL COMMENT 'current status of device parameters',
    time_activated int NOT NULL,
    time_deactivated int NOT NULL,
    is_active bool NOT NULL,
    CONSTRAINT device_pk PRIMARY KEY (id)
);

-- Table: device_data
CREATE TABLE device_data (
    id int NOT NULL AUTO_INCREMENT,
    device_id int NOT NULL,
    data_description varchar(255) NOT NULL,
    data_location text NOT NULL COMMENT 'link to the location where data is stored',
    ts timestamp NOT NULL,
    CONSTRAINT device_data_pk PRIMARY KEY (id)
) COMMENT 'data produced by device (stored in different time periods)';

-- Table: device_type
CREATE TABLE device_type (
    id int NOT NULL AUTO_INCREMENT,
    type_name varchar(64) NOT NULL,
    description text NULL,
    UNIQUE INDEX device_type_ak_1 (type_name),
    CONSTRAINT device_type_pk PRIMARY KEY (id)
);

-- Table: profile
CREATE TABLE profile (
    id int NOT NULL AUTO_INCREMENT,
    profile_name varchar(255) NOT NULL,
    user_account_id int NOT NULL,
    allow_others bool NOT NULL COMMENT 'users added in the list can use this profile',
    is_public bool NOT NULL COMMENT 'anyone can use this profile',
    is_active bool NOT NULL,
    ts bool NOT NULL,
    UNIQUE INDEX profile_ak_1 (profile_name,user_account_id),
    CONSTRAINT profile_pk PRIMARY KEY (id)
) COMMENT 'profiles allow access to certain devices';

-- Table: profile_device_list
CREATE TABLE profile_device_list (
    profile_id int NOT NULL,
    device_id int NOT NULL,
    CONSTRAINT profile_device_list_pk PRIMARY KEY (profile_id,device_id)
);

-- Table: real_estate
CREATE TABLE real_estate (
    id int NOT NULL AUTO_INCREMENT,
    real_estate_name varchar(255) NOT NULL,
    user_account_id int NOT NULL,
    real_estate_type_id int NOT NULL,
    address varchar(255) NULL,
    details text NULL,
    UNIQUE INDEX real_estate_ak_1 (real_estate_name,user_account_id),
    CONSTRAINT real_estate_pk PRIMARY KEY (id)
) COMMENT 'list of all real estates';

-- Table: real_estate_type
CREATE TABLE real_estate_type (
    id int NOT NULL AUTO_INCREMENT,
    type_name varchar(32) NOT NULL,
    UNIQUE INDEX real_estate_type_ak_1 (type_name),
    CONSTRAINT real_estate_type_pk PRIMARY KEY (id)
);

-- Table: recurring_command
CREATE TABLE recurring_command (
    id int NOT NULL AUTO_INCREMENT,
    user_account_id int NOT NULL,
    device_id int NOT NULL,
    command_type_id int NOT NULL,
    parameters text NOT NULL,
    interval_definition text NOT NULL,
    active_from timestamp NOT NULL,
    active_to timestamp NULL,
    is_active bool NOT NULL,
    ts timestamp NOT NULL,
    CONSTRAINT recurring_command_pk PRIMARY KEY (id)
);

-- Table: shared_with
CREATE TABLE shared_with (
    profile_id int NOT NULL,
    user_account_id int NOT NULL,
    CONSTRAINT shared_with_pk PRIMARY KEY (profile_id,user_account_id)
) COMMENT 'list of all users that can see profile';

-- Table: user_account
CREATE TABLE user_account (
    id int NOT NULL AUTO_INCREMENT,
    first_name varchar(64) NOT NULL,
    last_name varchar(64) NOT NULL,
    user_name varchar(64) NOT NULL,
    password varchar(255) NOT NULL,
    email varchar(128) NOT NULL,
    confirmation_code text NOT NULL,
    confirmation_time timestamp NULL,
    ts timestamp NOT NULL,
    UNIQUE INDEX user_account_ak_1 (user_name),
    UNIQUE INDEX user_account_ak_2 (email),
    CONSTRAINT user_account_pk PRIMARY KEY (id)
) COMMENT 'application users';

-- foreign keys
-- Reference: area_real_estate (table: area)
ALTER TABLE area ADD CONSTRAINT area_real_estate FOREIGN KEY area_real_estate (real_estate_id)
    REFERENCES real_estate (id);

-- Reference: auto_message_device (table: auto_message)
ALTER TABLE auto_message ADD CONSTRAINT auto_message_device FOREIGN KEY auto_message_device (device_id)
    REFERENCES device (id);

-- Reference: command_command_type (table: command)
ALTER TABLE command ADD CONSTRAINT command_command_type FOREIGN KEY command_command_type (command_type_id)
    REFERENCES command_type (id);

-- Reference: command_device (table: command)
ALTER TABLE command ADD CONSTRAINT command_device FOREIGN KEY command_device (device_id)
    REFERENCES device (id);

-- Reference: command_recurring_command (table: command)
ALTER TABLE command ADD CONSTRAINT command_recurring_command FOREIGN KEY command_recurring_command (recurring_command_id)
    REFERENCES recurring_command (id);

-- Reference: command_user_account (table: command)
ALTER TABLE command ADD CONSTRAINT command_user_account FOREIGN KEY command_user_account (user_account_id)
    REFERENCES user_account (id);

-- Reference: device_area (table: device)
ALTER TABLE device ADD CONSTRAINT device_area FOREIGN KEY device_area (area_id)
    REFERENCES area (id);

-- Reference: device_data_device (table: device_data)
ALTER TABLE device_data ADD CONSTRAINT device_data_device FOREIGN KEY device_data_device (device_id)
    REFERENCES device (id);

-- Reference: device_device_type (table: device)
ALTER TABLE device ADD CONSTRAINT device_device_type FOREIGN KEY device_device_type (device_type_id)
    REFERENCES device_type (id);

-- Reference: device_list_device (table: profile_device_list)
ALTER TABLE profile_device_list ADD CONSTRAINT device_list_device FOREIGN KEY device_list_device (device_id)
    REFERENCES device (id);

-- Reference: device_list_profile (table: profile_device_list)
ALTER TABLE profile_device_list ADD CONSTRAINT device_list_profile FOREIGN KEY device_list_profile (profile_id)
    REFERENCES profile (id);

-- Reference: device_real_estate (table: device)
ALTER TABLE device ADD CONSTRAINT device_real_estate FOREIGN KEY device_real_estate (real_estate_id)
    REFERENCES real_estate (id);

-- Reference: profile_user_account (table: profile)
ALTER TABLE profile ADD CONSTRAINT profile_user_account FOREIGN KEY profile_user_account (user_account_id)
    REFERENCES user_account (id);

-- Reference: real_estate_real_estate_type (table: real_estate)
ALTER TABLE real_estate ADD CONSTRAINT real_estate_real_estate_type FOREIGN KEY real_estate_real_estate_type (real_estate_type_id)
    REFERENCES real_estate_type (id);

-- Reference: real_estate_user_account (table: real_estate)
ALTER TABLE real_estate ADD CONSTRAINT real_estate_user_account FOREIGN KEY real_estate_user_account (user_account_id)
    REFERENCES user_account (id);

-- Reference: recurring_command_command_type (table: recurring_command)
ALTER TABLE recurring_command ADD CONSTRAINT recurring_command_command_type FOREIGN KEY recurring_command_command_type (command_type_id)
    REFERENCES command_type (id);

-- Reference: recurring_command_device (table: recurring_command)
ALTER TABLE recurring_command ADD CONSTRAINT recurring_command_device FOREIGN KEY recurring_command_device (device_id)
    REFERENCES device (id);

-- Reference: recurring_command_user_account (table: recurring_command)
ALTER TABLE recurring_command ADD CONSTRAINT recurring_command_user_account FOREIGN KEY recurring_command_user_account (user_account_id)
    REFERENCES user_account (id);

-- Reference: shared_with_profile (table: shared_with)
ALTER TABLE shared_with ADD CONSTRAINT shared_with_profile FOREIGN KEY shared_with_profile (profile_id)
    REFERENCES profile (id);

-- Reference: shared_with_user_account (table: shared_with)
ALTER TABLE shared_with ADD CONSTRAINT shared_with_user_account FOREIGN KEY shared_with_user_account (user_account_id)
    REFERENCES user_account (id);

-- End of file.
