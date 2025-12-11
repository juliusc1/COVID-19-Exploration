
# COVID-19 SQL Exploration & Tableau Dashboard

This project analyzes early COVID-19 case, death, and vaccination trends (Apr 2020–May 2021) using SQL Server Management Studio. It includes SQL scripts for exploratory analysis, analytical transformations, and data views used in a Tableau dashboard.

A Tableau Public dashboard is included for interactive exploration.

## Contents

### SQL Scripts
- **01_data_exploration.sql**  
  Basic descriptive queries for cases, deaths, and vaccinations.

- **02_covid_advanced_analysis.sql**  
  Analytical queries using window functions, CTEs, ROLLUP, and ranking.

- **03_tableau_views.sql**  
  Query outputs used as data sources for Tableau.

### Data
- `data/covid_deaths.csv`
- `data/covid_vaccinations.csv`

### Tableau
- `tableau/covid_dashboard.twbx`
- [View the interactive Tableau Public dashboard](https://public.tableau.com/views/Covid19Dashboard_17650778797350/Dashboard1?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)


## Techniques Used

This project demonstrates patterns common in analytical SQL work:

### Window functions
- Cumulative metrics with `SUM() OVER`
- Day-over-day comparisons with `LAG()`
- Moving averages with `ROWS BETWEEN`

### CTEs
Used to structure multi-step vaccination calculations.

### Temporary tables
Used for staged processing in `%PopulationVaccinated`.

### ROLLUP
Generates continent, country, and global aggregates in one query.

### Ranking functions
Identifies top countries by new daily cases using `RANK()`.

### NULL handling
`NULLIF()` avoids divide-by-zero; `CAST()` enforces numeric precision.

## Project Structure

```text
├── data/
│   ├── CovidDeaths.csv 
│   └── CovidVaccinations.csv
├── images/
    └── Covid19-Dashboard.png
├── queries/
│   ├── 01_data_exploration.sql
│   ├── 02_covid_advanced_analysis.sql
│   └── 03_tableau_views.sql
├── tableau/
│   ├── Covid19-Dashboard.twbx
├── gitignore.
└── README.md
```
## Dataset

The dataset originates from the public **Our World in Data (OWID)** COVID-19 data repository.  
The version used in this project was originally downloaded as an Excel file and later converted to CSV.

Unlike the current 2025 OWID dataset—which now contains only a few remaining columns—this dataset includes the **full historical records from the earlier years of the pandemic**, preserved by a third-party source who archived the more complete version.

It includes daily records by country with fields for:

- total and new cases  
- total and new deaths  
- vaccination counts  
- population and demographic fields  

No preprocessing is required; the SQL scripts operate on the raw CSVs.


## Running the Project

1. Import the CSV files into SQL Server (using SQL Server Management Studio) as tables:
   - `covid_deaths`
   - `covid_vaccinations`

2. Run the SQL scripts in order:
   - Start with `01_data_exploration.sql` for baseline metrics.
   - Use `02_covid_advanced_analysis.sql` for analytical outputs.
   - Use `03_tableau_views.sql` when loading the Tableau workbook.

3. Open `covid_dashboard.twbx` in Tableau Desktop or view it online using the link in `public_link.txt`.

****
