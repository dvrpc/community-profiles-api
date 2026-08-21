from fastapi import APIRouter, Depends
from schemas.topic import TopicCreate, TopicUpdate
import repository.topic_repository as topic_repo
import services.topic as topic_service
from services.auth import require_admin


router = APIRouter()


@router.put('/topic/{id}')
async def update_topic(id: int, topic: TopicUpdate, admin=Depends(require_admin)):
    res = await topic_service.update_topic(id, topic)
    return res


@router.post('/topic')
async def create_topic(topic: TopicCreate, admin=Depends(require_admin)):
    res = await topic_service.create_topic(topic)
    return res


@router.delete('/topic/{id}')
async def delete_topic(id: int, admin=Depends(require_admin)):
    res = await topic_repo.delete(id)
    return res
