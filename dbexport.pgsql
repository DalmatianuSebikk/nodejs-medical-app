--
-- PostgreSQL database dump
--

-- Dumped from database version 13.3
-- Dumped by pg_dump version 13.3

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
-- Name: tipuri_analize; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.tipuri_analize AS ENUM (
    'HEMATOLOGIE',
    'BIOCHIMIE',
    'HORMONI',
    'IMUNOLOGIE',
    'MARKERI TUMORALI',
    'MARKERI INFECTIOSI',
    'ANALIZE DE URINA',
    'MATERII FECALE',
    'BACTERIOLOGICE',
    'SECRETII VAGINALE/URETRALE'
);


ALTER TYPE public.tipuri_analize OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: analize; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.analize (
    id_analize integer NOT NULL,
    nume character varying(300) NOT NULL,
    timpexecutie character varying(100) NOT NULL,
    tipanaliza public.tipuri_analize DEFAULT 'HEMATOLOGIE'::public.tipuri_analize NOT NULL,
    pret integer NOT NULL
);


ALTER TABLE public.analize OWNER TO postgres;

--
-- Name: analize_id_analize_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.analize_id_analize_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.analize_id_analize_seq OWNER TO postgres;

--
-- Name: analize_id_analize_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.analize_id_analize_seq OWNED BY public.analize.id_analize;


--
-- Name: consultatii; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.consultatii (
    id_consultatie integer NOT NULL,
    nume character varying(300) NOT NULL,
    pret integer NOT NULL
);


ALTER TABLE public.consultatii OWNER TO postgres;

--
-- Name: consultatii_id_consultatie_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.consultatii_id_consultatie_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.consultatii_id_consultatie_seq OWNER TO postgres;

--
-- Name: consultatii_id_consultatie_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.consultatii_id_consultatie_seq OWNED BY public.consultatii.id_consultatie;


--
-- Name: ecografii; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ecografii (
    id_ecografie integer NOT NULL,
    nume character varying(300) NOT NULL,
    pret integer NOT NULL
);


ALTER TABLE public.ecografii OWNER TO postgres;

--
-- Name: ecografii_id_ecografie_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ecografii_id_ecografie_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ecografii_id_ecografie_seq OWNER TO postgres;

--
-- Name: ecografii_id_ecografie_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ecografii_id_ecografie_seq OWNED BY public.ecografii.id_ecografie;


--
-- Name: analize id_analize; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.analize ALTER COLUMN id_analize SET DEFAULT nextval('public.analize_id_analize_seq'::regclass);


--
-- Name: consultatii id_consultatie; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.consultatii ALTER COLUMN id_consultatie SET DEFAULT nextval('public.consultatii_id_consultatie_seq'::regclass);


--
-- Name: ecografii id_ecografie; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ecografii ALTER COLUMN id_ecografie SET DEFAULT nextval('public.ecografii_id_ecografie_seq'::regclass);


--
-- Data for Name: analize; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.analize (id_analize, nume, timpexecutie, tipanaliza, pret) FROM stdin;
1	APTT	2-3 Zile	HEMATOLOGIE	18
2	Crioglobuline	2-3 Zile	HEMATOLOGIE	12
3	Determinare de grup sanguin ABO	2-3 Zile	HEMATOLOGIE	15
4	Determinare de grup sanguin Rh	2-3 Zile	HEMATOLOGIE	15
5	Examen citologic al frotiului sanguin periferic	2-3 Zile	HEMATOLOGIE	20
6	Fibrinogen	2-3 Zile	HEMATOLOGIE	18
7	Hemoleucograma completă	2-3 Zile	HEMATOLOGIE	20
8	Reticulocite	2-3 Zile	HEMATOLOGIE	20
9	Timp de coagulare	2-3 Zile	HEMATOLOGIE	8
10	Timp de sângerare	2-3 Zile	HEMATOLOGIE	8
11	V.S.H.	2-3 Zile	HEMATOLOGIE	8
12	Timp Quick	2-3 Zile	HEMATOLOGIE	16
13	Acid uric seric	2-3 Zile	BIOCHIMIE	11
14	Amilazemie	2-3 Zile	BIOCHIMIE	14
15	Bilirubina totala	2-3 Zile	BIOCHIMIE	11
16	Bilirubina directa	2-3 Zile	BIOCHIMIE	11
17	Calcemie serică totală	2-3 Zile	BIOCHIMIE	10
18	Colesterol seric total	2-3 Zile	BIOCHIMIE	11
19	Complement C3	2-3 Zile	BIOCHIMIE	35
20	Complement C4	2-3 Zile	BIOCHIMIE	35
21	Creatin kinaza (CK)	2-3 Zile	BIOCHIMIE	17
22	Creatinina serică	2-3 Zile	BIOCHIMIE	11
23	Electroforeza proteinelor serice	2-3 Zile	BIOCHIMIE	35
24	Fosfataza alcalină	2-3 Zile	BIOCHIMIE	13
25	Fosfor	2-3 Zile	BIOCHIMIE	13
26	Gama GT	2-3 Zile	BIOCHIMIE	11
27	Glicemie	2-3 Zile	BIOCHIMIE	10
28	HDL colesterol	2-3 Zile	BIOCHIMIE	15
29	Hemoglobina glicozilata	2-3 Zile	BIOCHIMIE	35
30	Ionograma (Na,K,Ca,Cl,pH)	2-3 Zile	BIOCHIMIE	30
31	LDH (Lactat dehidrogenaza)	2-3 Zile	BIOCHIMIE	13
32	LDL colesterol	2-3 Zile	BIOCHIMIE	10
33	Lipide totale serice	2-3 Zile	BIOCHIMIE	10
34	Magneziemie	2-3 Zile	BIOCHIMIE	10
35	Proteine totale serice	2-3 Zile	BIOCHIMIE	11
36	Sideremie (Fe)	2-3 Zile	BIOCHIMIE	13
37	TGO	2-3 Zile	BIOCHIMIE	11
38	TGP	2-3 Zile	BIOCHIMIE	11
39	Trigliceride serice	2-3 Zile	BIOCHIMIE	11
40	Ureea serică	2-3 Zile	BIOCHIMIE	11
41	Feritina	2-3 Zile	BIOCHIMIE	40
42	Albumina serica	2-3 Zile	BIOCHIMIE	10
43	Vitamina B12	2-3 Zile	BIOCHIMIE	38
44	Ac anti TG (Chemiluminiscenta)	2-3 Zile	HORMONI	44
45	Ac Anti TPO (Chemiluminiscenta)	2-3 Zile	HORMONI	45
46	Calcitonina	2-3 Zile	HORMONI	65
47	Cortizol seric	2-3 Zile	HORMONI	40
48	Cortizol urinar	2-3 Zile	HORMONI	40
49	Estradiol II (ELFA)	2-3 Zile	HORMONI	42
50	FSH (ELFA)	2-3 Zile	HORMONI	42
51	FT4 (Chemiluminiscenta)	2-3 Zile	HORMONI	40
52	LH (ELFA)	2-3 Zile	HORMONI	42
53	Progesteron (Chemiluminiscenta)	2-3 Zile	HORMONI	42
54	Prolactina (ELFA)	2-3 Zile	HORMONI	42
55	PTH (Chemiluminiscenta)	2-3 Zile	HORMONI	45
56	Testosteron (ELFA)	2-3 Zile	HORMONI	42
57	Total Beta hCG (Chemiluminiscenta)	2-3 Zile	HORMONI	45
58	TSH (Chemiluminiscenta)	2-3 Zile	HORMONI	40
59	Free T3	2-3 Zile	HORMONI	40
60	Free T4	2-3 Zile	HORMONI	40
61	Alergotest cantitativ mixt	2-3 Zile	IMUNOLOGIE	220
62	Alergotest cantitativ pediatric	2-3 Zile	IMUNOLOGIE	220
63	ASLO cantitativ	2-3 Zile	IMUNOLOGIE	25
64	ASLO semicantitativ	2-3 Zile	IMUNOLOGIE	10
65	Confirmare TPHA	2-3 Zile	IMUNOLOGIE	20
66	Factor reumatoid cantitativ	2-3 Zile	IMUNOLOGIE	25
67	Factor reumatoid semicantitativ	2-3 Zile	IMUNOLOGIE	10
68	Ig E serica	2-3 Zile	IMUNOLOGIE	35
69	Ig M serica	2-3 Zile	IMUNOLOGIE	35
70	Ig A serică	2-3 Zile	IMUNOLOGIE	35
71	Ig G serică	2-3 Zile	IMUNOLOGIE	35
72	Proteina C reactivă cantitativ	2-3 Zile	IMUNOLOGIE	25
73	Proteina C reactivă semicantitativ	2-3 Zile	IMUNOLOGIE	10
74	VDRL /RPR	2-3 Zile	IMUNOLOGIE	15
75	AFP-Alfafetoproteina- (ELFA)	2-3 Zile	MARKERI TUMORALI	45
76	CA 15-3 (ELFA)	2-3 Zile	MARKERI TUMORALI	50
77	CA 19-9(ELFA)	2-3 Zile	MARKERI TUMORALI	50
78	CA 125(Chemiluminiscenta)	2-3 Zile	MARKERI TUMORALI	50
79	CEA	2-3 Zile	MARKERI TUMORALI	45
80	Free PSA (Chemiluminiscenta)	2-3 Zile	MARKERI TUMORALI	45
81	PSA (Chemiluminiscenta)	2-3 Zile	MARKERI TUMORALI	45
82	Ac HBs (Chemiluminiscenta)	2-3 Zile	MARKERI INFECTIOSI	45
83	Ac HCV (Chemiluminiscenta)	2-3 Zile	MARKERI INFECTIOSI	55
84	Ac HCV (Test rapid)	2-3 Zile	MARKERI INFECTIOSI	30
85	Anti HIV (Test Rapid)	2-3 Zile	MARKERI INFECTIOSI	30
86	Anticorpi HIV (Chemiluminiscenta)	2-3 Zile	MARKERI INFECTIOSI	45
87	Antigen HBs (Test Rapid)	2-3 Zile	MARKERI INFECTIOSI	30
88	Antigen HBs (Chemiluminiscenta)	2-3 Zile	MARKERI INFECTIOSI	40
89	Ac Helicobacter Pylori-(Chemiluminiscenta)	2-3 Zile	MARKERI INFECTIOSI	40
90	Anti Helicobacter Pylori IgG (Test rapid)	2-3 Zile	MARKERI INFECTIOSI	30
91	Ac anti Sars-Cov-2 IgM/IgG	2-3 Zile	MARKERI INFECTIOSI	100
92	Ac anti SARS COV 2 Ig M-cantitativ(ELFA)	2-3 Zile	MARKERI INFECTIOSI	95
93	Ac anti Sars-Cov-2 IgG anti nucleocapsida -cantitativ	2-3 Zile	MARKERI INFECTIOSI	90
94	Antigen SARS-COV-2 - Test Rapid	2-3 Zile	MARKERI INFECTIOSI	100
95	Ac anti Sars-Cov-2 IgG anti spike (S1/S2) -cantitativ	2-3 Zile	MARKERI INFECTIOSI	150
96	Amilazurie	2-3 Zile	ANALIZE DE URINA	13
97	Dozare calciu in urina	2-3 Zile	ANALIZE DE URINA	12
98	Dozare creatinina urinara	2-3 Zile	ANALIZE DE URINA	12
99	Dozare glucoză urinară	2-3 Zile	ANALIZE DE URINA	12
100	Dozare proteine urinare	2-3 Zile	ANALIZE DE URINA	12
101	Dozare uree urinară	2-3 Zile	ANALIZE DE URINA	12
102	Examen complet de urină (sumar + sediment)	2-3 Zile	ANALIZE DE URINA	20
103	Microalbumina	2-3 Zile	ANALIZE DE URINA	20
104	Urocultura	2-3 Zile	ANALIZE DE URINA	40
105	Coprocultură	2-3 Zile	MATERII FECALE	40
106	Depistare Giardia scaun	2-3 Zile	MATERII FECALE	30
107	Depistare rotavirus	2-3 Zile	MATERII FECALE	30
108	Depistare Helicobacter pylori scaun	2-3 Zile	MATERII FECALE	30
109	Examen coproparazitologic	2-3 Zile	MATERII FECALE	15
110	Reacţia Adler (Hemoragii oculte)	2-3 Zile	MATERII FECALE	20
111	Coprocultură (cultura fungi+antifungigrama)	2-3 Zile	MATERII FECALE	36
112	Exsudat faringian (cultura + antibiogramă)	2-3 Zile	BACTERIOLOGICE	36
113	Exsudat faringian (cultură fungi + antifungigrama)	2-3 Zile	BACTERIOLOGICE	36
114	Exsudat nazal (cultura + antibiograma)	2-3 Zile	BACTERIOLOGICE	36
115	Secretie otica (cultura + antibiograma)	2-3 Zile	BACTERIOLOGICE	50
116	Exsudat nazal (cultura fungi + antifungigrama)	2-3 Zile	BACTERIOLOGICE	50
117	Secretie conjunctivala (cultura bacterii aerobe + antibiograma)	2-3 Zile	BACTERIOLOGICE	50
118	Secretie conjunctivala (cultura fungi + antifungigrama)	2-3 Zile	BACTERIOLOGICE	35
119	Secretie otica (cultura bacterii aerobe + antibiograma)	2-3 Zile	BACTERIOLOGICE	50
120	Secretie otica (cultura fungi+antifungigrama)	2-3 Zile	BACTERIOLOGICE	35
121	Cultura bacterii aerobe+antibiograma	2-3 Zile	SECRETII VAGINALE/URETRALE	50
122	Cultură Fungi+antifungigrama	2-3 Zile	SECRETII VAGINALE/URETRALE	35
123	Examen microscopic colorat	2-3 Zile	SECRETII VAGINALE/URETRALE	18
124	Examen microscopic nativ	2-3 Zile	SECRETII VAGINALE/URETRALE	50
125	Spermograma	2-3 Zile	SECRETII VAGINALE/URETRALE	100
126	Secretie vaginala (cultura bacterii aerobe + antibiograma)	2-3 Zile	SECRETII VAGINALE/URETRALE	50
127	Secretie vaginala (cultura fungi + antifungigrama)	2-3 Zile	SECRETII VAGINALE/URETRALE	35
128	Secretie uretrala (cultura fungi + antifungigrama)	2-3 Zile	SECRETII VAGINALE/URETRALE	35
129	Secretii purulente (cultura bacterii aerobe+antibiograma)	2-3 Zile	SECRETII VAGINALE/URETRALE	40
130	Secretii purulente (cultura fungi+antifungigrama)	2-3 Zile	SECRETII VAGINALE/URETRALE	35
131	Spermocultura (cultura bacterii aerobe+antibiograma)	2-3 Zile	SECRETII VAGINALE/URETRALE	50
\.


--
-- Data for Name: consultatii; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.consultatii (id_consultatie, nume, pret) FROM stdin;
1	Consultatie neurologie	120
2	Consultatie psihologie adulti	120
3	Consultatie dermatologie	120
4	Consultatie gastroenterologie	120
5	Consultatie reumatologie	120
6	Consultatie medicina interna cu EKG inclus	140
7	Consultatie medicina generala	120
8	Consultatie psihiatrie	120
9	Consultatie endocrinologie	120
10	Consultatie ORL	150
11	Consultatie cardiologie(include EKG)	150
12	Consultatie ginecologie	150
13	Insertie sterilet	150
14	Extractie sterilet	150
15	Morfologie fetala	500
16	Holter EKG	150
17	Holter TA	150
18	Fibroscopie ORL	150
\.


--
-- Data for Name: ecografii; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ecografii (id_ecografie, nume, pret) FROM stdin;
1	Ecografie cardiaca Doppler color IIID	150
2	Ecografie vasculara Doppler color carotida bilateral	150
3	Ecografie vasculara Doppler color	100
4	Ecografie abdomen si pelvis Doppler color	130
5	Ecografie abdomen superior	100
6	Ecografie san bilateral	150
7	Ecografie tiroida	90
8	Ecografie musculoscheletala	100
9	Ecografie parti moi	90
10	Ecografie articulara articulatii mari (sold, genunchi, umar,cot)	100
11	Ecografie articulara articulatii mici (pumn, glezna) bilateral	100
12	Ecografie sarcina trim. I: pliu nucal +Doppler	150
13	Ecografie sarcina trim. II si III 4D	150
14	Ecografie endovaginala	120
\.


--
-- Name: analize_id_analize_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.analize_id_analize_seq', 131, true);


--
-- Name: consultatii_id_consultatie_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.consultatii_id_consultatie_seq', 18, true);


--
-- Name: ecografii_id_ecografie_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ecografii_id_ecografie_seq', 14, true);


--
-- Name: analize analize_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.analize
    ADD CONSTRAINT analize_pkey PRIMARY KEY (id_analize);


--
-- Name: consultatii consultatii_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.consultatii
    ADD CONSTRAINT consultatii_pkey PRIMARY KEY (id_consultatie);


--
-- Name: ecografii ecografii_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ecografii
    ADD CONSTRAINT ecografii_pkey PRIMARY KEY (id_ecografie);


--
-- Name: TABLE analize; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.analize TO sebi;


--
-- Name: TABLE consultatii; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.consultatii TO sebi;


--
-- Name: TABLE ecografii; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.ecografii TO sebi;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: -; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres GRANT ALL ON TABLES  TO sebi;


--
-- PostgreSQL database dump complete
--

