# Old Partition Management
 Package to generate maintenance code for old partitions

This is a small procedure to generate SQL scripts to maintain old partitions based on DATE or TIMESTAMP ranges.
The idea is to run the procedure passing the parameters of owner, table_name, and date you need to keep partitions, and the procedure will output the ALTER TABLE xxxx DROP/TRUNCATE partition statement for all partitions and subpartitions, no matter if the ranges are based on DATE or TIMESTAMP data types.

The steps to generate the SQL maintenance code are:

1- Download file in the database host server and start sqlplus located in the same filesystem.

	partition_management.sql

2- Ensure user has all privileges and all DBA stuff to create the procedure running the script:

	SQL> @partition_management.sql
	
3- Set the serveroutput parameter to enable sqlplus to display output and a proper linesize (200).

	SQL> set serveroutput on
	SQL> set lines 200
	
4- Execute the procedure providing the table owner, table name, date for high value and optionally 'drop' or 'truncate'.
	
	exec manage_old_partitions (TABLE_OWNER,TABLE_NAME,add_months(sysdate,-MONTHS),'drop')
    	
	
	-- SAMPLE OUTPUT --
	
	SQL> exec manage_old_partitions ('LABORATORIO','TEST_PARTICIONADO',add_months(sysdate,-54),'drop')
	alter table LABORATORIO.TEST_PARTICIONADO drop partition P1_TEST_PARTICIONADO_ABRIL_2018; --> before 01/09/18
	alter table LABORATORIO.TEST_PARTICIONADO drop partition P1_TEST_PARTICIONADO_AGOSTO_2018; --> before 01/09/18
	alter table LABORATORIO.TEST_PARTICIONADO drop partition P1_TEST_PARTICIONADO_JULIO_2018; --> before 01/09/18
	alter table LABORATORIO.TEST_PARTICIONADO drop partition P1_TEST_PARTICIONADO_JUNIO_2018; --> before 01/09/18
	alter table LABORATORIO.TEST_PARTICIONADO drop partition P1_TEST_PARTICIONADO_MAYO_2018; --> before 01/09/18
	-- The amount of  8 MB will be released.

	 PL/SQL procedure successfully completed.

	-- SAMPLE OUTPUT --
	
	
5- Once you check the SQL commands are generated properly, just execute them.

SQL> alter table LABORATORIO.TEST_PARTICIONADO drop partition P1_TEST_PARTICIONADO_ABRIL_2018;

Table altered.

SQL> alter table LABORATORIO.TEST_PARTICIONADO drop partition P1_TEST_PARTICIONADO_AGOSTO_2018;

Table altered.

SQL> alter table LABORATORIO.TEST_PARTICIONADO drop partition P1_TEST_PARTICIONADO_JULIO_2018;

Table altered.

SQL> alter table LABORATORIO.TEST_PARTICIONADO drop partition P1_TEST_PARTICIONADO_JUNIO_2018;

Table altered.

SQL> alter table LABORATORIO.TEST_PARTICIONADO drop partition P1_TEST_PARTICIONADO_MAYO_2018;

Table altered.
	
	
	
	
Enjoy!
