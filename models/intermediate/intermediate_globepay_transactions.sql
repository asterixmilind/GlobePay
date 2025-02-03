WITH acceptance AS (
    SELECT 
        external_ref,
        status AS acceptance_status,
        source AS acceptance_source,
        transaction_date,
        transaction_state,
        cvv_provided,
        amount_usd,
        country AS acceptance_country,
        currency
    FROM stage_globepay_acceptance
),

chargeback AS (
    SELECT 
        external_ref,
        status AS chargeback_status,
        source AS chargeback_source,
        chargeback
    FROM stage_globepay_chargeback
)

SELECT
    a.external_ref,
    a.acceptance_status,
    a.acceptance_source,
    a.transaction_date,
    a.transaction_state,
    a.amount_usd,
    a.acceptance_country,
    a.currency,
    a.cvv_provided,
    c.chargeback_source,
    c.chargeback AS chargeback_processed
FROM acceptance a
LEFT JOIN chargeback c
ON a.external_ref = c.external_ref
