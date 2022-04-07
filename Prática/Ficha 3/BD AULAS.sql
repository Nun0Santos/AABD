

--Ex2
Create Table ERROS(
  cod_error number(10),
  message varchar2(250),
  data_erro date
);

--Ex3
Create or replace Procedure F03_Ex04(codigoLivro in NUMBER)
IS
  CODA NUMBER; 
  n NUMBER;
BEGIN
    SELECT COUNT(*) INTO N
    FROM LIVROS
    WHERE CODIGO_LIVRO = codigoLivro;
    IF N > 0 THEN 
      SELECT CODIGO_AUTOR INTO CODA
      FROM LIVROS
      WHERE CODIGO_LIVRO = codigoLivro;
      IF CODA = 17 THEN
      --SE EXISTIR O 80
        SELECT COUNT(*) INTO N  
        FROM AUTORES WHERE CODIGO_AUTOR = 80;
        IF N = 0 THEN
          INSERT INTO AUTORES VALUES (80, 'Luis Moreno Campos', 23432432, 'Lisboa', NULL,'M','Portuguesa','Informática');
        END IF;
      UPDATE LIVROS SET CODIGO_AUTOR = 80 WHERE CODIGO_LIVRO = codigoLivro;
      END IF;
    END IF;
END;
/
--SHOW ERRORS
exec F03_Ex04(6);
exec F03_Ex04(10);

--Ex4
Create or replace Procedure F03_Ex04(codigoLivro in NUMBER)
IS
  CODA NUMBER; 
  n NUMBER;
  CODE NUMBER;
  MSG  ERROS.MESSAGE%TYPE;
BEGIN
      SELECT CODIGO_AUTOR INTO CODA
      FROM LIVROS
      WHERE CODIGO_LIVRO = codigoLivro;
      
      IF CODA = 17 THEN
        BEGIN
          INSERT INTO AUTORES VALUES (80, 'Luis Moreno Campos', 23432432, 
          'Lisboa', NULL,'M','Portuguesa','Informática');
        EXCEPTION
             When DUP_VAL_ON_INDEX THEN NULL;
             DBMS_OUTPUT.PUT_LINE('O autor 80 já existe');
              CODE := SQLCODE; MSG := SQLERRM;
             INSERT INTO ERROS VALUES(CODE,MSG,SYSDATE);
        END;
        
        UPDATE LIVROS SET CODIGO_AUTOR = 80 
        WHERE CODIGO_LIVRO = codigoLivro;
       END IF;
EXCEPTION
      When NO_DATA_FOUND  THEN NULL;
      DBMS_OUTPUT.PUT_LINE('O livro existe!');
      CODE := SQLCODE; MSG := SQLERRM;
      INSERT INTO ERROS VALUES(CODE,MSG,SYSDATE);
END;
/
--SHOW ERRORS
exec F03_Ex04(5);
select * from livros where codigo_autor =17;
select * from livros where codigo_autor =80;
select * from erros;

--Ex5
Create or replace Procedure F03_Ex06(valor in Livros.Quant_em_stock%type)

IS
  Cursor c1 IS
    Select titulo, preco_tabela, Quant_em_stock
    From Livros
    where  Quant_em_stock > valor;
    
  
BEGIN
    for r in c1
    Loop
          Insert into TEMP values(r.preco_tabela, r.Quant_em_stock, r.titulo);
    End loop;
EXCEPTION
     When others THEN NULL;
      DBMS_OUTPUT.PUT_LINE('erro');
END;
/
--show erros
exec F03_Ex06(24);
select * from temp;
delete from temp;
select titulo, preco_tabela, quant_em_stock from livros;


--Ex6
Create or replace Function F03_Ex07(codLivro NUMBER ) RETURN NUMBER

IS
Cursor c1 IS
    Select codigo_livro,preco_tabela
    From Livros
    where  codigo_livro = codLivro;
    
BEGIN
  for r in c1
  Loop
          return  r.preco_tabela;
  End Loop;
  RAISE_APPLICATION_ERROR(-20010,'Código de livro inexistente.'); 

END;
/
/*
Create or replace Function F03_Ex07(codLivro NUMBER ) RETURN NUMBER

IS
    PRECO LIVROS.PRECO_TABELA%TYPE;
BEGIN
    Select preco_tabela into preco
    From Livros
    where  codigo_livro = codLivro;
    return preco;
    
EXCEPTION
  When NO_DATA_FOUND Then
    RAISE_APPLICATION_ERROR(-20010,'Código de livro inexistente.');       
END;
/
*/

select  F03_Ex07(500)
from dual;

select * from livros where codigo_livro = 2;

--Ex7
Create or Replace Function F03_Ex08(codAutor in Number) Return varchar2

IS
  Cursor c1 is
      Select nome
      From AUTORES
      Where Codigo_Autor = codAutor;

BEGIN
    for r in c1
    Loop
        return (SUBSTR(r.NOME, 1, INSTR(r.NOME, ' ')-1));
    End Loop;
    RAISE_APPLICATION_ERROR(-20302,'Código de autor inexistente.');

END;
/

select F03_Ex08(1)
From Dual;
Select * from autores;

--Ex8
/*Create or Replace Function F03_Ex09(codAutor in Number) Return number
IS
  Cursor c1 is
      Select codigo_livro
      From Livros, Autores
      Where Livros.Codigo_Autor = Autores.Codigo_Autor and 
            Livros.codigo_Autor = codAutor;

BEGIN
    for r in c1
    Loop
        return (count( r.Codigo_livro));
    End Loop;
    RAISE_APPLICATION_ERROR(-20304,'O autor com o código ' || codAutor || ' não escreveu livros');

END;
/*/

----------------------------
--Ex8
Create or Replace Function F03_Ex09(codAutor in Number) Return number
IS
 contador Autores.Codigo_Autor%TYPE;
 
BEGIN
     Select count(codigo_livro) into contador
     From Livros, Autores
     Where Livros.Codigo_Autor = Autores.Codigo_Autor and 
           Livros.codigo_Autor = codAutor;
    if contador = 0 then
      RAISE_APPLICATION_ERROR(-20304,'O autor com o código ' || codAutor || ' não escreveu livros');
    end if;
    return contador;
END;
/
select F03_Ex09(80) from dual;

--Ex9
Create or Replace Procedure F03_Ex10(codAutorX in Number, codAutorY in Number)
IS
  i number;
Begin
    if CodAutorX > codAutorY then
      for i in codAutorX..codAutorY
      Loop
          Insert into temp values(i,F03_Ex09(i),F03_Ex08(i));
      End Loop;
    End if;
    
    RAISE_APPLICATION_ERROR(-20305,'O primeiro valor tem que ser superior ao segundo!');
End;
/
show erros
exec F03_Ex10(1,18);
delete temp;
select * from temp;







