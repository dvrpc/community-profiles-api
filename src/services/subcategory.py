import logging

from schemas.subcategory import SubcategoryCreate, SubcategoryUpdate
import repository.subcategory_repository as subcategory_repo
import services.revalidate as revalidation_service


log = logging.getLogger(__name__)


def create_label(name: str):
    return name.replace('-', ' ').title()


async def create_subcategory(subcategory: SubcategoryCreate):
    res = await subcategory_repo.create(
        subcategory.category_id,
        subcategory.geo_level,
        subcategory.url_id,
        subcategory.label,
    )
    subcategory_id = res[0]
    log.info(f"Created subcategory: {subcategory_id}")
    revalidation_service.revalidate_all()
    return res


async def update_subcategory(id: int, subcategory: SubcategoryUpdate):
    subcategory_data = subcategory.model_dump(exclude_unset=True)
    values = []

    if 'url_id' in subcategory_data:
        label = create_label(subcategory_data['url_id'])
        values.append(f"url_id = '{subcategory_data['url_id']}'")
        values.append(f"label = '{label}'")
    if 'label' in subcategory_data:
        values.append(f"label = '{subcategory_data['label']}'")
    if 'sort_weight' in subcategory_data:
        values.append(f"sort_weight = {subcategory_data['sort_weight']}")

    value_str = ','.join(values)
    res = await subcategory_repo.update(id, value_str)
    revalidation_service.revalidate_all()
    return res
