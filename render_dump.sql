--
-- PostgreSQL database dump
--

-- Dumped from database version 16.8 (Debian 16.8-1.pgdg120+1)
-- Dumped by pg_dump version 16.8 (Ubuntu 16.8-0ubuntu0.24.04.1)

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
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: active_storage_attachments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.active_storage_attachments (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying NOT NULL,
    record_type character varying NOT NULL,
    record_id uuid NOT NULL,
    blob_id uuid NOT NULL,
    created_at timestamp(6) without time zone NOT NULL
);


--
-- Name: active_storage_blobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.active_storage_blobs (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    key character varying NOT NULL,
    filename character varying NOT NULL,
    content_type character varying,
    metadata text,
    service_name character varying NOT NULL,
    byte_size bigint NOT NULL,
    checksum character varying,
    created_at timestamp(6) without time zone NOT NULL
);


--
-- Name: active_storage_variant_records; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.active_storage_variant_records (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    blob_id uuid NOT NULL,
    variation_digest character varying NOT NULL
);


--
-- Name: appointments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.appointments (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    patient_id uuid NOT NULL,
    professional_id uuid NOT NULL,
    clinic_id uuid NOT NULL,
    date date,
    "time" time without time zone,
    status character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    treatment_details text,
    deleted_at timestamp(6) without time zone
);


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
-- Name: clinics; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.clinics (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying,
    address character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: patients; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.patients (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    email character varying,
    phone character varying,
    professional_id uuid NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    first_name character varying,
    last_name character varying
);


--
-- Name: payments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.payments (
    id bigint NOT NULL,
    appointment_id uuid NOT NULL,
    amount numeric(10,2) NOT NULL,
    status integer DEFAULT 0 NOT NULL,
    external_payment_id character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: payments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.payments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: payments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.payments_id_seq OWNED BY public.payments.id;


--
-- Name: professionals; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.professionals (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    specialty integer DEFAULT 0 NOT NULL,
    license_number character varying,
    clinic_id uuid NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: professionals_secretaries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.professionals_secretaries (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    professional_id uuid NOT NULL,
    secretary_id uuid NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp(6) without time zone,
    remember_created_at timestamp(6) without time zone,
    clinic_id uuid,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    role integer DEFAULT 0,
    first_name character varying,
    last_name character varying,
    provider character varying,
    uid character varying
);


--
-- Name: payments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payments ALTER COLUMN id SET DEFAULT nextval('public.payments_id_seq'::regclass);


--
-- Data for Name: active_storage_attachments; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.active_storage_attachments (id, name, record_type, record_id, blob_id, created_at) FROM stdin;
e7fcf5ce-7539-4bf4-aa6a-9b499d415dbe	photo	Patient	31d64150-f51a-4caf-ad07-07b83ec02071	fb4460d5-6dc4-4396-a36f-1b1159f20cb4	2025-04-07 00:57:29.072314
bdc19d7a-0c4e-44f4-9f83-21d9e3108ebc	photo	Patient	82285d75-7858-4a63-ad8d-e26080e69089	3b11baff-75f2-42fd-b354-424e615feae0	2025-04-07 00:59:07.254073
\.


--
-- Data for Name: active_storage_blobs; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.active_storage_blobs (id, key, filename, content_type, metadata, service_name, byte_size, checksum, created_at) FROM stdin;
fb4460d5-6dc4-4396-a36f-1b1159f20cb4	2n3uf5p2bkn0s7br7czmeb30giiy	LinkedIn Github Profile 04.jpg	image/jpeg	{"identified":true,"analyzed":true}	cloudinary	127440	vjH4IvXCUkPbf/cpk1g+aA==	2025-04-07 00:57:29.069053
3b11baff-75f2-42fd-b354-424e615feae0	k55617ni5w50xby45olhrwhc674d	Diego Diaz.avif	image/avif	{"identified":true,"analyzed":true}	cloudinary	69067	ypbZ8H+CF9fUZksB1K+5qA==	2025-04-07 00:59:07.25197
\.


--
-- Data for Name: active_storage_variant_records; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.active_storage_variant_records (id, blob_id, variation_digest) FROM stdin;
\.


--
-- Data for Name: appointments; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.appointments (id, patient_id, professional_id, clinic_id, date, "time", status, created_at, updated_at, treatment_details, deleted_at) FROM stdin;
17f98802-fc67-42d6-ab54-127667ead8e2	7ae3cd0f-c0c1-47a3-8ece-8f200624087d	f16a43a5-44ca-4b6a-9afe-831ebbfa9803	8d81ec1b-2dba-4b13-a9ad-2c2226497b41	2025-04-07	09:00:00	pending	2025-04-06 15:41:11.100259	2025-04-06 15:41:11.100259	\N	\N
d58c1af7-2898-4918-8715-fde31c94f52e	c628dea0-41cf-4d56-a2d9-97e25eede2ca	f16a43a5-44ca-4b6a-9afe-831ebbfa9803	8d81ec1b-2dba-4b13-a9ad-2c2226497b41	2025-04-08	10:00:00	pending	2025-04-06 15:41:11.104411	2025-04-06 15:41:11.104411	\N	\N
d3fab4cb-ee2e-4ec8-8668-40d8d7318838	4db2f6c5-91e8-4022-b51d-41d445466030	f16a43a5-44ca-4b6a-9afe-831ebbfa9803	8d81ec1b-2dba-4b13-a9ad-2c2226497b41	2025-04-09	11:00:00	pending	2025-04-06 15:41:11.107867	2025-04-06 15:41:11.107867	\N	\N
5869cc60-a4fb-46e5-88de-55942af03ae3	6747ef9e-d66e-434c-8d93-382a4d5f10ba	f16a43a5-44ca-4b6a-9afe-831ebbfa9803	8d81ec1b-2dba-4b13-a9ad-2c2226497b41	2025-04-10	12:00:00	pending	2025-04-06 15:41:11.110999	2025-04-06 15:41:11.110999	\N	\N
66a3b3ab-ebd9-470b-a679-9fec6677be80	6c505651-caf9-4a5d-9303-77d0755f5cac	f16a43a5-44ca-4b6a-9afe-831ebbfa9803	8d81ec1b-2dba-4b13-a9ad-2c2226497b41	2025-04-11	13:00:00	pending	2025-04-06 15:41:11.1143	2025-04-06 15:41:11.1143	\N	\N
690baa93-20d9-492b-86aa-d83810e0d1cd	bc451112-ee56-43a3-8783-5c2d94a09d03	f16a43a5-44ca-4b6a-9afe-831ebbfa9803	8d81ec1b-2dba-4b13-a9ad-2c2226497b41	2025-04-14	14:00:00	pending	2025-04-06 15:41:11.117672	2025-04-06 15:41:11.117672	\N	\N
b59af70a-3ff4-445f-b2c0-b9fd2e006157	a8c790ec-9f7b-42ba-88d9-b286df60e113	f16a43a5-44ca-4b6a-9afe-831ebbfa9803	8d81ec1b-2dba-4b13-a9ad-2c2226497b41	2025-04-15	15:00:00	pending	2025-04-06 15:41:11.120635	2025-04-06 15:41:11.120635	\N	\N
4af8c866-ad6b-48ea-8591-b00eee6e0381	2b04ed45-8566-401d-80fe-39c3b99c90c7	f16a43a5-44ca-4b6a-9afe-831ebbfa9803	8d81ec1b-2dba-4b13-a9ad-2c2226497b41	2025-04-16	16:00:00	pending	2025-04-06 15:41:11.125336	2025-04-06 15:41:11.125336	\N	\N
84832e06-24d7-494a-bf06-18da2248779f	fbd1938b-68a3-4ae5-9738-9fe71394663d	f16a43a5-44ca-4b6a-9afe-831ebbfa9803	8d81ec1b-2dba-4b13-a9ad-2c2226497b41	2025-04-17	17:00:00	pending	2025-04-06 15:41:11.128583	2025-04-06 15:41:11.128583	\N	\N
0ad86b55-9453-4c1e-96dc-07c81a334114	d7b8797c-5159-48dc-b2d2-52f43556ca6a	f16a43a5-44ca-4b6a-9afe-831ebbfa9803	8d81ec1b-2dba-4b13-a9ad-2c2226497b41	2025-04-18	18:00:00	pending	2025-04-06 15:41:11.132129	2025-04-06 15:41:11.132129	\N	\N
056e0e65-a4a8-439c-8f4e-70ea537fd8f8	355b1cef-bd13-4b98-91c9-7c95079b4523	f16a43a5-44ca-4b6a-9afe-831ebbfa9803	8d81ec1b-2dba-4b13-a9ad-2c2226497b41	2025-04-21	09:00:00	pending	2025-04-06 15:41:11.135106	2025-04-06 15:41:11.135106	\N	\N
018a92d7-7b20-4853-aa28-5fda725ad85a	b56ad062-0612-4ff8-8a44-c3f48a1c0138	f16a43a5-44ca-4b6a-9afe-831ebbfa9803	8d81ec1b-2dba-4b13-a9ad-2c2226497b41	2025-04-22	10:00:00	pending	2025-04-06 15:41:11.138276	2025-04-06 15:41:11.138276	\N	\N
3a28974e-3549-419a-ae3b-6f76a8b0abb5	d84c6d7d-2979-41cc-9c03-f2d5d18f367a	9adf7839-64c5-4690-b05a-fa63a8db48f4	8d81ec1b-2dba-4b13-a9ad-2c2226497b41	2025-04-23	11:00:00	pending	2025-04-06 15:41:11.141248	2025-04-06 15:41:11.141248	\N	\N
5a40d13f-2329-4b90-a568-316c68e8cc5e	202bdf01-697b-4006-81b0-e143365d1012	9adf7839-64c5-4690-b05a-fa63a8db48f4	8d81ec1b-2dba-4b13-a9ad-2c2226497b41	2025-04-24	12:00:00	pending	2025-04-06 15:41:11.144329	2025-04-06 15:41:11.144329	\N	\N
83424242-fd7b-4d75-a40c-c2fc0cc396ce	bd9f1ced-f9c7-4c55-9d15-02f24bad809a	9adf7839-64c5-4690-b05a-fa63a8db48f4	8d81ec1b-2dba-4b13-a9ad-2c2226497b41	2025-04-25	13:00:00	pending	2025-04-06 15:41:11.151948	2025-04-06 15:41:11.151948	\N	\N
6f840945-b1b3-4aa1-8436-cf00303b5856	a04ce7b5-ab0f-4a9b-b06f-788d367236cc	9adf7839-64c5-4690-b05a-fa63a8db48f4	8d81ec1b-2dba-4b13-a9ad-2c2226497b41	2025-04-28	14:00:00	pending	2025-04-06 15:41:11.155037	2025-04-06 15:41:11.155037	\N	\N
f6a561a4-f815-470d-bdb2-5202b35a4f5d	9683c9d6-86f9-4616-85a2-7e1d2561f723	9adf7839-64c5-4690-b05a-fa63a8db48f4	8d81ec1b-2dba-4b13-a9ad-2c2226497b41	2025-04-29	15:00:00	pending	2025-04-06 15:41:11.157984	2025-04-06 15:41:11.157984	\N	\N
fc64e20f-1509-4d69-bc12-128c7d3dabca	bf72f8a9-7fca-4435-97ac-794272a7229c	9adf7839-64c5-4690-b05a-fa63a8db48f4	8d81ec1b-2dba-4b13-a9ad-2c2226497b41	2025-04-30	16:00:00	pending	2025-04-06 15:41:11.161257	2025-04-06 15:41:11.161257	\N	\N
bb5a452b-04f6-4337-87d8-5ac23bb4522d	1387181c-a6eb-4e6c-a7df-f5c03201903a	9adf7839-64c5-4690-b05a-fa63a8db48f4	8d81ec1b-2dba-4b13-a9ad-2c2226497b41	2025-05-01	17:00:00	pending	2025-04-06 15:41:11.165639	2025-04-06 15:41:11.165639	\N	\N
8cf308b5-23bf-426b-9e92-2a33bdf41a1c	0b2b24cd-8bb1-4190-bb76-2330f0a8f65d	9adf7839-64c5-4690-b05a-fa63a8db48f4	8d81ec1b-2dba-4b13-a9ad-2c2226497b41	2025-05-02	18:00:00	pending	2025-04-06 15:41:11.169779	2025-04-06 15:41:11.169779	\N	\N
5dad2b4c-b6c4-416a-bc83-466ed4abeb52	6e9f69a9-9c18-4e19-98f3-e78f16183e30	9adf7839-64c5-4690-b05a-fa63a8db48f4	8d81ec1b-2dba-4b13-a9ad-2c2226497b41	2025-05-05	09:00:00	pending	2025-04-06 15:41:11.173087	2025-04-06 15:41:11.173087	\N	\N
49329a90-ca6a-4dce-9406-bf92fb7825eb	2ad8c812-47ce-4ba9-8d59-b4b9826f3208	9adf7839-64c5-4690-b05a-fa63a8db48f4	8d81ec1b-2dba-4b13-a9ad-2c2226497b41	2025-05-06	10:00:00	pending	2025-04-06 15:41:11.17626	2025-04-06 15:41:11.17626	\N	\N
0d1b00a6-fec2-4fb1-a4fc-c4c784a4396f	fe432b6b-c825-4ac8-aee1-0f980aa1edfc	9adf7839-64c5-4690-b05a-fa63a8db48f4	8d81ec1b-2dba-4b13-a9ad-2c2226497b41	2025-05-07	11:00:00	pending	2025-04-06 15:41:11.179477	2025-04-06 15:41:11.179477	\N	\N
703d767d-1ec9-4dd9-b693-d080e19ec285	c65fafdd-d7da-430b-9e06-e17adef96250	9adf7839-64c5-4690-b05a-fa63a8db48f4	8d81ec1b-2dba-4b13-a9ad-2c2226497b41	2025-05-08	12:00:00	pending	2025-04-06 15:41:11.182735	2025-04-06 15:41:11.182735	\N	\N
9826e134-36e5-4fc3-ab82-7a9ffb23f400	b8f47b5f-d171-434d-b3fa-6a74294f2453	2bbbb6eb-57eb-4183-aecb-a1156aadb11c	8d81ec1b-2dba-4b13-a9ad-2c2226497b41	2025-05-09	13:00:00	pending	2025-04-06 15:41:11.186043	2025-04-06 15:41:11.186043	\N	\N
a83c5efb-0f52-4e24-8a8f-fb907a31545d	2f09a6c7-5948-4f6e-bd9f-7ae3c2b29949	2bbbb6eb-57eb-4183-aecb-a1156aadb11c	8d81ec1b-2dba-4b13-a9ad-2c2226497b41	2025-05-12	14:00:00	pending	2025-04-06 15:41:11.189369	2025-04-06 15:41:11.189369	\N	\N
8eaa39d2-d3f6-4a6e-82bd-4a4b27ce4d09	4a716b7c-32b8-4dab-b5d7-61c22afc3236	2bbbb6eb-57eb-4183-aecb-a1156aadb11c	8d81ec1b-2dba-4b13-a9ad-2c2226497b41	2025-05-13	15:00:00	pending	2025-04-06 15:41:11.192617	2025-04-06 15:41:11.192617	\N	\N
019dcb11-8522-4dd4-8ea7-c178f38a411c	fff180c1-254f-4256-bb1e-9761e6f95d39	2bbbb6eb-57eb-4183-aecb-a1156aadb11c	8d81ec1b-2dba-4b13-a9ad-2c2226497b41	2025-05-14	16:00:00	pending	2025-04-06 15:41:11.196238	2025-04-06 15:41:11.196238	\N	\N
6c0cb4e5-474f-4af4-b2ad-c9cd12be8883	3508844d-de98-468e-a9b8-ce7e314225c6	2bbbb6eb-57eb-4183-aecb-a1156aadb11c	8d81ec1b-2dba-4b13-a9ad-2c2226497b41	2025-05-15	17:00:00	pending	2025-04-06 15:41:11.222583	2025-04-06 15:41:11.222583	\N	\N
969b8a97-abd0-4039-90cc-1c865497dc9f	7afdef21-27c5-44fa-8309-be74524dd054	2bbbb6eb-57eb-4183-aecb-a1156aadb11c	8d81ec1b-2dba-4b13-a9ad-2c2226497b41	2025-05-16	18:00:00	pending	2025-04-06 15:41:11.225736	2025-04-06 15:41:11.225736	\N	\N
2e20410b-8ecd-4ca0-bcf7-a1627a1d2b1a	1420ee73-773d-48a9-bece-09c2ff2234b5	2bbbb6eb-57eb-4183-aecb-a1156aadb11c	8d81ec1b-2dba-4b13-a9ad-2c2226497b41	2025-04-07	09:00:00	pending	2025-04-06 15:41:11.228913	2025-04-06 15:41:11.228913	\N	\N
f98a2985-833c-4a09-9646-59bc0e7cb189	5fa934eb-5a3b-4aba-b76e-73d1f978a8b1	2bbbb6eb-57eb-4183-aecb-a1156aadb11c	8d81ec1b-2dba-4b13-a9ad-2c2226497b41	2025-04-08	10:00:00	pending	2025-04-06 15:41:11.231843	2025-04-06 15:41:11.231843	\N	\N
8b4f7f06-3a2b-4715-8f56-da9768cb15f0	8a2130f6-ee14-41a2-a404-f127992b07c3	2bbbb6eb-57eb-4183-aecb-a1156aadb11c	8d81ec1b-2dba-4b13-a9ad-2c2226497b41	2025-04-09	11:00:00	pending	2025-04-06 15:41:11.234992	2025-04-06 15:41:11.234992	\N	\N
d09cbade-4010-412b-8484-54bd3d86e41f	54f830b2-9809-4c74-b73b-0ba108e3bb0c	2bbbb6eb-57eb-4183-aecb-a1156aadb11c	8d81ec1b-2dba-4b13-a9ad-2c2226497b41	2025-04-10	12:00:00	pending	2025-04-06 15:41:11.237903	2025-04-06 15:41:11.237903	\N	\N
506b7270-a42a-44be-8526-15cce3712a0f	ee8e4134-208d-4f68-a000-da7f7cc843ea	2bbbb6eb-57eb-4183-aecb-a1156aadb11c	8d81ec1b-2dba-4b13-a9ad-2c2226497b41	2025-04-11	13:00:00	pending	2025-04-06 15:41:11.240781	2025-04-06 15:41:11.240781	\N	\N
64e57465-8865-4b54-a6cf-d3459eaf7fc2	962d494e-feaa-45a3-8294-0eac147e54fb	c613e6dc-c300-4776-95bd-5ffe0dacf4c8	6afc8d57-14df-46ad-863d-6b2a4eaacf77	2025-04-14	14:00:00	pending	2025-04-06 15:41:11.243598	2025-04-06 15:41:11.243598	\N	\N
1e97c442-51d3-40ed-83ac-2b73dedbcaf0	c1637852-d07c-43f7-b90b-43ef989d8e9f	c613e6dc-c300-4776-95bd-5ffe0dacf4c8	6afc8d57-14df-46ad-863d-6b2a4eaacf77	2025-04-15	15:00:00	pending	2025-04-06 15:41:11.246391	2025-04-06 15:41:11.246391	\N	\N
62ae36b3-1402-4532-b4c8-9d01d4b2f558	d5823bd8-5c3b-45aa-9f26-578da2aa4508	c613e6dc-c300-4776-95bd-5ffe0dacf4c8	6afc8d57-14df-46ad-863d-6b2a4eaacf77	2025-04-16	16:00:00	pending	2025-04-06 15:41:11.249339	2025-04-06 15:41:11.249339	\N	\N
1e748a53-0460-4aad-b141-4dfd6b64374b	870bf513-940e-4c61-9738-e38e79a9f3c5	c613e6dc-c300-4776-95bd-5ffe0dacf4c8	6afc8d57-14df-46ad-863d-6b2a4eaacf77	2025-04-17	17:00:00	pending	2025-04-06 15:41:11.252088	2025-04-06 15:41:11.252088	\N	\N
f27a853d-3b51-4c33-b82d-06913e060941	fcef99e7-4e86-4a0b-897f-cf46ca04e6dd	c613e6dc-c300-4776-95bd-5ffe0dacf4c8	6afc8d57-14df-46ad-863d-6b2a4eaacf77	2025-04-18	18:00:00	pending	2025-04-06 15:41:11.254983	2025-04-06 15:41:11.254983	\N	\N
0bb9369b-6343-49bd-a2eb-0469c37e5304	6a4479ee-03ed-4114-9a42-6502e80b9049	c613e6dc-c300-4776-95bd-5ffe0dacf4c8	6afc8d57-14df-46ad-863d-6b2a4eaacf77	2025-04-21	09:00:00	pending	2025-04-06 15:41:11.25805	2025-04-06 15:41:11.25805	\N	\N
99f019d0-dd5e-4baf-81da-cf81289cc246	870c3599-1f89-4693-9bf8-090b13dec1eb	c613e6dc-c300-4776-95bd-5ffe0dacf4c8	6afc8d57-14df-46ad-863d-6b2a4eaacf77	2025-04-22	10:00:00	pending	2025-04-06 15:41:11.261431	2025-04-06 15:41:11.261431	\N	\N
28795a0c-2f99-4c1f-a51e-f5555edabc29	90342d5e-499f-4591-9a9e-ceaa5017e8a0	c613e6dc-c300-4776-95bd-5ffe0dacf4c8	6afc8d57-14df-46ad-863d-6b2a4eaacf77	2025-04-23	11:00:00	pending	2025-04-06 15:41:11.264393	2025-04-06 15:41:11.264393	\N	\N
693a09f8-b393-4d9d-85f2-ef9d79c0211e	231bc521-0e08-4304-be3a-b472d26f44a4	c613e6dc-c300-4776-95bd-5ffe0dacf4c8	6afc8d57-14df-46ad-863d-6b2a4eaacf77	2025-04-24	12:00:00	pending	2025-04-06 15:41:11.267299	2025-04-06 15:41:11.267299	\N	\N
6f47aa21-931e-4107-b621-32887e7376b4	024579eb-d4ae-435e-ac1d-a21cad39742e	c613e6dc-c300-4776-95bd-5ffe0dacf4c8	6afc8d57-14df-46ad-863d-6b2a4eaacf77	2025-04-25	13:00:00	pending	2025-04-06 15:41:11.270314	2025-04-06 15:41:11.270314	\N	\N
d97ac40a-0ca1-4200-bb5f-52a0e4d39578	a634af5c-e09b-4986-880d-734dffbe666e	5801ce93-bb3b-4452-bfc8-768e953512bb	f2d9eda5-c41d-4429-8332-7d0d8262c716	2025-04-28	14:00:00	pending	2025-04-06 15:41:11.273325	2025-04-06 15:41:11.273325	\N	\N
222dadca-ea62-47b9-b03a-3b9bacfc8582	ef3aad9f-1b4f-4ee8-b6a6-1684d9620a12	5801ce93-bb3b-4452-bfc8-768e953512bb	f2d9eda5-c41d-4429-8332-7d0d8262c716	2025-04-29	15:00:00	pending	2025-04-06 15:41:11.276223	2025-04-06 15:41:11.276223	\N	\N
41963d68-f88a-4ccd-8002-5650a354cd8a	0dee7560-cc4f-43f9-bd39-7915655785bc	5801ce93-bb3b-4452-bfc8-768e953512bb	f2d9eda5-c41d-4429-8332-7d0d8262c716	2025-04-30	16:00:00	pending	2025-04-06 15:41:11.279245	2025-04-06 15:41:11.279245	\N	\N
ace4028a-eade-4b05-8f3e-b628a527e423	c0b90feb-7481-4918-b3fa-5ee28987951c	5801ce93-bb3b-4452-bfc8-768e953512bb	f2d9eda5-c41d-4429-8332-7d0d8262c716	2025-05-01	17:00:00	pending	2025-04-06 15:41:11.282276	2025-04-06 15:41:11.282276	\N	\N
bb74324b-e049-474a-b35f-cd8125c45f9c	2fc347f8-569d-45c1-9f23-f29d2f282ef9	5801ce93-bb3b-4452-bfc8-768e953512bb	f2d9eda5-c41d-4429-8332-7d0d8262c716	2025-05-02	18:00:00	pending	2025-04-06 15:41:11.285276	2025-04-06 15:41:11.285276	\N	\N
036b2b89-3ac6-4b88-9451-188a626a9fa2	1d6787e0-8757-40dc-ae90-8d6b8c0a325b	5801ce93-bb3b-4452-bfc8-768e953512bb	f2d9eda5-c41d-4429-8332-7d0d8262c716	2025-05-05	09:00:00	pending	2025-04-06 15:41:11.288262	2025-04-06 15:41:11.288262	\N	\N
37c506c0-90b4-4690-a909-a9f222d6902b	e6383118-75a8-4f87-a8bd-fd13f64f895f	5801ce93-bb3b-4452-bfc8-768e953512bb	f2d9eda5-c41d-4429-8332-7d0d8262c716	2025-05-06	10:00:00	pending	2025-04-06 15:41:11.291157	2025-04-06 15:41:11.291157	\N	\N
f05a8fd2-59f0-4c9f-a159-7c1098ee5ff9	508f4666-868a-48ad-8d7c-6f6e393d5dfa	5801ce93-bb3b-4452-bfc8-768e953512bb	f2d9eda5-c41d-4429-8332-7d0d8262c716	2025-05-07	11:00:00	pending	2025-04-06 15:41:11.322678	2025-04-06 15:41:11.322678	\N	\N
1a8f5ff9-a888-4b16-a0dc-48b0fd1169b4	982bc7e3-9fae-4e93-9269-b51082f4b246	5801ce93-bb3b-4452-bfc8-768e953512bb	f2d9eda5-c41d-4429-8332-7d0d8262c716	2025-05-08	12:00:00	pending	2025-04-06 15:41:11.326258	2025-04-06 15:41:11.326258	\N	\N
a9d2df0a-8e1c-4d14-ac05-b139e07164de	78728cb0-cecd-4c33-ad31-81d8de559fad	5801ce93-bb3b-4452-bfc8-768e953512bb	f2d9eda5-c41d-4429-8332-7d0d8262c716	2025-05-09	13:00:00	pending	2025-04-06 15:41:11.329367	2025-04-06 15:41:11.329367	\N	\N
aaa88bdb-d6ac-42ed-bbde-2f01eabe3530	5cc9604f-25c2-4f6d-8d65-2dee80447824	5801ce93-bb3b-4452-bfc8-768e953512bb	f2d9eda5-c41d-4429-8332-7d0d8262c716	2025-05-12	14:00:00	pending	2025-04-06 15:41:11.332395	2025-04-06 15:41:11.332395	\N	\N
55f27116-03c0-4bb1-96b9-84e21a7f939d	f73faaff-0b31-4d04-9d43-91c4b41f43e0	5801ce93-bb3b-4452-bfc8-768e953512bb	f2d9eda5-c41d-4429-8332-7d0d8262c716	2025-05-13	15:00:00	pending	2025-04-06 15:41:11.335424	2025-04-06 15:41:11.335424	\N	\N
57452c3b-03fe-4a29-9cf1-0b35b170fc06	cde3fd47-d79c-42f3-aab3-591909ec18ae	5801ce93-bb3b-4452-bfc8-768e953512bb	f2d9eda5-c41d-4429-8332-7d0d8262c716	2025-05-14	16:00:00	pending	2025-04-06 15:41:11.338332	2025-04-06 15:41:11.338332	\N	\N
260d1743-a99f-4526-b03f-818c7beee515	82285d75-7858-4a63-ad8d-e26080e69089	5801ce93-bb3b-4452-bfc8-768e953512bb	f2d9eda5-c41d-4429-8332-7d0d8262c716	2025-05-15	17:00:00	pending	2025-04-06 15:41:11.341234	2025-04-06 15:41:11.341234	\N	\N
7817f939-3094-4504-9528-f3193f49de28	31d64150-f51a-4caf-ad07-07b83ec02071	f16a43a5-44ca-4b6a-9afe-831ebbfa9803	8d81ec1b-2dba-4b13-a9ad-2c2226497b41	2025-04-07	11:45:00	completed	2025-04-06 23:04:16.381204	2025-04-07 02:01:32.740773		2025-04-07 02:01:32.739124
10c14666-a436-4072-9272-8ccca4ff7fa4	31d64150-f51a-4caf-ad07-07b83ec02071	f16a43a5-44ca-4b6a-9afe-831ebbfa9803	8d81ec1b-2dba-4b13-a9ad-2c2226497b41	2025-04-07	11:15:00	confirmed	2025-04-06 23:01:59.448102	2025-04-07 14:05:58.276803		2025-04-07 14:05:58.27543
42caaf4e-e145-43d5-b417-4eab80c256dc	31d64150-f51a-4caf-ad07-07b83ec02071	f16a43a5-44ca-4b6a-9afe-831ebbfa9803	8d81ec1b-2dba-4b13-a9ad-2c2226497b41	2025-04-07	11:30:00	confirmed	2025-04-06 23:03:05.55847	2025-04-07 14:06:22.130742		\N
f343649f-16e1-4976-b184-74308f2078ce	31d64150-f51a-4caf-ad07-07b83ec02071	f16a43a5-44ca-4b6a-9afe-831ebbfa9803	8d81ec1b-2dba-4b13-a9ad-2c2226497b41	2025-04-08	13:00:00	confirmed	2025-04-07 11:22:37.421624	2025-04-07 14:47:49.121528		\N
a32934e5-3bd2-4758-b40d-29fdcff51ce0	31d64150-f51a-4caf-ad07-07b83ec02071	f16a43a5-44ca-4b6a-9afe-831ebbfa9803	8d81ec1b-2dba-4b13-a9ad-2c2226497b41	2025-04-11	11:00:00	confirmed	2025-04-10 21:06:48.664603	2025-04-10 21:32:58.388378		2025-04-10 21:32:58.387261
e2b9e2a5-dd8a-4b46-9e6c-d40409c9d811	31d64150-f51a-4caf-ad07-07b83ec02071	f16a43a5-44ca-4b6a-9afe-831ebbfa9803	8d81ec1b-2dba-4b13-a9ad-2c2226497b41	2025-04-11	12:00:00	confirmed	2025-04-10 21:25:36.897922	2025-04-10 21:33:12.724474		2025-04-10 21:33:12.723777
337b6931-7947-42c7-9c05-3c4f3d3e5b3c	31d64150-f51a-4caf-ad07-07b83ec02071	f16a43a5-44ca-4b6a-9afe-831ebbfa9803	8d81ec1b-2dba-4b13-a9ad-2c2226497b41	2025-04-11	14:00:00	confirmed	2025-04-10 21:40:45.99596	2025-04-10 22:31:03.548257		2025-04-10 22:31:03.546613
59841963-6bd1-46b3-8eb4-61babc8d7b31	31d64150-f51a-4caf-ad07-07b83ec02071	f16a43a5-44ca-4b6a-9afe-831ebbfa9803	8d81ec1b-2dba-4b13-a9ad-2c2226497b41	2025-04-11	13:30:00	confirmed	2025-04-10 22:31:45.728869	2025-04-10 23:14:39.205512		2025-04-10 23:14:39.204355
872663ff-8780-4f0c-b398-43bbd9e120ec	31d64150-f51a-4caf-ad07-07b83ec02071	f16a43a5-44ca-4b6a-9afe-831ebbfa9803	8d81ec1b-2dba-4b13-a9ad-2c2226497b41	2025-04-11	14:00:00	confirmed	2025-04-10 23:02:05.204529	2025-04-10 23:18:35.427031		2025-04-10 23:18:35.42423
e42c10be-6ef9-49cf-bd46-3ace165ccb67	31d64150-f51a-4caf-ad07-07b83ec02071	f16a43a5-44ca-4b6a-9afe-831ebbfa9803	8d81ec1b-2dba-4b13-a9ad-2c2226497b41	2025-04-13	11:30:00	confirmed	2025-04-12 23:15:59.274095	2025-04-13 00:02:50.067152		2025-04-13 00:02:50.066493
2eb3edc3-d47e-48c6-8453-c9231f10f087	31d64150-f51a-4caf-ad07-07b83ec02071	f16a43a5-44ca-4b6a-9afe-831ebbfa9803	8d81ec1b-2dba-4b13-a9ad-2c2226497b41	2025-04-13	12:30:00	confirmed	2025-04-12 23:38:02.746363	2025-04-13 00:02:55.610268		2025-04-13 00:02:55.60971
a07a0e3b-5122-4e74-8286-ded43df1126f	31d64150-f51a-4caf-ad07-07b83ec02071	f16a43a5-44ca-4b6a-9afe-831ebbfa9803	8d81ec1b-2dba-4b13-a9ad-2c2226497b41	2025-04-13	15:00:00	confirmed	2025-04-13 13:15:58.595718	2025-04-13 13:15:58.595718		\N
19c918f9-3424-4c75-a2f1-63225d0c41a6	31d64150-f51a-4caf-ad07-07b83ec02071	f16a43a5-44ca-4b6a-9afe-831ebbfa9803	8d81ec1b-2dba-4b13-a9ad-2c2226497b41	2025-04-13	12:00:00	confirmed	2025-04-13 00:35:16.649521	2025-04-13 13:18:59.93789		2025-04-13 13:18:59.937276
1ff6a890-1a59-4003-a5dd-c25d3cd1017c	31d64150-f51a-4caf-ad07-07b83ec02071	f16a43a5-44ca-4b6a-9afe-831ebbfa9803	8d81ec1b-2dba-4b13-a9ad-2c2226497b41	2025-04-13	13:00:00	confirmed	2025-04-13 00:02:38.896722	2025-04-13 13:19:06.182344		2025-04-13 13:19:06.181789
de5005ab-e40e-44fd-97ac-10982b73cf9b	31d64150-f51a-4caf-ad07-07b83ec02071	f16a43a5-44ca-4b6a-9afe-831ebbfa9803	8d81ec1b-2dba-4b13-a9ad-2c2226497b41	2025-04-13	14:00:00	confirmed	2025-04-13 01:55:00.309859	2025-04-13 13:19:13.964999		2025-04-13 13:19:13.964401
d51c14c6-7e34-42e6-ae30-f912007b3cb3	31d64150-f51a-4caf-ad07-07b83ec02071	f16a43a5-44ca-4b6a-9afe-831ebbfa9803	8d81ec1b-2dba-4b13-a9ad-2c2226497b41	2025-04-13	16:00:00	confirmed	2025-04-13 13:26:58.65512	2025-04-13 13:27:31.207762		\N
37f2d645-f9b2-42ca-b61c-ab654d2b06d6	31d64150-f51a-4caf-ad07-07b83ec02071	f16a43a5-44ca-4b6a-9afe-831ebbfa9803	8d81ec1b-2dba-4b13-a9ad-2c2226497b41	2025-04-14	15:00:00	confirmed	2025-04-13 13:34:39.659639	2025-04-13 13:34:39.659639		\N
\.


--
-- Data for Name: ar_internal_metadata; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.ar_internal_metadata (key, value, created_at, updated_at) FROM stdin;
environment	production	2025-04-06 15:40:54.116334	2025-04-06 15:40:54.116337
\.


--
-- Data for Name: clinics; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.clinics (id, name, address, created_at, updated_at) FROM stdin;
8d81ec1b-2dba-4b13-a9ad-2c2226497b41	Clínica Dental del Sol	Chiclana 123, Bahia Blanca	2025-04-06 15:40:56.293544	2025-04-06 15:40:56.293544
6afc8d57-14df-46ad-863d-6b2a4eaacf77	Clínica Sonrisa Perfecta	Florida 456, Bahia Blanca	2025-04-06 15:41:05.122091	2025-04-06 15:41:05.122091
f2d9eda5-c41d-4429-8332-7d0d8262c716	Clínica Dientes Brillantes	Corrientes 789, Bahia Blanca	2025-04-06 15:41:07.770657	2025-04-06 15:41:07.770657
\.


--
-- Data for Name: patients; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.patients (id, email, phone, professional_id, created_at, updated_at, first_name, last_name) FROM stdin;
7ae3cd0f-c0c1-47a3-8ece-8f200624087d	patient_c1_d1_1@example.com	1193229131	256bf05b-60f3-4799-b26d-3f5fee0b8688	2025-04-06 15:40:57.476836	2025-04-06 15:40:57.476836	Martín	Romero
c628dea0-41cf-4d56-a2d9-97e25eede2ca	patient_c1_d1_2@example.com	1196716582	256bf05b-60f3-4799-b26d-3f5fee0b8688	2025-04-06 15:40:57.70181	2025-04-06 15:40:57.70181	Pedro	Rodríguez
4db2f6c5-91e8-4022-b51d-41d445466030	patient_c1_d1_3@example.com	1146484790	256bf05b-60f3-4799-b26d-3f5fee0b8688	2025-04-06 15:40:57.956867	2025-04-06 15:40:57.956867	Sofía	Martínez
6747ef9e-d66e-434c-8d93-382a4d5f10ba	patient_c1_d1_4@example.com	1163102816	256bf05b-60f3-4799-b26d-3f5fee0b8688	2025-04-06 15:40:58.177145	2025-04-06 15:40:58.177145	Pedro	Romero
6c505651-caf9-4a5d-9303-77d0755f5cac	patient_c1_d1_5@example.com	1191395684	256bf05b-60f3-4799-b26d-3f5fee0b8688	2025-04-06 15:40:58.400011	2025-04-06 15:40:58.400011	Pedro	Rodríguez
bc451112-ee56-43a3-8783-5c2d94a09d03	patient_c1_d1_6@example.com	1192491925	256bf05b-60f3-4799-b26d-3f5fee0b8688	2025-04-06 15:40:58.618911	2025-04-06 15:40:58.618911	Lucía	Díaz
a8c790ec-9f7b-42ba-88d9-b286df60e113	patient_c1_d1_7@example.com	1168845419	256bf05b-60f3-4799-b26d-3f5fee0b8688	2025-04-06 15:40:58.841853	2025-04-06 15:40:58.841853	Martín	Fernández
2b04ed45-8566-401d-80fe-39c3b99c90c7	patient_c1_d1_8@example.com	1188063942	256bf05b-60f3-4799-b26d-3f5fee0b8688	2025-04-06 15:40:59.059815	2025-04-06 15:40:59.059815	Clara	Pérez
fbd1938b-68a3-4ae5-9738-9fe71394663d	patient_c1_d1_9@example.com	1189235871	256bf05b-60f3-4799-b26d-3f5fee0b8688	2025-04-06 15:40:59.282413	2025-04-06 15:40:59.282413	Clara	Fernández
d7b8797c-5159-48dc-b2d2-52f43556ca6a	patient_c1_d1_10@example.com	1156369060	256bf05b-60f3-4799-b26d-3f5fee0b8688	2025-04-06 15:40:59.502845	2025-04-06 15:40:59.502845	Diego	Romero
355b1cef-bd13-4b98-91c9-7c95079b4523	patient_c1_d1_11@example.com	1181148543	256bf05b-60f3-4799-b26d-3f5fee0b8688	2025-04-06 15:40:59.724525	2025-04-06 15:40:59.724525	Juan	Gómez
b56ad062-0612-4ff8-8a44-c3f48a1c0138	patient_c1_d1_12@example.com	1130499118	256bf05b-60f3-4799-b26d-3f5fee0b8688	2025-04-06 15:40:59.945743	2025-04-06 15:40:59.945743	Diego	Sánchez
d84c6d7d-2979-41cc-9c03-f2d5d18f367a	patient_c1_d2_1@example.com	1191504415	61c8f6b0-5b7d-4156-8caa-fac87015c290	2025-04-06 15:41:00.169944	2025-04-06 15:41:00.169944	Juan	Rodríguez
202bdf01-697b-4006-81b0-e143365d1012	patient_c1_d2_2@example.com	1156746707	61c8f6b0-5b7d-4156-8caa-fac87015c290	2025-04-06 15:41:00.394411	2025-04-06 15:41:00.394411	Sofía	Gómez
bd9f1ced-f9c7-4c55-9d15-02f24bad809a	patient_c1_d2_3@example.com	1172764800	61c8f6b0-5b7d-4156-8caa-fac87015c290	2025-04-06 15:41:00.621033	2025-04-06 15:41:00.621033	Juan	Romero
a04ce7b5-ab0f-4a9b-b06f-788d367236cc	patient_c1_d2_4@example.com	1124195365	61c8f6b0-5b7d-4156-8caa-fac87015c290	2025-04-06 15:41:00.842645	2025-04-06 15:41:00.842645	Pedro	Martínez
9683c9d6-86f9-4616-85a2-7e1d2561f723	patient_c1_d2_5@example.com	1121475704	61c8f6b0-5b7d-4156-8caa-fac87015c290	2025-04-06 15:41:01.065304	2025-04-06 15:41:01.065304	Pedro	Pérez
bf72f8a9-7fca-4435-97ac-794272a7229c	patient_c1_d2_6@example.com	1191334355	61c8f6b0-5b7d-4156-8caa-fac87015c290	2025-04-06 15:41:01.28595	2025-04-06 15:41:01.28595	Ana	Gómez
1387181c-a6eb-4e6c-a7df-f5c03201903a	patient_c1_d2_7@example.com	1173483021	61c8f6b0-5b7d-4156-8caa-fac87015c290	2025-04-06 15:41:01.507009	2025-04-06 15:41:01.507009	Sofía	Gómez
0b2b24cd-8bb1-4190-bb76-2330f0a8f65d	patient_c1_d2_8@example.com	1179323349	61c8f6b0-5b7d-4156-8caa-fac87015c290	2025-04-06 15:41:01.724846	2025-04-06 15:41:01.724846	Clara	López
6e9f69a9-9c18-4e19-98f3-e78f16183e30	patient_c1_d2_9@example.com	1163318004	61c8f6b0-5b7d-4156-8caa-fac87015c290	2025-04-06 15:41:01.948875	2025-04-06 15:41:01.948875	Ana	García
2ad8c812-47ce-4ba9-8d59-b4b9826f3208	patient_c1_d2_10@example.com	1164381716	61c8f6b0-5b7d-4156-8caa-fac87015c290	2025-04-06 15:41:02.175032	2025-04-06 15:41:02.175032	Sofía	García
fe432b6b-c825-4ac8-aee1-0f980aa1edfc	patient_c1_d2_11@example.com	1112311994	61c8f6b0-5b7d-4156-8caa-fac87015c290	2025-04-06 15:41:02.430428	2025-04-06 15:41:02.430428	Juan	Rodríguez
c65fafdd-d7da-430b-9e06-e17adef96250	patient_c1_d2_12@example.com	1171231407	61c8f6b0-5b7d-4156-8caa-fac87015c290	2025-04-06 15:41:02.647278	2025-04-06 15:41:02.647278	Clara	López
b8f47b5f-d171-434d-b3fa-6a74294f2453	patient_c1_d3_1@example.com	1184724320	80fedf7c-0f67-43bd-8813-df56db5c071c	2025-04-06 15:41:02.863696	2025-04-06 15:41:02.863696	Juan	García
2f09a6c7-5948-4f6e-bd9f-7ae3c2b29949	patient_c1_d3_2@example.com	1136004181	80fedf7c-0f67-43bd-8813-df56db5c071c	2025-04-06 15:41:03.084175	2025-04-06 15:41:03.084175	Pedro	López
4a716b7c-32b8-4dab-b5d7-61c22afc3236	patient_c1_d3_3@example.com	1165136036	80fedf7c-0f67-43bd-8813-df56db5c071c	2025-04-06 15:41:03.301424	2025-04-06 15:41:03.301424	Mateo	Fernández
fff180c1-254f-4256-bb1e-9761e6f95d39	patient_c1_d3_4@example.com	1166529864	80fedf7c-0f67-43bd-8813-df56db5c071c	2025-04-06 15:41:03.519992	2025-04-06 15:41:03.519992	Valeria	Pérez
3508844d-de98-468e-a9b8-ce7e314225c6	patient_c1_d3_5@example.com	1116020631	80fedf7c-0f67-43bd-8813-df56db5c071c	2025-04-06 15:41:03.739315	2025-04-06 15:41:03.739315	Martín	Sánchez
7afdef21-27c5-44fa-8309-be74524dd054	patient_c1_d3_6@example.com	1196417592	80fedf7c-0f67-43bd-8813-df56db5c071c	2025-04-06 15:41:03.955829	2025-04-06 15:41:03.955829	Diego	Gómez
1420ee73-773d-48a9-bece-09c2ff2234b5	patient_c1_d3_7@example.com	1141579288	80fedf7c-0f67-43bd-8813-df56db5c071c	2025-04-06 15:41:04.172139	2025-04-06 15:41:04.172139	Martín	López
5fa934eb-5a3b-4aba-b76e-73d1f978a8b1	patient_c1_d3_8@example.com	1115610802	80fedf7c-0f67-43bd-8813-df56db5c071c	2025-04-06 15:41:04.456444	2025-04-06 15:41:04.456444	Sofía	Sánchez
8a2130f6-ee14-41a2-a404-f127992b07c3	patient_c1_d3_9@example.com	1195246028	80fedf7c-0f67-43bd-8813-df56db5c071c	2025-04-06 15:41:04.68284	2025-04-06 15:41:04.68284	Clara	García
54f830b2-9809-4c74-b73b-0ba108e3bb0c	patient_c1_d3_10@example.com	1132163458	80fedf7c-0f67-43bd-8813-df56db5c071c	2025-04-06 15:41:04.902681	2025-04-06 15:41:04.902681	Clara	Rodríguez
ee8e4134-208d-4f68-a000-da7f7cc843ea	patient_c1_d3_11@example.com	1180758470	80fedf7c-0f67-43bd-8813-df56db5c071c	2025-04-06 15:41:05.119428	2025-04-06 15:41:05.119428	Pedro	Pérez
962d494e-feaa-45a3-8294-0eac147e54fb	patient_c2_1@example.com	1153270434	c9e2efb2-adc5-42c8-aee6-f993fcab76ff	2025-04-06 15:41:05.778421	2025-04-06 15:41:05.778421	Pedro	García
c1637852-d07c-43f7-b90b-43ef989d8e9f	patient_c2_2@example.com	1152753521	c9e2efb2-adc5-42c8-aee6-f993fcab76ff	2025-04-06 15:41:05.998802	2025-04-06 15:41:05.998802	Valeria	Gómez
d5823bd8-5c3b-45aa-9f26-578da2aa4508	patient_c2_3@example.com	1153895570	c9e2efb2-adc5-42c8-aee6-f993fcab76ff	2025-04-06 15:41:06.216779	2025-04-06 15:41:06.216779	Mateo	Romero
870bf513-940e-4c61-9738-e38e79a9f3c5	patient_c2_4@example.com	1187853354	c9e2efb2-adc5-42c8-aee6-f993fcab76ff	2025-04-06 15:41:06.432761	2025-04-06 15:41:06.432761	Sofía	Gómez
fcef99e7-4e86-4a0b-897f-cf46ca04e6dd	patient_c2_5@example.com	1120797829	c9e2efb2-adc5-42c8-aee6-f993fcab76ff	2025-04-06 15:41:06.648036	2025-04-06 15:41:06.648036	Juan	Rodríguez
6a4479ee-03ed-4114-9a42-6502e80b9049	patient_c2_6@example.com	1136824871	c9e2efb2-adc5-42c8-aee6-f993fcab76ff	2025-04-06 15:41:06.863507	2025-04-06 15:41:06.863507	Pedro	Romero
870c3599-1f89-4693-9bf8-090b13dec1eb	patient_c2_7@example.com	1134104981	c9e2efb2-adc5-42c8-aee6-f993fcab76ff	2025-04-06 15:41:07.07899	2025-04-06 15:41:07.07899	Ana	Fernández
90342d5e-499f-4591-9a9e-ceaa5017e8a0	patient_c2_8@example.com	1138348567	c9e2efb2-adc5-42c8-aee6-f993fcab76ff	2025-04-06 15:41:07.299901	2025-04-06 15:41:07.299901	Clara	Romero
231bc521-0e08-4304-be3a-b472d26f44a4	patient_c2_9@example.com	1114913973	c9e2efb2-adc5-42c8-aee6-f993fcab76ff	2025-04-06 15:41:07.523802	2025-04-06 15:41:07.523802	Clara	Martínez
024579eb-d4ae-435e-ac1d-a21cad39742e	patient_c2_10@example.com	1133311339	c9e2efb2-adc5-42c8-aee6-f993fcab76ff	2025-04-06 15:41:07.7675	2025-04-06 15:41:07.7675	Sofía	Gómez
a634af5c-e09b-4986-880d-734dffbe666e	patient_c3_1@example.com	1164023548	42d1194a-63e3-425c-a44d-e327e3290f5a	2025-04-06 15:41:08.225464	2025-04-06 15:41:08.225464	Sofía	Pérez
ef3aad9f-1b4f-4ee8-b6a6-1684d9620a12	patient_c3_2@example.com	1150428142	42d1194a-63e3-425c-a44d-e327e3290f5a	2025-04-06 15:41:08.446106	2025-04-06 15:41:08.446106	Mateo	Fernández
0dee7560-cc4f-43f9-bd39-7915655785bc	patient_c3_3@example.com	1185825345	42d1194a-63e3-425c-a44d-e327e3290f5a	2025-04-06 15:41:08.66745	2025-04-06 15:41:08.66745	Valeria	Gómez
c0b90feb-7481-4918-b3fa-5ee28987951c	patient_c3_4@example.com	1157235543	42d1194a-63e3-425c-a44d-e327e3290f5a	2025-04-06 15:41:08.892441	2025-04-06 15:41:08.892441	Mateo	Rodríguez
2fc347f8-569d-45c1-9f23-f29d2f282ef9	patient_c3_5@example.com	1126861287	42d1194a-63e3-425c-a44d-e327e3290f5a	2025-04-06 15:41:09.114811	2025-04-06 15:41:09.114811	Pedro	Díaz
1d6787e0-8757-40dc-ae90-8d6b8c0a325b	patient_c3_6@example.com	1176994615	42d1194a-63e3-425c-a44d-e327e3290f5a	2025-04-06 15:41:09.332811	2025-04-06 15:41:09.332811	Pedro	Díaz
e6383118-75a8-4f87-a8bd-fd13f64f895f	patient_c3_7@example.com	1142556240	42d1194a-63e3-425c-a44d-e327e3290f5a	2025-04-06 15:41:09.548158	2025-04-06 15:41:09.548158	Juan	Romero
508f4666-868a-48ad-8d7c-6f6e393d5dfa	patient_c3_8@example.com	1134724911	42d1194a-63e3-425c-a44d-e327e3290f5a	2025-04-06 15:41:09.763941	2025-04-06 15:41:09.763941	Juan	Martínez
982bc7e3-9fae-4e93-9269-b51082f4b246	patient_c3_9@example.com	1171157522	42d1194a-63e3-425c-a44d-e327e3290f5a	2025-04-06 15:41:09.98774	2025-04-06 15:41:09.98774	Pedro	Fernández
78728cb0-cecd-4c33-ad31-81d8de559fad	patient_c3_10@example.com	1168545036	42d1194a-63e3-425c-a44d-e327e3290f5a	2025-04-06 15:41:10.20898	2025-04-06 15:41:10.20898	Diego	Romero
5cc9604f-25c2-4f6d-8d65-2dee80447824	patient_c3_11@example.com	1110580387	42d1194a-63e3-425c-a44d-e327e3290f5a	2025-04-06 15:41:10.426338	2025-04-06 15:41:10.426338	Lucía	Rodríguez
f73faaff-0b31-4d04-9d43-91c4b41f43e0	patient_c3_12@example.com	1191475708	42d1194a-63e3-425c-a44d-e327e3290f5a	2025-04-06 15:41:10.648545	2025-04-06 15:41:10.648545	Valeria	Fernández
cde3fd47-d79c-42f3-aab3-591909ec18ae	patient_c3_13@example.com	1199344320	42d1194a-63e3-425c-a44d-e327e3290f5a	2025-04-06 15:41:10.867659	2025-04-06 15:41:10.867659	Ana	Martínez
31d64150-f51a-4caf-ad07-07b83ec02071	maccari78@gmail.com	+54 9 291 444-4264	256bf05b-60f3-4799-b26d-3f5fee0b8688	2025-04-06 17:51:05.667918	2025-04-07 00:57:30.64443	Danilo	Maccari
82285d75-7858-4a63-ad8d-e26080e69089	patient_c3_14@example.com	1154090492	42d1194a-63e3-425c-a44d-e327e3290f5a	2025-04-06 15:41:11.08966	2025-04-07 00:59:08.35284	Diego	Díaz
\.


--
-- Data for Name: payments; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.payments (id, appointment_id, amount, status, external_payment_id, created_at, updated_at) FROM stdin;
3	10c14666-a436-4072-9272-8ccca4ff7fa4	10.00	0	cs_test_a1rbiTRQZux0OIFRyXHLOq32d6sKwMu4t543moibOvuJyTFHlsGZ7EADjD	2025-04-07 11:20:09.605986	2025-04-07 11:20:10.249707
4	42caaf4e-e145-43d5-b417-4eab80c256dc	10.00	0	cs_test_a1W3ZFbHzA4uqAh8e1iWbqcRNiYHhCGy0Cd27bCyfu3D38gxPJR600ervF	2025-04-09 22:57:26.188895	2025-04-09 22:57:26.743906
7	f343649f-16e1-4976-b184-74308f2078ce	10.00	0	cs_test_a1LEF49RPL53aLzznwVOdos1R6bGSEF18pCxt9Klcunmhm60Ga7qH0x9J9	2025-04-10 20:56:59.570429	2025-04-10 20:57:00.278114
9	a32934e5-3bd2-4758-b40d-29fdcff51ce0	10.00	0	cs_test_a1G8KqKpo5j5b7PBrvyGEwfs9jGSXeziNYnWct2zbQrPD7ee5OYZfl1mOL	2025-04-10 21:19:49.185012	2025-04-10 21:19:49.804389
10	e2b9e2a5-dd8a-4b46-9e6c-d40409c9d811	10.00	0	cs_test_a1QJFeeMIgWtChhT54pKyiHhKN4G0KHzD7tjtqWAvXQFYtdULGkol74PYO	2025-04-10 21:26:02.170009	2025-04-10 21:26:02.602498
11	337b6931-7947-42c7-9c05-3c4f3d3e5b3c	10.00	0	cs_test_a1dGXtiDDxnbJeEmicCXUGlgWiHt8OB0Tcm3dDmJQgfdwjUEHz8bN2Z7sj	2025-04-10 21:41:08.634057	2025-04-10 21:41:09.126166
16	872663ff-8780-4f0c-b398-43bbd9e120ec	50.00	0	\N	2025-04-10 23:02:36.626884	2025-04-10 23:02:36.626884
17	e42c10be-6ef9-49cf-bd46-3ace165ccb67	10.00	0	cs_test_a1WW0Uz8w1WFAcs5DUAo0hmr20Y2HkvsVBdbpQp5i2BgvfetPOS60OHyC6	2025-04-12 23:16:16.960983	2025-04-12 23:16:17.365949
18	2eb3edc3-d47e-48c6-8453-c9231f10f087	10.00	0	cs_test_a1wBcBe94eMGE7qSElTAN6Ki7x03WOzsN7NG1oMHd4FrZx2gfKmNXMEkzf	2025-04-12 23:38:20.19965	2025-04-12 23:38:20.640482
19	1ff6a890-1a59-4003-a5dd-c25d3cd1017c	10.00	0	cs_test_a10fPVhn34jHsMbqgBDtBlj7IyoGoUkLyLit8FurESkzvb1zGGX9zeN2WK	2025-04-13 00:03:11.063107	2025-04-13 00:03:11.608918
20	19c918f9-3424-4c75-a2f1-63225d0c41a6	10.00	0	cs_test_a1GcbIDkAYdrxGtJaoFTWrGAIZvkaNUKlhxQk5UKJb6AO9MmsqZC8Rp8WR	2025-04-13 01:42:13.904114	2025-04-13 01:42:14.495913
21	de5005ab-e40e-44fd-97ac-10982b73cf9b	10.00	0	cs_test_a1XoHGVxPLqFAOwmFVsbaZr2O2NaFoU2rSBFsWtGAFrMLH5XgycENiCvZH	2025-04-13 01:55:20.803953	2025-04-13 01:55:21.303748
22	a07a0e3b-5122-4e74-8286-ded43df1126f	10.00	1	cs_test_a1VxjtSmbrG1HH57s9bJ1c7vJTqkTxi9cCaIpFPAPPTf8ggcAhC4Pg2F5k	2025-04-13 13:16:30.777494	2025-04-13 13:16:57.713399
23	d51c14c6-7e34-42e6-ae30-f912007b3cb3	10.00	1	cs_test_a1waFO9Krm9cSFtxrLBOxcjMmzoYBnYHbPFTlSq8wC48NXkD6ub4qQrE6e	2025-04-13 13:27:43.85667	2025-04-13 13:28:08.877682
24	37f2d645-f9b2-42ca-b61c-ab654d2b06d6	10.00	1	cs_test_a1HISZ30Nq7QWBwUcEzbP0qZP0BTzVDRuvPvfAmop62YrnuneDObz2qEie	2025-04-13 13:35:02.454342	2025-04-13 13:35:26.041253
\.


--
-- Data for Name: professionals; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.professionals (id, user_id, specialty, license_number, clinic_id, created_at, updated_at) FROM stdin;
f16a43a5-44ca-4b6a-9afe-831ebbfa9803	256bf05b-60f3-4799-b26d-3f5fee0b8688	0	LIC12345	8d81ec1b-2dba-4b13-a9ad-2c2226497b41	2025-04-06 15:40:56.552818	2025-04-06 15:40:56.552818
9adf7839-64c5-4690-b05a-fa63a8db48f4	61c8f6b0-5b7d-4156-8caa-fac87015c290	0	LIC67890	8d81ec1b-2dba-4b13-a9ad-2c2226497b41	2025-04-06 15:40:56.774659	2025-04-06 15:40:56.774659
2bbbb6eb-57eb-4183-aecb-a1156aadb11c	80fedf7c-0f67-43bd-8813-df56db5c071c	0	LIC54321	8d81ec1b-2dba-4b13-a9ad-2c2226497b41	2025-04-06 15:40:57.002823	2025-04-06 15:40:57.002823
c613e6dc-c300-4776-95bd-5ffe0dacf4c8	c9e2efb2-adc5-42c8-aee6-f993fcab76ff	0	LIC98765	6afc8d57-14df-46ad-863d-6b2a4eaacf77	2025-04-06 15:41:05.343783	2025-04-06 15:41:05.343783
5801ce93-bb3b-4452-bfc8-768e953512bb	42d1194a-63e3-425c-a44d-e327e3290f5a	0	LIC45678	f2d9eda5-c41d-4429-8332-7d0d8262c716	2025-04-06 15:41:08.000349	2025-04-06 15:41:08.000349
\.


--
-- Data for Name: professionals_secretaries; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.professionals_secretaries (id, professional_id, secretary_id, created_at, updated_at) FROM stdin;
3c24850e-a716-4167-b2a1-37c197bab2b5	f16a43a5-44ca-4b6a-9afe-831ebbfa9803	f2b4fef4-c436-41b9-8e28-8059dee5c3e5	2025-04-06 15:40:57.235119	2025-04-06 15:40:57.235119
d771d914-0f6f-4f6f-99ef-f3927ed5b170	9adf7839-64c5-4690-b05a-fa63a8db48f4	f2b4fef4-c436-41b9-8e28-8059dee5c3e5	2025-04-06 15:40:57.239709	2025-04-06 15:40:57.239709
3d93e245-a479-4475-98ba-09dcbe2c8996	2bbbb6eb-57eb-4183-aecb-a1156aadb11c	f2b4fef4-c436-41b9-8e28-8059dee5c3e5	2025-04-06 15:40:57.243723	2025-04-06 15:40:57.243723
1bd63878-f263-417b-b9de-77b4f071dc52	c613e6dc-c300-4776-95bd-5ffe0dacf4c8	11db1a8d-4d1e-4b77-9b80-144dd21db908	2025-04-06 15:41:05.561909	2025-04-06 15:41:05.561909
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.schema_migrations (version) FROM stdin;
20250315140143
20250315140447
20250315140501
20250315140502
20250315140601
20250316192856
20250318192913
20250320211746
20250322001708
20250323153705
20250324222620
20250324224814
20250324230217
20250326004102
20250326203413
20250327212833
20250403220836
20250316221634
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.users (id, email, encrypted_password, reset_password_token, reset_password_sent_at, remember_created_at, clinic_id, created_at, updated_at, role, first_name, last_name, provider, uid) FROM stdin;
b5abaecb-0465-4613-b1e5-ac8a3ac53e5a	admin@example.com	$2a$12$l6MEYs2qxIy2CPKUJaVzrePWqkKr.vPdOoiP7RqadFx/QhiY0bIdG	\N	\N	\N	\N	2025-04-06 15:40:56.279233	2025-04-06 15:40:56.279233	3	Admin	User	\N	\N
256bf05b-60f3-4799-b26d-3f5fee0b8688	dr.alvarez@example.com	$2a$12$q4zUn25uEkEm7Tunc0GA4.GgBIoNzlYXl4bMMuYPq7DNIcbPM4DC2	\N	\N	\N	8d81ec1b-2dba-4b13-a9ad-2c2226497b41	2025-04-06 15:40:56.538048	2025-04-06 15:40:56.538048	2	Carlos	Álvarez	\N	\N
61c8f6b0-5b7d-4156-8caa-fac87015c290	dr.sanchez@example.com	$2a$12$wKFbxNDKZ85eGY2.hhosmuYH1QgeBQj5RhbpCsgYdloxRGurugdgO	\N	\N	\N	8d81ec1b-2dba-4b13-a9ad-2c2226497b41	2025-04-06 15:40:56.771301	2025-04-06 15:40:56.771301	2	María	Sánchez	\N	\N
80fedf7c-0f67-43bd-8813-df56db5c071c	dr.lopez@example.com	$2a$12$dr1E0Dp2wHtmlpu73.6C2.Ysu3pzla93QGHw1L/FM32dBgBTyhdtS	\N	\N	\N	8d81ec1b-2dba-4b13-a9ad-2c2226497b41	2025-04-06 15:40:56.990192	2025-04-06 15:40:56.990192	2	Javier	López	\N	\N
f2b4fef4-c436-41b9-8e28-8059dee5c3e5	secretary.sol@example.com	$2a$12$isNiMqkSYzW0SEdCsNjH/efrX2el.wAfsVQE9uaH5o2rjy3m25/He	\N	\N	\N	8d81ec1b-2dba-4b13-a9ad-2c2226497b41	2025-04-06 15:40:57.222828	2025-04-06 15:40:57.222828	1	Susana	Fernández	\N	\N
166ecd55-4b8f-4050-9a47-94acfd08fd88	patient_c1_d1_1@example.com	$2a$12$RYkWC2naryJDdNMSVgpmx.TJBA4yy8xYxge.FM2qLBtirSIHXPLn6	\N	\N	\N	\N	2025-04-06 15:40:57.462383	2025-04-06 15:40:57.462383	0	Martín	Romero	\N	\N
82ef2ffb-1b9c-4156-bc0f-6686177566e5	patient_c1_d1_2@example.com	$2a$12$LzA6I4yl0re6ifejSuJOl.Pa5V2yEpi4W8HNU4E24lMhmq.Z7.VnS	\N	\N	\N	\N	2025-04-06 15:40:57.693754	2025-04-06 15:40:57.693754	0	Pedro	Rodríguez	\N	\N
b6884a9d-390f-41cc-aee3-aaa4ff3cc6a3	patient_c1_d1_3@example.com	$2a$12$KLTzi1Ppc7ObhVTElmNGYezhdiBcRXDt0DiG8gGS6kXaXJ6jTI60e	\N	\N	\N	\N	2025-04-06 15:40:57.931142	2025-04-06 15:40:57.931142	0	Sofía	Martínez	\N	\N
b10d7d6f-59b7-46bf-8c08-9ff2ff05381f	patient_c1_d1_4@example.com	$2a$12$TRQTK8lWGVEEYCpxmJ0CfO3nNNED.T.GT3icU6iF1bxnmjYyxSPHa	\N	\N	\N	\N	2025-04-06 15:40:58.17196	2025-04-06 15:40:58.17196	0	Pedro	Romero	\N	\N
d221ef27-d83f-4c12-ad01-63e073ac104a	patient_c1_d1_5@example.com	$2a$12$wHnoJtfwO.G15Dd76rP44uDJHVQmblE2Iztkw1hsLOBETcyUkczVy	\N	\N	\N	\N	2025-04-06 15:40:58.395684	2025-04-06 15:40:58.395684	0	Pedro	Rodríguez	\N	\N
1a98d8e1-04cf-42a5-b098-14652bab6f02	patient_c1_d1_6@example.com	$2a$12$OInKVHKA6RPTbETd3/BzYO31B8i4idf9.LPOGpb59J9aa6unKlMiq	\N	\N	\N	\N	2025-04-06 15:40:58.61388	2025-04-06 15:40:58.61388	0	Lucía	Díaz	\N	\N
38cef2ee-92b5-464d-8f9f-854d69412799	patient_c1_d1_7@example.com	$2a$12$wD397EJT8QOEOLUhfMVwFetcASwOnSLyU29D5Fo9XYp/05wQqIa7C	\N	\N	\N	\N	2025-04-06 15:40:58.834294	2025-04-06 15:40:58.834294	0	Martín	Fernández	\N	\N
21eaf790-eddb-4c5c-b74d-da098284c13f	patient_c1_d1_8@example.com	$2a$12$Z5xKF/GZrU18vkx9/OWFYeWxzqt0NqyccVeCzbybHghhlgviCIK3G	\N	\N	\N	\N	2025-04-06 15:40:59.054626	2025-04-06 15:40:59.054626	0	Clara	Pérez	\N	\N
70925c22-8e65-4570-b176-98d729d5422c	patient_c1_d1_9@example.com	$2a$12$aFkjVKo1ccVZNEWG2jNYDOXA8rsg5rSzu8qoP0vahV879vd/rvRsy	\N	\N	\N	\N	2025-04-06 15:40:59.276751	2025-04-06 15:40:59.276751	0	Clara	Fernández	\N	\N
928b803d-1ef5-46d4-b1ed-5a7bb6d4b5fa	patient_c1_d1_10@example.com	$2a$12$J84i.anBMwVyPfwVlbbDguqW85SrvesydkT/er644UeRjOcG2eByS	\N	\N	\N	\N	2025-04-06 15:40:59.496246	2025-04-06 15:40:59.496246	0	Diego	Romero	\N	\N
46605f9b-ca20-40da-8e65-67a938552032	patient_c1_d1_11@example.com	$2a$12$cDa2.x1x3n9qdLC6SaMV..nz4BWXA2njMi4ksB8FFX.e56cHXOGbm	\N	\N	\N	\N	2025-04-06 15:40:59.71609	2025-04-06 15:40:59.71609	0	Juan	Gómez	\N	\N
baf53d61-b8eb-4ea4-8401-bddb30e3af6d	patient_c1_d1_12@example.com	$2a$12$8eR1KjEFPNUIvxZgGkgvPOhQfWnLtYadk82OMux6cLBg8EgpWuLRC	\N	\N	\N	\N	2025-04-06 15:40:59.937529	2025-04-06 15:40:59.937529	0	Diego	Sánchez	\N	\N
81e1310c-ea54-4d4e-8b1f-2a2b36dee193	patient_c1_d2_1@example.com	$2a$12$f.ITMA3x3XxRvzuZTnk0wOBtC79Z1KuWiQSd6Lu5KcFvzVf85R5g2	\N	\N	\N	\N	2025-04-06 15:41:00.162346	2025-04-06 15:41:00.162346	0	Juan	Rodríguez	\N	\N
52521ca4-b4f6-4cbc-abb0-8ddcadc7664d	patient_c1_d2_2@example.com	$2a$12$6HrOftBmya6CSb1jGTe2ZO2P7QBq9VMM8F3duUOYDQvT3t7sdnXH2	\N	\N	\N	\N	2025-04-06 15:41:00.384679	2025-04-06 15:41:00.384679	0	Sofía	Gómez	\N	\N
f3d5c19b-3fc9-4b3f-9a1c-e7c5600632b5	patient_c1_d2_3@example.com	$2a$12$cBUrqI.XTtJn0vvXKN/f6ecUcFRSZ2ogEqYw1CKExf4tUA8jKszba	\N	\N	\N	\N	2025-04-06 15:41:00.611072	2025-04-06 15:41:00.611072	0	Juan	Romero	\N	\N
d9742ff2-9837-4d7f-8f32-4233b38f9e46	patient_c1_d2_4@example.com	$2a$12$AdQq5TBGO7KVYK5gIIQDqOsTXqx3UAIqVfEvfXzsncWi143wz5lR.	\N	\N	\N	\N	2025-04-06 15:41:00.838144	2025-04-06 15:41:00.838144	0	Pedro	Martínez	\N	\N
87d28647-d3c8-4071-8f0c-a51fc5e03f90	patient_c1_d2_5@example.com	$2a$12$XBO/NK6RjXjaqSwA2SxUJe1cpa3xq2U.0ovjuFOiLGauhQlJSzeCq	\N	\N	\N	\N	2025-04-06 15:41:01.058479	2025-04-06 15:41:01.058479	0	Pedro	Pérez	\N	\N
c0caff39-2a36-4b79-b707-b7848822430b	patient_c1_d2_6@example.com	$2a$12$1QYL2X.4v5mxDNQmqN7//eacO.fp7C6jHLNkfhOaa/fSa6q68famS	\N	\N	\N	\N	2025-04-06 15:41:01.281671	2025-04-06 15:41:01.281671	0	Ana	Gómez	\N	\N
a71946fe-375b-42ee-a117-fc26d98e4075	patient_c1_d2_7@example.com	$2a$12$R9jWR5dw6eqNb03lZZV91uMU8uAhBVnBf68cfBv.SupTHTOdFPlGC	\N	\N	\N	\N	2025-04-06 15:41:01.502286	2025-04-06 15:41:01.502286	0	Sofía	Gómez	\N	\N
400078d3-f076-4a08-872b-b57e84dc23d3	patient_c1_d2_8@example.com	$2a$12$vK3OK9rAK2mhlWFffMoJhOe6DrksNwoZdkx/GGKrWrE.XNOtelOhG	\N	\N	\N	\N	2025-04-06 15:41:01.71951	2025-04-06 15:41:01.71951	0	Clara	López	\N	\N
12ecde48-8e99-4a46-b741-dfb817b89736	patient_c1_d2_9@example.com	$2a$12$1FfCFteig2Q96/w6wfKOSemY6PHywqA8H0iDphHisvs02RsyLD.6W	\N	\N	\N	\N	2025-04-06 15:41:01.943738	2025-04-06 15:41:01.943738	0	Ana	García	\N	\N
4f5ea382-ec27-48fb-a0f8-67a35b4c52e7	patient_c1_d2_10@example.com	$2a$12$XDKd7xXxOuPZIuBOjeMn2uwXRrC4AKkdbLBKVPc/m9MOzv1x1ueDe	\N	\N	\N	\N	2025-04-06 15:41:02.164669	2025-04-06 15:41:02.164669	0	Sofía	García	\N	\N
0dd904dc-8b23-4e52-ac34-fc67323254a1	patient_c1_d2_11@example.com	$2a$12$g1IVuZJHB6ZUyO21mp3zE./1mdCI1ncG2ZRUXpdubry832Id.Nkzq	\N	\N	\N	\N	2025-04-06 15:41:02.424032	2025-04-06 15:41:02.424032	0	Juan	Rodríguez	\N	\N
c578d339-ed08-44d4-ab19-35d6782e8432	patient_c1_d2_12@example.com	$2a$12$bcJ42eKNkLs.cqTk6LsGrusb2tK9bQOW/Io8aRua3wczF8cg2rT7a	\N	\N	\N	\N	2025-04-06 15:41:02.642268	2025-04-06 15:41:02.642268	0	Clara	López	\N	\N
2d475dc0-e54c-4773-8c5d-8e535fdb5e9d	patient_c1_d3_1@example.com	$2a$12$ruEHFCAKl6NITP6eDgLLWuxi86vk46XWBH7zXOM9fbN6MYPDCxBkC	\N	\N	\N	\N	2025-04-06 15:41:02.85887	2025-04-06 15:41:02.85887	0	Juan	García	\N	\N
74a08980-843e-49fa-b76c-c9d42697d6ca	patient_c1_d3_2@example.com	$2a$12$kbeiaE.pmrkcunKcjJfsPOwE0X2HM.XlC9COBjkGm6Tkkq4/9in46	\N	\N	\N	\N	2025-04-06 15:41:03.079155	2025-04-06 15:41:03.079155	0	Pedro	López	\N	\N
132ca16c-43f3-4f57-98f5-e387572fb2c8	patient_c1_d3_3@example.com	$2a$12$8MYOMXFC1BONF5JdcM5wA.TmfQZSJuHEhaJsuVUJkwDLa/SNir9LW	\N	\N	\N	\N	2025-04-06 15:41:03.296055	2025-04-06 15:41:03.296055	0	Mateo	Fernández	\N	\N
39b82c4e-6880-41b7-8220-737b93a91279	patient_c1_d3_4@example.com	$2a$12$NHX5n3oPbvBcSEoNIhuHeeFYf1l3M7iXnQ1FWZICvI88SHDTTX9OO	\N	\N	\N	\N	2025-04-06 15:41:03.514263	2025-04-06 15:41:03.514263	0	Valeria	Pérez	\N	\N
6fc69ded-b6de-470f-81d9-3c26dd6eda0d	patient_c1_d3_5@example.com	$2a$12$xBesnQ4SPov66ZO/hLJABuaGQ8yEaW3QL8rhkgdQo7TWKH93wYbxS	\N	\N	\N	\N	2025-04-06 15:41:03.732467	2025-04-06 15:41:03.732467	0	Martín	Sánchez	\N	\N
c0c7979e-adeb-475b-a530-9e3d6eb648f2	patient_c1_d3_6@example.com	$2a$12$taf5rffJlwdSBTg3RJ1hCeCa5z5w1ex9XtxAGXsjY.VlA4eA2sM.e	\N	\N	\N	\N	2025-04-06 15:41:03.951499	2025-04-06 15:41:03.951499	0	Diego	Gómez	\N	\N
65f28018-e0e6-459c-a7bf-df304806c3e2	patient_c1_d3_7@example.com	$2a$12$JyP2i7nmIVYEFrTSIGz7ieFD5BY8RgVuHbKSVchPB8FXPuWB18Gau	\N	\N	\N	\N	2025-04-06 15:41:04.167894	2025-04-06 15:41:04.167894	0	Martín	López	\N	\N
166f05ac-40e7-4d4e-851e-d94fa8ab655b	patient_c1_d3_8@example.com	$2a$12$Cd3cwIFZAsgAJl1CYuxKRuNMOAsPoKC1umjTNNFLoqdkDsBgJ1jym	\N	\N	\N	\N	2025-04-06 15:41:04.449088	2025-04-06 15:41:04.449088	0	Sofía	Sánchez	\N	\N
58950f04-2540-42c7-86c6-ff12e60b5d3d	patient_c1_d3_9@example.com	$2a$12$D2CjwGDuQtrF3z7Dp1pPUuL0QEj9ODkjS4PT0j6f1yNpnrCraOJ7K	\N	\N	\N	\N	2025-04-06 15:41:04.678102	2025-04-06 15:41:04.678102	0	Clara	García	\N	\N
070d4ed1-e184-4097-bb7f-bdf0ce5a725c	patient_c1_d3_10@example.com	$2a$12$ix3ZBwc9Rp5benpX.FGqNOgw360GDTmVBUW8OR7kZbJkeKyE8mxaG	\N	\N	\N	\N	2025-04-06 15:41:04.896941	2025-04-06 15:41:04.896941	0	Clara	Rodríguez	\N	\N
cc384134-54aa-4ebb-83f0-2a7f27712bbd	patient_c1_d3_11@example.com	$2a$12$wA5H5uc.Qolck4dRlLDR7O3oATVyuBwwjV0qu9xMCMfsiLg2hD9Wi	\N	\N	\N	\N	2025-04-06 15:41:05.114991	2025-04-06 15:41:05.114991	0	Pedro	Pérez	\N	\N
c9e2efb2-adc5-42c8-aee6-f993fcab76ff	dr.smith@example.com	$2a$12$oamqN/RAj0UeaF8nBB9Xkui731eFP6sWlypn3uZ.B7KZRNKkapjm2	\N	\N	\N	6afc8d57-14df-46ad-863d-6b2a4eaacf77	2025-04-06 15:41:05.334657	2025-04-06 15:41:05.334657	2	Robert	Smith	\N	\N
11db1a8d-4d1e-4b77-9b80-144dd21db908	secretary.sonrisa@example.com	$2a$12$WmylSl6rSlh68xx7zwCSFOu4e9berwYtvkG.QdgqIKDJQxnCGlqaC	\N	\N	\N	6afc8d57-14df-46ad-863d-6b2a4eaacf77	2025-04-06 15:41:05.557504	2025-04-06 15:41:05.557504	1	Liliana	Hernández	\N	\N
3eb57269-08e2-4181-8fe4-1b1df41b4702	patient_c2_1@example.com	$2a$12$os7htd6W3s92yc97NhphU.rQJ6V1QwGvgddcDUN4i/4KQmoTed6ZO	\N	\N	\N	\N	2025-04-06 15:41:05.773912	2025-04-06 15:41:05.773912	0	Pedro	García	\N	\N
3581285d-531c-414a-97a7-05fc4a3f5faf	patient_c2_2@example.com	$2a$12$vnXhVM7ZIp2bomKk4vZY1.I00jJPTnhy91l7p2VTC9gwXGh4bbBTK	\N	\N	\N	\N	2025-04-06 15:41:05.992058	2025-04-06 15:41:05.992058	0	Valeria	Gómez	\N	\N
d43addb6-94a8-41b7-ac38-d5e743221922	patient_c2_3@example.com	$2a$12$5RgVP0p4UN3sUjbLc5a5/.xjYcCd7eVIsaFQaztBAnqPI82V3abPe	\N	\N	\N	\N	2025-04-06 15:41:06.211753	2025-04-06 15:41:06.211753	0	Mateo	Romero	\N	\N
921da11a-dcfb-4619-a071-a84310778879	patient_c2_4@example.com	$2a$12$6FNfG5kl.bda9ZsGdQO0eelOC50G/gupFHRJXcdbFtnG7UAYEskAq	\N	\N	\N	\N	2025-04-06 15:41:06.428599	2025-04-06 15:41:06.428599	0	Sofía	Gómez	\N	\N
3322d6ab-99ac-450b-b0ac-cbccdaf24130	patient_c2_5@example.com	$2a$12$Xw5xVQhNUhe23TJpBag6neOj1x19riaBcjR3YyBkPPPAq39HjzVrq	\N	\N	\N	\N	2025-04-06 15:41:06.643723	2025-04-06 15:41:06.643723	0	Juan	Rodríguez	\N	\N
d0a2f0fa-ec48-4989-a55e-9bc931b205b2	patient_c2_6@example.com	$2a$12$fN4SwqXCEErPlWr/JG3Vq.DjFJ/ea3niUImVVDwkUHqXF8IcAwwzO	\N	\N	\N	\N	2025-04-06 15:41:06.859085	2025-04-06 15:41:06.859085	0	Pedro	Romero	\N	\N
2125595c-9712-4701-80d8-9b26b8dfb9c8	patient_c2_7@example.com	$2a$12$W/fHJvirGdshEjl6EgBSDeckZ.H1j1BTQDIyUzuP4qYzfEAU4ZVmG	\N	\N	\N	\N	2025-04-06 15:41:07.074463	2025-04-06 15:41:07.074463	0	Ana	Fernández	\N	\N
90d155ce-a829-42f4-99ed-23a9aebaf579	patient_c2_8@example.com	$2a$12$nQtDC8VLSmMTqiuufYY3BuYPzpwBYkGVoVqzZm9HtWrAgitXytuyS	\N	\N	\N	\N	2025-04-06 15:41:07.29458	2025-04-06 15:41:07.29458	0	Clara	Romero	\N	\N
85bb1bae-e3dc-4766-9b08-c6aaeca14e28	patient_c2_9@example.com	$2a$12$.YSSXA0kpbo4xbcJAU9xxuKlX/ygLtxJXvUVuN/zJ.8fKQ8Mh8qYe	\N	\N	\N	\N	2025-04-06 15:41:07.516911	2025-04-06 15:41:07.516911	0	Clara	Martínez	\N	\N
38e4f3aa-0027-4497-9110-e48d748e22e4	patient_c2_10@example.com	$2a$12$iPL8jzOIsfqDXtgMe6NpROds3IupfUPlZ.TNIg.sBaLKGZyY7jwVi	\N	\N	\N	\N	2025-04-06 15:41:07.761943	2025-04-06 15:41:07.761943	0	Sofía	Gómez	\N	\N
42d1194a-63e3-425c-a44d-e327e3290f5a	dr.martinez@example.com	$2a$12$wrrTSsjHCiVb5ZV9hbRqau7m/f4Bo7WrvvORnqY3UlMy77tJ1ULK2	\N	\N	\N	f2d9eda5-c41d-4429-8332-7d0d8262c716	2025-04-06 15:41:07.99542	2025-04-06 15:41:07.99542	2	Laura	Martínez	\N	\N
c76fdee1-4316-45d6-b77b-b9a55ba435b3	patient_c3_1@example.com	$2a$12$osnayj32XUMMIf29rAZtguFIXvtSOi7pykXhi.tKe08C5o9LTIafm	\N	\N	\N	\N	2025-04-06 15:41:08.217129	2025-04-06 15:41:08.217129	0	Sofía	Pérez	\N	\N
14526003-3d91-4f5a-a444-8e14c09ec3ed	patient_c3_2@example.com	$2a$12$bCQ4RTkUoCBbiSf5O9zHcuZ5B84QAAuGrcWy7jBEqjkuP5Hd4DTHO	\N	\N	\N	\N	2025-04-06 15:41:08.440471	2025-04-06 15:41:08.440471	0	Mateo	Fernández	\N	\N
2a8825bc-57bf-4d25-a053-38f300fb1cec	patient_c3_3@example.com	$2a$12$7yWUeyE5ZTWJoy2Eo7pgGeiTnkzhaigHRioQ2NJ/EmgAH39Rhmhiu	\N	\N	\N	\N	2025-04-06 15:41:08.661739	2025-04-06 15:41:08.661739	0	Valeria	Gómez	\N	\N
1bb53eba-495b-44c2-89c6-d0467eb7ba0b	patient_c3_4@example.com	$2a$12$SBZ6.A5IFOc21nbTiBQ8z.PbaYtzXB6FJ1oQWUwwa6jxMt0qWmj8q	\N	\N	\N	\N	2025-04-06 15:41:08.886577	2025-04-06 15:41:08.886577	0	Mateo	Rodríguez	\N	\N
e46dd6e9-4483-4948-bb1c-5688b18c6e86	patient_c3_5@example.com	$2a$12$oKYPEWOB9sWdZ4qUtnwv.uFT/.Fx5SM5Lz2bJYoLvR.B7yMwd7PAS	\N	\N	\N	\N	2025-04-06 15:41:09.108497	2025-04-06 15:41:09.108497	0	Pedro	Díaz	\N	\N
bccac476-287e-4da2-a23e-7059a825bd57	patient_c3_6@example.com	$2a$12$DVUwID5b2fqUMWTw9UjxneGZOEs1IXxS4PlXAi4BpMhZeAcKfp6z6	\N	\N	\N	\N	2025-04-06 15:41:09.32699	2025-04-06 15:41:09.32699	0	Pedro	Díaz	\N	\N
d5c07a3e-efdd-45d3-9d79-611ead72ad31	patient_c3_7@example.com	$2a$12$Gc9djb7KV2jhCcOtY4.Pn.CJ7ZFZUvOKFq.L/bPyYBfxCnD3jc5Fy	\N	\N	\N	\N	2025-04-06 15:41:09.544008	2025-04-06 15:41:09.544008	0	Juan	Romero	\N	\N
4f347110-0858-4e1f-a7fa-6f8f93aa150a	patient_c3_8@example.com	$2a$12$eK2.2lv6V9WeXE5jg6pntOLLhqEk22Wm0EI4QOzYxHjtKZkR7NaOW	\N	\N	\N	\N	2025-04-06 15:41:09.759298	2025-04-06 15:41:09.759298	0	Juan	Martínez	\N	\N
e2d5ec52-25d3-44b2-afcc-132135dbe536	patient_c3_9@example.com	$2a$12$qihJuiqFWex4V2WoIdan3ezcxaSgj95YHAXDKFfFhc6SBO9etEIZa	\N	\N	\N	\N	2025-04-06 15:41:09.978007	2025-04-06 15:41:09.978007	0	Pedro	Fernández	\N	\N
550d50d5-d8dd-437b-a3bb-2e11c33d406a	patient_c3_10@example.com	$2a$12$wsk3XquZo3ptdS7J8yC8Te32Y3H8GIIxVuDAP3wacjUd5tcO4fQRG	\N	\N	\N	\N	2025-04-06 15:41:10.202589	2025-04-06 15:41:10.202589	0	Diego	Romero	\N	\N
56968d38-f8cf-4561-8397-9e796e3cf912	patient_c3_11@example.com	$2a$12$48FMdQT29pZ4u8ZHeZ5dl.66tT0rkOoZU0fjoXQK.KVy0dUzlnSVS	\N	\N	\N	\N	2025-04-06 15:41:10.421883	2025-04-06 15:41:10.421883	0	Lucía	Rodríguez	\N	\N
fbe0fd7b-03e7-4beb-9f0b-b9026da62c34	patient_c3_12@example.com	$2a$12$6/eUtssuJZIhhm4loimc9.1ndTjYWe9vcuds3wZ0zmHKnxcKoTyfK	\N	\N	\N	\N	2025-04-06 15:41:10.643404	2025-04-06 15:41:10.643404	0	Valeria	Fernández	\N	\N
1c083109-115b-41e3-8cfc-c00c79d4cdb1	patient_c3_13@example.com	$2a$12$zeEArHNK87cumDb3hgrVue7rClXaKrMRQ1WH09ArvO7h/Z/d45Ngm	\N	\N	\N	\N	2025-04-06 15:41:10.862882	2025-04-06 15:41:10.862882	0	Ana	Martínez	\N	\N
2dfb6ace-0e1c-4749-90e0-0c811eb87472	patient_c3_14@example.com	$2a$12$0dnMQCYFf3pxm43YlpD4XezILMHyf/TUp8kJ9mrmHZY4zyzNfa0Ui	\N	\N	\N	\N	2025-04-06 15:41:11.083377	2025-04-06 15:41:11.083377	0	Diego	Díaz	\N	\N
4b8a8259-6da5-4714-9301-81a92332a9d8	docsync.clinics@gmail.com	$2a$12$HILJ9zPI9RuWR7p7qOAlZe0tZQ07l7h5WZnhyWf8MPCHwGvqFqWMu	\N	\N	\N	\N	2025-04-06 16:55:28.458109	2025-04-06 16:55:28.458109	0	DocSync	Clinics	google_oauth2	117548874622481920803
d5522640-1d44-45f9-b095-f14daa273991	maccari78@gmail.com	$2a$12$RudjUCPpEnWd9Pvqm48IhONGqpBlM7Kj6gLMRk9xSG.ZAXtmOQpOi	\N	\N	\N	\N	2025-04-06 16:55:56.450693	2025-04-06 16:55:56.450693	0	Danilo	Maccari	google_oauth2	105929080428349816693
\.


--
-- Name: payments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.payments_id_seq', 24, true);


--
-- Name: active_storage_attachments active_storage_attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_attachments
    ADD CONSTRAINT active_storage_attachments_pkey PRIMARY KEY (id);


--
-- Name: active_storage_attachments active_storage_attachments_record_type_record_id_name_blob__key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_attachments
    ADD CONSTRAINT active_storage_attachments_record_type_record_id_name_blob__key UNIQUE (record_type, record_id, name, blob_id);


--
-- Name: active_storage_blobs active_storage_blobs_key_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_blobs
    ADD CONSTRAINT active_storage_blobs_key_key UNIQUE (key);


--
-- Name: active_storage_blobs active_storage_blobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_blobs
    ADD CONSTRAINT active_storage_blobs_pkey PRIMARY KEY (id);


--
-- Name: active_storage_variant_records active_storage_variant_records_blob_id_variation_digest_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_variant_records
    ADD CONSTRAINT active_storage_variant_records_blob_id_variation_digest_key UNIQUE (blob_id, variation_digest);


--
-- Name: active_storage_variant_records active_storage_variant_records_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_variant_records
    ADD CONSTRAINT active_storage_variant_records_pkey PRIMARY KEY (id);


--
-- Name: appointments appointments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT appointments_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: clinics clinics_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clinics
    ADD CONSTRAINT clinics_pkey PRIMARY KEY (id);


--
-- Name: patients patients_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.patients
    ADD CONSTRAINT patients_pkey PRIMARY KEY (id);


--
-- Name: payments payments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (id);


--
-- Name: professionals professionals_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.professionals
    ADD CONSTRAINT professionals_pkey PRIMARY KEY (id);


--
-- Name: professionals_secretaries professionals_secretaries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.professionals_secretaries
    ADD CONSTRAINT professionals_secretaries_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_active_storage_attachments_uniqueness; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_active_storage_attachments_uniqueness ON public.active_storage_attachments USING btree (record_type, record_id, name, blob_id);


--
-- Name: index_active_storage_variant_records_uniqueness; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_active_storage_variant_records_uniqueness ON public.active_storage_variant_records USING btree (blob_id, variation_digest);


--
-- Name: index_appointments_on_clinic_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_appointments_on_clinic_id ON public.appointments USING btree (clinic_id);


--
-- Name: index_appointments_on_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_appointments_on_deleted_at ON public.appointments USING btree (deleted_at);


--
-- Name: index_appointments_on_patient_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_appointments_on_patient_id ON public.appointments USING btree (patient_id);


--
-- Name: index_appointments_on_professional_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_appointments_on_professional_id ON public.appointments USING btree (professional_id);


--
-- Name: index_patients_on_professional_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_patients_on_professional_id ON public.patients USING btree (professional_id);


--
-- Name: index_payments_on_appointment_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_payments_on_appointment_id ON public.payments USING btree (appointment_id);


--
-- Name: index_professionals_on_clinic_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_professionals_on_clinic_id ON public.professionals USING btree (clinic_id);


--
-- Name: index_professionals_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_professionals_on_user_id ON public.professionals USING btree (user_id);


--
-- Name: index_professionals_secretaries_on_professional_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_professionals_secretaries_on_professional_id ON public.professionals_secretaries USING btree (professional_id);


--
-- Name: index_professionals_secretaries_on_secretary_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_professionals_secretaries_on_secretary_id ON public.professionals_secretaries USING btree (secretary_id);


--
-- Name: index_users_on_clinic_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_clinic_id ON public.users USING btree (clinic_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: index_users_on_provider_and_uid; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_provider_and_uid ON public.users USING btree (provider, uid);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON public.users USING btree (reset_password_token);


--
-- Name: active_storage_attachments fk_active_storage_attachments_blob_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_attachments
    ADD CONSTRAINT fk_active_storage_attachments_blob_id FOREIGN KEY (blob_id) REFERENCES public.active_storage_blobs(id);


--
-- Name: active_storage_variant_records fk_active_storage_variant_records_blob_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_variant_records
    ADD CONSTRAINT fk_active_storage_variant_records_blob_id FOREIGN KEY (blob_id) REFERENCES public.active_storage_blobs(id);


--
-- Name: payments fk_rails_30cd1cf5da; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT fk_rails_30cd1cf5da FOREIGN KEY (appointment_id) REFERENCES public.appointments(id);


--
-- Name: professionals_secretaries fk_rails_7e34decc82; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.professionals_secretaries
    ADD CONSTRAINT fk_rails_7e34decc82 FOREIGN KEY (secretary_id) REFERENCES public.users(id);


--
-- Name: professionals fk_rails_84604d2557; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.professionals
    ADD CONSTRAINT fk_rails_84604d2557 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: appointments fk_rails_c63da04ab4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT fk_rails_c63da04ab4 FOREIGN KEY (patient_id) REFERENCES public.patients(id);


--
-- Name: patients fk_rails_d58a968e15; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.patients
    ADD CONSTRAINT fk_rails_d58a968e15 FOREIGN KEY (professional_id) REFERENCES public.users(id);


--
-- Name: professionals_secretaries fk_rails_d6d7c0699a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.professionals_secretaries
    ADD CONSTRAINT fk_rails_d6d7c0699a FOREIGN KEY (professional_id) REFERENCES public.professionals(id);


--
-- Name: professionals fk_rails_def8f27329; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.professionals
    ADD CONSTRAINT fk_rails_def8f27329 FOREIGN KEY (clinic_id) REFERENCES public.clinics(id);


--
-- Name: appointments fk_rails_e048c6d191; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT fk_rails_e048c6d191 FOREIGN KEY (clinic_id) REFERENCES public.clinics(id);


--
-- Name: users fk_rails_e1521f1719; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT fk_rails_e1521f1719 FOREIGN KEY (clinic_id) REFERENCES public.clinics(id);


--
-- Name: appointments fk_rails_e6009ecf68; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT fk_rails_e6009ecf68 FOREIGN KEY (professional_id) REFERENCES public.professionals(id);


--
-- PostgreSQL database dump complete
--

