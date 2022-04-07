--FICHA 4

--Ex2
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
select F03_Ex08(100)
From Dual;

--Ex3
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
select F03_Ex09(800) from dual;

--Ex4
Create or Replace Procedure F03_Ex10(codAutorX in Number, codAutorY in Number)
IS
  i number;
  Ex8 Exception;
  PRAGMA EXCEPTION_INIT(Ex8, -20302);
  
  Ex9 Exception;
  PRAGMA EXCEPTION_INIT(Ex9, -20304);
Begin
    if CodAutorX < codAutorY then
      for i in codAutorX..codAutorY
      Loop
          BEGIN
              Insert into temp values(i,F03_Ex09(i),F03_Ex08(i));
          EXCEPTION 
              When Ex8 then
                 DBMS_OUTPUT.PUT_LINE('Apanhou exceção da função 8');
              When Ex9 then
                  DBMS_OUTPUT.PUT_LINE('Apanhou exceção da função 9');
          END;
      End Loop;
    else
        RAISE_APPLICATION_ERROR(-20305,'O primeiro valor tem que ser inferior ao segundo!');
    End if; 
End;
/
exec F03_Ex10(1,8);
delete temp;
select * from temp;

--Ex5
Create or Replace Procedure F04_Ex11
IS
    /*Cursor c1 is
      Select  count(codigo_livro) as totalLivro, sum(preco_tabela) as precoTabela, 
      genero as gen
      from livros
      group by genero;
      
      totalLivro Livros.Codigo_Livro%type;
      precoTabela Livros.preco_tabela%type;
      gen Livros.genero%type;*/
  
Begin
    delete temp;
    
    insert into temp(col2, col1, message)
        Select  count(codigo_livro) as totalLivro, sum(preco_tabela) as precoTabela, 
        genero as gen
        from livros
        group by genero;
    
    /*for r in c1
    Loop
        Insert into temp values (r.precoTabela,r.totalLivro,r.gen);
      End Loop;*/
End;
/

Exec F04_Ex11();
delete temp;
select * from temp;

--Ex6
Create or Replace trigger F04_EX12
    After delete or insert or update of genero, preco_tabela 
    on livros
    for each row   
Begin
      if  updating ('Preco_tabela') then 
         Update temp set  col1 = col1 - :OLD.preco_tabela + :NEW.Preco_tabela
         Where message = :OLD.genero;
      
      ELSE
         if deleting or updating then
              Update temp set col2 = col2 - 1, 
                           col1 = col1 - :OLD.preco_tabela
              Where message = :OLD.genero;
        End if;
        
        if inserting or updating then
             Update temp set col2 = col2 + 1, 
                         col1 = col1 + :New.preco_tabela
              Where message = :New.genero;
        End if;
      END IF;
End;
/
select * from temp;
delete from livros where codigo_livro > 11;
rollback;

--Ex7
Create or Replace Trigger F04_EX13
  After Delete on autores
  for each row
  
Begin
    Delete from livros where Codigo_autor = :Old.Codigo_Autor;
End;
/

delete from autores where codigo_autor = 4;
select * from livros where codigo_autor = 4;

--Ex8
Create or Replace Trigger F05_EX11
  After INSERT on vendas
  for each row
  
Begin
      Update livros 
      set Quant_Em_Stock = Quant_Em_Stock - :NEW.Quantidade
      Where Codigo_livro = :New.Codigo_livro;
End;
/
insert into vendas values (99,sysdate,1,1,10,3,0);
select * from vendas;
select * from livros where codigo_livro =1; --23

