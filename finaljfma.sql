CREATE DATABASE IF NOT EXISTS hospital_salud
	CHARACTER SET utf8mb4
	COLLATE utf8mb4_unicode_ci;

USE hospital_salud;

CREATE TABLE Medico (
	cod_med INT NOT NULL AUTO_INCREMENT,
	nombre_comp_med VARCHAR(100) NOT NULL,
	type_med VARCHAR(25) NOT NULL,
	Special_med VARCHAR(30) NOT NULL,
	CONSTRAINT pk_med PRIMARY KEY (cod_med),
	CONSTRAINT ck_type_med CHECK (type_med IN ('Titular','Interino','Sustituto'))
	);

CREATE TABLE Horario_Medico (
	cod_horario INT NOT NULL AUTO_INCREMENT,
	cod_med INT NOT NULL,
	Day_med VARCHAR(10) NOT NULL,
	hora_ini_med TIME NOT NULL,
	hora_fin_med TIME NOT NULL,
	CONSTRAINT pk_horario PRIMARY KEY (cod_horario),
	CONSTRAINT fk_horario_med FOREIGN KEY (cod_med) REFERENCES Medico(cod_med)
	);

CREATE TABLE Sustituciones (
	cod_sus INT NOT NULL AUTO_INCREMENT,
	cod_med_titular INT NOT NULL,
	cod_med_sustituto INT NOT NULL,
	start_sus DATE NOT NULL,
	end_sus DATE NOT NULL,
	CONSTRAINT pk_sus PRIMARY KEY (cod_sus),
	CONSTRAINT fk_sus_titular FOREIGN KEY (cod_med_titular) REFERENCES Medico(cod_med),
	CONSTRAINT fk_sus_sustituto FOREIGN KEY (cod_med_sustituto) REFERENCES Medico(cod_med)
	);

CREATE TABLE Empleados (
	cod_emp INT NOT NULL AUTO_INCREMENT,
	nombre_comp_emp VARCHAR(100) NOT NULL,
	hor_emp VARCHAR(40) NOT NULL,
	cargo_emp VARCHAR(60) NOT NULL,
	CONSTRAINT pk_emp PRIMARY KEY (cod_emp),
	CONSTRAINT ck_cargo_emp CHECK (cargo_emp IN ('ATS','auxiliar_enfermeria'))
	);

CREATE TABLE Pacientes (
	cod_pac INT NOT NULL AUTO_INCREMENT,
	nombre_comp_pac VARCHAR(100) NOT NULL,
	nac_pac VARCHAR(25) NOT NULL,
	tel_pac VARCHAR(25) NOT NULL,
	cod_med INT NOT NULL,
	CONSTRAINT pk_pac PRIMARY KEY (cod_pac),
	CONSTRAINT fk_pac_med FOREIGN KEY (cod_med) REFERENCES Medico(cod_med)
	);

CREATE TABLE Vacaciones (
	cod_vac INT NOT NULL AUTO_INCREMENT,
	cmed_vac INT NULL,
	cemp_vac INT NULL,
	start_vac DATE NOT NULL,
	end_vac DATE NOT NULL,
	est_vac VARCHAR(25) NOT NULL,
	CONSTRAINT pk_vac PRIMARY KEY (cod_vac),
	CONSTRAINT fk_vac_med FOREIGN KEY (cmed_vac) REFERENCES Medico(cod_med),
	CONSTRAINT fk_vac_emp FOREIGN KEY (cemp_vac) REFERENCES Empleados(cod_emp),
	CONSTRAINT ck_est_vac CHECK (est_vac IN ('PLANIFICADA','TERMINADA'))
	);

CREATE TABLE Consultas (
	cod_cons INT NOT NULL AUTO_INCREMENT,
	cod_med INT NOT NULL,
	cod_pac INT NOT NULL,
	fecha_cons DATE NOT NULL,
	dia_cons VARCHAR(10) NOT NULL,
	hora_ini_cons TIME NOT NULL,
	hora_fin_cons TIME NOT NULL,
	CONSTRAINT pk_cons PRIMARY KEY (cod_cons),
	CONSTRAINT fk_cons_med FOREIGN KEY (cod_med) REFERENCES Medico(cod_med),
	CONSTRAINT fk_cons_pac FOREIGN KEY (cod_pac) REFERENCES Pacientes(cod_pac)
	);


SELECT m.cod_med, m.nombre_comp_med, COUNT(DISTINCT c.cod_pac) AS pacientes_atendidos
FROM Medico m
JOIN Consultas c ON m.cod_med = c.cod_med
GROUP BY m.cod_med, m.nombre_comp_med;


SELECT COUNT(DISTINCT cod_med_titular) AS medicos_en_sustitucion
FROM Sustituciones
WHERE CURDATE() BETWEEN start_sus AND end_sus;


SELECT e.cod_emp, e.nombre_comp_emp,
       SUM(DATEDIFF(v.end_vac, v.start_vac) + 1) AS dias_disfrutados
FROM Empleados e
JOIN Vacaciones v ON e.cod_emp = v.cemp_vac
WHERE v.est_vac = 'TERMINADA'
GROUP BY e.cod_emp, e.nombre_comp_emp
HAVING dias_disfrutados > 10;


SELECT cod_med, SUM(TIME_TO_SEC(TIMEDIFF(hora_fin_med, hora_ini_med)) / 3600) AS horas_semana
FROM Horario_Medico
GROUP BY cod_med
ORDER BY horas_semana DESC;


SELECT cod_med, Day_med, SUM(TIME_TO_SEC(TIMEDIFF(hora_fin_med, hora_ini_med)) / 3600) AS horas_dia
FROM Horario_Medico
GROUP BY cod_med, Day_med
ORDER BY cod_med, Day_med;


SELECT cod_med_sustituto, COUNT(*) AS num_sustituciones
FROM Sustituciones
GROUP BY cod_med_sustituto;


SELECT m.cod_med, m.nombre_comp_med,
       COUNT(DISTINCT c.cod_pac) AS num_pacientes,
       SUM(TIME_TO_SEC(TIMEDIFF(h.hora_fin_med, h.hora_ini_med)) / 3600) AS horas_semana
FROM Medico m
JOIN Consultas c ON m.cod_med = c.cod_med
JOIN Horario_Medico h ON m.cod_med = h.cod_med
GROUP BY m.cod_med, m.nombre_comp_med
HAVING num_pacientes > 5;
)
 