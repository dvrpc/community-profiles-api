from fastapi import APIRouter
import services.category as category_service


router = APIRouter()


@router.get('/category')
async def get_categories():
    res = await category_service.get_categories()
    return res


@router.get('/category/tree')
async def get_tree(geo_level: str):
    tree = await category_service.get_tree(geo_level)
    return tree
