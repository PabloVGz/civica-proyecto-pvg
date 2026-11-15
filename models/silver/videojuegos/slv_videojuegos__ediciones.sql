with unioned as (
--se unen y se les asigna las prioridades, VGS tiene 1, PS4 2 y Xbox One 3
    select
        game_name,
        platform,
        publisher,
        release_year,
        1 as source_priority
    from {{ ref('stg_raw_videojuegos__vgs_2016') }}

    union all

    select
        game_name,
        platform,
        publisher,
        release_year,
        2 as source_priority
    from {{ ref('stg_raw_videojuegos__ps4') }}

    union all

    select
        game_name,
        platform,
        publisher,
        release_year,
        3 as source_priority
    from {{ ref('stg_raw_videojuegos__xbox') }}

),

deduplicated as (
--Los juegos de Play4 o de Xbox One de antes de 2016 estarán repetidos así que se agrupa por título y plataforma y se queda con una fila, priorizando
--las filas que sí tienen año de lanzamiento y en caso de que sea igual, se prioriza vgs
    select
        game_name,
        platform,
        coalesce(publisher, 'Unknown') as publisher_name,
        release_year
    from unioned
    qualify row_number() over (
        partition by lower(game_name), lower(platform)
        order by
            case when release_year is not null then 0 else 1 end asc,
            source_priority asc
    ) = 1

)

select
    {{ dbt_utils.generate_surrogate_key(['lower(game_name)', 'lower(platform)']) }} as edicion_id,
    {{ dbt_utils.generate_surrogate_key(['lower(game_name)']) }} as game_id,
    {{ dbt_utils.generate_surrogate_key(['lower(platform)']) }} as platform_id,
    {{ dbt_utils.generate_surrogate_key(['lower(publisher_name)']) }} as publisher_id,
    release_year
from deduplicated