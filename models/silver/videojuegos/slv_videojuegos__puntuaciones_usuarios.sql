with usuarios as (
--Misma logica que las notas de la critica pero va aparte porque hay veces que no hay nota de critica pero si de usuario
    select
        game_name,
        platform,
        user_score,
        user_count
    from {{ ref('stg_raw_videojuegos__vgs_2016') }}
    where user_score is not null
    qualify row_number() over (
        partition by lower(game_name), lower(platform)
        order by user_count desc nulls last, user_score desc
    ) = 1

)

select
    {{ dbt_utils.generate_surrogate_key(['lower(game_name)', 'lower(platform)']) }} as edicion_id,
    user_score,
    user_count
from usuarios