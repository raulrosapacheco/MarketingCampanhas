# Análise de Dados de Clientes e Campanhas de Marketing

## Contexto do Projeto
Uma Boutique de Alimentos realizou 6 campanhas de marketing direcionado aos clientes cadastrados. O diretor de marketing da loja me contratou como analista de dados com o objetivo de identificar o perfil dos seus clientes e avaliar a efetividade de cada campanha nos últimos 2 anos.

Os dados utilizados nesse projeto podem ser obtidos no link: <a href="https://www.kaggle.com/datasets/rodsaldanha/arketing-campaign">Marketing Campaign</a>.

## Perguntas de Negócio
Com o intuito de identificar o perfil dos clientes cadastrados e a efetividade de cada campanha de marketing, algumas perguntas de negócio foram desenvolvidas.

**1 - Qual a renda média dos clientes cadastrados?**

**2 - Qual a proporção dos clientes por estado civil, escolaridade e número de filhos em casa?**

**3 - Qual a taxa de conversão de cada campanha?**

**4 - É possível identificar um padrão entre os clientes que compraram em cada campanha?** 

## Tecnologias Utilizadas
Os dados foram carregados localmente via **MySQL Workbench** e utilizando linguagem **SQL** foi possível realizar a análise exploratória dos dados, fazer limpezas e transformações nos dados e efetuar consultas que auxiliaram nas respostas das perguntas de negócio.

Por fim, utilizando a ferramenta do **Power BI**, um dashbord analítico foi criado com o objetivo de apresentar a análise ao dono da loja.
 
## Dicionário de Dados
O arquivo CSV utilizado neste projeto possui 22.016 registros de clientes, contendo 27 variáveis(colunas) para cada cliente. Segue abaixo uma breve descrição das variáveis.

| Nome da Coluna Original | Descrição |
| --- | --- |
| ID | Identificação do cliente | 
| Year_Birth | Ano de Nascimento | 
| Education | Grau de Escolaridade |
| Marital_Staus | Estado civil |
| Income | Renda Familiar Anual |
| Kidhome | Número de crianças na casa do cliente |
| Teenhome | Número de adolescentes na casa do cliente |
| Dt_Customer | Data de cadastro do cliente na empresa |
| Recency | Número de dias desde a última compra |
| MntWines | Gasto com Vinhos nos últimos 2 anos |
| MntFruits | Gasto com Frutas nos últimos 2 anos |
| MntMeatProducts | Gasto com Carnes nos últimos 2 anos |
| MntFishProducts | Gasto com Peixes nos últimos 2 anos |
| MntSweetProducts | Gasto com Doces nos últimos 2 anos |
| MntGoldProds | Gasto com produtos premium  nos últimos 2 anos|
| NumDealsPurchases | Número de compras feitas com desconto |
| NumWebPurchases | Número de compras feitas através do site da empresa |
| NumCatalogPurchases | Número de compras feitas pelo catálogo de entrega |
| NumStorePurchases | Número de compras feitas diretamente na loja |
| NumWebVisitsMonth | Número de visitas ao site da empresa no último mês |
| AcceptedCmp3	| 1 se o cliente aceitou a oferta na 3ª campanha, 0 caso contrário |
| AcceptedCmp4	| 1 se o cliente aceitou a oferta na 4ª campanha, 0 caso contrário |
| AcceptedCmp5	| 1 se o cliente aceitou a oferta na 5ª campanha, 0 caso contrário |
| AcceptedCmp1	| 1 se o cliente aceitou a oferta na 1ª campanha, 0 caso contrário |
| AcceptedCmp2	| 1 se o cliente aceitou a oferta na 2ª campanha, 0 caso contrário |
| Complain | 1 se o cliente reclamou nos últimos 2 anos, 0 caso contrário |
| Response | 1 se o cliente aceitou a oferta na última campanha, 0 caso contrário |

## Explorando e Transformando dados utilizando linguagem SQL
### 1. Importação dos dados
Utilizando o MySQL Workbench foi criado um SCHEMA com o nome de **marketing_campanhas** e realizado a importação dos dados do arquivo **marketing_campaign.csv** em uma tabela denominada de **clientes**.

### 2. Exploração os dados
* Visualizando os dados.
```sql
SELECT * FROM marketing_campanhas.clientes;
```

* Verificando se existem registros duplicados pela coluna 'Id': Não possui.
```sql
SELECT Id AS duplicados, COUNT(*) AS quantidade
FROM marketing_campanhas.clientes
GROUP BY Id 
HAVING COUNT(*) > 1;
```

* Calculando a quantidade de registros: 2216.
```sql
SELECT COUNT(*) AS qtdd_registros FROM marketing_campanhas.clientes;
```

* Calculando a quantidade de colunas: 27.
```sql
SELECT COUNT(*) AS num_columns
FROM information_schema.columns
WHERE table_name = 'clientes';
```

* Verificando os tipos de dados de cada coluna. 

Todas as colunas foram tipificadas como int, exceto as colunas 'Education', 'Marital_Status' e 'Dt_Customer' que foram tipificadas como tipo text.
```sql
DESC marketing_campanhas.clientes;
```

* Verificando e contalibizando os valores da coluna 'Marital_Status'. 

Single:	471, Together:	573, Married:	857, Divorced:	232, Widow:	7, Alone:	3, Absurd:	2, YOLO:	2.
```sql
SELECT Marital_Status, COUNT(*) 
FROM marketing_campanhas.clientes
GROUP BY Marital_Status;
```

* Verificando a idade dos clientes, considerando que os dados são de 2014. 

Analisando as idades dos clientes foi possível verificar a existência 3 idades que são outliers: 114, 115 e 121 anos.
```sql
SELECT (2014 - Year_Birth) AS idade 
FROM marketing_campanhas.clientes
ORDER BY Year_Birth ASC;
```

* Verificando a renda dos clientes

Analisando a renda dos clientes, também é possível perceber a presença de 1 valor outliers: 666666 dolares.
```sql
SELECT income AS renda 
FROM marketing_campanhas.clientes
ORDER BY renda DESC; 
```

* Calculando a média da idade dos clientes, desconsiderando os outliers: 45 anos.
```sql
SELECT ROUND(AVG((2014 - Year_Birth)),0) AS media_idade
FROM marketing_campanhas.clientes 
WHERE (2014 - Year_Birth) < 114;
```

* Calculando a média da renda dos clientes, desconsiderando o outlier: 51.970 dolares.
```sql
SELECT ROUND(AVG(income),0) AS media_renda
FROM marketing_campanhas.clientes 
WHERE income < 666666; 
```

### 3. Limpando, Transformando dados e gerando uma nova tabela
Com o objetivo de facilitar a análise, algumas transformações nos dados foram realizadas.

**1 - Os dados foram traduzidos para o idioma português;**

**2 - A coluna 'Year_Birth' foi transformada em 'idade' do cliente baseado no ano de 2014;**

**3 - Os valores 'Absurd' da coluna 'estado_civil' foi substituidos pelo valor que mais aparece na coluna, ou seja, 'Casado';**

**4 - Os valores 'YOLO' da coluna 'estado_civil' foram interpretados como 'Solteiro';**

**5 - Os valores outliers da coluna 'renda' foram substituídos pela média de renda;**

**6 - Os valores outliers da coluna 'idade' foram substituidos pela média de idade;**

**7 - Número de crianças e adolescentes foram somados e armazenados na coluna 'filhos_casa';**

**8 - A coluna referente a data de cadastro do cliente foi alterada para o tipo date;**

**9 - Foi criada uma coluna com o total dos gastos de cada cliente;**

**10 - Uma nova tabela denominada de 'clientes_transformados' foi criada.**

```sql
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
		(Kidhome + Teenhome) AS	filhos_casa,
		STR_TO_DATE(Dt_Customer, '%d/%m/%Y') AS data_inscricao,
		Recency AS dias_ultima_compra,
		MntWines AS gasto_vinhos,
		MntFruits AS gasto_frutas,
		MntMeatProducts AS gasto_carnes,
		MntFishProducts AS gasto_peixes,
		MntSweetProducts AS gasto_doces,
		MntGoldProds AS gastos_premium,
		(MntWines + MntFruits + MntMeatProducts + MntFishProducts + MntSweetProducts + MntGoldProds) AS total_gastos,
		NumDealsPurchases AS compras_desconto,
		NumWebPurchases AS compras_site,
		NumCatalogPurchases AS compras_catalogo,
		NumStorePurchases AS compras_loja,
		NumWebVisitsMonth AS visitas_mes_site,
		Complain AS reclamacao,
		AcceptedCmp1 AS campanha1,
		AcceptedCmp2 AS campanha2, 
		AcceptedCmp3 AS campanha3,
		AcceptedCmp4 AS campanha4,
		AcceptedCmp5 AS campanha5,
		Response AS campanha6	
	FROM marketing_campanhas.clientes);
```
## Dashboard
O Dashboard foi criado a partir da tabela 'clientes_transformados'.

Abaixo temos o print dos Dashboards Visão Cliente e Visão Campanhas referentes as campanhas 2 e 6.

Você pode acessar o Dashboard clicando em: <a href="https://app.powerbi.com/view?r=eyJrIjoiYjJhYjhkNGQtOTg2OC00MDE2LWI1ZTktODI2NmNkMjVkNGRjIiwidCI6IjUzYmMxZDQ4LTgxMWEtNGI0Ny1hYzFkLWRhYzQ2NmQwMjZjYSJ9">Análise do Cliente e Campanhas de Marketing<a>.

![image](https://user-images.githubusercontent.com/75815212/226145497-74e993fa-bc64-4cc8-9ef9-4cb7968fd822.png)

![image](https://user-images.githubusercontent.com/75815212/226145601-bf6ec6c9-7bdd-4951-8165-0e5a49ae02c0.png)

![image](https://user-images.githubusercontent.com/75815212/226145538-5d6e2ccf-dce7-4516-95f4-35775f5f7be6.png)


## Sumarização dos Resultados

- A loja possui um total de 2.216 clientes cadastrados, cuja renda média anual é de $51.970;
- A maior parte das compras é realizada na loja física, representando 46% do total;
- Dos clientes cadastrados, 65% são casados e 91% possuem pelo menos ensino superior;
- 78% dos clientes cadastrados têm até um filho em casa;
- A campanha 2 teve a menor taxa de conversão, ou seja, apenas 1,35% dos clientes compraram na campanha;
- A campanha 6 teve a maior taxa de conversão, com 15,03% dos clientes adquirindo produtos na campanha;
- Em média, os clientes que compraram na campanha 1 possuíam uma renda 52% maior do que a média da totalidade;
- Dos clientes que compraram na campanha 1, 77% não possuem filhos em casa, o que se torna mais o fato mais expressivo é que apenas 28% dos clientes cadastrados não possuem filhos em casa;
- A campanha 2 atingiu um perfil de clientes que gastou 300% a mais com vinhos em comparação com a média da totalidade;
- Entre todas as campanhas, o perfil dos clientes que compraram na campanha 3 foi o que mais se assemelhou com o perfil médio dos clientes cadastrados;
- Assim como na campanha 2, a campanha 4 atingiu um perfil de clientes que gastam mais com vinhos;
- O perfil médio dos clientes que compraram na campanha 5 se assemelha com o perfil dos clientes que compraram na campanha 1, tendo uma renda 58% maior que a média em geral e 84% destes não possuem filhos;
- A campanha 6 se mostrou a mais assertiva não apenas pela maior taxa de conversão, mas também por atingir um perfil médio de cliente que consome todos os tipos de produtos da loja.

## Contato
Agradeço por ter lido até o final! Ademais, Gostaria de receber seu feedback. Se houver qualquer parte que não esteja clara ou que possa ser aprimorada, por favor, entre em contato comigo.

E-mail: raulrosa.dev@gmail.com

LinkedIn: [linkedin.com/in/raul-rosa/](https://www.linkedin.com/in/raul-rosa/)






