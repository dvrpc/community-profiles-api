import repository.category_repository as category_repo


async def get_categories():
    return await category_repo.find_all()


async def get_tree(geo_level: str):
    return await category_repo.tree(geo_level)
