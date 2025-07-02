-- SQL Project 2.
# 2. Data Exploration

SELECT * 
FROM layoffs_staging2;

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

SELECT  *
FROM layoffs_staging2
WHERE percentage_laid_off LIKE 1
ORDER BY funds_raised_millions DESC;



SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

# to know the time period of these layoffs,

SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2
;

#To find the total laid off by each industry -- max in first order

SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

# To find which country laidoff more

SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

# To find on which date, month and year laidoff more

SELECT `date`, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY `date`
ORDER BY 1 DESC;

SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

SELECT SUBSTRING(`date`,1,7) AS MONTH, SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL 
GROUP BY MONTH
ORDER BY 1 ASC
;

# In order to find the rolling total of laid offs in every month and year using CTE

WITH Rolling_Total AS(
SELECT SUBSTRING(`date`,1,7) AS 'month', SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL 
GROUP BY MONTH
ORDER BY 1 ASC
)
SELECT MONTH, total_off,
SUM(total_off) OVER(ORDER BY MONTH) AS Rolling_Sum
FROM Rolling_Total;

# We san see by company also

SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;

# If Highest One based on layoffs per year should be at no.1 so use CTE

WITH Company_Year (company, years, total_laid_off) AS(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
), Company_Rank AS
(SELECT *, DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) as Ranking
FROM Company_Year
WHERE years IS NOT NULL)
SELECT *
FROM Company_Rank
WHERE Ranking <=5;

# We have done 3 CTEs so we can filter and rank the companies according to their layoffs
# we can change to industry, date and explore more in this given data set