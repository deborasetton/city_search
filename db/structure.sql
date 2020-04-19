SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: citext; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS citext WITH SCHEMA public;


--
-- Name: EXTENSION citext; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION citext IS 'data type for case-insensitive character strings';


--
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry, geography, and raster spatial types and functions';


SET default_tablespace = '';

--
-- Name: alternate_names; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.alternate_names (
    id integer,
    geoname_id integer,
    extra text,
    alternate_name text,
    extra1 text,
    extra2 text,
    extra3 text,
    extra4 text,
    extra5 text,
    extra6 text
);


--
-- Name: api_clients; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.api_clients (
    id bigint NOT NULL,
    name character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: api_clients_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.api_clients_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: api_clients_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.api_clients_id_seq OWNED BY public.api_clients.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: first_level_divisions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.first_level_divisions (
    id character varying NOT NULL,
    name character varying,
    ascii_name character varying,
    geoname_id integer,
    abbreviation text
);


--
-- Name: geonames; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.geonames (
    id integer NOT NULL,
    name character varying(200),
    ascii_name character varying(200),
    alternate_names text,
    latitude double precision,
    longitude double precision,
    feature_class character(1),
    feature_code character varying(10),
    country character varying(2),
    cc2 character varying(60),
    admin1_code character varying(20),
    admin2_code character varying(80),
    admin3_code character varying(20),
    admin4_code character varying(20),
    population bigint,
    elevation integer,
    gtopo30 integer,
    timezone character varying(40),
    moddate date,
    search_vector public.citext,
    first_level_division_id text,
    second_level_division_id text
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: second_level_divisions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.second_level_divisions (
    id character varying NOT NULL,
    name character varying,
    ascii_name character varying,
    geoname_id integer
);


--
-- Name: api_clients id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.api_clients ALTER COLUMN id SET DEFAULT nextval('public.api_clients_id_seq'::regclass);


--
-- Name: api_clients api_clients_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.api_clients
    ADD CONSTRAINT api_clients_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: first_level_divisions first_level_divisions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.first_level_divisions
    ADD CONSTRAINT first_level_divisions_pkey PRIMARY KEY (id);


--
-- Name: geonames geonames_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.geonames
    ADD CONSTRAINT geonames_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: second_level_divisions second_level_divisions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.second_level_divisions
    ADD CONSTRAINT second_level_divisions_pkey PRIMARY KEY (id);


--
-- Name: index_geonames_on_ascii_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_geonames_on_ascii_name ON public.geonames USING btree (ascii_name);


--
-- Name: index_geonames_on_first_level_division_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_geonames_on_first_level_division_id ON public.geonames USING btree (first_level_division_id);


--
-- Name: index_geonames_on_second_level_division_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_geonames_on_second_level_division_id ON public.geonames USING btree (second_level_division_id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20200418163328');


