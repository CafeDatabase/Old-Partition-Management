create or replace procedure manage_old_partitions (v_owner varchar2, v_table varchar2, v_date date, v_operation varchar2 default 'drop')
is 
   v_texto varchar2(32000);
   v_mascara varchar2(32000);
   var_operation varchar2(32000);
   v_size number;
BEGIN
   v_size:=0;
   dbms_output.enable(1000000);
   if lower(v_operation) not in ('drop','truncate') then var_operation:='drop'; 
   else var_operation:=v_operation;
   end if;
   
   for x in (select partition_name, high_value, blocks 
             from all_tab_partitions where table_owner=v_owner and table_name=v_table)
   loop
        if substr(x.high_value,1,7)='TO_DATE' then
		
        v_texto:=substr(x.high_value,11,19);
		v_mascara:=substr(x.high_value,34,22);
	    -- dbms_output.put_line(' fecha '||v_texto||' mascara '||v_mascara);
	    if to_date(v_texto,v_mascara)<v_date then
		    dbms_output.put_line('--alter table '||v_owner||'.'||v_table||' '||var_operation||' partition '||x.partition_name||'; --> anterior a '||v_date);
			v_size:=v_size+nvl(x.blocks*8,0);
	    end if;
		
		elsif  substr(x.high_value,1,9)='TIMESTAMP' then

        v_texto:=substr(x.high_value,12,19);
		-- dbms_output.put_line(' fecha '||v_texto);
	    if to_date(v_texto,'SYYYY-MM-DD HH24:MI:SS')<v_date then
		    dbms_output.put_line('--alter table '||v_owner||'.'||v_table||' '||var_operation||' partition '||x.partition_name||'; --> anterior a '||v_date);
			
			v_size:=v_size+nvl(x.blocks*8,0);
	    end if;

	    end if;

	end loop;
	
	for x in (select partition_name, subpartition_name, high_value, blocks 
	          from all_tab_subpartitions where table_owner=v_owner and table_name=v_table)
   loop
        if substr(x.high_value,1,7)='TO_DATE' then
		
        v_texto:=substr(x.high_value,11,19);
		v_mascara:=substr(x.high_value,34,22);
	    -- dbms_output.put_line(' fecha '||v_texto||' mascara '||v_mascara);
	    if to_date(v_texto,v_mascara)<v_date then
		    dbms_output.put_line('--alter table '||v_owner||'.'||v_table||' '||var_operation||' subpartition '||x.subpartition_name||'; --> anterior a '||v_date);
			
			v_size:=v_size+nvl(x.blocks*8,0);
	    end if;
		
		elsif  substr(x.high_value,1,9)='TIMESTAMP' then

        v_texto:=substr(x.high_value,12,19);
		-- dbms_output.put_line(' fecha '||v_texto);
	    if to_date(v_texto,'SYYYY-MM-DD HH24:MI:SS')<v_date then
		    dbms_output.put_line('--alter table '||v_owner||'.'||v_table||' '||var_operation||' subpartition '||x.subpartition_name||'; --> anterior a '||v_date);
			
			v_size:=v_size+nvl(x.blocks*8,0);
	    end if;

	    end if;

	end loop;
	dbms_output.put_line('-- Se gestionarían un total de '||to_char(round(v_size/1024))||' MB en total.');
exception
   when no_data_found then
        dbms_output.put_line('La tabla '||v_owner||'.'||v_table||' no está particionada o no existe en el esquema.');
END;
/
