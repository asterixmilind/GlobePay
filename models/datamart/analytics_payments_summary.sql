SELECT
    DATE_TRUNC('month', transaction_date) AS transaction_month,
    acceptance_country AS country,
    cvv_provided,
    COUNT(*) AS total_transactions,
    SUM(amount_usd) AS total_payments_usd
    SUM(CASE WHEN transaction_state = 'ACCEPTED' THEN amount_usd ELSE 0 END) AS accepted_payments_usd,
    SUM(CASE WHEN transaction_state = 'DECLINED' THEN amount_usd ELSE 0 END) AS declined_payments_usd,
    COUNT(CASE WHEN transaction_state = 'ACCEPTED' THEN 1 ELSE NULL END) AS accepted_transactions,
    COUNT(CASE WHEN transaction_state = 'DECLINED' THEN 1 ELSE NULL END) AS declined_transactions,
    ROUND(COUNT(CASE WHEN transaction_state = 'ACCEPTED' THEN 1 ELSE NULL END) * 1.0 / COUNT(*), 2) AS acceptance_rate
FROM ref {{ ('intermediate_globepay_transactions') }}
GROUP BY 1, 2, 3
ORDER BY transaction_month, country
