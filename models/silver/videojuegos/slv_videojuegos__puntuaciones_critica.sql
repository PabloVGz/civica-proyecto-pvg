with critica as (
--Solo hay criticas para el VGS, PS4 y Xbox One no tienen.  Se filtra igualmente las que tienen critica y si hay duplicados se guarda el que tiene mas criticas
    select
        game_name,
        platform,
        critic_score,
        critic_count
    from {{ ref('stg_raw_videojuegos__vgs_2016') }}
    where critic_score is not null
    qualify row_number() over (
        partition by lower(game_name), lower(platform)
        order by critic_count desc nulls last, critic_score desc
    ) = 1

)

select
    {{ dbt_utils.generate_surrogate_key(['lower(game_name)', 'lower(platform)']) }} as edicion_id,
    critic_score,
    critic_count
from critica