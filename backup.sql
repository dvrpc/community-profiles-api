--
-- PostgreSQL database dump
--

-- Dumped from database version 14.23 (Ubuntu 14.23-0ubuntu0.22.04.1)
-- Dumped by pg_dump version 17.2 (Ubuntu 17.2-1.pgdg22.04+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

-- *not* creating schema, since initdb creates it


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: category; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.category (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    label character varying(255),
    sort_weight integer DEFAULT 0
);


--
-- Name: category_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.category_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: category_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.category_id_seq OWNED BY public.category.id;


--
-- Name: content; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.content (
    geo_level text,
    file text,
    create_date timestamp without time zone,
    id integer NOT NULL,
    topic_id integer,
    category_id integer,
    is_visible boolean DEFAULT true,
    last_edited_by character varying(255),
    catalog_link text,
    census_link text,
    other_link text
);


--
-- Name: content_history; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.content_history (
    geo_level text,
    file text,
    create_date timestamp without time zone,
    topic_id integer,
    category_id integer,
    is_visible boolean,
    parent_id integer,
    id integer NOT NULL,
    last_edited_by character varying(255)
);


--
-- Name: content_history_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.content_history ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.content_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: content_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.content_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: content_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.content_id_seq OWNED BY public.content.id;


--
-- Name: content_link; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.content_link (
    content_id integer NOT NULL,
    link_id integer NOT NULL
);


--
-- Name: content_product; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.content_product (
    content_id integer NOT NULL,
    product_id character varying(255) NOT NULL
);


--
-- Name: content_source; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.content_source (
    content_id integer NOT NULL,
    source_id integer NOT NULL
);


--
-- Name: county; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.county (
    geoid text NOT NULL,
    co_name text,
    buffer_bbox text,
    state text,
    county text
);


--
-- Name: data; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.data (
    id integer NOT NULL,
    variable_id integer NOT NULL,
    geoid integer,
    value real NOT NULL,
    margin_of_error real
);


--
-- Name: data_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.data_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: data_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.data_id_seq OWNED BY public.data.id;


--
-- Name: geo_variable; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.geo_variable (
    id integer NOT NULL,
    variable_id integer,
    geo_level text NOT NULL,
    CONSTRAINT geo_variable_geo_level_check CHECK ((geo_level = ANY (ARRAY['municipality'::text, 'county'::text, 'region'::text])))
);


--
-- Name: geo_variable_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.geo_variable_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: geo_variable_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.geo_variable_id_seq OWNED BY public.geo_variable.id;


--
-- Name: geography; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.geography (
    id integer NOT NULL,
    name text NOT NULL,
    county_id integer,
    state text,
    buffer_bbox text NOT NULL,
    CONSTRAINT geography_state_check CHECK ((state = ANY (ARRAY['PA'::text, 'NJ'::text])))
);


--
-- Name: geography_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.geography_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: geography_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.geography_id_seq OWNED BY public.geography.id;


--
-- Name: link; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.link (
    id integer NOT NULL,
    link character varying(255) NOT NULL,
    type character varying(255) NOT NULL
);


--
-- Name: links_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.links_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: links_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.links_id_seq OWNED BY public.link.id;


--
-- Name: municipality; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.municipality (
    geoid text NOT NULL,
    buffer_bbox text,
    mun_name text,
    county text,
    state text
);


--
-- Name: source; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.source (
    id integer NOT NULL,
    agency character varying(255),
    year_from numeric,
    year_to numeric NOT NULL,
    citation text,
    dataset character varying(255)
);


--
-- Name: source_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.source_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: source_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.source_id_seq OWNED BY public.source.id;


--
-- Name: sql; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sql (
    id integer NOT NULL,
    name text NOT NULL,
    data_source character varying(4) NOT NULL,
    geo_level character varying(12) NOT NULL,
    body text NOT NULL,
    CONSTRAINT sql_data_source_check CHECK (((data_source)::text = ANY (ARRAY[('ckan'::character varying)::text, ('gis'::character varying)::text]))),
    CONSTRAINT sql_geo_level_check CHECK (((geo_level)::text = ANY (ARRAY[('region'::character varying)::text, ('county'::character varying)::text, ('municipality'::character varying)::text])))
);


--
-- Name: sql_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sql_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sql_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sql_id_seq OWNED BY public.sql.id;


--
-- Name: subcategory; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.subcategory (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    category_id integer NOT NULL,
    label character varying(255),
    sort_weight integer DEFAULT 0
);


--
-- Name: subcategory_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.subcategory_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: subcategory_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.subcategory_id_seq OWNED BY public.subcategory.id;


--
-- Name: topic; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.topic (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    subcategory_id integer NOT NULL,
    label character varying(255),
    sort_weight integer DEFAULT 0
);


--
-- Name: topic_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.topic_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: topic_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.topic_id_seq OWNED BY public.topic.id;


--
-- Name: variable; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.variable (
    id integer NOT NULL,
    name text NOT NULL,
    data_source text,
    acs_variable text,
    data_year integer,
    description text,
    concept text,
    last_updated date,
    aggregateable boolean
);


--
-- Name: variables_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.variable ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.variables_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: viz_history; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.viz_history (
    geo_level text,
    file text,
    create_date timestamp without time zone,
    id integer NOT NULL,
    parent_id integer,
    topic_id integer,
    last_edited_by character varying(255)
);


--
-- Name: visualizations_history_id_column_name_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.viz_history ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.visualizations_history_id_column_name_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: viz; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.viz (
    geo_level text,
    file text,
    create_date timestamp without time zone,
    topic_id integer,
    id integer,
    last_edited_by character varying(255)
);


--
-- Name: viz_source; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.viz_source (
    viz_id integer,
    source_id integer
);


--
-- Name: category id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.category ALTER COLUMN id SET DEFAULT nextval('public.category_id_seq'::regclass);


--
-- Name: content id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.content ALTER COLUMN id SET DEFAULT nextval('public.content_id_seq'::regclass);


--
-- Name: data id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.data ALTER COLUMN id SET DEFAULT nextval('public.data_id_seq'::regclass);


--
-- Name: geo_variable id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.geo_variable ALTER COLUMN id SET DEFAULT nextval('public.geo_variable_id_seq'::regclass);


--
-- Name: geography id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.geography ALTER COLUMN id SET DEFAULT nextval('public.geography_id_seq'::regclass);


--
-- Name: link id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.link ALTER COLUMN id SET DEFAULT nextval('public.links_id_seq'::regclass);


--
-- Name: source id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.source ALTER COLUMN id SET DEFAULT nextval('public.source_id_seq'::regclass);


--
-- Name: sql id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sql ALTER COLUMN id SET DEFAULT nextval('public.sql_id_seq'::regclass);


--
-- Name: subcategory id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subcategory ALTER COLUMN id SET DEFAULT nextval('public.subcategory_id_seq'::regclass);


--
-- Name: topic id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.topic ALTER COLUMN id SET DEFAULT nextval('public.topic_id_seq'::regclass);


--
-- Data for Name: category; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.category (id, name, label, sort_weight) FROM stdin;
5	roadways	Roadways	0
3	demographics-housing	Demographics Housing	7
1	economy	Economy	6
2	active-transportation	Active Transportation	5
4	safety-health	Safety Health	4
8	freight	Freight	3
7	environment	Environment	2
6	transit	Transit	1
\.


--
-- Data for Name: content; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.content (geo_level, file, create_date, id, topic_id, category_id, is_visible, last_edited_by, catalog_link, census_link, other_link) FROM stdin;
municipality	{% from 'display_variable.jinja' import display_variable %}\n\nThe Circuit is Greater Philadelphia’s multi–use trail network connecting people to jobs, communities, parks, and waterways. Governments, non-profits, and foundations have collaborated to complete over 390 miles of the envisioned 800-mile regional network.\n\n- **Existing** -- These trails are open for use so get out there and explore them.\n- **In Progress** -- These trails are currently being designed or built.\n- **Pipeline** -- DVRPC, local governments, and non-profit organizations are actively working to move these trails forward by conducting studies, acquiring rights-of-way, engaging local communities, and laying the groundwork to obtain funding for future design and construction.\n- **Planned** -- These trails are documented in local, county or regional plans. They represent excellent opportunities for regional-scale, multi-use trails. Studies or plans may have been prepared for these trails, but a sponsor is not actively working to move them forward.\n	2025-10-20 15:28:41.091245	82	5	\N	t	\N	\N	\N	\N
region	{% from 'display_variable.jinja' import display_variable %}\n\nThe Circuit is Greater Philadelphia’s multi–use trail network connecting people to jobs, communities, parks, and waterways. Governments, non-profits, and foundations have collaborated to complete over 390 miles of the envisioned 800-mile regional network.\n\n- **Existing** -- These trails are open for use so get out there and explore them.\n- **In Progress** -- These trails are currently being designed or built.\n- **Pipeline** -- DVRPC, local governments, and non-profit organizations are actively working to move these trails forward by conducting studies, acquiring rights-of-way, engaging local communities, and laying the groundwork to obtain funding for future design and construction.\n- **Planned** -- These trails are documented in local, county or regional plans. They represent excellent opportunities for regional-scale, multi-use trails. Studies or plans may have been prepared for these trails, but a sponsor is not actively working to move them forward.\n	2025-10-20 15:28:41.091245	16	5	\N	t	\N	\N	\N	\N
municipality	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n\n<div style="display: flex; flex-wrap: wrap; gap: 3rem;">\n{{display_variable(male_pop, 'Male Population', moe=male_pop_moe)}}\n{{display_variable(female_pop, 'Female Population', moe=female_pop_moe)}}\n</div>\n	2025-10-20 15:28:41.091245	67	12	\N	t	\N	\N	\N	\N
municipality	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. hello 12\n\n{{display_variable(total_pop, 'Population')}}\n	2025-11-04 11:16:02.468487	70	24	\N	t	\N	\N	\N	\N
municipality	{% from 'display_variable.jinja' import display_variable %}\n\nhello Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n\n{{display_variable(popabs50, 'Projected Population Growth: 2015-2050', county + ' County')}}\n\nVenenatis cras sed felis eget velit. Consectetur libero id faucibus nisl tincidunt. Gravida in fermentum et sollicitudin ac orci phasellus egestas tellus. Volutpat consequat mauris nunc congue nisi vitae. Id aliquet risus feugiat in ante metus dictum at tempor. Sed blandit libero volutpat sed cras. Sed odio morbi quis commodo odio aenean sed adipiscing. Velit euismod in pellentesque massa placerat. Mi bibendum neque egestas congue quisque egestas diam in arcu.\n	2025-10-20 15:28:41.091245	69	25	\N	t	\N	\N	\N	\N
region	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. abc region\n	2025-11-25 11:58:39.719926	11	10	\N	t	\N	\N	\N	\N
municipality	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Praesent elementum facilisis leo vel fringilla est ullamcorper eget. At imperdiet dui accumsan sit amet nulla facilities morbi tempus. Praesent elementum facilisis leo vel fringilla. 123\n\n<div style="display: flex; flex-wrap: wrap; gap: 3rem;">\n{{display_variable(median_age, 'Median Age', moe=median_age_moe)}}\n{{display_variable(under_18_pop, 'Under 18', moe=under_18_pop_moe)}}\n</div>\n	2025-12-02 09:50:28.26238	66	1	\N	t	\N	\N	\N	\N
municipality	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. abc\n	2025-12-02 11:02:31.827238	68	18	\N	t	\N	\N	\N	\N
county	{% from 'display_variable.jinja' import display_variable %}\n\nhello Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. 123456\n \n{{display_variable(popabs50, 'Projected Population Growth: 2015-2050', county + ' County')}}\n\nVenenatis cras sed felis eget velit. Consectetur libero id faucibus nisl tincidunt. Gravida in fermentum et sollicitudin ac orci phasellus egestas tellus. Volutpat consequat mauris nunc congue nisi vitae. Id aliquet risus feugiat in ante metus dictum at tempor. Sed blandit libero volutpat sed cras. Sed odio morbi quis commodo odio aenean sed adipiscing. Velit euismod in pellentesque massa placerat. Mi bibendum neque egestas congue quisque egestas diam in arcu. 4\n	2025-12-01 16:28:57.198896	36	25	\N	t	\N	\N	\N	\N
county	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. 12345677\n	2025-12-02 12:45:33.179071	38	33	\N	t	\N	\N	\N	\N
municipality	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n	2025-10-20 15:28:41.091245	71	33	\N	t	\N	\N	\N	\N
region	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n	2025-10-20 15:28:41.091245	2	18	\N	t	\N	\N	\N	\N
region	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. 1234567\n\n{{display_variable(total_pop, 'Population')}}\n	2025-11-04 11:09:19.048915	4	24	\N	t	\N	\N	\N	\N
region	{% from 'display_variable.jinja' import display_variable %}\n\nhello Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n\n{{display_variable(popabs50, 'Projected Population Growth: 2015-2050')}}\n\nVenenatis cras sed felis eget velit. Consectetur libero id faucibus nisl tincidunt. Gravida in fermentum et sollicitudin ac orci phasellus egestas tellus. Volutpat consequat mauris nunc congue nisi vitae. Id aliquet risus feugiat in ante metus dictum at tempor. Sed blandit libero volutpat sed cras. Sed odio morbi quis commodo odio aenean sed adipiscing. Velit euismod in pellentesque massa placerat. Mi bibendum neque egestas congue quisque egestas diam in arcu.\n	2025-10-20 15:28:41.091245	3	25	\N	t	\N	\N	\N	\N
county	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. 123\n	2025-11-12 12:04:31.533394	39	13	\N	t	\N	\N	\N	\N
county	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n	2025-10-20 15:28:41.091245	41	28	\N	t	\N	\N	\N	\N
county	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. abc\n	2025-11-03 14:30:26.672563	42	34	\N	t	\N	\N	\N	\N
municipality	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n	2025-10-20 15:28:41.091245	72	13	\N	t	\N	\N	\N	\N
municipality	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n	2025-10-20 15:28:41.091245	73	14	\N	t	\N	\N	\N	\N
municipality	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n	2025-10-20 15:28:41.091245	74	28	\N	t	\N	\N	\N	\N
municipality	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n	2025-10-20 15:28:41.091245	75	34	\N	t	\N	\N	\N	\N
region	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n	2025-10-20 15:28:41.091245	6	13	\N	t	\N	\N	\N	\N
region	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n	2025-10-20 15:28:41.091245	7	14	\N	t	\N	\N	\N	\N
region	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n	2025-10-20 15:28:41.091245	8	28	\N	t	\N	\N	\N	\N
region	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n	2025-10-20 15:28:41.091245	9	34	\N	t	\N	\N	\N	\N
county	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n\n1234567\n	2025-11-12 11:50:44.220696	43	11	\N	t	\N	\N	\N	\N
municipality	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n	2025-10-20 15:28:41.091245	76	11	\N	t	\N	\N	\N	\N
region	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n	2025-10-20 15:28:41.091245	10	11	\N	t	\N	\N	\N	\N
municipality	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n	2025-10-20 15:28:41.091245	78	15	\N	t	\N	\N	\N	\N
municipality	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n	2025-10-20 15:28:41.091245	79	26	\N	t	\N	\N	\N	\N
region	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n	2025-10-20 15:28:41.091245	12	15	\N	t	\N	\N	\N	\N
region	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n	2025-10-20 15:28:41.091245	13	26	\N	t	\N	\N	\N	\N
county	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. 123\n	2025-11-19 10:05:24.009846	46	26	\N	t	\N	\N	\N	\N
county	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. 123\n	2025-11-12 11:45:27.786063	47	6	\N	t	\N	\N	\N	\N
county	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n	2025-10-20 15:28:41.091245	48	8	\N	t	\N	\N	\N	\N
municipality	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. muni\n	2025-11-25 11:58:26.834227	77	10	\N	t	\N	\N	\N	\N
municipality	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n	2025-10-20 15:28:41.091245	80	6	\N	t	\N	\N	\N	\N
municipality	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n	2025-10-20 15:28:41.091245	81	8	\N	t	\N	\N	\N	\N
region	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n	2025-10-20 15:28:41.091245	14	6	\N	t	\N	\N	\N	\N
region	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n	2025-10-20 15:28:41.091245	15	8	\N	t	\N	\N	\N	\N
county	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n	2025-10-20 15:28:41.091245	58	20	\N	t	\N	\N	\N	\N
municipality	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n	2025-10-20 15:28:41.091245	92	20	\N	t	\N	\N	\N	\N
region	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n	2025-10-20 15:28:41.091245	26	20	\N	t	\N	\N	\N	\N
region	{% from 'display_variable.jinja' import display_variable %}	2025-12-01 15:36:09.571631	161	\N	\N	t	\N	\N	\N	\N
county	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n	2025-10-20 15:28:41.091245	59	17	\N	t	\N	\N	\N	\N
municipality	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n	2025-10-20 15:28:41.091245	93	17	\N	t	\N	\N	\N	\N
region	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n	2025-10-20 15:28:41.091245	27	17	\N	t	\N	\N	\N	\N
county	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n	2025-10-20 15:28:41.091245	57	16	\N	t	\N	\N	\N	\N
municipality	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n	2025-10-20 15:28:41.091245	91	16	\N	t	\N	\N	\N	\N
municipality	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n	2025-10-20 15:28:41.091245	85	7	\N	t	\N	\N	\N	\N
region	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n	2025-10-20 15:28:41.091245	25	16	\N	t	\N	\N	\N	\N
county	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n	2025-10-20 15:28:41.091245	63	3	\N	t	\N	\N	\N	\N
county	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n	2025-10-20 15:28:41.091245	64	22	\N	t	\N	\N	\N	\N
municipality	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n	2025-10-20 15:28:41.091245	97	3	\N	t	\N	\N	\N	\N
municipality	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n	2025-10-20 15:28:41.091245	98	22	\N	t	\N	\N	\N	\N
region	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n	2025-10-20 15:28:41.091245	31	3	\N	t	\N	\N	\N	\N
region	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n	2025-10-20 15:28:41.091245	32	22	\N	t	\N	\N	\N	\N
county	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n	2025-10-20 15:28:41.091245	65	32	\N	t	\N	\N	\N	\N
municipality	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n	2025-10-20 15:28:41.091245	99	32	\N	t	\N	\N	\N	\N
region	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n	2025-10-20 15:28:41.091245	33	32	\N	t	\N	\N	\N	\N
county	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n	2025-10-20 15:28:41.091245	52	9	\N	t	\N	\N	\N	\N
county	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n	2025-10-20 15:28:41.091245	53	29	\N	t	\N	\N	\N	\N
county	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n	2025-10-20 15:28:41.091245	54	30	\N	t	\N	\N	\N	\N
municipality	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n	2025-10-20 15:28:41.091245	86	9	\N	t	\N	\N	\N	\N
municipality	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n	2025-10-20 15:28:41.091245	87	29	\N	t	\N	\N	\N	\N
county	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n	2025-10-20 15:28:41.091245	62	31	\N	t	\N	\N	\N	\N
region	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n	2025-10-20 15:28:41.091245	22	30	\N	t	\N	\N	\N	\N
municipality	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n	2025-10-20 15:28:41.091245	96	31	\N	t	\N	\N	\N	\N
region	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n	2025-10-20 15:28:41.091245	30	31	\N	t	\N	\N	\N	\N
county	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n	2025-10-20 15:28:41.091245	60	4	\N	t	\N	\N	\N	\N
county	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n	2025-10-20 15:28:41.091245	61	27	\N	t	\N	\N	\N	\N
municipality	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n	2025-10-20 15:28:41.091245	94	4	\N	t	\N	\N	\N	\N
municipality	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n	2025-10-20 15:28:41.091245	95	27	\N	t	\N	\N	\N	\N
region	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n	2025-10-20 15:28:41.091245	28	4	\N	t	\N	\N	\N	\N
region	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n	2025-10-20 15:28:41.091245	29	27	\N	t	\N	\N	\N	\N
county	{% from 'display_variable.jinja' import display_variable %}\n\nThe Circuit is Greater Philadelphia’s multi–use trail network connecting people to jobs, communities, parks, and waterways. Governments, non-profits, and foundations have collaborated to complete over 390 miles of the envisioned 800-mile regional network.\n\n- **Existing** -- These trails are open for use so get out there and explore them.\n- **In Progress** -- These trails are currently being designed or built.\n- **Pipeline** -- DVRPC, local governments, and non-profit organizations are actively working to move these trails forward by conducting studies, acquiring rights-of-way, engaging local communities, and laying the groundwork to obtain funding for future design and construction.\n- **Planned** -- These trails are documented in local, county or regional plans. They represent excellent opportunities for regional-scale, multi-use trails. Studies or plans may have been prepared for these trails, but a sponsor is not actively working to move them forward. 12345\n	2025-11-17 10:47:42.762916	100	5	\N	t	\N	\N	\N	\N
county	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. 2345	2025-11-17 10:45:38.356564	51	7	\N	t	\N	\N	\N	\N
region	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n	2025-10-20 15:28:41.091245	19	7	\N	t	\N	\N	\N	\N
county	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n	2025-10-20 15:28:41.091245	49	19	\N	t	\N	\N	\N	\N
municipality	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n	2025-10-20 15:28:41.091245	83	19	\N	t	\N	\N	\N	\N
region	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n	2025-10-20 15:28:41.091245	17	19	\N	t	\N	\N	\N	\N
region	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\ntest	2025-10-27 16:23:26.168283	101	1	\N	t	\N	\N	\N	\N
county	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n	2025-10-20 15:28:41.091245	50	23	\N	t	\N	\N	\N	\N
municipality	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n	2025-10-20 15:28:41.091245	84	23	\N	t	\N	\N	\N	\N
region	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n	2025-10-20 15:28:41.091245	18	23	\N	t	\N	\N	\N	\N
region	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n	2025-10-20 15:28:41.091245	5	33	\N	t	\N	\N	\N	\N
municipality	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n	2025-10-20 15:28:41.091245	88	30	\N	t	\N	\N	\N	\N
region	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n	2025-10-20 15:28:41.091245	20	9	\N	t	\N	\N	\N	\N
region	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n	2025-10-20 15:28:41.091245	21	29	\N	t	\N	\N	\N	\N
county	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n	2025-10-20 15:28:41.091245	55	2	\N	t	\N	\N	\N	\N
county	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n	2025-10-20 15:28:41.091245	56	21	\N	t	\N	\N	\N	\N
municipality	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n	2025-10-20 15:28:41.091245	89	2	\N	t	\N	\N	\N	\N
municipality	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n	2025-10-20 15:28:41.091245	90	21	\N	t	\N	\N	\N	\N
region	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n	2025-10-20 15:28:41.091245	23	2	\N	t	\N	\N	\N	\N
region	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n	2025-10-20 15:28:41.091245	24	21	\N	t	\N	\N	\N	\N
county	{% from 'display_variable.jinja' import display_variable %}	2025-12-01 15:36:09.585237	162	\N	\N	t	\N	\N	\N	\N
municipality	{% from 'display_variable.jinja' import display_variable %}	2025-12-01 15:36:09.59456	163	\N	\N	t	\N	\N	\N	\N
region	{% from 'display_variable.jinja' import display_variable %}	2025-12-01 15:58:14.738207	164	\N	\N	t	\N	\N	\N	\N
region	{% from 'display_variable.jinja' import display_variable %}	2025-12-01 16:09:54.568826	168	\N	\N	t	\N	\N	\N	\N
municipality	{% from 'display_variable.jinja' import display_variable %}	2025-12-01 16:09:54.589094	170	\N	\N	t	\N	\N	\N	\N
county	{% from 'display_variable.jinja' import display_variable %}	2025-12-01 16:09:54.57912	169	\N	\N	t	\N	\N	\N	\N
county	Lorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus duis convallis. Tempus leo eu aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas. Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos.\n\nLorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus duis convallis. Tempus leo eu aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas. Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos.	2025-11-25 10:57:59.497087	140	\N	2	t	\N	\N	\N	\N
region	Lorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus duis convallis. Tempus leo eu aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas. Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos.\n\nLorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus duis convallis. Tempus leo eu aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas. Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos.	2025-11-25 10:57:59.497087	141	\N	2	t	\N	\N	\N	\N
region	region ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus duis convallis. Tempus leo eu aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas. Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos.\n\nLorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus duis convallis. Tempus leo eu aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas. Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos.\n\n	2025-11-25 11:59:05.654913	138	\N	1	t	\N	\N	\N	\N
municipality	muni ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus duis convallis. Tempus leo eu aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas. Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos.\n\nLorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus duis convallis. Tempus leo eu aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas. Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos.	2025-11-25 12:01:21.625969	139	\N	1	t	\N	\N	\N	\N
municipality	Lorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus duis convallis. Tempus leo eu aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas. Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos.\n\nLorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus duis convallis. Tempus leo eu aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas. Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos.	2025-11-25 10:57:59.497087	142	\N	2	t	\N	\N	\N	\N
region	Lorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus duis convallis. Tempus leo eu aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas. Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos.\n\nLorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus duis convallis. Tempus leo eu aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas. Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos.	2025-11-25 10:57:59.497087	144	\N	3	t	\N	\N	\N	\N
municipality	Lorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus duis convallis. Tempus leo eu aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas. Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos.\n\nLorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus duis convallis. Tempus leo eu aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas. Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos.	2025-11-25 10:57:59.497087	145	\N	3	t	\N	\N	\N	\N
region	{% from 'display_variable.jinja' import display_variable %}	2025-12-01 15:59:47.518121	165	\N	\N	t	\N	\N	\N	\N
county	{% from 'display_variable.jinja' import display_variable %}	2025-12-01 15:59:47.5285	166	\N	\N	t	\N	\N	\N	\N
municipality	{% from 'display_variable.jinja' import display_variable %}	2025-12-01 15:59:47.5382	167	\N	\N	t	\N	\N	\N	\N
county	{% from 'display_variable.jinja' import display_variable %}\n\nhelli	2025-12-01 16:23:03.995216	172	\N	\N	t	\N	\N	\N	\N
region	{% from 'display_variable.jinja' import display_variable %}	2025-12-01 16:22:53.414121	171	\N	\N	t	\N	\N	\N	\N
municipality	{% from 'display_variable.jinja' import display_variable %}	2025-12-01 16:22:53.437687	173	\N	\N	t	\N	\N	\N	\N
county	Lorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus duis convallis. Tempus leo eu aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas. Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos.\n\nLorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus duis convallis. Tempus leo eu aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas. Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos.	2025-11-25 10:57:59.497087	146	\N	4	t	\N	\N	\N	\N
region	Lorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus duis convallis. Tempus leo eu aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas. Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos.\n\nLorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus duis convallis. Tempus leo eu aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas. Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos.	2025-11-25 10:57:59.497087	147	\N	4	t	\N	\N	\N	\N
municipality	Lorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus duis convallis. Tempus leo eu aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas. Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos.\n\nLorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus duis convallis. Tempus leo eu aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas. Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos.	2025-11-25 10:57:59.497087	148	\N	4	t	\N	\N	\N	\N
county	Lorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus duis convallis. Tempus leo eu aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas. Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos.\n\nLorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus duis convallis. Tempus leo eu aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas. Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos.	2025-11-25 10:57:59.497087	149	\N	5	t	\N	\N	\N	\N
region	Lorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus duis convallis. Tempus leo eu aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas. Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos.\n\nLorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus duis convallis. Tempus leo eu aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas. Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos.	2025-11-25 10:57:59.497087	150	\N	5	t	\N	\N	\N	\N
municipality	Lorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus duis convallis. Tempus leo eu aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas. Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos.\n\nLorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus duis convallis. Tempus leo eu aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas. Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos.	2025-11-25 10:57:59.497087	151	\N	5	t	\N	\N	\N	\N
county	Lorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus duis convallis. Tempus leo eu aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas. Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos.\n\nLorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus duis convallis. Tempus leo eu aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas. Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos.	2025-11-25 10:57:59.497087	152	\N	6	t	\N	\N	\N	\N
region	Lorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus duis convallis. Tempus leo eu aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas. Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos.\n\nLorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus duis convallis. Tempus leo eu aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas. Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos.	2025-11-25 10:57:59.497087	153	\N	6	t	\N	\N	\N	\N
region	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. abcd\n\n<div style="display: flex; flex-wrap: wrap; gap: 3rem;">\n{{display_variable(male_pop, 'Male Population', moe=male_pop_moe)}}\n{{display_variable(female_pop, 'Female Population', moe=female_pop_moe)}}\n</div>\n	2025-12-02 10:52:11.510207	1	12	\N	t	\N	\N	\N	\N
municipality	Lorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus duis convallis. Tempus leo eu aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas. Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos.\n\nLorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus duis convallis. Tempus leo eu aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas. Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos.	2025-11-25 10:57:59.497087	154	\N	6	t	\N	\N	\N	\N
county	Lorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus duis convallis. Tempus leo eu aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas. Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos.\n\nLorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus duis convallis. Tempus leo eu aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas. Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos.	2025-11-25 10:57:59.497087	155	\N	7	t	\N	\N	\N	\N
region	Lorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus duis convallis. Tempus leo eu aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas. Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos.\n\nLorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus duis convallis. Tempus leo eu aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas. Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos.	2025-11-25 10:57:59.497087	156	\N	7	t	\N	\N	\N	\N
municipality	Lorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus duis convallis. Tempus leo eu aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas. Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos.\n\nLorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus duis convallis. Tempus leo eu aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas. Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos.	2025-11-25 10:57:59.497087	157	\N	7	t	\N	\N	\N	\N
county	Lorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus duis convallis. Tempus leo eu aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas. Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos.\n\nLorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus duis convallis. Tempus leo eu aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas. Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos.	2025-11-25 10:57:59.497087	158	\N	8	t	\N	\N	\N	\N
region	Lorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus duis convallis. Tempus leo eu aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas. Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos.\n\nLorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus duis convallis. Tempus leo eu aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas. Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos.	2025-11-25 10:57:59.497087	159	\N	8	t	\N	\N	\N	\N
municipality	Lorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus duis convallis. Tempus leo eu aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas. Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos.\n\nLorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus duis convallis. Tempus leo eu aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas. Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos.	2025-11-25 10:57:59.497087	160	\N	8	t	\N	\N	\N	\N
county	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. 123 county\n	2025-11-25 11:47:45.593111	45	15	\N	t	\N	\N	\N	\N
county	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n county	2025-11-25 11:48:28.397472	44	10	\N	t	\N	\N	\N	\N
county	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. \n\n<div style="display: flex; flex-wrap: wrap; gap: 3rem;">\n{{display_variable(male_pop, 'Male Population', moe=male_pop_moe)}}\n{{display_variable(female_pop, 'Female Population', moe=female_pop_moe)}}\n</div> 123\n	2025-11-17 10:54:44.441259	34	12	\N	t	\N	\N	\N	\N
region	{% from 'display_variable.jinja' import display_variable %}	2025-12-02 11:51:21.295494	177	\N	\N	t	\N	\N	\N	\N
county	{% from 'display_variable.jinja' import display_variable %}	2025-12-02 11:51:21.306822	178	\N	\N	t	\N	\N	\N	\N
municipality	{% from 'display_variable.jinja' import display_variable %}	2025-12-02 11:51:21.316488	179	\N	\N	t	\N	\N	\N	\N
region	{% from 'display_variable.jinja' import display_variable %}	2025-12-02 11:42:06.66402	174	\N	\N	t	\N	\N	\N	\N
county	{% from 'display_variable.jinja' import display_variable %}	2025-12-02 11:42:06.676426	175	\N	\N	t	\N	\N	\N	\N
municipality	{% from 'display_variable.jinja' import display_variable %}	2025-12-02 11:42:06.68664	176	\N	\N	t	\N	\N	\N	\N
county	Lorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus duis convallis. Tempus leo eu aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas. Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos.\n\nLorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus duis convallis. Tempus leo eu aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas. Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos. abc	2025-12-10 15:20:58.624234	143	\N	3	t	Colin Kirby	\N	\N	\N
region	{% from 'display_variable.jinja' import display_variable %}	2025-12-03 15:27:20.124375	180	\N	\N	t	\N	\N	\N	\N
county	{% from 'display_variable.jinja' import display_variable %}	2025-12-03 15:27:20.128381	181	\N	\N	t	\N	\N	\N	\N
municipality	{% from 'display_variable.jinja' import display_variable %}	2025-12-03 15:27:20.130042	182	\N	\N	t	\N	\N	\N	\N
county	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Praesent elementum facilisis leo vel fringilla est ullamcorper eget. At imperdiet dui accumsan sit amet nulla facilities morbi tempus. Praesent elementum facilisis leo vel fringilla. 1234\n\n<div style="display: flex; flex-wrap: wrap; gap: 3rem;">\n{{display_variable(median_age, 'Median Age', moe=median_age_moe)}}\n{{display_variable(under_18_pop, 'Under 18', moe=under_18_pop_moe)}}\n{{display_variable(over_65_pop, '65 and Over', moe=over_65_pop_moe)}}\n</div>\n\n1234567	2025-12-10 15:18:12.614678	102	1	\N	t	Colin Kirby	\N	\N	\N
county	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. abc12345\n	2025-12-04 13:32:02.395481	35	18	\N	t	\N	\N	\N	\N
county	county ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus duis convallis. Tempus leo eu aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas. Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos.\n\nLorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus duis convallis. Tempus leo eu aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas. Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos. 1234	2025-12-10 13:28:30.343772	137	\N	1	t	\N	\N	\N	\N
county	{% from 'display_variable.jinja' import display_variable %}\n\nIn data_year, the typical household in Greater Philadelphia would have had to pay approximately [median_home_value / median_regional_hh_income] times their annual income to purchase the median home in county_name. \n\nHouseholds needed to earn approximately [hh_income_for_median_apt] to affordably rent the median cost rental home in [county_name] in [data_year]. In [current_year], [per_rent_burdened] percent of renters in {{county}} were cost burdened, [diff_from_region] than the regional threshold of [regional_per_rent_burdened] percent. \n\n{{county}}’s housing stock is [age_vs_region] compared to the region. [per_pre_1940] percent of the county’s homes were built prior to 1940 while over [per_post_1980] percent has been built after 1980. \n	2026-05-13 15:53:20.328438	40	14	\N	t	Colin Kirby	\N	\N	\N
region	{% from 'display_variable.jinja' import display_variable %}	2026-05-21 10:26:16.034151	183	\N	\N	t	\N	\N	\N	\N
county	{% from 'display_variable.jinja' import display_variable %}	2026-05-21 10:26:16.041328	184	\N	\N	t	\N	\N	\N	\N
municipality	{% from 'display_variable.jinja' import display_variable %}	2026-05-21 10:26:16.043507	185	\N	\N	t	\N	\N	\N	\N
county	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. 123 \n\npopulation\n\n{{test_var}}\n{{display_variable(total_pop, 'Population', county + ' County')}}\n	2026-05-21 10:41:11.496241	37	24	\N	t	Colin Kirby	\N	\N	\N
\.


--
-- Data for Name: content_history; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.content_history (geo_level, file, create_date, topic_id, category_id, is_visible, parent_id, id, last_edited_by) FROM stdin;
county	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. \n\npopulation\n\n{{display_variable(total_pop, 'Population', county + ' County')}}\n	2025-12-10 15:11:10.954648	24	\N	t	37	21	Colin Kirby
county	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Praesent elementum facilisis leo vel fringilla est ullamcorper eget. At imperdiet dui accumsan sit amet nulla facilities morbi tempus. Praesent elementum facilisis leo vel fringilla. 123\n\n<div style="display: flex; flex-wrap: wrap; gap: 3rem;">\n{{display_variable(median_age, 'Median Age', moe=median_age_moe)}}\n{{display_variable(under_18_pop, 'Under 18', moe=under_18_pop_moe)}}\n{{display_variable(over_65_pop, '65 and Over', moe=over_65_pop_moe)}}\n</div>\n\n1234567	2025-12-10 13:59:21.904227	1	\N	t	102	22	\N
county	Lorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus duis convallis. Tempus leo eu aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas. Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos.\n\nLorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus duis convallis. Tempus leo eu aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas. Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos. 	2025-12-03 14:42:40.202878	\N	3	t	143	23	\N
county	Lorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus duis convallis. Tempus leo eu aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas. Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos.\n\nLorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus duis convallis. Tempus leo eu aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas. Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos.  1	2025-12-10 15:20:46.557478	\N	3	t	143	24	Colin Kirby
county	Lorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus duis convallis. Tempus leo eu aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas. Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos.\n\nLorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus duis convallis. Tempus leo eu aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas. Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos.	2025-12-10 15:20:55.094133	\N	3	t	143	25	Colin Kirby
county	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n	2025-10-20 15:28:41.091245	14	\N	t	40	26	\N
county	{% from 'display_variable.jinja' import display_variable %}\n\nIn data_year, the typical household in Greater Philadelphia would have had to pay approximately [median_home_value / median_regional_hh_income] times their annual income to purchase the median home in county_name. \n\nHouseholds needed to earn approximately [hh_income_for_median_apt] to affordably rent the median cost rental home in [county_name] in [data_year]. In [current_year], [per_rent_burdened] percent of renters in [county_name] were cost burdened, [diff_from_region] than the regional threshold of [regional_per_rent_burdened] percent. \n\n{{county}}’s housing stock is [age_vs_region] compared to the region. [per_pre_1940] percent of the county’s homes were built prior to 1940 while over [per_post_1980] percent has been built after 1980. \n	2026-05-13 15:36:40.068343	14	\N	t	40	27	Colin Kirby
county	{% from 'display_variable.jinja' import display_variable %}\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. 123 \n\npopulation\n\n{{display_variable(total_pop, 'Population', county + ' County')}}\n	2025-12-10 15:18:08.232969	24	\N	t	37	28	Colin Kirby
\.


--
-- Data for Name: content_link; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.content_link (content_id, link_id) FROM stdin;
\.


--
-- Data for Name: content_product; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.content_product (content_id, product_id) FROM stdin;
36	24156
36	24131
37	24131
37	23017
37	24109
37	22120
\.


--
-- Data for Name: content_source; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.content_source (content_id, source_id) FROM stdin;
37	5
37	10
\.


--
-- Data for Name: county; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.county (geoid, co_name, buffer_bbox, state, county) FROM stdin;
42017	Bucks	POLYGON((-75.5172386174942 40.019966656385144,-75.52195819955206 40.635408512424895,-74.68232273049465 40.63615113388574,-74.68519528899041 40.020693387223744,-75.5172386174942 40.019966656385144))	Pennsylvania	Bucks
42029	Chester	POLYGON((-76.16986916935087 39.692670891923115,-76.17970862838224 40.2671574994225,-75.3279315229405 40.2727066707756,-75.32519567797509 39.69810890607209,-76.16986916935087 39.692670891923115))	Pennsylvania	Chester
42045	Delaware	POLYGON((-75.61811849642501 39.78752868903448,-75.62074024540864 40.07835951366461,-75.19469101949267 40.07985900985727,-75.19386866783753 39.78901289984785,-75.61811849642501 39.78752868903448))	Pennsylvania	Delaware
42091	Montgomery	POLYGON((-75.7244727035021 39.951581599763706,-75.73000821236766 40.46945925090913,-74.98426667493503 40.47176346401691,-74.98438599040792 39.95384422346794,-75.7244727035021 39.951581599763706))	Pennsylvania	Montgomery
42101	Philadelphia	POLYGON((-75.29733264718094 39.853065358495556,-75.29862804603663 40.15105586523984,-74.9381283423984 40.151424403158565,-74.93839673599271 39.85343004938075,-75.29733264718094 39.853065358495556))	Pennsylvania	Philadelphia
34005	Burlington	POLYGON((-75.10171860536784 39.51051571821398,-75.10276577806611 40.216049347200794,-74.34323529515214 40.2142317457408,-74.34992709673733 39.50874275664577,-75.10171860536784 39.51051571821398))	New Jersey	Burlington
34007	Camden	POLYGON((-75.16340175005875 39.58893254539328,-75.16441481574451 40.01562229638109,-74.70988712645062 40.01537579746854,-74.71167467836511 39.588689727200304,-75.16340175005875 39.58893254539328))	New Jersey	Camden
34015	Gloucester	POLYGON((-75.45135231475463 39.495378768648,-75.45403265505443 39.90561004219216,-74.85256986608508 39.9064051456331,-74.85344023871828 39.49616244653485,-75.45135231475463 39.495378768648))	New Jersey	Gloucester
34021	Mercer	POLYGON((-74.96179492387068 40.12310637197726,-74.96161682329019 40.438766870044525,-74.46089334457224 40.437516240339036,-74.46339469067136 40.121869543447104,-74.96179492387068 40.12310637197726))	New Jersey	Mercer
\.


--
-- Data for Name: data; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.data (id, variable_id, geoid, value, margin_of_error) FROM stdin;
\.


--
-- Data for Name: geo_variable; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.geo_variable (id, variable_id, geo_level) FROM stdin;
40	383	municipality
41	384	municipality
42	385	municipality
43	386	municipality
44	387	municipality
45	388	municipality
46	389	municipality
47	390	municipality
48	391	municipality
49	392	municipality
50	393	municipality
51	394	municipality
52	395	municipality
53	396	municipality
54	411	municipality
55	412	municipality
56	413	municipality
57	414	municipality
58	415	municipality
59	416	municipality
60	417	municipality
61	418	municipality
62	419	municipality
63	420	municipality
64	421	municipality
65	422	municipality
66	423	municipality
67	424	municipality
68	425	municipality
69	426	municipality
70	427	municipality
71	428	municipality
72	381	municipality
73	382	municipality
74	397	municipality
75	398	municipality
76	399	municipality
77	402	municipality
78	403	municipality
79	404	municipality
80	405	municipality
81	406	municipality
82	407	municipality
83	408	municipality
84	409	municipality
85	400	municipality
86	401	municipality
87	410	municipality
88	74	county
89	74	municipality
90	74	region
91	1	county
92	1	municipality
93	1	region
94	11	county
95	11	municipality
96	11	region
97	12	county
98	12	municipality
99	12	region
100	13	county
101	13	municipality
102	13	region
103	14	county
104	14	municipality
105	14	region
106	15	county
107	15	municipality
108	15	region
109	18	county
110	18	municipality
111	18	region
112	50	county
113	50	municipality
114	50	region
115	3	county
116	3	municipality
117	3	region
118	69	county
119	69	municipality
120	69	region
121	78	county
122	78	municipality
123	78	region
124	93	county
125	93	municipality
126	93	region
127	94	county
128	94	municipality
129	94	region
130	199	county
131	199	municipality
132	199	region
133	79	county
134	79	municipality
135	79	region
136	5	county
137	5	municipality
138	5	region
139	200	county
140	200	municipality
141	200	region
142	228	county
143	228	municipality
144	228	region
145	49	county
146	49	municipality
147	49	region
148	85	county
149	85	municipality
150	85	region
151	86	county
152	86	municipality
153	86	region
154	87	county
155	87	municipality
156	87	region
157	88	county
158	88	municipality
159	88	region
160	89	county
161	89	municipality
162	89	region
163	90	county
164	90	municipality
165	90	region
166	201	county
167	201	municipality
168	201	region
169	23	county
170	23	municipality
171	23	region
172	24	county
173	24	municipality
174	24	region
175	25	county
176	25	municipality
177	25	region
178	104	county
179	104	municipality
180	104	region
181	106	county
182	106	municipality
183	106	region
184	107	county
185	107	municipality
186	107	region
187	108	county
188	108	municipality
189	108	region
190	110	county
191	110	municipality
192	110	region
193	111	county
194	111	municipality
195	111	region
196	112	county
197	112	municipality
198	112	region
199	114	county
200	114	municipality
201	114	region
202	115	county
203	115	municipality
204	115	region
205	116	county
206	116	municipality
207	116	region
208	229	county
209	229	municipality
210	229	region
211	121	county
212	121	municipality
213	121	region
214	122	county
215	122	municipality
216	122	region
217	123	county
218	123	municipality
219	123	region
220	124	county
221	124	municipality
222	124	region
223	202	county
224	202	municipality
225	202	region
226	125	county
227	125	municipality
228	125	region
229	126	county
230	126	municipality
231	126	region
232	127	county
233	127	municipality
234	127	region
235	128	county
236	128	municipality
237	128	region
238	129	county
239	129	municipality
240	129	region
241	130	county
242	130	municipality
243	130	region
244	30	county
245	30	municipality
246	30	region
247	208	county
248	208	municipality
249	208	region
253	31	county
254	31	municipality
255	31	region
256	32	county
257	32	municipality
258	32	region
259	33	county
260	33	municipality
261	33	region
262	34	county
263	34	municipality
264	34	region
265	7	county
266	7	municipality
267	7	region
268	8	county
269	8	municipality
270	8	region
271	9	county
272	9	municipality
273	9	region
274	10	county
275	10	municipality
276	10	region
277	177	county
278	177	municipality
279	177	region
280	180	county
281	180	municipality
282	180	region
283	198	county
284	198	municipality
285	198	region
286	91	county
287	91	municipality
288	91	region
289	222	county
290	222	municipality
291	222	region
292	92	county
293	92	municipality
294	92	region
295	223	county
296	223	municipality
297	223	region
298	224	county
299	224	municipality
300	224	region
301	225	county
302	225	municipality
303	225	region
304	226	county
305	226	municipality
306	226	region
307	131	county
308	131	municipality
309	131	region
310	132	county
311	132	municipality
312	132	region
313	133	county
314	133	municipality
315	133	region
316	73	county
317	73	municipality
318	73	region
319	134	county
320	134	municipality
321	134	region
322	135	county
323	135	municipality
324	135	region
325	136	county
326	136	municipality
327	136	region
328	137	county
329	137	municipality
330	137	region
331	71	county
332	71	municipality
333	71	region
334	72	county
335	72	municipality
336	72	region
337	138	county
338	138	municipality
339	138	region
340	139	county
341	139	municipality
342	139	region
343	140	county
344	140	municipality
345	140	region
346	141	county
347	141	municipality
348	141	region
349	95	county
350	95	municipality
351	95	region
352	96	county
353	96	municipality
354	96	region
355	97	county
356	97	municipality
357	97	region
358	98	county
359	98	municipality
360	98	region
361	99	county
362	99	municipality
363	99	region
364	100	county
365	100	municipality
366	100	region
367	142	county
368	142	municipality
369	142	region
370	149	county
371	149	municipality
372	149	region
373	150	county
374	150	municipality
375	150	region
376	151	county
377	151	municipality
378	151	region
379	152	county
380	152	municipality
381	152	region
382	153	county
383	153	municipality
384	153	region
385	154	county
386	154	municipality
387	154	region
388	155	county
389	155	municipality
390	155	region
391	156	county
392	156	municipality
393	156	region
394	157	county
395	157	municipality
396	157	region
397	158	county
398	158	municipality
399	158	region
400	159	county
401	159	municipality
402	159	region
403	160	county
404	160	municipality
405	160	region
406	161	county
407	161	municipality
408	161	region
409	162	county
410	162	municipality
411	162	region
412	163	county
413	163	municipality
414	163	region
415	164	county
416	164	municipality
417	164	region
418	165	county
419	165	municipality
420	165	region
421	166	county
422	166	municipality
423	166	region
424	169	county
425	169	municipality
426	169	region
427	170	county
428	170	municipality
429	170	region
430	171	county
431	171	municipality
432	171	region
433	172	county
434	172	municipality
435	172	region
436	173	county
437	173	municipality
438	173	region
439	174	county
440	174	municipality
441	174	region
442	175	county
443	175	municipality
444	175	region
445	176	county
446	176	municipality
447	176	region
448	181	county
449	181	municipality
450	181	region
451	182	county
452	182	municipality
453	182	region
454	183	county
455	183	municipality
456	183	region
457	184	county
458	184	municipality
459	184	region
460	186	county
461	186	municipality
462	186	region
463	187	county
464	187	municipality
465	187	region
466	188	county
467	188	municipality
468	188	region
469	190	county
470	190	municipality
471	190	region
472	191	county
473	191	municipality
474	191	region
475	192	county
476	192	municipality
477	192	region
478	193	county
479	193	municipality
480	193	region
481	194	county
482	194	municipality
483	194	region
484	195	county
485	195	municipality
486	195	region
487	203	county
488	203	municipality
489	203	region
490	204	county
491	204	municipality
492	204	region
493	205	county
494	205	municipality
495	205	region
496	206	county
497	206	municipality
498	206	region
499	207	county
500	207	municipality
501	207	region
502	84	county
503	84	municipality
504	84	region
505	117	county
506	117	municipality
507	117	region
508	118	county
509	118	municipality
510	118	region
511	189	county
512	189	municipality
513	189	region
514	80	county
515	80	municipality
516	80	region
517	81	county
518	81	municipality
519	81	region
520	82	county
521	82	municipality
522	82	region
523	83	county
524	83	municipality
525	83	region
526	35	county
527	35	municipality
528	35	region
529	37	county
530	37	municipality
531	37	region
532	38	county
533	38	municipality
534	38	region
535	39	county
536	39	municipality
537	39	region
538	40	county
539	40	municipality
540	40	region
541	41	county
542	41	municipality
543	41	region
544	119	county
545	119	municipality
546	119	region
547	120	county
548	120	municipality
549	120	region
550	59	county
551	59	municipality
552	59	region
553	65	county
554	65	municipality
555	65	region
556	61	county
557	61	municipality
558	61	region
559	60	county
560	60	municipality
561	60	region
562	62	county
563	62	municipality
564	62	region
565	66	county
566	66	municipality
567	66	region
568	63	county
569	63	municipality
570	63	region
571	52	county
572	52	municipality
573	52	region
574	57	county
575	57	municipality
576	57	region
577	148	county
578	148	municipality
579	148	region
580	227	county
581	227	municipality
582	227	region
583	53	county
584	53	municipality
585	53	region
586	54	county
587	54	municipality
588	54	region
589	55	county
590	55	municipality
591	55	region
592	56	county
593	56	municipality
594	56	region
595	67	county
596	67	municipality
597	67	region
598	68	county
599	68	municipality
600	68	region
601	64	county
602	64	municipality
603	64	region
604	58	county
605	58	municipality
606	58	region
607	168	county
608	168	municipality
609	168	region
610	209	county
611	209	municipality
612	209	region
613	210	county
614	210	municipality
615	210	region
616	211	county
617	211	municipality
618	211	region
619	212	county
620	212	municipality
621	212	region
622	213	county
623	213	municipality
624	213	region
625	214	county
626	214	municipality
627	214	region
628	215	county
629	215	municipality
630	215	region
631	216	county
632	216	municipality
633	216	region
634	217	county
635	217	municipality
636	217	region
637	218	county
638	218	municipality
639	218	region
640	219	county
641	219	municipality
642	219	region
643	220	county
644	220	municipality
645	220	region
646	221	county
647	221	municipality
648	221	region
649	42	county
650	42	municipality
651	42	region
652	2	county
653	2	municipality
654	2	region
655	101	county
656	101	municipality
657	101	region
658	102	county
659	102	municipality
660	102	region
661	70	county
662	70	municipality
663	70	region
664	103	county
665	103	municipality
666	103	region
667	16	county
668	16	municipality
669	16	region
670	17	county
671	17	municipality
672	17	region
673	19	county
674	19	municipality
675	19	region
676	20	county
677	20	municipality
678	20	region
679	21	county
680	21	municipality
681	21	region
682	22	county
683	22	municipality
684	22	region
685	109	county
686	109	municipality
687	109	region
688	43	county
689	43	municipality
690	43	region
691	44	county
692	44	municipality
693	44	region
694	45	county
695	45	municipality
696	45	region
697	51	county
698	51	municipality
699	51	region
700	167	county
701	167	municipality
702	167	region
703	179	county
704	179	municipality
705	179	region
706	113	county
707	113	municipality
708	113	region
709	178	county
710	178	municipality
711	178	region
712	26	county
713	26	municipality
714	26	region
715	27	county
716	27	municipality
717	27	region
718	28	county
719	28	municipality
720	28	region
721	29	county
722	29	municipality
723	29	region
724	105	county
725	105	municipality
726	105	region
727	185	county
728	185	municipality
729	185	region
730	46	county
731	46	municipality
732	46	region
733	47	county
734	47	municipality
735	47	region
736	48	county
737	48	municipality
738	48	region
739	36	county
740	36	municipality
741	36	region
742	143	county
743	143	municipality
744	143	region
745	144	county
746	144	municipality
747	144	region
748	145	county
749	145	municipality
750	145	region
751	146	county
752	146	municipality
753	146	region
754	147	county
755	147	municipality
756	147	region
757	4	county
758	4	municipality
759	76	county
760	76	municipality
761	75	county
762	75	municipality
763	77	county
764	77	municipality
765	197	county
766	197	municipality
767	196	county
768	196	municipality
769	381	county
770	382	county
771	383	county
772	384	county
773	385	county
774	386	county
775	387	county
776	388	county
777	389	county
778	390	county
779	391	county
780	392	county
781	393	county
782	394	county
783	395	county
784	396	county
785	397	county
786	398	county
787	399	county
788	400	county
789	401	county
790	402	county
791	403	county
792	404	county
793	405	county
794	406	county
795	407	county
796	408	county
797	409	county
798	410	county
799	411	county
800	412	county
801	413	county
802	414	county
803	415	county
804	416	county
805	417	county
806	418	county
807	419	county
808	420	county
809	421	county
810	422	county
811	423	county
812	424	county
813	425	county
814	426	county
815	427	county
816	428	county
833	435	region
834	435	county
835	435	municipality
876	466	county
877	467	county
878	468	county
879	469	county
880	470	county
881	471	county
882	472	county
883	473	county
884	474	county
885	475	county
886	476	county
887	477	county
888	478	county
889	479	county
890	480	county
891	481	county
892	482	county
893	483	county
894	484	county
895	485	county
896	486	county
900	490	county
904	494	county
908	478	municipality
912	482	municipality
897	487	county
901	491	county
905	475	municipality
909	479	municipality
913	483	municipality
898	488	county
902	492	county
906	476	municipality
910	480	municipality
914	484	municipality
899	489	county
903	493	county
907	477	municipality
911	481	municipality
\.


--
-- Data for Name: geography; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.geography (id, name, county_id, state, buffer_bbox) FROM stdin;
1	Bucks	\N	PA	POLYGON((-75.5172386174942 40.019966656385144,-75.52195819955206 40.635408512424895,-74.68232273049465 40.63615113388574,-74.68519528899041 40.020693387223744,-75.5172386174942 40.019966656385144))
2	Chester	\N	PA	POLYGON((-76.16986916935087 39.692670891923115,-76.17970862838224 40.2671574994225,-75.3279315229405 40.2727066707756,-75.32519567797509 39.69810890607209,-76.16986916935087 39.692670891923115))
3	Delaware	\N	PA	POLYGON((-75.61811849642501 39.78752868903448,-75.62074024540864 40.07835951366461,-75.19469101949267 40.07985900985727,-75.19386866783753 39.78901289984785,-75.61811849642501 39.78752868903448))
4	Montgomery	\N	PA	POLYGON((-75.7244727035021 39.951581599763706,-75.73000821236766 40.46945925090913,-74.98426667493503 40.47176346401691,-74.98438599040792 39.95384422346794,-75.7244727035021 39.951581599763706))
5	Philadelphia	\N	PA	POLYGON((-75.29733264718094 39.853065358495556,-75.29862804603663 40.15105586523984,-74.9381283423984 40.151424403158565,-74.93839673599271 39.85343004938075,-75.29733264718094 39.853065358495556))
6	Burlington	\N	NJ	POLYGON((-75.10171860536784 39.51051571821398,-75.10276577806611 40.216049347200794,-74.34323529515214 40.2142317457408,-74.34992709673733 39.50874275664577,-75.10171860536784 39.51051571821398))
7	Camden	\N	NJ	POLYGON((-75.16340175005875 39.58893254539328,-75.16441481574451 40.01562229638109,-74.70988712645062 40.01537579746854,-74.71167467836511 39.588689727200304,-75.16340175005875 39.58893254539328))
8	Gloucester	\N	NJ	POLYGON((-75.45135231475463 39.495378768648,-75.45403265505443 39.90561004219216,-74.85256986608508 39.9064051456331,-74.85344023871828 39.49616244653485,-75.45135231475463 39.495378768648))
9	Mercer	\N	NJ	POLYGON((-74.96179492387068 40.12310637197726,-74.96161682329019 40.438766870044525,-74.46089334457224 40.437516240339036,-74.46339469067136 40.121869543447104,-74.96179492387068 40.12310637197726))
10	Bedminster Township	1	PA	POLYGON((-75.26255154482685 40.35769570951717,-75.26303011527256 40.48069139792641,-75.1091131225946 40.480939185609806,-75.10891459429523 40.35794242896758,-75.26255154482685 40.35769570951717))
11	Bensalem Township	1	PA	POLYGON((-75.00148865852142 40.043679615018405,-75.00149122010927 40.16111066796855,-74.89133628374017 40.161059689585976,-74.89152294363547 40.043628846876466,-75.00148865852142 40.043679615018405))
12	Bridgeton Township	1	PA	POLYGON((-75.15363013346503 40.52771330286835,-75.1537451801633 40.57803240295161,-75.08173966126289 40.57810579308871,-75.08167849569996 40.52778656349834,-75.15363013346503 40.52771330286835))
13	Bristol Borough	1	PA	POLYGON((-74.87650947160728 40.09096813102292,-74.87645862635715 40.11908251014379,-74.83241964405568 40.11902716184115,-74.83248861401037 40.09091283745406,-74.87650947160728 40.09096813102292))
14	Chalfont Borough	1	PA	POLYGON((-75.22740098815547 40.27616318294177,-75.227494991461 40.304204886838704,-75.18852286657254 40.3042749554983,-75.18844496669956 40.276233182566095,-75.22740098815547 40.27616318294177))
15	Bristol Township	1	PA	POLYGON((-74.9219605970039 40.06541548082246,-74.92182882291014 40.180568076736364,-74.81179419577131 40.18044149396512,-74.81211145467631 40.065289409919835,-74.9219605970039 40.06541548082246))
16	Buckingham Township	1	PA	POLYGON((-75.14005911569002 40.24954890265329,-75.14034295397828 40.38677384652006,-74.97316528243283 40.38685589356816,-74.97321955483729 40.249630554939266,-75.14005911569002 40.24954890265329))
17	Doylestown Borough	1	PA	POLYGON((-75.14994057882667 40.29660831073017,-75.15001278140605 40.32924627295137,-75.10362738928275 40.32929712601904,-75.10357751231497 40.29665910549493,-75.14994057882667 40.29660831073017))
18	Doylestown Township	1	PA	POLYGON((-75.19797247179261 40.25723268697315,-75.19822926056403 40.34514785868697,-75.07706405420751 40.3452920471944,-75.07696422375093 40.25737643059005,-75.19797247179261 40.25723268697315))
19	Hulmeville Borough	1	PA	POLYGON((-74.91936905313088 40.132007314015645,-74.91934788968928 40.14990820195252,-74.8970001101187 40.14989048045125,-74.89702713768598 40.13198960367224,-74.91936905313088 40.132007314015645))
20	Dublin Borough	1	PA	POLYGON((-75.21522765654676 40.365043670409165,-75.21528625025266 40.38345739508928,-75.19208880403744 40.383498253856786,-75.19203652379905 40.36508450275072,-75.21522765654676 40.365043670409165))
21	Durham Township	1	PA	POLYGON((-75.26059096015905 40.53880649582372,-75.2608518422782 40.606020927316244,-75.16379797925696 40.606199337106155,-75.16363416089675 40.538984485245834,-75.26059096015905 40.53880649582372))
22	East Rockhill Township	1	PA	POLYGON((-75.34175904993542 40.364335161851486,-75.34223948917699 40.45923808026894,-75.23914222238578 40.45949734463741,-75.23880650804783 40.36459356333842,-75.34175904993542 40.364335161851486))
23	Ivyland Borough	1	PA	POLYGON((-75.08064856017087 40.199873286511945,-75.08066807327049 40.216335500088356,-75.06521551473044 40.216345237528444,-75.06519973950033 40.199883018315994,-75.08064856017087 40.199873286511945))
24	Falls Township	1	PA	POLYGON((-74.87854994124756 40.116006887095686,-74.87836078827036 40.222052034641656,-74.71448717738963 40.22176381774664,-74.71493115322285 40.11571974336971,-74.87854994124756 40.116006887095686))
25	Haycock Township	1	PA	POLYGON((-75.30845822566705 40.424698061579505,-75.30890166447116 40.52153650118335,-75.17910719998872 40.52181057272859,-75.17885008223526 40.42497120271347,-75.30845822566705 40.424698061579505))
26	Avondale Borough	2	PA	POLYGON((-75.78939710534064 39.81831573750745,-75.78954417886823 39.83116571213627,-75.77463439905901 39.831266223987804,-75.77449010218983 39.818416203836684,-75.78939710534064 39.81831573750745))
27	Hilltown Township	1	PA	POLYGON((-75.32982406312532 40.28071932624519,-75.33042095051505 40.403169685701975,-75.17421991635695 40.403510537876116,-75.17390519257478 40.281058714827914,-75.32982406312532 40.28071932624519))
28	Langhorne Borough	1	PA	POLYGON((-74.92953853740542 40.16975212786619,-74.92952121015121 40.186501491842634,-74.91151845501847 40.18648913263157,-74.91154020824857 40.1697397759347,-74.92953853740542 40.16975212786619))
29	Langhorne Manor Borough	1	PA	POLYGON((-74.92766249830517 40.157911430479125,-74.92764470974365 40.174667808928056,-74.90474511648665 40.17465123363159,-74.90476853489916 40.15789486495031,-74.92766249830517 40.157911430479125))
30	New Britain Borough	1	PA	POLYGON((-75.20226477743468 40.28715190649465,-75.20232743681483 40.308161963026464,-75.15314862172966 40.30823751666505,-75.15310119251338 40.28722740435559,-75.20226477743468 40.28715190649465))
31	Lower Makefield Township	1	PA	POLYGON((-74.91934156046705 40.18950144866973,-74.91924179204783 40.27354890663622,-74.77715366037788 40.273362506066256,-74.77742896159107 40.18931559819269,-74.91934156046705 40.18950144866973))
32	Riegelsville Borough	1	PA	POLYGON((-75.21049855397452 40.584554479129736,-75.21057734477539 40.609671085121235,-75.18797605302417 40.60971007954951,-75.18790571872084 40.58459343920439,-75.21049855397452 40.584554479129736))
33	Lower Southampton Township	1	PA	POLYGON((-75.03256233232545 40.125298854853895,-75.03258877038017 40.180633823874665,-74.9456144912172 40.180625636769626,-74.94565861213638 40.12529068367163,-75.03256233232545 40.125298854853895))
34	Sellersville Borough	1	PA	POLYGON((-75.3237388265513 40.34795700558344,-75.32385176307085 40.371563550830246,-75.29122342077558 40.371650316422695,-75.29112186229335 40.34804369923415,-75.3237388265513 40.34795700558344))
35	Middletown Township	1	PA	POLYGON((-74.96409849543609 40.12735283163234,-74.96404425351089 40.230191916353085,-74.84940497620401 40.23009953096762,-74.84963215904452 40.12726077984196,-74.96409849543609 40.12735283163234))
36	Milford Township	1	PA	POLYGON((-75.4909008475328 40.366552213721334,-75.491828895353 40.494061436628805,-75.35894581720879 40.49455054545705,-75.35826849525218 40.36703913688659,-75.4909008475328 40.366552213721334))
37	Morrisville Borough	1	PA	POLYGON((-74.80529618719287 40.192582046376145,-74.8052076313086 40.22352449834899,-74.7589393689358 40.223437385752014,-74.75904895870117 40.19249502852639,-74.80529618719287 40.192582046376145))
38	New Britain Township	1	PA	POLYGON((-75.27016673170827 40.25221950217359,-75.27061363960125 40.36428987394165,-75.1445024974298 40.36451619648962,-75.14426385464884 40.25244493495562,-75.27016673170827 40.25221950217359))
39	Londonderry Township	2	PA	POLYGON((-75.92349407362542 39.839722766117106,-75.92443614800824 39.909924670076755,-75.83129195763485 39.91062983849715,-75.83044477653942 39.84042619204197,-75.92349407362542 39.839722766117106))
40	New Hope Borough	1	PA	POLYGON((-74.97034210351788 40.3488795750308,-74.97033083298936 40.37459325024717,-74.94365553305178 40.374583330421906,-74.94367693680829 40.348869664164276,-74.97034210351788 40.3488795750308))
41	Newtown Borough	1	PA	POLYGON((-74.9401083897407 40.21984663690028,-74.94009185263141 40.238619003663246,-74.92393295746622 40.238609511505814,-74.9239539550849 40.219837151006864,-74.9401083897407 40.21984663690028))
42	Newtown Township	1	PA	POLYGON((-74.98854380745279 40.2082837489322,-74.98853268348627 40.27424797674475,-74.88466982019652 40.2741910713986,-74.88478169690565 40.208226975423706,-74.98854380745279 40.2082837489322))
43	Nockamixon Township	1	PA	POLYGON((-75.23797813377841 40.46176983843944,-75.23838156281408 40.57576419125245,-75.10361272976083 40.57596367752685,-75.10343737738285 40.4619685279722,-75.23797813377841 40.46176983843944))
44	Hi-Nella Borough	7	NJ	POLYGON((-75.02928886704267 39.83101949962796,-75.02929397965346 39.84305442898424,-75.01674958522632 39.843056918319085,-75.01674666195946 39.831021987906965,-75.02928886704267 39.83101949962796))
45	Northampton Township	1	PA	POLYGON((-75.07871968355714 40.15846313181038,-75.07883780165808 40.260485946573134,-74.91641166922408 40.260482612723884,-74.9165369047474 40.1584598099018,-75.07871968355714 40.15846313181038))
46	Penndel Borough	1	PA	POLYGON((-74.9249729964436 40.14848479728497,-74.92495740307746 40.16265247836238,-74.90586666662863 40.16263853190152,-74.90588622691345 40.148470857773695,-74.9249729964436 40.14848479728497))
47	Perkasie Borough	1	PA	POLYGON((-75.31406244552406 40.35264471666856,-75.31423816240725 40.39048574397217,-75.27238120770247 40.39059191198905,-75.27222889579053 40.35275074362035,-75.31406244552406 40.35264471666856))
48	Marcus Hook Borough	3	PA	POLYGON((-75.43828521606575 39.80029834907162,-75.43845846566674 39.82757051030129,-75.39710479147242 39.82771942036506,-75.39694788099048 39.80044711602588,-75.43828521606575 39.80029834907162))
49	Plumstead Township	1	PA	POLYGON((-75.19628079429425 40.32407474042342,-75.19663974308905 40.44762029080155,-75.03406386638152 40.447782514427885,-75.03400168527575 40.32423626143771,-75.19628079429425 40.32407474042342))
50	Quakertown Borough	1	PA	POLYGON((-75.3714435987592 40.42529540426655,-75.37159354937499 40.45253591350324,-75.3176302786341 40.452696784690644,-75.317502103063 40.4254561216136,-75.3714435987592 40.42529540426655))
51	Trainer Borough	3	PA	POLYGON((-75.4193928968167 39.80788331035696,-75.41958273712359 39.83910180617968,-75.38866690829356 39.83920949925119,-75.38849105496884 39.807990884969676,-75.4193928968167 39.80788331035696))
52	Richland Township	1	PA	POLYGON((-75.3901869995328 40.39230737800766,-75.39080514268791 40.499117997243076,-75.2880138428011 40.49941988136071,-75.28755827995698 40.39260813178472,-75.3901869995328 40.39230737800766))
53	Richlandtown Borough	1	PA	POLYGON((-75.3254114050084 40.46421912786107,-75.32548771775213 40.480026177955494,-75.31603190978247 40.48005241969034,-75.31595781392409 40.464245355033775,-75.3254114050084 40.46421912786107))
54	Silverdale Borough	1	PA	POLYGON((-75.28012143902154 40.34001357473147,-75.28018385732724 40.35509960808192,-75.26298333689638 40.355139996656526,-75.2629247503468 40.34005394190037,-75.28012143902154 40.34001357473147))
55	Tinicum Township	1	PA	POLYGON((-75.18692097607418 40.41406201604725,-75.18732793593021 40.560592242896305,-75.05162582580908 40.56073257897315,-75.05151367074563 40.414201631936024,-75.18692097607418 40.41406201604725))
56	Solebury Township	1	PA	POLYGON((-75.0860536908994 40.315618606113134,-75.08618048217622 40.41524752392731,-74.92201413337808 40.41525334145229,-74.92212886852516 40.31562440330844,-75.0860536908994 40.315618606113134))
57	Springfield Township	1	PA	POLYGON((-75.41593032308653 40.471168229576506,-75.41664983987937 40.58744650984232,-75.2082393107854 40.588010222796186,-75.20787969074196 40.471729646184734,-75.41593032308653 40.471168229576506))
58	Telford Borough	1	PA	POLYGON((-75.33566469387453 40.31741422052534,-75.33576417939439 40.33749386386241,-75.31445336205466 40.337553760270836,-75.31436019057865 40.31747407467997,-75.33566469387453 40.31741422052534))
59	Trumbauersville Borough	1	PA	POLYGON((-75.39272443694175 40.40731264807275,-75.39278987199063 40.41856733126659,-75.36737264255848 40.41865088663549,-75.3673114415377 40.40739617041457,-75.39272443694175 40.40731264807275))
60	Tullytown Borough	1	PA	POLYGON((-74.83064374441958 40.124323663868786,-74.83056022758316 40.157952278501426,-74.79297564221328 40.1578911807239,-74.79307768419272 40.12426263833822,-74.83064374441958 40.124323663868786))
61	Upper Makefield Township	1	PA	POLYGON((-75.00371805959692 40.25965235089218,-75.00372208905225 40.333128209462885,-74.84890330561595 40.3330295875865,-74.84906687896317 40.25955398340424,-75.00371805959692 40.25965235089218))
62	Upper Southampton Township	1	PA	POLYGON((-75.07452523184074 40.14392379788629,-75.07458731680734 40.20066072746334,-74.995385963549 40.20068466411345,-74.99538980418349 40.143947686810215,-75.07452523184074 40.14392379788629))
63	Salford Township	4	PA	POLYGON((-75.44665766531888 40.30708739892434,-75.44709041017322 40.37267435595276,-75.3495401252919 40.37301033774444,-75.34920179534593 40.3074226072067,-75.44665766531888 40.30708739892434))
64	Philadelphia City	5	PA	NaN
65	Warminster Township	1	PA	POLYGON((-75.14203829799382 40.167625757242035,-75.14219173548716 40.2411041525066,-75.03949557882817 40.24118476066005,-75.03945295943458 40.16770615735138,-75.14203829799382 40.167625757242035))
66	Warrington Township	1	PA	POLYGON((-75.21867888901305 40.207159319769694,-75.21893493007806 40.286676176479176,-75.10635481635617 40.28683442736102,-75.1062304350955 40.207317128809805,-75.21867888901305 40.207159319769694))
67	Warwick Township	1	PA	POLYGON((-75.12687888560967 40.211795116679525,-75.12701870889373 40.286634037809804,-75.02942762043871 40.28670001418722,-75.02939522616148 40.2118609196739,-75.12687888560967 40.211795116679525))
68	West Rockhill Township	1	PA	POLYGON((-75.41234848330231 40.324622434133964,-75.41286963235406 40.410084181579855,-75.2900598621956 40.41045748642689,-75.28969372466605 40.324994619678485,-75.41234848330231 40.324622434133964))
69	Wrightstown Township	1	PA	POLYGON((-75.04488071508956 40.23738151004079,-75.04492544517797 40.305015013966596,-74.95103632302396 40.3050133753991,-74.95108507378029 40.237379875364766,-75.04488071508956 40.23738151004079))
70	Yardley Borough	1	PA	POLYGON((-74.85295371734091 40.230783752421694,-74.85290937860096 40.25127490917907,-74.82283726945113 40.251232780834556,-74.82289067296945 40.23074165442074,-74.85295371734091 40.230783752421694))
71	Atglen Borough	2	PA	POLYGON((-75.9906970738078 39.9381270704601,-75.99096620944864 39.95678067164909,-75.96411956086183 39.95700706715612,-75.96385771368855 39.93835331725326,-75.9906970738078 39.9381270704601))
72	Birmingham Township	2	PA	POLYGON((-75.63861843996959 39.832844448670215,-75.63955805432778 39.93404771684584,-75.55685907233232 39.934474402636376,-75.55604093976902 39.833269615417926,-75.63861843996959 39.832844448670215))
73	Caln Township	2	PA	POLYGON((-75.81695335503963 39.97926980240721,-75.81748103692371 40.02352932241792,-75.70153233140421 40.02428929664019,-75.70107947792593 39.980028593077414,-75.81695335503963 39.97926980240721))
74	Charlestown Township	2	PA	POLYGON((-75.62296721326756 40.04701561801219,-75.62367826086657 40.12497420449958,-75.49212471019304 40.12560794504055,-75.49156362841565 40.04764762206346,-75.62296721326756 40.04701561801219))
75	Schwenksville Borough	4	PA	POLYGON((-75.47301720639622 40.24582720220427,-75.47317712442144 40.268788145085686,-75.45968524762715 40.26884252869548,-75.45952988900767 40.245881541928334,-75.47301720639622 40.24582720220427))
76	Coatesville City	2	PA	POLYGON((-75.84338255518495 39.97328132399796,-75.84379481048175 40.00679183624329,-75.79608834406531 40.007129373190374,-75.79569939068107 39.97361846284292,-75.84338255518495 39.97328132399796))
77	Downingtown Borough	2	PA	POLYGON((-75.72875167231345 39.994056260836096,-75.72905239653954 40.02232929596893,-75.67425739163521 40.02266108217374,-75.67397926526498 39.99438771688908,-75.72875167231345 39.994056260836096))
78	Rutledge Borough	3	PA	POLYGON((-75.33322371450684 39.89705221677695,-75.33326684534774 39.9059557810182,-75.3217539752459 39.90598829554717,-75.32171233431774 39.89708472110681,-75.33322371450684 39.89705221677695))
79	East Bradford Township	2	PA	POLYGON((-75.70044107635674 39.90985439111794,-75.70148879652318 40.01245510025787,-75.59380391830115 40.013056908112574,-75.59291700759465 39.91045402800915,-75.70044107635674 39.90985439111794))
80	East Brandywine Township	2	PA	POLYGON((-75.79161862344253 40.00841837213323,-75.79230898745608 40.06809132050434,-75.7029287756501 40.06866813699118,-75.70231627485495 40.00899397808123,-75.79161862344253 40.00841837213323))
81	Wallace Township	2	PA	POLYGON((-75.82630503423637 40.05849112717816,-75.82713319693805 40.12693257348406,-75.7268695344147 40.127605294048685,-75.72614173717567 40.0591622292688,-75.82630503423637 40.05849112717816))
82	East Caln Township	2	PA	POLYGON((-75.71130175018952 39.99267474192155,-75.71172606769184 40.03353545806628,-75.65408276636661 40.03387518552111,-75.65369280847145 39.99301398093762,-75.71130175018952 39.99267474192155))
83	East Coventry Township	2	PA	POLYGON((-75.66495379247102 40.16325944711042,-75.66571590715446 40.24121772334225,-75.57508247995445 40.241703579023444,-75.57442410783219 40.16374397245915,-75.66495379247102 40.16325944711042))
84	East Fallowfield Township	2	PA	POLYGON((-75.8944728988565 39.91184860640412,-75.89546366578978 39.98786828348369,-75.7601931535831 39.98883446014012,-75.75935201566824 39.91281219923571,-75.8944728988565 39.91184860640412))
85	East Goshen Township	2	PA	POLYGON((-75.58838048508953 39.954427139303924,-75.58905273811743 40.032722054205045,-75.50410147234726 40.03312276747923,-75.50352615862849 39.95482674924169,-75.58838048508953 39.954427139303924))
86	East Marlborough Township	2	PA	POLYGON((-75.77699810309834 39.84823408466775,-75.77775348097141 39.915123538420445,-75.66226314100685 39.915840664862074,-75.66161990917713 39.84894952265351,-75.77699810309834 39.84823408466775))
87	East Nantmeal Township	2	PA	POLYGON((-75.81430199394316 40.09469764042449,-75.81520538384997 40.17034553735676,-75.66607105481734 40.1712995661536,-75.66533289872669 40.095649133206834,-75.81430199394316 40.09469764042449))
88	East Nottingham Township	2	PA	POLYGON((-76.05202208156216 39.71740774288791,-76.05326985495094 39.79936013910229,-75.90034092688897 39.800647551990586,-75.89927425865532 39.718691439996945,-76.05202208156216 39.71740774288791))
89	Rose Valley Borough	3	PA	POLYGON((-75.39644515699887 39.88384884024037,-75.3965727898866 39.905997588854255,-75.37452145529703 39.90607090221127,-75.37440091898928 39.88392209640079,-75.39644515699887 39.88384884024037))
90	East Pikeland Township	2	PA	POLYGON((-75.61124456080458 40.09002598089243,-75.61199739598143 40.1740079646934,-75.52186704892833 40.17444930977958,-75.52122507232261 40.09046602373483,-75.61124456080458 40.09002598089243))
91	Easttown Township	2	PA	POLYGON((-75.48281643550355 39.993777647913376,-75.4832909806998 40.061055431633555,-75.40056833662476 40.06137097487025,-75.40017501126624 39.99409244459216,-75.48281643550355 39.993777647913376))
92	East Vincent Township	2	PA	POLYGON((-75.67066589282888 40.13372570164779,-75.67144647371734 40.21297337345017,-75.54121043470275 40.213655579836434,-75.54058123779029 40.13440600888298,-75.67066589282888 40.13372570164779))
93	Warwick Township	2	PA	POLYGON((-75.82521264129986 40.142550855422336,-75.82614741156928 40.219657301783606,-75.68900653709956 40.220554930060025,-75.6882269063089 40.14344605237992,-75.82521264129986 40.142550855422336))
310	Gibbsboro Borough	7	NJ	POLYGON((-74.9875704606147 39.81621264674891,-74.98756496042854 39.8467234526962,-74.94615025539905 39.84671162110778,-74.94617407385606 39.81620082787931,-74.9875704606147 39.81621264674891))
94	East Whiteland Township	2	PA	POLYGON((-75.60469700087948 40.01333443196787,-75.6052638877726 40.07746440354474,-75.50339903954499 40.07795184542916,-75.50292754792115 40.01382077460935,-75.60469700087948 40.01333443196787))
95	Elk Township	2	PA	POLYGON((-75.96809508882546 39.71918364377144,-75.96868989151412 39.76167642017054,-75.83893201053397 39.76268688593182,-75.83841685829739 39.7201925961163,-75.96809508882546 39.71918364377144))
96	Elverson Borough	2	PA	POLYGON((-75.84761763538049 40.14727979696159,-75.8478762335435 40.168072772816146,-75.81840484578447 40.16828485106615,-75.81815523376434 40.14749172013214,-75.84761763538049 40.14727979696159))
97	Franklin Township	2	PA	POLYGON((-75.87417255861712 39.717796151222764,-75.87525212063225 39.80312065100608,-75.7717454466377 39.80385524706327,-75.77079351993935 39.71852853999899,-75.87417255861712 39.717796151222764))
98	Highland Township	2	PA	POLYGON((-75.95752847904872 39.88240150255338,-75.95863370667105 39.961694728251814,-75.83570547792657 39.96264615531532,-75.8347419335849 39.8833502753586,-75.95752847904872 39.88240150255338))
99	Honey Brook Borough	2	PA	POLYGON((-75.9202934340909 40.0860115765197,-75.92048716321742 40.10039193127451,-75.90252330042476 40.10053330528664,-75.9023333507762 40.086152879,-75.9202934340909 40.0860115765197))
100	Honey Brook Township	2	PA	POLYGON((-75.94862078360941 40.04233640743975,-75.95015945497599 40.15304365603465,-75.82798517695161 40.1539817825213,-75.82664429342891 40.04327088592407,-75.94862078360941 40.04233640743975))
101	Kennett Township	2	PA	POLYGON((-75.73413292133924 39.78590745963492,-75.73515735441077 39.88206213854496,-75.62966818715242 39.882682831101434,-75.6287907263848 39.786526051841506,-75.73413292133924 39.78590745963492))
102	West Fallowfield Township	2	PA	POLYGON((-76.00210978957615 39.855117081993825,-76.00345955261997 39.94770438710623,-75.90567072408079 39.94850960157597,-75.90445245162837 39.855919673761875,-76.00210978957615 39.855117081993825))
103	Kennett Square Borough	2	PA	POLYGON((-75.72338435421402 39.83314065947038,-75.72359927046891 39.85361715730856,-75.69942522647874 39.85376543561028,-75.69921748870722 39.833288830785925,-75.72338435421402 39.83314065947038))
104	London Britain Township	2	PA	POLYGON((-75.82178927562417 39.71883363052231,-75.82255810336738 39.78350388370557,-75.75098027355494 39.78398915706616,-75.7502783320691 39.71931779825458,-75.82178927562417 39.71883363052231))
105	London Grove Township	2	PA	POLYGON((-75.85794954698434 39.78478861620709,-75.85908311782337 39.87584543910985,-75.77452486471238 39.87644094702052,-75.77350284092387 39.785382215610596,-75.85794954698434 39.78478861620709))
106	Lower Oxford Township	2	PA	POLYGON((-76.06919395459614 39.764925680794846,-76.07035036270636 39.83954449625235,-75.89856510920214 39.841002348244416,-75.89759423155182 39.766379702198975,-76.06919395459614 39.764925680794846))
107	Malvern Borough	2	PA	POLYGON((-75.53178472976585 40.021612543495316,-75.53195649740792 40.04372523554283,-75.49852504410381 40.04387389915251,-75.49836407028253 40.02176109141144,-75.53178472976585 40.021612543495316))
108	Modena Borough	2	PA	POLYGON((-75.8135061431669 39.95529384227014,-75.81364926365477 39.967369031253746,-75.7927600567675 39.96751377645353,-75.79262060973035 39.9554385259195,-75.8135061431669 39.95529384227014))
109	New Garden Township	2	PA	POLYGON((-75.79024146668166 39.75046858028187,-75.7914836026266 39.858881711918905,-75.71384761210122 39.85938547753604,-75.71272728974583 39.750970423945844,-75.79024146668166 39.75046858028187))
110	Newlin Township	2	PA	POLYGON((-75.79084253436052 39.89424652108254,-75.7915179721261 39.952925933691965,-75.68515426919227 39.953603359520244,-75.68456957771616 39.89492254786888,-75.79084253436052 39.89424652108254))
111	New London Township	2	PA	POLYGON((-75.92568590657379 39.731692524501156,-75.92664506860793 39.80327093951013,-75.83698399126632 39.80395234119922,-75.83611760883291 39.732372208260166,-75.92568590657379 39.731692524501156))
112	North Coventry Township	2	PA	POLYGON((-75.74618543012943 40.19172490089892,-75.74679394459662 40.24716944067772,-75.61904949473015 40.24792328120767,-75.6185450531662 40.1924772729832,-75.74618543012943 40.19172490089892))
113	Oxford Borough	2	PA	POLYGON((-76.00156132260665 39.7728377431484,-76.00191857765957 39.79747102880126,-75.9585421112362 39.7978374630944,-75.9582003170711 39.773203859281246,-76.00156132260665 39.7728377431484))
114	Parkesburg Borough	2	PA	POLYGON((-75.93489979638962 39.94814108555386,-75.93519671082859 39.96993897373299,-75.90282095953134 39.970195665144246,-75.90253432056687 39.94839757995377,-75.93489979638962 39.94814108555386))
115	Penn Township	2	PA	POLYGON((-75.9104352507779 39.79419874509038,-75.91121066186149 39.852922095971074,-75.84080164275288 39.853453826567105,-75.84008612958674 39.794729376017195,-75.9104352507779 39.79419874509038))
116	Pennsbury Township	2	PA	POLYGON((-75.67276474064883 39.82669554492176,-75.67348517340962 39.90041955475593,-75.58790996949514 39.900884965710546,-75.58728106348616 39.827159748122796,-75.67276474064883 39.82669554492176))
117	Sadsbury Township	2	PA	POLYGON((-75.94075504355476 39.95225511535187,-75.94156593211738 40.01135171010487,-75.87509135684984 40.01187275929533,-75.87433769857763 39.95277508121122,-75.94075504355476 39.95225511535187))
118	Phoenixville Borough	2	PA	POLYGON((-75.54993633377771 40.11434500381879,-75.55032211541129 40.162180719349244,-75.49725896452084 40.162420765339554,-75.49691037678723 40.11458464613317,-75.54993633377771 40.11434500381879))
119	Pocopson Township	2	PA	POLYGON((-75.7011919633102 39.881920537068346,-75.70175496344065 39.93711511768714,-75.6197400513194 39.937582524944155,-75.61924283873296 39.8823870362139,-75.7011919633102 39.881920537068346))
120	South Coventry Township	2	PA	POLYGON((-75.71830972515919 40.14637727451852,-75.71891902466885 40.2041376585957,-75.6377907252457 40.2046130896432,-75.63725017166682 40.14685174055442,-75.71830972515919 40.14637727451852))
121	Schuylkill Township	2	PA	POLYGON((-75.55697970123352 40.08074800716269,-75.55744194033805 40.13739445961186,-75.45352992716283 40.137848040912324,-75.45315384542376 40.081200685177656,-75.55697970123352 40.08074800716269))
122	Bryn Athyn Borough	4	PA	POLYGON((-75.09597067783925 40.123493600518536,-75.09602458511124 40.16179438903768,-75.04304308357011 40.161826205434934,-75.04301891956378 40.12352537407035,-75.09597067783925 40.123493600518536))
123	South Coatesville Borough	2	PA	POLYGON((-75.83698657370918 39.95317577569736,-75.83734389522614 39.98246697561588,-75.79563760583041 39.98276077426502,-75.7952980770327 39.95346927139616,-75.83698657370918 39.95317577569736))
124	Spring City Borough	2	PA	POLYGON((-75.55930234219444 40.165087962325735,-75.55948646945563 40.18751067299901,-75.53062258619687 40.18764656796211,-75.53044795693798 40.16522375014399,-75.55930234219444 40.165087962325735))
125	Thornbury Township	2	PA	POLYGON((-75.59714954785947 39.899365785904976,-75.59755385332979 39.945890331720626,-75.51568311016939 39.94628340273235,-75.51533419206537 39.899758213147535,-75.59714954785947 39.899365785904976))
126	Upper Uwchlan Township	2	PA	POLYGON((-75.74887426645859 40.043397891911255,-75.74973815800456 40.12219673084906,-75.65200462520056 40.12278820270304,-75.65125332700153 40.04398772561971,-75.74887426645859 40.043397891911255))
127	Tredyffrin Township	2	PA	POLYGON((-75.53407640228967 40.03125898552248,-75.53461242849842 40.09986512854997,-75.3570332929595 40.1005486254995,-75.35667530399982 40.03194083384467,-75.53407640228967 40.03125898552248))
128	Upper Oxford Township	2	PA	POLYGON((-76.02651422480326 39.80450163320188,-76.02760867714764 39.87795809861806,-75.89297222056955 39.879072898186905,-75.89202111261807 39.80561354988176,-76.02651422480326 39.80450163320188))
129	West Nantmeal Township	2	PA	POLYGON((-75.86592140342798 40.06834828880208,-75.86726509505993 40.17417665423221,-75.77402271050502 40.17483759200485,-75.7728234461796 40.06900676986691,-75.86592140342798 40.06834828880208))
130	Uwchlan Township	2	PA	POLYGON((-75.71805674509805 40.025806816007055,-75.71863308340647 40.0807005182618,-75.61039290519142 40.081321437973315,-75.60990336040454 40.02642653699756,-75.71805674509805 40.025806816007055))
131	Valley Township	2	PA	POLYGON((-75.88204083009003 39.95939159455331,-75.88264575365821 40.00641517276867,-75.80403719379724 40.0069872248235,-75.80348612998745 39.95996270002044,-75.88204083009003 39.95939159455331))
132	West Bradford Township	2	PA	POLYGON((-75.7802262352682 39.91878939131945,-75.7811555349051 40.00050332357737,-75.65075591383852 40.00130888907569,-75.64998171446457 39.919592641523266,-75.7802262352682 39.91878939131945))
133	West Brandywine Township	2	PA	POLYGON((-75.85273645979954 40.000020525219725,-75.85380508689163 40.08573774472667,-75.769593111697 40.08632785738287,-75.76862985807804 40.000608859779454,-75.85273645979954 40.000020525219725))
134	West Nottingham Township	2	PA	POLYGON((-76.13977316241309 39.717989194702085,-76.14069468753412 39.77388838229074,-75.98986724243947 39.77527291455176,-75.98906751311378 39.71937099977986,-76.13977316241309 39.717989194702085))
135	West Caln Township	2	PA	POLYGON((-75.95566471465698 39.98058853222077,-75.95679250797517 40.06137272905409,-75.8208983816825 40.06241537428228,-75.81993072250395 39.98162821592918,-75.95566471465698 39.98058853222077))
136	West Chester Borough	2	PA	POLYGON((-75.62472646077708 39.94492408886458,-75.62500276321542 39.97527844347542,-75.58651482097409 39.9754795791094,-75.58625553090647 39.945125009563704,-75.62472646077708 39.94492408886458))
137	West Goshen Township	2	PA	POLYGON((-75.6460833653962 39.93056019537292,-75.64689031988817 40.016205806934764,-75.54329046523786 40.01673780995149,-75.54261272803025 39.93109059603248,-75.6460833653962 39.93056019537292))
138	West Grove Borough	2	PA	POLYGON((-75.83678331548616 39.81320843898428,-75.83696312213434 39.82803055177469,-75.81979883488849 39.82815310942435,-75.8196227146655 39.813330932608636,-75.83678331548616 39.81320843898428))
139	West Marlborough Township	2	PA	POLYGON((-75.85798063277079 39.84451621965207,-75.85913964929068 39.937411545936186,-75.75306401176087 39.93814908209523,-75.75204806064764 39.84525134541104,-75.85798063277079 39.84451621965207))
140	West Pikeland Township	2	PA	POLYGON((-75.6677105146633 40.05256120873717,-75.66840697038643 40.12380070069798,-75.57727693540598 40.12429080771005,-75.5766754200154 40.05305008844258,-75.6677105146633 40.05256120873717))
141	West Sadsbury Township	2	PA	POLYGON((-75.99945727249907 39.933684123742495,-76.0007144214061 40.019919713093486,-75.92305167596389 40.020564390100795,-75.92189205587121 39.93432684570941,-75.99945727249907 39.933684123742495))
142	East Lansdowne Borough	3	PA	POLYGON((-75.2656992277693 39.93945748049829,-75.26573542495908 39.9488145110044,-75.25520692397477 39.94883816515279,-75.25517216088758 39.93948112685117,-75.2656992277693 39.93945748049829))
143	Westtown Township	2	PA	POLYGON((-75.61383218445012 39.908174295881615,-75.61443243395281 39.97531350485999,-75.49828410171826 39.97587098611726,-75.49779730674054 39.908730460173054,-75.61383218445012 39.908174295881615))
144	West Vincent Township	2	PA	POLYGON((-75.71399625246131 40.078301000246256,-75.71487006205606 40.16178486298474,-75.57248608270727 40.16257641546906,-75.5717862878127 40.07909023080831,-75.71399625246131 40.078301000246256))
145	Millbourne Borough	3	PA	POLYGON((-75.25734581673753 39.961905485285605,-75.25735954002953 39.96556572977096,-75.24718457854517 39.96558787229748,-75.24717139780323 39.96192762495765,-75.25734581673753 39.961905485285605))
146	West Whiteland Township	2	PA	POLYGON((-75.67741859751331 39.985454340771604,-75.67812742011483 40.05708973211431,-75.57135896265487 40.05766546971468,-75.57076172518964 39.98602862803116,-75.67741859751331 39.985454340771604))
147	Willistown Township	2	PA	POLYGON((-75.54955972774324 39.94931195874185,-75.55040557194276 40.05473120679925,-75.42976768357873 40.05524150477161,-75.42910721567996 39.94982036587295,-75.54955972774324 39.94931195874185))
148	Aldan Borough	3	PA	POLYGON((-75.29981125773737 39.91444137205001,-75.29988981071024 39.93244913129274,-75.27423657239677 39.93251264362498,-75.27416473880433 39.91450484410049,-75.29981125773737 39.91444137205001))
149	Aston Township	3	PA	POLYGON((-75.47057952848705 39.84898183394527,-75.470901838152 39.89613099945388,-75.39158209109509 39.896425949659836,-75.39131406826311 39.84927629444832,-75.47057952848705 39.84898183394527))
150	Swedesboro Borough	8	NJ	POLYGON((-75.32151326803194 39.73111624792231,-75.32163201507136 39.75666212731281,-75.29983049283005 39.756720489924525,-75.29971979464206 39.73117455796968,-75.32151326803194 39.73111624792231))
151	Bethel Township	3	PA	POLYGON((-75.54337060648264 39.82444490847483,-75.54374955452968 39.872493821610924,-75.4526587139485 39.872885083753296,-75.45234324280429 39.824835508519456,-75.54337060648264 39.82444490847483))
152	Brookhaven Borough	3	PA	POLYGON((-75.4105883938158 39.85653890335499,-75.41078621563634 39.889708403567134,-75.37490750625666 39.88982993470164,-75.37472696146995 39.85666029250506,-75.4105883938158 39.85653890335499))
153	Chadds Ford Township	3	PA	POLYGON((-75.60554187943164 39.8341834276457,-75.6061622099823 39.90469829138796,-75.53123335239371 39.90506574806439,-75.53068969268122 39.8345499722542,-75.60554187943164 39.8341834276457))
154	Chester City	3	PA	POLYGON((-75.41186599309835 39.81198331602005,-75.41226510918645 39.87874663526016,-75.3365766155857 39.87899097127985,-75.33625077019366 39.81222707771077,-75.41186599309835 39.81198331602005))
155	Chester Township	3	PA	POLYGON((-75.41970517647853 39.837883569074975,-75.41987057787583 39.86503669366138,-75.383214060884 39.86516358848967,-75.38306309884193 39.83801034251286,-75.41970517647853 39.837883569074975))
156	Chester Heights Borough	3	PA	POLYGON((-75.49069549082348 39.8715197836161,-75.49095506904015 39.907916118849165,-75.44817848091395 39.908089332745924,-75.44794151764269 39.87169277549687,-75.49069549082348 39.8715197836161))
157	Clifton Heights Borough	3	PA	POLYGON((-75.30880763182962 39.922328404440314,-75.30887120334064 39.93647459214708,-75.28276642556717 39.93654119534504,-75.2827082267286 39.92239497445355,-75.30880763182962 39.922328404440314))
158	Folcroft Borough	3	PA	POLYGON((-75.292089776372 39.8748512151941,-75.29223474001353 39.908995980791495,-75.25965214121172 39.90907351285904,-75.25952333976508 39.87492865403075,-75.292089776372 39.8748512151941))
159	Collingdale Borough	3	PA	POLYGON((-75.29256566952678 39.90491738276762,-75.29264701325307 39.92403267751407,-75.26207801266271 39.92410579895263,-75.26200516559936 39.90499045497584,-75.29256566952678 39.90491738276762))
160	Colwyn Borough	3	PA	POLYGON((-75.26108372398151 39.90526015848107,-75.2611309099789 39.917687605416376,-75.24602983052907 39.91772062881814,-75.2459853732069 39.9052931674261,-75.26108372398151 39.90526015848107))
161	Glenolden Borough	3	PA	POLYGON((-75.3069216865154 39.88777172765996,-75.30701507394534 39.908702535274266,-75.27832260834111 39.908774948777065,-75.27823794825792 39.887844087774766,-75.3069216865154 39.88777172765996))
162	Concord Township	3	PA	POLYGON((-75.56369569594267 39.83516499097461,-75.56435686580903 39.9158784501682,-75.46030879015056 39.916338165598816,-75.45976950570551 39.83562340059178,-75.56369569594267 39.83516499097461))
163	Darby Borough	3	PA	POLYGON((-75.27698346369928 39.91141647521717,-75.27706408054082 39.93142165727402,-75.24582680671931 39.931492092386705,-75.24575527869449 39.911486860703455,-75.27698346369928 39.91141647521717))
164	Darby Township	3	PA	POLYGON((-75.30715019845725 39.88606981496309,-75.30729457799758 39.918398066860306,-75.24944489554962 39.918536941785774,-75.24932769538621 39.88620853178333,-75.30715019845725 39.88606981496309))
165	Eddystone Borough	3	PA	POLYGON((-75.35002723545033 39.843543563745186,-75.3501512905913 39.86796001546919,-75.31416581539555 39.86806306349394,-75.31405450901265 39.843646523125464,-75.35002723545033 39.843543563745186))
166	Edgmont Township	3	PA	POLYGON((-75.51165865762617 39.920676434923614,-75.51215790887204 39.9876412502659,-75.41958195222995 39.98801334513946,-75.41917293682113 39.921047653130266,-75.51165865762617 39.920676434923614))
167	Haverford Township	3	PA	POLYGON((-75.36714781425769 39.94884767523908,-75.3675471019407 40.02339644160669,-75.2721845907 40.02365966518604,-75.27188889717321 39.949110208651916,-75.36714781425769 39.94884767523908))
168	Lansdowne Borough	3	PA	POLYGON((-75.2910523343178 39.92920321479606,-75.29115079942228 39.952439753766626,-75.26306274251588 39.9525068904696,-75.26297377630895 39.929270296565875,-75.2910523343178 39.92920321479606))
169	Lower Chichester Township	3	PA	POLYGON((-75.45626754365702 39.81250599737726,-75.45639594020005 39.831916372816046,-75.41324410769832 39.832078099564725,-75.41312785004925 39.81266761349474,-75.45626754365702 39.81250599737726))
170	Marple Township	3	PA	POLYGON((-75.41829953998597 39.92692076372459,-75.41875247466353 40.001202777307924,-75.32843543465006 40.001493910950884,-75.32808018461076 39.927211136643976,-75.41829953998597 39.92692076372459))
171	Media Borough	3	PA	POLYGON((-75.40092591650985 39.91104081747017,-75.401036907755 39.93006946260476,-75.37716251624731 39.93014958027849,-75.37705813210117 39.911120881449726,-75.40092591650985 39.91104081747017))
172	Middletown Township	3	PA	POLYGON((-75.49251174089795 39.865121485966434,-75.4931199776935 39.950005990527124,-75.38146631240082 39.95042713980618,-75.38099578504298 39.86554137750837,-75.49251174089795 39.865121485966434))
173	Morton Borough	3	PA	POLYGON((-75.3356849148723 39.90280905875126,-75.33576622968259 39.91946527208016,-75.31843635010823 39.91951415787099,-75.31835923201622 39.90285791586111,-75.3356849148723 39.90280905875126))
174	Nether Providence Township	3	PA	POLYGON((-75.3958734045008 39.86720412423826,-75.39625432194478 39.93336821620916,-75.34677266130855 39.93352676475856,-75.34643930787036 39.867362303579284,-75.3958734045008 39.86720412423826))
175	Lower Frederick Township	4	PA	POLYGON((-75.52325501302512 40.24596612273571,-75.5238063719858 40.31744150530343,-75.4501678777026 40.31775149806149,-75.44969402378263 40.246275337559865,-75.52325501302512 40.24596612273571))
176	Newtown Township	3	PA	POLYGON((-75.45785098776936 39.955288355240214,-75.45835448949438 40.030651769931005,-75.36813660491332 40.03097350773355,-75.3677322012868 39.95560924028268,-75.45785098776936 39.955288355240214))
177	Marlborough Township	4	PA	POLYGON((-75.49558988935743 40.31051446511395,-75.49624584508494 40.40005011775508,-75.39755950318468 40.40043153311006,-75.39703398524259 40.31089468233462,-75.49558988935743 40.31051446511395))
178	Tinicum Township	3	PA	POLYGON((-75.31652483314016 39.84526738276334,-75.31670010774191 39.88340081291004,-75.20902657077649 39.88364484447849,-75.20891088572027 39.84551108657377,-75.31652483314016 39.84526738276334))
179	Norwood Borough	3	PA	POLYGON((-75.30787985570733 39.87409660340492,-75.30799237575826 39.89924667362038,-75.28487460682608 39.899305764868735,-75.28477053218994 39.87415564230529,-75.30787985570733 39.87409660340492))
180	Parkside Borough	3	PA	POLYGON((-75.38297552952139 39.86100108541037,-75.38305076151484 39.87452955612974,-75.37372752890653 39.874559971367795,-75.37365412791088 39.86103148615007,-75.38297552952139 39.86100108541037))
181	Prospect Park Borough	3	PA	POLYGON((-75.31752887420191 39.87419026495395,-75.31763491721225 39.897173504827194,-75.2973024948461 39.89722741053524,-75.29720323960105 39.87424412702018,-75.31752887420191 39.87419026495395))
182	Radnor Township	3	PA	POLYGON((-75.41959613321639 39.986216438545384,-75.42010901966373 40.06987429111527,-75.31600350890587 40.07020503321212,-75.31561771277406 39.98654620788958,-75.41959613321639 39.986216438545384))
183	Ridley Township	3	PA	POLYGON((-75.36142973332562 39.845163359053615,-75.361823445346 39.92010944196012,-75.29510726593877 39.920298427063166,-75.29478614713942 39.84535184567947,-75.36142973332562 39.845163359053615))
184	Ridley Park Borough	3	PA	POLYGON((-75.33859458008628 39.86566303015182,-75.33871234244727 39.88960498952122,-75.30890280899438 39.88968821707043,-75.30879541029029 39.865746187507206,-75.33859458008628 39.86566303015182))
185	Sharon Hill Borough	3	PA	POLYGON((-75.28232227547939 39.898388815660184,-75.28239178671146 39.91532108074529,-75.25377375061393 39.91538724158107,-75.25371128356691 39.89845493703563,-75.28232227547939 39.898388815660184))
186	Thornbury Township	3	PA	POLYGON((-75.56634751513917 39.8844948866398,-75.56692468383501 39.95451953485416,-75.46910047570363 39.954956646547586,-75.4686228890301 39.88493092124924,-75.56634751513917 39.8844948866398))
187	Springfield Township	3	PA	POLYGON((-75.37124123354097 39.88322452661234,-75.37164775730848 39.95846160181779,-75.30339861811628 39.95866030726609,-75.30306674499461 39.883422706039894,-75.37124123354097 39.88322452661234))
188	Swarthmore Borough	3	PA	POLYGON((-75.36340146524037 39.888131539622066,-75.3635456113842 39.915412843359945,-75.33598423682955 39.915495976060974,-75.33585101827286 39.88821459244704,-75.36340146524037 39.888131539622066))
189	Upland Borough	3	PA	POLYGON((-75.39258732276264 39.84941762728901,-75.39266473427888 39.86300278168572,-75.36376483797977 39.86309701182791,-75.36369312358786 39.84951181232198,-75.39258732276264 39.84941762728901))
190	Upper Chichester Township	3	PA	POLYGON((-75.47548342113731 39.81877307451267,-75.47582431358434 39.86817661528482,-75.4009421528906 39.86845962660116,-75.40065490407186 39.81905559340923,-75.47548342113731 39.81877307451267))
191	Upper Frederick Township	4	PA	POLYGON((-75.55630603942919 40.26753811034155,-75.55701965833136 40.35445118719131,-75.46707420316483 40.35484939493963,-75.46647580560693 40.26793510347696,-75.55630603942919 40.26753811034155))
192	Upper Darby Township	3	PA	POLYGON((-75.33553408883729 39.90865619103288,-75.3358729451579 39.97799132999764,-75.24303172049919 39.97822316404135,-75.24278652738887 39.90888745952079,-75.33553408883729 39.90865619103288))
193	Upper Providence Township	3	PA	POLYGON((-75.43595643759875 39.897593836817926,-75.43639317006769 39.966398862030275,-75.36103036994449 39.96665806987379,-75.36066905446785 39.897852417111324,-75.43595643759875 39.897593836817926))
194	Yeadon Borough	3	PA	POLYGON((-75.27459655891482 39.917750867156236,-75.27470377080168 39.94457627525479,-75.23322359866563 39.94466713719256,-75.23313257534652 39.917841643265696,-75.27459655891482 39.917750867156236))
195	Abington Township	4	PA	POLYGON((-75.17639000215526 40.06474554926788,-75.17662283834424 40.154823167192575,-75.05307211917659 40.15494570786078,-75.05300215551188 40.06486770211171,-75.17639000215526 40.06474554926788))
196	Ambler Borough	4	PA	POLYGON((-75.23318500033261 40.144217894438555,-75.23327037199331 40.16917163796892,-75.2116461293833 40.16921318506135,-75.21156867155324 40.14425940507343,-75.23318500033261 40.144217894438555))
197	Bridgeport Borough	4	PA	POLYGON((-75.3576452462647 40.097058313467855,-75.35771471099432 40.11032267893609,-75.32657227931831 40.11041467414713,-75.32650886187271 40.09715026574579,-75.3576452462647 40.097058313467855))
198	Royersford Borough	4	PA	POLYGON((-75.54964581284578 40.173861369159745,-75.5498255789311 40.19613075671463,-75.5253179906493 40.19624456319933,-75.52514623642865 40.173975086532984,-75.54964581284578 40.173861369159745))
199	Cheltenham Township	4	PA	POLYGON((-75.19173542172503 40.042392206071945,-75.19193716450137 40.11428399487049,-75.08327783306756 40.114413092866215,-75.08319030023793 40.04252097781124,-75.19173542172503 40.042392206071945))
200	Collegeville Borough	4	PA	POLYGON((-75.47750369360037 40.17173401876957,-75.47772626491532 40.20346684919097,-75.44560097694163 40.203594969432125,-75.44539337145774 40.17186199608651,-75.47750369360037 40.17173401876957))
201	Conshohocken Borough	4	PA	POLYGON((-75.31750256828417 40.06799258190269,-75.31759721682985 40.08836833591349,-75.28885477356785 40.08844357387005,-75.28876869037973 40.06806776592004,-75.31750256828417 40.06799258190269))
202	Douglass Township	4	PA	POLYGON((-75.65254172644104 40.28201397441327,-75.65370818654631 40.402960651924175,-75.52902930473948 40.40359831822308,-75.52808529023564 40.28264893617406,-75.65254172644104 40.28201397441327))
203	East Greenville Borough	4	PA	POLYGON((-75.51586899606075 40.397497859685565,-75.51599390873686 40.41385729751168,-75.49566483107027 40.413946235044676,-75.49554483919063 40.39758674612159,-75.51586899606075 40.397497859685565))
204	East Norriton Township	4	PA	POLYGON((-75.37926650785047 40.122087513985505,-75.37957895278734 40.178237417191085,-75.29495490984706 40.1784839330429,-75.29471211915887 40.122333543334584,-75.37926650785047 40.122087513985505))
205	Franconia Township	4	PA	POLYGON((-75.42228626115403 40.26886031862064,-75.42275038851604 40.343347902217225,-75.29553833309495 40.34374289139457,-75.2952138627413 40.26925427499074,-75.42228626115403 40.26886031862064))
206	Green Lane Borough	4	PA	POLYGON((-75.47869355850257 40.3309404980759,-75.47877723951524 40.34278037996317,-75.46076356321446 40.34285354068809,-75.4606830303677 40.33101362836579,-75.47869355850257 40.3309404980759))
207	Hatboro Borough	4	PA	POLYGON((-75.12473423727879 40.16304660345312,-75.1247879276917 40.19236210118653,-75.08849372941205 40.19239553368085,-75.0884556546365 40.163080001489526,-75.12473423727879 40.16304660345312))
208	Hatfield Borough	4	PA	POLYGON((-75.30913723196997 40.26587182814154,-75.30923921985507 40.2882626122356,-75.28741176238248 40.28831889093093,-75.28731697299807 40.265928062554316,-75.30913723196997 40.26587182814154))
209	Jenkintown Borough	4	PA	POLYGON((-75.13982789032677 40.08860358557987,-75.13986035197142 40.10446194850228,-75.1197190790748 40.104484517487506,-75.1196912921983 40.088626141972654,-75.13982789032677 40.08860358557987))
210	Hatfield Township	4	PA	POLYGON((-75.3407736734575 40.24328405277534,-75.34111257191631 40.31075721725069,-75.23939281086132 40.311012421302884,-75.23915496906727 40.24353865218951,-75.3407736734575 40.24328405277534))
211	Horsham Township	4	PA	POLYGON((-75.23199742698475 40.15255781160923,-75.2323146425267 40.24556636352185,-75.10145500281968 40.24575506049076,-75.10131646919895 40.152745892309575,-75.23199742698475 40.15255781160923))
212	Lansdale Borough	4	PA	POLYGON((-75.30585162572173 40.22063897211555,-75.30604278834453 40.26310512610069,-75.25188737465353 40.26323567693316,-75.25173003800585 40.22076932815229,-75.30585162572173 40.22063897211555))
213	Limerick Township	4	PA	POLYGON((-75.59854427014115 40.179516240379556,-75.5994761911582 40.285286964922044,-75.46487315042818 40.28590606627147,-75.46415045678204 40.180133043312985,-75.59854427014115 40.179516240379556))
214	Lower Gwynedd Township	4	PA	POLYGON((-75.2830589376963 40.15649417534783,-75.28332877121439 40.22137488347042,-75.19172960598829 40.221562854820604,-75.1915470070577 40.15668171821819,-75.2830589376963 40.15649417534783))
215	Lower Merion Township	4	PA	POLYGON((-75.35529251030115 39.97197388748702,-75.35584357039147 40.07812071333894,-75.20007127775527 40.07849447000639,-75.19976144152405 39.97234624991044,-75.35529251030115 39.97197388748702))
216	Lower Moreland Township	4	PA	POLYGON((-75.09871501902808 40.10291319729329,-75.0988087368248 40.16765236973929,-75.01114229001813 40.167693994148586,-75.01113172179365 40.10295472699628,-75.09871501902808 40.10291319729329))
217	Lower Pottsgrove Township	4	PA	POLYGON((-75.63247260293276 40.21987847948841,-75.63308046135106 40.285140546324435,-75.55605149471371 40.28553637673371,-75.55551758649645 40.220273402647074,-75.63247260293276 40.21987847948841))
218	Lower Providence Township	4	PA	POLYGON((-75.47794457164639 40.097993537620944,-75.4786959436782 40.205098577625826,-75.37006899194168 40.2054968160687,-75.36948811239141 40.098390278266834,-75.47794457164639 40.097993537620944))
219	Lower Salford Township	4	PA	POLYGON((-75.44887233745051 40.222336965546184,-75.4494260796524 40.30606179467694,-75.33361732988341 40.30645371242979,-75.33320626920167 40.22272773134359,-75.44887233745051 40.222336965546184))
220	Montgomery Township	4	PA	POLYGON((-75.27675660704587 40.203858877063105,-75.27705756141948 40.27772926326517,-75.18339749294982 40.277915615616386,-75.18319827528568 40.20404474599318,-75.27675660704587 40.203858877063105))
221	Narberth Borough	4	PA	POLYGON((-75.27370747298312 39.9999744422253,-75.27376393390499 40.01411048123725,-75.2515813187591 40.01416075954908,-75.2515294326447 40.00002469551635,-75.27370747298312 39.9999744422253))
222	New Hanover Township	4	PA	POLYGON((-75.62222553424677 40.25154766312437,-75.6233674769993 40.37584561688957,-75.48944134588697 40.376489980450344,-75.4885447144644 40.25218921771085,-75.62222553424677 40.25154766312437))
223	Telford Borough	4	PA	POLYGON((-75.34237832884095 40.31460607657787,-75.342468439049 40.33243959810911,-75.3160146280582 40.33251489250584,-75.31593147807611 40.31468132379698,-75.34237832884095 40.31460607657787))
224	Pennsburg Borough	4	PA	POLYGON((-75.50874827628896 40.38217231801486,-75.50892111641403 40.40513419082997,-75.4847687868875 40.4052379728102,-75.48460414859048 40.38227601630953,-75.50874827628896 40.38217231801486))
225	Norristown Borough	4	PA	POLYGON((-75.36792951605477 40.102960097456624,-75.36814758264043 40.14340012458601,-75.31430645403567 40.14355877694262,-75.31412027803044 40.10311852421288,-75.36792951605477 40.102960097456624))
226	North Wales Borough	4	PA	POLYGON((-75.2855451185929 40.20273410354943,-75.28561717732313 40.21990192919073,-75.2631985524703 40.21995507702598,-75.2631321495983 40.202787219305044,-75.2855451185929 40.20273410354943))
227	Perkiomen Township	4	PA	POLYGON((-75.49403359908847 40.196951803554974,-75.49455318878331 40.26841741652863,-75.4402888361271 40.26863661135553,-75.43982625313245 40.197170448224114,-75.49403359908847 40.196951803554974))
228	Plymouth Township	4	PA	POLYGON((-75.33072905490792 40.07242886793402,-75.33108757038826 40.14641142287754,-75.256101898293 40.1466015402922,-75.25582457796158 40.07261849102268,-75.33072905490792 40.07242886793402))
229	Pottstown Borough	4	PA	POLYGON((-75.680712449777 40.23062119199726,-75.68110195980229 40.26948761251431,-75.60839096977524 40.2698927553215,-75.60804303524498 40.23102578152092,-75.680712449777 40.23062119199726))
230	Red Hill Borough	4	PA	POLYGON((-75.49407094952095 40.36422132727592,-75.4942357256414 40.3867768232866,-75.47042660263654 40.386876131676445,-75.47026976364677 40.36432055699598,-75.49407094952095 40.36422132727592))
231	Rockledge Borough	4	PA	POLYGON((-75.10061463992737 40.074682995567755,-75.1006321541286 40.08658086678155,-75.08160951645347 40.08659583006514,-75.08159531297635 40.07469795258654,-75.10061463992737 40.074682995567755))
232	Skippack Township	4	PA	POLYGON((-75.46123128220475 40.17164204650242,-75.46183432844916 40.260526708749325,-75.36444388869694 40.260874403895244,-75.36396800353761 40.17198865648268,-75.46123128220475 40.17164204650242))
233	Souderton Borough	4	PA	POLYGON((-75.33621287091705 40.300295337441106,-75.33631874816665 40.32164250069855,-75.30644764031157 40.32172548724226,-75.30635116647558 40.30037826174203,-75.33621287091705 40.300295337441106))
234	Beverly City	6	NJ	POLYGON((-74.933590648396 40.05658976676083,-74.93357518914492 40.07250947418131,-74.91047323519872 40.0724939248925,-74.91049407102356 40.05657422618305,-74.933590648396 40.05658976676083))
235	Springfield Township	4	PA	POLYGON((-75.2622440449246 40.059653270534724,-75.26251791736728 40.13096560761362,-75.16378304286589 40.13114733112649,-75.16361217435801 40.059834538539874,-75.2622440449246 40.059653270534724))
236	Towamencin Township	4	PA	POLYGON((-75.38958110067111 40.21059595015692,-75.38995883356068 40.276457922548175,-75.29358419333376 40.276742579376325,-75.29329980975896 40.210879948522,-75.38958110067111 40.21059595015692))
237	Trappe Borough	4	PA	POLYGON((-75.49768376994955 40.18405844287176,-75.49790380588118 40.21414575535263,-75.4570382300009 40.21431432416012,-75.45683625197222 40.184226833390966,-75.49768376994955 40.18405844287176))
238	Upper Dublin Township	4	PA	POLYGON((-75.23795194684375 40.109080970382344,-75.23824111283149 40.19189269654038,-75.12803632336454 40.19206703323208,-75.12788091755563 40.109254799888035,-75.23795194684375 40.109080970382344))
239	Upper Gwynedd Township	4	PA	POLYGON((-75.33357444437725 40.18274072292187,-75.33388003181838 40.245036851113554,-75.24165359311505 40.24526616987335,-75.24143241457473 40.18296953982578,-75.33357444437725 40.18274072292187))
240	Upper Hanover Township	4	PA	POLYGON((-75.57551150876603 40.33906485535973,-75.57647353372674 40.45196043212611,-75.43932603871406 40.45256302104178,-75.43859286621245 40.339665059034026,-75.57551150876603 40.33906485535973))
241	Bass River Township	6	NJ	POLYGON((-74.54417725258084 39.530076349646876,-74.54249589920052 39.785561867001526,-74.37385362014788 39.78477450223334,-74.37615465848785 39.529296052297525,-74.54417725258084 39.530076349646876))
242	Upper Merion Township	4	PA	POLYGON((-75.46693893710076 40.04921832866017,-75.46743199846922 40.121347088727866,-75.3150231900064 40.121861931434196,-75.31469088601051 40.04973186602107,-75.46693893710076 40.04921832866017))
243	Upper Moreland Township	4	PA	POLYGON((-75.14723945644232 40.124899368027044,-75.14739189529354 40.19543306172773,-75.05598444656847 40.19551335291983,-75.05592654489844 40.124979460234805,-75.14723945644232 40.124899368027044))
244	Upper Pottsgrove Township	4	PA	POLYGON((-75.66742416461469 40.2584176583059,-75.6679004899333 40.3068336897464,-75.60040765569619 40.30720365675025,-75.59997945667756 40.25878699615022,-75.66742416461469 40.2584176583059))
245	Upper Providence Township	4	PA	POLYGON((-75.54601620367634 40.11344562518186,-75.54694823474789 40.229648346429904,-75.43570709205846 40.23012057158142,-75.43496460581565 40.113915923944106,-75.54601620367634 40.11344562518186))
246	Upper Salford Township	4	PA	POLYGON((-75.47924119759166 40.25236033234367,-75.47982589351906 40.33507679980244,-75.402255617382 40.33537256321331,-75.40176543857623 40.25265523702839,-75.47924119759166 40.25236033234367))
247	West Conshohocken Borough	4	PA	POLYGON((-75.33020313601124 40.060759251591016,-75.33030189385511 40.08120711412232,-75.30508313804675 40.08127627483439,-75.30499192012924 40.06082836254315,-75.33020313601124 40.060759251591016))
248	Wrightstown Borough	6	NJ	POLYGON((-74.66222119305014 39.99015524935649,-74.66195912222607 40.043289895245024,-74.59957038376145 40.04309108385345,-74.59988081940902 39.98995680957342,-74.66222119305014 39.99015524935649))
249	West Norriton Township	4	PA	POLYGON((-75.42771626000639 40.105216759354974,-75.42804773108057 40.15807399971265,-75.3419644361354 40.15836022917885,-75.34169962257648 40.10550245697712,-75.42771626000639 40.105216759354974))
250	West Pottsgrove Township	4	PA	POLYGON((-75.69969428026472 40.23374959506461,-75.70020446790515 40.28325762795467,-75.64574724939949 40.283574372835915,-75.645276733744 40.234065789078684,-75.69969428026472 40.23374959506461))
251	Medford Lakes Borough	6	NJ	POLYGON((-74.82088239338738 39.846542031319615,-74.8208225436416 39.86955997569469,-74.78517231210108 39.8694994273666,-74.78524406971006 39.84648153209377,-74.82088239338738 39.846542031319615))
252	Whitemarsh Township	4	PA	POLYGON((-75.30465755249733 40.049179521556496,-75.30513079089135 40.15519572168837,-75.1903919934608 40.15544122686041,-75.19009670422153 40.049424112467804,-75.30465755249733 40.049179521556496))
253	Whitpain Township	4	PA	POLYGON((-75.33135046005323 40.11826731421496,-75.3317314236571 40.196598460981676,-75.22272591078209 40.1968595019277,-75.22247012703883 40.11852763679415,-75.33135046005323 40.11826731421496))
254	Worcester Township	4	PA	POLYGON((-75.41552480784672 40.15205635747842,-75.41601780202888 40.23278596962648,-75.28860781777995 40.23317380455247,-75.2882658022127 40.152443092704544,-75.41552480784672 40.15205635747842))
255	Burlington City	6	NJ	POLYGON((-74.88337512253004 40.06076634023438,-74.88330253748931 40.10329453415738,-74.82761138174423 40.10322503727066,-74.82771860596091 40.060696947295575,-74.88337512253004 40.06076634023438))
256	Bordentown City	6	NJ	POLYGON((-74.72138146666174 40.1370736914042,-74.7212813464137 40.161572709545354,-74.6992022100863 40.1615174571356,-74.69931026123656 40.13701848659734,-74.72138146666174 40.1370736914042))
257	Bordentown Township	6	NJ	POLYGON((-74.77960230989873 40.10990905730714,-74.77935188262086 40.18734715429021,-74.66965950922858 40.18708612628962,-74.67003442861255 40.10964873949158,-74.77960230989873 40.10990905730714))
258	Springfield Township	6	NJ	POLYGON((-74.81903037962188 39.987245507289074,-74.81878273260554 40.08087790359368,-74.61384705198934 40.08037604554041,-74.61437474658146 39.98674530087698,-74.81903037962188 39.987245507289074))
259	Mount Ephraim Borough	7	NJ	POLYGON((-75.10942495525492 39.87153642982144,-75.10945624385477 39.891218151197656,-75.07857827361696 39.891243182372705,-75.07855581160865 39.87156144364094,-75.10942495525492 39.87153642982144))
260	Burlington Township	6	NJ	POLYGON((-74.9056803637859 40.02002194644532,-74.9055347163746 40.12552489751499,-74.79091184505704 40.125374681788124,-74.7912342167544 40.019872287515255,-74.9056803637859 40.02002194644532))
261	Chesterfield Township	6	NJ	POLYGON((-74.70718578161947 40.05086716489411,-74.70665855206745 40.173696651387885,-74.58830017497361 40.17333628094049,-74.58904012034237 40.05050834873005,-74.70718578161947 40.05086716489411))
262	Cinnaminson Township	6	NJ	POLYGON((-75.03567510829271 39.96399496861439,-75.0357149442304 40.04049398637584,-74.9538918533404 40.04049031681458,-74.95394328169847 39.96399130892496,-75.03567510829271 39.96399496861439))
263	Delanco Township	6	NJ	POLYGON((-74.98915826009116 40.0268206913444,-74.98915125942429 40.070994852325235,-74.92243131466563 40.070969392141805,-74.9224813694967 40.02679527072308,-74.98915826009116 40.0268206913444))
264	Pennington Borough	9	NJ	POLYGON((-74.80227268632588 40.3141072246741,-74.80220271762389 40.33808178641663,-74.77582944638922 40.33803368211306,-74.77590874417857 40.3140591608856,-74.80227268632588 40.3141072246741))
265	Delran Township	6	NJ	POLYGON((-74.99362173639899 39.98929247952232,-74.99361656818837 40.04478340625998,-74.90164009468867 40.04474183403408,-74.90171972955093 39.9892509884437,-74.99362173639899 39.98929247952232))
266	Eastampton Township	6	NJ	POLYGON((-74.78297645767452 39.97467261077436,-74.78279410382906 40.03224224084992,-74.72975094524855 40.03213067437489,-74.72997782995469 39.97456127024095,-74.78297645767452 39.97467261077436))
267	Tabernacle Township	6	NJ	POLYGON((-74.77743933659086 39.74078007278537,-74.77696395380018 39.88801822110788,-74.53330139052278 39.887293682195704,-74.53429608596956 39.740059285181225,-74.77743933659086 39.74078007278537))
268	Edgewater Park Township	6	NJ	POLYGON((-74.93651437780845 40.0306999473643,-74.93647259784788 40.07571432865189,-74.88673557547129 40.07567637772738,-74.88681006576348 40.030662056530204,-74.93651437780845 40.0306999473643))
269	Oaklyn Borough	7	NJ	POLYGON((-75.0956091935131 39.8936263760787,-75.09563317238762 39.91087711208394,-75.06987546788349 39.91089549334347,-75.06985794743024 39.89364474616863,-75.0956091935131 39.8936263760787))
270	Evesham Township	6	NJ	POLYGON((-74.96634932994748 39.77460111993997,-74.96627492913957 39.926807840209776,-74.85359981342734 39.9267203231724,-74.85392278524428 39.77451407116757,-74.96634932994748 39.77460111993997))
271	Fieldsboro Borough	6	NJ	POLYGON((-74.74188227190878 40.13101052374056,-74.74183887544278 40.14247909707239,-74.72286220336073 40.14243523685624,-74.72290878967844 40.13096668121922,-74.74188227190878 40.13101052374056))
272	North Hanover Township	6	NJ	POLYGON((-74.63432995912868 40.03347321308318,-74.63373725624213 40.14414626247944,-74.53336406202503 40.14378529112969,-74.53411918055114 40.03311364502493,-74.63432995912868 40.03347321308318))
273	Florence Township	6	NJ	POLYGON((-74.83322477874991 40.05733569291246,-74.83304401465965 40.13134916270855,-74.74967879171666 40.13119897505279,-74.74994981384421 40.05718589595793,-74.83322477874991 40.05733569291246))
274	Hainesport Township	6	NJ	POLYGON((-74.86617310371898 39.94035500660617,-74.86605204316257 40.00240295001103,-74.79738815678132 40.00230325322892,-74.79757127407625 39.94025552745994,-74.86617310371898 39.94035500660617))
275	Brooklawn Borough	7	NJ	POLYGON((-75.13284418586929 39.87207741127373,-75.13286901625067 39.88494507528577,-75.10753321208722 39.88497133267276,-75.10751311640168 39.872103656756394,-75.13284418586929 39.87207741127373))
276	Lumberton Township	6	NJ	POLYGON((-74.86625025300393 39.928307776107836,-74.86612760398278 39.99123171274861,-74.74636627194052 39.99103151611513,-74.74659863975221 39.928108022693856,-74.86625025300393 39.928307776107836))
277	Washington Township	6	NJ	POLYGON((-74.73839936026243 39.5456466492075,-74.73750572843603 39.78223522180497,-74.41433712024539 39.78105432508307,-74.41633083234669 39.54447557106256,-74.73839936026243 39.5456466492075))
278	Mansfield Township	6	NJ	POLYGON((-74.77711687802308 40.047780989819096,-74.77684543886527 40.130952040303306,-74.63394659800369 40.1305885249381,-74.63439184783779 40.047418536972856,-74.77711687802308 40.047780989819096))
279	Maple Shade Township	6	NJ	POLYGON((-75.02224589295325 39.925073950762226,-75.02226216915541 39.97530092881545,-74.96382757529665 39.97529742272382,-74.96385402148866 39.925070450868304,-75.02224589295325 39.925073950762226))
280	Medford Township	6	NJ	POLYGON((-74.87314366312961 39.77808291681165,-74.87283873273024 39.943484675507776,-74.74494776636287 39.94327387029531,-74.74555937091726 39.777873336940615,-74.87314366312961 39.77808291681165))
281	Moorestown Township	6	NJ	POLYGON((-75.01033833478557 39.934219560474084,-75.01035095955561 40.017953274958415,-74.8771783187907 40.0178886523048,-74.87732812043622 39.93415512811607,-75.01033833478557 39.934219560474084))
282	Mount Holly Township	6	NJ	POLYGON((-74.80812311304086 39.97781999669293,-74.80802529122522 40.01276593580184,-74.76552556801498 40.01268774210241,-74.76564504536931 39.97774189916198,-74.80812311304086 39.97781999669293))
283	Mount Laurel Township	6	NJ	POLYGON((-74.98966175806932 39.9100306901155,-74.9896473930017 40.00536208944595,-74.84274655195424 40.00525586817489,-74.8429647525621 39.909924824928304,-74.98966175806932 39.9100306901155))
284	New Hanover Township	6	NJ	POLYGON((-74.65379897197838 39.985577664031574,-74.65341401220351 40.06169761387426,-74.50140500026762 40.061143153704165,-74.50195878497387 39.985024687878756,-74.65379897197838 39.985577664031574))
285	Hopewell Borough	9	NJ	POLYGON((-74.77826698355157 40.380353772792674,-74.7782067390474 40.398720858844804,-74.75019031742038 40.39866372714814,-74.75025817169167 40.380296677949865,-74.77826698355157 40.380353772792674))
286	Palmyra Borough	6	NJ	POLYGON((-75.06240650449354 39.98966448081085,-75.06243217375527 40.01785215830348,-75.0087829084837 40.017868642418854,-75.00877929734959 39.989680948572435,-75.06240650449354 39.98966448081085))
287	Pemberton Borough	6	NJ	POLYGON((-74.6990064255173 39.965607925374336,-74.69895334552933 39.97770811907489,-74.67367623224702 39.97763971527415,-74.6737337688635 39.965539550719384,-74.6990064255173 39.965607925374336))
288	Newfield Borough	8	NJ	POLYGON((-75.03583027710513 39.53633253110109,-75.03584334017451 39.56172551394753,-75.00101441068016 39.56173103662808,-75.00101404097911 39.536338048830956,-75.03583027710513 39.53633253110109))
289	Pemberton Township	6	NJ	POLYGON((-74.74366460617497 39.89366308317063,-74.74320301045836 40.01719267491671,-74.46222606472014 40.0162294270928,-74.46319267621135 39.89270401749386,-74.74366460617497 39.89366308317063))
290	Woodlynne Borough	7	NJ	POLYGON((-75.1024767270959 39.91299459328579,-75.10248922158743 39.92137700500384,-75.08958943283429 39.92138768908686,-75.08957851095435 39.9130052742139,-75.1024767270959 39.91299459328579))
291	Riverside Township	6	NJ	POLYGON((-74.97439286929504 40.02297169268862,-74.97438442969826 40.045534002218254,-74.93561385217755 40.045518944642254,-74.93563506555421 40.02295664706881,-74.97439286929504 40.02297169268862))
292	Riverton Borough	6	NJ	POLYGON((-75.03179070031032 40.001763042408754,-75.03179991920422 40.02163123549339,-74.99623674750296 40.021635537455104,-74.99623783848159 40.00176734136191,-75.03179070031032 40.001763042408754))
293	Shamong Township	6	NJ	POLYGON((-74.82247759894534 39.716235185811136,-74.8221360360573 39.849029916134626,-74.61884473981722 39.84854010391178,-74.61957667838814 39.71574766188503,-74.82247759894534 39.716235185811136))
294	Southampton Township	6	NJ	POLYGON((-74.79921070334056 39.856376824611395,-74.79882535293548 39.988178412402526,-74.58817673434183 39.98762138887937,-74.58896556193558 39.8558223816515,-74.79921070334056 39.856376824611395))
295	Westampton Township	6	NJ	POLYGON((-74.87562468462198 39.99199074481054,-74.87552526175415 40.04673041116418,-74.76804273579091 40.046565092878424,-74.76822800773883 39.99182574484957,-74.87562468462198 39.99199074481054))
296	Willingboro Township	6	NJ	POLYGON((-74.93606569273558 39.994869821533754,-74.93600411200813 40.06080162757332,-74.84773130498944 40.06071924139677,-74.84787782660199 39.99478762638164,-74.93606569273558 39.994869821533754))
297	Woodland Township	6	NJ	POLYGON((-74.66760795709425 39.75370676679038,-74.66674552256174 39.932337422485645,-74.37776663091323 39.9311467150118,-74.37937682854744 39.75252353307397,-74.66760795709425 39.75370676679038))
298	Lawnside Borough	7	NJ	POLYGON((-75.04860723414812 39.856670080458265,-75.0486244737676 39.88109306446332,-75.01122953928251 39.881102713265605,-75.0112255578909 39.85667972095892,-75.04860723414812 39.856670080458265))
299	Audubon Borough	7	NJ	POLYGON((-75.09262222761886 39.88049355297857,-75.09265180117953 39.90246296960236,-75.05019091455914 39.90248911962343,-75.05017489408392 39.88051968276298,-75.09262222761886 39.88049355297857))
300	Audubon Park Borough	7	NJ	POLYGON((-75.09472779763236 39.89321455233888,-75.09473851628432 39.900999408971686,-75.08299404998638 39.90100840853319,-75.08298466009144 39.89322354943201,-75.09472779763236 39.89321455233888))
301	Barrington Borough	7	NJ	POLYGON((-75.06912678288806 39.8526981830398,-75.06916028845414 39.886072043721285,-75.03514118157744 39.886087340294736,-75.03512415698059 39.85271346163187,-75.06912678288806 39.8526981830398))
302	Bellmawr Borough	7	NJ	POLYGON((-75.1253377605597 39.85231907901851,-75.12538682172135 39.879275792934344,-75.0584690933136 39.87932883026964,-75.0584462155601 39.85237206598863,-75.1253377605597 39.85231907901851))
303	Berlin Borough	7	NJ	POLYGON((-74.96827352715934 39.77474279970956,-74.9682568658517 39.81100026195505,-74.90569354465049 39.81096628073669,-74.90574304405857 39.774708861907285,-74.96827352715934 39.77474279970956))
304	Berlin Township	7	NJ	POLYGON((-74.96011238226164 39.78202521030655,-74.9600885195759 39.82331321863295,-74.89988839180558 39.82327689340545,-74.8999482474595 39.78198893792121,-74.96011238226164 39.78202521030655))
305	Camden City	7	NJ	POLYGON((-75.14132108806939 39.89499810856863,-75.14148134868857 39.97287641077244,-75.06201893228564 39.97294615995082,-75.06194868115244 39.895067666647385,-75.14132108806939 39.89499810856863))
306	Cherry Hill Township	7	NJ	POLYGON((-75.07183866647665 39.854621751589505,-75.07194766730505 39.95890282358542,-74.92096024022064 39.95889820519968,-74.92107998555426 39.854617150142175,-75.07183866647665 39.854621751589505))
307	Chesilhurst Borough	7	NJ	POLYGON((-74.896454326199 39.718456118439555,-74.89641574993786 39.74423609927426,-74.85808529019073 39.74419556815297,-74.85813814116419 39.718415624160016,-74.896454326199 39.718456118439555))
308	Clementon Borough	7	NJ	POLYGON((-75.00505594994911 39.792291752302006,-75.00505767622872 39.815857715124274,-74.96429131892727 39.815852330722954,-74.96430350696573 39.792286372372686,-75.00505594994911 39.792291752302006))
309	Collingswood Borough	7	NJ	POLYGON((-75.09731176420195 39.90353625820344,-75.09734511785624 39.92709948055256,-75.05486364265056 39.92712736293794,-75.05484484452886 39.90356411745033,-75.09731176420195 39.90353625820344))
311	Gloucester Township	7	NJ	POLYGON((-75.09683011161644 39.71960025215631,-75.09702557119418 39.85888005001162,-74.96019875828885 39.85891379891461,-74.96027893865919 39.71963383571673,-75.09683011161644 39.71960025215631))
312	Gloucester City City	7	NJ	POLYGON((-75.14090428646465 39.876401102069956,-75.14097321977084 39.910057727606294,-75.09432643728783 39.9101050523863,-75.09428031329581 39.87644837075635,-75.14090428646465 39.876401102069956))
313	Haddon Township	7	NJ	POLYGON((-75.10619659064824 39.88662325187784,-75.10626047924531 39.927988619989925,-75.03526127938039 39.92803194810007,-75.03524007866422 39.88666651688308,-75.10619659064824 39.88662325187784))
314	Haddonfield Borough	7	NJ	POLYGON((-75.0544249170417 39.87026348344237,-75.05446328097531 39.918750470288515,-75.01361080434718 39.91876246164773,-75.01360121689157 39.87027545433096,-75.0544249170417 39.87026348344237))
315	Haddon Heights Borough	7	NJ	POLYGON((-75.08679025395988 39.868193918479896,-75.08681892603495 39.89093442148869,-75.04455752558779 39.89095835769784,-75.04454281038436 39.86821783551423,-75.08679025395988 39.868193918479896))
316	Laurel Springs Borough	7	NJ	POLYGON((-75.01571928357433 39.815816284358576,-75.01572189168174 39.8272618592471,-74.99396257814766 39.827262767366285,-74.9939635796967 39.8158171921114,-75.01571928357433 39.815816284358576))
317	Merchantville Borough	7	NJ	POLYGON((-75.0663029214487 39.9453124045619,-75.06631510432072 39.95792915443835,-75.03463907627379 39.95794294644236,-75.03463271266008 39.94532619043776,-75.0663029214487 39.9453124045619))
318	Lindenwold Borough	7	NJ	POLYGON((-75.03034998152673 39.79789109435805,-75.03036784930512 39.8384995871426,-74.95139820824386 39.838493381409215,-74.95142680446686 39.79788489750276,-75.03034998152673 39.79789109435805))
319	Magnolia Borough	7	NJ	POLYGON((-75.05069834402993 39.84834125779783,-75.0507096531863 39.86370990622485,-75.0210306473361 39.86371908390887,-75.02102595712492 39.84835043051174,-75.05069834402993 39.84834125779783))
320	Pennsauken Township	7	NJ	POLYGON((-75.12668394621925 39.92161145963233,-75.12682839279742 39.99984037078185,-75.00536901773081 39.99990963948535,-75.00536290286374 39.92168053773155,-75.12668394621925 39.92161145963233))
321	Pine Hill Borough	7	NJ	POLYGON((-75.02613815538318 39.765182316769284,-75.02615410022 39.80730725898805,-74.94534631052481 39.80729733561391,-74.94537963010934 39.76517240812461,-75.02613815538318 39.765182316769284))
322	Runnemede Borough	7	NJ	POLYGON((-75.1043127737855 39.83939800236456,-75.10434868932694 39.86312217812529,-75.04703508658118 39.863159576805835,-75.04701889765165 39.839435369784724,-75.1043127737855 39.83939800236456))
323	Somerdale Borough	7	NJ	POLYGON((-75.04081728441804 39.832965094177865,-75.04083366341644 39.86061836793231,-74.99984855783477 39.860625554853826,-74.99984861858051 39.83297227409745,-75.04081728441804 39.832965094177865))
324	Stratford Borough	7	NJ	POLYGON((-75.04030823929278 39.81781751781761,-75.04032281818367 39.84275759066796,-74.99219989252803 39.842764335989386,-74.99220271269184 39.8178242572112,-75.04030823929278 39.81781751781761))
325	Tavistock Borough	7	NJ	POLYGON((-75.03775094380674 39.872114465754166,-75.03775610264589 39.8815229755223,-75.01787442090168 39.88152774350592,-75.01787197861348 39.87211923215712,-75.03775094380674 39.872114465754166))
326	Voorhees Township	7	NJ	POLYGON((-75.02218025028499 39.80645328522722,-75.02220295211309 39.87697796351223,-74.90426170389341 39.87694057671733,-74.90435959315192 39.80641599125932,-75.02218025028499 39.80645328522722))
327	Waterford Township	7	NJ	POLYGON((-74.92077694863724 39.66919918148499,-74.92063068034506 39.79685693664406,-74.72840002763226 39.796566245320896,-74.72890054749942 39.66890979621948,-74.92077694863724 39.66919918148499))
328	Winslow Township	7	NJ	POLYGON((-75.02709323369399 39.59961003900587,-75.02716920718495 39.79365624244232,-74.78840366490374 39.79346651621109,-74.78899534831176 39.59942160730626,-75.02709323369399 39.59961003900587))
329	Clayton Borough	8	NJ	POLYGON((-75.12365187190969 39.63859777531966,-75.12372902423985 39.68187787566372,-75.02914899077278 39.68194012946845,-75.02913081460781 39.63865993410893,-75.12365187190969 39.63859777531966))
330	Deptford Township	8	NJ	POLYGON((-75.17815435887108 39.76372372147312,-75.17842391170272 39.86804810265072,-75.06883852604639 39.868164902944464,-75.06873452809387 39.76384009296219,-75.17815435887108 39.76372372147312))
331	East Greenwich Township	8	NJ	POLYGON((-75.29188404733246 39.754527372386086,-75.2921990772058 39.829025327835986,-75.1834272626699 39.829248280060696,-75.18322950135594 39.754749739709595,-75.29188404733246 39.754527372386086))
332	Elk Township	8	NJ	POLYGON((-75.22208864590345 39.61581814915892,-75.22240120624127 39.71338633736435,-75.09469613481376 39.713560723155474,-75.0945630487605 39.61599193552918,-75.22208864590345 39.61581814915892))
333	Greenwich Township	8	NJ	POLYGON((-75.3487260278405 39.789749843855375,-75.34905322657373 39.8544477724495,-75.23247183451709 39.85473998404585,-75.23225391492849 39.79004138971226,-75.3487260278405 39.789749843855375))
334	Franklin Township	8	NJ	POLYGON((-75.14331601531063 39.507407940283315,-75.14365131600604 39.66996823802926,-74.90222776055445 39.6700159231242,-74.90245597408058 39.50745535246019,-75.14331601531063 39.507407940283315))
335	Glassboro Borough	8	NJ	POLYGON((-75.17139447987101 39.67442743026434,-75.17155786491573 39.7404288065056,-75.04967878724315 39.74054494358156,-75.04963147483772 39.67454329722174,-75.17139447987101 39.67442743026434))
336	Harrison Township	8	NJ	POLYGON((-75.2807443820118 39.68082936824212,-75.28109018221656 39.76604932542441,-75.1346022632964 39.766311645119515,-75.13443667208162 39.68109090050945,-75.2807443820118 39.68082936824212))
337	Logan Township	8	NJ	POLYGON((-75.43507859411368 39.74053870971954,-75.4357517357169 39.847297180846496,-75.28022403073838 39.84777712292896,-75.2797911358268 39.74101684850882,-75.43507859411368 39.74053870971954))
338	National Park Borough	8	NJ	POLYGON((-75.20192612279241 39.855578888497206,-75.2020010987291 39.88114731772348,-75.16745134636496 39.881202344303475,-75.16738919396009 39.855633865513724,-75.20192612279241 39.855578888497206))
339	Mantua Township	8	NJ	POLYGON((-75.23429012867909 39.71067417939976,-75.23460388418914 39.803213001628116,-75.1084186803931 39.80339950605954,-75.10827368169925 39.710860076116454,-75.23429012867909 39.71067417939976))
340	Monroe Township	8	NJ	POLYGON((-75.10099785764308 39.57109419908332,-75.10123413003807 39.73327263768901,-74.8675356404319 39.73324120397939,-74.86784480123812 39.571062944781595,-75.10099785764308 39.57109419908332))
341	Paulsboro Borough	8	NJ	POLYGON((-75.2590984646001 39.817547127467755,-75.25926239740397 39.86115513130858,-75.22059012565246 39.86123511910582,-75.2204506449784 39.81762699240284,-75.2590984646001 39.817547127467755))
342	Pitman Borough	8	NJ	POLYGON((-75.1522782932499 39.71759502022673,-75.15235163693028 39.75091846157385,-75.1115463042138 39.75096484539627,-75.11149260453243 39.717641349558754,-75.1522782932499 39.71759502022673))
343	South Harrison Township	8	NJ	POLYGON((-75.32404343380554 39.65755872379617,-75.32441910130154 39.737844812920066,-75.2027055018717 39.73812114586153,-75.2024707719854 39.65783427506832,-75.32404343380554 39.65755872379617))
344	Washington Township	8	NJ	POLYGON((-75.13582024441675 39.702743760258464,-75.13602945146125 39.80917559634576,-75.00951813891952 39.80925493913582,-75.0095035004047 39.70282280577139,-75.13582024441675 39.702743760258464))
345	Wenonah Borough	8	NJ	POLYGON((-75.16181484932147 39.77961497307115,-75.16187126042857 39.803686988507266,-75.13670695784856 39.80371936290146,-75.13665931626856 39.77964731999744,-75.16181484932147 39.77961497307115))
346	West Deptford Township	8	NJ	POLYGON((-75.24265669900207 39.79049525255622,-75.24300015525297 39.88801133314553,-75.12404045940481 39.88819956873816,-75.12386513915425 39.79068284220487,-75.24265669900207 39.79049525255622))
347	Westville Borough	8	NJ	POLYGON((-75.14706340249207 39.854712660364584,-75.14713735531525 39.88933373265512,-75.11068658543341 39.889374248059276,-75.11063095305458 39.85475312636425,-75.14706340249207 39.854712660364584))
348	Woodbury City	8	NJ	POLYGON((-75.17310569015147 39.82261595407474,-75.1731912928195 39.856701326433445,-75.13321004332495 39.85675412835309,-75.13314420188873 39.82266869259021,-75.17310569015147 39.82261595407474))
349	Woodbury Heights Borough	8	NJ	POLYGON((-75.16711927582178 39.805133343856774,-75.16717366322791 39.827585647237605,-75.13448258895713 39.82762814492381,-75.1344388370067 39.805175807916555,-75.16711927582178 39.805133343856774))
350	Hightstown Borough	9	NJ	POLYGON((-74.53899792954189 40.25646839850764,-74.53883819841455 40.279991044869604,-74.51240239995556 40.279882663543766,-74.51257128670545 40.25636010677457,-74.53899792954189 40.25646839850764))
351	Woolwich Township	8	NJ	POLYGON((-75.38468220977701 39.6841183567494,-75.38531431407867 39.797711212739664,-75.25847048043431 39.79806306196465,-75.25804645516631 39.68446879902073,-75.38468220977701 39.6841183567494))
352	East Windsor Township	9	NJ	POLYGON((-74.58626318257068 40.21264911376171,-74.5856974617398 40.30546004543826,-74.47513416996894 40.30501127669304,-74.47585084741482 40.21220180701443,-74.58626318257068 40.21264911376171))
353	Ewing Township	9	NJ	POLYGON((-74.860634295765 40.23010204742224,-74.86050261500813 40.294243374018215,-74.74415544812874 40.29404459911049,-74.7443969543762 40.22990372026577,-74.860634295765 40.23010204742224))
354	Hamilton Township	9	NJ	POLYGON((-74.76183044843823 40.13051892498648,-74.76131452130461 40.27778462714751,-74.57826232894547 40.2772622400911,-74.57917390758223 40.12999923656894,-74.76183044843823 40.13051892498648))
355	Hopewell Township	9	NJ	POLYGON((-74.95256667151068 40.270403168606336,-74.95245349351073 40.43175252766428,-74.70331498352388 40.43138162686006,-74.70402118964809 40.2700343647854,-74.95256667151068 40.270403168606336))
356	Lawrence Township	9	NJ	POLYGON((-74.77033188118288 40.23392936802316,-74.76988921075073 40.36453596364681,-74.65631208341203 40.364254218215656,-74.65697323655198 40.23364891309052,-74.77033188118288 40.23392936802316))
357	Princeton	9	NJ	POLYGON((-74.7280763593203 40.3006717488446,-74.72769503928798 40.39555457129782,-74.61174371160682 40.39522338578309,-74.61228739469684 40.300341665739424,-74.7280763593203 40.3006717488446))
358	Robbinsville Township	9	NJ	POLYGON((-74.65592091327646 40.17529107398325,-74.65543741622697 40.270791693610875,-74.53000575175766 40.270350215790785,-74.53066524335073 40.17485107633534,-74.65592091327646 40.17529107398325))
359	Trenton City	9	NJ	POLYGON((-74.82358201497657 40.18078419154499,-74.82339809147693 40.25166892934795,-74.72450348671862 40.25147576204676,-74.72479040221086 40.180591505183344,-74.82358201497657 40.18078419154499))
360	West Windsor Township	9	NJ	POLYGON((-74.69148973339263 40.236807446564185,-74.6909819660163 40.34837608006769,-74.56032167612578 40.347953198293666,-74.56104412549816 40.2363862200176,-74.69148973339263 40.236807446564185))
\.


--
-- Data for Name: link; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.link (id, link, type) FROM stdin;
\.


--
-- Data for Name: municipality; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.municipality (geoid, buffer_bbox, mun_name, county, state) FROM stdin;
4201704976	POLYGON((-75.26255154482685 40.35769570951717,-75.26303011527256 40.48069139792641,-75.1091131225946 40.480939185609806,-75.10891459429523 40.35794242896758,-75.26255154482685 40.35769570951717))	Bedminster Township	Bucks	Pennsylvania
4201705616	POLYGON((-75.00148865852142 40.043679615018405,-75.00149122010927 40.16111066796855,-74.89133628374017 40.161059689585976,-74.89152294363547 40.043628846876466,-75.00148865852142 40.043679615018405))	Bensalem Township	Bucks	Pennsylvania
4201708592	POLYGON((-75.15363013346503 40.52771330286835,-75.1537451801633 40.57803240295161,-75.08173966126289 40.57810579308871,-75.08167849569996 40.52778656349834,-75.15363013346503 40.52771330286835))	Bridgeton Township	Bucks	Pennsylvania
4201708760	POLYGON((-74.87650947160728 40.09096813102292,-74.87645862635715 40.11908251014379,-74.83241964405568 40.11902716184115,-74.83248861401037 40.09091283745406,-74.87650947160728 40.09096813102292))	Bristol Borough	Bucks	Pennsylvania
4201712504	POLYGON((-75.22740098815547 40.27616318294177,-75.227494991461 40.304204886838704,-75.18852286657254 40.3042749554983,-75.18844496669956 40.276233182566095,-75.22740098815547 40.27616318294177))	Chalfont Borough	Bucks	Pennsylvania
4201708768	POLYGON((-74.9219605970039 40.06541548082246,-74.92182882291014 40.180568076736364,-74.81179419577131 40.18044149396512,-74.81211145467631 40.065289409919835,-74.9219605970039 40.06541548082246))	Bristol Township	Bucks	Pennsylvania
4201709816	POLYGON((-75.14005911569002 40.24954890265329,-75.14034295397828 40.38677384652006,-74.97316528243283 40.38685589356816,-74.97321955483729 40.249630554939266,-75.14005911569002 40.24954890265329))	Buckingham Township	Bucks	Pennsylvania
4201719784	POLYGON((-75.14994057882667 40.29660831073017,-75.15001278140605 40.32924627295137,-75.10362738928275 40.32929712601904,-75.10357751231497 40.29665910549493,-75.14994057882667 40.29660831073017))	Doylestown Borough	Bucks	Pennsylvania
4201719792	POLYGON((-75.19797247179261 40.25723268697315,-75.19822926056403 40.34514785868697,-75.07706405420751 40.3452920471944,-75.07696422375093 40.25737643059005,-75.19797247179261 40.25723268697315))	Doylestown Township	Bucks	Pennsylvania
4201736192	POLYGON((-74.91936905313088 40.132007314015645,-74.91934788968928 40.14990820195252,-74.8970001101187 40.14989048045125,-74.89702713768598 40.13198960367224,-74.91936905313088 40.132007314015645))	Hulmeville Borough	Bucks	Pennsylvania
4201720104	POLYGON((-75.21522765654676 40.365043670409165,-75.21528625025266 40.38345739508928,-75.19208880403744 40.383498253856786,-75.19203652379905 40.36508450275072,-75.21522765654676 40.365043670409165))	Dublin Borough	Bucks	Pennsylvania
4201720480	POLYGON((-75.26059096015905 40.53880649582372,-75.2608518422782 40.606020927316244,-75.16379797925696 40.606199337106155,-75.16363416089675 40.538984485245834,-75.26059096015905 40.53880649582372))	Durham Township	Bucks	Pennsylvania
4201721760	POLYGON((-75.34175904993542 40.364335161851486,-75.34223948917699 40.45923808026894,-75.23914222238578 40.45949734463741,-75.23880650804783 40.36459356333842,-75.34175904993542 40.364335161851486))	East Rockhill Township	Bucks	Pennsylvania
4201737304	POLYGON((-75.08064856017087 40.199873286511945,-75.08066807327049 40.216335500088356,-75.06521551473044 40.216345237528444,-75.06519973950033 40.199883018315994,-75.08064856017087 40.199873286511945))	Ivyland Borough	Bucks	Pennsylvania
4201725112	POLYGON((-74.87854994124756 40.116006887095686,-74.87836078827036 40.222052034641656,-74.71448717738963 40.22176381774664,-74.71493115322285 40.11571974336971,-74.87854994124756 40.116006887095686))	Falls Township	Bucks	Pennsylvania
4201733224	POLYGON((-75.30845822566705 40.424698061579505,-75.30890166447116 40.52153650118335,-75.17910719998872 40.52181057272859,-75.17885008223526 40.42497120271347,-75.30845822566705 40.424698061579505))	Haycock Township	Bucks	Pennsylvania
4202903656	POLYGON((-75.78939710534064 39.81831573750745,-75.78954417886823 39.83116571213627,-75.77463439905901 39.831266223987804,-75.77449010218983 39.818416203836684,-75.78939710534064 39.81831573750745))	Avondale Borough	Chester	Pennsylvania
4201734952	POLYGON((-75.32982406312532 40.28071932624519,-75.33042095051505 40.403169685701975,-75.17421991635695 40.403510537876116,-75.17390519257478 40.281058714827914,-75.32982406312532 40.28071932624519))	Hilltown Township	Bucks	Pennsylvania
4201741392	POLYGON((-74.92953853740542 40.16975212786619,-74.92952121015121 40.186501491842634,-74.91151845501847 40.18648913263157,-74.91154020824857 40.1697397759347,-74.92953853740542 40.16975212786619))	Langhorne Borough	Bucks	Pennsylvania
4201741416	POLYGON((-74.92766249830517 40.157911430479125,-74.92764470974365 40.174667808928056,-74.90474511648665 40.17465123363159,-74.90476853489916 40.15789486495031,-74.92766249830517 40.157911430479125))	Langhorne Manor Borough	Bucks	Pennsylvania
4201753296	POLYGON((-75.20226477743468 40.28715190649465,-75.20232743681483 40.308161963026464,-75.15314862172966 40.30823751666505,-75.15310119251338 40.28722740435559,-75.20226477743468 40.28715190649465))	New Britain Borough	Bucks	Pennsylvania
4201744968	POLYGON((-74.91934156046705 40.18950144866973,-74.91924179204783 40.27354890663622,-74.77715366037788 40.273362506066256,-74.77742896159107 40.18931559819269,-74.91934156046705 40.18950144866973))	Lower Makefield Township	Bucks	Pennsylvania
4201764856	POLYGON((-75.21049855397452 40.584554479129736,-75.21057734477539 40.609671085121235,-75.18797605302417 40.60971007954951,-75.18790571872084 40.58459343920439,-75.21049855397452 40.584554479129736))	Riegelsville Borough	Bucks	Pennsylvania
4201745112	POLYGON((-75.03256233232545 40.125298854853895,-75.03258877038017 40.180633823874665,-74.9456144912172 40.180625636769626,-74.94565861213638 40.12529068367163,-75.03256233232545 40.125298854853895))	Lower Southampton Township	Bucks	Pennsylvania
4201769248	POLYGON((-75.3237388265513 40.34795700558344,-75.32385176307085 40.371563550830246,-75.29122342077558 40.371650316422695,-75.29112186229335 40.34804369923415,-75.3237388265513 40.34795700558344))	Sellersville Borough	Bucks	Pennsylvania
4201749120	POLYGON((-74.96409849543609 40.12735283163234,-74.96404425351089 40.230191916353085,-74.84940497620401 40.23009953096762,-74.84963215904452 40.12726077984196,-74.96409849543609 40.12735283163234))	Middletown Township	Bucks	Pennsylvania
4201749384	POLYGON((-75.4909008475328 40.366552213721334,-75.491828895353 40.494061436628805,-75.35894581720879 40.49455054545705,-75.35826849525218 40.36703913688659,-75.4909008475328 40.366552213721334))	Milford Township	Bucks	Pennsylvania
4201751144	POLYGON((-74.80529618719287 40.192582046376145,-74.8052076313086 40.22352449834899,-74.7589393689358 40.223437385752014,-74.75904895870117 40.19249502852639,-74.80529618719287 40.192582046376145))	Morrisville Borough	Bucks	Pennsylvania
4201753304	POLYGON((-75.27016673170827 40.25221950217359,-75.27061363960125 40.36428987394165,-75.1445024974298 40.36451619648962,-75.14426385464884 40.25244493495562,-75.27016673170827 40.25221950217359))	New Britain Township	Bucks	Pennsylvania
4202944456	POLYGON((-75.92349407362542 39.839722766117106,-75.92443614800824 39.909924670076755,-75.83129195763485 39.91062983849715,-75.83044477653942 39.84042619204197,-75.92349407362542 39.839722766117106))	Londonderry Township	Chester	Pennsylvania
4201753712	POLYGON((-74.97034210351788 40.3488795750308,-74.97033083298936 40.37459325024717,-74.94365553305178 40.374583330421906,-74.94367693680829 40.348869664164276,-74.97034210351788 40.3488795750308))	New Hope Borough	Bucks	Pennsylvania
4201754184	POLYGON((-74.9401083897407 40.21984663690028,-74.94009185263141 40.238619003663246,-74.92393295746622 40.238609511505814,-74.9239539550849 40.219837151006864,-74.9401083897407 40.21984663690028))	Newtown Borough	Bucks	Pennsylvania
4201754192	POLYGON((-74.98854380745279 40.2082837489322,-74.98853268348627 40.27424797674475,-74.88466982019652 40.2741910713986,-74.88478169690565 40.208226975423706,-74.98854380745279 40.2082837489322))	Newtown Township	Bucks	Pennsylvania
4201754576	POLYGON((-75.23797813377841 40.46176983843944,-75.23838156281408 40.57576419125245,-75.10361272976083 40.57596367752685,-75.10343737738285 40.4619685279722,-75.23797813377841 40.46176983843944))	Nockamixon Township	Bucks	Pennsylvania
3400732220	POLYGON((-75.02928886704267 39.83101949962796,-75.02929397965346 39.84305442898424,-75.01674958522632 39.843056918319085,-75.01674666195946 39.831021987906965,-75.02928886704267 39.83101949962796))	Hi-Nella Borough	Camden	New Jersey
4201754688	POLYGON((-75.07871968355714 40.15846313181038,-75.07883780165808 40.260485946573134,-74.91641166922408 40.260482612723884,-74.9165369047474 40.1584598099018,-75.07871968355714 40.15846313181038))	Northampton Township	Bucks	Pennsylvania
4201758936	POLYGON((-74.9249729964436 40.14848479728497,-74.92495740307746 40.16265247836238,-74.90586666662863 40.16263853190152,-74.90588622691345 40.148470857773695,-74.9249729964436 40.14848479728497))	Penndel Borough	Bucks	Pennsylvania
4201759384	POLYGON((-75.31406244552406 40.35264471666856,-75.31423816240725 40.39048574397217,-75.27238120770247 40.39059191198905,-75.27222889579053 40.35275074362035,-75.31406244552406 40.35264471666856))	Perkasie Borough	Bucks	Pennsylvania
4204547344	POLYGON((-75.43828521606575 39.80029834907162,-75.43845846566674 39.82757051030129,-75.39710479147242 39.82771942036506,-75.39694788099048 39.80044711602588,-75.43828521606575 39.80029834907162))	Marcus Hook Borough	Delaware	Pennsylvania
4201761616	POLYGON((-75.19628079429425 40.32407474042342,-75.19663974308905 40.44762029080155,-75.03406386638152 40.447782514427885,-75.03400168527575 40.32423626143771,-75.19628079429425 40.32407474042342))	Plumstead Township	Bucks	Pennsylvania
4201763048	POLYGON((-75.3714435987592 40.42529540426655,-75.37159354937499 40.45253591350324,-75.3176302786341 40.452696784690644,-75.317502103063 40.4254561216136,-75.3714435987592 40.42529540426655))	Quakertown Borough	Bucks	Pennsylvania
4204577288	POLYGON((-75.4193928968167 39.80788331035696,-75.41958273712359 39.83910180617968,-75.38866690829356 39.83920949925119,-75.38849105496884 39.807990884969676,-75.4193928968167 39.80788331035696))	Trainer Borough	Delaware	Pennsylvania
4201764536	POLYGON((-75.3901869995328 40.39230737800766,-75.39080514268791 40.499117997243076,-75.2880138428011 40.49941988136071,-75.28755827995698 40.39260813178472,-75.3901869995328 40.39230737800766))	Richland Township	Bucks	Pennsylvania
4201764584	POLYGON((-75.3254114050084 40.46421912786107,-75.32548771775213 40.480026177955494,-75.31603190978247 40.48005241969034,-75.31595781392409 40.464245355033775,-75.3254114050084 40.46421912786107))	Richlandtown Borough	Bucks	Pennsylvania
4201770744	POLYGON((-75.28012143902154 40.34001357473147,-75.28018385732724 40.35509960808192,-75.26298333689638 40.355139996656526,-75.2629247503468 40.34005394190037,-75.28012143902154 40.34001357473147))	Silverdale Borough	Bucks	Pennsylvania
4201776784	POLYGON((-75.18692097607418 40.41406201604725,-75.18732793593021 40.560592242896305,-75.05162582580908 40.56073257897315,-75.05151367074563 40.414201631936024,-75.18692097607418 40.41406201604725))	Tinicum Township	Bucks	Pennsylvania
4201771752	POLYGON((-75.0860536908994 40.315618606113134,-75.08618048217622 40.41524752392731,-74.92201413337808 40.41525334145229,-74.92212886852516 40.31562440330844,-75.0860536908994 40.315618606113134))	Solebury Township	Bucks	Pennsylvania
4201773016	POLYGON((-75.41593032308653 40.471168229576506,-75.41664983987937 40.58744650984232,-75.2082393107854 40.588010222796186,-75.20787969074196 40.471729646184734,-75.41593032308653 40.471168229576506))	Springfield Township	Bucks	Pennsylvania
4201776304	POLYGON((-75.33566469387453 40.31741422052534,-75.33576417939439 40.33749386386241,-75.31445336205466 40.337553760270836,-75.31436019057865 40.31747407467997,-75.33566469387453 40.31741422052534))	Telford Borough	Bucks	Pennsylvania
4201777704	POLYGON((-75.39272443694175 40.40731264807275,-75.39278987199063 40.41856733126659,-75.36737264255848 40.41865088663549,-75.3673114415377 40.40739617041457,-75.39272443694175 40.40731264807275))	Trumbauersville Borough	Bucks	Pennsylvania
4201777744	POLYGON((-74.83064374441958 40.124323663868786,-74.83056022758316 40.157952278501426,-74.79297564221328 40.1578911807239,-74.79307768419272 40.12426263833822,-74.83064374441958 40.124323663868786))	Tullytown Borough	Bucks	Pennsylvania
4201779128	POLYGON((-75.00371805959692 40.25965235089218,-75.00372208905225 40.333128209462885,-74.84890330561595 40.3330295875865,-74.84906687896317 40.25955398340424,-75.00371805959692 40.25965235089218))	Upper Makefield Township	Bucks	Pennsylvania
4201779296	POLYGON((-75.07452523184074 40.14392379788629,-75.07458731680734 40.20066072746334,-74.995385963549 40.20068466411345,-74.99538980418349 40.143947686810215,-75.07452523184074 40.14392379788629))	Upper Southampton Township	Bucks	Pennsylvania
4209167528	POLYGON((-75.44665766531888 40.30708739892434,-75.44709041017322 40.37267435595276,-75.3495401252919 40.37301033774444,-75.34920179534593 40.3074226072067,-75.44665766531888 40.30708739892434))	Salford Township	Montgomery	Pennsylvania
4210160000	NaN	Philadelphia City	Philadelphia	Pennsylvania
4201780952	POLYGON((-75.14203829799382 40.167625757242035,-75.14219173548716 40.2411041525066,-75.03949557882817 40.24118476066005,-75.03945295943458 40.16770615735138,-75.14203829799382 40.167625757242035))	Warminster Township	Bucks	Pennsylvania
4201781048	POLYGON((-75.21867888901305 40.207159319769694,-75.21893493007806 40.286676176479176,-75.10635481635617 40.28683442736102,-75.1062304350955 40.207317128809805,-75.21867888901305 40.207159319769694))	Warrington Township	Bucks	Pennsylvania
4201781144	POLYGON((-75.12687888560967 40.211795116679525,-75.12701870889373 40.286634037809804,-75.02942762043871 40.28670001418722,-75.02939522616148 40.2118609196739,-75.12687888560967 40.211795116679525))	Warwick Township	Bucks	Pennsylvania
4201783960	POLYGON((-75.41234848330231 40.324622434133964,-75.41286963235406 40.410084181579855,-75.2900598621956 40.41045748642689,-75.28969372466605 40.324994619678485,-75.41234848330231 40.324622434133964))	West Rockhill Township	Bucks	Pennsylvania
4201786624	POLYGON((-75.04488071508956 40.23738151004079,-75.04492544517797 40.305015013966596,-74.95103632302396 40.3050133753991,-74.95108507378029 40.237379875364766,-75.04488071508956 40.23738151004079))	Wrightstown Township	Bucks	Pennsylvania
4201786920	POLYGON((-74.85295371734091 40.230783752421694,-74.85290937860096 40.25127490917907,-74.82283726945113 40.251232780834556,-74.82289067296945 40.23074165442074,-74.85295371734091 40.230783752421694))	Yardley Borough	Bucks	Pennsylvania
4202903384	POLYGON((-75.9906970738078 39.9381270704601,-75.99096620944864 39.95678067164909,-75.96411956086183 39.95700706715612,-75.96385771368855 39.93835331725326,-75.9906970738078 39.9381270704601))	Atglen Borough	Chester	Pennsylvania
4202906544	POLYGON((-75.63861843996959 39.832844448670215,-75.63955805432778 39.93404771684584,-75.55685907233232 39.934474402636376,-75.55604093976902 39.833269615417926,-75.63861843996959 39.832844448670215))	Birmingham Township	Chester	Pennsylvania
4202910824	POLYGON((-75.81695335503963 39.97926980240721,-75.81748103692371 40.02352932241792,-75.70153233140421 40.02428929664019,-75.70107947792593 39.980028593077414,-75.81695335503963 39.97926980240721))	Caln Township	Chester	Pennsylvania
4202912744	POLYGON((-75.62296721326756 40.04701561801219,-75.62367826086657 40.12497420449958,-75.49212471019304 40.12560794504055,-75.49156362841565 40.04764762206346,-75.62296721326756 40.04701561801219))	Charlestown Township	Chester	Pennsylvania
4209168328	POLYGON((-75.47301720639622 40.24582720220427,-75.47317712442144 40.268788145085686,-75.45968524762715 40.26884252869548,-75.45952988900767 40.245881541928334,-75.47301720639622 40.24582720220427))	Schwenksville Borough	Montgomery	Pennsylvania
4202914712	POLYGON((-75.84338255518495 39.97328132399796,-75.84379481048175 40.00679183624329,-75.79608834406531 40.007129373190374,-75.79569939068107 39.97361846284292,-75.84338255518495 39.97328132399796))	Coatesville City	Chester	Pennsylvania
4202919752	POLYGON((-75.72875167231345 39.994056260836096,-75.72905239653954 40.02232929596893,-75.67425739163521 40.02266108217374,-75.67397926526498 39.99438771688908,-75.72875167231345 39.994056260836096))	Downingtown Borough	Chester	Pennsylvania
4204566928	POLYGON((-75.33322371450684 39.89705221677695,-75.33326684534774 39.9059557810182,-75.3217539752459 39.90598829554717,-75.32171233431774 39.89708472110681,-75.33322371450684 39.89705221677695))	Rutledge Borough	Delaware	Pennsylvania
4202920824	POLYGON((-75.70044107635674 39.90985439111794,-75.70148879652318 40.01245510025787,-75.59380391830115 40.013056908112574,-75.59291700759465 39.91045402800915,-75.70044107635674 39.90985439111794))	East Bradford Township	Chester	Pennsylvania
4202920864	POLYGON((-75.79161862344253 40.00841837213323,-75.79230898745608 40.06809132050434,-75.7029287756501 40.06866813699118,-75.70231627485495 40.00899397808123,-75.79161862344253 40.00841837213323))	East Brandywine Township	Chester	Pennsylvania
4202980616	POLYGON((-75.82630503423637 40.05849112717816,-75.82713319693805 40.12693257348406,-75.7268695344147 40.127605294048685,-75.72614173717567 40.0591622292688,-75.82630503423637 40.05849112717816))	Wallace Township	Chester	Pennsylvania
4202920920	POLYGON((-75.71130175018952 39.99267474192155,-75.71172606769184 40.03353545806628,-75.65408276636661 40.03387518552111,-75.65369280847145 39.99301398093762,-75.71130175018952 39.99267474192155))	East Caln Township	Chester	Pennsylvania
4202921008	POLYGON((-75.66495379247102 40.16325944711042,-75.66571590715446 40.24121772334225,-75.57508247995445 40.241703579023444,-75.57442410783219 40.16374397245915,-75.66495379247102 40.16325944711042))	East Coventry Township	Chester	Pennsylvania
4202921104	POLYGON((-75.8944728988565 39.91184860640412,-75.89546366578978 39.98786828348369,-75.7601931535831 39.98883446014012,-75.75935201566824 39.91281219923571,-75.8944728988565 39.91184860640412))	East Fallowfield Township	Chester	Pennsylvania
4202921192	POLYGON((-75.58838048508953 39.954427139303924,-75.58905273811743 40.032722054205045,-75.50410147234726 40.03312276747923,-75.50352615862849 39.95482674924169,-75.58838048508953 39.954427139303924))	East Goshen Township	Chester	Pennsylvania
4202921480	POLYGON((-75.77699810309834 39.84823408466775,-75.77775348097141 39.915123538420445,-75.66226314100685 39.915840664862074,-75.66161990917713 39.84894952265351,-75.77699810309834 39.84823408466775))	East Marlborough Township	Chester	Pennsylvania
4202921576	POLYGON((-75.81430199394316 40.09469764042449,-75.81520538384997 40.17034553735676,-75.66607105481734 40.1712995661536,-75.66533289872669 40.095649133206834,-75.81430199394316 40.09469764042449))	East Nantmeal Township	Chester	Pennsylvania
4202921624	POLYGON((-76.05202208156216 39.71740774288791,-76.05326985495094 39.79936013910229,-75.90034092688897 39.800647551990586,-75.89927425865532 39.718691439996945,-76.05202208156216 39.71740774288791))	East Nottingham Township	Chester	Pennsylvania
4204566192	POLYGON((-75.39644515699887 39.88384884024037,-75.3965727898866 39.905997588854255,-75.37452145529703 39.90607090221127,-75.37440091898928 39.88392209640079,-75.39644515699887 39.88384884024037))	Rose Valley Borough	Delaware	Pennsylvania
4202921696	POLYGON((-75.61124456080458 40.09002598089243,-75.61199739598143 40.1740079646934,-75.52186704892833 40.17444930977958,-75.52122507232261 40.09046602373483,-75.61124456080458 40.09002598089243))	East Pikeland Township	Chester	Pennsylvania
4202921928	POLYGON((-75.48281643550355 39.993777647913376,-75.4832909806998 40.061055431633555,-75.40056833662476 40.06137097487025,-75.40017501126624 39.99409244459216,-75.48281643550355 39.993777647913376))	Easttown Township	Chester	Pennsylvania
4202922000	POLYGON((-75.67066589282888 40.13372570164779,-75.67144647371734 40.21297337345017,-75.54121043470275 40.213655579836434,-75.54058123779029 40.13440600888298,-75.67066589282888 40.13372570164779))	East Vincent Township	Chester	Pennsylvania
4202981160	POLYGON((-75.82521264129986 40.142550855422336,-75.82614741156928 40.219657301783606,-75.68900653709956 40.220554930060025,-75.6882269063089 40.14344605237992,-75.82521264129986 40.142550855422336))	Warwick Township	Chester	Pennsylvania
4202922056	POLYGON((-75.60469700087948 40.01333443196787,-75.6052638877726 40.07746440354474,-75.50339903954499 40.07795184542916,-75.50292754792115 40.01382077460935,-75.60469700087948 40.01333443196787))	East Whiteland Township	Chester	Pennsylvania
4202923032	POLYGON((-75.96809508882546 39.71918364377144,-75.96868989151412 39.76167642017054,-75.83893201053397 39.76268688593182,-75.83841685829739 39.7201925961163,-75.96809508882546 39.71918364377144))	Elk Township	Chester	Pennsylvania
4202923440	POLYGON((-75.84761763538049 40.14727979696159,-75.8478762335435 40.168072772816146,-75.81840484578447 40.16828485106615,-75.81815523376434 40.14749172013214,-75.84761763538049 40.14727979696159))	Elverson Borough	Chester	Pennsylvania
4202927376	POLYGON((-75.87417255861712 39.717796151222764,-75.87525212063225 39.80312065100608,-75.7717454466377 39.80385524706327,-75.77079351993935 39.71852853999899,-75.87417255861712 39.717796151222764))	Franklin Township	Chester	Pennsylvania
4202934448	POLYGON((-75.95752847904872 39.88240150255338,-75.95863370667105 39.961694728251814,-75.83570547792657 39.96264615531532,-75.8347419335849 39.8833502753586,-75.95752847904872 39.88240150255338))	Highland Township	Chester	Pennsylvania
4202935528	POLYGON((-75.9202934340909 40.0860115765197,-75.92048716321742 40.10039193127451,-75.90252330042476 40.10053330528664,-75.9023333507762 40.086152879,-75.9202934340909 40.0860115765197))	Honey Brook Borough	Chester	Pennsylvania
4202935536	POLYGON((-75.94862078360941 40.04233640743975,-75.95015945497599 40.15304365603465,-75.82798517695161 40.1539817825213,-75.82664429342891 40.04327088592407,-75.94862078360941 40.04233640743975))	Honey Brook Township	Chester	Pennsylvania
4202939344	POLYGON((-75.73413292133924 39.78590745963492,-75.73515735441077 39.88206213854496,-75.62966818715242 39.882682831101434,-75.6287907263848 39.786526051841506,-75.73413292133924 39.78590745963492))	Kennett Township	Chester	Pennsylvania
4202982936	POLYGON((-76.00210978957615 39.855117081993825,-76.00345955261997 39.94770438710623,-75.90567072408079 39.94850960157597,-75.90445245162837 39.855919673761875,-76.00210978957615 39.855117081993825))	West Fallowfield Township	Chester	Pennsylvania
4202939352	POLYGON((-75.72338435421402 39.83314065947038,-75.72359927046891 39.85361715730856,-75.69942522647874 39.85376543561028,-75.69921748870722 39.833288830785925,-75.72338435421402 39.83314065947038))	Kennett Square Borough	Chester	Pennsylvania
4202944440	POLYGON((-75.82178927562417 39.71883363052231,-75.82255810336738 39.78350388370557,-75.75098027355494 39.78398915706616,-75.7502783320691 39.71931779825458,-75.82178927562417 39.71883363052231))	London Britain Township	Chester	Pennsylvania
4202944480	POLYGON((-75.85794954698434 39.78478861620709,-75.85908311782337 39.87584543910985,-75.77452486471238 39.87644094702052,-75.77350284092387 39.785382215610596,-75.85794954698434 39.78478861620709))	London Grove Township	Chester	Pennsylvania
4202945040	POLYGON((-76.06919395459614 39.764925680794846,-76.07035036270636 39.83954449625235,-75.89856510920214 39.841002348244416,-75.89759423155182 39.766379702198975,-76.06919395459614 39.764925680794846))	Lower Oxford Township	Chester	Pennsylvania
4202946792	POLYGON((-75.53178472976585 40.021612543495316,-75.53195649740792 40.04372523554283,-75.49852504410381 40.04387389915251,-75.49836407028253 40.02176109141144,-75.53178472976585 40.021612543495316))	Malvern Borough	Chester	Pennsylvania
4202950232	POLYGON((-75.8135061431669 39.95529384227014,-75.81364926365477 39.967369031253746,-75.7927600567675 39.96751377645353,-75.79262060973035 39.9554385259195,-75.8135061431669 39.95529384227014))	Modena Borough	Chester	Pennsylvania
4202953608	POLYGON((-75.79024146668166 39.75046858028187,-75.7914836026266 39.858881711918905,-75.71384761210122 39.85938547753604,-75.71272728974583 39.750970423945844,-75.79024146668166 39.75046858028187))	New Garden Township	Chester	Pennsylvania
4202953784	POLYGON((-75.79084253436052 39.89424652108254,-75.7915179721261 39.952925933691965,-75.68515426919227 39.953603359520244,-75.68456957771616 39.89492254786888,-75.79084253436052 39.89424652108254))	Newlin Township	Chester	Pennsylvania
4202953816	POLYGON((-75.92568590657379 39.731692524501156,-75.92664506860793 39.80327093951013,-75.83698399126632 39.80395234119922,-75.83611760883291 39.732372208260166,-75.92568590657379 39.731692524501156))	New London Township	Chester	Pennsylvania
4202954936	POLYGON((-75.74618543012943 40.19172490089892,-75.74679394459662 40.24716944067772,-75.61904949473015 40.24792328120767,-75.6185450531662 40.1924772729832,-75.74618543012943 40.19172490089892))	North Coventry Township	Chester	Pennsylvania
4202957480	POLYGON((-76.00156132260665 39.7728377431484,-76.00191857765957 39.79747102880126,-75.9585421112362 39.7978374630944,-75.9582003170711 39.773203859281246,-76.00156132260665 39.7728377431484))	Oxford Borough	Chester	Pennsylvania
4202958032	POLYGON((-75.93489979638962 39.94814108555386,-75.93519671082859 39.96993897373299,-75.90282095953134 39.970195665144246,-75.90253432056687 39.94839757995377,-75.93489979638962 39.94814108555386))	Parkesburg Borough	Chester	Pennsylvania
4202958808	POLYGON((-75.9104352507779 39.79419874509038,-75.91121066186149 39.852922095971074,-75.84080164275288 39.853453826567105,-75.84008612958674 39.794729376017195,-75.9104352507779 39.79419874509038))	Penn Township	Chester	Pennsylvania
4202959136	POLYGON((-75.67276474064883 39.82669554492176,-75.67348517340962 39.90041955475593,-75.58790996949514 39.900884965710546,-75.58728106348616 39.827159748122796,-75.67276474064883 39.82669554492176))	Pennsbury Township	Chester	Pennsylvania
4202967080	POLYGON((-75.94075504355476 39.95225511535187,-75.94156593211738 40.01135171010487,-75.87509135684984 40.01187275929533,-75.87433769857763 39.95277508121122,-75.94075504355476 39.95225511535187))	Sadsbury Township	Chester	Pennsylvania
4202960120	POLYGON((-75.54993633377771 40.11434500381879,-75.55032211541129 40.162180719349244,-75.49725896452084 40.162420765339554,-75.49691037678723 40.11458464613317,-75.54993633377771 40.11434500381879))	Phoenixville Borough	Chester	Pennsylvania
4202961800	POLYGON((-75.7011919633102 39.881920537068346,-75.70175496344065 39.93711511768714,-75.6197400513194 39.937582524944155,-75.61924283873296 39.8823870362139,-75.7011919633102 39.881920537068346))	Pocopson Township	Chester	Pennsylvania
4202972088	POLYGON((-75.71830972515919 40.14637727451852,-75.71891902466885 40.2041376585957,-75.6377907252457 40.2046130896432,-75.63725017166682 40.14685174055442,-75.71830972515919 40.14637727451852))	South Coventry Township	Chester	Pennsylvania
4202968288	POLYGON((-75.55697970123352 40.08074800716269,-75.55744194033805 40.13739445961186,-75.45352992716283 40.137848040912324,-75.45315384542376 40.081200685177656,-75.55697970123352 40.08074800716269))	Schuylkill Township	Chester	Pennsylvania
4209109696	POLYGON((-75.09597067783925 40.123493600518536,-75.09602458511124 40.16179438903768,-75.04304308357011 40.161826205434934,-75.04301891956378 40.12352537407035,-75.09597067783925 40.123493600518536))	Bryn Athyn Borough	Montgomery	Pennsylvania
4202972072	POLYGON((-75.83698657370918 39.95317577569736,-75.83734389522614 39.98246697561588,-75.79563760583041 39.98276077426502,-75.7952980770327 39.95346927139616,-75.83698657370918 39.95317577569736))	South Coatesville Borough	Chester	Pennsylvania
4202972920	POLYGON((-75.55930234219444 40.165087962325735,-75.55948646945563 40.18751067299901,-75.53062258619687 40.18764656796211,-75.53044795693798 40.16522375014399,-75.55930234219444 40.165087962325735))	Spring City Borough	Chester	Pennsylvania
4202976568	POLYGON((-75.59714954785947 39.899365785904976,-75.59755385332979 39.945890331720626,-75.51568311016939 39.94628340273235,-75.51533419206537 39.899758213147535,-75.59714954785947 39.899365785904976))	Thornbury Township	Chester	Pennsylvania
4202979352	POLYGON((-75.74887426645859 40.043397891911255,-75.74973815800456 40.12219673084906,-75.65200462520056 40.12278820270304,-75.65125332700153 40.04398772561971,-75.74887426645859 40.043397891911255))	Upper Uwchlan Township	Chester	Pennsylvania
4202977344	POLYGON((-75.53407640228967 40.03125898552248,-75.53461242849842 40.09986512854997,-75.3570332929595 40.1005486254995,-75.35667530399982 40.03194083384467,-75.53407640228967 40.03125898552248))	Tredyffrin Township	Chester	Pennsylvania
4202979208	POLYGON((-76.02651422480326 39.80450163320188,-76.02760867714764 39.87795809861806,-75.89297222056955 39.879072898186905,-75.89202111261807 39.80561354988176,-76.02651422480326 39.80450163320188))	Upper Oxford Township	Chester	Pennsylvania
4202983664	POLYGON((-75.86592140342798 40.06834828880208,-75.86726509505993 40.17417665423221,-75.77402271050502 40.17483759200485,-75.7728234461796 40.06900676986691,-75.86592140342798 40.06834828880208))	West Nantmeal Township	Chester	Pennsylvania
4202979480	POLYGON((-75.71805674509805 40.025806816007055,-75.71863308340647 40.0807005182618,-75.61039290519142 40.081321437973315,-75.60990336040454 40.02642653699756,-75.71805674509805 40.025806816007055))	Uwchlan Township	Chester	Pennsylvania
4202979544	POLYGON((-75.88204083009003 39.95939159455331,-75.88264575365821 40.00641517276867,-75.80403719379724 40.0069872248235,-75.80348612998745 39.95996270002044,-75.88204083009003 39.95939159455331))	Valley Township	Chester	Pennsylvania
4202982544	POLYGON((-75.7802262352682 39.91878939131945,-75.7811555349051 40.00050332357737,-75.65075591383852 40.00130888907569,-75.64998171446457 39.919592641523266,-75.7802262352682 39.91878939131945))	West Bradford Township	Chester	Pennsylvania
4202982576	POLYGON((-75.85273645979954 40.000020525219725,-75.85380508689163 40.08573774472667,-75.769593111697 40.08632785738287,-75.76862985807804 40.000608859779454,-75.85273645979954 40.000020525219725))	West Brandywine Township	Chester	Pennsylvania
4202983712	POLYGON((-76.13977316241309 39.717989194702085,-76.14069468753412 39.77388838229074,-75.98986724243947 39.77527291455176,-75.98906751311378 39.71937099977986,-76.13977316241309 39.717989194702085))	West Nottingham Township	Chester	Pennsylvania
4202982664	POLYGON((-75.95566471465698 39.98058853222077,-75.95679250797517 40.06137272905409,-75.8208983816825 40.06241537428228,-75.81993072250395 39.98162821592918,-75.95566471465698 39.98058853222077))	West Caln Township	Chester	Pennsylvania
4202982704	POLYGON((-75.62472646077708 39.94492408886458,-75.62500276321542 39.97527844347542,-75.58651482097409 39.9754795791094,-75.58625553090647 39.945125009563704,-75.62472646077708 39.94492408886458))	West Chester Borough	Chester	Pennsylvania
4202983080	POLYGON((-75.6460833653962 39.93056019537292,-75.64689031988817 40.016205806934764,-75.54329046523786 40.01673780995149,-75.54261272803025 39.93109059603248,-75.6460833653962 39.93056019537292))	West Goshen Township	Chester	Pennsylvania
4202983104	POLYGON((-75.83678331548616 39.81320843898428,-75.83696312213434 39.82803055177469,-75.81979883488849 39.82815310942435,-75.8196227146655 39.813330932608636,-75.83678331548616 39.81320843898428))	West Grove Borough	Chester	Pennsylvania
4202983464	POLYGON((-75.85798063277079 39.84451621965207,-75.85913964929068 39.937411545936186,-75.75306401176087 39.93814908209523,-75.75204806064764 39.84525134541104,-75.85798063277079 39.84451621965207))	West Marlborough Township	Chester	Pennsylvania
4202983832	POLYGON((-75.6677105146633 40.05256120873717,-75.66840697038643 40.12380070069798,-75.57727693540598 40.12429080771005,-75.5766754200154 40.05305008844258,-75.6677105146633 40.05256120873717))	West Pikeland Township	Chester	Pennsylvania
4202983968	POLYGON((-75.99945727249907 39.933684123742495,-76.0007144214061 40.019919713093486,-75.92305167596389 40.020564390100795,-75.92189205587121 39.93432684570941,-75.99945727249907 39.933684123742495))	West Sadsbury Township	Chester	Pennsylvania
4204521384	POLYGON((-75.2656992277693 39.93945748049829,-75.26573542495908 39.9488145110044,-75.25520692397477 39.94883816515279,-75.25517216088758 39.93948112685117,-75.2656992277693 39.93945748049829))	East Lansdowne Borough	Delaware	Pennsylvania
4202984104	POLYGON((-75.61383218445012 39.908174295881615,-75.61443243395281 39.97531350485999,-75.49828410171826 39.97587098611726,-75.49779730674054 39.908730460173054,-75.61383218445012 39.908174295881615))	Westtown Township	Chester	Pennsylvania
4202984160	POLYGON((-75.71399625246131 40.078301000246256,-75.71487006205606 40.16178486298474,-75.57248608270727 40.16257641546906,-75.5717862878127 40.07909023080831,-75.71399625246131 40.078301000246256))	West Vincent Township	Chester	Pennsylvania
4204549504	POLYGON((-75.25734581673753 39.961905485285605,-75.25735954002953 39.96556572977096,-75.24718457854517 39.96558787229748,-75.24717139780323 39.96192762495765,-75.25734581673753 39.961905485285605))	Millbourne Borough	Delaware	Pennsylvania
4202984192	POLYGON((-75.67741859751331 39.985454340771604,-75.67812742011483 40.05708973211431,-75.57135896265487 40.05766546971468,-75.57076172518964 39.98602862803116,-75.67741859751331 39.985454340771604))	West Whiteland Township	Chester	Pennsylvania
4202985352	POLYGON((-75.54955972774324 39.94931195874185,-75.55040557194276 40.05473120679925,-75.42976768357873 40.05524150477161,-75.42910721567996 39.94982036587295,-75.54955972774324 39.94931195874185))	Willistown Township	Chester	Pennsylvania
4204500676	POLYGON((-75.29981125773737 39.91444137205001,-75.29988981071024 39.93244913129274,-75.27423657239677 39.93251264362498,-75.27416473880433 39.91450484410049,-75.29981125773737 39.91444137205001))	Aldan Borough	Delaware	Pennsylvania
4204503336	POLYGON((-75.47057952848705 39.84898183394527,-75.470901838152 39.89613099945388,-75.39158209109509 39.896425949659836,-75.39131406826311 39.84927629444832,-75.47057952848705 39.84898183394527))	Aston Township	Delaware	Pennsylvania
3401571850	POLYGON((-75.32151326803194 39.73111624792231,-75.32163201507136 39.75666212731281,-75.29983049283005 39.756720489924525,-75.29971979464206 39.73117455796968,-75.32151326803194 39.73111624792231))	Swedesboro Borough	Gloucester	New Jersey
4204506024	POLYGON((-75.54337060648264 39.82444490847483,-75.54374955452968 39.872493821610924,-75.4526587139485 39.872885083753296,-75.45234324280429 39.824835508519456,-75.54337060648264 39.82444490847483))	Bethel Township	Delaware	Pennsylvania
4204509080	POLYGON((-75.4105883938158 39.85653890335499,-75.41078621563634 39.889708403567134,-75.37490750625666 39.88982993470164,-75.37472696146995 39.85666029250506,-75.4105883938158 39.85653890335499))	Brookhaven Borough	Delaware	Pennsylvania
4204512442	POLYGON((-75.60554187943164 39.8341834276457,-75.6061622099823 39.90469829138796,-75.53123335239371 39.90506574806439,-75.53068969268122 39.8345499722542,-75.60554187943164 39.8341834276457))	Chadds Ford Township	Delaware	Pennsylvania
4204513208	POLYGON((-75.41186599309835 39.81198331602005,-75.41226510918645 39.87874663526016,-75.3365766155857 39.87899097127985,-75.33625077019366 39.81222707771077,-75.41186599309835 39.81198331602005))	Chester City	Delaware	Pennsylvania
4204513212	POLYGON((-75.41970517647853 39.837883569074975,-75.41987057787583 39.86503669366138,-75.383214060884 39.86516358848967,-75.38306309884193 39.83801034251286,-75.41970517647853 39.837883569074975))	Chester Township	Delaware	Pennsylvania
4204513232	POLYGON((-75.49069549082348 39.8715197836161,-75.49095506904015 39.907916118849165,-75.44817848091395 39.908089332745924,-75.44794151764269 39.87169277549687,-75.49069549082348 39.8715197836161))	Chester Heights Borough	Delaware	Pennsylvania
4204514264	POLYGON((-75.30880763182962 39.922328404440314,-75.30887120334064 39.93647459214708,-75.28276642556717 39.93654119534504,-75.2827082267286 39.92239497445355,-75.30880763182962 39.922328404440314))	Clifton Heights Borough	Delaware	Pennsylvania
4204526408	POLYGON((-75.292089776372 39.8748512151941,-75.29223474001353 39.908995980791495,-75.25965214121172 39.90907351285904,-75.25952333976508 39.87492865403075,-75.292089776372 39.8748512151941))	Folcroft Borough	Delaware	Pennsylvania
4204515232	POLYGON((-75.29256566952678 39.90491738276762,-75.29264701325307 39.92403267751407,-75.26207801266271 39.92410579895263,-75.26200516559936 39.90499045497584,-75.29256566952678 39.90491738276762))	Collingdale Borough	Delaware	Pennsylvania
4204515432	POLYGON((-75.26108372398151 39.90526015848107,-75.2611309099789 39.917687605416376,-75.24602983052907 39.91772062881814,-75.2459853732069 39.9052931674261,-75.26108372398151 39.90526015848107))	Colwyn Borough	Delaware	Pennsylvania
4204529720	POLYGON((-75.3069216865154 39.88777172765996,-75.30701507394534 39.908702535274266,-75.27832260834111 39.908774948777065,-75.27823794825792 39.887844087774766,-75.3069216865154 39.88777172765996))	Glenolden Borough	Delaware	Pennsylvania
4204515488	POLYGON((-75.56369569594267 39.83516499097461,-75.56435686580903 39.9158784501682,-75.46030879015056 39.916338165598816,-75.45976950570551 39.83562340059178,-75.56369569594267 39.83516499097461))	Concord Township	Delaware	Pennsylvania
4204518152	POLYGON((-75.27698346369928 39.91141647521717,-75.27706408054082 39.93142165727402,-75.24582680671931 39.931492092386705,-75.24575527869449 39.911486860703455,-75.27698346369928 39.91141647521717))	Darby Borough	Delaware	Pennsylvania
4204518160	POLYGON((-75.30715019845725 39.88606981496309,-75.30729457799758 39.918398066860306,-75.24944489554962 39.918536941785774,-75.24932769538621 39.88620853178333,-75.30715019845725 39.88606981496309))	Darby Township	Delaware	Pennsylvania
4204522296	POLYGON((-75.35002723545033 39.843543563745186,-75.3501512905913 39.86796001546919,-75.31416581539555 39.86806306349394,-75.31405450901265 39.843646523125464,-75.35002723545033 39.843543563745186))	Eddystone Borough	Delaware	Pennsylvania
4204522584	POLYGON((-75.51165865762617 39.920676434923614,-75.51215790887204 39.9876412502659,-75.41958195222995 39.98801334513946,-75.41917293682113 39.921047653130266,-75.51165865762617 39.920676434923614))	Edgmont Township	Delaware	Pennsylvania
4204533144	POLYGON((-75.36714781425769 39.94884767523908,-75.3675471019407 40.02339644160669,-75.2721845907 40.02365966518604,-75.27188889717321 39.949110208651916,-75.36714781425769 39.94884767523908))	Haverford Township	Delaware	Pennsylvania
4204541440	POLYGON((-75.2910523343178 39.92920321479606,-75.29115079942228 39.952439753766626,-75.26306274251588 39.9525068904696,-75.26297377630895 39.929270296565875,-75.2910523343178 39.92920321479606))	Lansdowne Borough	Delaware	Pennsylvania
4204544888	POLYGON((-75.45626754365702 39.81250599737726,-75.45639594020005 39.831916372816046,-75.41324410769832 39.832078099564725,-75.41312785004925 39.81266761349474,-75.45626754365702 39.81250599737726))	Lower Chichester Township	Delaware	Pennsylvania
4204547616	POLYGON((-75.41829953998597 39.92692076372459,-75.41875247466353 40.001202777307924,-75.32843543465006 40.001493910950884,-75.32808018461076 39.927211136643976,-75.41829953998597 39.92692076372459))	Marple Township	Delaware	Pennsylvania
4204548480	POLYGON((-75.40092591650985 39.91104081747017,-75.401036907755 39.93006946260476,-75.37716251624731 39.93014958027849,-75.37705813210117 39.911120881449726,-75.40092591650985 39.91104081747017))	Media Borough	Delaware	Pennsylvania
4204549136	POLYGON((-75.49251174089795 39.865121485966434,-75.4931199776935 39.950005990527124,-75.38146631240082 39.95042713980618,-75.38099578504298 39.86554137750837,-75.49251174089795 39.865121485966434))	Middletown Township	Delaware	Pennsylvania
4204551176	POLYGON((-75.3356849148723 39.90280905875126,-75.33576622968259 39.91946527208016,-75.31843635010823 39.91951415787099,-75.31835923201622 39.90285791586111,-75.3356849148723 39.90280905875126))	Morton Borough	Delaware	Pennsylvania
4204553104	POLYGON((-75.3958734045008 39.86720412423826,-75.39625432194478 39.93336821620916,-75.34677266130855 39.93352676475856,-75.34643930787036 39.867362303579284,-75.3958734045008 39.86720412423826))	Nether Providence Township	Delaware	Pennsylvania
4209144912	POLYGON((-75.52325501302512 40.24596612273571,-75.5238063719858 40.31744150530343,-75.4501678777026 40.31775149806149,-75.44969402378263 40.246275337559865,-75.52325501302512 40.24596612273571))	Lower Frederick Township	Montgomery	Pennsylvania
4204554224	POLYGON((-75.45785098776936 39.955288355240214,-75.45835448949438 40.030651769931005,-75.36813660491332 40.03097350773355,-75.3677322012868 39.95560924028268,-75.45785098776936 39.955288355240214))	Newtown Township	Delaware	Pennsylvania
4209147592	POLYGON((-75.49558988935743 40.31051446511395,-75.49624584508494 40.40005011775508,-75.39755950318468 40.40043153311006,-75.39703398524259 40.31089468233462,-75.49558988935743 40.31051446511395))	Marlborough Township	Montgomery	Pennsylvania
4204576792	POLYGON((-75.31652483314016 39.84526738276334,-75.31670010774191 39.88340081291004,-75.20902657077649 39.88364484447849,-75.20891088572027 39.84551108657377,-75.31652483314016 39.84526738276334))	Tinicum Township	Delaware	Pennsylvania
4204555664	POLYGON((-75.30787985570733 39.87409660340492,-75.30799237575826 39.89924667362038,-75.28487460682608 39.899305764868735,-75.28477053218994 39.87415564230529,-75.30787985570733 39.87409660340492))	Norwood Borough	Delaware	Pennsylvania
4204558176	POLYGON((-75.38297552952139 39.86100108541037,-75.38305076151484 39.87452955612974,-75.37372752890653 39.874559971367795,-75.37365412791088 39.86103148615007,-75.38297552952139 39.86100108541037))	Parkside Borough	Delaware	Pennsylvania
4204562792	POLYGON((-75.31752887420191 39.87419026495395,-75.31763491721225 39.897173504827194,-75.2973024948461 39.89722741053524,-75.29720323960105 39.87424412702018,-75.31752887420191 39.87419026495395))	Prospect Park Borough	Delaware	Pennsylvania
4204563264	POLYGON((-75.41959613321639 39.986216438545384,-75.42010901966373 40.06987429111527,-75.31600350890587 40.07020503321212,-75.31561771277406 39.98654620788958,-75.41959613321639 39.986216438545384))	Radnor Township	Delaware	Pennsylvania
4204564800	POLYGON((-75.36142973332562 39.845163359053615,-75.361823445346 39.92010944196012,-75.29510726593877 39.920298427063166,-75.29478614713942 39.84535184567947,-75.36142973332562 39.845163359053615))	Ridley Township	Delaware	Pennsylvania
4204564832	POLYGON((-75.33859458008628 39.86566303015182,-75.33871234244727 39.88960498952122,-75.30890280899438 39.88968821707043,-75.30879541029029 39.865746187507206,-75.33859458008628 39.86566303015182))	Ridley Park Borough	Delaware	Pennsylvania
4204569752	POLYGON((-75.28232227547939 39.898388815660184,-75.28239178671146 39.91532108074529,-75.25377375061393 39.91538724158107,-75.25371128356691 39.89845493703563,-75.28232227547939 39.898388815660184))	Sharon Hill Borough	Delaware	Pennsylvania
4204576576	POLYGON((-75.56634751513917 39.8844948866398,-75.56692468383501 39.95451953485416,-75.46910047570363 39.954956646547586,-75.4686228890301 39.88493092124924,-75.56634751513917 39.8844948866398))	Thornbury Township	Delaware	Pennsylvania
4204573032	POLYGON((-75.37124123354097 39.88322452661234,-75.37164775730848 39.95846160181779,-75.30339861811628 39.95866030726609,-75.30306674499461 39.883422706039894,-75.37124123354097 39.88322452661234))	Springfield Township	Delaware	Pennsylvania
4204575648	POLYGON((-75.36340146524037 39.888131539622066,-75.3635456113842 39.915412843359945,-75.33598423682955 39.915495976060974,-75.33585101827286 39.88821459244704,-75.36340146524037 39.888131539622066))	Swarthmore Borough	Delaware	Pennsylvania
4204578712	POLYGON((-75.39258732276264 39.84941762728901,-75.39266473427888 39.86300278168572,-75.36376483797977 39.86309701182791,-75.36369312358786 39.84951181232198,-75.39258732276264 39.84941762728901))	Upland Borough	Delaware	Pennsylvania
4204578776	POLYGON((-75.47548342113731 39.81877307451267,-75.47582431358434 39.86817661528482,-75.4009421528906 39.86845962660116,-75.40065490407186 39.81905559340923,-75.47548342113731 39.81877307451267))	Upper Chichester Township	Delaware	Pennsylvania
4209179040	POLYGON((-75.55630603942919 40.26753811034155,-75.55701965833136 40.35445118719131,-75.46707420316483 40.35484939493963,-75.46647580560693 40.26793510347696,-75.55630603942919 40.26753811034155))	Upper Frederick Township	Montgomery	Pennsylvania
4204579000	POLYGON((-75.33553408883729 39.90865619103288,-75.3358729451579 39.97799132999764,-75.24303172049919 39.97822316404135,-75.24278652738887 39.90888745952079,-75.33553408883729 39.90865619103288))	Upper Darby Township	Delaware	Pennsylvania
4204579248	POLYGON((-75.43595643759875 39.897593836817926,-75.43639317006769 39.966398862030275,-75.36103036994449 39.96665806987379,-75.36066905446785 39.897852417111324,-75.43595643759875 39.897593836817926))	Upper Providence Township	Delaware	Pennsylvania
4204586968	POLYGON((-75.27459655891482 39.917750867156236,-75.27470377080168 39.94457627525479,-75.23322359866563 39.94466713719256,-75.23313257534652 39.917841643265696,-75.27459655891482 39.917750867156236))	Yeadon Borough	Delaware	Pennsylvania
4209100156	POLYGON((-75.17639000215526 40.06474554926788,-75.17662283834424 40.154823167192575,-75.05307211917659 40.15494570786078,-75.05300215551188 40.06486770211171,-75.17639000215526 40.06474554926788))	Abington Township	Montgomery	Pennsylvania
4209102264	POLYGON((-75.23318500033261 40.144217894438555,-75.23327037199331 40.16917163796892,-75.2116461293833 40.16921318506135,-75.21156867155324 40.14425940507343,-75.23318500033261 40.144217894438555))	Ambler Borough	Montgomery	Pennsylvania
4209108568	POLYGON((-75.3576452462647 40.097058313467855,-75.35771471099432 40.11032267893609,-75.32657227931831 40.11041467414713,-75.32650886187271 40.09715026574579,-75.3576452462647 40.097058313467855))	Bridgeport Borough	Montgomery	Pennsylvania
4209166576	POLYGON((-75.54964581284578 40.173861369159745,-75.5498255789311 40.19613075671463,-75.5253179906493 40.19624456319933,-75.52514623642865 40.173975086532984,-75.54964581284578 40.173861369159745))	Royersford Borough	Montgomery	Pennsylvania
4209112968	POLYGON((-75.19173542172503 40.042392206071945,-75.19193716450137 40.11428399487049,-75.08327783306756 40.114413092866215,-75.08319030023793 40.04252097781124,-75.19173542172503 40.042392206071945))	Cheltenham Township	Montgomery	Pennsylvania
4209115192	POLYGON((-75.47750369360037 40.17173401876957,-75.47772626491532 40.20346684919097,-75.44560097694163 40.203594969432125,-75.44539337145774 40.17186199608651,-75.47750369360037 40.17173401876957))	Collegeville Borough	Montgomery	Pennsylvania
4209115848	POLYGON((-75.31750256828417 40.06799258190269,-75.31759721682985 40.08836833591349,-75.28885477356785 40.08844357387005,-75.28876869037973 40.06806776592004,-75.31750256828417 40.06799258190269))	Conshohocken Borough	Montgomery	Pennsylvania
4209119672	POLYGON((-75.65254172644104 40.28201397441327,-75.65370818654631 40.402960651924175,-75.52902930473948 40.40359831822308,-75.52808529023564 40.28264893617406,-75.65254172644104 40.28201397441327))	Douglass Township	Montgomery	Pennsylvania
4209121200	POLYGON((-75.51586899606075 40.397497859685565,-75.51599390873686 40.41385729751168,-75.49566483107027 40.413946235044676,-75.49554483919063 40.39758674612159,-75.51586899606075 40.397497859685565))	East Greenville Borough	Montgomery	Pennsylvania
4209121600	POLYGON((-75.37926650785047 40.122087513985505,-75.37957895278734 40.178237417191085,-75.29495490984706 40.1784839330429,-75.29471211915887 40.122333543334584,-75.37926650785047 40.122087513985505))	East Norriton Township	Montgomery	Pennsylvania
4209127280	POLYGON((-75.42228626115403 40.26886031862064,-75.42275038851604 40.343347902217225,-75.29553833309495 40.34374289139457,-75.2952138627413 40.26925427499074,-75.42228626115403 40.26886031862064))	Franconia Township	Montgomery	Pennsylvania
4209131088	POLYGON((-75.47869355850257 40.3309404980759,-75.47877723951524 40.34278037996317,-75.46076356321446 40.34285354068809,-75.4606830303677 40.33101362836579,-75.47869355850257 40.3309404980759))	Green Lane Borough	Montgomery	Pennsylvania
4209133088	POLYGON((-75.12473423727879 40.16304660345312,-75.1247879276917 40.19236210118653,-75.08849372941205 40.19239553368085,-75.0884556546365 40.163080001489526,-75.12473423727879 40.16304660345312))	Hatboro Borough	Montgomery	Pennsylvania
4209133112	POLYGON((-75.30913723196997 40.26587182814154,-75.30923921985507 40.2882626122356,-75.28741176238248 40.28831889093093,-75.28731697299807 40.265928062554316,-75.30913723196997 40.26587182814154))	Hatfield Borough	Montgomery	Pennsylvania
4209138000	POLYGON((-75.13982789032677 40.08860358557987,-75.13986035197142 40.10446194850228,-75.1197190790748 40.104484517487506,-75.1196912921983 40.088626141972654,-75.13982789032677 40.08860358557987))	Jenkintown Borough	Montgomery	Pennsylvania
4209133120	POLYGON((-75.3407736734575 40.24328405277534,-75.34111257191631 40.31075721725069,-75.23939281086132 40.311012421302884,-75.23915496906727 40.24353865218951,-75.3407736734575 40.24328405277534))	Hatfield Township	Montgomery	Pennsylvania
4209135808	POLYGON((-75.23199742698475 40.15255781160923,-75.2323146425267 40.24556636352185,-75.10145500281968 40.24575506049076,-75.10131646919895 40.152745892309575,-75.23199742698475 40.15255781160923))	Horsham Township	Montgomery	Pennsylvania
4209141432	POLYGON((-75.30585162572173 40.22063897211555,-75.30604278834453 40.26310512610069,-75.25188737465353 40.26323567693316,-75.25173003800585 40.22076932815229,-75.30585162572173 40.22063897211555))	Lansdale Borough	Montgomery	Pennsylvania
4209143312	POLYGON((-75.59854427014115 40.179516240379556,-75.5994761911582 40.285286964922044,-75.46487315042818 40.28590606627147,-75.46415045678204 40.180133043312985,-75.59854427014115 40.179516240379556))	Limerick Township	Montgomery	Pennsylvania
4209144920	POLYGON((-75.2830589376963 40.15649417534783,-75.28332877121439 40.22137488347042,-75.19172960598829 40.221562854820604,-75.1915470070577 40.15668171821819,-75.2830589376963 40.15649417534783))	Lower Gwynedd Township	Montgomery	Pennsylvania
4209144976	POLYGON((-75.35529251030115 39.97197388748702,-75.35584357039147 40.07812071333894,-75.20007127775527 40.07849447000639,-75.19976144152405 39.97234624991044,-75.35529251030115 39.97197388748702))	Lower Merion Township	Montgomery	Pennsylvania
4209145008	POLYGON((-75.09871501902808 40.10291319729329,-75.0988087368248 40.16765236973929,-75.01114229001813 40.167693994148586,-75.01113172179365 40.10295472699628,-75.09871501902808 40.10291319729329))	Lower Moreland Township	Montgomery	Pennsylvania
4209145072	POLYGON((-75.63247260293276 40.21987847948841,-75.63308046135106 40.285140546324435,-75.55605149471371 40.28553637673371,-75.55551758649645 40.220273402647074,-75.63247260293276 40.21987847948841))	Lower Pottsgrove Township	Montgomery	Pennsylvania
4209145080	POLYGON((-75.47794457164639 40.097993537620944,-75.4786959436782 40.205098577625826,-75.37006899194168 40.2054968160687,-75.36948811239141 40.098390278266834,-75.47794457164639 40.097993537620944))	Lower Providence Township	Montgomery	Pennsylvania
4209145096	POLYGON((-75.44887233745051 40.222336965546184,-75.4494260796524 40.30606179467694,-75.33361732988341 40.30645371242979,-75.33320626920167 40.22272773134359,-75.44887233745051 40.222336965546184))	Lower Salford Township	Montgomery	Pennsylvania
4209150640	POLYGON((-75.27675660704587 40.203858877063105,-75.27705756141948 40.27772926326517,-75.18339749294982 40.277915615616386,-75.18319827528568 40.20404474599318,-75.27675660704587 40.203858877063105))	Montgomery Township	Montgomery	Pennsylvania
4209152664	POLYGON((-75.27370747298312 39.9999744422253,-75.27376393390499 40.01411048123725,-75.2515813187591 40.01416075954908,-75.2515294326447 40.00002469551635,-75.27370747298312 39.9999744422253))	Narberth Borough	Montgomery	Pennsylvania
4209153664	POLYGON((-75.62222553424677 40.25154766312437,-75.6233674769993 40.37584561688957,-75.48944134588697 40.376489980450344,-75.4885447144644 40.25218921771085,-75.62222553424677 40.25154766312437))	New Hanover Township	Montgomery	Pennsylvania
4209176304	POLYGON((-75.34237832884095 40.31460607657787,-75.342468439049 40.33243959810911,-75.3160146280582 40.33251489250584,-75.31593147807611 40.31468132379698,-75.34237832884095 40.31460607657787))	Telford Borough	Montgomery	Pennsylvania
4209159120	POLYGON((-75.50874827628896 40.38217231801486,-75.50892111641403 40.40513419082997,-75.4847687868875 40.4052379728102,-75.48460414859048 40.38227601630953,-75.50874827628896 40.38217231801486))	Pennsburg Borough	Montgomery	Pennsylvania
4209154656	POLYGON((-75.36792951605477 40.102960097456624,-75.36814758264043 40.14340012458601,-75.31430645403567 40.14355877694262,-75.31412027803044 40.10311852421288,-75.36792951605477 40.102960097456624))	Norristown Borough	Montgomery	Pennsylvania
4209155512	POLYGON((-75.2855451185929 40.20273410354943,-75.28561717732313 40.21990192919073,-75.2631985524703 40.21995507702598,-75.2631321495983 40.202787219305044,-75.2855451185929 40.20273410354943))	North Wales Borough	Montgomery	Pennsylvania
4209159392	POLYGON((-75.49403359908847 40.196951803554974,-75.49455318878331 40.26841741652863,-75.4402888361271 40.26863661135553,-75.43982625313245 40.197170448224114,-75.49403359908847 40.196951803554974))	Perkiomen Township	Montgomery	Pennsylvania
4209161664	POLYGON((-75.33072905490792 40.07242886793402,-75.33108757038826 40.14641142287754,-75.256101898293 40.1466015402922,-75.25582457796158 40.07261849102268,-75.33072905490792 40.07242886793402))	Plymouth Township	Montgomery	Pennsylvania
4209162416	POLYGON((-75.680712449777 40.23062119199726,-75.68110195980229 40.26948761251431,-75.60839096977524 40.2698927553215,-75.60804303524498 40.23102578152092,-75.680712449777 40.23062119199726))	Pottstown Borough	Montgomery	Pennsylvania
4209163808	POLYGON((-75.49407094952095 40.36422132727592,-75.4942357256414 40.3867768232866,-75.47042660263654 40.386876131676445,-75.47026976364677 40.36432055699598,-75.49407094952095 40.36422132727592))	Red Hill Borough	Montgomery	Pennsylvania
4209165568	POLYGON((-75.10061463992737 40.074682995567755,-75.1006321541286 40.08658086678155,-75.08160951645347 40.08659583006514,-75.08159531297635 40.07469795258654,-75.10061463992737 40.074682995567755))	Rockledge Borough	Montgomery	Pennsylvania
4209171016	POLYGON((-75.46123128220475 40.17164204650242,-75.46183432844916 40.260526708749325,-75.36444388869694 40.260874403895244,-75.36396800353761 40.17198865648268,-75.46123128220475 40.17164204650242))	Skippack Township	Montgomery	Pennsylvania
4209171856	POLYGON((-75.33621287091705 40.300295337441106,-75.33631874816665 40.32164250069855,-75.30644764031157 40.32172548724226,-75.30635116647558 40.30037826174203,-75.33621287091705 40.300295337441106))	Souderton Borough	Montgomery	Pennsylvania
3400505740	POLYGON((-74.933590648396 40.05658976676083,-74.93357518914492 40.07250947418131,-74.91047323519872 40.0724939248925,-74.91049407102356 40.05657422618305,-74.933590648396 40.05658976676083))	Beverly City	Burlington	New Jersey
4209173088	POLYGON((-75.2622440449246 40.059653270534724,-75.26251791736728 40.13096560761362,-75.16378304286589 40.13114733112649,-75.16361217435801 40.059834538539874,-75.2622440449246 40.059653270534724))	Springfield Township	Montgomery	Pennsylvania
4209177152	POLYGON((-75.38958110067111 40.21059595015692,-75.38995883356068 40.276457922548175,-75.29358419333376 40.276742579376325,-75.29329980975896 40.210879948522,-75.38958110067111 40.21059595015692))	Towamencin Township	Montgomery	Pennsylvania
4209177304	POLYGON((-75.49768376994955 40.18405844287176,-75.49790380588118 40.21414575535263,-75.4570382300009 40.21431432416012,-75.45683625197222 40.184226833390966,-75.49768376994955 40.18405844287176))	Trappe Borough	Montgomery	Pennsylvania
4209179008	POLYGON((-75.23795194684375 40.109080970382344,-75.23824111283149 40.19189269654038,-75.12803632336454 40.19206703323208,-75.12788091755563 40.109254799888035,-75.23795194684375 40.109080970382344))	Upper Dublin Township	Montgomery	Pennsylvania
4209179056	POLYGON((-75.33357444437725 40.18274072292187,-75.33388003181838 40.245036851113554,-75.24165359311505 40.24526616987335,-75.24143241457473 40.18296953982578,-75.33357444437725 40.18274072292187))	Upper Gwynedd Township	Montgomery	Pennsylvania
4209179064	POLYGON((-75.57551150876603 40.33906485535973,-75.57647353372674 40.45196043212611,-75.43932603871406 40.45256302104178,-75.43859286621245 40.339665059034026,-75.57551150876603 40.33906485535973))	Upper Hanover Township	Montgomery	Pennsylvania
3400503370	POLYGON((-74.54417725258084 39.530076349646876,-74.54249589920052 39.785561867001526,-74.37385362014788 39.78477450223334,-74.37615465848785 39.529296052297525,-74.54417725258084 39.530076349646876))	Bass River Township	Burlington	New Jersey
4209179136	POLYGON((-75.46693893710076 40.04921832866017,-75.46743199846922 40.121347088727866,-75.3150231900064 40.121861931434196,-75.31469088601051 40.04973186602107,-75.46693893710076 40.04921832866017))	Upper Merion Township	Montgomery	Pennsylvania
4209179176	POLYGON((-75.14723945644232 40.124899368027044,-75.14739189529354 40.19543306172773,-75.05598444656847 40.19551335291983,-75.05592654489844 40.124979460234805,-75.14723945644232 40.124899368027044))	Upper Moreland Township	Montgomery	Pennsylvania
4209179240	POLYGON((-75.66742416461469 40.2584176583059,-75.6679004899333 40.3068336897464,-75.60040765569619 40.30720365675025,-75.59997945667756 40.25878699615022,-75.66742416461469 40.2584176583059))	Upper Pottsgrove Township	Montgomery	Pennsylvania
4209179256	POLYGON((-75.54601620367634 40.11344562518186,-75.54694823474789 40.229648346429904,-75.43570709205846 40.23012057158142,-75.43496460581565 40.113915923944106,-75.54601620367634 40.11344562518186))	Upper Providence Township	Montgomery	Pennsylvania
4209179280	POLYGON((-75.47924119759166 40.25236033234367,-75.47982589351906 40.33507679980244,-75.402255617382 40.33537256321331,-75.40176543857623 40.25265523702839,-75.47924119759166 40.25236033234367))	Upper Salford Township	Montgomery	Pennsylvania
4209182736	POLYGON((-75.33020313601124 40.060759251591016,-75.33030189385511 40.08120711412232,-75.30508313804675 40.08127627483439,-75.30499192012924 40.06082836254315,-75.33020313601124 40.060759251591016))	West Conshohocken Borough	Montgomery	Pennsylvania
3400582960	POLYGON((-74.66222119305014 39.99015524935649,-74.66195912222607 40.043289895245024,-74.59957038376145 40.04309108385345,-74.59988081940902 39.98995680957342,-74.66222119305014 39.99015524935649))	Wrightstown Borough	Burlington	New Jersey
4209183696	POLYGON((-75.42771626000639 40.105216759354974,-75.42804773108057 40.15807399971265,-75.3419644361354 40.15836022917885,-75.34169962257648 40.10550245697712,-75.42771626000639 40.105216759354974))	West Norriton Township	Montgomery	Pennsylvania
4209183912	POLYGON((-75.69969428026472 40.23374959506461,-75.70020446790515 40.28325762795467,-75.64574724939949 40.283574372835915,-75.645276733744 40.234065789078684,-75.69969428026472 40.23374959506461))	West Pottsgrove Township	Montgomery	Pennsylvania
3400545210	POLYGON((-74.82088239338738 39.846542031319615,-74.8208225436416 39.86955997569469,-74.78517231210108 39.8694994273666,-74.78524406971006 39.84648153209377,-74.82088239338738 39.846542031319615))	Medford Lakes Borough	Burlington	New Jersey
4209184624	POLYGON((-75.30465755249733 40.049179521556496,-75.30513079089135 40.15519572168837,-75.1903919934608 40.15544122686041,-75.19009670422153 40.049424112467804,-75.30465755249733 40.049179521556496))	Whitemarsh Township	Montgomery	Pennsylvania
4209184888	POLYGON((-75.33135046005323 40.11826731421496,-75.3317314236571 40.196598460981676,-75.22272591078209 40.1968595019277,-75.22247012703883 40.11852763679415,-75.33135046005323 40.11826731421496))	Whitpain Township	Montgomery	Pennsylvania
4209186496	POLYGON((-75.41552480784672 40.15205635747842,-75.41601780202888 40.23278596962648,-75.28860781777995 40.23317380455247,-75.2882658022127 40.152443092704544,-75.41552480784672 40.15205635747842))	Worcester Township	Montgomery	Pennsylvania
3400508920	POLYGON((-74.88337512253004 40.06076634023438,-74.88330253748931 40.10329453415738,-74.82761138174423 40.10322503727066,-74.82771860596091 40.060696947295575,-74.88337512253004 40.06076634023438))	Burlington City	Burlington	New Jersey
3400506670	POLYGON((-74.72138146666174 40.1370736914042,-74.7212813464137 40.161572709545354,-74.6992022100863 40.1615174571356,-74.69931026123656 40.13701848659734,-74.72138146666174 40.1370736914042))	Bordentown City	Burlington	New Jersey
3400506700	POLYGON((-74.77960230989873 40.10990905730714,-74.77935188262086 40.18734715429021,-74.66965950922858 40.18708612628962,-74.67003442861255 40.10964873949158,-74.77960230989873 40.10990905730714))	Bordentown Township	Burlington	New Jersey
3400569990	POLYGON((-74.81903037962188 39.987245507289074,-74.81878273260554 40.08087790359368,-74.61384705198934 40.08037604554041,-74.61437474658146 39.98674530087698,-74.81903037962188 39.987245507289074))	Springfield Township	Burlington	New Jersey
3400748750	POLYGON((-75.10942495525492 39.87153642982144,-75.10945624385477 39.891218151197656,-75.07857827361696 39.891243182372705,-75.07855581160865 39.87156144364094,-75.10942495525492 39.87153642982144))	Mount Ephraim Borough	Camden	New Jersey
3400508950	POLYGON((-74.9056803637859 40.02002194644532,-74.9055347163746 40.12552489751499,-74.79091184505704 40.125374681788124,-74.7912342167544 40.019872287515255,-74.9056803637859 40.02002194644532))	Burlington Township	Burlington	New Jersey
3400512670	POLYGON((-74.70718578161947 40.05086716489411,-74.70665855206745 40.173696651387885,-74.58830017497361 40.17333628094049,-74.58904012034237 40.05050834873005,-74.70718578161947 40.05086716489411))	Chesterfield Township	Burlington	New Jersey
3400512940	POLYGON((-75.03567510829271 39.96399496861439,-75.0357149442304 40.04049398637584,-74.9538918533404 40.04049031681458,-74.95394328169847 39.96399130892496,-75.03567510829271 39.96399496861439))	Cinnaminson Township	Burlington	New Jersey
3400517080	POLYGON((-74.98915826009116 40.0268206913444,-74.98915125942429 40.070994852325235,-74.92243131466563 40.070969392141805,-74.9224813694967 40.02679527072308,-74.98915826009116 40.0268206913444))	Delanco Township	Burlington	New Jersey
3402157600	POLYGON((-74.80227268632588 40.3141072246741,-74.80220271762389 40.33808178641663,-74.77582944638922 40.33803368211306,-74.77590874417857 40.3140591608856,-74.80227268632588 40.3141072246741))	Pennington Borough	Mercer	New Jersey
3400517440	POLYGON((-74.99362173639899 39.98929247952232,-74.99361656818837 40.04478340625998,-74.90164009468867 40.04474183403408,-74.90171972955093 39.9892509884437,-74.99362173639899 39.98929247952232))	Delran Township	Burlington	New Jersey
3400518790	POLYGON((-74.78297645767452 39.97467261077436,-74.78279410382906 40.03224224084992,-74.72975094524855 40.03213067437489,-74.72997782995469 39.97456127024095,-74.78297645767452 39.97467261077436))	Eastampton Township	Burlington	New Jersey
3400572060	POLYGON((-74.77743933659086 39.74078007278537,-74.77696395380018 39.88801822110788,-74.53330139052278 39.887293682195704,-74.53429608596956 39.740059285181225,-74.77743933659086 39.74078007278537))	Tabernacle Township	Burlington	New Jersey
3400520050	POLYGON((-74.93651437780845 40.0306999473643,-74.93647259784788 40.07571432865189,-74.88673557547129 40.07567637772738,-74.88681006576348 40.030662056530204,-74.93651437780845 40.0306999473643))	Edgewater Park Township	Burlington	New Jersey
3400753880	POLYGON((-75.0956091935131 39.8936263760787,-75.09563317238762 39.91087711208394,-75.06987546788349 39.91089549334347,-75.06985794743024 39.89364474616863,-75.0956091935131 39.8936263760787))	Oaklyn Borough	Camden	New Jersey
3400522110	POLYGON((-74.96634932994748 39.77460111993997,-74.96627492913957 39.926807840209776,-74.85359981342734 39.9267203231724,-74.85392278524428 39.77451407116757,-74.96634932994748 39.77460111993997))	Evesham Township	Burlington	New Jersey
3400523250	POLYGON((-74.74188227190878 40.13101052374056,-74.74183887544278 40.14247909707239,-74.72286220336073 40.14243523685624,-74.72290878967844 40.13096668121922,-74.74188227190878 40.13101052374056))	Fieldsboro Borough	Burlington	New Jersey
3400553070	POLYGON((-74.63432995912868 40.03347321308318,-74.63373725624213 40.14414626247944,-74.53336406202503 40.14378529112969,-74.53411918055114 40.03311364502493,-74.63432995912868 40.03347321308318))	North Hanover Township	Burlington	New Jersey
3400523850	POLYGON((-74.83322477874991 40.05733569291246,-74.83304401465965 40.13134916270855,-74.74967879171666 40.13119897505279,-74.74994981384421 40.05718589595793,-74.83322477874991 40.05733569291246))	Florence Township	Burlington	New Jersey
3400529010	POLYGON((-74.86617310371898 39.94035500660617,-74.86605204316257 40.00240295001103,-74.79738815678132 40.00230325322892,-74.79757127407625 39.94025552745994,-74.86617310371898 39.94035500660617))	Hainesport Township	Burlington	New Jersey
3400708170	POLYGON((-75.13284418586929 39.87207741127373,-75.13286901625067 39.88494507528577,-75.10753321208722 39.88497133267276,-75.10751311640168 39.872103656756394,-75.13284418586929 39.87207741127373))	Brooklawn Borough	Camden	New Jersey
3400542060	POLYGON((-74.86625025300393 39.928307776107836,-74.86612760398278 39.99123171274861,-74.74636627194052 39.99103151611513,-74.74659863975221 39.928108022693856,-74.86625025300393 39.928307776107836))	Lumberton Township	Burlington	New Jersey
3400577150	POLYGON((-74.73839936026243 39.5456466492075,-74.73750572843603 39.78223522180497,-74.41433712024539 39.78105432508307,-74.41633083234669 39.54447557106256,-74.73839936026243 39.5456466492075))	Washington Township	Burlington	New Jersey
3400543290	POLYGON((-74.77711687802308 40.047780989819096,-74.77684543886527 40.130952040303306,-74.63394659800369 40.1305885249381,-74.63439184783779 40.047418536972856,-74.77711687802308 40.047780989819096))	Mansfield Township	Burlington	New Jersey
3400543740	POLYGON((-75.02224589295325 39.925073950762226,-75.02226216915541 39.97530092881545,-74.96382757529665 39.97529742272382,-74.96385402148866 39.925070450868304,-75.02224589295325 39.925073950762226))	Maple Shade Township	Burlington	New Jersey
3400545120	POLYGON((-74.87314366312961 39.77808291681165,-74.87283873273024 39.943484675507776,-74.74494776636287 39.94327387029531,-74.74555937091726 39.777873336940615,-74.87314366312961 39.77808291681165))	Medford Township	Burlington	New Jersey
3400547880	POLYGON((-75.01033833478557 39.934219560474084,-75.01035095955561 40.017953274958415,-74.8771783187907 40.0178886523048,-74.87732812043622 39.93415512811607,-75.01033833478557 39.934219560474084))	Moorestown Township	Burlington	New Jersey
3400548900	POLYGON((-74.80812311304086 39.97781999669293,-74.80802529122522 40.01276593580184,-74.76552556801498 40.01268774210241,-74.76564504536931 39.97774189916198,-74.80812311304086 39.97781999669293))	Mount Holly Township	Burlington	New Jersey
3400549020	POLYGON((-74.98966175806932 39.9100306901155,-74.9896473930017 40.00536208944595,-74.84274655195424 40.00525586817489,-74.8429647525621 39.909924824928304,-74.98966175806932 39.9100306901155))	Mount Laurel Township	Burlington	New Jersey
3400551510	POLYGON((-74.65379897197838 39.985577664031574,-74.65341401220351 40.06169761387426,-74.50140500026762 40.061143153704165,-74.50195878497387 39.985024687878756,-74.65379897197838 39.985577664031574))	New Hanover Township	Burlington	New Jersey
3402133150	POLYGON((-74.77826698355157 40.380353772792674,-74.7782067390474 40.398720858844804,-74.75019031742038 40.39866372714814,-74.75025817169167 40.380296677949865,-74.77826698355157 40.380353772792674))	Hopewell Borough	Mercer	New Jersey
3400555800	POLYGON((-75.06240650449354 39.98966448081085,-75.06243217375527 40.01785215830348,-75.0087829084837 40.017868642418854,-75.00877929734959 39.989680948572435,-75.06240650449354 39.98966448081085))	Palmyra Borough	Burlington	New Jersey
3400557480	POLYGON((-74.6990064255173 39.965607925374336,-74.69895334552933 39.97770811907489,-74.67367623224702 39.97763971527415,-74.6737337688635 39.965539550719384,-74.6990064255173 39.965607925374336))	Pemberton Borough	Burlington	New Jersey
3401551390	POLYGON((-75.03583027710513 39.53633253110109,-75.03584334017451 39.56172551394753,-75.00101441068016 39.56173103662808,-75.00101404097911 39.536338048830956,-75.03583027710513 39.53633253110109))	Newfield Borough	Gloucester	New Jersey
3400557510	POLYGON((-74.74366460617497 39.89366308317063,-74.74320301045836 40.01719267491671,-74.46222606472014 40.0162294270928,-74.46319267621135 39.89270401749386,-74.74366460617497 39.89366308317063))	Pemberton Township	Burlington	New Jersey
3400782450	POLYGON((-75.1024767270959 39.91299459328579,-75.10248922158743 39.92137700500384,-75.08958943283429 39.92138768908686,-75.08957851095435 39.9130052742139,-75.1024767270959 39.91299459328579))	Woodlynne Borough	Camden	New Jersey
3400563510	POLYGON((-74.97439286929504 40.02297169268862,-74.97438442969826 40.045534002218254,-74.93561385217755 40.045518944642254,-74.93563506555421 40.02295664706881,-74.97439286929504 40.02297169268862))	Riverside Township	Burlington	New Jersey
3400563660	POLYGON((-75.03179070031032 40.001763042408754,-75.03179991920422 40.02163123549339,-74.99623674750296 40.021635537455104,-74.99623783848159 40.00176734136191,-75.03179070031032 40.001763042408754))	Riverton Borough	Burlington	New Jersey
3400566810	POLYGON((-74.82247759894534 39.716235185811136,-74.8221360360573 39.849029916134626,-74.61884473981722 39.84854010391178,-74.61957667838814 39.71574766188503,-74.82247759894534 39.716235185811136))	Shamong Township	Burlington	New Jersey
3400568610	POLYGON((-74.79921070334056 39.856376824611395,-74.79882535293548 39.988178412402526,-74.58817673434183 39.98762138887937,-74.58896556193558 39.8558223816515,-74.79921070334056 39.856376824611395))	Southampton Township	Burlington	New Jersey
3400578200	POLYGON((-74.87562468462198 39.99199074481054,-74.87552526175415 40.04673041116418,-74.76804273579091 40.046565092878424,-74.76822800773883 39.99182574484957,-74.87562468462198 39.99199074481054))	Westampton Township	Burlington	New Jersey
3400581440	POLYGON((-74.93606569273558 39.994869821533754,-74.93600411200813 40.06080162757332,-74.84773130498944 40.06071924139677,-74.84787782660199 39.99478762638164,-74.93606569273558 39.994869821533754))	Willingboro Township	Burlington	New Jersey
3400582420	POLYGON((-74.66760795709425 39.75370676679038,-74.66674552256174 39.932337422485645,-74.37776663091323 39.9311467150118,-74.37937682854744 39.75252353307397,-74.66760795709425 39.75370676679038))	Woodland Township	Burlington	New Jersey
3400739420	POLYGON((-75.04860723414812 39.856670080458265,-75.0486244737676 39.88109306446332,-75.01122953928251 39.881102713265605,-75.0112255578909 39.85667972095892,-75.04860723414812 39.856670080458265))	Lawnside Borough	Camden	New Jersey
3400702200	POLYGON((-75.09262222761886 39.88049355297857,-75.09265180117953 39.90246296960236,-75.05019091455914 39.90248911962343,-75.05017489408392 39.88051968276298,-75.09262222761886 39.88049355297857))	Audubon Borough	Camden	New Jersey
3400702230	POLYGON((-75.09472779763236 39.89321455233888,-75.09473851628432 39.900999408971686,-75.08299404998638 39.90100840853319,-75.08298466009144 39.89322354943201,-75.09472779763236 39.89321455233888))	Audubon Park Borough	Camden	New Jersey
3400703250	POLYGON((-75.06912678288806 39.8526981830398,-75.06916028845414 39.886072043721285,-75.03514118157744 39.886087340294736,-75.03512415698059 39.85271346163187,-75.06912678288806 39.8526981830398))	Barrington Borough	Camden	New Jersey
3400704750	POLYGON((-75.1253377605597 39.85231907901851,-75.12538682172135 39.879275792934344,-75.0584690933136 39.87932883026964,-75.0584462155601 39.85237206598863,-75.1253377605597 39.85231907901851))	Bellmawr Borough	Camden	New Jersey
3400705440	POLYGON((-74.96827352715934 39.77474279970956,-74.9682568658517 39.81100026195505,-74.90569354465049 39.81096628073669,-74.90574304405857 39.774708861907285,-74.96827352715934 39.77474279970956))	Berlin Borough	Camden	New Jersey
3400705470	POLYGON((-74.96011238226164 39.78202521030655,-74.9600885195759 39.82331321863295,-74.89988839180558 39.82327689340545,-74.8999482474595 39.78198893792121,-74.96011238226164 39.78202521030655))	Berlin Township	Camden	New Jersey
3400710000	POLYGON((-75.14132108806939 39.89499810856863,-75.14148134868857 39.97287641077244,-75.06201893228564 39.97294615995082,-75.06194868115244 39.895067666647385,-75.14132108806939 39.89499810856863))	Camden City	Camden	New Jersey
3400712280	POLYGON((-75.07183866647665 39.854621751589505,-75.07194766730505 39.95890282358542,-74.92096024022064 39.95889820519968,-74.92107998555426 39.854617150142175,-75.07183866647665 39.854621751589505))	Cherry Hill Township	Camden	New Jersey
3400712550	POLYGON((-74.896454326199 39.718456118439555,-74.89641574993786 39.74423609927426,-74.85808529019073 39.74419556815297,-74.85813814116419 39.718415624160016,-74.896454326199 39.718456118439555))	Chesilhurst Borough	Camden	New Jersey
3400713420	POLYGON((-75.00505594994911 39.792291752302006,-75.00505767622872 39.815857715124274,-74.96429131892727 39.815852330722954,-74.96430350696573 39.792286372372686,-75.00505594994911 39.792291752302006))	Clementon Borough	Camden	New Jersey
3400714260	POLYGON((-75.09731176420195 39.90353625820344,-75.09734511785624 39.92709948055256,-75.05486364265056 39.92712736293794,-75.05484484452886 39.90356411745033,-75.09731176420195 39.90353625820344))	Collingswood Borough	Camden	New Jersey
3400726070	POLYGON((-74.9875704606147 39.81621264674891,-74.98756496042854 39.8467234526962,-74.94615025539905 39.84671162110778,-74.94617407385606 39.81620082787931,-74.9875704606147 39.81621264674891))	Gibbsboro Borough	Camden	New Jersey
3400726760	POLYGON((-75.09683011161644 39.71960025215631,-75.09702557119418 39.85888005001162,-74.96019875828885 39.85891379891461,-74.96027893865919 39.71963383571673,-75.09683011161644 39.71960025215631))	Gloucester Township	Camden	New Jersey
3400726820	POLYGON((-75.14090428646465 39.876401102069956,-75.14097321977084 39.910057727606294,-75.09432643728783 39.9101050523863,-75.09428031329581 39.87644837075635,-75.14090428646465 39.876401102069956))	Gloucester City City	Camden	New Jersey
3400728740	POLYGON((-75.10619659064824 39.88662325187784,-75.10626047924531 39.927988619989925,-75.03526127938039 39.92803194810007,-75.03524007866422 39.88666651688308,-75.10619659064824 39.88662325187784))	Haddon Township	Camden	New Jersey
3400728770	POLYGON((-75.0544249170417 39.87026348344237,-75.05446328097531 39.918750470288515,-75.01361080434718 39.91876246164773,-75.01360121689157 39.87027545433096,-75.0544249170417 39.87026348344237))	Haddonfield Borough	Camden	New Jersey
3400728800	POLYGON((-75.08679025395988 39.868193918479896,-75.08681892603495 39.89093442148869,-75.04455752558779 39.89095835769784,-75.04454281038436 39.86821783551423,-75.08679025395988 39.868193918479896))	Haddon Heights Borough	Camden	New Jersey
3400739210	POLYGON((-75.01571928357433 39.815816284358576,-75.01572189168174 39.8272618592471,-74.99396257814766 39.827262767366285,-74.9939635796967 39.8158171921114,-75.01571928357433 39.815816284358576))	Laurel Springs Borough	Camden	New Jersey
3400745510	POLYGON((-75.0663029214487 39.9453124045619,-75.06631510432072 39.95792915443835,-75.03463907627379 39.95794294644236,-75.03463271266008 39.94532619043776,-75.0663029214487 39.9453124045619))	Merchantville Borough	Camden	New Jersey
3400740440	POLYGON((-75.03034998152673 39.79789109435805,-75.03036784930512 39.8384995871426,-74.95139820824386 39.838493381409215,-74.95142680446686 39.79788489750276,-75.03034998152673 39.79789109435805))	Lindenwold Borough	Camden	New Jersey
3400742630	POLYGON((-75.05069834402993 39.84834125779783,-75.0507096531863 39.86370990622485,-75.0210306473361 39.86371908390887,-75.02102595712492 39.84835043051174,-75.05069834402993 39.84834125779783))	Magnolia Borough	Camden	New Jersey
3400757660	POLYGON((-75.12668394621925 39.92161145963233,-75.12682839279742 39.99984037078185,-75.00536901773081 39.99990963948535,-75.00536290286374 39.92168053773155,-75.12668394621925 39.92161145963233))	Pennsauken Township	Camden	New Jersey
3400758770	POLYGON((-75.02613815538318 39.765182316769284,-75.02615410022 39.80730725898805,-74.94534631052481 39.80729733561391,-74.94537963010934 39.76517240812461,-75.02613815538318 39.765182316769284))	Pine Hill Borough	Camden	New Jersey
3400765160	POLYGON((-75.1043127737855 39.83939800236456,-75.10434868932694 39.86312217812529,-75.04703508658118 39.863159576805835,-75.04701889765165 39.839435369784724,-75.1043127737855 39.83939800236456))	Runnemede Borough	Camden	New Jersey
3400768340	POLYGON((-75.04081728441804 39.832965094177865,-75.04083366341644 39.86061836793231,-74.99984855783477 39.860625554853826,-74.99984861858051 39.83297227409745,-75.04081728441804 39.832965094177865))	Somerdale Borough	Camden	New Jersey
3400771220	POLYGON((-75.04030823929278 39.81781751781761,-75.04032281818367 39.84275759066796,-74.99219989252803 39.842764335989386,-74.99220271269184 39.8178242572112,-75.04030823929278 39.81781751781761))	Stratford Borough	Camden	New Jersey
3400772240	POLYGON((-75.03775094380674 39.872114465754166,-75.03775610264589 39.8815229755223,-75.01787442090168 39.88152774350592,-75.01787197861348 39.87211923215712,-75.03775094380674 39.872114465754166))	Tavistock Borough	Camden	New Jersey
3400776220	POLYGON((-75.02218025028499 39.80645328522722,-75.02220295211309 39.87697796351223,-74.90426170389341 39.87694057671733,-74.90435959315192 39.80641599125932,-75.02218025028499 39.80645328522722))	Voorhees Township	Camden	New Jersey
3400777630	POLYGON((-74.92077694863724 39.66919918148499,-74.92063068034506 39.79685693664406,-74.72840002763226 39.796566245320896,-74.72890054749942 39.66890979621948,-74.92077694863724 39.66919918148499))	Waterford Township	Camden	New Jersey
3400781740	POLYGON((-75.02709323369399 39.59961003900587,-75.02716920718495 39.79365624244232,-74.78840366490374 39.79346651621109,-74.78899534831176 39.59942160730626,-75.02709323369399 39.59961003900587))	Winslow Township	Camden	New Jersey
3401513360	POLYGON((-75.12365187190969 39.63859777531966,-75.12372902423985 39.68187787566372,-75.02914899077278 39.68194012946845,-75.02913081460781 39.63865993410893,-75.12365187190969 39.63859777531966))	Clayton Borough	Gloucester	New Jersey
3401517710	POLYGON((-75.17815435887108 39.76372372147312,-75.17842391170272 39.86804810265072,-75.06883852604639 39.868164902944464,-75.06873452809387 39.76384009296219,-75.17815435887108 39.76372372147312))	Deptford Township	Gloucester	New Jersey
3401519180	POLYGON((-75.29188404733246 39.754527372386086,-75.2921990772058 39.829025327835986,-75.1834272626699 39.829248280060696,-75.18322950135594 39.754749739709595,-75.29188404733246 39.754527372386086))	East Greenwich Township	Gloucester	New Jersey
3401521060	POLYGON((-75.22208864590345 39.61581814915892,-75.22240120624127 39.71338633736435,-75.09469613481376 39.713560723155474,-75.0945630487605 39.61599193552918,-75.22208864590345 39.61581814915892))	Elk Township	Gloucester	New Jersey
3401528185	POLYGON((-75.3487260278405 39.789749843855375,-75.34905322657373 39.8544477724495,-75.23247183451709 39.85473998404585,-75.23225391492849 39.79004138971226,-75.3487260278405 39.789749843855375))	Greenwich Township	Gloucester	New Jersey
3401524840	POLYGON((-75.14331601531063 39.507407940283315,-75.14365131600604 39.66996823802926,-74.90222776055445 39.6700159231242,-74.90245597408058 39.50745535246019,-75.14331601531063 39.507407940283315))	Franklin Township	Gloucester	New Jersey
3401526340	POLYGON((-75.17139447987101 39.67442743026434,-75.17155786491573 39.7404288065056,-75.04967878724315 39.74054494358156,-75.04963147483772 39.67454329722174,-75.17139447987101 39.67442743026434))	Glassboro Borough	Gloucester	New Jersey
3401530180	POLYGON((-75.2807443820118 39.68082936824212,-75.28109018221656 39.76604932542441,-75.1346022632964 39.766311645119515,-75.13443667208162 39.68109090050945,-75.2807443820118 39.68082936824212))	Harrison Township	Gloucester	New Jersey
3401541160	POLYGON((-75.43507859411368 39.74053870971954,-75.4357517357169 39.847297180846496,-75.28022403073838 39.84777712292896,-75.2797911358268 39.74101684850882,-75.43507859411368 39.74053870971954))	Logan Township	Gloucester	New Jersey
3401549680	POLYGON((-75.20192612279241 39.855578888497206,-75.2020010987291 39.88114731772348,-75.16745134636496 39.881202344303475,-75.16738919396009 39.855633865513724,-75.20192612279241 39.855578888497206))	National Park Borough	Gloucester	New Jersey
3401543440	POLYGON((-75.23429012867909 39.71067417939976,-75.23460388418914 39.803213001628116,-75.1084186803931 39.80339950605954,-75.10827368169925 39.710860076116454,-75.23429012867909 39.71067417939976))	Mantua Township	Gloucester	New Jersey
3401547250	POLYGON((-75.10099785764308 39.57109419908332,-75.10123413003807 39.73327263768901,-74.8675356404319 39.73324120397939,-74.86784480123812 39.571062944781595,-75.10099785764308 39.57109419908332))	Monroe Township	Gloucester	New Jersey
3401557150	POLYGON((-75.2590984646001 39.817547127467755,-75.25926239740397 39.86115513130858,-75.22059012565246 39.86123511910582,-75.2204506449784 39.81762699240284,-75.2590984646001 39.817547127467755))	Paulsboro Borough	Gloucester	New Jersey
3401559070	POLYGON((-75.1522782932499 39.71759502022673,-75.15235163693028 39.75091846157385,-75.1115463042138 39.75096484539627,-75.11149260453243 39.717641349558754,-75.1522782932499 39.71759502022673))	Pitman Borough	Gloucester	New Jersey
3401569030	POLYGON((-75.32404343380554 39.65755872379617,-75.32441910130154 39.737844812920066,-75.2027055018717 39.73812114586153,-75.2024707719854 39.65783427506832,-75.32404343380554 39.65755872379617))	South Harrison Township	Gloucester	New Jersey
3401577180	POLYGON((-75.13582024441675 39.702743760258464,-75.13602945146125 39.80917559634576,-75.00951813891952 39.80925493913582,-75.0095035004047 39.70282280577139,-75.13582024441675 39.702743760258464))	Washington Township	Gloucester	New Jersey
3401578110	POLYGON((-75.16181484932147 39.77961497307115,-75.16187126042857 39.803686988507266,-75.13670695784856 39.80371936290146,-75.13665931626856 39.77964731999744,-75.16181484932147 39.77961497307115))	Wenonah Borough	Gloucester	New Jersey
3401578800	POLYGON((-75.24265669900207 39.79049525255622,-75.24300015525297 39.88801133314553,-75.12404045940481 39.88819956873816,-75.12386513915425 39.79068284220487,-75.24265669900207 39.79049525255622))	West Deptford Township	Gloucester	New Jersey
3401580120	POLYGON((-75.14706340249207 39.854712660364584,-75.14713735531525 39.88933373265512,-75.11068658543341 39.889374248059276,-75.11063095305458 39.85475312636425,-75.14706340249207 39.854712660364584))	Westville Borough	Gloucester	New Jersey
3401582120	POLYGON((-75.17310569015147 39.82261595407474,-75.1731912928195 39.856701326433445,-75.13321004332495 39.85675412835309,-75.13314420188873 39.82266869259021,-75.17310569015147 39.82261595407474))	Woodbury City	Gloucester	New Jersey
3401582180	POLYGON((-75.16711927582178 39.805133343856774,-75.16717366322791 39.827585647237605,-75.13448258895713 39.82762814492381,-75.1344388370067 39.805175807916555,-75.16711927582178 39.805133343856774))	Woodbury Heights Borough	Gloucester	New Jersey
3402131620	POLYGON((-74.53899792954189 40.25646839850764,-74.53883819841455 40.279991044869604,-74.51240239995556 40.279882663543766,-74.51257128670545 40.25636010677457,-74.53899792954189 40.25646839850764))	Hightstown Borough	Mercer	New Jersey
3401582840	POLYGON((-75.38468220977701 39.6841183567494,-75.38531431407867 39.797711212739664,-75.25847048043431 39.79806306196465,-75.25804645516631 39.68446879902073,-75.38468220977701 39.6841183567494))	Woolwich Township	Gloucester	New Jersey
3402119780	POLYGON((-74.58626318257068 40.21264911376171,-74.5856974617398 40.30546004543826,-74.47513416996894 40.30501127669304,-74.47585084741482 40.21220180701443,-74.58626318257068 40.21264911376171))	East Windsor Township	Mercer	New Jersey
3402122185	POLYGON((-74.860634295765 40.23010204742224,-74.86050261500813 40.294243374018215,-74.74415544812874 40.29404459911049,-74.7443969543762 40.22990372026577,-74.860634295765 40.23010204742224))	Ewing Township	Mercer	New Jersey
3402129310	POLYGON((-74.76183044843823 40.13051892498648,-74.76131452130461 40.27778462714751,-74.57826232894547 40.2772622400911,-74.57917390758223 40.12999923656894,-74.76183044843823 40.13051892498648))	Hamilton Township	Mercer	New Jersey
3402133180	POLYGON((-74.95256667151068 40.270403168606336,-74.95245349351073 40.43175252766428,-74.70331498352388 40.43138162686006,-74.70402118964809 40.2700343647854,-74.95256667151068 40.270403168606336))	Hopewell Township	Mercer	New Jersey
3402139510	POLYGON((-74.77033188118288 40.23392936802316,-74.76988921075073 40.36453596364681,-74.65631208341203 40.364254218215656,-74.65697323655198 40.23364891309052,-74.77033188118288 40.23392936802316))	Lawrence Township	Mercer	New Jersey
3402160900	POLYGON((-74.7280763593203 40.3006717488446,-74.72769503928798 40.39555457129782,-74.61174371160682 40.39522338578309,-74.61228739469684 40.300341665739424,-74.7280763593203 40.3006717488446))	Princeton	Mercer	New Jersey
3402163850	POLYGON((-74.65592091327646 40.17529107398325,-74.65543741622697 40.270791693610875,-74.53000575175766 40.270350215790785,-74.53066524335073 40.17485107633534,-74.65592091327646 40.17529107398325))	Robbinsville Township	Mercer	New Jersey
3402174000	POLYGON((-74.82358201497657 40.18078419154499,-74.82339809147693 40.25166892934795,-74.72450348671862 40.25147576204676,-74.72479040221086 40.180591505183344,-74.82358201497657 40.18078419154499))	Trenton City	Mercer	New Jersey
3402180240	POLYGON((-74.69148973339263 40.236807446564185,-74.6909819660163 40.34837608006769,-74.56032167612578 40.347953198293666,-74.56104412549816 40.2363862200176,-74.69148973339263 40.236807446564185))	West Windsor Township	Mercer	New Jersey
\.


--
-- Data for Name: source; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.source (id, agency, year_from, year_to, citation, dataset) FROM stdin;
5	U.S Census Bureau	\N	2022	U.S Census Bureau, “Age and Sex,” American Community Survey 5-Year Estimates Subject Tables, Table S0101, 2022	“Age and Sex,” American Community Survey 5-Year Estimates Subject Tables, Table S0101
11	fdsafsad	\N	2025	fdsafsad, fafsf, 2025	fafsf
9	DVRPC	\N	2020	DVRPC, Circuit Trails, 2020	Circuit Trails
10	SEPTA	\N	2022	SEPTA, Bus Network, 2022	Bus Network
\.


--
-- Data for Name: sql; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.sql (id, name, data_source, geo_level, body) FROM stdin;
3	Trails	gis	county	SELECT\n  c.fips,\n  COALESCE((\n    SELECT (SUM(ST_Length(ST_Intersection(c.shape, t.shape))) / 1609.34)\n    FROM transportation.all_trails t\n    WHERE ST_Intersects(c.shape, t.shape)\n  ), 0) AS existing_trail_mi,\n  COALESCE((\n    SELECT (SUM(ST_Length(ST_Intersection(c.shape, ct.shape))) / 1609.34)\n    FROM transportation.circuittrails ct\n    WHERE ST_Intersects(c.shape, ct.shape) and ct.circuit != 'Existing'\n  ), 0) AS planned_trail_mi\nFROM\n  boundaries.countyboundaries c\nwhere c.dvrpc_reg = 'Yes';
2	Land Use	gis	municipality	select\n  geoid,\n  ROUND(SUM(acres), 2) as total_acres,\n  ROUND(SUM(CASE WHEN lu23catn = 'Agriculture' THEN acres ELSE 0 END), 2) AS agriculture_acres,\n  ROUND(SUM(CASE WHEN lu23catn = 'Commercial' THEN acres ELSE 0 END), 2) AS commercial_acres,\n  ROUND(SUM(CASE WHEN lu23catn = 'Industrial' THEN acres ELSE 0 END), 2) AS industrial_acres,\n  ROUND(SUM(CASE WHEN lu23catn = 'Institutional' THEN acres ELSE 0 END), 2) AS institutional_acres,\n  ROUND(SUM(CASE WHEN lu23catn = 'Military' THEN acres ELSE 0 END), 2) AS military_acres,\n  ROUND(SUM(CASE WHEN lu23catn = 'Mining' THEN acres ELSE 0 END), 2) AS mining_acres,\n  ROUND(SUM(CASE WHEN lu23catn = 'Recreation' THEN acres ELSE 0 END), 2) AS recreation_acres,\n  ROUND(SUM(CASE WHEN lu23catn = 'Residential' THEN acres ELSE 0 END), 2) AS residential_acres,\n  ROUND(SUM(CASE WHEN lu23catn = 'Transportation' THEN acres ELSE 0 END), 2) AS transportation_acres,\n  ROUND(SUM(CASE WHEN lu23catn = 'Undeveloped' THEN acres ELSE 0 END), 2) AS undeveloped_acres,\n  ROUND(SUM(CASE WHEN lu23catn = 'Utility' THEN acres ELSE 0 END), 2) AS utility_acres,\n  ROUND(SUM(CASE WHEN lu23catn = 'Water' THEN acres ELSE 0 END), 2) AS water_acres,\n  ROUND(SUM(CASE WHEN lu23catn = 'Wooded' THEN acres ELSE 0 END), 2) AS wooded_acres\nFROM planning.dvrpc_landuse_2023\nGROUP BY geoid;\n
5	Freight	gis	county	SELECT\n  c.fips,\n  COALESCE((\n    SELECT (SUM(ST_Length(ST_Intersection(c.shape, fr.shape))) / 1609.34)\n    FROM freight.freight_rail fr\n    WHERE ST_Intersects(c.shape, fr.shape)\n  ), 0) AS freight_rail_mi,\n  COALESCE((\n    SELECT (SUM(ST_Length(ST_Intersection(c.shape, hw.shape))) / 1609.34)\n    FROM freight.highways hw\n    WHERE ST_Intersects(c.shape, hw.shape)\n  ), 0) AS highway_mi,\n  COALESCE((\n    SELECT COUNT(*)\n    FROM freight.freight_centers fc\n    WHERE ST_Area(ST_Intersection(c.shape, fc.shape)) > 0\n  ), 0) AS unique_freight_centers\nFROM\n  boundaries.countyboundaries c\nwhere c.dvrpc_reg = 'Yes';
6	Passenger Rail	gis	county	SELECT\n  c.fips,\n  COALESCE((\n    SELECT COUNT(*)\n    FROM transportation.passengerrailstations prs\n    WHERE ST_Intersects(c.shape, prs.shape)\n  ), 0) AS passenger_rail_stations,\n\n  COALESCE((\n    SELECT (SUM(ST_Length(ST_Intersection(c.shape, pr.shape))) / 1609.34)\n    FROM transportation.passengerrail pr\n    WHERE ST_Intersects(c.shape, pr.shape)\n  ), 0) AS passenger_rail_mi\nFROM\n  boundaries.countyboundaries c\nwhere c.dvrpc_reg = 'Yes';
7	TIP	gis	county	SELECT\n  c.fips,  \nCOALESCE((\n    SELECT COUNT(*)\n    FROM transportation.patip_fy2025_2028_line tip\n    WHERE ST_Intersects(c.shape, tip.shape)\n  ), 0) AS fy25_pa_lines,\n  COALESCE((\n    SELECT COUNT(*)\n    FROM transportation.njtip_fy2026_2029_line tip\n    WHERE ST_Intersects(c.shape, tip.shape)\n  ), 0) AS fy26_nj_lines,\n  COALESCE((\n    SELECT COUNT(*)\n    FROM transportation.patip_fy2025_2028_point tip\n    WHERE ST_Intersects(c.shape, tip.shape)\n  ), 0) AS fy25_pa_points,\n  COALESCE((\n    SELECT COUNT(*)\n    FROM transportation.njtip_fy2026_2029_point tip\n    WHERE ST_Intersects(c.shape, tip.shape)\n  ), 0) AS fy26_nj_points\nFROM\n  boundaries.countyboundaries c\nwhere c.dvrpc_reg = 'Yes';
8	SEPTA Bus	gis	county	SELECT\n  c.fips,\nCOALESCE((\n    SELECT COUNT(*)\n    FROM transportation.septa_transitstops sp\n    WHERE ST_Intersects(c.shape, ST_transform(sp.shape, 26918))\n  ), 0) AS septa_bus_stops,\n  COALESCE((\n    SELECT (SUM(ST_Length(ST_Intersection(c.shape, ST_transform(sp.shape, 26918)))) / 1609.34)\n    FROM transportation.septa_transitroutes sp\n    WHERE ST_Intersects(c.shape, ST_transform(sp.shape, 26918))\n  ), 0) AS septa_bus_routes_mi\nFROM\n  boundaries.countyboundaries c\nwhere c.dvrpc_reg = 'Yes';
9	NJT Bus	gis	county	SELECT\n  c.fips,  \nCOALESCE((\n    SELECT COUNT(*)\n    FROM transportation.njtransit_transitstops njt\n    WHERE ST_Intersects(c.shape, ST_transform(njt.shape, 26918))\n  ), 0) AS njt_bus_stops,\n  COALESCE((\n    SELECT (SUM(ST_Length(ST_Intersection(c.shape, ST_transform(njt.shape, 26918)))) / 1609.34)\n    FROM transportation.njtransit_transitroutes njt\n    WHERE ST_Intersects(c.shape, ST_transform(njt.shape, 26918))\n  ), 0) AS njt_bus_routes_mi\nFROM\n  boundaries.countyboundaries c\nwhere c.dvrpc_reg = 'Yes';
10	Open Space	gis	county	SELECT\n  c.fips,\nCOALESCE((\n    SELECT (SUM(ST_Area(ST_Intersection(c.shape, os.shape))) / 1609.34)\n    FROM planning.dvrpc_protectedopenspace os\n    WHERE ST_Intersects(c.shape, os.shape)\n  ), 0) AS protected_open_space_sq_mi\nFROM\n  boundaries.countyboundaries c\nwhere c.dvrpc_reg = 'Yes';
11	Population & Employment Forecasts	gis	county	SELECT fips, pop20, pop25, pop30, pop35, pop40, pop45, pop50, emp20, emp25, emp30, emp35, emp40, emp45, emp50, popabs50, poppct50, empabs50, emppct50\nFROM demographics.forecast_2050_county_table_v2;
12	Population & Employment Forecasts	gis	municipality	SELECT geoid, pop20, pop25, pop30, pop35, pop40, pop45, pop50, emp20, emp25, emp30, emp35, emp40, emp45, emp50, popabs50, poppct50, empabs50, emppct50\nFROM demographics.forecast_2050_mcd_table_v2;
13	Trails	gis	municipality	SELECT\n  m.geoid,\n  COALESCE((\n    SELECT (SUM(ST_Length(ST_Intersection(m.shape, t.shape))) / 1609.34)\n    FROM transportation.all_trails t\n    WHERE ST_Intersects(m.shape, t.shape)\n  ), 0) AS existing_trail_mi,\n  COALESCE((\n    SELECT (SUM(ST_Length(ST_Intersection(m.shape, ct.shape))) / 1609.34)\n    FROM transportation.circuittrails ct\n    WHERE ST_Intersects(m.shape, ct.shape) and ct.circuit != 'Existing'\n  ), 0) AS planned_trail_mi\nFROM\n  boundaries.municipalboundaries m\nwhere m.dvrpc_reg = 'Yes';
14	Freight	gis	municipality	SELECT\n  m.geoid,\n  COALESCE((\n    SELECT (SUM(ST_Length(ST_Intersection(m.shape, fr.shape))) / 1609.34)\n    FROM freight.freight_rail fr\n    WHERE ST_Intersects(m.shape, fr.shape)\n  ), 0) AS freight_rail_mi,\n  COALESCE((\n    SELECT (SUM(ST_Length(ST_Intersection(m.shape, hw.shape))) / 1609.34)\n    FROM freight.highways hw\n    WHERE ST_Intersects(m.shape, hw.shape)\n  ), 0) AS highway_mi,\n  COALESCE((\n    SELECT COUNT(*)\n    FROM freight.freight_centers fc\n    WHERE ST_Area(ST_Intersection(m.shape, fc.shape)) > 0\n  ), 0) AS unique_freight_centers\nFROM\n  boundaries.municipalboundaries m\nwhere m.dvrpc_reg = 'Yes';
15	TIP	gis	municipality	SELECT\n  m.geoid,\n  COALESCE((\n    SELECT COUNT(*)\n    FROM transportation.patip_fy2025_2028_line tip\n    WHERE ST_Intersects(m.shape, tip.shape)\n  ), 0) AS fy25_pa_lines,\n    COALESCE((\n    SELECT COUNT(*)\n    FROM transportation.njtip_fy2026_2029_line tip\n    WHERE ST_Intersects(m.shape, tip.shape)\n  ), 0) AS fy26_nj_lines,\n  COALESCE((\n    SELECT COUNT(*)\n    FROM transportation.patip_fy2025_2028_point tip\n    WHERE ST_Intersects(m.shape, tip.shape)\n  ), 0) AS fy25_pa_points,\n  COALESCE((\n    SELECT COUNT(*)\n    FROM transportation.njtip_fy2026_2029_point tip\n    WHERE ST_Intersects(m.shape, tip.shape)\n  ), 0) AS fy26_nj_points\nFROM\n  boundaries.municipalboundaries m\nwhere m.dvrpc_reg = 'Yes';
16	SEPTA Bus	gis	municipality	SELECT\n  m.geoid,\n  COALESCE((\n    SELECT COUNT(*)\n    FROM transportation.septa_transitstops sp\n    WHERE ST_Intersects(m.shape, ST_transform(sp.shape, 26918))\n  ), 0) AS septa_bus_stops,\n  COALESCE((\n    SELECT (SUM(ST_Length(ST_Intersection(m.shape, ST_transform(sp.shape, 26918)))) / 1609.34)\n    FROM transportation.septa_transitroutes sp\n    WHERE ST_Intersects(m.shape, ST_transform(sp.shape, 26918))\n  ), 0) AS septa_bus_routes_mi\nFROM\n  boundaries.municipalboundaries m\nwhere m.dvrpc_reg = 'Yes';
17	NJT Bus	gis	municipality	SELECT\n  m.geoid,\n  COALESCE((\n    SELECT COUNT(*)\n    FROM transportation.njtransit_transitstops njt\n    WHERE ST_Intersects(m.shape, ST_transform(njt.shape, 26918))\n  ), 0) AS njt_bus_stops,\n  COALESCE((\n    SELECT (SUM(ST_Length(ST_Intersection(m.shape, ST_transform(njt.shape, 26918)))) / 1609.34)\n    FROM transportation.njtransit_transitroutes njt\n    WHERE ST_Intersects(m.shape, ST_transform(njt.shape, 26918))\n  ), 0) AS njt_bus_routes_mi\nFROM\n  boundaries.municipalboundaries m\nwhere m.dvrpc_reg = 'Yes';
18	Passenger Rail	gis	municipality	SELECT\n  m.geoid,\n  COALESCE((\n    SELECT COUNT(*)\n    FROM transportation.passengerrailstations prs\n    WHERE ST_Intersects(m.shape, prs.shape)\n  ), 0) AS passenger_rail_stations,\n  COALESCE((\n    SELECT (SUM(ST_Length(ST_Intersection(m.shape, pr.shape))) / 1609.34)\n    FROM transportation.passengerrail pr\n    WHERE ST_Intersects(m.shape, pr.shape)\n  ), 0) AS passenger_rail_mi\nFROM\n  boundaries.municipalboundaries m\nwhere m.dvrpc_reg = 'Yes';
19	Open Space	gis	municipality	SELECT\n  m.geoid,\n  COALESCE((\n    SELECT (SUM(ST_Area(ST_Intersection(m.shape, os.shape))) / 1609.34)\n    FROM planning.dvrpc_protectedopenspace os\n    WHERE ST_Intersects(m.shape, os.shape)\n  ), 0) AS protected_open_space_sq_mi\nFROM\n  boundaries.municipalboundaries m\nwhere m.dvrpc_reg = 'Yes';
20	Bridge Conditions	ckan	county	SELECT\n    county_id as fips,\n    SUM(CASE WHEN nhs_type = 'All' AND condition = 'Good' THEN count_bridges ELSE 0 END) AS bridge_all_good,\n    SUM(CASE WHEN nhs_type = 'All' AND condition = 'Fair' THEN count_bridges ELSE 0 END) AS bridge_all_fair,\n    SUM(CASE WHEN nhs_type = 'All' AND condition = 'Poor' THEN count_bridges ELSE 0 END) AS bridge_all_poor,\n    SUM(CASE WHEN nhs_type = 'NHS' AND condition = 'Good' THEN count_bridges ELSE 0 END) AS bridge_nhs_good,\n    SUM(CASE WHEN nhs_type = 'NHS' AND condition = 'Fair' THEN count_bridges ELSE 0 END) AS bridge_nhs_fair,\n    SUM(CASE WHEN nhs_type = 'NHS' AND condition = 'Poor' THEN count_bridges ELSE 0 END) AS bridge_nhs_poor,\n    SUM(CASE WHEN nhs_type = 'Non-NHS' AND condition = 'Good' THEN count_bridges ELSE 0 END) AS bridge_nonnhs_good,\n    SUM(CASE WHEN nhs_type = 'Non-NHS' AND condition = 'Fair' THEN count_bridges ELSE 0 END) AS bridge_nonnhs_fair,\n    SUM(CASE WHEN nhs_type = 'Non-NHS' AND condition = 'Poor' THEN count_bridges ELSE 0 END) AS bridge_nonnhs_poor\nFROM\n    "6b065499-c75d-48bd-a3c1-6c7bcf030efa" as t\nWHERE\n    year = (SELECT MAX(year) FROM "6b065499-c75d-48bd-a3c1-6c7bcf030efa")\nGROUP BY\n    county_id
21	Electric Vehicles	ckan	county	SELECT geoid as fips, bev, phev, total_ev, other_fuel, total_ldv, pct_ev_ldv, change_ev, pct_change_ev, change_ldv, pct_change_ldv FROM "97af7cbb-11b9-4f98-9d71-b2a6e5bfb994" WHERE YEAR = (SELECT MAX(YEAR) FROM "97af7cbb-11b9-4f98-9d71-b2a6e5bfb994")
22	Housing Affordability	ckan	county	SELECT county_id as fips, percent_cost_burdened from "4a3105ac-cc2f-4ba2-8b25-68ae4c1e311c" WHERE year = (SELECT MAX(year) FROM "4a3105ac-cc2f-4ba2-8b25-68ae4c1e311c")
23	Pavement Conditions	ckan	county	SELECT\n    county_id as fips,\n    SUM(CASE WHEN metric = 'PM2' AND pavement_condition = 'Good' THEN miles ELSE 0 END) AS road_pm2_good,\n    SUM(CASE WHEN metric = 'PM2' AND pavement_condition = 'Fair' THEN miles ELSE 0 END) AS road_pm2_fair,\n    SUM(CASE WHEN metric = 'PM2' AND pavement_condition = 'Poor' THEN miles ELSE 0 END) AS road_pm2_poor,\n    SUM(CASE WHEN metric = 'IRI' AND pavement_condition = 'Good' THEN miles ELSE 0 END) AS road_iri_good,\n    SUM(CASE WHEN metric = 'IRI' AND pavement_condition = 'Fair' THEN miles ELSE 0 END) AS road_iri_fair,\n    SUM(CASE WHEN metric = 'IRI' AND pavement_condition = 'Poor' THEN miles ELSE 0 END) AS road_iri_poor,\n    SUM(CASE WHEN metric = 'DOT Pavement Index' AND pavement_condition = 'Good' THEN miles ELSE 0 END) AS road_dot_index_good,\n    SUM(CASE WHEN metric = 'DOT Pavement Index' AND pavement_condition = 'Fair' THEN miles ELSE 0 END) AS road_dot_index_fair,\n    SUM(CASE WHEN metric = 'DOT Pavement Index' AND pavement_condition = 'Poor' THEN miles ELSE 0 END) AS road_dot_index_poor\nFROM\n    "4e632db0-9830-4f7b-9ff3-072353ea9e6a"\nWHERE\n    year = (SELECT MAX(year) FROM "4e632db0-9830-4f7b-9ff3-072353ea9e6a") AND road_type = 'Total'\nGROUP BY\n    county_id
24	Electric Vehicles	ckan	municipality	SELECT geoid, bev, phev, total_ev, other_fuel, total_ldv, pct_ev_ldv, change_ev, pct_change_ev, change_ldv, pct_change_ldv FROM "31691dde-5bd5-4570-ab9f-79c498f72497" WHERE YEAR = (SELECT MAX(YEAR) FROM "31691dde-5bd5-4570-ab9f-79c498f72497") AND geoid IS NOT NULL
1	Land Use	gis	county	select\n  SUBSTRING(geoid, 0, 6) as fips,\n  ROUND(SUM(acres), 2) as total_acres,\n  ROUND(SUM(CASE WHEN lu23catn = 'Agriculture' THEN acres ELSE 0 END), 2) AS agriculture_acres,\n  ROUND(SUM(CASE WHEN lu23catn = 'Commercial' THEN acres ELSE 0 END), 2) AS commercial_acres,\n  ROUND(SUM(CASE WHEN lu23catn = 'Industrial' THEN acres ELSE 0 END), 2) AS industrial_acres,\n  ROUND(SUM(CASE WHEN lu23catn = 'Institutional' THEN acres ELSE 0 END), 2) AS institutional_acres,\n  ROUND(SUM(CASE WHEN lu23catn = 'Military' THEN acres ELSE 0 END), 2) AS military_acres,\n  ROUND(SUM(CASE WHEN lu23catn = 'Mining' THEN acres ELSE 0 END), 2) AS mining_acres,\n  ROUND(SUM(CASE WHEN lu23catn = 'Recreation' THEN acres ELSE 0 END), 2) AS recreation_acres,\n  ROUND(SUM(CASE WHEN lu23catn = 'Residential' THEN acres ELSE 0 END), 2) AS residential_acres,\n  ROUND(SUM(CASE WHEN lu23catn = 'Transportation' THEN acres ELSE 0 END), 2) AS transportation_acres,\n  ROUND(SUM(CASE WHEN lu23catn = 'Undeveloped' THEN acres ELSE 0 END), 2) AS undeveloped_acres,\n  ROUND(SUM(CASE WHEN lu23catn = 'Utility' THEN acres ELSE 0 END), 2) AS utility_acres,\n  ROUND(SUM(CASE WHEN lu23catn = 'Water' THEN acres ELSE 0 END), 2) AS water_acres,\n  ROUND(SUM(CASE WHEN lu23catn = 'Wooded' THEN acres ELSE 0 END), 2) AS wooded_acres\nFROM planning.dvrpc_landuse_2023\nGROUP BY fips;\n
\.


--
-- Data for Name: subcategory; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.subcategory (id, name, category_id, label, sort_weight) FROM stdin;
1	income-poverty	1	Income Poverty	0
2	pedestrian	2	Pedestrian	0
3	housing	3	Housing	0
4	commute	2	Commute	0
5	crash	4	Crash	0
6	transportation	1	Transportation	0
7	demographics	3	Demographics	0
8	cycling	2	Cycling	0
9	employment	1	Employment	0
10	health	4	Health	0
11	freight	8	Freight	0
12	tip	6	Tip	0
13	open-space	7	Open Space	0
14	planning	7	Planning	0
15	transit	6	Transit	0
16	tip	5	Tip	0
17	conditions	5	Conditions	0
\.


--
-- Data for Name: topic; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.topic (id, name, subcategory_id, label, sort_weight) FROM stdin;
2	asthma	10	Asthma	0
3	bridge	17	Bridge	0
4	bus	15	Bus	0
5	circuit-trails	8	Circuit Trails	0
6	commute	6	Commute	0
7	commute-mode	4	Commute Mode	0
8	electric-vehicles	6	Electric Vehicles	0
9	emphasis-areas	5	Emphasis Areas	0
10	employment	9	Employment	0
11	employment-forecasts	9	Employment Forecasts	0
13	household-vehicles	3	Household Vehicles	0
14	housing-burden	3	Housing Burden	0
15	income	1	Income	0
16	infrastructure	11	Infrastructure	0
17	land-use	14	Land Use	0
18	lep	7	Lep	0
19	lts	8	Lts	0
20	open-space	13	Open Space	0
21	other	10	Other	0
22	pavement	17	Pavement	0
23	pedestrian-network	2	Pedestrian Network	0
26	poverty	1	Poverty	0
27	rail	15	Rail	0
28	rent-own	3	Rent Own	0
29	rhin	5	Rhin	0
30	summary	5	Summary	0
31	tip	12	Tip	0
32	tip	16	Tip	0
34	units-permits	3	Units Permits	0
24	population	7	Population	10
25	population-forecasts	7	Population Forecasts	9
1	age	7	Age	8
12	gender	7	Gender	7
33	title-vi	7	Title VI	6
\.


--
-- Data for Name: variable; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.variable (id, name, data_source, acs_variable, data_year, description, concept, last_updated, aggregateable) FROM stdin;
69	age_60_to_64_pop	acs	S0101_C01_014E	2024	Estimate!!Total!!Total population!!AGE!!60 to 64 years	Age and Sex	2026-06-11	t
124	male_not_in_labor_force_60_61	acs	B23001_065E	2024	Estimate!!Total:!!Male:!!60 and 61 years:!!Not in labor force	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
202	family_hh	acs	B11001_002E	2024	Estimate!!Total:!!Family households:	Household Type (Including Living Alone)	2026-06-11	t
177	female_not_in_labor_force_75	acs	B23001_173E	2024	Estimate!!Total:!!Female:!!75 years and over:!!Not in labor force	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
486	road_pm2_good	ckan	\N	\N	\N	Pavement Conditions	\N	t
490	road_iri_fair	ckan	\N	\N	\N	Pavement Conditions	\N	t
494	road_dot_index_poor	ckan	\N	\N	\N	Pavement Conditions	\N	t
31	russian_polish_or_other_slavic_languages_w	acs	C16001_013E	2024	Estimate!!Total:!!Russian, Polish, or other Slavic languages:!!Speak English "very well"	Language Spoken at Home for the Population 5 Years and Over	2026-06-11	t
33	other_indo_european_languages	acs	C16001_015E	2024	Estimate!!Total:!!Other Indo-European languages:	Language Spoken at Home for the Population 5 Years and Over	2026-06-11	t
1	total_pop	acs	B01003_001E	2024	Estimate!!Total	Total Population	2026-06-11	t
478	other_fuel	ckan	\N	\N	\N	Electric Vehicles	2026-06-10	t
482	pct_change_ev	ckan	\N	\N	\N	Electric Vehicles	2026-06-10	t
11	asian_alone_pop	acs	B03002_006E	2024	Estimate!!Total:!!Not Hispanic or Latino:!!Asian alone	Hispanic or Latino Origin by Race	2026-06-11	t
12	haw_pac_alone_pop	acs	B03002_007E	2024	Estimate!!Total:!!Not Hispanic or Latino:!!Native Hawaiian and Other Pacific Islander alone	Hispanic or Latino Origin by Race	2026-06-11	t
13	other_alone_pop	acs	B03002_008E	2024	Estimate!!Total:!!Not Hispanic or Latino:!!Some other race alone	Hispanic or Latino Origin by Race	2026-06-11	t
3	female_pop	acs	B01001_026E	2024	Estimate!!Total:!!Female:	Sex by Age	2026-06-11	t
306	geoid (county, municipality)	\N	\N	\N	\N	\N	\N	t
307	state (county, municipality)	\N	\N	\N	\N	\N	\N	t
308	county (county, municipality)	\N	\N	\N	\N	\N	\N	t
309	mun_name (municipality)	\N	\N	\N	\N	\N	\N	t
70	age_65_to_69_pop	acs	S0101_C01_015E	2024	Estimate!!Total!!Total population!!AGE!!65 to 69 years	Age and Sex	2026-06-11	t
58	age_5_to_9_pop	acs	S0101_C01_003E	2024	Estimate!!Total!!Total population!!AGE!!5 to 9 years	Age and Sex	2026-06-11	t
213	comm_ferry	acs	B08006_013E	2024	Estimate!!Total:!!Public transportation (excluding taxicab):!!Ferryboat	Sex of Workers by Means of Transportation to Work	2026-06-11	t
197	mean_family_inc	acs	S1901_C02_013E	2024	Estimate!!Families!!Mean income (dollars)	Income in the Past 12 Months (in 2024 Inflation-Adjusted Dollars)	2026-06-11	f
466	bridge_all_good	ckan	\N	\N	\N	Bridge Conditions	\N	t
470	bridge_nhs_fair	ckan	\N	\N	\N	Bridge Conditions	\N	t
474	bridge_nonnhs_poor	ckan	\N	\N	\N	Bridge Conditions	\N	t
383	total_acres	gis	\N	\N	\N	Land Use	2026-06-10	t
384	agriculture_acres	gis	\N	\N	\N	Land Use	2026-06-10	t
385	commercial_acres	gis	\N	\N	\N	Land Use	2026-06-10	t
387	institutional_acres	gis	\N	\N	\N	Land Use	2026-06-10	t
386	industrial_acres	gis	\N	\N	\N	Land Use	2026-06-10	t
389	mining_acres	gis	\N	\N	\N	Land Use	2026-06-10	t
391	residential_acres	gis	\N	\N	\N	Land Use	2026-06-10	t
392	transportation_acres	gis	\N	\N	\N	Land Use	2026-06-10	t
393	undeveloped_acres	gis	\N	\N	\N	Land Use	2026-06-10	t
394	utility_acres	gis	\N	\N	\N	Land Use	2026-06-10	t
395	water_acres	gis	\N	\N	\N	Land Use	2026-06-10	t
396	wooded_acres	gis	\N	\N	\N	Land Use	2026-06-10	t
397	freight_rail_mi	gis	\N	\N	\N	Freight	2026-06-10	t
398	highway_mi	gis	\N	\N	\N	Freight	2026-06-10	t
399	unique_freight_centers	gis	\N	\N	\N	Freight	2026-06-10	t
467	bridge_all_fair	ckan	\N	\N	\N	Bridge Conditions	\N	t
471	bridge_nhs_poor	ckan	\N	\N	\N	Bridge Conditions	\N	t
487	road_pm2_fair	ckan	\N	\N	\N	Pavement Conditions	\N	t
491	road_iri_poor	ckan	\N	\N	\N	Pavement Conditions	\N	t
475	bev	ckan	\N	\N	\N	Electric Vehicles	2026-06-10	t
71	age_70_to_74_pop	acs	S0101_C01_016E	2024	Estimate!!Total!!Total population!!AGE!!70 to 74 years	Age and Sex	2026-06-11	t
9	black_alone_pop	acs	B03002_004E	2024	Estimate!!Total:!!Not Hispanic or Latino:!!Black or African American alone	Hispanic or Latino Origin by Race	2026-06-11	t
181	hh_inc_20k_25k	acs	B19001_005E	2024	Estimate!!Total:!!$20,000 to $24,999	Household Income in the Past 12 Months (in 2023 Inflation-Adjusted Dollars)	2026-06-11	t
198	avg_family_size	acs	S1101_C01_004E	2024	Estimate!!Total!!FAMILIES!!Average family size	Households and Families	2026-06-11	t
171	female_not_in_labor_force_45_54	acs	B23001_137E	2024	Estimate!!Total:!!Female:!!45 to 54 years:!!Not in labor force	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
10	am_indian_alone_pop	acs	B03002_005E	2024	Estimate!!Total:!!Not Hispanic or Latino:!!American Indian and Alaska Native alone	Hispanic or Latino Origin by Race	2026-06-11	t
4	median_age	acs	B01002_001E	2024	Estimate!!Median age --!!Total:	Median Age by Sex	2026-06-11	f
479	total_ldv	ckan	\N	\N	\N	Electric Vehicles	2026-06-10	t
483	change_ldv	ckan	\N	\N	\N	Electric Vehicles	2026-06-10	t
468	bridge_all_poor	ckan	\N	\N	\N	Bridge Conditions	\N	t
472	bridge_nonnhs_good	ckan	\N	\N	\N	Bridge Conditions	\N	t
488	road_pm2_poor	ckan	\N	\N	\N	Pavement Conditions	\N	t
492	road_dot_index_good	ckan	\N	\N	\N	Pavement Conditions	\N	t
157	female_unemployed_35_44	acs	B23001_129E	2024	Estimate!!Total:!!Female:!!35 to 44 years:!!In labor force:!!Civilian:!!Unemployed	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
139	female_employed_16_19	acs	B23001_093E	2024	Estimate!!Total:!!Female:!!16 to 19 years:!!In labor force:!!Civilian:!!Employed	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
21	spanish	acs	C16001_003E	2024	Estimate!!Total:!!Spanish:	Language Spoken at Home for the Population 5 Years and Over	2026-06-11	t
176	female_not_in_labor_force_70_74	acs	B23001_168E	2024	Estimate!!Total:!!Female:!!70 to 74 years:!!Not in labor force	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
154	female_unemployed_22_24	acs	B23001_108E	2024	Estimate!!Total:!!Female:!!22 to 24 years:!!In labor force:!!Civilian:!!Unemployed	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
110	male_unemployed_55_59	acs	B23001_057E	2024	Estimate!!Total:!!Male:!!55 to 59 years:!!In labor force:!!Civilian:!!Unemployed	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
111	male_unemployed_60_61	acs	B23001_064E	2024	Estimate!!Total:!!Male:!!60 and 61 years:!!In labor force:!!Civilian:!!Unemployed	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
115	male_unemployed_75	acs	B23001_086E	2024	Estimate!!Total:!!Male:!!75 years and over:!!In labor force:!!Unemployed	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
67	age_50_to_54_pop	acs	S0101_C01_012E	2024	Estimate!!Total!!Total population!!AGE!!50 to 54 years	Age and Sex	2026-06-11	t
199	total_hh	acs	B25003_001E	2024	Estimate!!Total:	Tenure	2026-06-11	t
2	male_pop	acs	B01001_002E	2024	Estimate!!Total:!!Male:	Sex by Age	2026-06-11	t
215	comm_bike	acs	B08006_014E	2024	Estimate!!Total:!!Bicycle	Sex of Workers by Means of Transportation to Work	2026-06-11	t
223	owner_5_vehicle	acs	B25044_008E	2024	Estimate!!Total:!!Owner occupied:!!5 or more vehicles available	Tenure by Vehicles Available	2026-06-11	t
476	phev	ckan	\N	\N	\N	Electric Vehicles	2026-06-10	t
480	pct_ev_ldv	ckan	\N	\N	\N	Electric Vehicles	2026-06-10	t
484	pct_change_ldv	ckan	\N	\N	\N	Electric Vehicles	2026-06-10	t
73	age_80_to_84_pop	acs	S0101_C01_018E	2024	Estimate!!Total!!Total population!!AGE!!80 to 84 years	Age and Sex	2026-06-11	t
62	age_25_to_29_pop	acs	S0101_C01_007E	2024	Estimate!!Total!!Total population!!AGE!!25 to 29 years	Age and Sex	2026-06-11	t
118	male_not_in_labor_force_22_24	acs	B23001_023E	2024	Estimate!!Total:!!Male:!!22 to 24 years:!!Not in labor force	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
128	male_not_in_labor_force_75	acs	B23001_087E	2024	Estimate!!Total:!!Male:!!75 years and over:!!Not in labor force	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
66	age_45_to_49_pop	acs	S0101_C01_011E	2024	Estimate!!Total!!Total population!!AGE!!45 to 49 years	Age and Sex	2026-06-11	t
469	bridge_nhs_good	ckan	\N	\N	\N	Bridge Conditions	\N	t
473	bridge_nonnhs_fair	ckan	\N	\N	\N	Bridge Conditions	\N	t
485	percent_cost_burdened	ckan	\N	\N	\N	Housing Affordability	\N	t
489	road_iri_good	ckan	\N	\N	\N	Pavement Conditions	\N	t
493	road_dot_index_fair	ckan	\N	\N	\N	Pavement Conditions	\N	t
125	male_not_in_labor_force_62_64	acs	B23001_072E	2024	Estimate!!Total:!!Male:!!62 to 64 years:!!Not in labor force	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
126	male_not_in_labor_force_65_69	acs	B23001_077E	2024	Estimate!!Total:!!Male:!!65 to 69 years:!!Not in labor force	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
61	age_20_to_24_pop	acs	S0101_C01_006E	2024	Estimate!!Total!!Total population!!AGE!!20 to 24 years	Age and Sex	2026-06-11	t
137	female_armed_forces_60_61	acs	B23001_147E	2024	Estimate!!Total:!!Female:!!60 and 61 years:!!In labor force:!!In Armed Forces	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
477	total_ev	ckan	\N	\N	\N	Electric Vehicles	2026-06-10	t
481	change_ev	ckan	\N	\N	\N	Electric Vehicles	2026-06-10	t
94	male_employed_30_34	acs	B23001_035E	2024	Estimate!!Total:!!Male:!!30 to 34 years:!!In labor force:!!Civilian:!!Employed	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
17	some_college	acs	B06009_004E	2024	Estimate!!Total:!!Some college or associate's degree	Place of Birth by Educational Attainment in the United States	2026-06-11	t
161	female_unemployed_62_64	acs	B23001_157E	2024	Estimate!!Total:!!Female:!!62 to 64 years:!!In labor force:!!Civilian:!!Unemployed	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
39	chinese_mandarin_cantonese	acs	C16001_021E	2024	Estimate!!Total:!!Chinese (incl. Mandarin, Cantonese):	Language Spoken at Home for the Population 5 Years and Over	2026-06-11	t
131	female_armed_forces_22_24	acs	B23001_105E	2024	Estimate!!Total:!!Female:!!22 to 24 years:!!In labor force:!!In Armed Forces	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
41	chinese_mandarin_cantonese_lim	acs	C16001_023E	2024	Estimate!!Total:!!Chinese (incl. Mandarin, Cantonese):!!Speak English less than "very well"	Language Spoken at Home for the Population 5 Years and Over	2026-06-11	t
191	hh_inc_125k_150k	acs	B19001_015E	2024	Estimate!!Total:!!$125,000 to $149,999	Household Income in the Past 12 Months (in 2023 Inflation-Adjusted Dollars)	2026-06-11	t
169	female_not_in_labor_force_30_34	acs	B23001_123E	2024	Estimate!!Total:!!Female:!!30 to 34 years:!!Not in labor force	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
189	hh_inc_75k_100k	acs	B19001_013E	2024	Estimate!!Total:!!$75,000 to $99,999	Household Income in the Past 12 Months (in 2023 Inflation-Adjusted Dollars)	2026-06-11	t
49	other_asian_and_pacific_island_languages_w	acs	C16001_031E	2024	Estimate!!Total:!!Other Asian and Pacific Island languages:!!Speak English "very well"	Language Spoken at Home for the Population 5 Years and Over	2026-06-11	t
86	male_armed_forces_45_54	acs	B23001_047E	2024	Estimate!!Total:!!Male:!!45 to 54 years:!!In labor force:!!In Armed Forces	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
87	male_armed_forces_55_59	acs	B23001_054E	2024	Estimate!!Total:!!Male:!!55 to 59 years:!!In labor force:!!In Armed Forces	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
88	male_armed_forces_60_61	acs	B23001_061E	2024	Estimate!!Total:!!Male:!!60 and 61 years:!!In labor force:!!In Armed Forces	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
196	mean_hh_inc	acs	S1901_C01_013E	2024	Estimate!!Households!!Mean income (dollars)	Income in the Past 12 Months (in 2024 Inflation-Adjusted Dollars)	2026-06-11	f
206	comm_drive_alone	acs	B08006_003E	2024	Estimate!!Total:!!Car, truck, or van:!!Drove alone	Sex of Workers by Means of Transportation to Work	2026-06-11	t
130	female_armed_forces_20_21	acs	B23001_098E	2024	Estimate!!Total:!!Female:!!20 and 21 years:!!In labor force:!!In Armed Forces	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
30	russian_polish_or_other_slavic_languages	acs	C16001_012E	2024	Estimate!!Total:!!Russian, Polish, or other Slavic languages:	Language Spoken at Home for the Population 5 Years and Over	2026-06-11	t
194	under_18_pov_level	acs	S1701_C01_002E	2024	Estimate!!Total!!Population for whom poverty status is determined!!AGE!!Under 18 years	Poverty Status in the Past 12 Months	2026-06-11	t
175	female_not_in_labor_force_65_69	acs	B23001_163E	2024	Estimate!!Total:!!Female:!!65 to 69 years:!!Not in labor force	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
135	female_armed_forces_45_54	acs	B23001_133E	2024	Estimate!!Total:!!Female:!!45 to 54 years:!!In labor force:!!In Armed Forces	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
35	sother_indo_european_languages_lim	acs	C16001_017E	2024	Estimate!!Total:!!Other Indo-European languages:!!Speak English less than "very well"	Language Spoken at Home for the Population 5 Years and Over	2026-06-11	t
145	female_employed_45_54	acs	B23001_135E	2024	Estimate!!Total:!!Female:!!45 to 54 years:!!In labor force:!!Civilian:!!Employed	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
212	comm_light_rail	acs	B08006_012E	2024	Estimate!!Total:!!Public transportation (excluding taxicab):!!Light rail, streetcar or trolley (carro pÃºblico in Puerto Rico)	Sex of Workers by Means of Transportation to Work	2026-06-11	t
119	male_not_in_labor_force_25_29	acs	B23001_030E	2024	Estimate!!Total:!!Male:!!25 to 29 years:!!Not in labor force	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
120	male_not_in_labor_force_30_34	acs	B23001_037E	2024	Estimate!!Total:!!Male:!!30 to 34 years:!!Not in labor force	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
60	age_15_to_19_pop	acs	S0101_C01_005E	2024	Estimate!!Total!!Total population!!AGE!!15 to 19 years	Age and Sex	2026-06-11	t
156	female_unemployed_30_34	acs	B23001_122E	2024	Estimate!!Total:!!Female:!!30 to 34 years:!!In labor force:!!Civilian:!!Unemployed	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
205	comm_drive	acs	B08006_002E	2024	Estimate!!Total:!!Car, truck, or van:	Sex of Workers by Means of Transportation to Work	2026-06-11	t
55	other_and_unspecified_languages_w	acs	C16001_037E	2024	Estimate!!Total:!!Other and unspecified languages:!!Speak English "very well"	Language Spoken at Home for the Population 5 Years and Over	2026-06-11	t
68	age_55_to_59_pop	acs	S0101_C01_013E	2024	Estimate!!Total!!Total population!!AGE!!55 to 59 years	Age and Sex	2026-06-11	t
57	under_5_pop	acs	S0101_C01_002E	2024	Estimate!!Total!!Total population!!AGE!!Under 5 years	Age and Sex	2026-06-11	t
382	planned_trail_mi	gis	\N	\N	\N	Trails	2026-06-10	t
413	pop30	gis	\N	\N	\N	Population & Employment Forecasts	2026-06-10	t
414	pop35	gis	\N	\N	\N	Population & Employment Forecasts	2026-06-10	t
415	pop40	gis	\N	\N	\N	Population & Employment Forecasts	2026-06-10	t
416	pop45	gis	\N	\N	\N	Population & Employment Forecasts	2026-06-10	t
417	pop50	gis	\N	\N	\N	Population & Employment Forecasts	2026-06-10	t
418	emp20	gis	\N	\N	\N	Population & Employment Forecasts	2026-06-10	t
419	emp25	gis	\N	\N	\N	Population & Employment Forecasts	2026-06-10	t
53	arabic_lim	acs	C16001_035E	2024	Estimate!!Total:!!Arabic:!!Speak English less than "very well"	Language Spoken at Home for the Population 5 Years and Over	2026-06-11	t
19	graduate_degree	acs	B06009_006E	2024	Estimate!!Total:!!Graduate or professional degree	Place of Birth by Educational Attainment in the United States	2026-06-11	t
74	age_85_over_pop	acs	S0101_C01_019E	2024	Estimate!!Total!!Total population!!AGE!!85 years and over	Age and Sex	2026-06-11	t
20	speak_only_english	acs	C16001_002E	2024	Estimate!!Total:!!Speak only English	Language Spoken at Home for the Population 5 Years and Over	2026-06-11	t
226	renter_2_vehicle	acs	B25044_012E	2024	Estimate!!Total:!!Renter occupied:!!2 vehicles available	Tenure by Vehicles Available	2026-06-11	t
167	female_not_in_labor_force_22_24	acs	B23001_109E	2024	Estimate!!Total:!!Female:!!22 to 24 years:!!Not in labor force	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
140	female_employed_20_21	acs	B23001_100E	2024	Estimate!!Total:!!Female:!!20 and 21 years:!!In labor force:!!Civilian:!!Employed	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
7	not_hispanic_or_latino_pop	acs	B03002_002E	2024	Estimate!!Total:!!Not Hispanic or Latino:	Hispanic or Latino Origin by Race	2026-06-11	t
51	arabic	acs	C16001_033E	2024	Estimate!!Total:!!Arabic:	Language Spoken at Home for the Population 5 Years and Over	2026-06-11	t
201	rent_hh	acs	B25003_003E	2024	Estimate!!Total:!!Renter occupied	Tenure	2026-06-11	t
117	male_not_in_labor_force_20_21	acs	B23001_016E	2024	Estimate!!Total:!!Male:!!20 and 21 years:!!Not in labor force	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
388	military_acres	gis	\N	\N	\N	Land Use	2026-06-10	t
420	emp30	gis	\N	\N	\N	Population & Employment Forecasts	2026-06-10	t
421	emp35	gis	\N	\N	\N	Population & Employment Forecasts	2026-06-10	t
422	emp40	gis	\N	\N	\N	Population & Employment Forecasts	2026-06-10	t
423	emp45	gis	\N	\N	\N	Population & Employment Forecasts	2026-06-10	t
424	emp50	gis	\N	\N	\N	Population & Employment Forecasts	2026-06-10	t
425	popabs50	gis	\N	\N	\N	Population & Employment Forecasts	2026-06-10	t
426	poppct50	gis	\N	\N	\N	Population & Employment Forecasts	2026-06-10	t
427	empabs50	gis	\N	\N	\N	Population & Employment Forecasts	2026-06-10	t
428	emppct50	gis	\N	\N	\N	Population & Employment Forecasts	2026-06-10	t
381	existing_trail_mi	gis	\N	\N	\N	Trails	2026-06-10	t
390	recreation_acres	gis	\N	\N	\N	Land Use	2026-06-10	t
108	male_unemployed_35_44	acs	B23001_043E	2024	Estimate!!Total:!!Male:!!35 to 44 years:!!In labor force:!!Civilian:!!Unemployed	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
195	over_65_pov_level	acs	S1701_C01_010E	2024	Estimate!!Total!!Population for whom poverty status is determined!!AGE!!65 years and over	Poverty Status in the Past 12 Months	2026-06-11	t
102	male_employed_75	acs	B23001_085E	2024	Estimate!!Total:!!Male:!!75 years and over:!!In labor force:!!Employed	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
76	median_family_inc	acs	B19113_001E	2024	Estimate!!Median family income in the past 12 months (in 2024 inflation-adjusted dollars)	Median Family Income in the Past 12 Months (in 2024 Inflation-Adjusted Dollars)	2026-06-11	f
155	female_unemployed_25_29	acs	B23001_115E	2024	Estimate!!Total:!!Female:!!25 to 29 years:!!In labor force:!!Civilian:!!Unemployed	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
104	male_unemployed_20_21	acs	B23001_015E	2024	Estimate!!Total:!!Male:!!20 and 21 years:!!In labor force:!!Civilian:!!Unemployed	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
106	male_unemployed_25_29	acs	B23001_029E	2024	Estimate!!Total:!!Male:!!25 to 29 years:!!In labor force:!!Civilian:!!Unemployed	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
113	male_unemployed_65_69	acs	B23001_076E	2024	Estimate!!Total:!!Male:!!65 to 69 years:!!In labor force:!!Unemployed	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
75	median_hh_inc	acs	B19013_001E	2024	Estimate!!Median household income in the past 12 months (in 2024 inflation-adjusted dollars)	Median Household Income in the Past 12 Months (in 2024 Inflation-Adjusted Dollars)	2026-06-11	f
165	female_not_in_labor_force_16_19	acs	B23001_095E	2024	Estimate!!Total:!!Female:!!16 to 19 years:!!Not in labor force	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
42	vietnamese	acs	C16001_024E	2024	Estimate!!Total:!!Vietnamese:	Language Spoken at Home for the Population 5 Years and Over	2026-06-11	t
83	male_armed_forces_25_29	acs	B23001_026E	2024	Estimate!!Total:!!Male:!!25 to 29 years:!!In labor force:!!In Armed Forces	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
227	renter_3_vehicle	acs	B25044_013E	2024	Estimate!!Total:!!Renter occupied:!!3 vehicles available	Tenure by Vehicles Available	2026-06-11	t
45	tagalog_filipino	acs	C16001_027E	2024	Estimate!!Total:!!Tagalog (incl. Filipino):	Language Spoken at Home for the Population 5 Years and Over	2026-06-11	t
116	male_not_in_labor_force_16_19	acs	B23001_009E	2024	Estimate!!Total:!!Male:!!16 to 19 years:!!Not in labor force	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
121	male_not_in_labor_force_35_44	acs	B23001_044E	2024	Estimate!!Total:!!Male:!!35 to 44 years:!!Not in labor force	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
141	female_employed_22_24	acs	B23001_107E	2024	Estimate!!Total:!!Female:!!22 to 24 years:!!In labor force:!!Civilian:!!Employed	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
59	age_10_to_14_pop	acs	S0101_C01_004E	2024	Estimate!!Total!!Total population!!AGE!!10 to 14 years	Age and Sex	2026-06-11	t
5	under_18_pop	acs	B09001_001E	2024	Estimate!!Total:	Population Under 18 Years by Age	2026-06-11	t
132	female_armed_forces_25_29	acs	B23001_112E	2024	Estimate!!Total:!!Female:!!25 to 29 years:!!In labor force:!!In Armed Forces	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
133	female_armed_forces_30_34	acs	B23001_119E	2024	Estimate!!Total:!!Female:!!30 to 34 years:!!In labor force:!!In Armed Forces	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
162	female_unemployed_65_69	acs	B23001_162E	2024	Estimate!!Total:!!Female:!!65 to 69 years:!!In labor force:!!Unemployed	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
100	male_employed_65_69	acs	B23001_075E	2024	Estimate!!Total:!!Male:!!65 to 69 years:!!In labor force:!!Employed	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
84	male_armed_forces_30_34	acs	B23001_033E	2024	Estimate!!Total:!!Male:!!30 to 34 years:!!In labor force:!!In Armed Forces	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
105	male_unemployed_22_24	acs	B23001_022E	2024	Estimate!!Total:!!Male:!!22 to 24 years:!!In labor force:!!Civilian:!!Unemployed	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
185	hh_inc_40k_45k	acs	B19001_009E	2024	Estimate!!Total:!!$40,000 to $44,999	Household Income in the Past 12 Months (in 2023 Inflation-Adjusted Dollars)	2026-06-11	t
64	age_35_to_39_pop	acs	S0101_C01_009E	2024	Estimate!!Total!!Total population!!AGE!!35 to 39 years	Age and Sex	2026-06-11	t
98	male_employed_60_61	acs	B23001_063E	2024	Estimate!!Total:!!Male:!!60 and 61 years:!!In labor force:!!Civilian:!!Employed	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
97	male_employed_55_59	acs	B23001_056E	2024	Estimate!!Total:!!Male:!!55 to 59 years:!!In labor force:!!Civilian:!!Employed	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
207	comm_pool	acs	B08006_004E	2024	Estimate!!Total:!!Car, truck, or van:!!Carpooled:	Sex of Workers by Means of Transportation to Work	2026-06-11	t
218	owner_no_vehicle	acs	B25044_003E	2024	Estimate!!Total:!!Owner occupied:!!No vehicle available	Tenure by Vehicles Available	2026-06-11	t
25	french_haitian_or_cajun_w	acs	C16001_007E	2024	Estimate!!Total:!!French, Haitian, or Cajun:!!Speak English "very well"	Language Spoken at Home for the Population 5 Years and Over	2026-06-11	t
14	hispanic_or_latino_pop	acs	B03002_012E	2024	Estimate!!Total:!!Hispanic or Latino:	Hispanic or Latino Origin by Race	2026-06-11	t
142	female_employed_25_29	acs	B23001_114E	2024	Estimate!!Total:!!Female:!!25 to 29 years:!!In labor force:!!Civilian:!!Employed	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
184	hh_inc_35k_40k	acs	B19001_008E	2024	Estimate!!Total:!!$35,000 to $39,999	Household Income in the Past 12 Months (in 2023 Inflation-Adjusted Dollars)	2026-06-11	t
160	female_unemployed_60_61	acs	B23001_150E	2024	Estimate!!Total:!!Female:!!60 and 61 years:!!In labor force:!!Civilian:!!Unemployed	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
114	male_unemployed_70_74	acs	B23001_081E	2024	Estimate!!Total:!!Male:!!70 to 74 years:!!In labor force:!!Unemployed	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
219	owner_1_vehicle	acs	B25044_004E	2024	Estimate!!Total:!!Owner occupied:!!1 vehicle available	Tenure by Vehicles Available	2026-06-11	t
220	owner_2_vehicle	acs	B25044_005E	2024	Estimate!!Total:!!Owner occupied:!!2 vehicles available	Tenure by Vehicles Available	2026-06-11	t
123	male_not_in_labor_force_55_59	acs	B23001_058E	2024	Estimate!!Total:!!Male:!!55 to 59 years:!!Not in labor force	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
32	russian_polish_or_other_slavic_languages_lim	acs	C16001_014E	2024	Estimate!!Total:!!Russian, Polish, or other Slavic languages:!!Speak English less than "very well"	Language Spoken at Home for the Population 5 Years and Over	2026-06-11	t
148	female_employed_62_64	acs	B23001_156E	2024	Estimate!!Total:!!Female:!!62 to 64 years:!!In labor force:!!Civilian:!!Employed	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
159	female_unemployed_55_59	acs	B23001_143E	2024	Estimate!!Total:!!Female:!!55 to 59 years:!!In labor force:!!Civilian:!!Unemployed	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
203	nonfamily_hh	acs	B11001_007E	2024	Estimate!!Total:!!Nonfamily households:	Household Type (Including Living Alone)	2026-06-11	t
34	other_indo_european_languages_w	acs	C16001_016E	2024	Estimate!!Total:!!Other Indo-European languages:!!Speak English "very well"	Language Spoken at Home for the Population 5 Years and Over	2026-06-11	t
8	white_alone_pop	acs	B03002_003E	2024	Estimate!!Total:!!Not Hispanic or Latino:!!White alone	Hispanic or Latino Origin by Race	2026-06-11	t
15	less_hs	acs	B06009_002E	2024	Estimate!!Total:!!Less than high school graduate	Place of Birth by Educational Attainment in the United States	2026-06-11	t
99	male_employed_62_64	acs	B23001_070E	2024	Estimate!!Total:!!Male:!!62 to 64 years:!!In labor force:!!Civilian:!!Employed	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
180	hh_inc_15k_20k	acs	B19001_004E	2024	Estimate!!Total:!!$15,000 to $19,999	Household Income in the Past 12 Months (in 2023 Inflation-Adjusted Dollars)	2026-06-11	t
50	other_asian_and_pacific_island_languages_lim	acs	C16001_032E	2024	Estimate!!Total:!!Other Asian and Pacific Island languages:!!Speak English less than "very well"	Language Spoken at Home for the Population 5 Years and Over	2026-06-11	t
224	renter_no_vehicle	acs	B25044_010E	2024	Estimate!!Total:!!Renter occupied:!!No vehicle available	Tenure by Vehicles Available	2026-06-11	t
225	renter_1_vehicle	acs	B25044_011E	2024	Estimate!!Total:!!Renter occupied:!!1 vehicle available	Tenure by Vehicles Available	2026-06-11	t
78	pov_level	acs	B17001_002E	2024	Estimate!!Total:!!Income in the past 12 months below poverty level:	Poverty Status in the Past 12 Months by Sex by Age	2026-06-11	t
93	male_employed_25_29	acs	B23001_028E	2024	Estimate!!Total:!!Male:!!25 to 29 years:!!In labor force:!!Civilian:!!Employed	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
228	renter_4_vehicle	acs	B25044_014E	2024	Estimate!!Total:!!Renter occupied:!!4 vehicles available	Tenure by Vehicles Available	2026-06-11	t
96	male_employed_45_54	acs	B23001_049E	2024	Estimate!!Total:!!Male:!!45 to 54 years:!!In labor force:!!Civilian:!!Employed	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
138	female_armed_forces_62_64	acs	B23001_153E	2024	Estimate!!Total:!!Female:!!62 to 64 years:!!In labor force:	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
65	age_40_to_44_pop	acs	S0101_C01_010E	2024	Estimate!!Total!!Total population!!AGE!!40 to 44 years	Age and Sex	2026-06-11	t
63	age_30_to_34_pop	acs	S0101_C01_008E	2024	Estimate!!Total!!Total population!!AGE!!30 to 34 years	Age and Sex	2026-06-11	t
22	spanish_w	acs	C16001_004E	2024	Estimate!!Total:!!Spanish:!!Speak English "very well"	Language Spoken at Home for the Population 5 Years and Over	2026-06-11	t
400	passenger_rail_stations	gis	\N	\N	\N	Passenger Rail	2026-06-10	t
401	passenger_rail_mi	gis	\N	\N	\N	Passenger Rail	2026-06-10	t
402	fy25_pa_lines	gis	\N	\N	\N	TIP	2026-06-10	t
403	fy26_nj_lines	gis	\N	\N	\N	TIP	2026-06-10	t
404	fy25_pa_points	gis	\N	\N	\N	TIP	2026-06-10	t
405	fy26_nj_points	gis	\N	\N	\N	TIP	2026-06-10	t
406	septa_bus_stops	gis	\N	\N	\N	SEPTA Bus	2026-06-10	t
407	septa_bus_routes_mi	gis	\N	\N	\N	SEPTA Bus	2026-06-10	t
408	njt_bus_stops	gis	\N	\N	\N	NJT Bus	2026-06-10	t
409	njt_bus_routes_mi	gis	\N	\N	\N	NJT Bus	2026-06-10	t
410	protected_open_space_sq_mi	gis	\N	\N	\N	Open Space	2026-06-10	t
411	pop20	gis	\N	\N	\N	Population & Employment Forecasts	2026-06-10	t
412	pop25	gis	\N	\N	\N	Population & Employment Forecasts	2026-06-10	t
127	male_not_in_labor_force_70_74	acs	B23001_082E	2024	Estimate!!Total:!!Male:!!70 to 74 years:!!Not in labor force	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
36	korean	acs	C16001_018E	2024	Estimate!!Total:!!Korean:	Language Spoken at Home for the Population 5 Years and Over	2026-06-11	t
143	female_employed_30_34	acs	B23001_121E	2024	Estimate!!Total:!!Female:!!30 to 34 years:!!In labor force:!!Civilian:!!Employed	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
52	arabic_w	acs	C16001_034E	2024	Estimate!!Total:!!Arabic:!!Speak English "very well"	Language Spoken at Home for the Population 5 Years and Over	2026-06-11	t
40	chinese_mandarin_cantonese_w	acs	C16001_022E	2024	Estimate!!Total:!!Chinese (incl. Mandarin, Cantonese):!!Speak English "very well"	Language Spoken at Home for the Population 5 Years and Over	2026-06-11	t
77	median_inc	acs	B19301_001E	2024	Estimate!!Per capita income in the past 12 months (in 2024 inflation-adjusted dollars)	Per Capita Income in the Past 12 Months (in 2024 Inflation-Adjusted Dollars)	2026-06-11	f
178	hh_inc_10k	acs	B19001_002E	2024	Estimate!!Total:!!Less than $10,000	Household Income in the Past 12 Months (in 2023 Inflation-Adjusted Dollars)	2026-06-11	t
26	french_haitian_or_cajun_lim	acs	C16001_008E	2024	Estimate!!Total:!!French, Haitian, or Cajun:!!Speak English less than "very well"	Language Spoken at Home for the Population 5 Years and Over	2026-06-11	t
27	german_or_other_west_germanic_languages	acs	C16001_009E	2024	Estimate!!Total:!!German or other West Germanic languages:	Language Spoken at Home for the Population 5 Years and Over	2026-06-11	t
28	german_or_other_west_germanic_languages_w	acs	C16001_010E	2024	Estimate!!Total:!!German or other West Germanic languages:!!Speak English "very well"	Language Spoken at Home for the Population 5 Years and Over	2026-06-11	t
54	other_and_unspecified_languages	acs	C16001_036E	2024	Estimate!!Total:!!Other and unspecified languages:	Language Spoken at Home for the Population 5 Years and Over	2026-06-11	t
129	female_armed_forces_16_19	acs	B23001_091E	2024	Estimate!!Total:!!Female:!!16 to 19 years:!!In labor force:!!In Armed Forces	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
109	male_unemployed_45_54	acs	B23001_050E	2024	Estimate!!Total:!!Male:!!45 to 54 years:!!In labor force:!!Civilian:!!Unemployed	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
43	vietnamese_w	acs	C16001_025E	2024	Estimate!!Total:!!Vietnamese:!!Speak English "very well"	Language Spoken at Home for the Population 5 Years and Over	2026-06-11	t
435	test	acs	B09001_002E	2024	Estimate!!Total:!!In households:	Population Under 18 Years by Age	2026-06-11	t
150	female_employed_70_74	acs	B23001_166E	2024	Estimate!!Total:!!Female:!!70 to 74 years:!!In labor force:!!Employed	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
151	female_employed_75	acs	B23001_171E	2024	Estimate!!Total:!!Female:!!75 years and over:!!In labor force:!!Employed	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
152	female_unemployed_16_19	acs	B23001_094E	2024	Estimate!!Total:!!Female:!!16 to 19 years:!!In labor force:!!Civilian:!!Unemployed	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
153	female_unemployed_20_21	acs	B23001_101E	2024	Estimate!!Total:!!Female:!!20 and 21 years:!!In labor force:!!Civilian:!!Unemployed	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
216	comm_taxi_motor_other	acs	B08006_016E	2024	Estimate!!Total:!!Taxicab, motorcycle, or other means	Sex of Workers by Means of Transportation to Work	2026-06-11	t
101	male_employed_70_74	acs	B23001_080E	2024	Estimate!!Total:!!Male:!!70 to 74 years:!!In labor force:!!Employed	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
174	female_not_in_labor_force_62_64	acs	B23001_158E	2024	Estimate!!Total:!!Female:!!62 to 64 years:!!Not in labor force	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
56	other_and_unspecified_languages_lim	acs	C16001_038E	2024	Estimate!!Total:!!Other and unspecified languages:!!Speak English less than "very well"	Language Spoken at Home for the Population 5 Years and Over	2026-06-11	t
221	owner_3_vehicle	acs	B25044_006E	2024	Estimate!!Total:!!Owner occupied:!!3 vehicles available	Tenure by Vehicles Available	2026-06-11	t
134	female_armed_forces_35_44	acs	B23001_126E	2024	Estimate!!Total:!!Female:!!35 to 44 years:!!In labor force:!!In Armed Forces	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
172	female_not_in_labor_force_55_59	acs	B23001_144E	2024	Estimate!!Total:!!Female:!!55 to 59 years:!!Not in labor force	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
80	male_armed_forces_16_19	acs	B23001_005E	2024	Estimate!!Total:!!Male:!!16 to 19 years:!!In labor force:!!In Armed Forces	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
144	female_employed_35_44	acs	B23001_128E	2024	Estimate!!Total:!!Female:!!35 to 44 years:!!In labor force:!!Civilian:!!Employed	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
163	female_unemployed_70_74	acs	B23001_167E	2024	Estimate!!Total:!!Female:!!70 to 74 years:!!In labor force:!!Unemployed	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
81	male_armed_forces_20_21	acs	B23001_012E	2024	Estimate!!Total:!!Male:!!20 and 21 years:!!In labor force:!!In Armed Forces	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
82	male_armed_forces_22_24	acs	B23001_019E	2024	Estimate!!Total:!!Male:!!22 to 24 years:!!In labor force:!!In Armed Forces	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
166	female_not_in_labor_force_20_21	acs	B23001_102E	2024	Estimate!!Total:!!Female:!!20 and 21 years:!!Not in labor force	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
72	age_75_to_79_pop	acs	S0101_C01_017E	2024	Estimate!!Total!!Total population!!AGE!!75 to 79 years	Age and Sex	2026-06-11	t
37	korean_w	acs	C16001_019E	2024	Estimate!!Total:!!Korean:!!Speak English "very well"	Language Spoken at Home for the Population 5 Years and Over	2026-06-11	t
229	renter_5_vehicle	acs	B25044_015E	2024	Estimate!!Total:!!Renter occupied:!!5 or more vehicles available	Tenure by Vehicles Available	2026-06-11	t
179	hh_inc_10k_15k	acs	B19001_003E	2024	Estimate!!Total:!!$10,000 to $14,999	Household Income in the Past 12 Months (in 2023 Inflation-Adjusted Dollars)	2026-06-11	t
173	female_not_in_labor_force_60_61	acs	B23001_151E	2024	Estimate!!Total:!!Female:!!60 and 61 years:!!Not in labor force	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
91	male_employed_20_21	acs	B23001_014E	2024	Estimate!!Total:!!Male:!!20 and 21 years:!!In labor force:!!Civilian:!!Employed	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
222	owner_4_vehicle	acs	B25044_007E	2024	Estimate!!Total:!!Owner occupied:!!4 vehicles available	Tenure by Vehicles Available	2026-06-11	t
214	comm_walk	acs	B08006_015E	2024	Estimate!!Total:!!Walked	Sex of Workers by Means of Transportation to Work	2026-06-11	t
217	wfh	acs	B08006_017E	2024	Estimate!!Total:!!Worked from home	Sex of Workers by Means of Transportation to Work	2026-06-11	t
200	owner_hh	acs	B25003_002E	2024	Estimate!!Total:!!Owner occupied	Tenure	2026-06-11	t
208	comm_trans	acs	B08006_008E	2024	Estimate!!Total:!!Public transportation (excluding taxicab):	Sex of Workers by Means of Transportation to Work	2026-06-11	t
38	korean_lim	acs	C16001_020E	2024	Estimate!!Total:!!Korean:!!Speak English less than "very well"	Language Spoken at Home for the Population 5 Years and Over	2026-06-11	t
103	male_unemployed_16_19	acs	B23001_008E	2024	Estimate!!Total:!!Male:!!16 to 19 years:!!In labor force:!!Civilian:!!Unemployed	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
16	hs_no_college	acs	B06009_003E	2024	Estimate!!Total:!!High school graduate (includes equivalency)	Place of Birth by Educational Attainment in the United States	2026-06-11	t
112	male_unemployed_62_64	acs	B23001_071E	2024	Estimate!!Total:!!Male:!!62 to 64 years:!!In labor force:!!Civilian:!!Unemployed	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
85	male_armed_forces_35_44	acs	B23001_040E	2024	Estimate!!Total:!!Male:!!35 to 44 years:!!In labor force:!!In Armed Forces	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
89	male_armed_forces_62_64	acs	B23001_068E	2024	Estimate!!Total:!!Male:!!62 to 64 years:!!In labor force:!!In Armed Forces	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
90	male_employed_16_19	acs	B23001_007E	2024	Estimate!!Total:!!Male:!!16 to 19 years:!!In labor force:!!Civilian:!!Employed	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
149	female_employed_65_69	acs	B23001_161E	2024	Estimate!!Total:!!Female:!!65 to 69 years:!!In labor force:!!Employed	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
168	female_not_in_labor_force_25_29	acs	B23001_116E	2024	Estimate!!Total:!!Female:!!25 to 29 years:!!Not in labor force	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
209	comm_bus	acs	B08006_009E	2024	Estimate!!Total:!!Public transportation (excluding taxicab):!!Bus	Sex of Workers by Means of Transportation to Work	2026-06-11	t
210	comm_subway	acs	B08006_010E	2024	Estimate!!Total:!!Public transportation (excluding taxicab):!!Subway or elevated rail	Sex of Workers by Means of Transportation to Work	2026-06-11	t
211	comm_rail	acs	B08006_011E	2024	Estimate!!Total:!!Public transportation (excluding taxicab):!!Long-distance train or commuter rail	Sex of Workers by Means of Transportation to Work	2026-06-11	t
136	female_armed_forces_55_59	acs	B23001_140E	2024	Estimate!!Total:!!Female:!!55 to 59 years:!!In labor force:!!In Armed Forces	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
164	female_unemployed_75	acs	B23001_172E	2024	Estimate!!Total:!!Female:!!75 years and over:!!In labor force:!!Unemployed	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
95	male_employed_35_44	acs	B23001_042E	2024	Estimate!!Total:!!Male:!!35 to 44 years:!!In labor force:!!Civilian:!!Employed	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
170	female_not_in_labor_force_35_44	acs	B23001_130E	2024	Estimate!!Total:!!Female:!!35 to 44 years:!!Not in labor force	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
146	female_employed_55_59	acs	B23001_142E	2024	Estimate!!Total:!!Female:!!55 to 59 years:!!In labor force:!!Civilian:!!Employed	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
147	female_employed_60_61	acs	B23001_149E	2024	Estimate!!Total:!!Female:!!60 and 61 years:!!In labor force:!!Civilian:!!Employed	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
107	male_unemployed_30_34	acs	B23001_036E	2024	Estimate!!Total:!!Male:!!30 to 34 years:!!In labor force:!!Civilian:!!Unemployed	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
24	french_haitian_or_cajun	acs	C16001_006E	2024	Estimate!!Total:!!French, Haitian, or Cajun:	Language Spoken at Home for the Population 5 Years and Over	2026-06-11	t
92	male_employed_22_24	acs	B23001_021E	2024	Estimate!!Total:!!Male:!!22 to 24 years:!!In labor force:!!Civilian:!!Employed	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
18	bachelors_degree	acs	B06009_005E	2024	Estimate!!Total:!!Bachelor's degree	Place of Birth by Educational Attainment in the United States	2026-06-11	t
79	labor_force	acs	B23025_002E	2024	Estimate!!Total:!!In labor force:	Employment Status for the Population 16 Years and Over	2026-06-11	t
158	female_unemployed_45_54	acs	B23001_136E	2024	Estimate!!Total:!!Female:!!45 to 54 years:!!In labor force:!!Civilian:!!Unemployed	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
23	spanish_lim	acs	C16001_005E	2024	Estimate!!Total:!!Spanish:!!Speak English less than "very well"	Language Spoken at Home for the Population 5 Years and Over	2026-06-11	t
122	male_not_in_labor_force_45_54	acs	B23001_051E	2024	Estimate!!Total:!!Male:!!45 to 54 years:!!Not in labor force	Sex by Age by Employment Status for the Population 16 Years and Over	2026-06-11	t
46	tagalog_filipino_w	acs	C16001_028E	2024	Estimate!!Total:!!Tagalog (incl. Filipino):!!Speak English "very well"	Language Spoken at Home for the Population 5 Years and Over	2026-06-11	t
47	tagalog_filipino_lim	acs	C16001_029E	2024	Estimate!!Total:!!Tagalog (incl. Filipino):!!Speak English less than "very well"	Language Spoken at Home for the Population 5 Years and Over	2026-06-11	t
29	german_or_other_west_germanic_languages_lim	acs	C16001_011E	2024	Estimate!!Total:!!German or other West Germanic languages:!!Speak English less than "very well"	Language Spoken at Home for the Population 5 Years and Over	2026-06-11	t
48	other_asian_and_pacific_island_languages	acs	C16001_030E	2024	Estimate!!Total:!!Other Asian and Pacific Island languages:	Language Spoken at Home for the Population 5 Years and Over	2026-06-11	t
182	hh_inc_25k_30k	acs	B19001_006E	2024	Estimate!!Total:!!$25,000 to $29,999	Household Income in the Past 12 Months (in 2023 Inflation-Adjusted Dollars)	2026-06-11	t
183	hh_inc_30k_35k	acs	B19001_007E	2024	Estimate!!Total:!!$30,000 to $34,999	Household Income in the Past 12 Months (in 2023 Inflation-Adjusted Dollars)	2026-06-11	t
186	hh_inc_45k_50k	acs	B19001_010E	2024	Estimate!!Total:!!$45,000 to $49,999	Household Income in the Past 12 Months (in 2023 Inflation-Adjusted Dollars)	2026-06-11	t
187	hh_inc_50k_60k	acs	B19001_011E	2024	Estimate!!Total:!!$50,000 to $59,999	Household Income in the Past 12 Months (in 2023 Inflation-Adjusted Dollars)	2026-06-11	t
188	hh_inc_60k_75k	acs	B19001_012E	2024	Estimate!!Total:!!$60,000 to $74,999	Household Income in the Past 12 Months (in 2023 Inflation-Adjusted Dollars)	2026-06-11	t
190	hh_inc_100k_125k	acs	B19001_014E	2024	Estimate!!Total:!!$100,000 to $124,999	Household Income in the Past 12 Months (in 2023 Inflation-Adjusted Dollars)	2026-06-11	t
192	hh_inc_150k_200k	acs	B19001_016E	2024	Estimate!!Total:!!$150,000 to $199,999	Household Income in the Past 12 Months (in 2023 Inflation-Adjusted Dollars)	2026-06-11	t
193	hh_inc_200k	acs	B19001_017E	2024	Estimate!!Total:!!$200,000 or more	Household Income in the Past 12 Months (in 2023 Inflation-Adjusted Dollars)	2026-06-11	t
204	avg_hh_size	acs	B25010_001E	2024	Estimate!!Average household size --!!Total:	Average Household Size of Occupied Housing Units by Tenure	2026-06-11	t
44	vietnamese_lim	acs	C16001_026E	2024	Estimate!!Total:!!Vietnamese:!!Speak English less than "very well"	Language Spoken at Home for the Population 5 Years and Over	2026-06-11	t
\.


--
-- Data for Name: viz; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.viz (geo_level, file, create_date, topic_id, id, last_edited_by) FROM stdin;
region	[]	2025-12-01 15:59:47.522861	\N	165	\N
county	[]	2025-12-01 15:59:47.533627	\N	166	\N
municipality	[]	2025-12-01 15:59:47.543392	\N	167	\N
region	[]	2025-12-01 16:22:53.420613	\N	171	\N
county	[]	2025-12-01 16:22:53.432392	\N	172	\N
municipality	[]	2025-12-01 16:22:53.44272	\N	173	\N
region	[]	2025-12-02 11:42:06.670186	\N	174	\N
county	[]	2025-12-02 11:42:06.681681	\N	175	\N
municipality	[]	2025-12-02 11:42:06.691593	\N	176	\N
region	[]\n	2025-10-20 15:28:43.570856	12	1	\N
region	[]\n	2025-10-20 15:28:43.570856	18	2	\N
region	[]\n	2025-10-20 15:28:43.570856	25	3	\N
region	[]\n	2025-10-20 15:28:43.570856	24	4	\N
county	[]\n	2025-10-20 15:28:43.570856	10	44	\N
county	[]\n	2025-10-20 15:28:43.570856	15	45	\N
county	[]\n	2025-10-20 15:28:43.570856	26	46	\N
region	[]	2025-12-01 16:09:54.573994	\N	168	\N
county	[]	2025-12-01 16:09:54.584571	\N	169	\N
municipality	[]	2025-12-01 16:09:54.594109	\N	170	\N
region	[]	2025-12-02 11:51:21.301064	\N	177	\N
county	[]	2025-12-02 11:51:21.311698	\N	178	\N
municipality	[]	2025-12-02 11:51:21.321736	\N	179	\N
county	[]	2025-12-01 16:29:34.589702	25	36	\N
county	[]\n	2025-10-20 15:28:43.570856	6	47	\N
county	[]\n	2025-10-20 15:28:43.570856	8	48	\N
county	[]\n	2025-10-20 15:28:43.570856	19	49	\N
county	[]\n	2025-10-20 15:28:43.570856	23	50	\N
county	[]\n	2025-10-20 15:28:43.570856	7	51	\N
county	[]\n	2025-10-20 15:28:43.570856	9	52	\N
county	[]\n	2025-10-20 15:28:43.570856	29	53	\N
county	[]\n	2025-10-20 15:28:43.570856	30	54	\N
county	[]\n	2025-10-20 15:28:43.570856	2	55	\N
county	[]\n	2025-10-20 15:28:43.570856	21	56	\N
county	[]\n	2025-10-20 15:28:43.570856	17	59	\N
county	[]\n	2025-10-20 15:28:43.570856	4	60	\N
region	[]\n	2025-10-20 15:28:43.570856	31	30	\N
region	[]\n	2025-10-20 15:28:43.570856	3	31	\N
region	[]\n	2025-10-20 15:28:43.570856	22	32	\N
region	[]\n	2025-10-20 15:28:43.570856	32	33	\N
county	[]\n	2025-10-20 15:28:43.570856	12	34	\N
county	[]\n	2025-10-20 15:28:43.570856	18	35	\N
county	[]\n	2025-10-20 15:28:43.570856	33	38	\N
county	[]\n	2025-10-20 15:28:43.570856	13	39	\N
county	[]\n	2025-10-20 15:28:43.570856	14	40	\N
county	[]\n	2025-10-20 15:28:43.570856	28	41	\N
county	[]\n	2025-10-20 15:28:43.570856	34	42	\N
municipality	[]\n	2025-10-20 15:28:43.570856	26	79	\N
municipality	[]\n	2025-10-20 15:28:43.570856	6	80	\N
municipality	[]\n	2025-10-20 15:28:43.570856	8	81	\N
municipality	[]\n	2025-10-20 15:28:43.570856	19	83	\N
region	[]\n	2025-10-20 15:28:43.570856	33	5	\N
region	[]\n	2025-10-20 15:28:43.570856	13	6	\N
region	[]\n	2025-10-20 15:28:43.570856	14	7	\N
region	[]\n	2025-10-20 15:28:43.570856	28	8	\N
region	[]\n	2025-10-20 15:28:43.570856	34	9	\N
municipality	[]\n	2025-10-20 15:28:43.570856	18	68	\N
municipality	[]\n	2025-10-20 15:28:43.570856	25	69	\N
municipality	[]\n	2025-10-20 15:28:43.570856	24	70	\N
municipality	[]\n	2025-10-20 15:28:43.570856	33	71	\N
municipality	[]\n	2025-10-20 15:28:43.570856	13	72	\N
municipality	[]\n	2025-10-20 15:28:43.570856	14	73	\N
municipality	[]\n	2025-10-20 15:28:43.570856	28	74	\N
municipality	[]\n	2025-10-20 15:28:43.570856	34	75	\N
county	[{"type":"map","features":[{"sourceUrl":"https://tiles.dvrpc.org/data/transportation/circuittrails/","sourceLayer":"circuittrails","geometry":"Line","label":"Circuit Trails","colorExpression":["match",["get","circuit"],"Existing","#8EC73D","In Progress","#FDAE61","Pipeline","#B144A5","Planned","#2E9BA8","#0078AE"]}],"legendOverride":[{"label":"Existing","geometry":"Line","color":"#8EC73D"},{"label":"In Progress","geometry":"Line","color":"#FDAE61"},{"label":"Pipeline","geometry":"Line","color":"#B144A5"},{"label":"Planned","geometry":"Line","color":"#2E9BA8"}]}]	2025-11-03 15:19:55.266968	5	100	\N
region	[\n  {\n    "type": "chart",\n    "target_field": "population",\n    "schema": {\n      "$schema": "https://vega.github.io/schema/vega-lite/v6.json",\n      "description": "A line chart showing population forecasts from 2015-2050",\n      "data": {\n        "values": [\n          {\n            "year": "2015",\n            "population": "pop15"\n          },\n          {\n            "year": "2020",\n            "population": "pop20"\n          },\n          {\n            "year": "2025",\n            "population": "pop25"\n          },\n          {\n            "year": "2030",\n            "population": "pop30"\n          },\n          {\n            "year": "2035",\n            "population": "pop35"\n          },\n          {\n            "year": "2040",\n            "population": "pop40"\n          },\n          {\n            "year": "2045",\n            "population": "pop45"\n          },\n          {\n            "year": "2050",\n            "population": "pop50"\n          }\n        ]\n      },\n      "mark": "line",\n      "encoding": {\n        "x": {\n          "field": "year",\n          "type": "temporal"\n        },\n        "y": {\n          "field": "population",\n          "type": "quantitative",\n          "scale": {\n            "zero": false\n          }\n        }\n      }\n    }\n  }\n]\n	2025-10-20 15:28:43.570856	11	10	\N
region	[]\n	2025-10-20 15:28:43.570856	10	11	\N
region	[]\n	2025-10-20 15:28:43.570856	15	12	\N
region	[]\n	2025-10-20 15:28:43.570856	26	13	\N
region	[]\n	2025-10-20 15:28:43.570856	6	14	\N
region	[]\n	2025-10-20 15:28:43.570856	8	15	\N
region	[\n  {\n    "type": "map",\n    "features": [\n      {\n        "sourceUrl": "https://tiles.dvrpc.org/data/transportation/circuittrails/",\n        "sourceLayer": "circuittrails",\n        "geometry": "Line",\n        "label": "Circuit Trails",\n        "colorExpression": [\n          "match",\n          ["get", "circuit"],\n          "Existing",\n          "#8EC73D",\n          "In Progress",\n          "#FDAE61",\n          "Pipeline",\n          "#B144A5",\n          "Planned",\n          "#2E9BA8",\n          "#0078AE"\n        ]\n      }\n    ],\n    "legendOverride": [\n      {\n        "label": "Existing",\n        "geometry": "Line",\n        "color": "#8EC73D"\n      },\n      {\n        "label": "In Progress",\n        "geometry": "Line",\n        "color": "#FDAE61"\n      },\n      {\n        "label": "Pipeline",\n        "geometry": "Line",\n        "color": "#B144A5"\n      },\n      {\n        "label": "Planned",\n        "geometry": "Line",\n        "color": "#2E9BA8"\n      }\n    ]\n  }\n]\n	2025-10-20 15:28:43.570856	5	16	\N
region	[]\n	2025-10-20 15:28:43.570856	19	17	\N
region	[]\n	2025-10-20 15:28:43.570856	23	18	\N
region	[]\n	2025-10-20 15:28:43.570856	7	19	\N
region	[]\n	2025-10-20 15:28:43.570856	9	20	\N
region	[]\n	2025-10-20 15:28:43.570856	29	21	\N
region	[]\n	2025-10-20 15:28:43.570856	30	22	\N
region	[]\n	2025-10-20 15:28:43.570856	2	23	\N
region	[]\n	2025-10-20 15:28:43.570856	21	24	\N
county	[]	2025-12-10 15:20:29.366553	24	37	Colin Kirby
region	[\n  {\n    "type": "map",\n    "features": [\n      {\n        "sourceUrl": "https://tiles.dvrpc.org/data/freight/highways/",\n        "sourceLayer": "highways",\n        "geometry": "Line",\n        "label": "Highway",\n        "color": "#FF73DF"\n      },\n      {\n        "sourceUrl": "https://tiles.dvrpc.org/data/freight/freight_rail/",\n        "sourceLayer": "freight_rail",\n        "geometry": "Line",\n        "label": "Freight Rail",\n        "color": "#FAA819"\n      },\n      {\n        "sourceUrl": "https://tiles.dvrpc.org/data/freight/freight_centers/",\n        "sourceLayer": "freight_centers",\n        "geometry": "Polygon",\n        "label": "Freight Centers"\n      }\n    ]\n  }\n]\n	2025-10-20 15:28:43.570856	16	25	\N
region	[\n  {\n    "type": "map",\n\n    "features": [\n      {\n        "sourceUrl": "https://tiles.dvrpc.org/data/planning/dvrpc_protectedopenspace/",\n        "sourceLayer": "dvrpc_protectedopenspace",\n        "geometry": "Polygon",\n        "label": "Protected Open Space",\n        "color": "#B6CC89"\n      }\n    ]\n  }\n]\n	2025-10-20 15:28:43.570856	20	26	\N
region	[]\n	2025-10-20 15:28:43.570856	17	27	\N
region	[]\n	2025-10-20 15:28:43.570856	4	28	\N
region	[\n  {\n    "type": "map",\n    "features": [\n      {\n        "sourceUrl": "https://tiles.dvrpc.org/data/transportation/passengerrail/",\n        "sourceLayer": "passengerrail",\n        "geometry": "Line",\n        "label": "Passenger Rail"\n      },\n      {\n        "sourceUrl": "https://tiles.dvrpc.org/data/transportation/passengerrailstations/",\n        "sourceLayer": "passengerrailstations",\n        "geometry": "Point",\n        "label": "Passenger Rail Stations",\n        "color": "#FF73DF"\n      }\n    ]\n  }\n]\n	2025-10-20 15:28:43.570856	27	29	\N
municipality	[]\n	2025-10-20 15:28:43.570856	3	97	\N
municipality	[]\n	2025-10-20 15:28:43.570856	22	98	\N
municipality	[]\n	2025-10-20 15:28:43.570856	32	99	\N
county	[\n  {\n    "type": "map",\n    "features": [\n      {\n        "sourceUrl": "https://tiles.dvrpc.org/data/freight/highways/",\n        "sourceLayer": "highways",\n        "geometry": "Line",\n        "label": "Highway",\n        "color": "#FF73DF"\n      },\n      {\n        "sourceUrl": "https://tiles.dvrpc.org/data/freight/freight_rail/",\n        "sourceLayer": "freight_rail",\n        "geometry": "Line",\n        "label": "Freight Rail",\n        "color": "#FAA819"\n      },\n      {\n        "sourceUrl": "https://tiles.dvrpc.org/data/freight/freight_centers/",\n        "sourceLayer": "freight_centers",\n        "geometry": "Polygon",\n        "label": "Freight Centers"\n      }\n    ]\n  }\n]\n	2025-10-20 15:28:43.570856	16	57	\N
county	[\n  {\n    "type": "map",\n\n    "features": [\n      {\n        "sourceUrl": "https://tiles.dvrpc.org/data/planning/dvrpc_protectedopenspace/",\n        "sourceLayer": "dvrpc_protectedopenspace",\n        "geometry": "Polygon",\n        "label": "Protected Open Space",\n        "color": "#B6CC89"\n      }\n    ]\n  }\n]\n	2025-10-20 15:28:43.570856	20	58	\N
county	[\n  {\n    "type": "map",\n    "features": [\n      {\n        "sourceUrl": "https://tiles.dvrpc.org/data/transportation/passengerrail/",\n        "sourceLayer": "passengerrail",\n        "geometry": "Line",\n        "label": "Passenger Rail"\n      },\n      {\n        "sourceUrl": "https://tiles.dvrpc.org/data/transportation/passengerrailstations/",\n        "sourceLayer": "passengerrailstations",\n        "geometry": "Point",\n        "label": "Passenger Rail Stations",\n        "color": "#FF73DF"\n      }\n    ]\n  }\n]\n	2025-10-20 15:28:43.570856	27	61	\N
county	[]\n	2025-10-20 15:28:43.570856	31	62	\N
county	[]\n	2025-10-20 15:28:43.570856	3	63	\N
county	[]\n	2025-10-20 15:28:43.570856	22	64	\N
county	[]\n	2025-10-20 15:28:43.570856	32	65	\N
municipality	[\n  {\n    "type": "chart",\n    "target_field": "population",\n    "schema": {\n      "$schema": "https://vega.github.io/schema/vega-lite/v6.json",\n      "description": "A bar chart showing the population distribution of age groups",\n      "height": {\n        "step": 17\n      },\n      "data": {\n        "values": [\n          {\n            "age": "0 to 4",\n            "population": "under_5_pop"\n          },\n          {\n            "age": "5 to 9",\n            "population": "age_5_to_9_pop"\n          },\n          {\n            "age": "10 to 14",\n            "population": "age_10_to_14_pop"\n          },\n          {\n            "age": "15 to 19",\n            "population": "age_15_to_19_pop"\n          },\n          {\n            "age": "20 to 24",\n            "population": "age_20_to_24_pop"\n          },\n          {\n            "age": "25 to 29",\n            "population": "age_25_to_29_pop"\n          },\n          {\n            "age": "30 to 34",\n            "population": "age_30_to_34_pop"\n          },\n          {\n            "age": "35 to 39",\n            "population": "age_35_to_39_pop"\n          },\n          {\n            "age": "40 to 44",\n            "population": "age_40_to_44_pop"\n          },\n          {\n            "age": "45 to 49",\n            "population": "age_45_to_49_pop"\n          },\n          {\n            "age": "50 to 54",\n            "population": "age_50_to_54_pop"\n          },\n          {\n            "age": "55 to 59",\n            "population": "age_55_to_59_pop"\n          },\n          {\n            "age": "60 to 64",\n            "population": "age_60_to_64_pop"\n          },\n          {\n            "age": "65 to 69",\n            "population": "age_65_to_69_pop"\n          },\n          {\n            "age": "70 to 74",\n            "population": "age_70_to_74_pop"\n          },\n          {\n            "age": "75 to 79",\n            "population": "age_75_to_79_pop"\n          },\n          {\n            "age": "80 to 84",\n            "population": "age_80_to_84_pop"\n          },\n          {\n            "age": "85+",\n            "population": "age_85_over_pop"\n          }\n        ]\n      },\n      "mark": "bar",\n      "encoding": {\n        "y": {\n          "field": "age",\n          "sort": null\n        },\n        "x": {\n          "aggregate": "sum",\n          "field": "population",\n          "title": "population"\n        }\n      }\n    }\n  }\n]\n	2025-10-20 15:28:43.570856	1	66	\N
municipality	[]\n	2025-10-20 15:28:43.570856	12	67	\N
municipality	[\n  {\n    "type": "chart",\n    "target_field": "population",\n    "schema": {\n      "$schema": "https://vega.github.io/schema/vega-lite/v6.json",\n      "description": "A line chart showing population forecasts from 2015-2050",\n      "data": {\n        "values": [\n          {\n            "year": "2015",\n            "population": "pop15"\n          },\n          {\n            "year": "2020",\n            "population": "pop20"\n          },\n          {\n            "year": "2025",\n            "population": "pop25"\n          },\n          {\n            "year": "2030",\n            "population": "pop30"\n          },\n          {\n            "year": "2035",\n            "population": "pop35"\n          },\n          {\n            "year": "2040",\n            "population": "pop40"\n          },\n          {\n            "year": "2045",\n            "population": "pop45"\n          },\n          {\n            "year": "2050",\n            "population": "pop50"\n          }\n        ]\n      },\n      "mark": "line",\n      "encoding": {\n        "x": {\n          "field": "year",\n          "type": "temporal"\n        },\n        "y": {\n          "field": "population",\n          "type": "quantitative",\n          "scale": {\n            "zero": false\n          }\n        }\n      }\n    }\n  }\n]\n	2025-10-20 15:28:43.570856	11	76	\N
municipality	[]\n	2025-10-20 15:28:43.570856	10	77	\N
municipality	[]\n	2025-10-20 15:28:43.570856	15	78	\N
municipality	[\n  {\n    "type": "map",\n    "features": [\n      {\n        "sourceUrl": "https://tiles.dvrpc.org/data/transportation/circuittrails/",\n        "sourceLayer": "circuittrails",\n        "geometry": "Line",\n        "label": "Circuit Trails",\n        "colorExpression": [\n          "match",\n          ["get", "circuit"],\n          "Existing",\n          "#8EC73D",\n          "In Progress",\n          "#FDAE61",\n          "Pipeline",\n          "#B144A5",\n          "Planned",\n          "#2E9BA8",\n          "#0078AE"\n        ]\n      }\n    ],\n    "legendOverride": [\n      {\n        "label": "Existing",\n        "geometry": "Line",\n        "color": "#8EC73D"\n      },\n      {\n        "label": "In Progress",\n        "geometry": "Line",\n        "color": "#FDAE61"\n      },\n      {\n        "label": "Pipeline",\n        "geometry": "Line",\n        "color": "#B144A5"\n      },\n      {\n        "label": "Planned",\n        "geometry": "Line",\n        "color": "#2E9BA8"\n      }\n    ]\n  }\n]\n	2025-10-20 15:28:43.570856	5	82	\N
municipality	[]\n	2025-10-20 15:28:43.570856	23	84	\N
municipality	[]\n	2025-10-20 15:28:43.570856	7	85	\N
municipality	[]\n	2025-10-20 15:28:43.570856	9	86	\N
municipality	[]\n	2025-10-20 15:28:43.570856	29	87	\N
municipality	[]\n	2025-10-20 15:28:43.570856	30	88	\N
municipality	[]\n	2025-10-20 15:28:43.570856	2	89	\N
municipality	[]\n	2025-10-20 15:28:43.570856	21	90	\N
municipality	[\n  {\n    "type": "map",\n    "features": [\n      {\n        "sourceUrl": "https://tiles.dvrpc.org/data/freight/highways/",\n        "sourceLayer": "highways",\n        "geometry": "Line",\n        "label": "Highway",\n        "color": "#FF73DF"\n      },\n      {\n        "sourceUrl": "https://tiles.dvrpc.org/data/freight/freight_rail/",\n        "sourceLayer": "freight_rail",\n        "geometry": "Line",\n        "label": "Freight Rail",\n        "color": "#FAA819"\n      },\n      {\n        "sourceUrl": "https://tiles.dvrpc.org/data/freight/freight_centers/",\n        "sourceLayer": "freight_centers",\n        "geometry": "Polygon",\n        "label": "Freight Centers"\n      }\n    ]\n  }\n]\n	2025-10-20 15:28:43.570856	16	91	\N
municipality	[\n  {\n    "type": "map",\n\n    "features": [\n      {\n        "sourceUrl": "https://tiles.dvrpc.org/data/planning/dvrpc_protectedopenspace/",\n        "sourceLayer": "dvrpc_protectedopenspace",\n        "geometry": "Polygon",\n        "label": "Protected Open Space",\n        "color": "#B6CC89"\n      }\n    ]\n  }\n]\n	2025-10-20 15:28:43.570856	20	92	\N
municipality	[]\n	2025-10-20 15:28:43.570856	17	93	\N
municipality	[]\n	2025-10-20 15:28:43.570856	4	94	\N
municipality	[\n  {\n    "type": "map",\n    "features": [\n      {\n        "sourceUrl": "https://tiles.dvrpc.org/data/transportation/passengerrail/",\n        "sourceLayer": "passengerrail",\n        "geometry": "Line",\n        "label": "Passenger Rail"\n      },\n      {\n        "sourceUrl": "https://tiles.dvrpc.org/data/transportation/passengerrailstations/",\n        "sourceLayer": "passengerrailstations",\n        "geometry": "Point",\n        "label": "Passenger Rail Stations",\n        "color": "#FF73DF"\n      }\n    ]\n  }\n]\n	2025-10-20 15:28:43.570856	27	95	\N
municipality	[]\n	2025-10-20 15:28:43.570856	31	96	\N
region	[{"type":"chart","target_field":"population","schema":{"$schema":"https://vega.github.io/schema/vega-lite/v6.json","description":"A bar chart showing the population distribution of age groups","height":{"step":17},"data":{"values":[{"age":"0 to 4","population":"under_5_pop"},{"age":"5 to 9","population":"age_5_to_9_pop"},{"age":"10 to 14","population":"age_10_to_14_pop"},{"age":"15 to 19","population":"age_15_to_19_pop"},{"age":"20 to 24","population":"age_20_to_24_pop"},{"age":"25 to 29","population":"age_25_to_29_pop"},{"age":"30 to 34","population":"age_30_to_34_pop"},{"age":"35 to 39","population":"age_35_to_39_pop"},{"age":"40 to 44","population":"age_40_to_44_pop"},{"age":"45 to 49","population":"age_45_to_49_pop"},{"age":"50 to 54","population":"age_50_to_54_pop"},{"age":"55 to 59","population":"age_55_to_59_pop"},{"age":"60 to 64","population":"age_60_to_64_pop"},{"age":"65 to 69","population":"age_65_to_69_pop"},{"age":"70 to 74","population":"age_70_to_74_pop"},{"age":"75 to 79","population":"age_75_to_79_pop"},{"age":"80 to 84","population":"age_80_to_84_pop"},{"age":"85+","population":"age_85_over_pop"}]},"mark":"bar","encoding":{"y":{"field":"age","sort":null},"x":{"aggregate":"sum","field":"population","title":"population"}}}}]	2025-10-31 12:06:10.363244	1	101	\N
county	[{"type":"chart","target_field":"population","schema":{"$schema":"https://vega.github.io/schema/vega-lite/v6.json","description":"A line chart showing population forecasts from 2015-2050","data":{"values":[{"year":"2020","population":"pop20"},{"year":"2025","population":"pop25"},{"year":"2030","population":"pop30"},{"year":"2035","population":"pop35"},{"year":"2040","population":"pop40"},{"year":"2045","population":"pop45"},{"year":"2050","population":"pop50"}]},"mark":"line","encoding":{"x":{"field":"year","type":"temporal"},"y":{"field":"population","type":"quantitative","scale":{"zero":false}}}}}]	2025-11-14 16:15:39.248086	11	43	\N
region	[]	2025-12-03 15:27:20.126306	\N	180	\N
county	[]	2025-12-03 15:27:20.129277	\N	181	\N
municipality	[]	2025-12-03 15:27:20.130796	\N	182	\N
county	[{"type":"chart","target_field":"population","schema":{"$schema":"https://vega.github.io/schema/vega-lite/v6.json","description":"A bar chart showing the population distribution of age groups1","height":{"step":17},"data":{"values":[{"age":"0 to 4","population":"under_5_pop"},{"age":"5 to 9","population":"age_5_to_9_pop"},{"age":"10 to 14","population":"age_10_to_14_pop"},{"age":"15 to 19","population":"age_15_to_19_pop"},{"age":"20 to 24","population":"age_20_to_24_pop"},{"age":"25 to 29","population":"age_25_to_29_pop"},{"age":"30 to 34","population":"age_30_to_34_pop"},{"age":"35 to 39","population":"age_35_to_39_pop"},{"age":"40 to 44","population":"age_40_to_44_pop"},{"age":"45 to 49","population":"age_45_to_49_pop"},{"age":"50 to 54","population":"age_50_to_54_pop"},{"age":"55 to 59","population":"age_55_to_59_pop"},{"age":"60 to 64","population":"age_60_to_64_pop"},{"age":"65 to 69","population":"age_65_to_69_pop"},{"age":"70 to 74","population":"age_70_to_74_pop"},{"age":"75 to 79","population":"age_75_to_79_pop"},{"age":"80 to 84","population":"age_80_to_84_pop"},{"age":"85+","population":"age_85_over_pop"}]},"mark":"bar","encoding":{"y":{"field":"age","sort":null},"x":{"aggregate":"sum","field":"population","title":"population"}}}}]	2025-12-10 15:14:12.946645	1	102	Colin Kirby
region	[]	2026-05-21 10:26:16.038134	\N	183	\N
county	[]	2026-05-21 10:26:16.042415	\N	184	\N
municipality	[]	2026-05-21 10:26:16.044533	\N	185	\N
\.


--
-- Data for Name: viz_history; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.viz_history (geo_level, file, create_date, id, parent_id, topic_id, last_edited_by) FROM stdin;
county	[]\n	2025-10-20 15:28:43.570856	56	37	24	\N
county	[1]	2025-12-10 15:20:24.220183	57	37	24	Colin Kirby
\.


--
-- Data for Name: viz_source; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.viz_source (viz_id, source_id) FROM stdin;
\.


--
-- Name: category_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.category_id_seq', 8, true);


--
-- Name: content_history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.content_history_id_seq', 28, true);


--
-- Name: content_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.content_id_seq', 185, true);


--
-- Name: data_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.data_id_seq', 1, false);


--
-- Name: geo_variable_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.geo_variable_id_seq', 914, true);


--
-- Name: geography_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.geography_id_seq', 360, true);


--
-- Name: links_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.links_id_seq', 1, false);


--
-- Name: source_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.source_id_seq', 11, true);


--
-- Name: sql_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sql_id_seq', 24, true);


--
-- Name: subcategory_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.subcategory_id_seq', 27, true);


--
-- Name: topic_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.topic_id_seq', 59, true);


--
-- Name: variables_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.variables_id_seq', 494, true);


--
-- Name: visualizations_history_id_column_name_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.visualizations_history_id_column_name_seq', 57, true);


--
-- Name: category category_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.category
    ADD CONSTRAINT category_name_key UNIQUE (name);


--
-- Name: category category_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.category
    ADD CONSTRAINT category_pkey PRIMARY KEY (id);


--
-- Name: content_history content_history_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.content_history
    ADD CONSTRAINT content_history_pkey PRIMARY KEY (id);


--
-- Name: content content_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.content
    ADD CONSTRAINT content_pkey PRIMARY KEY (id);


--
-- Name: content_source content_source_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.content_source
    ADD CONSTRAINT content_source_pkey PRIMARY KEY (content_id, source_id);


--
-- Name: county county_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.county
    ADD CONSTRAINT county_pkey PRIMARY KEY (geoid);


--
-- Name: data data_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.data
    ADD CONSTRAINT data_pkey PRIMARY KEY (id);


--
-- Name: geo_variable geo_variable_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.geo_variable
    ADD CONSTRAINT geo_variable_pkey PRIMARY KEY (id);


--
-- Name: geography geography_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.geography
    ADD CONSTRAINT geography_pkey PRIMARY KEY (id);


--
-- Name: link links_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.link
    ADD CONSTRAINT links_pkey PRIMARY KEY (id);


--
-- Name: municipality municipality_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.municipality
    ADD CONSTRAINT municipality_pkey PRIMARY KEY (geoid);


--
-- Name: source source_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.source
    ADD CONSTRAINT source_pkey PRIMARY KEY (id);


--
-- Name: sql sql_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sql
    ADD CONSTRAINT sql_pkey PRIMARY KEY (id);


--
-- Name: subcategory subcategory_name_category_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subcategory
    ADD CONSTRAINT subcategory_name_category_id_key UNIQUE (name, category_id);


--
-- Name: subcategory subcategory_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subcategory
    ADD CONSTRAINT subcategory_pkey PRIMARY KEY (id);


--
-- Name: topic topic_name_subcategory_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.topic
    ADD CONSTRAINT topic_name_subcategory_id_key UNIQUE (name, subcategory_id);


--
-- Name: topic topic_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.topic
    ADD CONSTRAINT topic_pkey PRIMARY KEY (id);


--
-- Name: variable unique_acs_variable; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.variable
    ADD CONSTRAINT unique_acs_variable UNIQUE (acs_variable);


--
-- Name: variable unique_name; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.variable
    ADD CONSTRAINT unique_name UNIQUE (name);


--
-- Name: variable variables_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.variable
    ADD CONSTRAINT variables_pkey PRIMARY KEY (id);


--
-- Name: viz_history visualizations_history_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.viz_history
    ADD CONSTRAINT visualizations_history_pkey PRIMARY KEY (id);


--
-- Name: content content_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.content
    ADD CONSTRAINT content_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.category(id);


--
-- Name: content_product content_product_content_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.content_product
    ADD CONSTRAINT content_product_content_id_fkey FOREIGN KEY (content_id) REFERENCES public.content(id) ON DELETE CASCADE;


--
-- Name: content_source content_source_content_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.content_source
    ADD CONSTRAINT content_source_content_id_fkey FOREIGN KEY (content_id) REFERENCES public.content(id) ON DELETE CASCADE;


--
-- Name: content_source content_source_source_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.content_source
    ADD CONSTRAINT content_source_source_id_fkey FOREIGN KEY (source_id) REFERENCES public.source(id) ON DELETE CASCADE;


--
-- Name: data data_geoid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.data
    ADD CONSTRAINT data_geoid_fkey FOREIGN KEY (geoid) REFERENCES public.geography(id);


--
-- Name: data data_variable_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.data
    ADD CONSTRAINT data_variable_id_fkey FOREIGN KEY (variable_id) REFERENCES public.variable(id);


--
-- Name: content_link fk_content; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.content_link
    ADD CONSTRAINT fk_content FOREIGN KEY (content_id) REFERENCES public.content(id);


--
-- Name: content fk_content_topic; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.content
    ADD CONSTRAINT fk_content_topic FOREIGN KEY (topic_id) REFERENCES public.topic(id) ON DELETE SET NULL;


--
-- Name: content_link fk_link; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.content_link
    ADD CONSTRAINT fk_link FOREIGN KEY (link_id) REFERENCES public.link(id);


--
-- Name: viz_source fk_source; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.viz_source
    ADD CONSTRAINT fk_source FOREIGN KEY (source_id) REFERENCES public.source(id) ON DELETE CASCADE;


--
-- Name: viz_source fk_viz; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.viz_source
    ADD CONSTRAINT fk_viz FOREIGN KEY (viz_id) REFERENCES public.content(id);


--
-- Name: viz_history fk_viz_history_topic; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.viz_history
    ADD CONSTRAINT fk_viz_history_topic FOREIGN KEY (topic_id) REFERENCES public.topic(id) ON DELETE SET NULL;


--
-- Name: viz fk_viz_topic; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.viz
    ADD CONSTRAINT fk_viz_topic FOREIGN KEY (topic_id) REFERENCES public.topic(id) ON DELETE SET NULL;


--
-- Name: geo_variable geo_variable_variable_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.geo_variable
    ADD CONSTRAINT geo_variable_variable_id_fkey FOREIGN KEY (variable_id) REFERENCES public.variable(id) ON DELETE CASCADE;


--
-- Name: geography geography_county_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.geography
    ADD CONSTRAINT geography_county_id_fkey FOREIGN KEY (county_id) REFERENCES public.geography(id);


--
-- Name: subcategory subcategory_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subcategory
    ADD CONSTRAINT subcategory_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.category(id) ON DELETE CASCADE;


--
-- Name: topic topic_subcategory_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.topic
    ADD CONSTRAINT topic_subcategory_id_fkey FOREIGN KEY (subcategory_id) REFERENCES public.subcategory(id) ON DELETE CASCADE;


--
-- Name: viz viz_content_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.viz
    ADD CONSTRAINT viz_content_id_fkey FOREIGN KEY (id) REFERENCES public.content(id);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: -
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

