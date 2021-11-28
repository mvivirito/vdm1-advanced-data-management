Create or replace function family_friendly (rating mpaa_rating)
returns varchar
Language plpgsql
as
$$
Declare
 friendly varchar;
	Begin
	
	 if rating = 'R' then
		 friendly := 'No';
	 elseif rating = 'NC-17' then
		 friendly := 'No';
	 else 
		 friendly := 'Yes';
	 end if;
	
	return friendly;
End;
$$;