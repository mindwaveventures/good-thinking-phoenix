--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.1
-- Dumped by pg_dump version 9.6.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: likes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE likes (
    id integer NOT NULL,
    user_hash character varying(255),
    article_id integer,
    like_value integer
);


ALTER TABLE likes OWNER TO postgres;

--
-- Name: likes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE likes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE likes_id_seq OWNER TO postgres;

--
-- Name: likes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE likes_id_seq OWNED BY likes.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp without time zone
);


ALTER TABLE schema_migrations OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE users (
    id integer NOT NULL,
    username character varying(255),
    password_hash character varying(255)
);


ALTER TABLE users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: likes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY likes ALTER COLUMN id SET DEFAULT nextval('likes_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Data for Name: likes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY likes (id, user_hash, article_id, like_value) FROM stdin;
1	SFMyNTY.g3QAAAACbQAAAAtfY3NyZl90b2tlbm0AAAAYVldEd1ZQWmxyK0dtTFlycWhXRW1hQT09bQAAAAd1c2VyX2lkYQM.9Qu09Z3qunPDHA5BnvTmnU2uc1MCBBbL7wYZk62K8kE	9	-1
2	SFMyNTY.g3QAAAACbQAAAAtfY3NyZl90b2tlbm0AAAAYVldEd1ZQWmxyK0dtTFlycWhXRW1hQT09bQAAAAd1c2VyX2lkYQM.9Qu09Z3qunPDHA5BnvTmnU2uc1MCBBbL7wYZk62K8kE	6	1
3	SFMyNTY.g3QAAAACbQAAAAtfY3NyZl90b2tlbm0AAAAYVldEd1ZQWmxyK0dtTFlycWhXRW1hQT09bQAAAAd1c2VyX2lkYQM.9Qu09Z3qunPDHA5BnvTmnU2uc1MCBBbL7wYZk62K8kE	10	1
5	SFMyNTY.g3QAAAACbQAAAAtfY3NyZl90b2tlbm0AAAAYVldEd1ZQWmxyK0dtTFlycWhXRW1hQT09bQAAAAd1c2VyX2lkYQM.9Qu09Z3qunPDHA5BnvTmnU2uc1MCBBbL7wYZk62K8kE	7	1
6	SFMyNTY.g3QAAAACbQAAAAtfY3NyZl90b2tlbm0AAAAYVldEd1ZQWmxyK0dtTFlycWhXRW1hQT09bQAAAAd1c2VyX2lkYQM.9Qu09Z3qunPDHA5BnvTmnU2uc1MCBBbL7wYZk62K8kE	8	-1
10	SFMyNTY.g3QAAAACbQAAAAtfY3NyZl90b2tlbm0AAAAYZW5yYzF3akFRbG5yR1ZmaXpDSXAwdz09bQAAAAd1c2VyX2lkYQM.OrvdrqD0uzk-2DVhYqGM1g5U5VQMI5Gd8b6BzVs7A4o	8	-1
9	SFMyNTY.g3QAAAACbQAAAAtfY3NyZl90b2tlbm0AAAAYZW5yYzF3akFRbG5yR1ZmaXpDSXAwdz09bQAAAAd1c2VyX2lkYQM.OrvdrqD0uzk-2DVhYqGM1g5U5VQMI5Gd8b6BzVs7A4o	7	-1
11	SFMyNTY.g3QAAAACbQAAAAtfY3NyZl90b2tlbm0AAAAYZW5yYzF3akFRbG5yR1ZmaXpDSXAwdz09bQAAAAd1c2VyX2lkYQM.OrvdrqD0uzk-2DVhYqGM1g5U5VQMI5Gd8b6BzVs7A4o	10	1
16	NiyJ_fS1QX0Wb9Xi8jrwIgz01iXvTRGsyA2LU7-MpMFC1gEg8ChjunRFYrlzMhsU_jpXX2jCFkdDZ6Kz9KhgEpeBa5WZ4HxG7DuaB_jHerU=	7	1
12	SFMyNTY.g3QAAAACbQAAAAtfY3NyZl90b2tlbm0AAAAYZW5yYzF3akFRbG5yR1ZmaXpDSXAwdz09bQAAAAd1c2VyX2lkYQM.OrvdrqD0uzk-2DVhYqGM1g5U5VQMI5Gd8b6BzVs7A4o	6	-1
7	SFMyNTY.g3QAAAACbQAAAAtfY3NyZl90b2tlbm0AAAAYZW5yYzF3akFRbG5yR1ZmaXpDSXAwdz09bQAAAAd1c2VyX2lkYQM.OrvdrqD0uzk-2DVhYqGM1g5U5VQMI5Gd8b6BzVs7A4o	9	1
19	NiyJ_fS1QX0Wb9Xi8jrwIgz01iXvTRGsyA2LU7-MpMFC1gEg8ChjunRFYrlzMhsU_jpXX2jCFkdDZ6Kz9KhgEpeBa5WZ4HxG7DuaB_jHerU=	8	1
13	SFMyNTY.g3QAAAACbQAAAAtfY3NyZl90b2tlbm0AAAAYZW5yYzF3akFRbG5yR1ZmaXpDSXAwdz09bQAAAAd1c2VyX2lkYQM.OrvdrqD0uzk-2DVhYqGM1g5U5VQMI5Gd8b6BzVs7A4o	5	-1
14	SFMyNTY.g3QAAAABbQAAAAtfY3NyZl90b2tlbm0AAAAYRUVhOU4vWnRSdWM5U3liaGRzNXJaUT09.RxWWUuA7dRu6AdC2JKp1MP9ydS2LrUqxsgzsPZpkgzo	9	1
20	NiyJ_fS1QX0Wb9Xi8jrwIgz01iXvTRGsyA2LU7-MpMFC1gEg8ChjunRFYrlzMhsU_jpXX2jCFkdDZ6Kz9KhgEpeBa5WZ4HxG7DuaB_jHerU=	10	-1
18	NiyJ_fS1QX0Wb9Xi8jrwIgz01iXvTRGsyA2LU7-MpMFC1gEg8ChjunRFYrlzMhsU_jpXX2jCFkdDZ6Kz9KhgEpeBa5WZ4HxG7DuaB_jHerU=	5	-1
17	NiyJ_fS1QX0Wb9Xi8jrwIgz01iXvTRGsyA2LU7-MpMFC1gEg8ChjunRFYrlzMhsU_jpXX2jCFkdDZ6Kz9KhgEpeBa5WZ4HxG7DuaB_jHerU=	6	-1
15	NiyJ_fS1QX0Wb9Xi8jrwIgz01iXvTRGsyA2LU7-MpMFC1gEg8ChjunRFYrlzMhsU_jpXX2jCFkdDZ6Kz9KhgEpeBa5WZ4HxG7DuaB_jHerU=	9	-1
\.


--
-- Name: likes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('likes_id_seq', 20, true);


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY schema_migrations (version, inserted_at) FROM stdin;
20170503151116	2017-05-03 15:13:34.716525
20170509093107	2017-05-09 15:22:13.499494
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY users (id, username, password_hash) FROM stdin;
2	admin	$2b$12$nCz60LyKSZtEnsg4RsLknOKp4Nbsyao8zyaQth/2yM.746Npx.ZKS
3	ldmw	$2b$12$SVbyqbfFCK05XXz7k0iPCeStMm9P/8ReM4EZsJOeZWDJ3.h0AzNbO
\.


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('users_id_seq', 3, true);


--
-- Name: likes likes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY likes
    ADD CONSTRAINT likes_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- PostgreSQL database dump complete
--

