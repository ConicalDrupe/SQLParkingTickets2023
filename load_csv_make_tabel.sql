-- Table: public.DOTraw

DROP TABLE IF EXISTS public."DOTraw";

CREATE TABLE IF NOT EXISTS public."DOTraw"
(
    "Ticket Number" bigint NOT NULL,
	"Date" date,
	"Time" time without time zone,
    "Date/Time" time without time zone,
    "Parking District" character varying(25) COLLATE pg_catalog."default",
    "Ticket Location" character varying(255) COLLATE pg_catalog."default",
    "Meter" character varying(255) COLLATE pg_catalog."default",
    "Violation Code" integer,
    "Violation Description" character varying(255) COLLATE pg_catalog."default",
    "Plate Year" integer,
    "Vehicle Make" character varying(25) COLLATE pg_catalog."default",
    "Plate Month" integer,
    "Vehicle Type" character varying(25) COLLATE pg_catalog."default",
    "Vehicle Color" character varying(25) COLLATE pg_catalog."default",
    "Remarks" character varying(255) COLLATE pg_catalog."default",
    CONSTRAINT "DOTraw_pkey" PRIMARY KEY ("Ticket Number")
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."DOTraw"
    OWNER to postgres;

COPY "DOTraw"
FROM 'C:\Users\Christopher\Documents\DataProjects2023\Parking Tickets 2023\DOT_Parking_Tickets_military.csv'
NULL 'NULL'
csv HEADER
