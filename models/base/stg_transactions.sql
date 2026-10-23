{{ config(materialized='incremental', incremental_strategy='merge', unique_key='hash')  }}

select
t.hash,
t.block_number,
t.date,
t.from_address,
t.to_address,
t.value,
t.receipt_contract_address,
t.input

from {{ source('eth', 'transactions') }} t

{# 
left join {{ ref('stg_transactions_enriched') }} tt
on t.hash = tt.hash 
#}

{% if is_incremental() %}

where t.date >= (select max(date) from {{ this }})

{% endif %}