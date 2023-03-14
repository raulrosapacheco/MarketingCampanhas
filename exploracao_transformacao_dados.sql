# Visualiza os dados
SELECT * FROM marketing_campanhas.clientes;

# Verifica se existem registros duplicados 
SELECT Id AS duplicados, COUNT(*) AS quantidade
FROM marketing_campanhas.clientes
GROUP BY Id 
HAVING COUNT(*) > 1;

# Quantidade de Registros
SELECT COUNT(*) AS qtdd_registros FROM marketing_campanhas.clientes;

# Quantidade de Colunas
SELECT COUNT(*) AS num_columns
FROM information_schema.columns
WHERE table_name = 'clientes';

# Informação da tabela
DESC marketing_campanhas.clientes;

# Verifica e contalibiza os valores da coluna 'Marital_Status'
SELECT Marital_Status, COUNT(*) AS quantidade
FROM marketing_campanhas.clientes
GROUP BY Marital_Status;

# Verifica a idade dos clientes, considerando que os dados são de 2014 
SELECT (2014 - Year_Birth) AS idade 
FROM marketing_campanhas.clientes
ORDER BY Year_Birth ASC;

# Verifica a renda dos clientes
SELECT income AS renda 
FROM marketing_campanhas.clientes
ORDER BY renda DESC; 

# Calcula a média da idade, descosiderando os outliers.
SELECT ROUND(AVG((2014 - Year_Birth)),0) AS media_idade
FROM marketing_campanhas.clientes 
WHERE (2014 - Year_Birth) < 114;

# Calcula a média da renda, desconsiderando o outlier.
SELECT ROUND(AVG(income),0) AS media_renda
FROM marketing_campanhas.clientes 
WHERE income < 666666;

# Transformando dados
CREATE TABLE `clientes_transformados` AS (
	SELECT
		Id AS id,
        CASE
			WHEN (2014 - Year_Birth) < 114 THEN (2014 - Year_Birth) 
            ELSE 45 
            END AS idade,
		CASE 
			WHEN Education = 'Graduation' THEN 'Graduacao'
			WHEN Education = 'PhD' THEN 'Doutorado'
			WHEN Education = 'Master' THEN 'Mestrado'
			WHEN Education = '2n Cycle' THEN 'Ensino Medio'
			WHEN Education = 'Basic' THEN 'Ensino Basico'
		END AS escolaridade,
		CASE 
			WHEN Marital_Status = 'Single' OR Marital_Status = 'Alone' OR Marital_Status = 'YOLO' THEN 'Solteiro'
			WHEN Marital_Status = 'Together' OR Marital_Status = 'Married' OR Marital_Status = 'Absurd' THEN 'Casado'
			WHEN Marital_Status = 'Divorced' THEN 'Divorciado'
			WHEN Marital_Status = 'Widow' THEN 'Viuvo'
		END AS estado_civil,
		CASE 
			WHEN Income < 666666 THEN Income
            ELSE 51970
		END AS renda,
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
    


   
