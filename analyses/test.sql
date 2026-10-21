-- yml codes for sources.yml
{# {{ codegen.generate_source(schema_name='eth_schema', database_name='eth', generate_columns=true, include_data_types=false) }} #}

-- yml codes for schema.yml
{# {{ codegen.generate_model_yaml(['stg_transactions','stg_transactions_enriched','stablecoin_per_day'] ) }} #}

{#
-- select
{{ dbt_utils.star(from=ref('stg_transactions_enriched'), except=["newfield"], quote_identifiers=False, prefix="stg_") }}
-- from ref('stg_transactions_enriched') 
#}

{{ audit_helper.compare_relations( source('eth','contracts'), source('eth','contracts_clone') ) }}