--Ficha 5
drop table livros_removidos;
--Ex2

  CREATE TABLE Livros_Removidos
   (	"CODIGO_LIVRO" NUMBER(4,0) NOT NULL ENABLE, 

	"TITULO" VARCHAR2(50 BYTE) NOT NULL ENABLE, 
	"ISBN" VARCHAR2(10 BYTE) NOT NULL ENABLE, 
	"GENERO" VARCHAR2(20 BYTE), 
	"PRECO_TABELA" NUMBER(6,0), 
	"PAGINAS" NUMBER(6,0), 
	"QUANT_EM_STOCK" NUMBER(9,0), 
	"UNIDADES_VENDIDAS" NUMBER(9,0), 
	"DATA_EDICAO" DATE, 
	 CONSTRAINT "PK_ID_LIVRO_REMOVIDO" PRIMARY KEY ("CODIGO_LIVRO")
   );
   
--Ex3 e Ex5

Create or replace Trigger F05_EX03
  After delete on Livros 
  for each row
Begin
   INSERT INTO LIVROS_REMOVIDOS VALUES(
    :OLD.CODIGO_LIVRO,
    :OLD.TITULO,
    :OLD.ISBN,
    :OLD.GENERO,
    :OLD.PRECO_TABELA,
    :OLD.PAGINAS,
    :OLD.QUANT_EM_STOCK,
    :OLD.UNIDADES_VENDIDAS,
    :OLD.DATA_EDICAO,
    USER, SYSDATE
  );
End;
/

--Ex4
--Ex7 (Ficha 4 )

Create or Replace Trigger F04_EX13
  After Delete on autores
  for each row
  
Begin
    Delete from livros where Codigo_autor = :Old.Codigo_Autor;
End;
/

-- TRIGGER PARA APAGAR OS LIVROS VENDIDOS DAQUELE AUTOR --
Create or Replace Trigger apagaVendas
 Before Delete on livros
 for each row
Begin
      Delete from vendas where codigo_livro = :old.codigo_livro;
End;
/

--Ex6

Select * from editoras;
Alter table Editoras add nlivros_editados number default 0;;

Update editoras set nlivros_editados = (
  Select count(*),
  From livros
  Where Editoras.codigo_editora = Livros.codigo_editora);
  
--Ex7

Create or replace Trigger F05_EX07
  After Insert Or Delete or update of Codigo_editora on livros
  For each row
Begin
  If Inserting or updating then
    update editoras set nlivros_editados = nlivros_editados + 1
    where editoras.codigo_editora = :NEW.codigo_editora;
  End If;
  
  If Deleting or updating then 
      update editoras set nlivros_editados = nlivros_editados - 1
      where editoras.codigo_editora = :OLD.codigo_editora;
  End If;
End;
/
--Ex8

Create table FICHA5(
    num1 number,
    num2 number,
    num3 number,
    num4 number,
    string1 varchar(100),
    string2 varchar(1000)

);
--Ex9
Create or replace Procedure F05_EX9
as
Cursor c1 is
      Select Livros.titulo  as titulos,livros.quant_em_stock as quant,
      vendas.quantidade as nVendas,
      (vendas.quantidade*livros.preco_tabela - vendas.preco_unitario) as receita
      From Livros, vendas
      Where Livros.Codigo_livro = Vendas.Codigo_livro;
      
Begin
    Delete from Ficha5;
    for r in c1
    Loop
      Insert into Ficha5 values (r.quant, r.nVendas, 1, r.receita, r.titulos, 'nada');
    End Loop;

End;
/

--Ex10

Create sequence  SEQ_VENDAS;
Create sequence SEQ_VENDAS  start with 20;
select seq_vendas.nextval from livros;

Create  or replace Trigger F05_EX10
  Before Insert on Vendas
  For each row
Begin
  :New.Data_Venda := Sysdate;
  Select Preco_tabela into :New.Preco_unitario
  From Livros
  Where Codigo_livro = :New.codigo_livro;
  
  -- 28 Dezembro a 28 de Fevereiro
  if not (to_char(sysdate, 'MM-DD') < '12-28' and to_char(sysdate,'MM-DD') > '02-28') then 
  
    :New.Preco_unitario := :New.preco_unitario * 0.6;
    
  End If;
    :New.total_venda := :New.quantidade * :new.preco_unitario;
    Select Seq_vendas.nextval into :new.codigo_venda from dual;
End;
/
show erros


--Ex11

create or replace Trigger F05_EX11
  After INSERT on vendas
  for each row
  
Begin
      Update livros 
      set Quant_Em_Stock = Quant_Em_Stock - :NEW.Quantidade
      Where Codigo_livro = :New.Codigo_livro;
End;
/

select * from livros;
insert into vendas values(1,sysdate,2,1,28,3,28*3);
select * from vendas;
rollback

--Ex 12
Create or replace Trigger F05_EX12
  Before DELETE on Clientes
  For each Row 
    
Begin
      Delete from Vendas
      Where Vendas.codigo_cliente = :OLD.codigo_cliente;   

End;
/
show erros
select clientes.codigo_cliente,vendas.codigo_livro
from vendas,clientes
where clientes.codigo_cliente = vendas.codigo_cliente;

delete from clientes where codigo_cliente = 1;
select * from vendas;
rollback;


--Ex13
Alter table clientes add total number(5); 

Create Trigger F05_EX14 
 After Update On Vendas