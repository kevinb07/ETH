{{ config(group = 'fraud_risk',access = 'private') }}

SELECT
t.from_address,
c.bytecode,
count(c.bytecode) as bytecode_count

from {{ ref('stg_transactions_enriched') }} t

left join {{ ref('stg_contracts') }} c
on t.receipt_contract_address = c.address

where t.transaction_category = 'contract_creation'
and c.bytecode is NOT NULL

group by 1,2