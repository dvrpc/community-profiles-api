from fastapi import APIRouter, Depends
from schemas.topic import TopicCreate, TopicPropertiesUpdate
import repository.topic_repository as topic_repo
import services.topic as topic_service
from services.auth import require_admin


router = APIRouter()


@router.get("/topic/{id}")
async def get_topic(id):
    return await topic_repo.find_topic_properties(id)


@router.put("/topic/{id}")
async def update_topic(
    id: int,
    topic: TopicPropertiesUpdate,
    admin=Depends(require_admin),
):
    return await topic_service.update_topic_properties(id, topic)


@router.post('/topic')
async def create_topic(topic: TopicCreate, admin=Depends(require_admin)):
    res = await topic_service.create_topic(topic)
    return res


@router.delete('/topic/{id}')
async def delete_topic(id: int, admin=Depends(require_admin)):
    res = await topic_repo.delete(id)
    return res
