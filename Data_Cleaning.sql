-- Removing Duplicates--

select *from layoffs;
select *from layoffs_staging;  -- copy values to new table for safety

select*, row_number() over(partition by company, location, industry, total_laid_off,percentage_laid_off,date, stage, country
,funds_raised_millions)as row_num from layoffs_staging;   -- create a unique row_num as we dont have id column

with cte as(
select*, row_number() over(partition by company, location, industry, total_laid_off,percentage_laid_off,`date`, stage, country
,funds_raised_millions)as row_num from layoffs_staging
) select *from cte
where row_num>1;    -- check for row_num >1 which displaces all the duplicates

/* As we cant do operations like update, delete in cte. we have to go for writing a subquery or
creating a temp table to remove duplicates. so below we created a temp table */


CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

insert into layoffs_staging2 select *, row_number() over(partition by company, location, industry, total_laid_off,percentage_laid_off,`date`, stage, country
,funds_raised_millions)as row_num from layoffs_staging;

select * from layoffs_staging2 where row_num>1;layoffs_staging2

SET SQL_SAFE_UPDATES = 0; 

/*upate, delete operations are very complicated so sql doesnot allow it.
 if we are confident on what we are doing we can enable it, use, disable after use*/

Delete from layoffs_staging2 where row_num>1;

SET SQL_SAFE_UPDATES = 1;

select * from layoffs_staging2;

-- Standardizing data : Finging issues in our data and fixing it --

select `date`, str_to_date(date, '%m/%d/%Y') from layoffs_staging2;

SET SQL_SAFE_UPDATES = 0; 
-- fixing issues in data
update layoffs_staging2 set company=trim(company);
update layoffs_staging2 set industry='Crypto' where industry like 'Crypto%';
update layoffs_staging2 set country='United States' where industry like 'United States%';
-- or
update layoffs_staging2 set country=Trim(Trailing '.' from country) where industry like 'United States%';
update layoffs_staging2 set date=str_to_date(date, '%m/%d/%Y');

Alter table layoffs_staging2 modify column `date` date;

-- Working with null and blank values--

select*from layoffs_staging2 where industry is null or industry='';
select*from layoffs_staging2 where company='Airbnb';                  -- self joined the table to populate null places with values 

Select * from layoffs_staging2 t1 
join layoffs_staging2 t2 
on t1.company=t2.company 
where (t1.industry is null or t1.industry ='') and (t2. industry is not null);

update layoffs_staging2 
set industry=null where industry='';

Update layoffs_staging2 t1 
join layoffs_staging2 t2
on t1.company=t2.company 
set t1.industry=t2.industry
where (t1.industry is null) and (t2. industry is not null);

select*from layoffs_staging2;

-- Remove any colums or rows--

alter table layoffs_staging2 
drop column row_num;


select * from layoffs_staging2 where
total_laid_off is null and percentage_laid_off is null;

delete from layoffs_staging2 where
total_laid_off is null and percentage_laid_off is null;






