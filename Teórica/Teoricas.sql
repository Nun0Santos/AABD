/* ========== EXCEP��ES ========== */

/* 1 - Apague o livro com o c�digo 1
        - Apanhar a exce��o e fazer o output da mensagem */     
Declare
    CodLivroERR EXCEPTION;
    PRAGMA EXCEPTION_INIT(CodLivroERR,-02292);
Begin
      Delete From Livros Where Livros.Codigo_Livro = 1;
      
      Exception
        When CodLivroERR Then
          DBMS_OUTPUT.PUT_LINE('Erro numero: '|| SQLCODE || ' apanhado com sucesso');
End;
/

/* 2 - Inserir uma venda do livro com o codigo 2
          - Lan�ar uma exce��o se a quantidade a vender 
            for superior � quantidade em stock */            
Declare
    quantStock Livros.QUANT_EM_STOCK%TYPE;
    quantVender Livros.QUANT_EM_STOCK%TYPE := 100;
Begin
    Select QUANT_EM_STOCK into quantStock
    From Livros where Codigo_Livro = 2;
    
    if quantVender > quantStock then
      RAISE_APPLICATION_ERROR(-20010,'Stock Insuficiente');
    End if;
    
    Insert into Vendas 
        values (89, sysdate, 1, 2, 50, quantVender, 50*quantVender);
End;
/

/* ========== PROCEDIMENTOS ========== */

/* a) Criar um procedimento que recebe como argumento o
c�digo de um livro, e devolve por argumento h�
quantos dias foi editado. */


Declare

Begin

End;
\




  
