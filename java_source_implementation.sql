declare

code varchar2(4000);
  r varchar2(4000);
   
begin
   SELECT csmLogin() into code FROM   dual;
   --DBMS_OUTPUT.put_line(code);
     r := utl_raw.cast_to_varchar2(utl_encode.base64_decode(utl_raw.cast_to_raw(code)));
  -- DBMS_OUTPUT.put_line(r);
   --utl_raw.cast_to_varchar2(utl_encode.base64_encode(utl_raw.cast_to_raw(code)))
end;

