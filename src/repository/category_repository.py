from repository.utils import fetch_many
import logging

log = logging.getLogger(__name__)


async def find_all():
    log.info("Fetching all categories")
    query = "SELECT * FROM category;"
    return await fetch_many(query)

async def tree(geo_level: str):
    log.info("Fetching category tree")
    query = """
        SELECT
            c.id,
            c.label,
            c.url_id,
            c.sort_weight,
            COALESCE(
                json_agg(
                    json_build_object(
                        'id', s.id,
                        'label', s.label,
                        'url_id', s.url_id,
                        'sort_weight', s.sort_weight,
                        'topics', s.topics
                    )
                    ORDER BY s.sort_weight
                ) FILTER (WHERE s.id IS NOT NULL),
                '[]'
            ) AS subcategories
        FROM category c
        LEFT JOIN LATERAL (
            SELECT
                sub.id,
                sub.label,
                sub.url_id,
                sub.sort_weight,
                COALESCE(
                    (
                        SELECT json_agg(
                            json_build_object(
                                'id', t.id,
                                'label', t.label,
                                'url_id', t.url_id,
                                'sort_weight', t.sort_weight,
                                'is_visible', t.is_visible
                            )
                            ORDER BY t.sort_weight
                        )
                        FROM topic t
                        WHERE t.subcategory_id = sub.id
                    ),
                    '[]'
                ) AS topics
            FROM subcategory sub
            WHERE sub.category_id = c.id
            AND sub.geo_level = %s
        ) s ON true
        GROUP BY c.id, c.label, c.url_id, c.sort_weight
        ORDER BY c.sort_weight;
        """
    return await fetch_many(query, (geo_level,))