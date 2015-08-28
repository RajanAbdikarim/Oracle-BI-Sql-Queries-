DELETE FROM prykazy;

/*
CREATE TABLE `prykazy` (
	`BU` VARCHAR(4) NOT NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
	`ASSIGNMENT_ID` VARCHAR(15) NOT NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
	`JOB_ID` VARCHAR(14) NOT NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
	`JOB_NAME` VARCHAR(255) NOT NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
	`DEPARTMENT_ID` VARCHAR(19) NOT NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
	`DEPARTMENT_NAME` VARCHAR(255) NOT NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
	`КодПриказа` INT(11) NOT NULL DEFAULT '0',
	`КодОрганизации` INT(11) NOT NULL DEFAULT '0',
	`ГруппаПриказа` INT(11) NOT NULL DEFAULT '0',
	`КодСтатьи1` INT(11) NULL DEFAULT NULL,
	`КодСтатьи2` INT(11) NULL DEFAULT NULL,
	`КодСотрудника` INT(11) NULL DEFAULT NULL,
	`КодДолжности` INT(11) NULL DEFAULT NULL,
	`Дата` DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00',
	`Номер` VARCHAR(20) NOT NULL DEFAULT '',
	`КодОсновного` INT(11) NULL DEFAULT NULL,
	`Содержание` LONGTEXT NULL,
	`СодержаниеАнгл` LONGTEXT NULL,
	`СодержаниеКаз` LONGTEXT NULL,
	`Основание` VARCHAR(250) NULL DEFAULT NULL,
	`ОснованиеАнгл` VARCHAR(250) NULL DEFAULT NULL,
	`ОснованиеКаз` VARCHAR(250) NULL DEFAULT NULL,
	`ЗарПлата` INT(11) NULL DEFAULT NULL,
	`Продолжительность` DECIMAL(19,4) NULL DEFAULT NULL,
	`ДатаНач` DATETIME NULL DEFAULT NULL,
	`ДатаКон` DATETIME NULL DEFAULT NULL,
	`ВСиле` INT(11) NOT NULL DEFAULT '0',
	`КодРуководителя` INT(11) NULL DEFAULT NULL,
	`ВнеприказнойУчет` TINYINT(4) NULL DEFAULT NULL,
	`Исполнитель` VARCHAR(50) NULL DEFAULT NULL,
	`Согласование` LONGTEXT NULL,
	`Согласование1` LONGTEXT NULL,
	`КодДолжностиДоп` INT(11) NULL DEFAULT NULL,
	`ДатаИспСрокДо` DATETIME NULL DEFAULT NULL,
	`КемОтстранен` VARCHAR(150) NULL DEFAULT NULL,
	`КемРассмотренТрудСпор` VARCHAR(150) NULL DEFAULT NULL,
	`КодПрОНезаконномДействии` INT(11) NULL DEFAULT NULL,
	`КодИТД` INT(11) NULL DEFAULT NULL,
	`ЗарплатаДоДаты` DATETIME NULL DEFAULT NULL,
	`ДолжнИнструкции` TINYINT(4) NULL DEFAULT NULL,
	`ЦельКомандировки` INT(11) NULL DEFAULT NULL,
	`КодПроекта` INT(11) NULL DEFAULT NULL,
	`ДатаОтзыва` DATETIME NULL DEFAULT NULL,
	`Маршрут` VARCHAR(255) NULL DEFAULT NULL,
	`ДатаВыдачиКомУдост` DATETIME NULL DEFAULT NULL,
	`НомерКомУдост` VARCHAR(50) NULL DEFAULT NULL,
	`ОсталосьДнейОтпуска` DECIMAL(19,4) NULL DEFAULT NULL,
	`ПериодНач` DATETIME NULL DEFAULT NULL,
	`ПериодКон` DATETIME NULL DEFAULT NULL,
	`ДопДнейОтпуска` DECIMAL(19,4) NULL DEFAULT NULL,
	`ОсталосьДопДнейОтпуска` DECIMAL(19,4) NULL DEFAULT NULL,
	`ЗарплатаУЕ` INT(11) NULL DEFAULT NULL,
	`МаршрутАнгл` VARCHAR(255) NULL DEFAULT NULL,
	`PERSON_ID` BIGINT(20) UNSIGNED NULL DEFAULT NULL
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;*/


CREATE TABLE prykazy AS (
SELECT T.* FROM(
SELECT KTG.* FROM (
select
'KTG' as BU,
 concat('KTG',
`П`.`КодПриказа`) AS `ASSIGNMENT_ID`,
`ДЖ`.`Наименование` AS `JOB_NAME`,
`ПД`.`Наименование` AS `DEPARTMENT_NAME`,
CONCAT('JOB_',CRC32(UPPER(TRIM(ДЖ.`Наименование`)))) as JOB_ID,
CONCAT('KTG_DEP_',CRC32(UPPER(TRIM(ПД.`Наименование`)))) as DEPARTMENT_ID,
П.*,
CRC32(UPPER(trim(`С`.`ФИО`))) AS `PERSON_ID` from (`kontrotenko_ktg`.`Приказы` `П` join `kontrotenko_ktg`.`Сотрудники` `С` on((`П`.`КодСотрудника` = `С`.`КодСотрудника`))) 
JOIN kontrotenko_ktg.`Должности` ДЖ ON П.`КодДолжности`=ДЖ.`КодДолжности`
JOIN kontrotenko_ktg.`Подразделения` ПД ON ДЖ.`КодПодразделения`=ПД.`КодПодразделения`
WHERE  П.ГруппаПриказа IN(1,2,3)
ORDER BY П.Дата
) KTG
union all 
SELECT KTGA.* FROM (
select
'KTGA' as BU,
 concat('KTGA',
`П`.`КодПриказа`) AS `ASSIGNMENT_ID`,
`ДЖ`.`Наименование` AS `JOB_NAME`,
`ПД`.`Наименование` AS `DEPARTMENT_NAME`,
CONCAT('JOB_',CRC32(UPPER(TRIM(ДЖ.`Наименование`)))) as JOB_ID,
CONCAT('KTGA_DEP_',CRC32(UPPER(TRIM(ПД.`Наименование`)))) as DEPARTMENT_ID,
П.*,
CRC32(UPPER(trim(`С`.`ФИО`))) AS `PERSON_ID` from (`kontrotenko_ktga`.`Приказы` `П` join `kontrotenko_ktga`.`Сотрудники` `С` on((`П`.`КодСотрудника` = `С`.`КодСотрудника`)))
JOIN kontrotenko_ktga.`Должности` ДЖ ON П.`КодДолжности`=ДЖ.`КодДолжности`
JOIN kontrotenko_ktga.`Подразделения` ПД ON ДЖ.`КодПодразделения`=ПД.`КодПодразделения`
WHERE  П.ГруппаПриказа IN(1,2,3)
ORDER BY П.Дата)
KTGA
) T
ORDER BY T.Дата
)