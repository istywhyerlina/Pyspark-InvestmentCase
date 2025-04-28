\c warehouse;

DROP TABLE if exists dim_date;

CREATE TABLE dim_date
(
  date_id              INT NOT NULL,
  date_actual              DATE NOT NULL,
  epoch                    BIGINT NOT NULL,
  day_suffix               VARCHAR(4) NOT NULL,
  day_name                 VARCHAR(9) NOT NULL,
  day_of_week              INT NOT NULL,
  day_of_month             INT NOT NULL,
  day_of_quarter           INT NOT NULL,
  day_of_year              INT NOT NULL,
  week_of_month            INT NOT NULL,
  week_of_year             INT NOT NULL,
  week_of_year_iso         CHAR(10) NOT NULL,
  month_actual             INT NOT NULL,
  month_name               VARCHAR(9) NOT NULL,
  month_name_abbreviated   CHAR(3) NOT NULL,
  quarter_actual           INT NOT NULL,
  quarter_name             VARCHAR(9) NOT NULL,
  year_actual              INT NOT NULL,
  first_day_of_week        DATE NOT NULL,
  last_day_of_week         DATE NOT NULL,
  first_day_of_month       DATE NOT NULL,
  last_day_of_month        DATE NOT NULL,
  first_day_of_quarter     DATE NOT NULL,
  last_day_of_quarter      DATE NOT NULL,
  first_day_of_year        DATE NOT NULL,
  last_day_of_year         DATE NOT NULL,
  mmyyyy                   CHAR(6) NOT NULL,
  mmddyyyy                 CHAR(10) NOT NULL,
  weekend_indr             BOOLEAN NOT NULL
);

ALTER TABLE public.dim_date ADD CONSTRAINT dim_date_date_id_pk PRIMARY KEY (date_id);

CREATE INDEX dim_date_date_actual_idx
  ON dim_date(date_actual);

COMMIT;

INSERT INTO dim_date
SELECT TO_CHAR(datum, 'yyyymmdd')::INT AS date_id,
       datum AS date_actual,
       EXTRACT(EPOCH FROM datum) AS epoch,
       TO_CHAR(datum, 'fmDDth') AS day_suffix,
       TO_CHAR(datum, 'TMDay') AS day_name,
       EXTRACT(ISODOW FROM datum) AS day_of_week,
       EXTRACT(DAY FROM datum) AS day_of_month,
       datum - DATE_TRUNC('quarter', datum)::DATE + 1 AS day_of_quarter,
       EXTRACT(DOY FROM datum) AS day_of_year,
       TO_CHAR(datum, 'W')::INT AS week_of_month,
       EXTRACT(WEEK FROM datum) AS week_of_year,
       EXTRACT(ISOYEAR FROM datum) || TO_CHAR(datum, '"-W"IW-') || EXTRACT(ISODOW FROM datum) AS week_of_year_iso,
       EXTRACT(MONTH FROM datum) AS month_actual,
       TO_CHAR(datum, 'TMMonth') AS month_name,
       TO_CHAR(datum, 'Mon') AS month_name_abbreviated,
       EXTRACT(QUARTER FROM datum) AS quarter_actual,
       CASE
           WHEN EXTRACT(QUARTER FROM datum) = 1 THEN 'First'
           WHEN EXTRACT(QUARTER FROM datum) = 2 THEN 'Second'
           WHEN EXTRACT(QUARTER FROM datum) = 3 THEN 'Third'
           WHEN EXTRACT(QUARTER FROM datum) = 4 THEN 'Fourth'
           END AS quarter_name,
       EXTRACT(YEAR FROM datum) AS year_actual,
       datum + (1 - EXTRACT(ISODOW FROM datum))::INT AS first_day_of_week,
       datum + (7 - EXTRACT(ISODOW FROM datum))::INT AS last_day_of_week,
       datum + (1 - EXTRACT(DAY FROM datum))::INT AS first_day_of_month,
       (DATE_TRUNC('MONTH', datum) + INTERVAL '1 MONTH - 1 day')::DATE AS last_day_of_month,
       DATE_TRUNC('quarter', datum)::DATE AS first_day_of_quarter,
       (DATE_TRUNC('quarter', datum) + INTERVAL '3 MONTH - 1 day')::DATE AS last_day_of_quarter,
       TO_DATE(EXTRACT(YEAR FROM datum) || '-01-01', 'YYYY-MM-DD') AS first_day_of_year,
       TO_DATE(EXTRACT(YEAR FROM datum) || '-12-31', 'YYYY-MM-DD') AS last_day_of_year,
       TO_CHAR(datum, 'mmyyyy') AS mmyyyy,
       TO_CHAR(datum, 'mmddyyyy') AS mmddyyyy,
       CASE
           WHEN EXTRACT(ISODOW FROM datum) IN (6, 7) THEN TRUE
           ELSE FALSE
           END AS weekend_indr
FROM (SELECT '1970-01-01'::DATE + SEQUENCE.DAY AS datum
      FROM GENERATE_SERIES(0, 29219) AS SEQUENCE (DAY)
      GROUP BY SEQUENCE.DAY) DQ
ORDER BY 1;

COMMIT;


DROP TABLE if exists dim_time;

CREATE TABLE dim_time (
    time_id	INT UNIQUE,
    time_actual	VARCHAR(512),
    hours_24	INT,
    hours_12	INT,
    hour_minutes	INT,
    day_minutes	INT,
    day_time_name	VARCHAR(512),
    day_night	VARCHAR(512)
);

INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('0', '00:00:00', '00', '12', '00', '0', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1', '00:01:00', '00', '12', '01', '1', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2', '00:02:00', '00', '12', '02', '2', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('3', '00:03:00', '00', '12', '03', '3', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('4', '00:04:00', '00', '12', '04', '4', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('5', '00:05:00', '00', '12', '05', '5', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('6', '00:06:00', '00', '12', '06', '6', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('7', '00:07:00', '00', '12', '07', '7', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('8', '00:08:00', '00', '12', '08', '8', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('9', '00:09:00', '00', '12', '09', '9', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('10', '00:10:00', '00', '12', '10', '10', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('11', '00:11:00', '00', '12', '11', '11', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('12', '00:12:00', '00', '12', '12', '12', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('13', '00:13:00', '00', '12', '13', '13', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('14', '00:14:00', '00', '12', '14', '14', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('15', '00:15:00', '00', '12', '15', '15', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('16', '00:16:00', '00', '12', '16', '16', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('17', '00:17:00', '00', '12', '17', '17', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('18', '00:18:00', '00', '12', '18', '18', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('19', '00:19:00', '00', '12', '19', '19', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('20', '00:20:00', '00', '12', '20', '20', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('21', '00:21:00', '00', '12', '21', '21', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('22', '00:22:00', '00', '12', '22', '22', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('23', '00:23:00', '00', '12', '23', '23', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('24', '00:24:00', '00', '12', '24', '24', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('25', '00:25:00', '00', '12', '25', '25', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('26', '00:26:00', '00', '12', '26', '26', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('27', '00:27:00', '00', '12', '27', '27', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('28', '00:28:00', '00', '12', '28', '28', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('29', '00:29:00', '00', '12', '29', '29', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('30', '00:30:00', '00', '12', '30', '30', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('31', '00:31:00', '00', '12', '31', '31', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('32', '00:32:00', '00', '12', '32', '32', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('33', '00:33:00', '00', '12', '33', '33', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('34', '00:34:00', '00', '12', '34', '34', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('35', '00:35:00', '00', '12', '35', '35', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('36', '00:36:00', '00', '12', '36', '36', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('37', '00:37:00', '00', '12', '37', '37', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('38', '00:38:00', '00', '12', '38', '38', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('39', '00:39:00', '00', '12', '39', '39', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('40', '00:40:00', '00', '12', '40', '40', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('41', '00:41:00', '00', '12', '41', '41', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('42', '00:42:00', '00', '12', '42', '42', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('43', '00:43:00', '00', '12', '43', '43', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('44', '00:44:00', '00', '12', '44', '44', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('45', '00:45:00', '00', '12', '45', '45', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('46', '00:46:00', '00', '12', '46', '46', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('47', '00:47:00', '00', '12', '47', '47', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('48', '00:48:00', '00', '12', '48', '48', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('49', '00:49:00', '00', '12', '49', '49', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('50', '00:50:00', '00', '12', '50', '50', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('51', '00:51:00', '00', '12', '51', '51', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('52', '00:52:00', '00', '12', '52', '52', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('53', '00:53:00', '00', '12', '53', '53', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('54', '00:54:00', '00', '12', '54', '54', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('55', '00:55:00', '00', '12', '55', '55', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('56', '00:56:00', '00', '12', '56', '56', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('57', '00:57:00', '00', '12', '57', '57', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('58', '00:58:00', '00', '12', '58', '58', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('59', '00:59:00', '00', '12', '59', '59', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('100', '01:00:00', '01', '01', '00', '60', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('101', '01:01:00', '01', '01', '01', '61', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('102', '01:02:00', '01', '01', '02', '62', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('103', '01:03:00', '01', '01', '03', '63', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('104', '01:04:00', '01', '01', '04', '64', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('105', '01:05:00', '01', '01', '05', '65', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('106', '01:06:00', '01', '01', '06', '66', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('107', '01:07:00', '01', '01', '07', '67', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('108', '01:08:00', '01', '01', '08', '68', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('109', '01:09:00', '01', '01', '09', '69', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('110', '01:10:00', '01', '01', '10', '70', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('111', '01:11:00', '01', '01', '11', '71', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('112', '01:12:00', '01', '01', '12', '72', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('113', '01:13:00', '01', '01', '13', '73', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('114', '01:14:00', '01', '01', '14', '74', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('115', '01:15:00', '01', '01', '15', '75', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('116', '01:16:00', '01', '01', '16', '76', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('117', '01:17:00', '01', '01', '17', '77', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('118', '01:18:00', '01', '01', '18', '78', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('119', '01:19:00', '01', '01', '19', '79', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('120', '01:20:00', '01', '01', '20', '80', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('121', '01:21:00', '01', '01', '21', '81', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('122', '01:22:00', '01', '01', '22', '82', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('123', '01:23:00', '01', '01', '23', '83', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('124', '01:24:00', '01', '01', '24', '84', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('125', '01:25:00', '01', '01', '25', '85', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('126', '01:26:00', '01', '01', '26', '86', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('127', '01:27:00', '01', '01', '27', '87', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('128', '01:28:00', '01', '01', '28', '88', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('129', '01:29:00', '01', '01', '29', '89', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('130', '01:30:00', '01', '01', '30', '90', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('131', '01:31:00', '01', '01', '31', '91', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('132', '01:32:00', '01', '01', '32', '92', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('133', '01:33:00', '01', '01', '33', '93', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('134', '01:34:00', '01', '01', '34', '94', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('135', '01:35:00', '01', '01', '35', '95', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('136', '01:36:00', '01', '01', '36', '96', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('137', '01:37:00', '01', '01', '37', '97', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('138', '01:38:00', '01', '01', '38', '98', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('139', '01:39:00', '01', '01', '39', '99', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('140', '01:40:00', '01', '01', '40', '100', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('141', '01:41:00', '01', '01', '41', '101', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('142', '01:42:00', '01', '01', '42', '102', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('143', '01:43:00', '01', '01', '43', '103', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('144', '01:44:00', '01', '01', '44', '104', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('145', '01:45:00', '01', '01', '45', '105', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('146', '01:46:00', '01', '01', '46', '106', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('147', '01:47:00', '01', '01', '47', '107', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('148', '01:48:00', '01', '01', '48', '108', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('149', '01:49:00', '01', '01', '49', '109', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('150', '01:50:00', '01', '01', '50', '110', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('151', '01:51:00', '01', '01', '51', '111', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('152', '01:52:00', '01', '01', '52', '112', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('153', '01:53:00', '01', '01', '53', '113', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('154', '01:54:00', '01', '01', '54', '114', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('155', '01:55:00', '01', '01', '55', '115', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('156', '01:56:00', '01', '01', '56', '116', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('157', '01:57:00', '01', '01', '57', '117', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('158', '01:58:00', '01', '01', '58', '118', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('159', '01:59:00', '01', '01', '59', '119', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('200', '02:00:00', '02', '02', '00', '120', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('201', '02:01:00', '02', '02', '01', '121', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('202', '02:02:00', '02', '02', '02', '122', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('203', '02:03:00', '02', '02', '03', '123', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('204', '02:04:00', '02', '02', '04', '124', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('205', '02:05:00', '02', '02', '05', '125', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('206', '02:06:00', '02', '02', '06', '126', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('207', '02:07:00', '02', '02', '07', '127', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('208', '02:08:00', '02', '02', '08', '128', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('209', '02:09:00', '02', '02', '09', '129', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('210', '02:10:00', '02', '02', '10', '130', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('211', '02:11:00', '02', '02', '11', '131', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('212', '02:12:00', '02', '02', '12', '132', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('213', '02:13:00', '02', '02', '13', '133', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('214', '02:14:00', '02', '02', '14', '134', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('215', '02:15:00', '02', '02', '15', '135', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('216', '02:16:00', '02', '02', '16', '136', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('217', '02:17:00', '02', '02', '17', '137', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('218', '02:18:00', '02', '02', '18', '138', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('219', '02:19:00', '02', '02', '19', '139', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('220', '02:20:00', '02', '02', '20', '140', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('221', '02:21:00', '02', '02', '21', '141', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('222', '02:22:00', '02', '02', '22', '142', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('223', '02:23:00', '02', '02', '23', '143', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('224', '02:24:00', '02', '02', '24', '144', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('225', '02:25:00', '02', '02', '25', '145', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('226', '02:26:00', '02', '02', '26', '146', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('227', '02:27:00', '02', '02', '27', '147', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('228', '02:28:00', '02', '02', '28', '148', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('229', '02:29:00', '02', '02', '29', '149', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('230', '02:30:00', '02', '02', '30', '150', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('231', '02:31:00', '02', '02', '31', '151', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('232', '02:32:00', '02', '02', '32', '152', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('233', '02:33:00', '02', '02', '33', '153', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('234', '02:34:00', '02', '02', '34', '154', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('235', '02:35:00', '02', '02', '35', '155', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('236', '02:36:00', '02', '02', '36', '156', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('237', '02:37:00', '02', '02', '37', '157', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('238', '02:38:00', '02', '02', '38', '158', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('239', '02:39:00', '02', '02', '39', '159', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('240', '02:40:00', '02', '02', '40', '160', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('241', '02:41:00', '02', '02', '41', '161', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('242', '02:42:00', '02', '02', '42', '162', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('243', '02:43:00', '02', '02', '43', '163', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('244', '02:44:00', '02', '02', '44', '164', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('245', '02:45:00', '02', '02', '45', '165', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('246', '02:46:00', '02', '02', '46', '166', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('247', '02:47:00', '02', '02', '47', '167', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('248', '02:48:00', '02', '02', '48', '168', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('249', '02:49:00', '02', '02', '49', '169', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('250', '02:50:00', '02', '02', '50', '170', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('251', '02:51:00', '02', '02', '51', '171', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('252', '02:52:00', '02', '02', '52', '172', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('253', '02:53:00', '02', '02', '53', '173', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('254', '02:54:00', '02', '02', '54', '174', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('255', '02:55:00', '02', '02', '55', '175', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('256', '02:56:00', '02', '02', '56', '176', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('257', '02:57:00', '02', '02', '57', '177', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('258', '02:58:00', '02', '02', '58', '178', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('259', '02:59:00', '02', '02', '59', '179', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('300', '03:00:00', '03', '03', '00', '180', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('301', '03:01:00', '03', '03', '01', '181', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('302', '03:02:00', '03', '03', '02', '182', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('303', '03:03:00', '03', '03', '03', '183', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('304', '03:04:00', '03', '03', '04', '184', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('305', '03:05:00', '03', '03', '05', '185', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('306', '03:06:00', '03', '03', '06', '186', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('307', '03:07:00', '03', '03', '07', '187', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('308', '03:08:00', '03', '03', '08', '188', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('309', '03:09:00', '03', '03', '09', '189', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('310', '03:10:00', '03', '03', '10', '190', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('311', '03:11:00', '03', '03', '11', '191', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('312', '03:12:00', '03', '03', '12', '192', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('313', '03:13:00', '03', '03', '13', '193', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('314', '03:14:00', '03', '03', '14', '194', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('315', '03:15:00', '03', '03', '15', '195', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('316', '03:16:00', '03', '03', '16', '196', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('317', '03:17:00', '03', '03', '17', '197', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('318', '03:18:00', '03', '03', '18', '198', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('319', '03:19:00', '03', '03', '19', '199', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('320', '03:20:00', '03', '03', '20', '200', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('321', '03:21:00', '03', '03', '21', '201', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('322', '03:22:00', '03', '03', '22', '202', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('323', '03:23:00', '03', '03', '23', '203', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('324', '03:24:00', '03', '03', '24', '204', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('325', '03:25:00', '03', '03', '25', '205', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('326', '03:26:00', '03', '03', '26', '206', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('327', '03:27:00', '03', '03', '27', '207', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('328', '03:28:00', '03', '03', '28', '208', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('329', '03:29:00', '03', '03', '29', '209', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('330', '03:30:00', '03', '03', '30', '210', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('331', '03:31:00', '03', '03', '31', '211', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('332', '03:32:00', '03', '03', '32', '212', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('333', '03:33:00', '03', '03', '33', '213', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('334', '03:34:00', '03', '03', '34', '214', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('335', '03:35:00', '03', '03', '35', '215', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('336', '03:36:00', '03', '03', '36', '216', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('337', '03:37:00', '03', '03', '37', '217', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('338', '03:38:00', '03', '03', '38', '218', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('339', '03:39:00', '03', '03', '39', '219', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('340', '03:40:00', '03', '03', '40', '220', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('341', '03:41:00', '03', '03', '41', '221', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('342', '03:42:00', '03', '03', '42', '222', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('343', '03:43:00', '03', '03', '43', '223', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('344', '03:44:00', '03', '03', '44', '224', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('345', '03:45:00', '03', '03', '45', '225', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('346', '03:46:00', '03', '03', '46', '226', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('347', '03:47:00', '03', '03', '47', '227', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('348', '03:48:00', '03', '03', '48', '228', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('349', '03:49:00', '03', '03', '49', '229', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('350', '03:50:00', '03', '03', '50', '230', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('351', '03:51:00', '03', '03', '51', '231', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('352', '03:52:00', '03', '03', '52', '232', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('353', '03:53:00', '03', '03', '53', '233', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('354', '03:54:00', '03', '03', '54', '234', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('355', '03:55:00', '03', '03', '55', '235', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('356', '03:56:00', '03', '03', '56', '236', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('357', '03:57:00', '03', '03', '57', '237', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('358', '03:58:00', '03', '03', '58', '238', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('359', '03:59:00', '03', '03', '59', '239', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('400', '04:00:00', '04', '04', '00', '240', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('401', '04:01:00', '04', '04', '01', '241', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('402', '04:02:00', '04', '04', '02', '242', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('403', '04:03:00', '04', '04', '03', '243', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('404', '04:04:00', '04', '04', '04', '244', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('405', '04:05:00', '04', '04', '05', '245', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('406', '04:06:00', '04', '04', '06', '246', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('407', '04:07:00', '04', '04', '07', '247', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('408', '04:08:00', '04', '04', '08', '248', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('409', '04:09:00', '04', '04', '09', '249', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('410', '04:10:00', '04', '04', '10', '250', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('411', '04:11:00', '04', '04', '11', '251', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('412', '04:12:00', '04', '04', '12', '252', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('413', '04:13:00', '04', '04', '13', '253', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('414', '04:14:00', '04', '04', '14', '254', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('415', '04:15:00', '04', '04', '15', '255', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('416', '04:16:00', '04', '04', '16', '256', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('417', '04:17:00', '04', '04', '17', '257', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('418', '04:18:00', '04', '04', '18', '258', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('419', '04:19:00', '04', '04', '19', '259', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('420', '04:20:00', '04', '04', '20', '260', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('421', '04:21:00', '04', '04', '21', '261', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('422', '04:22:00', '04', '04', '22', '262', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('423', '04:23:00', '04', '04', '23', '263', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('424', '04:24:00', '04', '04', '24', '264', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('425', '04:25:00', '04', '04', '25', '265', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('426', '04:26:00', '04', '04', '26', '266', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('427', '04:27:00', '04', '04', '27', '267', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('428', '04:28:00', '04', '04', '28', '268', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('429', '04:29:00', '04', '04', '29', '269', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('430', '04:30:00', '04', '04', '30', '270', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('431', '04:31:00', '04', '04', '31', '271', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('432', '04:32:00', '04', '04', '32', '272', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('433', '04:33:00', '04', '04', '33', '273', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('434', '04:34:00', '04', '04', '34', '274', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('435', '04:35:00', '04', '04', '35', '275', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('436', '04:36:00', '04', '04', '36', '276', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('437', '04:37:00', '04', '04', '37', '277', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('438', '04:38:00', '04', '04', '38', '278', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('439', '04:39:00', '04', '04', '39', '279', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('440', '04:40:00', '04', '04', '40', '280', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('441', '04:41:00', '04', '04', '41', '281', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('442', '04:42:00', '04', '04', '42', '282', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('443', '04:43:00', '04', '04', '43', '283', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('444', '04:44:00', '04', '04', '44', '284', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('445', '04:45:00', '04', '04', '45', '285', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('446', '04:46:00', '04', '04', '46', '286', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('447', '04:47:00', '04', '04', '47', '287', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('448', '04:48:00', '04', '04', '48', '288', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('449', '04:49:00', '04', '04', '49', '289', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('450', '04:50:00', '04', '04', '50', '290', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('451', '04:51:00', '04', '04', '51', '291', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('452', '04:52:00', '04', '04', '52', '292', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('453', '04:53:00', '04', '04', '53', '293', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('454', '04:54:00', '04', '04', '54', '294', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('455', '04:55:00', '04', '04', '55', '295', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('456', '04:56:00', '04', '04', '56', '296', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('457', '04:57:00', '04', '04', '57', '297', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('458', '04:58:00', '04', '04', '58', '298', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('459', '04:59:00', '04', '04', '59', '299', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('500', '05:00:00', '05', '05', '00', '300', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('501', '05:01:00', '05', '05', '01', '301', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('502', '05:02:00', '05', '05', '02', '302', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('503', '05:03:00', '05', '05', '03', '303', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('504', '05:04:00', '05', '05', '04', '304', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('505', '05:05:00', '05', '05', '05', '305', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('506', '05:06:00', '05', '05', '06', '306', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('507', '05:07:00', '05', '05', '07', '307', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('508', '05:08:00', '05', '05', '08', '308', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('509', '05:09:00', '05', '05', '09', '309', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('510', '05:10:00', '05', '05', '10', '310', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('511', '05:11:00', '05', '05', '11', '311', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('512', '05:12:00', '05', '05', '12', '312', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('513', '05:13:00', '05', '05', '13', '313', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('514', '05:14:00', '05', '05', '14', '314', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('515', '05:15:00', '05', '05', '15', '315', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('516', '05:16:00', '05', '05', '16', '316', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('517', '05:17:00', '05', '05', '17', '317', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('518', '05:18:00', '05', '05', '18', '318', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('519', '05:19:00', '05', '05', '19', '319', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('520', '05:20:00', '05', '05', '20', '320', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('521', '05:21:00', '05', '05', '21', '321', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('522', '05:22:00', '05', '05', '22', '322', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('523', '05:23:00', '05', '05', '23', '323', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('524', '05:24:00', '05', '05', '24', '324', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('525', '05:25:00', '05', '05', '25', '325', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('526', '05:26:00', '05', '05', '26', '326', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('527', '05:27:00', '05', '05', '27', '327', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('528', '05:28:00', '05', '05', '28', '328', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('529', '05:29:00', '05', '05', '29', '329', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('530', '05:30:00', '05', '05', '30', '330', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('531', '05:31:00', '05', '05', '31', '331', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('532', '05:32:00', '05', '05', '32', '332', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('533', '05:33:00', '05', '05', '33', '333', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('534', '05:34:00', '05', '05', '34', '334', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('535', '05:35:00', '05', '05', '35', '335', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('536', '05:36:00', '05', '05', '36', '336', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('537', '05:37:00', '05', '05', '37', '337', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('538', '05:38:00', '05', '05', '38', '338', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('539', '05:39:00', '05', '05', '39', '339', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('540', '05:40:00', '05', '05', '40', '340', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('541', '05:41:00', '05', '05', '41', '341', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('542', '05:42:00', '05', '05', '42', '342', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('543', '05:43:00', '05', '05', '43', '343', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('544', '05:44:00', '05', '05', '44', '344', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('545', '05:45:00', '05', '05', '45', '345', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('546', '05:46:00', '05', '05', '46', '346', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('547', '05:47:00', '05', '05', '47', '347', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('548', '05:48:00', '05', '05', '48', '348', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('549', '05:49:00', '05', '05', '49', '349', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('550', '05:50:00', '05', '05', '50', '350', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('551', '05:51:00', '05', '05', '51', '351', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('552', '05:52:00', '05', '05', '52', '352', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('553', '05:53:00', '05', '05', '53', '353', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('554', '05:54:00', '05', '05', '54', '354', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('555', '05:55:00', '05', '05', '55', '355', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('556', '05:56:00', '05', '05', '56', '356', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('557', '05:57:00', '05', '05', '57', '357', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('558', '05:58:00', '05', '05', '58', '358', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('559', '05:59:00', '05', '05', '59', '359', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('600', '06:00:00', '06', '06', '00', '360', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('601', '06:01:00', '06', '06', '01', '361', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('602', '06:02:00', '06', '06', '02', '362', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('603', '06:03:00', '06', '06', '03', '363', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('604', '06:04:00', '06', '06', '04', '364', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('605', '06:05:00', '06', '06', '05', '365', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('606', '06:06:00', '06', '06', '06', '366', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('607', '06:07:00', '06', '06', '07', '367', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('608', '06:08:00', '06', '06', '08', '368', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('609', '06:09:00', '06', '06', '09', '369', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('610', '06:10:00', '06', '06', '10', '370', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('611', '06:11:00', '06', '06', '11', '371', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('612', '06:12:00', '06', '06', '12', '372', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('613', '06:13:00', '06', '06', '13', '373', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('614', '06:14:00', '06', '06', '14', '374', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('615', '06:15:00', '06', '06', '15', '375', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('616', '06:16:00', '06', '06', '16', '376', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('617', '06:17:00', '06', '06', '17', '377', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('618', '06:18:00', '06', '06', '18', '378', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('619', '06:19:00', '06', '06', '19', '379', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('620', '06:20:00', '06', '06', '20', '380', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('621', '06:21:00', '06', '06', '21', '381', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('622', '06:22:00', '06', '06', '22', '382', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('623', '06:23:00', '06', '06', '23', '383', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('624', '06:24:00', '06', '06', '24', '384', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('625', '06:25:00', '06', '06', '25', '385', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('626', '06:26:00', '06', '06', '26', '386', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('627', '06:27:00', '06', '06', '27', '387', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('628', '06:28:00', '06', '06', '28', '388', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('629', '06:29:00', '06', '06', '29', '389', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('630', '06:30:00', '06', '06', '30', '390', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('631', '06:31:00', '06', '06', '31', '391', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('632', '06:32:00', '06', '06', '32', '392', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('633', '06:33:00', '06', '06', '33', '393', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('634', '06:34:00', '06', '06', '34', '394', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('635', '06:35:00', '06', '06', '35', '395', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('636', '06:36:00', '06', '06', '36', '396', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('637', '06:37:00', '06', '06', '37', '397', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('638', '06:38:00', '06', '06', '38', '398', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('639', '06:39:00', '06', '06', '39', '399', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('640', '06:40:00', '06', '06', '40', '400', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('641', '06:41:00', '06', '06', '41', '401', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('642', '06:42:00', '06', '06', '42', '402', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('643', '06:43:00', '06', '06', '43', '403', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('644', '06:44:00', '06', '06', '44', '404', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('645', '06:45:00', '06', '06', '45', '405', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('646', '06:46:00', '06', '06', '46', '406', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('647', '06:47:00', '06', '06', '47', '407', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('648', '06:48:00', '06', '06', '48', '408', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('649', '06:49:00', '06', '06', '49', '409', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('650', '06:50:00', '06', '06', '50', '410', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('651', '06:51:00', '06', '06', '51', '411', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('652', '06:52:00', '06', '06', '52', '412', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('653', '06:53:00', '06', '06', '53', '413', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('654', '06:54:00', '06', '06', '54', '414', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('655', '06:55:00', '06', '06', '55', '415', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('656', '06:56:00', '06', '06', '56', '416', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('657', '06:57:00', '06', '06', '57', '417', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('658', '06:58:00', '06', '06', '58', '418', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('659', '06:59:00', '06', '06', '59', '419', 'AM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('700', '07:00:00', '07', '07', '00', '420', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('701', '07:01:00', '07', '07', '01', '421', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('702', '07:02:00', '07', '07', '02', '422', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('703', '07:03:00', '07', '07', '03', '423', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('704', '07:04:00', '07', '07', '04', '424', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('705', '07:05:00', '07', '07', '05', '425', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('706', '07:06:00', '07', '07', '06', '426', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('707', '07:07:00', '07', '07', '07', '427', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('708', '07:08:00', '07', '07', '08', '428', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('709', '07:09:00', '07', '07', '09', '429', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('710', '07:10:00', '07', '07', '10', '430', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('711', '07:11:00', '07', '07', '11', '431', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('712', '07:12:00', '07', '07', '12', '432', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('713', '07:13:00', '07', '07', '13', '433', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('714', '07:14:00', '07', '07', '14', '434', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('715', '07:15:00', '07', '07', '15', '435', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('716', '07:16:00', '07', '07', '16', '436', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('717', '07:17:00', '07', '07', '17', '437', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('718', '07:18:00', '07', '07', '18', '438', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('719', '07:19:00', '07', '07', '19', '439', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('720', '07:20:00', '07', '07', '20', '440', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('721', '07:21:00', '07', '07', '21', '441', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('722', '07:22:00', '07', '07', '22', '442', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('723', '07:23:00', '07', '07', '23', '443', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('724', '07:24:00', '07', '07', '24', '444', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('725', '07:25:00', '07', '07', '25', '445', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('726', '07:26:00', '07', '07', '26', '446', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('727', '07:27:00', '07', '07', '27', '447', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('728', '07:28:00', '07', '07', '28', '448', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('729', '07:29:00', '07', '07', '29', '449', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('730', '07:30:00', '07', '07', '30', '450', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('731', '07:31:00', '07', '07', '31', '451', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('732', '07:32:00', '07', '07', '32', '452', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('733', '07:33:00', '07', '07', '33', '453', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('734', '07:34:00', '07', '07', '34', '454', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('735', '07:35:00', '07', '07', '35', '455', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('736', '07:36:00', '07', '07', '36', '456', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('737', '07:37:00', '07', '07', '37', '457', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('738', '07:38:00', '07', '07', '38', '458', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('739', '07:39:00', '07', '07', '39', '459', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('740', '07:40:00', '07', '07', '40', '460', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('741', '07:41:00', '07', '07', '41', '461', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('742', '07:42:00', '07', '07', '42', '462', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('743', '07:43:00', '07', '07', '43', '463', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('744', '07:44:00', '07', '07', '44', '464', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('745', '07:45:00', '07', '07', '45', '465', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('746', '07:46:00', '07', '07', '46', '466', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('747', '07:47:00', '07', '07', '47', '467', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('748', '07:48:00', '07', '07', '48', '468', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('749', '07:49:00', '07', '07', '49', '469', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('750', '07:50:00', '07', '07', '50', '470', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('751', '07:51:00', '07', '07', '51', '471', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('752', '07:52:00', '07', '07', '52', '472', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('753', '07:53:00', '07', '07', '53', '473', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('754', '07:54:00', '07', '07', '54', '474', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('755', '07:55:00', '07', '07', '55', '475', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('756', '07:56:00', '07', '07', '56', '476', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('757', '07:57:00', '07', '07', '57', '477', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('758', '07:58:00', '07', '07', '58', '478', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('759', '07:59:00', '07', '07', '59', '479', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('800', '08:00:00', '08', '08', '00', '480', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('801', '08:01:00', '08', '08', '01', '481', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('802', '08:02:00', '08', '08', '02', '482', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('803', '08:03:00', '08', '08', '03', '483', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('804', '08:04:00', '08', '08', '04', '484', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('805', '08:05:00', '08', '08', '05', '485', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('806', '08:06:00', '08', '08', '06', '486', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('807', '08:07:00', '08', '08', '07', '487', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('808', '08:08:00', '08', '08', '08', '488', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('809', '08:09:00', '08', '08', '09', '489', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('810', '08:10:00', '08', '08', '10', '490', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('811', '08:11:00', '08', '08', '11', '491', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('812', '08:12:00', '08', '08', '12', '492', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('813', '08:13:00', '08', '08', '13', '493', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('814', '08:14:00', '08', '08', '14', '494', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('815', '08:15:00', '08', '08', '15', '495', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('816', '08:16:00', '08', '08', '16', '496', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('817', '08:17:00', '08', '08', '17', '497', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('818', '08:18:00', '08', '08', '18', '498', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('819', '08:19:00', '08', '08', '19', '499', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('820', '08:20:00', '08', '08', '20', '500', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('821', '08:21:00', '08', '08', '21', '501', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('822', '08:22:00', '08', '08', '22', '502', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('823', '08:23:00', '08', '08', '23', '503', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('824', '08:24:00', '08', '08', '24', '504', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('825', '08:25:00', '08', '08', '25', '505', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('826', '08:26:00', '08', '08', '26', '506', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('827', '08:27:00', '08', '08', '27', '507', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('828', '08:28:00', '08', '08', '28', '508', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('829', '08:29:00', '08', '08', '29', '509', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('830', '08:30:00', '08', '08', '30', '510', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('831', '08:31:00', '08', '08', '31', '511', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('832', '08:32:00', '08', '08', '32', '512', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('833', '08:33:00', '08', '08', '33', '513', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('834', '08:34:00', '08', '08', '34', '514', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('835', '08:35:00', '08', '08', '35', '515', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('836', '08:36:00', '08', '08', '36', '516', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('837', '08:37:00', '08', '08', '37', '517', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('838', '08:38:00', '08', '08', '38', '518', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('839', '08:39:00', '08', '08', '39', '519', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('840', '08:40:00', '08', '08', '40', '520', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('841', '08:41:00', '08', '08', '41', '521', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('842', '08:42:00', '08', '08', '42', '522', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('843', '08:43:00', '08', '08', '43', '523', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('844', '08:44:00', '08', '08', '44', '524', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('845', '08:45:00', '08', '08', '45', '525', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('846', '08:46:00', '08', '08', '46', '526', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('847', '08:47:00', '08', '08', '47', '527', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('848', '08:48:00', '08', '08', '48', '528', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('849', '08:49:00', '08', '08', '49', '529', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('850', '08:50:00', '08', '08', '50', '530', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('851', '08:51:00', '08', '08', '51', '531', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('852', '08:52:00', '08', '08', '52', '532', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('853', '08:53:00', '08', '08', '53', '533', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('854', '08:54:00', '08', '08', '54', '534', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('855', '08:55:00', '08', '08', '55', '535', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('856', '08:56:00', '08', '08', '56', '536', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('857', '08:57:00', '08', '08', '57', '537', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('858', '08:58:00', '08', '08', '58', '538', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('859', '08:59:00', '08', '08', '59', '539', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('900', '09:00:00', '09', '09', '00', '540', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('901', '09:01:00', '09', '09', '01', '541', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('902', '09:02:00', '09', '09', '02', '542', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('903', '09:03:00', '09', '09', '03', '543', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('904', '09:04:00', '09', '09', '04', '544', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('905', '09:05:00', '09', '09', '05', '545', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('906', '09:06:00', '09', '09', '06', '546', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('907', '09:07:00', '09', '09', '07', '547', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('908', '09:08:00', '09', '09', '08', '548', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('909', '09:09:00', '09', '09', '09', '549', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('910', '09:10:00', '09', '09', '10', '550', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('911', '09:11:00', '09', '09', '11', '551', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('912', '09:12:00', '09', '09', '12', '552', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('913', '09:13:00', '09', '09', '13', '553', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('914', '09:14:00', '09', '09', '14', '554', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('915', '09:15:00', '09', '09', '15', '555', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('916', '09:16:00', '09', '09', '16', '556', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('917', '09:17:00', '09', '09', '17', '557', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('918', '09:18:00', '09', '09', '18', '558', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('919', '09:19:00', '09', '09', '19', '559', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('920', '09:20:00', '09', '09', '20', '560', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('921', '09:21:00', '09', '09', '21', '561', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('922', '09:22:00', '09', '09', '22', '562', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('923', '09:23:00', '09', '09', '23', '563', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('924', '09:24:00', '09', '09', '24', '564', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('925', '09:25:00', '09', '09', '25', '565', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('926', '09:26:00', '09', '09', '26', '566', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('927', '09:27:00', '09', '09', '27', '567', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('928', '09:28:00', '09', '09', '28', '568', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('929', '09:29:00', '09', '09', '29', '569', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('930', '09:30:00', '09', '09', '30', '570', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('931', '09:31:00', '09', '09', '31', '571', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('932', '09:32:00', '09', '09', '32', '572', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('933', '09:33:00', '09', '09', '33', '573', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('934', '09:34:00', '09', '09', '34', '574', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('935', '09:35:00', '09', '09', '35', '575', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('936', '09:36:00', '09', '09', '36', '576', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('937', '09:37:00', '09', '09', '37', '577', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('938', '09:38:00', '09', '09', '38', '578', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('939', '09:39:00', '09', '09', '39', '579', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('940', '09:40:00', '09', '09', '40', '580', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('941', '09:41:00', '09', '09', '41', '581', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('942', '09:42:00', '09', '09', '42', '582', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('943', '09:43:00', '09', '09', '43', '583', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('944', '09:44:00', '09', '09', '44', '584', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('945', '09:45:00', '09', '09', '45', '585', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('946', '09:46:00', '09', '09', '46', '586', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('947', '09:47:00', '09', '09', '47', '587', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('948', '09:48:00', '09', '09', '48', '588', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('949', '09:49:00', '09', '09', '49', '589', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('950', '09:50:00', '09', '09', '50', '590', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('951', '09:51:00', '09', '09', '51', '591', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('952', '09:52:00', '09', '09', '52', '592', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('953', '09:53:00', '09', '09', '53', '593', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('954', '09:54:00', '09', '09', '54', '594', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('955', '09:55:00', '09', '09', '55', '595', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('956', '09:56:00', '09', '09', '56', '596', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('957', '09:57:00', '09', '09', '57', '597', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('958', '09:58:00', '09', '09', '58', '598', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('959', '09:59:00', '09', '09', '59', '599', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1000', '10:00:00', '10', '10', '00', '600', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1001', '10:01:00', '10', '10', '01', '601', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1002', '10:02:00', '10', '10', '02', '602', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1003', '10:03:00', '10', '10', '03', '603', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1004', '10:04:00', '10', '10', '04', '604', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1005', '10:05:00', '10', '10', '05', '605', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1006', '10:06:00', '10', '10', '06', '606', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1007', '10:07:00', '10', '10', '07', '607', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1008', '10:08:00', '10', '10', '08', '608', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1009', '10:09:00', '10', '10', '09', '609', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1010', '10:10:00', '10', '10', '10', '610', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1011', '10:11:00', '10', '10', '11', '611', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1012', '10:12:00', '10', '10', '12', '612', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1013', '10:13:00', '10', '10', '13', '613', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1014', '10:14:00', '10', '10', '14', '614', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1015', '10:15:00', '10', '10', '15', '615', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1016', '10:16:00', '10', '10', '16', '616', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1017', '10:17:00', '10', '10', '17', '617', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1018', '10:18:00', '10', '10', '18', '618', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1019', '10:19:00', '10', '10', '19', '619', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1020', '10:20:00', '10', '10', '20', '620', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1021', '10:21:00', '10', '10', '21', '621', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1022', '10:22:00', '10', '10', '22', '622', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1023', '10:23:00', '10', '10', '23', '623', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1024', '10:24:00', '10', '10', '24', '624', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1025', '10:25:00', '10', '10', '25', '625', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1026', '10:26:00', '10', '10', '26', '626', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1027', '10:27:00', '10', '10', '27', '627', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1028', '10:28:00', '10', '10', '28', '628', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1029', '10:29:00', '10', '10', '29', '629', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1030', '10:30:00', '10', '10', '30', '630', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1031', '10:31:00', '10', '10', '31', '631', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1032', '10:32:00', '10', '10', '32', '632', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1033', '10:33:00', '10', '10', '33', '633', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1034', '10:34:00', '10', '10', '34', '634', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1035', '10:35:00', '10', '10', '35', '635', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1036', '10:36:00', '10', '10', '36', '636', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1037', '10:37:00', '10', '10', '37', '637', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1038', '10:38:00', '10', '10', '38', '638', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1039', '10:39:00', '10', '10', '39', '639', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1040', '10:40:00', '10', '10', '40', '640', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1041', '10:41:00', '10', '10', '41', '641', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1042', '10:42:00', '10', '10', '42', '642', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1043', '10:43:00', '10', '10', '43', '643', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1044', '10:44:00', '10', '10', '44', '644', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1045', '10:45:00', '10', '10', '45', '645', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1046', '10:46:00', '10', '10', '46', '646', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1047', '10:47:00', '10', '10', '47', '647', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1048', '10:48:00', '10', '10', '48', '648', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1049', '10:49:00', '10', '10', '49', '649', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1050', '10:50:00', '10', '10', '50', '650', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1051', '10:51:00', '10', '10', '51', '651', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1052', '10:52:00', '10', '10', '52', '652', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1053', '10:53:00', '10', '10', '53', '653', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1054', '10:54:00', '10', '10', '54', '654', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1055', '10:55:00', '10', '10', '55', '655', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1056', '10:56:00', '10', '10', '56', '656', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1057', '10:57:00', '10', '10', '57', '657', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1058', '10:58:00', '10', '10', '58', '658', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1059', '10:59:00', '10', '10', '59', '659', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1100', '11:00:00', '11', '11', '00', '660', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1101', '11:01:00', '11', '11', '01', '661', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1102', '11:02:00', '11', '11', '02', '662', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1103', '11:03:00', '11', '11', '03', '663', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1104', '11:04:00', '11', '11', '04', '664', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1105', '11:05:00', '11', '11', '05', '665', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1106', '11:06:00', '11', '11', '06', '666', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1107', '11:07:00', '11', '11', '07', '667', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1108', '11:08:00', '11', '11', '08', '668', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1109', '11:09:00', '11', '11', '09', '669', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1110', '11:10:00', '11', '11', '10', '670', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1111', '11:11:00', '11', '11', '11', '671', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1112', '11:12:00', '11', '11', '12', '672', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1113', '11:13:00', '11', '11', '13', '673', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1114', '11:14:00', '11', '11', '14', '674', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1115', '11:15:00', '11', '11', '15', '675', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1116', '11:16:00', '11', '11', '16', '676', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1117', '11:17:00', '11', '11', '17', '677', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1118', '11:18:00', '11', '11', '18', '678', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1119', '11:19:00', '11', '11', '19', '679', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1120', '11:20:00', '11', '11', '20', '680', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1121', '11:21:00', '11', '11', '21', '681', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1122', '11:22:00', '11', '11', '22', '682', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1123', '11:23:00', '11', '11', '23', '683', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1124', '11:24:00', '11', '11', '24', '684', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1125', '11:25:00', '11', '11', '25', '685', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1126', '11:26:00', '11', '11', '26', '686', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1127', '11:27:00', '11', '11', '27', '687', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1128', '11:28:00', '11', '11', '28', '688', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1129', '11:29:00', '11', '11', '29', '689', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1130', '11:30:00', '11', '11', '30', '690', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1131', '11:31:00', '11', '11', '31', '691', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1132', '11:32:00', '11', '11', '32', '692', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1133', '11:33:00', '11', '11', '33', '693', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1134', '11:34:00', '11', '11', '34', '694', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1135', '11:35:00', '11', '11', '35', '695', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1136', '11:36:00', '11', '11', '36', '696', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1137', '11:37:00', '11', '11', '37', '697', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1138', '11:38:00', '11', '11', '38', '698', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1139', '11:39:00', '11', '11', '39', '699', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1140', '11:40:00', '11', '11', '40', '700', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1141', '11:41:00', '11', '11', '41', '701', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1142', '11:42:00', '11', '11', '42', '702', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1143', '11:43:00', '11', '11', '43', '703', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1144', '11:44:00', '11', '11', '44', '704', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1145', '11:45:00', '11', '11', '45', '705', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1146', '11:46:00', '11', '11', '46', '706', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1147', '11:47:00', '11', '11', '47', '707', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1148', '11:48:00', '11', '11', '48', '708', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1149', '11:49:00', '11', '11', '49', '709', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1150', '11:50:00', '11', '11', '50', '710', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1151', '11:51:00', '11', '11', '51', '711', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1152', '11:52:00', '11', '11', '52', '712', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1153', '11:53:00', '11', '11', '53', '713', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1154', '11:54:00', '11', '11', '54', '714', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1155', '11:55:00', '11', '11', '55', '715', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1156', '11:56:00', '11', '11', '56', '716', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1157', '11:57:00', '11', '11', '57', '717', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1158', '11:58:00', '11', '11', '58', '718', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1159', '11:59:00', '11', '11', '59', '719', 'AM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1200', '12:00:00', '12', '12', '00', '720', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1201', '12:01:00', '12', '12', '01', '721', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1202', '12:02:00', '12', '12', '02', '722', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1203', '12:03:00', '12', '12', '03', '723', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1204', '12:04:00', '12', '12', '04', '724', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1205', '12:05:00', '12', '12', '05', '725', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1206', '12:06:00', '12', '12', '06', '726', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1207', '12:07:00', '12', '12', '07', '727', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1208', '12:08:00', '12', '12', '08', '728', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1209', '12:09:00', '12', '12', '09', '729', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1210', '12:10:00', '12', '12', '10', '730', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1211', '12:11:00', '12', '12', '11', '731', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1212', '12:12:00', '12', '12', '12', '732', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1213', '12:13:00', '12', '12', '13', '733', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1214', '12:14:00', '12', '12', '14', '734', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1215', '12:15:00', '12', '12', '15', '735', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1216', '12:16:00', '12', '12', '16', '736', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1217', '12:17:00', '12', '12', '17', '737', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1218', '12:18:00', '12', '12', '18', '738', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1219', '12:19:00', '12', '12', '19', '739', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1220', '12:20:00', '12', '12', '20', '740', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1221', '12:21:00', '12', '12', '21', '741', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1222', '12:22:00', '12', '12', '22', '742', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1223', '12:23:00', '12', '12', '23', '743', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1224', '12:24:00', '12', '12', '24', '744', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1225', '12:25:00', '12', '12', '25', '745', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1226', '12:26:00', '12', '12', '26', '746', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1227', '12:27:00', '12', '12', '27', '747', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1228', '12:28:00', '12', '12', '28', '748', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1229', '12:29:00', '12', '12', '29', '749', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1230', '12:30:00', '12', '12', '30', '750', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1231', '12:31:00', '12', '12', '31', '751', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1232', '12:32:00', '12', '12', '32', '752', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1233', '12:33:00', '12', '12', '33', '753', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1234', '12:34:00', '12', '12', '34', '754', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1235', '12:35:00', '12', '12', '35', '755', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1236', '12:36:00', '12', '12', '36', '756', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1237', '12:37:00', '12', '12', '37', '757', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1238', '12:38:00', '12', '12', '38', '758', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1239', '12:39:00', '12', '12', '39', '759', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1240', '12:40:00', '12', '12', '40', '760', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1241', '12:41:00', '12', '12', '41', '761', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1242', '12:42:00', '12', '12', '42', '762', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1243', '12:43:00', '12', '12', '43', '763', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1244', '12:44:00', '12', '12', '44', '764', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1245', '12:45:00', '12', '12', '45', '765', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1246', '12:46:00', '12', '12', '46', '766', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1247', '12:47:00', '12', '12', '47', '767', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1248', '12:48:00', '12', '12', '48', '768', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1249', '12:49:00', '12', '12', '49', '769', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1250', '12:50:00', '12', '12', '50', '770', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1251', '12:51:00', '12', '12', '51', '771', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1252', '12:52:00', '12', '12', '52', '772', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1253', '12:53:00', '12', '12', '53', '773', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1254', '12:54:00', '12', '12', '54', '774', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1255', '12:55:00', '12', '12', '55', '775', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1256', '12:56:00', '12', '12', '56', '776', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1257', '12:57:00', '12', '12', '57', '777', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1258', '12:58:00', '12', '12', '58', '778', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1259', '12:59:00', '12', '12', '59', '779', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1300', '13:00:00', '13', '01', '00', '780', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1301', '13:01:00', '13', '01', '01', '781', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1302', '13:02:00', '13', '01', '02', '782', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1303', '13:03:00', '13', '01', '03', '783', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1304', '13:04:00', '13', '01', '04', '784', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1305', '13:05:00', '13', '01', '05', '785', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1306', '13:06:00', '13', '01', '06', '786', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1307', '13:07:00', '13', '01', '07', '787', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1308', '13:08:00', '13', '01', '08', '788', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1309', '13:09:00', '13', '01', '09', '789', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1310', '13:10:00', '13', '01', '10', '790', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1311', '13:11:00', '13', '01', '11', '791', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1312', '13:12:00', '13', '01', '12', '792', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1313', '13:13:00', '13', '01', '13', '793', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1314', '13:14:00', '13', '01', '14', '794', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1315', '13:15:00', '13', '01', '15', '795', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1316', '13:16:00', '13', '01', '16', '796', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1317', '13:17:00', '13', '01', '17', '797', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1318', '13:18:00', '13', '01', '18', '798', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1319', '13:19:00', '13', '01', '19', '799', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1320', '13:20:00', '13', '01', '20', '800', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1321', '13:21:00', '13', '01', '21', '801', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1322', '13:22:00', '13', '01', '22', '802', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1323', '13:23:00', '13', '01', '23', '803', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1324', '13:24:00', '13', '01', '24', '804', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1325', '13:25:00', '13', '01', '25', '805', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1326', '13:26:00', '13', '01', '26', '806', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1327', '13:27:00', '13', '01', '27', '807', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1328', '13:28:00', '13', '01', '28', '808', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1329', '13:29:00', '13', '01', '29', '809', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1330', '13:30:00', '13', '01', '30', '810', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1331', '13:31:00', '13', '01', '31', '811', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1332', '13:32:00', '13', '01', '32', '812', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1333', '13:33:00', '13', '01', '33', '813', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1334', '13:34:00', '13', '01', '34', '814', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1335', '13:35:00', '13', '01', '35', '815', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1336', '13:36:00', '13', '01', '36', '816', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1337', '13:37:00', '13', '01', '37', '817', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1338', '13:38:00', '13', '01', '38', '818', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1339', '13:39:00', '13', '01', '39', '819', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1340', '13:40:00', '13', '01', '40', '820', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1341', '13:41:00', '13', '01', '41', '821', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1342', '13:42:00', '13', '01', '42', '822', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1343', '13:43:00', '13', '01', '43', '823', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1344', '13:44:00', '13', '01', '44', '824', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1345', '13:45:00', '13', '01', '45', '825', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1346', '13:46:00', '13', '01', '46', '826', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1347', '13:47:00', '13', '01', '47', '827', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1348', '13:48:00', '13', '01', '48', '828', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1349', '13:49:00', '13', '01', '49', '829', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1350', '13:50:00', '13', '01', '50', '830', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1351', '13:51:00', '13', '01', '51', '831', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1352', '13:52:00', '13', '01', '52', '832', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1353', '13:53:00', '13', '01', '53', '833', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1354', '13:54:00', '13', '01', '54', '834', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1355', '13:55:00', '13', '01', '55', '835', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1356', '13:56:00', '13', '01', '56', '836', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1357', '13:57:00', '13', '01', '57', '837', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1358', '13:58:00', '13', '01', '58', '838', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1359', '13:59:00', '13', '01', '59', '839', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1400', '14:00:00', '14', '02', '00', '840', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1401', '14:01:00', '14', '02', '01', '841', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1402', '14:02:00', '14', '02', '02', '842', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1403', '14:03:00', '14', '02', '03', '843', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1404', '14:04:00', '14', '02', '04', '844', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1405', '14:05:00', '14', '02', '05', '845', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1406', '14:06:00', '14', '02', '06', '846', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1407', '14:07:00', '14', '02', '07', '847', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1408', '14:08:00', '14', '02', '08', '848', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1409', '14:09:00', '14', '02', '09', '849', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1410', '14:10:00', '14', '02', '10', '850', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1411', '14:11:00', '14', '02', '11', '851', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1412', '14:12:00', '14', '02', '12', '852', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1413', '14:13:00', '14', '02', '13', '853', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1414', '14:14:00', '14', '02', '14', '854', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1415', '14:15:00', '14', '02', '15', '855', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1416', '14:16:00', '14', '02', '16', '856', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1417', '14:17:00', '14', '02', '17', '857', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1418', '14:18:00', '14', '02', '18', '858', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1419', '14:19:00', '14', '02', '19', '859', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1420', '14:20:00', '14', '02', '20', '860', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1421', '14:21:00', '14', '02', '21', '861', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1422', '14:22:00', '14', '02', '22', '862', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1423', '14:23:00', '14', '02', '23', '863', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1424', '14:24:00', '14', '02', '24', '864', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1425', '14:25:00', '14', '02', '25', '865', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1426', '14:26:00', '14', '02', '26', '866', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1427', '14:27:00', '14', '02', '27', '867', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1428', '14:28:00', '14', '02', '28', '868', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1429', '14:29:00', '14', '02', '29', '869', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1430', '14:30:00', '14', '02', '30', '870', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1431', '14:31:00', '14', '02', '31', '871', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1432', '14:32:00', '14', '02', '32', '872', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1433', '14:33:00', '14', '02', '33', '873', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1434', '14:34:00', '14', '02', '34', '874', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1435', '14:35:00', '14', '02', '35', '875', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1436', '14:36:00', '14', '02', '36', '876', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1437', '14:37:00', '14', '02', '37', '877', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1438', '14:38:00', '14', '02', '38', '878', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1439', '14:39:00', '14', '02', '39', '879', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1440', '14:40:00', '14', '02', '40', '880', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1441', '14:41:00', '14', '02', '41', '881', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1442', '14:42:00', '14', '02', '42', '882', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1443', '14:43:00', '14', '02', '43', '883', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1444', '14:44:00', '14', '02', '44', '884', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1445', '14:45:00', '14', '02', '45', '885', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1446', '14:46:00', '14', '02', '46', '886', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1447', '14:47:00', '14', '02', '47', '887', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1448', '14:48:00', '14', '02', '48', '888', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1449', '14:49:00', '14', '02', '49', '889', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1450', '14:50:00', '14', '02', '50', '890', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1451', '14:51:00', '14', '02', '51', '891', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1452', '14:52:00', '14', '02', '52', '892', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1453', '14:53:00', '14', '02', '53', '893', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1454', '14:54:00', '14', '02', '54', '894', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1455', '14:55:00', '14', '02', '55', '895', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1456', '14:56:00', '14', '02', '56', '896', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1457', '14:57:00', '14', '02', '57', '897', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1458', '14:58:00', '14', '02', '58', '898', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1459', '14:59:00', '14', '02', '59', '899', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1500', '15:00:00', '15', '03', '00', '900', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1501', '15:01:00', '15', '03', '01', '901', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1502', '15:02:00', '15', '03', '02', '902', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1503', '15:03:00', '15', '03', '03', '903', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1504', '15:04:00', '15', '03', '04', '904', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1505', '15:05:00', '15', '03', '05', '905', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1506', '15:06:00', '15', '03', '06', '906', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1507', '15:07:00', '15', '03', '07', '907', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1508', '15:08:00', '15', '03', '08', '908', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1509', '15:09:00', '15', '03', '09', '909', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1510', '15:10:00', '15', '03', '10', '910', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1511', '15:11:00', '15', '03', '11', '911', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1512', '15:12:00', '15', '03', '12', '912', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1513', '15:13:00', '15', '03', '13', '913', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1514', '15:14:00', '15', '03', '14', '914', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1515', '15:15:00', '15', '03', '15', '915', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1516', '15:16:00', '15', '03', '16', '916', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1517', '15:17:00', '15', '03', '17', '917', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1518', '15:18:00', '15', '03', '18', '918', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1519', '15:19:00', '15', '03', '19', '919', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1520', '15:20:00', '15', '03', '20', '920', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1521', '15:21:00', '15', '03', '21', '921', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1522', '15:22:00', '15', '03', '22', '922', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1523', '15:23:00', '15', '03', '23', '923', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1524', '15:24:00', '15', '03', '24', '924', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1525', '15:25:00', '15', '03', '25', '925', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1526', '15:26:00', '15', '03', '26', '926', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1527', '15:27:00', '15', '03', '27', '927', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1528', '15:28:00', '15', '03', '28', '928', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1529', '15:29:00', '15', '03', '29', '929', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1530', '15:30:00', '15', '03', '30', '930', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1531', '15:31:00', '15', '03', '31', '931', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1532', '15:32:00', '15', '03', '32', '932', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1533', '15:33:00', '15', '03', '33', '933', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1534', '15:34:00', '15', '03', '34', '934', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1535', '15:35:00', '15', '03', '35', '935', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1536', '15:36:00', '15', '03', '36', '936', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1537', '15:37:00', '15', '03', '37', '937', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1538', '15:38:00', '15', '03', '38', '938', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1539', '15:39:00', '15', '03', '39', '939', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1540', '15:40:00', '15', '03', '40', '940', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1541', '15:41:00', '15', '03', '41', '941', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1542', '15:42:00', '15', '03', '42', '942', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1543', '15:43:00', '15', '03', '43', '943', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1544', '15:44:00', '15', '03', '44', '944', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1545', '15:45:00', '15', '03', '45', '945', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1546', '15:46:00', '15', '03', '46', '946', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1547', '15:47:00', '15', '03', '47', '947', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1548', '15:48:00', '15', '03', '48', '948', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1549', '15:49:00', '15', '03', '49', '949', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1550', '15:50:00', '15', '03', '50', '950', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1551', '15:51:00', '15', '03', '51', '951', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1552', '15:52:00', '15', '03', '52', '952', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1553', '15:53:00', '15', '03', '53', '953', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1554', '15:54:00', '15', '03', '54', '954', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1555', '15:55:00', '15', '03', '55', '955', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1556', '15:56:00', '15', '03', '56', '956', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1557', '15:57:00', '15', '03', '57', '957', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1558', '15:58:00', '15', '03', '58', '958', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1559', '15:59:00', '15', '03', '59', '959', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1600', '16:00:00', '16', '04', '00', '960', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1601', '16:01:00', '16', '04', '01', '961', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1602', '16:02:00', '16', '04', '02', '962', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1603', '16:03:00', '16', '04', '03', '963', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1604', '16:04:00', '16', '04', '04', '964', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1605', '16:05:00', '16', '04', '05', '965', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1606', '16:06:00', '16', '04', '06', '966', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1607', '16:07:00', '16', '04', '07', '967', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1608', '16:08:00', '16', '04', '08', '968', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1609', '16:09:00', '16', '04', '09', '969', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1610', '16:10:00', '16', '04', '10', '970', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1611', '16:11:00', '16', '04', '11', '971', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1612', '16:12:00', '16', '04', '12', '972', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1613', '16:13:00', '16', '04', '13', '973', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1614', '16:14:00', '16', '04', '14', '974', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1615', '16:15:00', '16', '04', '15', '975', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1616', '16:16:00', '16', '04', '16', '976', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1617', '16:17:00', '16', '04', '17', '977', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1618', '16:18:00', '16', '04', '18', '978', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1619', '16:19:00', '16', '04', '19', '979', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1620', '16:20:00', '16', '04', '20', '980', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1621', '16:21:00', '16', '04', '21', '981', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1622', '16:22:00', '16', '04', '22', '982', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1623', '16:23:00', '16', '04', '23', '983', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1624', '16:24:00', '16', '04', '24', '984', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1625', '16:25:00', '16', '04', '25', '985', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1626', '16:26:00', '16', '04', '26', '986', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1627', '16:27:00', '16', '04', '27', '987', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1628', '16:28:00', '16', '04', '28', '988', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1629', '16:29:00', '16', '04', '29', '989', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1630', '16:30:00', '16', '04', '30', '990', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1631', '16:31:00', '16', '04', '31', '991', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1632', '16:32:00', '16', '04', '32', '992', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1633', '16:33:00', '16', '04', '33', '993', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1634', '16:34:00', '16', '04', '34', '994', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1635', '16:35:00', '16', '04', '35', '995', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1636', '16:36:00', '16', '04', '36', '996', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1637', '16:37:00', '16', '04', '37', '997', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1638', '16:38:00', '16', '04', '38', '998', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1639', '16:39:00', '16', '04', '39', '999', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1640', '16:40:00', '16', '04', '40', '1000', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1641', '16:41:00', '16', '04', '41', '1001', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1642', '16:42:00', '16', '04', '42', '1002', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1643', '16:43:00', '16', '04', '43', '1003', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1644', '16:44:00', '16', '04', '44', '1004', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1645', '16:45:00', '16', '04', '45', '1005', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1646', '16:46:00', '16', '04', '46', '1006', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1647', '16:47:00', '16', '04', '47', '1007', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1648', '16:48:00', '16', '04', '48', '1008', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1649', '16:49:00', '16', '04', '49', '1009', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1650', '16:50:00', '16', '04', '50', '1010', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1651', '16:51:00', '16', '04', '51', '1011', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1652', '16:52:00', '16', '04', '52', '1012', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1653', '16:53:00', '16', '04', '53', '1013', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1654', '16:54:00', '16', '04', '54', '1014', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1655', '16:55:00', '16', '04', '55', '1015', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1656', '16:56:00', '16', '04', '56', '1016', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1657', '16:57:00', '16', '04', '57', '1017', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1658', '16:58:00', '16', '04', '58', '1018', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1659', '16:59:00', '16', '04', '59', '1019', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1700', '17:00:00', '17', '05', '00', '1020', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1701', '17:01:00', '17', '05', '01', '1021', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1702', '17:02:00', '17', '05', '02', '1022', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1703', '17:03:00', '17', '05', '03', '1023', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1704', '17:04:00', '17', '05', '04', '1024', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1705', '17:05:00', '17', '05', '05', '1025', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1706', '17:06:00', '17', '05', '06', '1026', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1707', '17:07:00', '17', '05', '07', '1027', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1708', '17:08:00', '17', '05', '08', '1028', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1709', '17:09:00', '17', '05', '09', '1029', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1710', '17:10:00', '17', '05', '10', '1030', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1711', '17:11:00', '17', '05', '11', '1031', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1712', '17:12:00', '17', '05', '12', '1032', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1713', '17:13:00', '17', '05', '13', '1033', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1714', '17:14:00', '17', '05', '14', '1034', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1715', '17:15:00', '17', '05', '15', '1035', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1716', '17:16:00', '17', '05', '16', '1036', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1717', '17:17:00', '17', '05', '17', '1037', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1718', '17:18:00', '17', '05', '18', '1038', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1719', '17:19:00', '17', '05', '19', '1039', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1720', '17:20:00', '17', '05', '20', '1040', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1721', '17:21:00', '17', '05', '21', '1041', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1722', '17:22:00', '17', '05', '22', '1042', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1723', '17:23:00', '17', '05', '23', '1043', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1724', '17:24:00', '17', '05', '24', '1044', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1725', '17:25:00', '17', '05', '25', '1045', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1726', '17:26:00', '17', '05', '26', '1046', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1727', '17:27:00', '17', '05', '27', '1047', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1728', '17:28:00', '17', '05', '28', '1048', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1729', '17:29:00', '17', '05', '29', '1049', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1730', '17:30:00', '17', '05', '30', '1050', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1731', '17:31:00', '17', '05', '31', '1051', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1732', '17:32:00', '17', '05', '32', '1052', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1733', '17:33:00', '17', '05', '33', '1053', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1734', '17:34:00', '17', '05', '34', '1054', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1735', '17:35:00', '17', '05', '35', '1055', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1736', '17:36:00', '17', '05', '36', '1056', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1737', '17:37:00', '17', '05', '37', '1057', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1738', '17:38:00', '17', '05', '38', '1058', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1739', '17:39:00', '17', '05', '39', '1059', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1740', '17:40:00', '17', '05', '40', '1060', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1741', '17:41:00', '17', '05', '41', '1061', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1742', '17:42:00', '17', '05', '42', '1062', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1743', '17:43:00', '17', '05', '43', '1063', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1744', '17:44:00', '17', '05', '44', '1064', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1745', '17:45:00', '17', '05', '45', '1065', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1746', '17:46:00', '17', '05', '46', '1066', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1747', '17:47:00', '17', '05', '47', '1067', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1748', '17:48:00', '17', '05', '48', '1068', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1749', '17:49:00', '17', '05', '49', '1069', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1750', '17:50:00', '17', '05', '50', '1070', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1751', '17:51:00', '17', '05', '51', '1071', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1752', '17:52:00', '17', '05', '52', '1072', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1753', '17:53:00', '17', '05', '53', '1073', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1754', '17:54:00', '17', '05', '54', '1074', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1755', '17:55:00', '17', '05', '55', '1075', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1756', '17:56:00', '17', '05', '56', '1076', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1757', '17:57:00', '17', '05', '57', '1077', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1758', '17:58:00', '17', '05', '58', '1078', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1759', '17:59:00', '17', '05', '59', '1079', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1800', '18:00:00', '18', '06', '00', '1080', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1801', '18:01:00', '18', '06', '01', '1081', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1802', '18:02:00', '18', '06', '02', '1082', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1803', '18:03:00', '18', '06', '03', '1083', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1804', '18:04:00', '18', '06', '04', '1084', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1805', '18:05:00', '18', '06', '05', '1085', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1806', '18:06:00', '18', '06', '06', '1086', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1807', '18:07:00', '18', '06', '07', '1087', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1808', '18:08:00', '18', '06', '08', '1088', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1809', '18:09:00', '18', '06', '09', '1089', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1810', '18:10:00', '18', '06', '10', '1090', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1811', '18:11:00', '18', '06', '11', '1091', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1812', '18:12:00', '18', '06', '12', '1092', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1813', '18:13:00', '18', '06', '13', '1093', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1814', '18:14:00', '18', '06', '14', '1094', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1815', '18:15:00', '18', '06', '15', '1095', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1816', '18:16:00', '18', '06', '16', '1096', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1817', '18:17:00', '18', '06', '17', '1097', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1818', '18:18:00', '18', '06', '18', '1098', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1819', '18:19:00', '18', '06', '19', '1099', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1820', '18:20:00', '18', '06', '20', '1100', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1821', '18:21:00', '18', '06', '21', '1101', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1822', '18:22:00', '18', '06', '22', '1102', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1823', '18:23:00', '18', '06', '23', '1103', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1824', '18:24:00', '18', '06', '24', '1104', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1825', '18:25:00', '18', '06', '25', '1105', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1826', '18:26:00', '18', '06', '26', '1106', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1827', '18:27:00', '18', '06', '27', '1107', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1828', '18:28:00', '18', '06', '28', '1108', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1829', '18:29:00', '18', '06', '29', '1109', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1830', '18:30:00', '18', '06', '30', '1110', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1831', '18:31:00', '18', '06', '31', '1111', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1832', '18:32:00', '18', '06', '32', '1112', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1833', '18:33:00', '18', '06', '33', '1113', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1834', '18:34:00', '18', '06', '34', '1114', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1835', '18:35:00', '18', '06', '35', '1115', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1836', '18:36:00', '18', '06', '36', '1116', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1837', '18:37:00', '18', '06', '37', '1117', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1838', '18:38:00', '18', '06', '38', '1118', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1839', '18:39:00', '18', '06', '39', '1119', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1840', '18:40:00', '18', '06', '40', '1120', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1841', '18:41:00', '18', '06', '41', '1121', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1842', '18:42:00', '18', '06', '42', '1122', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1843', '18:43:00', '18', '06', '43', '1123', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1844', '18:44:00', '18', '06', '44', '1124', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1845', '18:45:00', '18', '06', '45', '1125', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1846', '18:46:00', '18', '06', '46', '1126', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1847', '18:47:00', '18', '06', '47', '1127', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1848', '18:48:00', '18', '06', '48', '1128', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1849', '18:49:00', '18', '06', '49', '1129', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1850', '18:50:00', '18', '06', '50', '1130', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1851', '18:51:00', '18', '06', '51', '1131', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1852', '18:52:00', '18', '06', '52', '1132', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1853', '18:53:00', '18', '06', '53', '1133', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1854', '18:54:00', '18', '06', '54', '1134', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1855', '18:55:00', '18', '06', '55', '1135', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1856', '18:56:00', '18', '06', '56', '1136', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1857', '18:57:00', '18', '06', '57', '1137', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1858', '18:58:00', '18', '06', '58', '1138', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1859', '18:59:00', '18', '06', '59', '1139', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1900', '19:00:00', '19', '07', '00', '1140', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1901', '19:01:00', '19', '07', '01', '1141', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1902', '19:02:00', '19', '07', '02', '1142', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1903', '19:03:00', '19', '07', '03', '1143', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1904', '19:04:00', '19', '07', '04', '1144', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1905', '19:05:00', '19', '07', '05', '1145', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1906', '19:06:00', '19', '07', '06', '1146', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1907', '19:07:00', '19', '07', '07', '1147', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1908', '19:08:00', '19', '07', '08', '1148', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1909', '19:09:00', '19', '07', '09', '1149', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1910', '19:10:00', '19', '07', '10', '1150', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1911', '19:11:00', '19', '07', '11', '1151', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1912', '19:12:00', '19', '07', '12', '1152', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1913', '19:13:00', '19', '07', '13', '1153', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1914', '19:14:00', '19', '07', '14', '1154', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1915', '19:15:00', '19', '07', '15', '1155', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1916', '19:16:00', '19', '07', '16', '1156', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1917', '19:17:00', '19', '07', '17', '1157', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1918', '19:18:00', '19', '07', '18', '1158', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1919', '19:19:00', '19', '07', '19', '1159', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1920', '19:20:00', '19', '07', '20', '1160', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1921', '19:21:00', '19', '07', '21', '1161', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1922', '19:22:00', '19', '07', '22', '1162', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1923', '19:23:00', '19', '07', '23', '1163', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1924', '19:24:00', '19', '07', '24', '1164', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1925', '19:25:00', '19', '07', '25', '1165', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1926', '19:26:00', '19', '07', '26', '1166', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1927', '19:27:00', '19', '07', '27', '1167', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1928', '19:28:00', '19', '07', '28', '1168', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1929', '19:29:00', '19', '07', '29', '1169', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1930', '19:30:00', '19', '07', '30', '1170', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1931', '19:31:00', '19', '07', '31', '1171', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1932', '19:32:00', '19', '07', '32', '1172', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1933', '19:33:00', '19', '07', '33', '1173', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1934', '19:34:00', '19', '07', '34', '1174', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1935', '19:35:00', '19', '07', '35', '1175', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1936', '19:36:00', '19', '07', '36', '1176', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1937', '19:37:00', '19', '07', '37', '1177', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1938', '19:38:00', '19', '07', '38', '1178', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1939', '19:39:00', '19', '07', '39', '1179', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1940', '19:40:00', '19', '07', '40', '1180', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1941', '19:41:00', '19', '07', '41', '1181', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1942', '19:42:00', '19', '07', '42', '1182', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1943', '19:43:00', '19', '07', '43', '1183', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1944', '19:44:00', '19', '07', '44', '1184', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1945', '19:45:00', '19', '07', '45', '1185', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1946', '19:46:00', '19', '07', '46', '1186', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1947', '19:47:00', '19', '07', '47', '1187', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1948', '19:48:00', '19', '07', '48', '1188', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1949', '19:49:00', '19', '07', '49', '1189', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1950', '19:50:00', '19', '07', '50', '1190', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1951', '19:51:00', '19', '07', '51', '1191', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1952', '19:52:00', '19', '07', '52', '1192', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1953', '19:53:00', '19', '07', '53', '1193', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1954', '19:54:00', '19', '07', '54', '1194', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1955', '19:55:00', '19', '07', '55', '1195', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1956', '19:56:00', '19', '07', '56', '1196', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1957', '19:57:00', '19', '07', '57', '1197', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1958', '19:58:00', '19', '07', '58', '1198', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('1959', '19:59:00', '19', '07', '59', '1199', 'PM', 'Day');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2000', '20:00:00', '20', '08', '00', '1200', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2001', '20:01:00', '20', '08', '01', '1201', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2002', '20:02:00', '20', '08', '02', '1202', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2003', '20:03:00', '20', '08', '03', '1203', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2004', '20:04:00', '20', '08', '04', '1204', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2005', '20:05:00', '20', '08', '05', '1205', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2006', '20:06:00', '20', '08', '06', '1206', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2007', '20:07:00', '20', '08', '07', '1207', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2008', '20:08:00', '20', '08', '08', '1208', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2009', '20:09:00', '20', '08', '09', '1209', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2010', '20:10:00', '20', '08', '10', '1210', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2011', '20:11:00', '20', '08', '11', '1211', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2012', '20:12:00', '20', '08', '12', '1212', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2013', '20:13:00', '20', '08', '13', '1213', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2014', '20:14:00', '20', '08', '14', '1214', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2015', '20:15:00', '20', '08', '15', '1215', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2016', '20:16:00', '20', '08', '16', '1216', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2017', '20:17:00', '20', '08', '17', '1217', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2018', '20:18:00', '20', '08', '18', '1218', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2019', '20:19:00', '20', '08', '19', '1219', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2020', '20:20:00', '20', '08', '20', '1220', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2021', '20:21:00', '20', '08', '21', '1221', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2022', '20:22:00', '20', '08', '22', '1222', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2023', '20:23:00', '20', '08', '23', '1223', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2024', '20:24:00', '20', '08', '24', '1224', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2025', '20:25:00', '20', '08', '25', '1225', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2026', '20:26:00', '20', '08', '26', '1226', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2027', '20:27:00', '20', '08', '27', '1227', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2028', '20:28:00', '20', '08', '28', '1228', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2029', '20:29:00', '20', '08', '29', '1229', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2030', '20:30:00', '20', '08', '30', '1230', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2031', '20:31:00', '20', '08', '31', '1231', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2032', '20:32:00', '20', '08', '32', '1232', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2033', '20:33:00', '20', '08', '33', '1233', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2034', '20:34:00', '20', '08', '34', '1234', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2035', '20:35:00', '20', '08', '35', '1235', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2036', '20:36:00', '20', '08', '36', '1236', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2037', '20:37:00', '20', '08', '37', '1237', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2038', '20:38:00', '20', '08', '38', '1238', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2039', '20:39:00', '20', '08', '39', '1239', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2040', '20:40:00', '20', '08', '40', '1240', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2041', '20:41:00', '20', '08', '41', '1241', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2042', '20:42:00', '20', '08', '42', '1242', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2043', '20:43:00', '20', '08', '43', '1243', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2044', '20:44:00', '20', '08', '44', '1244', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2045', '20:45:00', '20', '08', '45', '1245', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2046', '20:46:00', '20', '08', '46', '1246', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2047', '20:47:00', '20', '08', '47', '1247', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2048', '20:48:00', '20', '08', '48', '1248', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2049', '20:49:00', '20', '08', '49', '1249', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2050', '20:50:00', '20', '08', '50', '1250', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2051', '20:51:00', '20', '08', '51', '1251', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2052', '20:52:00', '20', '08', '52', '1252', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2053', '20:53:00', '20', '08', '53', '1253', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2054', '20:54:00', '20', '08', '54', '1254', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2055', '20:55:00', '20', '08', '55', '1255', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2056', '20:56:00', '20', '08', '56', '1256', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2057', '20:57:00', '20', '08', '57', '1257', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2058', '20:58:00', '20', '08', '58', '1258', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2059', '20:59:00', '20', '08', '59', '1259', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2100', '21:00:00', '21', '09', '00', '1260', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2101', '21:01:00', '21', '09', '01', '1261', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2102', '21:02:00', '21', '09', '02', '1262', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2103', '21:03:00', '21', '09', '03', '1263', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2104', '21:04:00', '21', '09', '04', '1264', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2105', '21:05:00', '21', '09', '05', '1265', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2106', '21:06:00', '21', '09', '06', '1266', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2107', '21:07:00', '21', '09', '07', '1267', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2108', '21:08:00', '21', '09', '08', '1268', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2109', '21:09:00', '21', '09', '09', '1269', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2110', '21:10:00', '21', '09', '10', '1270', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2111', '21:11:00', '21', '09', '11', '1271', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2112', '21:12:00', '21', '09', '12', '1272', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2113', '21:13:00', '21', '09', '13', '1273', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2114', '21:14:00', '21', '09', '14', '1274', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2115', '21:15:00', '21', '09', '15', '1275', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2116', '21:16:00', '21', '09', '16', '1276', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2117', '21:17:00', '21', '09', '17', '1277', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2118', '21:18:00', '21', '09', '18', '1278', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2119', '21:19:00', '21', '09', '19', '1279', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2120', '21:20:00', '21', '09', '20', '1280', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2121', '21:21:00', '21', '09', '21', '1281', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2122', '21:22:00', '21', '09', '22', '1282', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2123', '21:23:00', '21', '09', '23', '1283', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2124', '21:24:00', '21', '09', '24', '1284', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2125', '21:25:00', '21', '09', '25', '1285', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2126', '21:26:00', '21', '09', '26', '1286', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2127', '21:27:00', '21', '09', '27', '1287', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2128', '21:28:00', '21', '09', '28', '1288', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2129', '21:29:00', '21', '09', '29', '1289', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2130', '21:30:00', '21', '09', '30', '1290', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2131', '21:31:00', '21', '09', '31', '1291', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2132', '21:32:00', '21', '09', '32', '1292', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2133', '21:33:00', '21', '09', '33', '1293', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2134', '21:34:00', '21', '09', '34', '1294', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2135', '21:35:00', '21', '09', '35', '1295', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2136', '21:36:00', '21', '09', '36', '1296', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2137', '21:37:00', '21', '09', '37', '1297', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2138', '21:38:00', '21', '09', '38', '1298', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2139', '21:39:00', '21', '09', '39', '1299', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2140', '21:40:00', '21', '09', '40', '1300', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2141', '21:41:00', '21', '09', '41', '1301', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2142', '21:42:00', '21', '09', '42', '1302', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2143', '21:43:00', '21', '09', '43', '1303', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2144', '21:44:00', '21', '09', '44', '1304', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2145', '21:45:00', '21', '09', '45', '1305', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2146', '21:46:00', '21', '09', '46', '1306', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2147', '21:47:00', '21', '09', '47', '1307', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2148', '21:48:00', '21', '09', '48', '1308', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2149', '21:49:00', '21', '09', '49', '1309', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2150', '21:50:00', '21', '09', '50', '1310', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2151', '21:51:00', '21', '09', '51', '1311', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2152', '21:52:00', '21', '09', '52', '1312', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2153', '21:53:00', '21', '09', '53', '1313', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2154', '21:54:00', '21', '09', '54', '1314', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2155', '21:55:00', '21', '09', '55', '1315', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2156', '21:56:00', '21', '09', '56', '1316', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2157', '21:57:00', '21', '09', '57', '1317', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2158', '21:58:00', '21', '09', '58', '1318', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2159', '21:59:00', '21', '09', '59', '1319', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2200', '22:00:00', '22', '10', '00', '1320', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2201', '22:01:00', '22', '10', '01', '1321', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2202', '22:02:00', '22', '10', '02', '1322', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2203', '22:03:00', '22', '10', '03', '1323', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2204', '22:04:00', '22', '10', '04', '1324', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2205', '22:05:00', '22', '10', '05', '1325', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2206', '22:06:00', '22', '10', '06', '1326', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2207', '22:07:00', '22', '10', '07', '1327', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2208', '22:08:00', '22', '10', '08', '1328', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2209', '22:09:00', '22', '10', '09', '1329', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2210', '22:10:00', '22', '10', '10', '1330', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2211', '22:11:00', '22', '10', '11', '1331', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2212', '22:12:00', '22', '10', '12', '1332', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2213', '22:13:00', '22', '10', '13', '1333', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2214', '22:14:00', '22', '10', '14', '1334', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2215', '22:15:00', '22', '10', '15', '1335', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2216', '22:16:00', '22', '10', '16', '1336', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2217', '22:17:00', '22', '10', '17', '1337', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2218', '22:18:00', '22', '10', '18', '1338', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2219', '22:19:00', '22', '10', '19', '1339', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2220', '22:20:00', '22', '10', '20', '1340', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2221', '22:21:00', '22', '10', '21', '1341', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2222', '22:22:00', '22', '10', '22', '1342', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2223', '22:23:00', '22', '10', '23', '1343', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2224', '22:24:00', '22', '10', '24', '1344', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2225', '22:25:00', '22', '10', '25', '1345', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2226', '22:26:00', '22', '10', '26', '1346', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2227', '22:27:00', '22', '10', '27', '1347', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2228', '22:28:00', '22', '10', '28', '1348', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2229', '22:29:00', '22', '10', '29', '1349', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2230', '22:30:00', '22', '10', '30', '1350', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2231', '22:31:00', '22', '10', '31', '1351', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2232', '22:32:00', '22', '10', '32', '1352', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2233', '22:33:00', '22', '10', '33', '1353', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2234', '22:34:00', '22', '10', '34', '1354', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2235', '22:35:00', '22', '10', '35', '1355', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2236', '22:36:00', '22', '10', '36', '1356', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2237', '22:37:00', '22', '10', '37', '1357', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2238', '22:38:00', '22', '10', '38', '1358', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2239', '22:39:00', '22', '10', '39', '1359', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2240', '22:40:00', '22', '10', '40', '1360', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2241', '22:41:00', '22', '10', '41', '1361', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2242', '22:42:00', '22', '10', '42', '1362', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2243', '22:43:00', '22', '10', '43', '1363', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2244', '22:44:00', '22', '10', '44', '1364', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2245', '22:45:00', '22', '10', '45', '1365', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2246', '22:46:00', '22', '10', '46', '1366', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2247', '22:47:00', '22', '10', '47', '1367', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2248', '22:48:00', '22', '10', '48', '1368', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2249', '22:49:00', '22', '10', '49', '1369', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2250', '22:50:00', '22', '10', '50', '1370', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2251', '22:51:00', '22', '10', '51', '1371', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2252', '22:52:00', '22', '10', '52', '1372', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2253', '22:53:00', '22', '10', '53', '1373', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2254', '22:54:00', '22', '10', '54', '1374', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2255', '22:55:00', '22', '10', '55', '1375', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2256', '22:56:00', '22', '10', '56', '1376', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2257', '22:57:00', '22', '10', '57', '1377', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2258', '22:58:00', '22', '10', '58', '1378', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2259', '22:59:00', '22', '10', '59', '1379', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2300', '23:00:00', '23', '11', '00', '1380', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2301', '23:01:00', '23', '11', '01', '1381', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2302', '23:02:00', '23', '11', '02', '1382', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2303', '23:03:00', '23', '11', '03', '1383', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2304', '23:04:00', '23', '11', '04', '1384', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2305', '23:05:00', '23', '11', '05', '1385', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2306', '23:06:00', '23', '11', '06', '1386', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2307', '23:07:00', '23', '11', '07', '1387', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2308', '23:08:00', '23', '11', '08', '1388', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2309', '23:09:00', '23', '11', '09', '1389', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2310', '23:10:00', '23', '11', '10', '1390', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2311', '23:11:00', '23', '11', '11', '1391', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2312', '23:12:00', '23', '11', '12', '1392', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2313', '23:13:00', '23', '11', '13', '1393', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2314', '23:14:00', '23', '11', '14', '1394', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2315', '23:15:00', '23', '11', '15', '1395', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2316', '23:16:00', '23', '11', '16', '1396', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2317', '23:17:00', '23', '11', '17', '1397', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2318', '23:18:00', '23', '11', '18', '1398', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2319', '23:19:00', '23', '11', '19', '1399', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2320', '23:20:00', '23', '11', '20', '1400', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2321', '23:21:00', '23', '11', '21', '1401', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2322', '23:22:00', '23', '11', '22', '1402', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2323', '23:23:00', '23', '11', '23', '1403', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2324', '23:24:00', '23', '11', '24', '1404', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2325', '23:25:00', '23', '11', '25', '1405', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2326', '23:26:00', '23', '11', '26', '1406', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2327', '23:27:00', '23', '11', '27', '1407', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2328', '23:28:00', '23', '11', '28', '1408', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2329', '23:29:00', '23', '11', '29', '1409', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2330', '23:30:00', '23', '11', '30', '1410', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2331', '23:31:00', '23', '11', '31', '1411', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2332', '23:32:00', '23', '11', '32', '1412', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2333', '23:33:00', '23', '11', '33', '1413', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2334', '23:34:00', '23', '11', '34', '1414', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2335', '23:35:00', '23', '11', '35', '1415', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2336', '23:36:00', '23', '11', '36', '1416', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2337', '23:37:00', '23', '11', '37', '1417', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2338', '23:38:00', '23', '11', '38', '1418', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2339', '23:39:00', '23', '11', '39', '1419', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2340', '23:40:00', '23', '11', '40', '1420', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2341', '23:41:00', '23', '11', '41', '1421', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2342', '23:42:00', '23', '11', '42', '1422', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2343', '23:43:00', '23', '11', '43', '1423', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2344', '23:44:00', '23', '11', '44', '1424', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2345', '23:45:00', '23', '11', '45', '1425', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2346', '23:46:00', '23', '11', '46', '1426', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2347', '23:47:00', '23', '11', '47', '1427', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2348', '23:48:00', '23', '11', '48', '1428', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2349', '23:49:00', '23', '11', '49', '1429', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2350', '23:50:00', '23', '11', '50', '1430', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2351', '23:51:00', '23', '11', '51', '1431', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2352', '23:52:00', '23', '11', '52', '1432', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2353', '23:53:00', '23', '11', '53', '1433', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2354', '23:54:00', '23', '11', '54', '1434', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2355', '23:55:00', '23', '11', '55', '1435', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2356', '23:56:00', '23', '11', '56', '1436', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2357', '23:57:00', '23', '11', '57', '1437', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2358', '23:58:00', '23', '11', '58', '1438', 'PM', 'Night');
INSERT INTO dim_time (time_id, time_actual, hours_24, hours_12, hour_minutes, day_minutes, day_time_name, day_night) VALUES ('2359', '23:59:00', '23', '11', '59', '1439', 'PM', 'Night');

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";


CREATE TABLE public.dim_term_code (
    term_code_id  uuid DEFAULT uuid_generate_v4() NOT NULL UNIQUE,
    term_code character varying(255));
  
CREATE TABLE public.dim_stock_symbol (
    stock_symbol_id uuid DEFAULT uuid_generate_v4() NOT NULL UNIQUE,
    stock_symbol character varying(255));
  

CREATE TABLE public.dim_company (
    company_id uuid DEFAULT uuid_generate_v4() NOT NULL UNIQUE,
    company_nk_id integer NOT NULL,
    object_id character varying(255),
    description text,
    region character varying(255),
    address1 text,
    address2 text,
    city character varying(255),
    zip_code character varying(200),
    state_code character varying(255),
    country_code character varying(255),
    latitude numeric(9,6),
    longitude numeric(9,6),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE public.dim_people (
    people_id uuid DEFAULT uuid_generate_v4() NOT NULL UNIQUE,
    people_nk_id integer NOT NULL,
    object_id character varying(255),
    first_name character varying(255),
    last_name character varying(255),
    birthplace character varying(255),
    affiliation_name character varying(255)
);



CREATE TABLE public.fct_acquisition (
    acquisition_id uuid DEFAULT uuid_generate_v4() NOT NULL UNIQUE,
    acquisition_nk_id integer NOT NULL,
    acquiring_object_id uuid,
    acquired_object_id uuid,
    term_code_id uuid,
    price_amount numeric(15,2),
    price_currency_code character varying(3),
    acquired_at int,
    source_url text,
    source_description text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE public.fct_funds (
    fund_id uuid DEFAULT uuid_generate_v4() NOT NULL UNIQUE,
    fund_nk_id character varying(255) NOT NULL,
    object_id uuid,
    name character varying(255),
    funded_at int,
    raised_amount numeric(15,2),
    raised_currency_code character varying(3),
    source_url text,
    source_description text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE public.fct_funding_rounds (
    funding_round_id  uuid DEFAULT uuid_generate_v4() NOT NULL UNIQUE,
    funding_round_nk_id integer NOT NULL,
    object_id uuid,
    funded_at int,
    funding_round_type character varying(255),
    funding_round_code character varying(255),
    raised_amount_usd numeric(15,2),
    raised_amount numeric(15,2),
    raised_currency_code character varying(255),
    pre_money_valuation_usd numeric(15,2),
    pre_money_valuation numeric(15,2),
    pre_money_currency_code character varying(255),
    post_money_valuation_usd numeric(15,2),
    post_money_valuation numeric(15,2),
    post_money_currency_code character varying(255),
    participants text,
    is_first_round boolean,
    is_last_round boolean,
    source_url text,
    source_description text,
    created_by character varying(255),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE public.fct_investments (
    investment_id uuid DEFAULT uuid_generate_v4() NOT NULL UNIQUE,  
    investment_nk_id integer NOT NULL,
    funding_round_id uuid,
    funded_object_id uuid,
    investor_object_id uuid,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE public.fct_ipos (
    ipo_id  uuid DEFAULT uuid_generate_v4() NOT NULL UNIQUE,
    ipo_nk_id character varying(255) NOT NULL,
    object_id uuid,
    valuation_amount numeric(15,2),
    valuation_currency_code character varying(3),
    raised_amount numeric(15,2),
    raised_currency_code character varying(3),
    public_at int,
    stock_symbol uuid,
    source_url text,
    source_description text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE public.fct_person_relationship (
    person_relationship_id uuid DEFAULT uuid_generate_v4() NOT NULL UNIQUE,  
    relationship_nk_id integer NOT NULL,
    people_id uuid,
    relationship_object_id uuid,
    start_at int,
    end_at int,
    is_past boolean,   
    "sequence" character varying(300),
    title character varying(300),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);
    
--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;


--
-- PostgreSQL database dump complete
--

ALTER TABLE ONLY public.fct_acquisition
    ADD CONSTRAINT acquisition_fk FOREIGN KEY (acquiring_object_id) REFERENCES public.dim_company(company_id);


ALTER TABLE ONLY public.fct_acquisition
    ADD CONSTRAINT acquisition_fk_2 FOREIGN KEY (acquired_object_id) REFERENCES public.dim_company(company_id);

ALTER TABLE ONLY public.fct_acquisition
    ADD CONSTRAINT acquisition_fk_3 FOREIGN KEY (term_code_id) REFERENCES public.dim_term_code(term_code_id);

ALTER TABLE ONLY public.fct_acquisition
    ADD CONSTRAINT acquisition_fk_4 FOREIGN KEY (acquired_at) REFERENCES public.dim_date(date_id);

ALTER TABLE ONLY public.fct_funds
    ADD CONSTRAINT funds_fk FOREIGN KEY (object_id) REFERENCES public.dim_company(company_id);


ALTER TABLE ONLY public.fct_funds
    ADD CONSTRAINT funds_fk_2 FOREIGN KEY (funded_at) REFERENCES public.dim_date(date_id);

ALTER TABLE ONLY public.fct_funding_rounds
    ADD CONSTRAINT fund_rounds_fk FOREIGN KEY (object_id) REFERENCES public.dim_company(company_id);


ALTER TABLE ONLY public.fct_funding_rounds
    ADD CONSTRAINT fund_rounds_fk_2 FOREIGN KEY (funded_at) REFERENCES public.dim_date(date_id);

ALTER TABLE ONLY public.fct_ipos
    ADD CONSTRAINT ipos_fk FOREIGN KEY (object_id) REFERENCES public.dim_company(company_id);


ALTER TABLE ONLY public.fct_ipos
    ADD CONSTRAINT ipos_2 FOREIGN KEY (public_at) REFERENCES public.dim_date(date_id);

ALTER TABLE ONLY public.fct_ipos
    ADD CONSTRAINT ipos_3 FOREIGN KEY (stock_symbol) REFERENCES public.dim_stock_symbol(stock_symbol_id);

ALTER TABLE ONLY public.fct_investments
    ADD CONSTRAINT investments_fk FOREIGN KEY (funded_object_id) REFERENCES public.dim_company(company_id);


ALTER TABLE ONLY public.fct_investments
    ADD CONSTRAINT investments_fk_2 FOREIGN KEY (investor_object_id) REFERENCES public.dim_company(company_id);

ALTER TABLE ONLY public.fct_investments
    ADD CONSTRAINT investments_fk_3 FOREIGN KEY (funding_round_id) REFERENCES public.fct_funding_rounds(funding_round_id);

ALTER TABLE ONLY public.fct_person_relationship
    ADD CONSTRAINT person_rl_fk FOREIGN KEY (people_id) REFERENCES public.dim_people(people_id);


ALTER TABLE ONLY public.fct_person_relationship
    ADD CONSTRAINT person_rl_fk_2 FOREIGN KEY (relationship_object_id) REFERENCES public.dim_company(company_id);


ALTER TABLE ONLY public.fct_person_relationship
    ADD CONSTRAINT person_rl_fk_4 FOREIGN KEY (start_at) REFERENCES public.dim_date(date_id);


ALTER TABLE ONLY public.fct_person_relationship
    ADD CONSTRAINT person_rl_fk_5 FOREIGN KEY (end_at) REFERENCES public.dim_date(date_id);
