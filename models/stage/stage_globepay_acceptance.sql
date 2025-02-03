WITH raw_file AS (
    SELECT *
    FROM read_csv_auto('C:\Users\aster\Documents\DBT\dbt\globepay_project\raw\globepay_acceptance.csv', delim=';', header=True)
),

parsed_data AS (
    SELECT
        external_ref,
        status,
        source,
        CAST(date_time AS TIMESTAMP) AS transaction_date,
        state AS transaction_state,
        cvv_provided,
        CAST(amount AS DOUBLE) AS amount_local,
        country,
        currency,
        rates
    FROM raw_file
),

converted_amounts AS (
    SELECT *,
        CAST(JSON_EXTRACT(rates, '$."' || currency || '"') AS DOUBLE) AS exchange_rate,
        CASE 
            WHEN currency = 'USD' THEN amount_local
            ELSE amount_local / CAST(JSON_EXTRACT(rates, '$."' || currency || '"') AS DOUBLE)
        END AS amount_usd
    FROM parsed_data
)

SELECT * FROM converted_amounts
