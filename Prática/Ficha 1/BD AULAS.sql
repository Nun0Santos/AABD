--FICHA 1

--2
Create table temp(
  col1 number(10),
  col2 number(20),
  message varchar2(100)
);

EXEC AABDCHECK('QCODE11BULFOEEF'); 

--3
Declare 
  i number;
Begin
  for i in 1..100
    loop
      if mod(i,2) = 0 then
        insert into TEMP (Col1,col2,message) values
        (i,100*i,'Col1 é par');
      else
         insert into TEMP (Col1,col2,message) values
         (i,100*i,'Col1 é impar');
      end if;
    end loop;
End;
/
EXEC AABDCHECK('QCODE12BULFOEEF'); 
select * from temp;


--EX 4
--set serveroutput of
DECLARE

cod_livro LIVROS.CODIGO_LIVRO%TYPE;

cod_autor AUTORES.CODIGO_AUTOR%TYPE;

BEGIN

cod_livro := &cod_livro;

  Select autores.codigo_autor into cod_autor
  from autores,livros 
  where autores.codigo_autor = livros.codigo_autor and livros.codigo_livro = cod_livro;
  
  IF cod_autor = 17 THEN    
    INSERT into AUTORES
    VALUES (80,'Luis Moreno Campos',23432432,'Lisboa',31,'M','Portuguesa','Informatica');
    
    UPDATE LIVROS
    SET codigo_autor = 80
    Where codigo_livro = cod_livro;
  ELSE
   DBMS_OUTPUT.PUT_LINE('Código livro não valido para este exercício');
  END IF;
END;
/












--FICHA 2


--4 5
DECLARE
  CODL NUMBER := &CODIGO_LIVRO;
  CODA NUMBER; n NUMBER;

BEGIN
    SELECT COUNT(*) INTO N
    FROM LIVROS
    WHERE CODIGO_LIVRO = CODL;
    IF N > 0 THEN 
      SELECT CODIGO_AUTOR INTO CODA
      FROM LIVROS
      WHERE CODIGO_LIVRO = CODL;
      IF CODA = 17 THEN
      --SE EXISTIR O 80
        SELECT COUNT(*) INTO N  
        FROM AUTORES WHERE CODIGO_AUTOR = 80;
        IF N = 0 THEN
          INSERT INTO AUORES VALUES (80, 'Luis Moreno Campos', 23432432, 'Lisboa', NULL,'M','Portuguesa','Informática');
        END IF;
      UPDATE LIVROS SET CODIGO_AUTOR = 80 WHERE CODIGO_LIVRO = CODL;
      END IF;
    END IF;
END;
/
EXEC AABDCHECK('QCODE15BULFOEEF'); 

--Ex6

DECLARE
  nlivros NUMBER;
  nlivrospref NUMBER;
  
  CURSOR C2 IS 
    SELECT CODIGO_AUTOR, NOME, GENERO_PREFERIDO
    FROM AUTORES
    WHERE CODIGO_AUTOR BETWEEN 8 AND 14;
    
BEGIN
    FOR R IN C2 --R representa uma linha
    LOOP
      SELECT COUNT(*) into nlivros FROM Livros WHERE codigo_autor = R.Codigo_autor;
     
      SELECT COUNT(*) into nlivrospref FROM Livros
      WHERE CODIGO_AUTOR = R.Codigo_Autor and Genero = R.Genero_Preferido;
      
      INSERT INTO TEMP VALUES (nlivros, nlivrospref, substr(R.NOME, instr(R.nome, ' ',-1) +1));
    END LOOP;
END;
/

select * from temp;

--Ex7

DECLARE
  precoTOTAL NUMBER;
  precoSUp20 NUMBER;
  nPaginas NUMBER;
  
  NLP20 NUMBER := 0;
  NLPAG400 NUMBER := 0;
  TOTAL NUMBER := 0;
  
  CURSOR C1 IS
    SELECT PRECO_TABELA, PAGINAS, FROM LIVROS WHERE upper(Genero) = 'AVENTURA';
  
BEGIN
    /*SELECT SUM(PRECO_TABELA) INTO precoTOTAL FROM Livros Where upper(Genero) = 'AVENTURA';
    
    SELECT COUNT(PRECO_TABELA) INTO precoSUp20 FROM Livros 
    Where upper(Genero) = 'AVENTURA' and Preco_Tabela > 20;
    
    SELECT COUNT(PRECO_TABELA) INTO nPaginas FROM Livros 
    Where upper(Genero) = 'AVENTURA' and Preco_Tabela > 20 and Paginas > 400;*/
    FOR R IN C1
    LOOP
       IF R.PRECO_TABELA > 20 THEN NLP20 := NLP20 + 1;
       END IF;
       
       IF R.PAGINAS > 400 THEN NLPAG400 := NLPAG400 + 1;
       END IF;
       SOMA := SOMA + R.PRECO_TABELA;
       
    END LOOP;
    INSERT INTO TEMP VALUES(NLP20, NLPAG400, 'Total do preço dos livros de Aventura = ' || TOTAL);
  
END;
/

select * from temp;
delete temp;
--Ex9
declare
	--v_codigo_livro livros.codigo_livro%type;
  --v_preco livros.preco_tabela%type;
	cursor c1 is
		select codigo_livro,preco_tabela
		from livros
		where genero in ('Policial','Romance') and preco_tabela<=60
		for update of preco_tabela;
begin
	--open c1;
  FOR X IN C1
	loop
		--fetch c1 into v_codigo_livro,v_preco;
		--exit when c1%notfound;
		if x.preco_tabela<=30 then
			update livros set x.preco_tabela=x.preco_tabela*1.08 
			where current of c1;
		else
			update livros set x.preco_tabela=x.preco_tabela*1.05 
			where current of c1;
		end if;
	end loop;
	--close c1;
end;
/

//Ex 11






