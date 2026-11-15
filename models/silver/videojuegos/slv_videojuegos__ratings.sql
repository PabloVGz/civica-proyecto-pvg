with all_ratings as (

    select distinct
        coalesce(rating, 'Unrated') as rating_code
    from {{ ref('stg_raw_videojuegos__vgs_2016') }} --los otros no tienen ratings
    union
    select 'Unrated' as rating_code

)

select
    {{ dbt_utils.generate_surrogate_key(['lower(rating_code)']) }} as rating_id, --hash
    rating_code
from all_ratings