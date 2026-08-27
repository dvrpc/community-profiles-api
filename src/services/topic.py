import logging

from schemas.topic import TopicCreate, TopicPropertiesUpdate, TopicUpdate
import repository.topic_repository as topic_repo
import repository.content_repository as content_repo
import repository.topic_content_repository as topic_content_repo
import services.revalidate as revalidation_service
from services.topic_product import sync_content_product
from services.topic_source import sync_topic_source
from services.link import apply_link_mutations


log = logging.getLogger(__name__)


def create_label(name: str):
    return name.replace('-', ' ').title()


async def create_topic(topic: TopicCreate):
    res = await topic_repo.create(topic.subcategory_id, topic.url_id, topic.label)
    topic_id = res[0]
    log.info(f"Created topic: {topic_id}")

    content_res = await content_repo.create("")
    await topic_content_repo.create(topic_id, content_res[0])
    log.info(f"Created empty content {content_res[0]} for topic: {topic_id}")

    revalidation_service.revalidate_all()
    return res



async def update_topic_properties(
    topic_id: int,
    topic: TopicPropertiesUpdate,
):
    topic_data = topic.model_dump(
        exclude_unset=True,
        exclude={"links", "source_ids", "product_ids"},
    )

    if topic_data:
        await topic_repo.update(topic_id, topic_data)

    if topic.source_ids is not None:
        await sync_topic_source(topic_id, topic.source_ids)

    if topic.product_ids is not None:
        await sync_content_product(topic_id, topic.product_ids)

    if topic.links is not None:
        await apply_link_mutations(topic_id, topic.links)

    revalidation_service.revalidate_all()
    return await topic_repo.find_one(topic_id)