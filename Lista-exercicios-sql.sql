
-------	EXERCICIO 1 -------
create view RegistroeVenda
as

select 
distinct
Produto.* from Produto
inner join VendaProduto
on Produto.ProdutoID = VendaProduto.ProdutoID
where Estoque >= 1 

select * from Produto
where Estoque >= 1
and Produto.ProdutoID not in (Select ProdutoID from VendaProduto)

select * from Produto 
where Estoque >= 1
and exists (Select ProdutoID from VendaProduto where VendaProduto.ProdutoID = Produto.ProdutoID) 

-------	EXERCICIO 2 -------

create view VendaCliente
as

select * from CLiente 
where 
not exists (Select ClienteID from Venda where Cliente.ClienteID = Venda.ClienteID)

-------	EXERCICIO 3 -------

begin tran

update Produto
set PrecoVenda = (PrecoVenda * 0.10) + PrecoVenda
where Estoque > 0
 select PrecoVenda from Produto where estoque > 0
commit

-------	EXERCICIO 4 -------

begin tran

update Produto
set PrecoVenda = (PrecoVenda * 0.10) + PrecoVenda

where not exists (Select ProdutoID from VendaProduto where VendaProduto.ProdutoID = Produto.ProdutoID)
commit

-------	EXERCICIO 5 -------

Declare @totaldesc money = (SELECT SUM(ValorDesconto) from VendaProduto)

select Produto.ProdutoID,
Produto.Descricao,
SUM(VendaProduto.ValorDesconto) / @totaldesc*100

from Produto
inner join VendaProduto
on Produto.ProdutoID = VendaProduto.ProdutoID
group by Produto.ProdutoID,
Produto.Descricao

-------	EXERCICIO 6 -------

SELECT
 Sum(ValorLiquido) AS TOTALVENDA
from Venda
group by Year(DataPedido)

-------	EXERCICIO 7 -------

 select year(DataPedido),
	 Grupo.Descricao, 
	 sum(VendaProduto.PrecoVenda)
 from Venda 
          
inner join VendaProduto 
on VendaProduto.VendaID = Venda.VendaID
inner join Produto
on Produto.ProdutoID = VendaProduto.ProdutoID 
inner join Grupo
on Grupo.GrupoID = Produto.GrupoID
group by year(DataPedido),
Grupo.Descricao

-------	EXERCICIO 8 -------

Create Procedure prInsertCliente
 @Marca int,
 @Descricao varchar(200)
as
insert into Marca(MarcaID,Descricao)
values (@Marca,@Descricao)

-------	EXERCICIO 9 -------

Create Procedure prInsertGrupo
@GrupoID Int,
@DepartamentoID int,
@Descricao varchar(200)
as
Insert into Grupo(GrupoID,DepartamentoID,Descricao)
values (@GrupoID,@DepartamentoID,@Descricao)


-------	EXERCICIO 10 -------

Create procedure PdPesquisaGrupo

as
select Produto.ProdutoID,
Produto.Descricao,
Grupo.Descricao from Produto
inner join Grupo
on Produto.GrupoID = Grupo.GrupoID

exec PdPesquisaGrupo

-------	EXERCICIO 11 -------

Create Procedure pdPesquisaMarca
@Descricao varchar(200)

as
select Produto.ProdutoID, 
Produto.Descricao,
Marca.Descricao from Produto
inner join Marca
on Produto.MarcaID = Marca.MarcaID
where Produto.Descricao like '%' + @Descricao + '%'


exec pdPesquisaMarca @Descricao = 'Adidas'

-------	EXERCICIO 12 -------

create Procedure PesquisaCliente12
@Nome varchar(200)

as
select ClienteID,Nome from Cliente
where Nome like  @Nome + '%'

exec PesquisaCliente12 @Nome = 'J'

-------	EXERCICIO 13 -------

create procedure  prPesquisaClienteTipo
@tipo char (1)
as
select * from Cliente
where Tipo = @tipo

exec prPesquisaClienteTipo 'F'

-------	EXERCICIO 14 -------

Create procedure prPesquisaMarcaNome
@MarcaID int = null,
@GrupoID int = null

as
select * from Produto
where MarcaID = ISNULL(@MarcaID,MarcaID)
and GrupoID = ISNULL(@GrupoID,GrupoID)

exec prPesquisaMarcaNome @MarcaID = '364', @GrupoID = '38'

-------	EXERCICIO 15 -------

Create procedure PrPesquisaDataVenda
@ValorMin  datetime,
@ValorMax  datetime

as
Select Cliente.ClienteID,Cliente.Nome,Max(Venda.DataPedido) from Cliente
inner join Venda
on Cliente.ClienteID = Venda.ClienteID
where DataPedido between @ValorMin and @ValorMax
group by Cliente.ClienteID,Cliente.Nome

Exec PrPesquisaDataVenda @ValorMin = '01-01-2020' , @ValorMax = '01-31-2020'

-------	EXERCICIO 16 -------

select produto.produtoId,
produto.Descricao,
sum(VendaProduto.QtdeVendida)

from vendaproduto
inner join produto
on produto.produtoid = vendaproduto.produtoid
group by produto.ProdutoID, Produto.Descricao
having sum(VendaProduto.QtdeVendida) >= 5

-------	EXERCICIO 17 -------

select 
 Cliente.ClienteID,
 Cliente.Nome,
 IIF(Tipo = 'F',CPF,CNPJ)as CNPJCPF,
 SUM(VendaProduto.PrecoVenda) as valorVendaTotal,
 SUM(VendaProduto.QtdeVendida*VendaProduto.QtdeVendida)as qtdeVendida

from Cliente
	 left join ClienteFisico
	 on Cliente.ClienteID = ClienteFisico.ClienteID
	 left join ClienteJuridico
	 on Cliente.ClienteID = ClienteJuridico.ClienteID
	 inner join Venda 
	 on Cliente.ClienteID = Venda.ClienteID
	 inner join VendaProduto
	 on Venda.VendaID = VendaProduto.VendaID
group by 
 Cliente.ClienteID,
 Cliente.Nome,
 IIF(Tipo = 'F',CPF,CNPJ)
Order By 
 Sum(VendaProduto.QtdeVendida)ASC

select * from Venda

-------	EXERCICIO 18 -------

select Marca.MarcaID,
Marca.Descricao,
COUNT(Distinct Produto.ProdutoID)as QTDEcada,
IIF(SUM(VendaProduto.QtdeVendida) IS NOT NULL, 
SUM(VendaProduto.QtdeVendida),0) as Total

from Marca
inner join Produto
on Produto.MarcaID = Marca.MarcaID
left join VendaProduto
on VendaProduto.ProdutoID  = Produto.ProdutoID

group by Marca.MarcaID, Marca.Descricao 

-------	EXERCICIO 19 -------

select 
Grupo.GrupoID,
Max(Venda.DataPedido ) as UltimaVendida,
COUNT(Distinct Produto.ProdutoID)as QTDEcada,
IIF(SUM(VendaProduto.QtdeVendida) IS NOT NULL, 
SUM(VendaProduto.QtdeVendida),0) as Total

	from Grupo
inner join Produto
on Produto.GrupoID = Grupo.GrupoID
left join VendaProduto
on VendaProduto.ProdutoID  = Produto.ProdutoID
inner join Venda
on Venda.VendaID = VendaProduto.VendaID

group by Grupo.GrupoID

-------	EXERCICIO 20 -------

-------	EXERCICIO 21 -------

CREATE FUNCTION fnQtdPrdVendidos (@QtdePro INT) 
RETURNS TABLE
AS 
RETURN
(SELECT 
	ProdutoID,
	sum(QtdeVendida) QUANTIDADE
FROM VendaProduto 
GROUP BY ProdutoID
HAVING SUM(QtdeVendida) > @QtdePro 
)

SELECT * FROM fnQtdPrdVendidos (10)

-------	EXERCICIO 22 -------

create function RetornandoTodos(@MarcaID int) 
returns table 
as 
return 
 (
 select MarcaID,
 Descricao,
 ProdutoID
 from Produto

 where MarcaID =@MarcaID
	
)

select * from RetornandoTodos(7)

-------	EXERCICIO 23 -------

CREATE FUNCTION fncValidaCPF(
    @Nr_Documento VARCHAR(11)
)
RETURNS BIT -- 1 = válido, 0 = inválido
WITH SCHEMABINDING
BEGIN
 
    DECLARE
        @Contador_1 INT,
        @Contador_2 INT,
        @Digito_1 INT,
        @Digito_2 INT,
        @Nr_Documento_Aux VARCHAR(11)
 
    -- Remove espaços em branco
    SET @Nr_Documento_Aux = LTRIM(RTRIM(@Nr_Documento))
    SET @Digito_1 = 0
 
 
    -- Remove os números que funcionam como validação para CPF, pois eles "passam" pela regra de validação
    IF (@Nr_Documento_Aux IN ('00000000000', '11111111111', '22222222222', '33333333333', '44444444444', '55555555555', '66666666666', '77777777777', '88888888888', '99999999999', '12345678909'))
        RETURN 0
 
 
    -- Verifica se possui apenas 11 caracteres
    IF (LEN(@Nr_Documento_Aux) <> 11)
        RETURN 0
    ELSE 
    BEGIN
 
        -- Cálculo do segundo dígito
        SET @Nr_Documento_Aux = SUBSTRING(@Nr_Documento_Aux, 1, 9)
 
        SET @Contador_1 = 2
 
        WHILE (@Contador_1 < = 10)
        BEGIN 
            SET @Digito_1 = @Digito_1 + (@Contador_1 * CAST(SUBSTRING(@Nr_Documento_Aux, 11 - @Contador_1, 1) as int))
            SET @Contador_1 = @Contador_1 + 1
        end 
 
        SET @Digito_1 = @Digito_1 - (@Digito_1/11)*11
 
        IF (@Digito_1 <= 1)
            SET @Digito_1 = 0
        ELSE 
            SET @Digito_1 = 11 - @Digito_1
 
        SET @Nr_Documento_Aux = @Nr_Documento_Aux + CAST(@Digito_1 AS VARCHAR(1))
 
        IF (@Nr_Documento_Aux <> SUBSTRING(@Nr_Documento, 1, 10))
            RETURN 0
        ELSE BEGIN 
        
            -- Cálculo do segundo dígito
            SET @Digito_2 = 0
            SET @Contador_2 = 2
 
            WHILE (@Contador_2 < = 11)
            BEGIN 
                SET @Digito_2 = @Digito_2 + (@Contador_2 * CAST(SUBSTRING(@Nr_Documento_Aux, 12 - @Contador_2, 1) AS INT))
                SET @Contador_2 = @Contador_2 + 1
            end 
            SET @Digito_2 = @Digito_2 - (@Digito_2/11)*11
 
            IF (@Digito_2 < 2)
                SET @Digito_2 = 0
            ELSE 
                SET @Digito_2 = 11 - @Digito_2
 
            SET @Nr_Documento_Aux = @Nr_Documento_Aux + CAST(@Digito_2 AS VARCHAR(1))
 
            IF (@Nr_Documento_Aux <> @Nr_Documento)
                RETURN 0     
        END
    END 
    RETURN 1
END

-------	EXERCICIO 24 -------

create function CalcIdade (@DataNascimento date)
returns table 
as 
return
(select 
DataNascimento,DATEDIFF(YYYY,DataNascimento,GETDATE()) as idade
from ClienteFisico
inner join Cliente
on Cliente.ClienteID = ClienteFisico.ClienteID)

-------	EXERCICIO 25 -------

-------	EXERCICIO 26 -------

create function CalcIdade (@DataNascimento date)
returns table 
as 
return
(select Nome,
DataNascimento,DATEDIFF(YYYY,DataNascimento,GETDATE()) as idade
from ClienteFisico
inner join Cliente
on Cliente.ClienteID = ClienteFisico.ClienteID)

-------	EXERCICIO 27 -------

select 
Grupo.GrupoID,
Grupo.Descricao,
SUM(VendaProduto.QtdeVendida)

from VendaProduto
inner join Produto
on Produto.ProdutoID = VendaProduto.ProdutoID
inner join Grupo 
on Produto.GrupoID = Grupo.GrupoID

group by Grupo.GrupoID, Grupo.Descricao
having SUM(VendaProduto.QtdeVendida) > 2

-------	EXERCICIO 28 -------

-------	EXERCICIO 29 -------

create trigger trAttDescMarca
on Marca
After update
as
begin
declare @marcaAntiga varchar(200),
@marcaNova varchar(200)
set @marcaAntiga = (Select Descricao from deleted)
set @marcaNova = (Select Descricao from inserted)

if (@marcaAntiga <> @marcaNova)
begin
update Produto set Descricao = Replace(Descricao,@marcaAntiga,@marcaNova)
where MarcaId = (Select MarcaID from deleted)

end

end

Drop trigger trAttDescMarca

-------	EXERCICIO 30 -------

-------	EXERCICIO 31 -------

create trigger trDeleteGrupo
on Grupo
instead of delete
as
begin

update Grupo 
set Ativo = 0
where GrupoID = (select GrupoID from deleted)

end

-------	EXERCICIO 32 -------

create trigger trUpdateMarca
on Marca
instead of delete
as
begin

update Marca set Ativo = 0
where MarcaID = (select MarcaID from deleted)

end

-------	EXERCICIO 33 -------

declare @anointerior table (
ANO INT,
JANEIRO INT,
FEVEREIRO INT,
MARÇO INT,
ABRIL INT,
MAIO INT, 
JUNHO INT,
JULHO INT,
AGOSTO INT,
SETEMBRO INT,
OUTUBRO INT,
NOVEMBRO INT, 
DEZEMBRO INT
)

declare @anoatual table(
ANO INT,
JANEIRO INT,
FEVEREIRO INT,
MARÇO INT,
ABRIL INT,
MAIO INT, 
JUNHO INT,
JULHO INT,
AGOSTO INT,
SETEMBRO INT,
OUTUBRO INT,
NOVEMBRO INT, 
DEZEMBRO INT
)


insert into @anointerior

SELECT
ANO,
[1] JANEIRO,
[2] FEVEREIRO,
[3] MARÇO,
[4] ABRIL,
[5] MAIO,
[6] JUNHO,
[7] JULHO,
[8] AGOSTO,
[9] SETEMBRO,
[10] OUTUBRO,
[11] NOVEMBRO,
[12] DEZEMBRO

FROM

(SELECT  MONTH (DATAPEDIDO) MES,
YEAR (DATAPEDIDO) ANO,
VENDAID
FROM VENDA WHERE YEAR(DataPedido)= 2019 ) SOURCETABLE

PIVOT (count(VENDAID) for mes in ([1], [2], [3], [4] ,[5] ,[6] , [7], [8], [9], [10], [11], [12])) as PIVOTTABLE

insert into @anoatual

SELECT
ANO,
[1] JANEIRO,
[2] FEVEREIRO,
[3] MARÇO,
[4] ABRIL,
[5] MAIO,
[6] JUNHO,
[7] JULHO,
[8] AGOSTO,
[9] SETEMBRO,
[10] OUTUBRO,
[11] NOVEMBRO,
[12] DEZEMBRO

FROM

(SELECT  MONTH (DATAPEDIDO) MES,
YEAR (DATAPEDIDO) ANO,
VENDAID
FROM VENDA WHERE YEAR(DataPedido)= 2020 ) SOURCETABLE

PIVOT (count(VENDAID) for mes in ([1], [2], [3], [4] ,[5] ,[6] , [7], [8], [9], [10], [11], [12])) as PIVOTTABLE

select iif(ano=2019,JANEIRO,0) - iif(ano=2020,JANEIRO,0)
from
(select * from @anoatual
union
select * from @anointerior) Faturamento


-------	EXERCICIO 34 -------

-------	EXERCICIO 35 -------

-------	EXERCICIO 36 -------


