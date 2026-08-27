import repository.link_repository as link_repo
from schemas.link import LinkCreate, LinkUpdate
from schemas.topic import LinkMutation


async def apply_link_mutations(topic_id, links):
    for link in links:
        if link.mutation == LinkMutation.none:
            continue

        if link.mutation == LinkMutation.create:
            await link_repo.create(
                LinkCreate(topic_id=topic_id, link=link.link, type=link.type))
            continue

        if link.mutation == LinkMutation.update:
            await link_repo.update(
                link.id, LinkUpdate(link=link.link, type=link.type), topic_id)
            continue

        if link.mutation == LinkMutation.delete:
            await link_repo.delete(link.id, topic_id)
