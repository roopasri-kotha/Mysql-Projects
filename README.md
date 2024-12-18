Data Cleaning Project Summary
Objective:
Clean and standardize a "layoffs" dataset by removing duplicates, handling missing values, and ensuring consistency.

Steps Taken:

Removed Duplicates:
Used ROW_NUMBER() to identify and delete duplicate rows based on key columns (e.g., company, location, industry).

Standardized Data:

Converted dates to proper DATE format using STR_TO_DATE().
Cleaned text fields with TRIM() to remove extra spaces and standardized values (e.g., industry and country).
Handled Null and Blank Values:

Self-joined the table to fill missing values in the industry column.
Replaced empty strings in industry with NULL.
Removed Unnecessary Data:
Dropped the row_num column and deleted rows with null values in critical fields (total_laid_off, percentage_laid_off).

Outcome:
The dataset is now clean, consistent, and ready for analysis.
