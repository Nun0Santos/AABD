--Ficha6

--Ex2
Create or replace Trigger F05_EX15
  After INSERT ON Livros 
  For each Row
Begin
    Update Autores
    Set Genero_preferido = :NEW.Genero
    Where  Autores.Codigo_Autor = :NEW.Codigo_Autor;
End;
/


--Ex3
Create or replace Function F04_EX14(Gen in varchar) 
return varchar 
IS
/*Cursor c1 is
  Select titulo as nomeTitulo
  From livros
  Where Genero = gen and Preco_tabela =(select max(preco_tabela)
                                        From livros
                                        where genero = gen);    */ 
Cursor c1 is
        Select titulo as nomeTitulo
        From Livros
        Where upper(genero) = upper(gen)
        Order by preco_tabela DESC, Data_edicao desc;
Begin
      for r in c1
      Loop
          return r.nomeTitulo;
     End Loop;
  
   RAISE_APPLICATION_ERROR(-20300,'Genero Inexistente');
End;
/
show erros

select F04_EX14('Informática')
From Dual;

--Ex4
drop table Ficha5;
Create table FICHA5(
    num1 number,
    num2 number,
    num3 number,
    num4 number,
    string1 varchar(100),
    string2 varchar(1000)

);

--Ex5
create or replace Procedure F05_EX09
as
Cursor c1 is
      Select Livros.titulo  as titulos, livros.quant_em_stock as quant, max(nvl(soma_mes),0)
      sum(vendas.quantidade) as nVendas,
      sum(vendas.quantidade*livros.preco_tabela) -  sum(vendas.quantidade * vendas.preco_unitario) as receita,
      From Livros, vendas, ( Select codigo_livro, sum(quantidade) soma_mes
                             From vendas v
                             Where to_char(sysdate,'YYYYMM') = To_char(ADD_MONTHS(DATA_VENDA,1),'YYYYMM'),
                             Group by codigo_livro; ULT
      Where Livros.Codigo_livro = Vendas.Codigo_livro and Livros.codigo_livro = ult.codigo_livros (+)
      Group by Livros.titulo,livros.quant_em_stock; 
      
Begin
    Delete from Ficha5;
    for r in c1
    Loop
      Insert into Ficha5 values (r.quant, r.nVendas, r.ultimoMes, r.receita, r.titulos, 'nada');
    End Loop;

End;
/
show erros
exec F05_EX9();
select * from Ficha5;
delete ficha5;

--Ex6
Create Trigger F06_EX20
AFTER INSERT OR DELETE OR UPDATE ON VENDAS

BEGIN

END;
/


/* QUIZ 3 */
Create Trigger Quiz3
before Insert On Vendas
for each row

Begin

  if ((sysdate - :NEW.DATA_EDICAO) > 30) then
      RAISE_APPLICATION_ERROR(-20431,'O livro '+ titulo +'não está disponivel para venda);

  end if;

End;
/



 