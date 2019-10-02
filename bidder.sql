/* CREATE SCHEMA */
CREATE SCHEMA bidder;

/* SET SEARCH PATH */
SET search_path = bidder;

/* CREATE TABLES */
CREATE TABLE IF NOT EXISTS campaigns (
	id BIGSERIAL,
	"name" VARCHAR(30) NOT NULL,
	starting_date DATE NOT NULL,
	ending_date DATE NOT NULL,
	CONSTRAINT campaigns_pk PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS categories (
	id BIGSERIAL,
	"name" VARCHAR(30) NOT NULL,
	CONSTRAINT categories_pk PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS statuses (
	id BIGSERIAL,
	"name" VARCHAR(20) NOT NULL,
	CONSTRAINT statuses_pk PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS roles (
	id BIGSERIAL,
	"name" VARCHAR(30) NOT NULL,
	CONSTRAINT roles_pk PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS users (
	id BIGSERIAL,
	email VARCHAR(255) NOT NULL,
	first_name VARCHAR(30) NOT NULL,
	last_name VARCHAR(30) NOT NULL,
	profile_pic_url VARCHAR(255) DEFAULT NULL,
	CONSTRAINT users_pk PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS users_roles (
	user_id int8 NOT NULL,
	role_id int8 NOT NULL,
	CONSTRAINT user_role_fk_user FOREIGN KEY (user_id) REFERENCES users (id),
	CONSTRAINT user_role_fk_role FOREIGN KEY (role_id) REFERENCES roles (id)
);

CREATE TABLE IF NOT EXISTS items (
	id BIGSERIAL,
	campaign_id int8 NOT NULL,
	category_id int8 NOT NULL,
	created_by int8 NOT NULL,
	status_id int8 NOT NULL,
	assigned_to int8 DEFAULT NULL,
	"name" VARCHAR(50) NOT NULL,
	description VARCHAR(255) NOT NULL,
	initial_price NUMERIC(6,3) NOT NULL,
	created DATE NOT NULL,
	CONSTRAINT items_pk PRIMARY KEY (id),
	CONSTRAINT items_fk_campaign FOREIGN KEY (campaign_id) REFERENCES campaigns (id),
	CONSTRAINT items_fk_category FOREIGN KEY (category_id) REFERENCES categories (id),
	CONSTRAINT items_fk_created_by FOREIGN KEY (created_by) REFERENCES users (id),
	CONSTRAINT items_fk_status FOREIGN KEY (status_id) REFERENCES statuses (id),
	CONSTRAINT items_fk_assigned_to FOREIGN KEY (assigned_to) REFERENCES users (id)
);

CREATE TABLE IF NOT EXISTS bids (
	id BIGSERIAL,
	item_id int8 NOT NULL,
	user_id int8 NOT NULL,
	price NUMERIC(6,3) NOT NULL,
	"comment" VARCHAR(255) NOT NULL,
	CONSTRAINT bids_pk PRIMARY KEY (id),
	CONSTRAINT bids_fk_item FOREIGN KEY (item_id) REFERENCES items (id),
	CONSTRAINT bids_fk_user FOREIGN KEY (user_id) REFERENCES users (id)
);

CREATE TABLE IF NOT EXISTS pictures (
	id BIGSERIAL,
	"path" VARCHAR(255) NOT NULL,
	item_id int8 NOT NULL,
	CONSTRAINT pictures_pk PRIMARY KEY (id),
	CONSTRAINT pictures_fk_item FOREIGN KEY (item_id) REFERENCES items (id)
);

/* CREATE INDEXES */
CREATE UNIQUE INDEX ur_user_idx ON users_roles (user_id);
CREATE UNIQUE INDEX ur_role_idx ON users_roles (role_id);
CREATE UNIQUE INDEX items_campaign_idx ON items (campaign_id);
CREATE UNIQUE INDEX items_category_idx ON items (category_id);
CREATE UNIQUE INDEX items_created_by_idx ON items (created_by);
CREATE UNIQUE INDEX items_status_idx ON items (status_id);
CREATE UNIQUE INDEX items_assigned_to_idx ON items (assigned_to);
CREATE UNIQUE INDEX items_initial_price_idx ON items (initial_price);
CREATE UNIQUE INDEX bids_item_idx ON bids (item_id);
CREATE UNIQUE INDEX bids_user_idx ON bids (user_id);
CREATE UNIQUE INDEX pictures_item_idx ON pictures (item_id);

