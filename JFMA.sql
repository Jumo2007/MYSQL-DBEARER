CREATE DATABASE IF NOT EXISTS hospital_salud
	CHARACTER SET utf8mb4
	COLLATE utf8mb4_unicode_ci;
USE hospital_salud;

CREATE TABLE Medico (
	cod_med INT(10) NOT NULL,
	nombre_comp_med VARCHAR (100) NOT NULL,
	type_med VARCHAR (25) NOT NULL,
	Special_med VARCHAR (30) NOT NULL,
	Day_med VARCHAR (10) NOT NULL,
	hor_med VARCHAR(400) NOT NULL,
	CONSTRAINT pk_med PRIMARY KEY (cod_med)
	);

CREATE TABLE Sustituciones (
	cod_sus  INT (20) NOT NULL,
	nombre_comp_sus VARCHAR (100) NOT NULL,
	med_sus VARCHAR (100) NOT NULL,
	hor_sus VARCHAR (40) NOT NULL,
	start_sus VARCHAR (30) NOT NULL,
	end_sus VARCHAR (30) NOT NULL,
	CONSTRAINT pk_sus PRIMARY KEY (cod_sus)
	);
	
CREATE TABLE Empleados (
	cod_emp INT (20) NOT NULL,
	nombre_comp_emp VARCHAR (100) NOT NULL,
	hor_emp VARCHAR (40) NOT NULL,
	cargo_emp VARCHAR (60) ONLY ATS, auxiliar_enfermeria, null,
	CONSTRAINT pk_emp PRIMARY KEY (cod_emp)
	);
	
CREATE TABLE Pacientes (
cod_pac INT (20) NOT NULL,
nombre_comp_pac VARCHAR (100) NOT NULL,
nac_pac VARCHAR (25) NOT NULL,
tel_pac VARCHAR (25) NOT NULL,
med_pac VARCHAR (100) NOT NULL,
CONSTRAINT pk_pac PRIMARY KEY (cod_pac)
);

 CREATE TABLE Vacaciones (
 cmed_vac INT (20) NOT NULL,
 cemp_vac INT (20) NOT NULL,
 start_vac VARCHAR (30) NOT NULL,
 end_vac VARCHAR (30) NOT NULL,
 est_vac VARCHAR (25) ONLY PLANIFICADA, TERMINADA, null,
 CONSTRAINT ṕk_vac PRIMARY KEY (cmed_vac, cemp_vac)
 );
create table Consultas (
time_cons VARCHAR (50) NOT NULL,
sit_cons VARCHAR (50) NOT NULL,



)
 