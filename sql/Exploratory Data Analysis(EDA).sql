-- Exploratory Data Analysis(EDA)

select *
from layoffs_staging2
;

select max(total_laid_off), max(percentage_laid_off)
from layoffs_staging2
;

select *
from layoffs_staging2
where percentage_laid_off = 1
order by funds_raised_millions desc
;

select company, sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 desc
;

select min(`date`), max(`date`)
from layoffs_staging2
;

select industry, sum(total_laid_off)
from layoffs_staging2
group by industry
order by 2 desc
;

select *
from layoffs_staging2
;

select country, sum(total_laid_off)
from layoffs_staging2
group by country
order by 2 desc
;

select year(`date`) `year`, sum(total_laid_off)
from layoffs_staging2
group by `year`
order by 1 desc
;

select stage, sum(total_laid_off)
from layoffs_staging2
group by stage
order by 2 desc
;

select company, avg(percentage_laid_off)
from layoffs_staging2
group by company
order by 2 desc
;

select substring(`date`, 1, 7) `Month`, sum(total_laid_off)
from layoffs_staging2
where `date` is not null
group by `Month`
order by 1 asc
;


with Rolling_Total as
(
select substring(`date`, 1, 7) `Month`, sum(total_laid_off) total_off
from layoffs_staging2
where `date` is not null
group by `Month`
order by 1 asc
)
select `Month`, 
total_off, 
sum(total_off) over(order by `Month`) rolling_total
from Rolling_Total
;
