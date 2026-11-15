with base_sources as (
--primero se unen todas las fuentes
    select
        'VGS_2016' as source_code,
        game_name,
        platform,
        na_sales,
        eu_sales,
        jp_sales,
        other_sales,
        global_sales
    from {{ ref('stg_raw_videojuegos__vgs_2016') }}

    union all

    select
        'PS4' as source_code,
        game_name,
        platform,
        na_sales,
        eu_sales,
        jp_sales,
        other_sales,
        global_sales
    from {{ ref('stg_raw_videojuegos__ps4') }}

    union all

    select
        'XBOX' as source_code,
        game_name,
        platform,
        na_sales,
        eu_sales,
        jp_sales,
        other_sales,
        global_sales
    from {{ ref('stg_raw_videojuegos__xbox') }}

),

deduplicated_sources as (
--nos quedamos con el registro que más ventas tenga
    select *
    from base_sources
    qualify row_number() over (
        partition by lower(source_code), lower(game_name), lower(platform)
        order by global_sales desc nulls last
    ) = 1

),

unpivoted as (

    select source_code, game_name, platform, 'NA' as region_code, na_sales as sales_millions
    from deduplicated_sources
    union all
    select source_code, game_name, platform, 'EU' as region_code, eu_sales as sales_millions
    from deduplicated_sources
    union all
    select source_code, game_name, platform, 'JP' as region_code, jp_sales as sales_millions
    from deduplicated_sources
    union all
    select source_code, game_name, platform, 'OTHER' as region_code, other_sales as sales_millions
    from deduplicated_sources

)

select
    {{ dbt_utils.generate_surrogate_key([
        'lower(game_name)',
        'lower(platform)',
        'lower(region_code)',
        'lower(source_code)'
    ]) }} as sale_id,
    {{ dbt_utils.generate_surrogate_key(['lower(game_name)', 'lower(platform)']) }} as edicion_id,
    {{ dbt_utils.generate_surrogate_key(['lower(region_code)']) }} as region_id,
    source_code,
    coalesce(sales_millions, 0)::number(10, 2) as sales_millions
from unpivoted