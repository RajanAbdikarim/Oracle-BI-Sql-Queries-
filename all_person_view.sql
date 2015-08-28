CREATE TABLE kontrotenko_ktg.allperson AS (
SELECT P.* FROM(
SELECT С.`КодСотрудника`, С.`ФИО`, CRC32(UPPER(TRIM(С.ФИО))) as PERSON_ID FROM kontrotenko_ktg.`Сотрудники` С
UNION ALL
SELECT С.`КодСотрудника`, С.`ФИО`, CRC32(UPPER(TRIM(С.ФИО))) as PERSON_ID FROM kontrotenko_ktga.`Сотрудники` С
) P GROUP BY P.PERSON_ID)