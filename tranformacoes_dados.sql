# Visualizando os dados
SELECT * FROM marketing_campanhas.clientes;

# Informação da tabela
DESC marketing_campanhas.clientes;

# Verificando valores distintos da variável 'Year_Birth'
SELECT DISTINCT(Education) FROM marketing_campanhas.clientes;

# Verificando valores distintos da variável 'Marital_Status'
SELECT DISTINCT(Marital_Status) FROM marketing_campanhas.clientes;

# Verificar se existem registros duplicados 
SELECT Id AS duplicados, COUNT(*) AS quantidade
FROM marketing_campanhas.clientes
GROUP BY Id HAVING COUNT(*) > 1;

# Transformando dados
CREATE TABLE `clientes_tranformados` AS (
	SELECT
		Id AS id,
		(2014 - Year_Birth) AS idade,
		CASE 
			WHEN Education = 'Graduation' THEN 'Graduacao'
			WHEN Education = 'PhD' THEN 'Doutorado'
			WHEN Education = 'Master' THEN 'Mestrado'
			WHEN Education = '2n Cycle' THEN 'Ensino Medio'
			WHEN Education = 'Basic' THEN 'Ensino Basico'
		END AS escolaridade,
		CASE 
			WHEN Marital_Status = 'Single' OR Marital_Status = 'Alone' THEN 'Solteiro'
			WHEN Marital_Status = 'Together' OR Marital_Status = 'Married' THEN 'Casado'
			WHEN Marital_Status = 'Divorced' THEN 'Divorciado'
			WHEN Marital_Status = 'Widow' THEN 'Viuvo'
			ELSE Marital_Status = NULL
		END AS estado_civil,
		Income	AS renda,
		Kidhome	AS criancas_casa,
		Teenhome AS	adolescentes_casa,
		STR_TO_DATE(Dt_Customer, '%d/%m/%Y') AS data_inscricao,
		Recency	AS dias_ultima_compra,
		MntWines AS	gasto_vinhos,
		MntFruits AS gasto_frutas,
		MntMeatProducts	AS gasto_carnes,
		MntFishProducts	AS gasto_peixes,
		MntSweetProducts AS	gasto_doces,
		MntGoldProds AS gastos_premium,
		NumDealsPurchases AS compras_desconto,
		NumWebPurchases	AS compras_site,
		NumCatalogPurchases AS compras_catalogo,
		NumStorePurchases AS compras_loja,
		NumWebVisitsMonth AS visitas_mes_site,
		Complain AS reclamacao,
		AcceptedCmp1 AS campanha1,
		AcceptedCmp2 AS	campanha2, 
		AcceptedCmp3 AS campanha3,
		AcceptedCmp4 AS campanha4,
		AcceptedCmp5 AS campanha5,
		Response AS campanha6	
	FROM marketing_campanhas.clientes);

# Verificando a existência de valores nulos nas variáveis 'id', 'idade', 'escolaridade' 'estado_civil', 
# 'renda', 'criancas_casa' e 'adolescentes_casa'