# MarketingCampanhas

## Contexto do Projeto
“Sou analista de dados e o diretor de marketing de uma empresa me informou que as campanhas de marketing anteriores não foram tão eficazes quanto se esperava. Faz parte do meu trabalho, analisar o conjunto de dados para entender esse problema e propor soluções baseadas em dados.” 

Esse contexto foi parafraseado e adaptado a partir do que foi proposto no dataset <a href="https://www.kaggle.com/datasets/rodsaldanha/arketing-campaign">Marketing Campaign</a>.

Os dados utilizados nesse projeto podem ser obtidos no mesmo link acima. 

## Tecnologias Utilizadas
Os dados foram carregados localmente via **MySQL Workbench** e utilizando linguagem **SQL** foi possível realizar a análise exploratória dos dados, fazer as limpezas e transformações necessárias e responder algumas perguntas de negócio.

Por fim, utilizando a ferramenta do **Power BI**, um dashbord analítico criado com o objetivo de apresentar a análise ao tomador de decisão da empresa.
 
## Dicionário de Dados
O arquivo CSV utilizado neste projeto possui 22.016 registros de clientes, contendo 27 variáveis(colunas) para cada cliente. Irei aqui fazer uma breve descrição das variáveis.

| Nome da Coluna Original | Descrição |
| --- | --- |
| ID | Identificação do cliente | 
| Year_Birth | Ano de Nascimento | 
| Education | Grau de Escolaridade |
| Marital_Staus | Estado civil |
| Income | Renda Familiar Anual |
| Kidhome | Número de crianças na casa do cliente |
| Teenhome | Número de adolescentes na casa do cliente |
| Dt_Customer | Data de inscrição do cliente na empresa |
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
| NumWebVisitsMonth	| Número de visitas ao site da empresa no último mês |
| AcceptedCmp3	| 1 se o cliente aceitou a oferta na 3ª campanha, 0 caso contrário |
| AcceptedCmp4	| 1 se o cliente aceitou a oferta na 4ª campanha, 0 caso contrário |
| AcceptedCmp5	| 1 se o cliente aceitou a oferta na 5ª campanha, 0 caso contrário |
| AcceptedCmp1	| 1 se o cliente aceitou a oferta na 1ª campanha, 0 caso contrário |
| AcceptedCmp2	| 1 se o cliente aceitou a oferta na 2ª campanha, 0 caso contrário |
| Complain	| 1 se o cliente reclamou nos últimos 2 anos, 0 caso contrário |
| Response | 1 se o cliente aceitou a oferta na última campanha, 0 caso contrário |

## Explorando e Transformando dados utilizando linguagem SQL
### 1. Importação dos dados
Utilizando o MySQL Workbench foi criado um SCHEMA com o nome de **marketing_campanhas** e realizado a importação dos dados no arquivo **marketing_campaign.csv**, criando uma tabela denominada de **clientes**.

### 2. Explorando os dados
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

Todas as colunas são do tipo int, exceto as colunas 'Education', 'Marital_Status' e 'Dt_Customer' que foram tipificadas como tipo text.
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

* Verifica a renda dos clientes

Analisando a renda dos clientes, também é possivel perceber a presença de 1 valor outliers: 666666 dolares.
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








