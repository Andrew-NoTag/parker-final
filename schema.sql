--
-- PostgreSQL database dump
--

-- Dumped from database version 17.4 (Postgres.app)
-- Dumped by pg_dump version 17.4 (Postgres.app)

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
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry and geography spatial types and functions';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: blocks; Type: TABLE; Schema: public; Owner: cclemente
--

CREATE TABLE public.blocks (
    id integer NOT NULL,
    latitude double precision NOT NULL,
    longitude double precision NOT NULL,
    street_name character varying(100),
    zip_code integer,
    borough integer,
    status character varying(10) DEFAULT 'unknown'::character varying,
    last_updated timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    time_limit_minutes integer,
    is_free boolean,
    no_parking_start time without time zone,
    no_parking_end time without time zone,
    CONSTRAINT blocks_status_check CHECK (((status)::text = ANY ((ARRAY['unknown'::character varying, 'open'::character varying, 'full'::character varying, 'restricted'::character varying])::text[])))
);


ALTER TABLE public.blocks OWNER TO cclemente;

--
-- Name: credit_transactions; Type: TABLE; Schema: public; Owner: cclemente
--

CREATE TABLE public.credit_transactions (
    id integer NOT NULL,
    user_id integer,
    amount integer NOT NULL,
    reason text NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.credit_transactions OWNER TO cclemente;

--
-- Name: credit_transactions_id_seq; Type: SEQUENCE; Schema: public; Owner: cclemente
--

CREATE SEQUENCE public.credit_transactions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.credit_transactions_id_seq OWNER TO cclemente;

--
-- Name: credit_transactions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: cclemente
--

ALTER SEQUENCE public.credit_transactions_id_seq OWNED BY public.credit_transactions.id;


--
-- Name: status_reports; Type: TABLE; Schema: public; Owner: cclemente
--

CREATE TABLE public.status_reports (
    id integer NOT NULL,
    block_id integer,
    user_id integer,
    status character varying(10) NOT NULL,
    reported_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT status_reports_status_check CHECK (((status)::text = ANY ((ARRAY['open'::character varying, 'full'::character varying])::text[])))
);


ALTER TABLE public.status_reports OWNER TO cclemente;

--
-- Name: status_reports_id_seq; Type: SEQUENCE; Schema: public; Owner: cclemente
--

CREATE SEQUENCE public.status_reports_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.status_reports_id_seq OWNER TO cclemente;

--
-- Name: status_reports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: cclemente
--

ALTER SEQUENCE public.status_reports_id_seq OWNED BY public.status_reports.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: cclemente
--

CREATE TABLE public.users (
    id integer NOT NULL,
    name character varying(100),
    email character varying(100) NOT NULL,
    password_hash text NOT NULL,
    credits integer DEFAULT 0,
    CONSTRAINT users_credits_check CHECK ((credits >= 0))
);


ALTER TABLE public.users OWNER TO cclemente;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: cclemente
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO cclemente;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: cclemente
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: credit_transactions id; Type: DEFAULT; Schema: public; Owner: cclemente
--

ALTER TABLE ONLY public.credit_transactions ALTER COLUMN id SET DEFAULT nextval('public.credit_transactions_id_seq'::regclass);


--
-- Name: status_reports id; Type: DEFAULT; Schema: public; Owner: cclemente
--

ALTER TABLE ONLY public.status_reports ALTER COLUMN id SET DEFAULT nextval('public.status_reports_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: cclemente
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: blocks blocks_pkey; Type: CONSTRAINT; Schema: public; Owner: cclemente
--

ALTER TABLE ONLY public.blocks
    ADD CONSTRAINT blocks_pkey PRIMARY KEY (id);


--
-- Name: credit_transactions credit_transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: cclemente
--

ALTER TABLE ONLY public.credit_transactions
    ADD CONSTRAINT credit_transactions_pkey PRIMARY KEY (id);


--
-- Name: status_reports status_reports_pkey; Type: CONSTRAINT; Schema: public; Owner: cclemente
--

ALTER TABLE ONLY public.status_reports
    ADD CONSTRAINT status_reports_pkey PRIMARY KEY (id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: cclemente
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: cclemente
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: credit_transactions credit_transactions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: cclemente
--

ALTER TABLE ONLY public.credit_transactions
    ADD CONSTRAINT credit_transactions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: status_reports status_reports_block_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: cclemente
--

ALTER TABLE ONLY public.status_reports
    ADD CONSTRAINT status_reports_block_id_fkey FOREIGN KEY (block_id) REFERENCES public.blocks(id) ON DELETE CASCADE;


--
-- Name: status_reports status_reports_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: cclemente
--

ALTER TABLE ONLY public.status_reports
    ADD CONSTRAINT status_reports_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- PostgreSQL database dump complete
--

