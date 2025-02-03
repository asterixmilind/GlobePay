WITH raw_file AS (
    SELECT *
    FROM read_csv_auto('C:\Users\aster\Documents\DBT\dbt\globepay_project\raw\globepay_chargeback.csv', header=True)
),

validated_data AS (
    SELECT
        external_ref,
        status,
        source,
        chargeback
    FROM raw_file
)

SELECT * FROM validated_data
